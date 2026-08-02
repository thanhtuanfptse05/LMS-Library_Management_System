package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import model.Book;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import dao.UserLockReasonDAO;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ReservationExpirationProcessor — Xử lý các đơn đặt trước quá hạn nhận sách (Lazy Load).
 *
 * <p>Bao gồm chế tài cho người vi phạm: khóa giao dịch 7 ngày, hủy toàn bộ
 * hàng chờ khác, luân chuyển bản sao sách, ghi Audit Log.</p>
 *
 * <p>Có cơ chế throttle (cooldown) để tránh gọi lặp lại quá nhanh khi
 * AuthFilter kích hoạt Lazy Sweep trên mọi request.</p>
 */
public class ReservationExpirationProcessor {
    private static final Logger LOGGER = Logger.getLogger(ReservationExpirationProcessor.class.getName());

    /** Thời gian khóa giao dịch cố định (ngày) khi vi phạm quá hạn nhận sách đặt trước. */
    private static final int PENALTY_LOCK_DAYS = 7;

    /** Cooldown tối thiểu giữa các lần chạy processExpiration() (milliseconds). */
    private static final long COOLDOWN_MS = 30_000L;

    /** Thời điểm chạy thành công gần nhất — dùng để throttle. */
    private static volatile long lastRunTimestamp = 0;

    /** Lock object để tránh nhiều thread chạy đồng thời. */
    private static final Object RUN_LOCK = new Object();

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();
    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    /**
     * Thực hiện luồng xử lý quét quá hạn với cơ chế throttle.
     *
     * <p>Nếu được gọi lại trong vòng {@value #COOLDOWN_MS}ms kể từ lần chạy trước,
     * trả về ngay {@code ProcessResult} rỗng mà không query DB.</p>
     */
    public ProcessResult processExpiration() {
        ProcessResult result = new ProcessResult();

        // Throttle: nếu đã chạy gần đây thì bỏ qua
        long now = System.currentTimeMillis();
        if (now - lastRunTimestamp < COOLDOWN_MS) {
            return result;
        }

        // Đảm bảo chỉ 1 thread chạy tại một thời điểm
        synchronized (RUN_LOCK) {
            // Double-check sau khi lấy lock
            if (System.currentTimeMillis() - lastRunTimestamp < COOLDOWN_MS) {
                return result;
            }

            try {
                result = doProcessExpiration();
            } finally {
                lastRunTimestamp = System.currentTimeMillis();
            }
        }

        return result;
    }

    /**
     * Logic xử lý quét quá hạn chính — được gọi từ processExpiration() sau khi đã qua throttle.
     */
    private ProcessResult doProcessExpiration() {
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
            return result;
        }

        LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Tìm thấy {0} đơn quá hạn cần xử lý.", expiredList.size());

        // Lấy cấu hình holdDays trước để tối ưu hóa
        int holdDays = new SystemConfigDAO().getIntValue("RESERVATION_HOLD_DAYS", 3);

        // Theo dõi userId đã bị xử phạt để tránh lặp lock cho cùng 1 user (FR-ROP-007)
        Set<Integer> penalizedUserIds = new HashSet<>();

        // 2. Vòng lặp xử lý cô lập cho từng đơn hàng
        for (Reservation res : expiredList) {
            Connection conn = null;
            List<Reservation> nextPromotedList = new ArrayList<>();
            try {
                conn = DatabaseConnection.getConnection();
                conn.setAutoCommit(false); // Bắt đầu Transaction độc lập

                // Khóa đầu sách trước để tuần tự hóa mọi thay đổi sức chứa khả dụng.
                bookDAO.findByIdForUpdate(conn, res.getBookId());

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
                // Kiểm tra xem user đã bị phạt trong lần quét này chưa (FR-ROP-007: tránh lặp lock)
                if (!penalizedUserIds.contains(userId)) {
                    userDAO.lockUserForDuration(conn, userId, PENALTY_LOCK_DAYS);
                    penalizedUserIds.add(userId);
                    result.lockedAccountCount++;
                    LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã khóa giao dịch {0} ngày cho người dùng — userId={1}",
                            new Object[]{PENALTY_LOCK_DAYS, userId});
                }
                // Luôn ghi thêm UserLockReason cho mỗi đơn quá hạn (không ghi đè lý do cũ)
                String lockReasonText = "quá hạn nhận sách đặt trước (ReservationID: " + lockedRes.getReservationId() + ")";
                userLockReasonDAO.insertLockReason(conn, userId, lockReasonText);
                auditLogDAO.insert(conn, null, "LOCK_ACCOUNT_OVERDUE_RESERVATION", "User", userId,
                        "status=active",
                        "status=locked, lockedUntil=NOW+" + PENALTY_LOCK_DAYS + "days, reservationId=" + lockedRes.getReservationId());

                // Bước 3.2: HỦY TOÀN BỘ HÀNG CHỜ KHÁC của người dùng vi phạm (FR-ROP-003)
                List<Reservation> otherActive = reservationDAO.findAllActiveByUserId(conn, userId, lockedRes.getReservationId());
                if (!otherActive.isEmpty()) {
                    // Phân tách đơn readypickup (cần luân chuyển) và pending (chỉ hủy)
                    List<Reservation> otherReadyPickup = new ArrayList<>();
                    Set<Integer> affectedBookIds = new HashSet<>();

                    for (Reservation otherRes : otherActive) {
                        if (isReadyHold(otherRes)) {
                            otherReadyPickup.add(otherRes);
                        }
                        affectedBookIds.add(otherRes.getBookId());
                    }

                    // Hủy toàn bộ đơn trước
                    for (Reservation otherRes : otherActive) {
                        reservationDAO.updateStatusToCancelled(conn, otherRes.getReservationId());
                    }
                    int cancelledOther = otherActive.size();
                    result.penaltyCancelledCount += cancelledOther;
                    auditLogDAO.insert(conn, null, "CANCEL_ALL_RESERVATIONS_PENALTY", "Reservation", userId,
                            "activeCount=" + otherActive.size(),
                            "cancelledCount=" + cancelledOther);
                    LOGGER.log(Level.INFO, "[ReservationExpirationProcessor] Đã hủy thêm {0} đơn hàng chờ khác của người dùng vi phạm — userId={1}",
                            new Object[]{cancelledOther, userId});

                    // Chuẩn hóa hàng chờ cho các bookId bị ảnh hưởng bởi đơn pending bị hủy
                    for (Integer affectedBookId : affectedBookIds) {
                        reservationDAO.normalizePendingQueuePositions(conn, affectedBookId);
                    }

                    // Luân chuyển bản sao cho các đơn readypickup đã bị hủy
                    for (Reservation otherRes : otherReadyPickup) {
                        Reservation nextOther = releaseReadyHold(conn, otherRes, holdDays);
                        if (nextOther != null) {
                            result.promotedCount++;
                            nextPromotedList.add(nextOther);
                        }
                    }
                }

                // Luân chuyển bản sao cho đơn quá hạn gốc
                Reservation nextRes = releaseReadyHold(conn, lockedRes, holdDays);
                if (nextRes != null) {
                    result.promotedCount++;
                    nextPromotedList.add(nextRes);
                }

                auditLogDAO.insert(conn, null, "CANCEL_EXPIRED_RESERVATION", "Reservation",
                        lockedRes.getReservationId(), "status=readypickup",
                        nextRes == null ? "status=cancelled, capacity=released"
                                : "status=cancelled, promoted reservationId=" + nextRes.getReservationId());
                conn.commit();

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
     * Kiểm tra xem đơn đặt trước có đang giữ suất readypickup không.
     */
    private boolean isReadyHold(Reservation reservation) {
        return "readypickup".equals(reservation.getStatus())
                && reservation.getQueuePosition() != null
                && reservation.getQueuePosition() == 0;
    }

    /**
     * Giải phóng một suất readypickup. Nếu còn hàng chờ, suất được chuyển thẳng
     * cho người tiếp theo và availableQuantity giữ nguyên.
     * Nếu không còn ai chờ, tăng availableQuantity lên 1.
     */
    private Reservation releaseReadyHold(Connection conn, Reservation reservation, int holdDays)
            throws SQLException {
        Reservation next = reservationDAO.findNextInQueue(conn, reservation.getBookId());
        if (next != null) {
            reservationDAO.updateToReadyPickupWithoutCopy(conn, next.getReservationId(), holdDays);
            reservationDAO.decrementQueuePositions(conn, reservation.getBookId());
            return next;
        }

        // Không còn ai chờ → giải phóng bản sao về kho
        model.Book book = bookDAO.findById(conn, reservation.getBookId());
        if (book != null && "available".equals(book.getStatus())) {
            bookDAO.updateQuantities(conn, reservation.getBookId(), 0, 1);
        }
        return null;
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
