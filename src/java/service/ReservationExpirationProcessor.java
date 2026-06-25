package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import model.Book;
import model.BookCopy;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ReservationExpirationProcessor - Tiến trình ngầm quét và xử lý các đơn đặt trước quá hạn nhận sách.
 */
public class ReservationExpirationProcessor implements Runnable {
    private static final Logger LOGGER = Logger.getLogger(ReservationExpirationProcessor.class.getName());

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();

    @Override
    public void run() {
        LOGGER.log(Level.INFO, "[BACKGROUND JOB] Bắt đầu quét và xử lý các Reservation quá hạn nhận sách...");
        try {
            ProcessResult result = processExpiration();
            LOGGER.log(Level.INFO, "[BACKGROUND JOB] Hoàn thành. Đã hủy {0} đơn quá hạn, đôn {1} độc giả xếp hàng tiếp theo lên.",
                    new Object[]{result.cancelledCount, result.promotedCount});
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[BACKGROUND JOB] Lỗi nghiêm trọng xảy ra trong quá trình xử lý ReservationExpirationProcessor", e);
        }
    }

    /**
     * Thực hiện luồng xử lý quét quá hạn.
     */
    public ProcessResult processExpiration() {
        ProcessResult result = new ProcessResult();

        // 1. Quét tìm danh sách các Reservation quá hạn nhận sách (không khóa dòng)
        List<Reservation> expiredList;
        try (Connection conn = DatabaseConnection.getConnection()) {
            expiredList = reservationDAO.findExpiredReservations(conn);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Không thể quét danh sách Reservation quá hạn do lỗi CSDL", e);
            return result;
        }

        if (expiredList.isEmpty()) {
            LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Không tìm thấy đơn đặt trước nào quá hạn nhận.");
            return result;
        }

        LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Tìm thấy {0} đơn quá hạn cần xử lý.", expiredList.size());

        // Lấy cấu hình holdDays trước để tối ưu hóa
        int holdDays = new SystemConfigDAO().getIntValue("RESERVATION_HOLD_DAYS", 3);

        // 2. Vòng lặp xử lý cô lập cho từng đơn hàng
        for (Reservation res : expiredList) {
            Connection conn = null;
            boolean success = false;
            try {
                conn = DatabaseConnection.getConnection();
                conn.setAutoCommit(false); // Bắt đầu Transaction độc lập

                // Bước 2: Khóa dòng Reservation cụ thể bằng FOR UPDATE để chống tranh chấp
                Reservation lockedRes = reservationDAO.findReservationByIdForUpdate(conn, res.getReservationId());
                if (lockedRes == null || !"readypickup".equals(lockedRes.getStatus())) {
                    // Đơn hàng đã bị thay đổi trạng thái trước đó (ví dụ: đã checkout hoặc bị hủy thủ công)
                    conn.rollback();
                    continue;
                }

                // Bước 3: Hủy đơn đặt trước quá hạn
                reservationDAO.updateStatusToCancelled(conn, lockedRes.getReservationId());
                result.cancelledCount++;

                // Bước 4: Xác định bản sao sách vật lý cần giải phóng
                Integer copyId = lockedRes.getBookCopyId();
                int bookId = lockedRes.getBookId();

                if (copyId != null) {
                    // Bước 5: Kiểm tra xem có người dùng nào khác đang xếp hàng cho tựa sách này không
                    Reservation nextRes = reservationDAO.findNextInQueue(conn, bookId);

                    if (nextRes != null) {
                        // Bước 6a: Phân bổ cho người chờ tiếp theo
                        // Cập nhật đơn người tiếp theo lên readypickup, gán bản sao sách hiện tại và thiết lập hạn nhận sách mới
                        reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), copyId, holdDays);

                        // Giữ nguyên trạng thái BookCopy là 'reserved'
                        bookCopyDAO.updateStatusToReserved(conn, copyId);

                        // Tịnh tiến vị trí hàng chờ của những người xếp hàng phía sau (queuePosition - 1)
                        reservationDAO.decrementQueuePositions(conn, bookId);

                        // Ghi Audit Log cho hành động hủy và đôn hàng chờ (hệ thống tự động thực hiện -> userId = NULL/0)
                        userDAO.insertAuditLog(conn, 0, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=" + copyId,
                                "status=cancelled, promoted reservationId=" + nextRes.getReservationId() + " to ready");

                        result.promotedCount++;
                        success = true;
                        conn.commit(); // Hoàn thành Transaction

                        // Gửi email thông báo bất đồng bộ cho độc giả vừa được đôn lên
                        sendNotificationEmailAsync(nextRes, bookId);

                    } else {
                        // Bước 6b: Trả sách về trạng thái sẵn sàng trong kho vì hàng chờ trống
                        bookCopyDAO.updateStatusToAvailable(conn, copyId);
                        bookDAO.updateQuantities(conn, bookId, 0, 1); // Tăng availableQuantity lên 1

                        // Ghi Audit Log cho hành động hủy và trả sách về kho
                        userDAO.insertAuditLog(conn, 0, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=" + copyId,
                                "status=cancelled, bookCopyId=" + copyId + " returned to available stock");

                        success = true;
                        conn.commit(); // Hoàn thành Transaction
                    }
                } else {
                    // Đơn hàng quá hạn không có bản sao (trường hợp hiếm gặp) -> Chỉ hủy
                    userDAO.insertAuditLog(conn, 0, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                            "status=readypickup, bookCopyId=null", "status=cancelled");
                    success = true;
                    conn.commit();
                }

            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi SQL khi xử lý đơn đặt trước quá hạn ID=" + res.getReservationId() + ", tiến hành rollback đơn này.", e);
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        LOGGER.log(Level.SEVERE, "Rollback thất bại", ex);
                    }
                }
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Không thể đóng Connection", e);
                    }
                }
            }
        }

        return result;
    }

    /**
     * Gửi email thông báo bất đồng bộ bằng EmailService.
     */
    private void sendNotificationEmailAsync(Reservation nextRes, int bookId) {
        // Chạy ngầm bất đồng bộ bằng Thread để tránh block luồng chính
        new Thread(() -> {
            try {
                User nextUser = userDAO.findByUserId(nextRes.getUserId());
                if (nextUser != null && nextUser.getEmail() != null) {
                    MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                    String fullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();

                    String bookTitle = "Sách đã đặt";
                    try (Connection conn = DatabaseConnection.getConnection()) {
                        Book b = bookDAO.findById(conn, bookId);
                        if (b != null) {
                            bookTitle = b.getTitle();
                        }
                    }

                    String subject = "[LMS] Sách đã sẵn sàng cho bạn nhận tại quầy";
                    String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                            + "<h2>Xin chào " + fullName + ",</h2>"
                            + "<p>Cuốn sách <strong>\"" + bookTitle + "\"</strong> bạn đang xếp hàng chờ đặt trước đã sẵn sàng để nhận.</p>"
                            + "<p>Vui lòng đến quầy thư viện để nhận sách trong thời hạn quy định.</p>"
                            + "<p>Trân trọng,<br/>Ban quản lý Thư viện LMS</p>"
                            + "</div>";

                    EmailService.getInstance().sendAsyncHtmlEmail(nextUser.getEmail(), subject, htmlContent);
                    LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã gửi thông báo email cho người dùng: " + nextUser.getEmail());
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi gửi email thông báo đôn hàng chờ cho userId=" + nextRes.getUserId(), e);
            }
        }).start();
    }

    /**
     * DTO lưu kết quả xử lý
     */
    public static class ProcessResult {
        public int cancelledCount = 0;
        public int promotedCount = 0;
    }
}
