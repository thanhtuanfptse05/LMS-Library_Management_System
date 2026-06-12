package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Year;
import model.Book;
import util.DatabaseConnection;

public class BookService {

    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;

    public BookService() {
        this(new BookDAO(), new AuditLogDAO());
    }

    public BookService(BookDAO bookDAO, AuditLogDAO auditLogDAO) {
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
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
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Book oldBook = bookDAO.findById(conn, book.getBookId());
                if (oldBook == null) {
                    throw new ValidationException("Đầu sách không tồn tại.");
                }
                book.setIsbn(oldBook.getIsbn());
                bookDAO.update(conn, book);
                bookDAO.replaceCategories(conn, book.getBookId(), categoryIds);
                bookDAO.replaceTags(conn, book.getBookId(), tagIds);
                auditLogDAO.insert(conn, actorId, "UPDATE_BOOK", "Book", book.getBookId(),
                        toAuditValue(oldBook), toAuditValue(book));
                conn.commit();
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
        if (creating && book.getIsbn().trim().length() > 20) {
            throw new ValidationException("ISBN không được vượt quá 20 ký tự.");
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
}
