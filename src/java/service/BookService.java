package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.UserDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Year;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;
import util.IsbnValidator;

public class BookService {

    private static final Logger LOGGER = Logger.getLogger(BookService.class.getName());
    private static final String UNIQUE_VIOLATION_SQL_STATE = "23505";

    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;
    private final BookCopyDAO bookCopyDAO;
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;

    public BookService() {
        this(new BookDAO(), new AuditLogDAO(), new BookCopyDAO(), new ReservationDAO(),
                new UserDAO(), new MemberProfileDAO());
    }

    public BookService(BookDAO bookDAO, AuditLogDAO auditLogDAO) {
        this(bookDAO, auditLogDAO, new BookCopyDAO(), new ReservationDAO(),
                new UserDAO(), new MemberProfileDAO());
    }

    public BookService(BookDAO bookDAO, AuditLogDAO auditLogDAO, BookCopyDAO bookCopyDAO,
            ReservationDAO reservationDAO, UserDAO userDAO, MemberProfileDAO memberProfileDAO) {
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.reservationDAO = reservationDAO;
        this.userDAO = userDAO;
        this.memberProfileDAO = memberProfileDAO;
    }

    public int createBook(Book book, int[] categoryIds, int[] tagIds, int actorId)
            throws ValidationException, DatabaseException {
        validate(book, true);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if (bookDAO.existsByIsbn(conn, book.getIsbn())) {
                    throw new ValidationException("Trùng lặp ISBN. ISBN này đã tồn tại trên hệ thống.");
                }
                int bookId = bookDAO.insert(conn, book);
                bookDAO.replaceCategories(conn, bookId, categoryIds);
                bookDAO.replaceTags(conn, bookId, tagIds);
                auditLogDAO.insert(conn, actorId, "CREATE_BOOK", "Book", bookId, null, toAuditValue(book));
                conn.commit();
                return bookId;
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                if (isUniqueConstraintViolation((SQLException) e)
                        && bookDAO.existsByIsbn(conn, book.getIsbn())) {
                    throw new ValidationException("Trùng lặp ISBN. ISBN này vừa được thêm bởi thao tác khác.");
                }
                throw new DatabaseException("Không thể tạo đầu sách do lỗi hệ thống.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void updateBook(Book book, int[] categoryIds, int[] tagIds, int actorId)
            throws ValidationException, DatabaseException {
        validate(book, false);
        List<Reservation> cancelledReservations = Collections.emptyList();
        String cancellationBookTitle = null;
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Book oldBook = bookDAO.findByIdForUpdate(conn, book.getBookId());
                if (oldBook == null) {
                    throw new ValidationException("Đầu sách không tồn tại.");
                }
                book.setIsbn(oldBook.getIsbn());
                bookDAO.update(conn, book);

                boolean stoppingCirculation = "available".equals(oldBook.getStatus())
                        && "unavailable".equals(book.getStatus());
                boolean resumingCirculation = "unavailable".equals(oldBook.getStatus())
                        && "available".equals(book.getStatus());

                if (stoppingCirculation) {
                    cancelledReservations = reservationDAO.findActiveByBookIdForUpdate(conn, book.getBookId());
                    int suspendedCopies = bookCopyDAO.suspendAvailableCopiesByBookId(conn, book.getBookId());
                    int cancelledCount = reservationDAO.cancelActiveByBookId(conn, book.getBookId());
                    bookDAO.setAvailableQuantity(conn, book.getBookId(), 0);
                    cancellationBookTitle = book.getTitle();
                    auditLogDAO.insert(conn, actorId, "STOP_BOOK_CIRCULATION", "Book", book.getBookId(),
                            "{\"status\":\"available\"}",
                            "{\"status\":\"unavailable\",\"suspendedCopies\":" + suspendedCopies
                            + ",\"cancelledReservations\":" + cancelledCount + "}");
                } else if (resumingCirculation) {
                    int restoredCopies = bookCopyDAO.restoreEligibleCopiesByBookId(conn, book.getBookId());
                    int availableCopies = bookCopyDAO.countActiveAvailableCopies(conn, book.getBookId());
                    bookDAO.setAvailableQuantity(conn, book.getBookId(), availableCopies);
                    auditLogDAO.insert(conn, actorId, "RESUME_BOOK_CIRCULATION", "Book", book.getBookId(),
                            "{\"status\":\"unavailable\"}",
                            "{\"status\":\"available\",\"restoredCopies\":" + restoredCopies
                            + ",\"availableQuantity\":" + availableCopies + "}");
                }
                bookDAO.replaceCategories(conn, book.getBookId(), categoryIds);
                bookDAO.replaceTags(conn, book.getBookId(), tagIds);
                auditLogDAO.insert(conn, actorId, "UPDATE_BOOK", "Book", book.getBookId(),
                        toAuditValue(oldBook), toAuditValue(book));
                conn.commit();
                if (!cancelledReservations.isEmpty()) {
                    notifyCancelledReservations(cancelledReservations, cancellationBookTitle);
                }
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật đầu sách do lỗi hệ thống.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validate(Book book, boolean creating) throws ValidationException {
        if (creating && (book.getIsbn() == null || book.getIsbn().isBlank())) {
            throw new ValidationException("ISBN không được để trống.");
        }
        if (creating) {
            String normalizedIsbn = IsbnValidator.normalize(book.getIsbn());
            if (!IsbnValidator.isValid(normalizedIsbn)) {
                throw new ValidationException("ISBN không hợp lệ. Vui lòng nhập ISBN-10 hoặc ISBN-13 đúng chuẩn.");
            }
            book.setIsbn(normalizedIsbn);
        }
        if (book.getTitle() == null || book.getTitle().isBlank()) {
            throw new ValidationException("Tên sách không được để trống.");
        }
        if (book.getTitle().trim().length() > 500) {
            throw new ValidationException("Tên sách không được vượt quá 500 ký tự.");
        }
        if (book.getAuthor() != null && book.getAuthor().length() > 500) {
            throw new ValidationException("Tên tác giả không được vượt quá 500 ký tự.");
        }
        if (book.getPublisher() != null && book.getPublisher().length() > 255) {
            throw new ValidationException("Tên nhà xuất bản không được vượt quá 255 ký tự.");
        }
        if (book.getPublicationYear() != null
                && (book.getPublicationYear() < 1000 || book.getPublicationYear() > Year.now().getValue() + 1)) {
            throw new ValidationException("Năm xuất bản không hợp lệ.");
        }
        if (book.getPrice() != null && book.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Giá sách không được âm.");
        }
        if (!"available".equals(book.getStatus()) && !"unavailable".equals(book.getStatus())) {
            throw new ValidationException("Trạng thái đầu sách không hợp lệ.");
        }
    }

    private String toAuditValue(Book book) {
        return "{\"isbn\":\"" + escape(book.getIsbn()) + "\",\"title\":\"" + escape(book.getTitle())
                + "\",\"imagePath\":\"" + escape(book.getImagePath())
                + "\",\"status\":\"" + escape(book.getStatus()) + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private boolean isUniqueConstraintViolation(SQLException exception) {
        SQLException current = exception;
        while (current != null) {
            if (UNIQUE_VIOLATION_SQL_STATE.equals(current.getSQLState())) {
                return true;
            }
            current = current.getNextException();
        }
        return false;
    }

    private void notifyCancelledReservations(List<Reservation> reservations, String bookTitle) {
        for (Reservation reservation : reservations) {
            try {
                User user = userDAO.findByUserId(reservation.getUserId());
                if (user == null || user.getEmail() == null) {
                    continue;
                }
                MemberProfile profile = memberProfileDAO.findByUserId(reservation.getUserId());
                String fullName = profile != null ? profile.getFullName() : user.getEmail();
                EmailService.sendReservationCancelledEmail(user.getEmail(), fullName, bookTitle,
                        "Đầu sách đã được thư viện chuyển sang trạng thái ngừng lưu thông.");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Không thể gửi thông báo hủy reservationId="
                        + reservation.getReservationId(), e);
            }
        }
    }
}
