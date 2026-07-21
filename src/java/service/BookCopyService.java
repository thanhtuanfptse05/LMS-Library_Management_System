package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.regex.Pattern;
import model.Book;
import model.BookCopy;
import util.DatabaseConnection;

public class BookCopyService {

    private static final Pattern BARCODE_PATTERN = Pattern.compile("^[A-Za-z0-9._/-]+$");
    private static final String UNIQUE_VIOLATION_SQL_STATE = "23505";

    private final BookCopyDAO bookCopyDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;

    public BookCopyService() {
        this(new BookCopyDAO(), new BookDAO(), new AuditLogDAO());
    }

    public BookCopyService(BookCopyDAO bookCopyDAO, BookDAO bookDAO, AuditLogDAO auditLogDAO) {
        this.bookCopyDAO = bookCopyDAO;
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
    }

    public int create(BookCopy copy, int actorId) throws ValidationException, DatabaseException {
        validateCreate(copy);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Book book = bookDAO.findById(conn, copy.getBookId());
                if (book == null) {
                    throw new ValidationException("Đầu sách không tồn tại.");
                }
                BookCopy duplicate = bookCopyDAO.findByBarcode(conn, copy.getBarcode());
                if (duplicate != null) {
                    throw new ValidationException("Mã vạch đã tồn tại trên hệ thống thuộc tựa sách "
                            + duplicate.getBookTitle() + ".");
                }
                copy.setCondition("good");
                copy.setStatus("available");
                int copyId = bookCopyDAO.insert(conn, copy);
                bookDAO.updateQuantities(conn, copy.getBookId(), 1, 1);
                auditLogDAO.insert(conn, actorId, "CREATE_BOOK_COPY", "BookCopy", copyId, null, toAuditValue(copy));
                conn.commit();
                return copyId;
            } catch (ValidationException e) {
                conn.rollback();
                throw e;
            } catch (SQLException e) {
                conn.rollback();
                if (isUniqueConstraintViolation(e)) {
                    throw new ValidationException("Mã vạch " + copy.getBarcode()
                            + " vừa được sử dụng, vui lòng thử lại.");
                }
                throw new DatabaseException("Không thể thêm bản sao do lỗi đồng bộ tồn kho.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void update(BookCopy requested, int actorId) throws ValidationException, DatabaseException {
        validateUpdate(requested);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCopy oldCopy = bookCopyDAO.findById(conn, requested.getBookCopyId());
                if (oldCopy == null) {
                    throw new ValidationException("Bản sao không tồn tại.");
                }
                if (!"available".equals(oldCopy.getStatus())) {
                    if ("borrowed".equals(oldCopy.getStatus()) || "reserved".equals(oldCopy.getStatus())) {
                        throw new ValidationException("Không thể cập nhật bản sao đang được mượn hoặc đặt trước.");
                    }
                    throw new ValidationException("Bản sao đã ghi nhận sự cố cần được xử lý tại màn Hỏng & mất.");
                }
                requested.setBookId(oldCopy.getBookId());
                requested.setBarcode(oldCopy.getBarcode());
                requested.setCondition(oldCopy.getCondition());
                requested.setStatus(oldCopy.getStatus());
                bookCopyDAO.updateAvailableCopy(conn, requested);
                auditLogDAO.insert(conn, actorId, "UPDATE_BOOK_COPY", "BookCopy", requested.getBookCopyId(),
                        toAuditValue(oldCopy), toAuditValue(requested));
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật bản sao do lỗi đồng bộ tồn kho.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validateCreate(BookCopy copy) throws ValidationException {
        if (copy.getBookId() <= 0) {
            throw new ValidationException("Hãy chọn đầu sách.");
        }
        if (copy.getBarcode() == null || copy.getBarcode().isBlank()) {
            throw new ValidationException("Mã vạch không được để trống.");
        }
        if (copy.getBarcode().length() > 50) {
            throw new ValidationException("Mã vạch không được vượt quá 50 ký tự.");
        }
        if (!BARCODE_PATTERN.matcher(copy.getBarcode()).matches()) {
            throw new ValidationException("Mã vạch chỉ được chứa chữ, số và các ký tự - _ . /.");
        }
        validateLocation(copy.getLocation());
    }

    public void validateUpdate(BookCopy copy) throws ValidationException {
        if (copy.getBookCopyId() <= 0) {
            throw new ValidationException("Bản sao không hợp lệ.");
        }
        validateLocation(copy.getLocation());
    }

    private void validateLocation(String location) throws ValidationException {
        if (location == null || location.isBlank()) {
            throw new ValidationException("Vị trí lưu trữ không được để trống.");
        }
        if (location.length() > 255) {
            throw new ValidationException("Vị trí lưu trữ không được vượt quá 255 ký tự.");
        }
    }

    boolean isUniqueConstraintViolation(SQLException e) {
        SQLException current = e;
        while (current != null) {
            if (UNIQUE_VIOLATION_SQL_STATE.equals(current.getSQLState())) {
                return true;
            }
            current = current.getNextException();
        }
        return false;
    }

    private String toAuditValue(BookCopy copy) {
        return "{\"barcode\":\"" + escape(copy.getBarcode()) + "\",\"bookId\":" + copy.getBookId()
                + ",\"location\":\"" + escape(copy.getLocation()) + "\",\"condition\":\""
                + escape(copy.getCondition()) + "\",\"status\":\"" + escape(copy.getStatus()) + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
