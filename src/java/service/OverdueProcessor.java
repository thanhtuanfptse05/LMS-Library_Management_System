package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.DocumentTempDAO;
import dao.FineDAO;
import dao.MemberProfileDAO;
import dao.PaymentDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import model.Book;
import model.BorrowRecord;
import model.DocumentTemp;
import model.MemberProfile;
import model.User;
import util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * OverdueProcessor — Dịch vụ quét và xử lý các bản ghi mượn quá hạn (Lazy Load / Scheduled Job).
 *
 * <p>Quy trình quét gồm 2 Giai đoạn chính:</p>
 * <ul>
 *   <li><b>Giai đoạn 1:</b> Quét các đơn mượn hết hạn vừa mới chuyển sang trạng thái quá hạn
 *       (chuyển status='overdue', tạo khoản phạt Fine mới, tạo Payment pending, khóa tài khoản và gửi email thông báo).</li>
 *   <li><b>Giai đoạn 2:</b> Cập nhật lũy tiến tiền phạt cho các đơn mượn ĐÃ quá hạn từ trước mà độc giả chưa trả sách
 *       (mỗi ngày trôi qua tiền phạt tự cộng thêm FINE_RATE_PER_DAY).</li>
 * </ul>
 */
public class OverdueProcessor {

    private static final Logger LOGGER = Logger.getLogger(OverdueProcessor.class.getName());

    // Các đối tượng DAO tương tác với Cơ sở dữ liệu
    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();
    private final UserDAO userDAO = new UserDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();
    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();

    /**
     * Thực hiện quét toàn bộ hệ thống để phát hiện và xử lý các khoản trễ hạn.
     * Hàm này được gọi khi hệ thống khởi động hoặc khi độc giả/thủ thư thực hiện các tác vụ lưu thông.
     *
     * @return OverdueResult Lưu thông số thống kê số bản ghi đã xử lý, số tài khoản bị khóa và số email đã gửi.
     */
    public OverdueResult processOverdue() {
        LOGGER.info("[OverdueProcessor] Bắt đầu quét quá hạn trả sách...");
        int processedRecords = 0; // Số bản ghi mới chuyển sang overdue
        int lockedUsers = 0;      // Số tài khoản người dùng mới bị khóa thêm
        int emailsSent = 0;       // Số email thông báo đã đưa vào hàng đợi

        // ================================================================
        // GIAI ĐOẠN 1: Quét phát hiện đơn mượn MỚI chuyển sang quá hạn
        // ================================================================
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Lấy các đơn mượn có endDate < NOW() nhưng status vẫn là 'borrowed'
            List<BorrowRecord> overdueRecords = borrowRecordDAO.findOverdueRecords(conn);
            LOGGER.log(Level.INFO, "[OverdueProcessor] Tìm thấy {0} lượt mượn quá hạn cần xử lý.", overdueRecords.size());

            for (BorrowRecord record : overdueRecords) {
                try {
                    // Kiểm tra trước xem user đã bị khóa do nợ tiền phạt chưa
                    boolean userWasLocked = userLockReasonDAO.hasReason(conn, record.getUserId(), "unpaid");
                    
                    // Xử lý đơn quá hạn trong transaction riêng
                    boolean success = processSingleRecord(record);
                    if (success) {
                        processedRecords++;
                        if (!userWasLocked) {
                            lockedUsers++; // Đánh dấu nếu user này mới bị khóa thêm ở lượt này
                        }
                        emailsSent++;
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi xử lý đơn quá hạn ID=" + record.getBorrowRecordId(), e);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OverdueProcessor] Lỗi DB khi lấy danh sách quá hạn", e);
        }

        // ================================================================
        // GIAI ĐOẠN 2: Cập nhật lũy tiến tiền phạt cho các đơn ĐÃ overdue từ trước
        // ================================================================
        int updatedFines = updateExistingOverdueFines();

        LOGGER.log(Level.INFO, "[OverdueProcessor] Hoàn tất quét. Giai đoạn 1: {0} bản ghi mới, khóa thêm: {1} độc giả, gửi: {2} email. Giai đoạn 2: cập nhật lũy tiến {3} khoản phạt.",
                new Object[]{processedRecords, lockedUsers, emailsSent, updatedFines});
        return new OverdueResult(processedRecords, lockedUsers, emailsSent);
    }

    /**
     * Xử lý quá hạn cho một bản ghi mượn cụ thể.
     * Mỗi bản ghi được thực hiện trong một Database Transaction (Atomic) độc lập.
     *
     * @param record Bản ghi mượn sách bị quá hạn
     * @return true nếu xử lý thành công, false nếu xảy ra lỗi và rollback
     */
    private boolean processSingleRecord(BorrowRecord record) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // Bước 1: Đọc đơn giá phạt trễ hạn mỗi ngày từ cấu hình hệ thống (mặc định 5,000 VNĐ/ngày)
            BigDecimal fineRate = BigDecimal.valueOf(5000);
            try {
                String rateVal = new SystemConfigDAO().getValue(conn, "FINE_RATE_PER_DAY", "5000");
                fineRate = new BigDecimal(rateVal.trim());
            } catch (Exception ex) {
                LOGGER.warning("Không đọc được FINE_RATE_PER_DAY, sử dụng mặc định 5000 VND.");
            }

            // Bước 2: Tính số ngày trễ hạn thực tế (tối thiểu tính là 1 ngày)
            long diffInMillis = System.currentTimeMillis() - record.getEndDate().getTime();
            long overdueDays = TimeUnit.MILLISECONDS.toDays(diffInMillis);
            if (overdueDays < 1) {
                overdueDays = 1;
            }

            // Tổng tiền phạt = Số ngày trễ * Đơn giá phạt/ngày
            BigDecimal totalFine = fineRate.multiply(BigDecimal.valueOf(overdueDays));

            // Bước 3: Cập nhật trạng thái phiếu mượn sang 'overdue' (Quá hạn)
            String sqlUpdateBorrow = "UPDATE BorrowRecord SET status = 'overdue' WHERE borrowRecordId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateBorrow)) {
                ps.setInt(1, record.getBorrowRecordId());
                ps.executeUpdate();
            }

            // Bước 4: Tạo bản ghi phạt mới trong bảng Fine với trạng thái 'unpaid'
            int fineId = fineDAO.insertOverdueFine(conn, record.getBorrowRecordId(), record.getUserId(), totalFine, "Trễ hạn " + overdueDays + " ngày");

            // Bước 4.1: Tạo trước bản ghi Payment ở trạng thái 'pending' để sẵn sàng cho độc giả quét QR thanh toán
            new PaymentDAO().insertPayment(conn, fineId, totalFine, "pending");

            // Bước 5: Thêm lý do khóa 'unpaid' và chuyển trạng thái tài khoản User sang 'locked' (Khóa)
            if (!userLockReasonDAO.hasReason(conn, record.getUserId(), "unpaid")) {
                userLockReasonDAO.insertLockReason(conn, record.getUserId(), "unpaid");
                userDAO.updateStatusToLocked(conn, record.getUserId());
            }

            // Bước 6: Ghi Nhật ký hệ thống (Audit Log) ghi nhận hành động khóa tự động do nợ phạt
            auditLogDAO.insert(conn, null, "LOCK_USER", "User", record.getUserId(),
                    "status=active", "status=locked, reason=unpaid, overdueRecordId=" + record.getBorrowRecordId());

            conn.commit(); // Hoàn tất Transaction thành công

            // Bước 7: Kích hoạt gửi email thông báo trễ hạn bất đồng bộ (ngoài Transaction)
            triggerOverdueEmailAsync(conn, record, overdueDays, fineRate, totalFine);

            return true;
        } catch (Exception e) {
            // Rollback nếu xảy ra lỗi trong quá trình xử lý bản ghi này
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed for record ID=" + record.getBorrowRecordId(), ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Lỗi giao dịch xử lý quá hạn cho borrowRecordId=" + record.getBorrowRecordId(), e);
            return false;
        } finally {
            // Đảm bảo luôn đóng Connection
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Không thể đóng Connection cho record ID=" + record.getBorrowRecordId(), ex);
                }
            }
        }
    }

    /**
     * Chuẩn bị dữ liệu và kích hoạt gửi email thông báo quá hạn trả sách bất đồng bộ qua EmailService.
     *
     * @param conn        Connection DB để tra cứu tên sách, tên độc giả
     * @param record      Bản ghi mượn quá hạn
     * @param overdueDays Số ngày trễ hạn
     * @param fineRate    Mức phạt mỗi ngày
     * @param totalFine   Tổng tiền phạt
     */
    private void triggerOverdueEmailAsync(Connection conn, BorrowRecord record, long overdueDays, BigDecimal fineRate, BigDecimal totalFine) {
        try {
            // Lấy địa chỉ email của độc giả
            User user = userDAO.findByUserId(record.getUserId());
            if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                return;
            }

            // Lấy họ tên hiển thị của độc giả
            MemberProfile profile = memberProfileDAO.findByUserId(record.getUserId());
            String userName = (profile != null) ? profile.getFullName() : user.getEmail();

            // Lấy tên cuốn sách bị mượn trễ
            Book book = bookDAO.findById(conn, record.getBookId());
            String bookTitle = (book != null) ? book.getTitle() : "Sách mượn thư viện";

            // Định dạng ngày tháng và tiền tệ chuẩn Việt Nam
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            DecimalFormat df = new DecimalFormat("#,###");

            String formattedDueDate = sdf.format(record.getEndDate());
            String formattedFineRate = df.format(fineRate);
            String formattedTotalFine = df.format(totalFine);

            // Đóng gói các biến thay thế (placeholders) cho Template Email OVERDUE_NOTICE
            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("bookTitle", bookTitle);
            placeholders.put("dueDate", formattedDueDate);
            placeholders.put("overdueDays", String.valueOf(overdueDays));
            placeholders.put("finePerDay", formattedFineRate);
            placeholders.put("totalFine", formattedTotalFine);

            // Đưa công việc gửi email vào hàng đợi bất đồng bộ (Non-blocking)
            model.EmailJob job = new model.EmailJob("OVERDUE_NOTICE", user.getEmail(), userName, placeholders);
            EmailService.enqueue(job);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi email quá hạn cho userId=" + record.getUserId(), e);
        }
    }

    // =========================================================================
    // GIAI ĐOẠN 2: CẬP NHẬT LŨY TIẾN TIỀN PHẠT CHO CÁC ĐƠN ĐÃ OVERDUE
    // =========================================================================

    /**
     * Quét các phiếu mượn đang quá hạn chưa trả (status='overdue') và cập nhật
     * lũy tiến tiền phạt theo số ngày trễ thực tế.
     *
     * <p>Logic: Với mỗi đơn mượn đang overdue, tính lại tổng tiền phạt =
     * {@code FINE_RATE_PER_DAY × số ngày trễ hiện tại}. Nếu số tiền mới lớn hơn
     * số tiền đang lưu trong bảng {@code Fine}, thực hiện UPDATE cả bảng
     * {@code Fine} và {@code Payment} tương ứng.</p>
     *
     * <p>Thiết kế tối ưu: Trong cùng 1 ngày, dù load trang bao nhiêu lần,
     * số tiền phạt tính ra vẫn giống nhau → điều kiện {@code newAmount > currentAmount}
     * sẽ FALSE → KHÔNG thực hiện UPDATE vào DB (tránh ghi thừa).</p>
     *
     * @return Số lượng khoản phạt đã được cập nhật lũy tiến
     */
    private int updateExistingOverdueFines() {
        int updatedCount = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Đọc mức phạt hàng ngày từ config
            BigDecimal fineRate = BigDecimal.valueOf(5000);
            try {
                String rateVal = new dao.SystemConfigDAO().getValue(conn, "FINE_RATE_PER_DAY", "5000");
                fineRate = new BigDecimal(rateVal.trim());
            } catch (Exception ex) {
                LOGGER.warning("[Giai đoạn 2] Không đọc được FINE_RATE_PER_DAY, sử dụng mặc định 5000 VND.");
            }

            // Lấy danh sách các đơn mượn đang overdue mà độc giả CHƯA TRẢ SÁCH (returnedAt IS NULL)
            List<BorrowRecord> overdueLoans = borrowRecordDAO.findActiveOverdueLoans(conn);

            for (BorrowRecord record : overdueLoans) {
                try {
                    // Tính số ngày trễ thực tế đến thời điểm hiện tại
                    long diffInMillis = System.currentTimeMillis() - record.getEndDate().getTime();
                    long overdueDays = TimeUnit.MILLISECONDS.toDays(diffInMillis);
                    if (overdueDays < 1) {
                        overdueDays = 1;
                    }

                    BigDecimal newTotalFine = fineRate.multiply(BigDecimal.valueOf(overdueDays));

                    // Tìm khoản phạt unpaid hiện tại liên kết với phiếu mượn này
                    model.Fine existingFine = fineDAO.findUnpaidFineByBorrowRecordId(conn, record.getBorrowRecordId());
                    if (existingFine == null) {
                        continue; // Không có Fine unpaid → bỏ qua (có thể khoản phạt này đã được thanh toán)
                    }

                    // TỐI ƯU: Chỉ UPDATE cơ sở dữ liệu khi số tiền phạt MỚI lớn hơn số tiền phạt ĐÃ LƯU
                    // Giúp tránh việc gọi câu lệnh UPDATE liên tục nhiều lần trong cùng một ngày
                    if (newTotalFine.compareTo(existingFine.getAmount()) > 0) {
                        conn.setAutoCommit(false); // Bắt đầu Transaction cập nhật lũy tiến

                        String newReason = "Trễ hạn " + overdueDays + " ngày";
                        fineDAO.updateFineAmount(conn, existingFine.getFineId(), newTotalFine, newReason);
                        new PaymentDAO().updatePendingPaymentAmount(conn, existingFine.getFineId(), newTotalFine);

                        conn.commit();
                        conn.setAutoCommit(true);
                        updatedCount++;
                    }
                } catch (Exception e) {
                    try { conn.rollback(); conn.setAutoCommit(true); } catch (SQLException ex) { /* ignore */ }
                    LOGGER.log(Level.WARNING,
                            "[Giai đoạn 2] Lỗi cập nhật lũy tiến cho borrowRecordId=" + record.getBorrowRecordId(), e);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Giai đoạn 2] Lỗi DB khi quét cập nhật lũy tiến tiền phạt", e);
        }

        return updatedCount;
    }

    /**
     * Lớp DTO lưu trữ kết quả thống kê tiến trình quét.
     */
    public static class OverdueResult {
        public final int processedRecords; // Số bản ghi trễ hạn mới được tạo
        public final int lockedUsers;      // Số người dùng mới bị khóa tài khoản
        public final int emailsSent;       // Số email thông báo đã đưa vào hàng đợi

        public OverdueResult(int processedRecords, int lockedUsers, int emailsSent) {
            this.processedRecords = processedRecords;
            this.lockedUsers = lockedUsers;
            this.emailsSent = emailsSent;
        }
    }
}

