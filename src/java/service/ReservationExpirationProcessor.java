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
import dao.UserLockReasonDAO;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ReservationExpirationProcessor — Xử lý các đơn đặt trước quá hạn nhận sách (Lazy Load).
 */
public class ReservationExpirationProcessor {
    private static final Logger LOGGER = Logger.getLogger(ReservationExpirationProcessor.class.getName());

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();
    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();

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
            LOGGER.log(Level.SEVERE, "[ReservationExpirationProcessor] Không thể quét danh sách Reservation quá hạn do lỗi CSDL", e);
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
            List<Reservation> nextPromotedList = new ArrayList<>();
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

                int userId = lockedRes.getUserId();

                // Bước 3: Hủy đơn đặt trước quá hạn
                reservationDAO.updateStatusToCancelled(conn, lockedRes.getReservationId());
                result.cancelledCount++;
                LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã hủy đơn đặt trước quá hạn — reservationId={0}, userId={1}",
                        new Object[]{lockedRes.getReservationId(), userId});

                // Bước 3.1: Áp dụng CHẾ TÀI KHÓA GIAO DỊCH 7 NGÀY cho người vi phạm (FR-ROP-002)
                userDAO.lockUserForDuration(conn, userId, 7);
                String lockReasonText = "Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: " + lockedRes.getReservationId() + ")";
                userLockReasonDAO.insertLockReason(conn, userId, lockReasonText);
                userDAO.insertAuditLog(null, "LOCK_ACCOUNT_OVERDUE_RESERVATION", "User", userId,
                        "status=active",
                        "status=locked, lockedUntil=NOW+7days, reason=" + lockReasonText);
                result.lockedAccountCount++;
                LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã khóa giao dịch 7 ngày cho người dùng — userId={0}, reservationId={1}",
                        new Object[]{userId, lockedRes.getReservationId()});

                // Bước 3.2: HỦY TOÀN BỘ HÀNG CHỜ KHÁC của người dùng vi phạm (FR-ROP-003)
                List<Reservation> otherActive = reservationDAO.findAllActiveByUserId(conn, userId, lockedRes.getReservationId());
                if (!otherActive.isEmpty()) {
                    int cancelledOther = reservationDAO.cancelAllActiveByUserId(conn, userId, lockedRes.getReservationId());
                    result.penaltyCancelledCount += cancelledOther;
                    userDAO.insertAuditLog(null, "CANCEL_ALL_RESERVATIONS_PENALTY", "Reservation", userId,
                            "activeCount=" + otherActive.size(),
                            "cancelledCount=" + cancelledOther);
                    LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã hủy thêm {0} đơn hàng chờ khác của người dùng vi phạm — userId={1}",
                            new Object[]{cancelledOther, userId});

                    // Luân chuyển bản sao cho từng đơn bị hủy do chế tài (FR-ROP-004)
                    for (Reservation otherRes : otherActive) {
                        Integer otherCopyId = otherRes.getBookCopyId();
                        int otherBookId = otherRes.getBookId();

                        if (otherCopyId != null) {
                            Reservation nextOther = reservationDAO.findNextInQueue(conn, otherBookId);
                            if (nextOther != null) {
                                reservationDAO.updateToReadyPickup(conn, nextOther.getReservationId(), otherCopyId, holdDays);
                                bookCopyDAO.updateStatusToReserved(conn, otherCopyId);
                                reservationDAO.decrementQueuePositions(conn, otherBookId);
                                result.promotedCount++;
                                nextPromotedList.add(nextOther);
                            } else {
                                bookCopyDAO.updateStatusToAvailable(conn, otherCopyId);
                                bookDAO.updateQuantities(conn, otherBookId, 0, 1);
                            }
                        } else {
                            bookDAO.updateQuantities(conn, otherBookId, 0, 1);
                            Reservation nextOther = reservationDAO.findNextInQueue(conn, otherBookId);
                            if (nextOther != null) {
                                reservationDAO.updateToReadyPickup(conn, nextOther.getReservationId(), null, holdDays);
                                reservationDAO.decrementQueuePositions(conn, otherBookId);
                                result.promotedCount++;
                                nextPromotedList.add(nextOther);
                            }
                        }
                    }
                }

                // Bước 4: Xác định bản sao sách vật lý cần giải phóng cho đơn quá hạn gốc
                Integer copyId = lockedRes.getBookCopyId();
                int bookId = lockedRes.getBookId();

                if (copyId != null) {
                    // Bước 5: Kiểm tra xem có người dùng nào khác đang xếp hàng cho tựa sách này không
                    Reservation nextRes = reservationDAO.findNextInQueue(conn, bookId);

                    if (nextRes != null) {
                        // Bước 6a: Phân bổ cho người chờ tiếp theo
                        reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), copyId, holdDays);
                        bookCopyDAO.updateStatusToReserved(conn, copyId);
                        reservationDAO.decrementQueuePositions(conn, bookId);

                        userDAO.insertAuditLog(null, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=" + copyId,
                                "status=cancelled, promoted reservationId=" + nextRes.getReservationId() + " to ready");

                        result.promotedCount++;
                        nextPromotedList.add(nextRes);
                        conn.commit(); // Hoàn thành Transaction

                    } else {
                        // Bước 6b: Trả sách về trạng thái sẵn sàng trong kho vì hàng chờ trống
                        bookCopyDAO.updateStatusToAvailable(conn, copyId);
                        bookDAO.updateQuantities(conn, bookId, 0, 1);

                        userDAO.insertAuditLog(null, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=" + copyId,
                                "status=cancelled, bookCopyId=" + copyId + " returned to available stock");

                        conn.commit(); // Hoàn thành Transaction
                    }
                } else {
                    // bookCopyId == NULL (đơn đặt trước online chưa được lấy)
                    bookDAO.updateQuantities(conn, bookId, 0, 1);

                    Reservation nextRes = reservationDAO.findNextInQueue(conn, bookId);
                    if (nextRes != null) {
                        reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), null, holdDays);
                        reservationDAO.decrementQueuePositions(conn, bookId);

                        userDAO.insertAuditLog(null, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=null",
                                "status=cancelled, promoted reservationId=" + nextRes.getReservationId() + " to ready");

                        result.promotedCount++;
                        nextPromotedList.add(nextRes);
                        conn.commit();
                    } else {
                        userDAO.insertAuditLog(null, "CANCEL_EXPIRED_RESERVATION", "Reservation", lockedRes.getReservationId(),
                                "status=readypickup, bookCopyId=null", "status=cancelled");
                        conn.commit();
                    }
                }

                // Gửi email thông báo bất đồng bộ ngoài transaction cho những người được đôn lên
                for (Reservation promotedRes : nextPromotedList) {
                    sendNotificationEmailAsync(promotedRes, promotedRes.getBookId());
                }

            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ReservationExpirationProcessor] Lỗi SQL khi xử lý đơn đặt trước quá hạn — reservationId=" + res.getReservationId() + ", tiến hành rollback đơn này.", e);
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        LOGGER.log(Level.SEVERE, "[ReservationExpirationProcessor] Rollback thất bại", ex);
                    }
                }
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "[ReservationExpirationProcessor] Không thể đóng Connection", e);
                    }
                }
            }
        }

        return result;
    }

    /**
     * Gửi email thông báo bất đồng bộ bằng EmailService sử dụng Queue ngầm.
     */
    private void sendNotificationEmailAsync(Reservation nextRes, int bookId) {
        try {
            User nextUser = userDAO.findByUserId(nextRes.getUserId());
            if (nextUser != null && nextUser.getEmail() != null) {
                MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                String fullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();

                String bookTitle = "Sách đã đặt";
                int holdDays = 3;
                try (Connection conn = DatabaseConnection.getConnection()) {
                    Book b = bookDAO.findById(conn, bookId);
                    if (b != null) {
                        bookTitle = b.getTitle();
                    }
                    holdDays = new dao.SystemConfigDAO().getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                }

                java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                String deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);

                java.util.Map<String, String> placeholders = new java.util.HashMap<>();
                placeholders.put("bookTitle", bookTitle);
                placeholders.put("pickupDeadline", deadlineStr);

                model.EmailJob job = new model.EmailJob("RESERVATION_READY", nextUser.getEmail(), fullName, placeholders);
                EmailService.enqueue(job);
                LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã enqueue email thông báo RESERVATION_READY cho người dùng: " + nextUser.getEmail());
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[ReservationExpirationProcessor] Lỗi khi gửi email thông báo đôn hàng chờ cho userId=" + nextRes.getUserId(), e);
        }
    }

    /**
     * DTO lưu kết quả xử lý
     */
    public static class ProcessResult {
        public int cancelledCount = 0;
        public int promotedCount = 0;
        public int lockedAccountCount = 0;
        public int penaltyCancelledCount = 0;
    }
}
