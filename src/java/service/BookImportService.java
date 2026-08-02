package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BookImportDAO;
import dao.CategoryDAO;
import dao.TagDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;
import model.Book;
import model.BookCopy;
import model.BookImportBatch;
import model.BookImportError;
import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import model.Category;
import model.Reservation;
import model.Tag;
import util.DatabaseConnection;

public class BookImportService {

    private final BookImportValidator validator;
    private final BookImportDAO importDAO;
    private final BookDAO bookDAO;
    private final BookCopyDAO copyDAO;
    private final CategoryDAO categoryDAO;
    private final TagDAO tagDAO;
    private final AuditLogDAO auditDAO;
    private final ReservationCapacityAllocator capacityAllocator;

    public BookImportService() {
        this(new BookImportValidator(), new BookImportDAO(), new BookDAO(), new BookCopyDAO(),
                new CategoryDAO(), new TagDAO(), new AuditLogDAO(), new ReservationCapacityAllocator());
    }

    public BookImportService(BookImportValidator validator, BookImportDAO importDAO, BookDAO bookDAO,
            BookCopyDAO copyDAO, CategoryDAO categoryDAO, TagDAO tagDAO, AuditLogDAO auditDAO) {
        this(validator, importDAO, bookDAO, copyDAO, categoryDAO, tagDAO, auditDAO,
                new ReservationCapacityAllocator());
    }

    public BookImportService(BookImportValidator validator, BookImportDAO importDAO, BookDAO bookDAO,
            BookCopyDAO copyDAO, CategoryDAO categoryDAO, TagDAO tagDAO, AuditLogDAO auditDAO,
            ReservationCapacityAllocator capacityAllocator) {
        this.validator = validator;
        this.importDAO = importDAO;
        this.bookDAO = bookDAO;
        this.copyDAO = copyDAO;
        this.categoryDAO = categoryDAO;
        this.tagDAO = tagDAO;
        this.auditDAO = auditDAO;
        this.capacityAllocator = capacityAllocator;
    }

    public void validate(BookImportPreviewDTO preview, int actorId) throws DatabaseException {
        validator.validate(preview);
        if (!preview.isValid()) {
            saveFailedBatch(preview, actorId, preview.getErrors());
        }
    }

    public int confirm(BookImportPreviewDTO preview, int actorId) throws ValidationException, DatabaseException {
        // Lỗi do WorkbookReader phát hiện là lỗi cấu trúc/nội dung gốc của tệp và
        // không được xóa khi xác nhận. Một preview đã có lỗi tuyệt đối không được import.
        if (!preview.isValid()) {
            saveFailedBatch(preview, actorId, preview.getErrors());
            throw new ValidationException("Tệp import vẫn còn lỗi. Hãy sửa tệp và tải lên lại.");
        }
        validator.validate(preview);
        if (!preview.isValid()) {
            saveFailedBatch(preview, actorId, preview.getErrors());
            throw new ValidationException("Dữ liệu đã thay đổi hoặc không còn hợp lệ. Hãy kiểm tra lại tệp.");
        }
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCreationResult books = createBooks(conn, preview.getBooks(), actorId);
                CopyCreationResult copies = createCopies(
                        conn, preview.getBookCopies(), books.idsByIsbn, actorId);
                // successRows chỉ đếm số dòng thực sự được ghi vào CSDL: các dòng đầu sách có ISBN
                // đã tồn tại bị bỏ qua nên không được tính là thành công.
                int successRows = books.inserted + copies.inserted;
                BookImportBatch batch = batch(preview, actorId, successRows, 0, "success");
                int batchId = importDAO.insertBatch(conn, batch);
                auditDAO.insert(conn, actorId, "IMPORT_BOOKS", "BookImportBatch", batchId, null,
                        "{\"fileName\":\"" + escape(preview.getFileName()) + "\",\"books\":"
                        + books.inserted + ",\"skippedBooks\":" + books.skipped
                        + ",\"bookCopies\":" + copies.inserted + "}");
                conn.commit();
                for (ReadyNotification notification : copies.notifications) {
                    capacityAllocator.notifyReadyAfterCommit(
                            notification.reservation, notification.bookTitle);
                }
                return batchId;
            } catch (SQLException e) {
                conn.rollback();
                saveFailedBatch(preview, actorId, List.of(new BookImportError("Books", 1, null,
                        "Lỗi hệ thống khi lưu dữ liệu. Toàn bộ phiên import đã được hoàn tác.")));
                if (isUniqueConstraintViolation(e)) {
                    throw new ValidationException("Dữ liệu ISBN, mã vạch, thể loại hoặc tag vừa bị trùng với "
                            + "một thao tác khác. Toàn bộ phiên import đã được hoàn tác; hãy tải lại dữ liệu.");
                }
                throw new DatabaseException("Lỗi hệ thống trong quá trình đồng bộ dữ liệu import.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    /** Kết quả tạo đầu sách: ánh xạ ISBN → bookId, kèm số dòng đã tạo mới và số dòng bị bỏ qua. */
    private static final class BookCreationResult {
        private final Map<String, Integer> idsByIsbn = new LinkedHashMap<>();
        private int inserted;
        private int skipped;
    }

    private static final class CopyCreationResult {
        private int inserted;
        private final List<ReadyNotification> notifications = new ArrayList<>();
    }

    private static final class ReadyNotification {
        private final Reservation reservation;
        private final String bookTitle;

        private ReadyNotification(Reservation reservation, String bookTitle) {
            this.reservation = reservation;
            this.bookTitle = bookTitle;
        }
    }

    private BookCreationResult createBooks(Connection conn, List<BookImportRowDTO> rows, int actorId)
            throws SQLException {
        BookCreationResult result = new BookCreationResult();
        for (BookImportRowDTO row : rows) {
            Book existing = bookDAO.findByIsbn(conn, row.getIsbn());
            if (existing != null) {
                // Đầu sách đã tồn tại: chỉ dùng lại bookId, không ghi đè dữ liệu hiện có.
                // BookImportValidator đã cảnh báo dòng này ở bước xem trước.
                row.setExistingBook(true);
                result.idsByIsbn.put(row.getIsbn().toLowerCase(), existing.getBookId());
                result.skipped++;
                continue;
            }
            Book book = toBook(row);
            int bookId = bookDAO.insert(conn, book);
            bookDAO.replaceCategories(conn, bookId, resolveCategories(conn, row.getCategories(), actorId));
            bookDAO.replaceTags(conn, bookId, resolveTags(conn, row.getTags(), actorId));
            result.idsByIsbn.put(row.getIsbn().toLowerCase(), bookId);
            result.inserted++;
        }
        return result;
    }

    private CopyCreationResult createCopies(Connection conn, List<BookImportRowDTO> rows,
            Map<String, Integer> bookIds, int actorId)
            throws SQLException {
        CopyCreationResult result = new CopyCreationResult();
        for (BookImportRowDTO row : rows) {
            Integer bookId = bookIds.get(row.getIsbn().toLowerCase());
            if (bookId == null) {
                Book existing = bookDAO.findByIsbn(conn, row.getIsbn());
                if (existing == null) {
                    throw new SQLException("Không tìm thấy đầu sách cho ISBN " + row.getIsbn()
                            + " ở dòng " + row.getRowNumber() + " của trang tính BookCopies.");
                }
                bookId = existing.getBookId();
                bookIds.put(row.getIsbn().toLowerCase(), bookId);
            }
            BookCopy copy = new BookCopy();
            Book parentBook = bookDAO.findByIdForUpdate(conn, bookId);
            if (parentBook == null) {
                throw new SQLException("Đầu sách không còn tồn tại cho ISBN " + row.getIsbn() + ".");
            }
            boolean parentAvailable = "available".equals(parentBook.getStatus());
            copy.setBookId(bookId);
            copy.setBarcode(row.getBarcode());
            copy.setLocation(row.getLocation());
            copy.setCondition("good");
            copy.setStatus(parentAvailable ? "available" : "unavailable");
            copyDAO.insert(conn, copy);
            Reservation promoted = capacityAllocator.registerNewCopy(
                    conn, parentBook, actorId, "excel_import");
            if (promoted != null) {
                result.notifications.add(new ReadyNotification(promoted, parentBook.getTitle()));
            }
            result.inserted++;
        }
        return result;
    }

    private int[] resolveCategories(Connection conn, List<String> names, int actorId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        for (String name : names) {
            Category category = categoryDAO.findByName(conn, name);
            if (category == null) {
                category = new Category();
                category.setName(name);
                category.setDescription(null);
                category.setStatus("active");
                int id = categoryDAO.insert(conn, category, actorId);
                ids.add(id);
            } else {
                ids.add(category.getCategoryId());
            }
        }
        return ids.stream().mapToInt(Integer::intValue).toArray();
    }

    private int[] resolveTags(Connection conn, List<String> names, int actorId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        for (String name : names) {
            Tag tag = tagDAO.findByName(conn, name);
            if (tag == null) {
                tag = new Tag();
                tag.setName(name);
                tag.setStatus("active");
                int id = tagDAO.insert(conn, tag, actorId);
                ids.add(id);
            } else {
                ids.add(tag.getTagId());
            }
        }
        return ids.stream().mapToInt(Integer::intValue).toArray();
    }

    private void saveFailedBatch(BookImportPreviewDTO preview, int actorId, List<BookImportError> errors)
            throws DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookImportBatch batch = batch(preview, actorId, 0, countFailedRows(errors), "failed");
                int batchId = importDAO.insertBatch(conn, batch);
                importDAO.insertErrors(conn, batchId, errors);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new DatabaseException("Không thể lưu lịch sử lỗi import.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    private BookImportBatch batch(BookImportPreviewDTO preview, int actorId, int successRows, int failedRows,
            String status) {
        BookImportBatch batch = new BookImportBatch();
        batch.setImportedBy(actorId);
        batch.setFileName(preview.getFileName());
        batch.setTotalRows(preview.getTotalRows());
        batch.setSuccessRows(Math.min(successRows, preview.getTotalRows()));
        batch.setFailedRows(Math.min(failedRows, preview.getTotalRows()));
        batch.setStatus(status);
        return batch;
    }

    private int countFailedRows(List<BookImportError> errors) {
        Set<String> rows = new HashSet<>();
        for (BookImportError error : errors) {
            rows.add(error.getSheetName() + ":" + Math.max(1, error.getRowNumber()));
        }
        return rows.size();
    }

    private Book toBook(BookImportRowDTO row) {
        Book book = new Book();
        book.setIsbn(row.getIsbn());
        book.setTitle(row.getTitle());
        book.setAuthor(row.getAuthor());
        book.setPublisher(row.getPublisher());
        book.setPublicationYear(row.getPublicationYear());
        book.setPrice(row.getPrice());
        book.setStatus("available");
        return book;
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private boolean isUniqueConstraintViolation(SQLException exception) {
        SQLException current = exception;
        while (current != null) {
            if ("23505".equals(current.getSQLState())) {
                return true;
            }
            current = current.getNextException();
        }
        return false;
    }
}
