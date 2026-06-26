package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.DocumentTempDAO;
import dao.FineDAO;
import dao.MemberProfileDAO;
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
 * OverdueProcessor — Tiến trình ngầm quét và xử lý các bản ghi mượn quá hạn.
 */
public class OverdueProcessor implements Runnable {

    private static final Logger LOGGER = Logger.getLogger(OverdueProcessor.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();
    private final UserDAO userDAO = new UserDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();
    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();

    @Override
    public void run() {
        processOverdue();
    }

    /**
     * Thực hiện quét toàn bộ hệ thống để phát hiện các khoản quá hạn.
     *
     * @return Kết quả thống kê tiến trình quét
     */
    public OverdueResult processOverdue() {
        LOGGER.info("[OverdueProcessor] Bắt đầu quét quá hạn trả sách...");
        int processedRecords = 0;
        int lockedUsers = 0;
        int emailsSent = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            List<BorrowRecord> overdueRecords = borrowRecordDAO.findOverdueRecords(conn);
            LOGGER.log(Level.INFO, "[OverdueProcessor] Tìm thấy {0} lượt mượn quá hạn cần xử lý.", overdueRecords.size());

            for (BorrowRecord record : overdueRecords) {
                try {
                    boolean userWasLocked = userLockReasonDAO.hasReason(conn, record.getUserId(), "unpaid");
                    boolean success = processSingleRecord(record);
                    if (success) {
                        processedRecords++;
                        if (!userWasLocked) {
                            lockedUsers++;
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

        LOGGER.log(Level.INFO, "[OverdueProcessor] Hoàn tất quét. Đã xử lý: {0} bản ghi, khóa thêm: {1} độc giả, gửi: {2} email.",
                new Object[]{processedRecords, lockedUsers, emailsSent});
        return new OverdueResult(processedRecords, lockedUsers, emailsSent);
    }

    /**
     * Xử lý quá hạn cho một bản ghi mượn trong một Transaction riêng biệt.
     */
    private boolean processSingleRecord(BorrowRecord record) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Đọc mức phạt hàng ngày từ config
            BigDecimal fineRate = BigDecimal.valueOf(5000);
            try {
                String rateVal = new SystemConfigDAO().getValue(conn, "FINE_RATE_PER_DAY", "5000");
                fineRate = new BigDecimal(rateVal.trim());
            } catch (Exception ex) {
                LOGGER.warning("Không đọc được FINE_RATE_PER_DAY, sử dụng mặc định 5000 VND.");
            }

            // 2. Tính số ngày trễ hạn (ít nhất 1 ngày)
            long diffInMillis = System.currentTimeMillis() - record.getEndDate().getTime();
            long overdueDays = TimeUnit.MILLISECONDS.toDays(diffInMillis);
            if (overdueDays < 1) {
                overdueDays = 1;
            }

            BigDecimal totalFine = fineRate.multiply(BigDecimal.valueOf(overdueDays));

            // 3. Cập nhật BorrowRecord.status = 'overdue'
            String sqlUpdateBorrow = "UPDATE BorrowRecord SET status = 'overdue' WHERE borrowRecordId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateBorrow)) {
                ps.setInt(1, record.getBorrowRecordId());
                ps.executeUpdate();
            }

            // 4. Tạo bản ghi Fine trễ hạn
            fineDAO.insertOverdueFine(conn, record.getBorrowRecordId(), record.getUserId(), totalFine, "Trễ hạn " + overdueDays + " ngày");

            // 5. Thêm lý do khóa và khóa tài khoản người dùng nếu chưa bị khóa vì nợ phạt
            if (!userLockReasonDAO.hasReason(conn, record.getUserId(), "unpaid")) {
                userLockReasonDAO.insertLockReason(conn, record.getUserId(), "unpaid");
                userDAO.updateStatusToLocked(conn, record.getUserId());
            }

            // 6. Ghi Audit Log hành động khóa tự động bởi hệ thống
            auditLogDAO.insert(conn, null, "LOCK_USER", "User", record.getUserId(),
                    "status=active", "status=locked, reason=unpaid, overdueRecordId=" + record.getBorrowRecordId());

            conn.commit();

            // 7. Gửi email thông báo bất đồng bộ sau khi commit thành công
            triggerOverdueEmailAsync(conn, record, overdueDays, fineRate, totalFine);

            return true;
        } catch (Exception e) {
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
     * Gửi email thông báo quá hạn trả sách bất đồng bộ.
     */
    private void triggerOverdueEmailAsync(Connection conn, BorrowRecord record, long overdueDays, BigDecimal fineRate, BigDecimal totalFine) {
        try {
            // Lấy email độc giả
            User user = userDAO.findByUserId(record.getUserId());
            if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                return;
            }

            // Lấy tên hiển thị của độc giả
            MemberProfile profile = memberProfileDAO.findByUserId(record.getUserId());
            String userName = (profile != null) ? profile.getFullName() : user.getEmail();

            // Lấy tiêu đề sách
            Book book = bookDAO.findById(conn, record.getBookId());
            String bookTitle = (book != null) ? book.getTitle() : "Sách mượn thư viện";

            // Định dạng dữ liệu hiển thị
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            DecimalFormat df = new DecimalFormat("#,###");

            String formattedDueDate = sdf.format(record.getEndDate());
            String formattedFineRate = df.format(fineRate);
            String formattedTotalFine = df.format(totalFine);

            // Gửi email bất đồng bộ qua EmailService sử dụng Queue ngầm
            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("bookTitle", bookTitle);
            placeholders.put("dueDate", formattedDueDate);
            placeholders.put("overdueDays", String.valueOf(overdueDays));
            placeholders.put("finePerDay", formattedFineRate);
            placeholders.put("totalFine", formattedTotalFine);

            model.EmailJob job = new model.EmailJob("OVERDUE_NOTICE", user.getEmail(), userName, placeholders);
            EmailService.enqueue(job);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi email quá hạn cho userId=" + record.getUserId(), e);
        }
    }

    /**
     * Lớp DTO lưu trữ kết quả thống kê tiến trình quét.
     */
    public static class OverdueResult {
        public final int processedRecords;
        public final int lockedUsers;
        public final int emailsSent;

        public OverdueResult(int processedRecords, int lockedUsers, int emailsSent) {
            this.processedRecords = processedRecords;
            this.lockedUsers = lockedUsers;
            this.emailsSent = emailsSent;
        }
    }
}
