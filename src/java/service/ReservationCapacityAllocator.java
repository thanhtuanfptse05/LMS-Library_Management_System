package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.EmailJob;
import model.MemberProfile;
import model.Reservation;
import model.User;

/**
 * Phân bổ phần sức chứa phát sinh khi thư viện bổ sung một bản sao vật lý.
 * Reservation chỉ giữ suất của đầu sách; barcode chỉ được gán khi checkout.
 */
public class ReservationCapacityAllocator {

    private static final Logger LOGGER = Logger.getLogger(ReservationCapacityAllocator.class.getName());
    private static final String HOLD_DAYS_KEY = "RESERVATION_HOLD_DAYS";

    private final ReservationDAO reservationDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;
    private final SystemConfigDAO systemConfigDAO;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;

    public ReservationCapacityAllocator() {
        this(new ReservationDAO(), new BookDAO(), new AuditLogDAO(), new SystemConfigDAO(),
                new UserDAO(), new MemberProfileDAO());
    }

    public ReservationCapacityAllocator(ReservationDAO reservationDAO, BookDAO bookDAO,
            AuditLogDAO auditLogDAO, SystemConfigDAO systemConfigDAO,
            UserDAO userDAO, MemberProfileDAO memberProfileDAO) {
        this.reservationDAO = reservationDAO;
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
        this.systemConfigDAO = systemConfigDAO;
        this.userDAO = userDAO;
        this.memberProfileDAO = memberProfileDAO;
    }

    /**
     * Ghi nhận một bản sao mới và ưu tiên cấp sức chứa đó cho người đầu hàng đợi.
     * Phương thức dùng transaction/lock do caller quản lý và không tự commit.
     */
    public Reservation registerNewCopy(Connection conn, Book book, int actorId, String source)
            throws SQLException {
        if (!"available".equals(book.getStatus())) {
            bookDAO.updateQuantities(conn, book.getBookId(), 1, 0);
            return null;
        }

        Reservation next = reservationDAO.findNextInQueue(conn, book.getBookId());
        if (next == null) {
            bookDAO.updateQuantities(conn, book.getBookId(), 1, 1);
            return null;
        }

        int holdDays = systemConfigDAO.getIntValue(conn, HOLD_DAYS_KEY, 3);
        reservationDAO.updateToReadyPickupWithoutCopy(conn, next.getReservationId(), holdDays);
        reservationDAO.decrementQueuePositions(conn, book.getBookId());
        bookDAO.updateQuantities(conn, book.getBookId(), 1, 0);
        auditLogDAO.insert(conn, actorId, "PROMOTE_RESERVATION_NEW_COPY", "Reservation",
                next.getReservationId(),
                "{\"status\":\"pending\",\"queuePosition\":1}",
                "{\"status\":\"readypickup\",\"queuePosition\":0,\"bookCopyId\":null,"
                + "\"source\":\"" + escape(source) + "\"}");
        return next;
    }

    /** Chỉ gọi sau khi transaction tạo bản sao đã commit thành công. */
    public void notifyReadyAfterCommit(Reservation reservation, String bookTitle) {
        if (reservation == null) {
            return;
        }
        try {
            User user = userDAO.findByUserId(reservation.getUserId());
            if (user == null || user.getEmail() == null || user.getEmail().isBlank()) {
                return;
            }
            MemberProfile profile = memberProfileDAO.findByUserId(reservation.getUserId());
            String fullName = profile != null ? profile.getFullName() : user.getEmail();
            int holdDays = systemConfigDAO.getIntValue(HOLD_DAYS_KEY, 3);
            java.sql.Timestamp deadline = new java.sql.Timestamp(
                    System.currentTimeMillis() + (long) holdDays * 24 * 60 * 60 * 1000);
            Map<String, String> placeholders = new HashMap<>();
            placeholders.put("bookTitle", bookTitle != null ? bookTitle : "Sách đã đặt");
            placeholders.put("pickupDeadline", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline));
            EmailService.enqueue(new EmailJob("RESERVATION_READY", user.getEmail(), fullName, placeholders));
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể xếp thông báo sẵn sàng cho reservationId="
                    + reservation.getReservationId(), e);
        }
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
