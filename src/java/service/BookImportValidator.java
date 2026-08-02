package service;

import dao.BookCopyDAO;
import dao.BookDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;
import model.Book;
import model.BookImportError;
import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import util.DatabaseConnection;
import util.IsbnValidator;

public class BookImportValidator {

    private static final Pattern BARCODE_PATTERN = Pattern.compile("^[A-Za-z0-9._/-]+$");

    private final BookDAO bookDAO;
    private final BookCopyDAO bookCopyDAO;
    private final BookService bookService;

    public BookImportValidator() {
        this(new BookDAO(), new BookCopyDAO(), new BookService());
    }

    public BookImportValidator(BookDAO bookDAO, BookCopyDAO bookCopyDAO, BookService bookService) {
        this.bookDAO = bookDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.bookService = bookService;
    }

    public void validate(BookImportPreviewDTO preview) throws DatabaseException {
        Set<String> availableIsbns = new HashSet<>();
        Set<String> seenIsbns = new HashSet<>();
        Set<String> seenBarcodes = new HashSet<>();
        preview.getWarnings().clear();
        try (Connection conn = DatabaseConnection.getConnection()) {
            for (BookImportRowDTO row : preview.getBooks()) {
                validateBookRow(conn, preview, row, seenIsbns);
                if (IsbnValidator.isValid(row.getIsbn())) {
                    availableIsbns.add(row.getIsbn().toLowerCase());
                }
            }
            for (BookImportRowDTO row : preview.getBookCopies()) {
                validateCopyRow(conn, preview, row, availableIsbns, seenBarcodes);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kiểm tra dữ liệu import với cơ sở dữ liệu.", e);
        }
    }

    void validateBookRow(Connection conn, BookImportPreviewDTO preview, BookImportRowDTO row,
            Set<String> seenIsbns)
            throws SQLException {
        row.setExistingBook(false);
        Book book = new Book();
        book.setIsbn(row.getIsbn());
        book.setTitle(row.getTitle());
        book.setAuthor(row.getAuthor());
        book.setPublisher(row.getPublisher());
        book.setPublicationYear(row.getPublicationYear());
        book.setPrice(row.getPrice());
        book.setStatus("available");
        boolean validIsbn = false;
        try {
            bookService.validate(book, true);
            row.setIsbn(book.getIsbn());
            validIsbn = true;
        } catch (ValidationException e) {
            preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), null, e.getMessage()));
        }
        if (validIsbn && !seenIsbns.add(row.getIsbn().toLowerCase())) {
            preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), "isbn",
                    "ISBN bị trùng trong trang tính Books."));
        }
        // Đầu sách đã có trên hệ thống sẽ không bị ghi đè: import chỉ dùng lại bookId sẵn có.
        // Đây là cảnh báo (không chặn import) để thủ thư biết dòng này không tạo dữ liệu mới.
        if (validIsbn
                && bookDAO.findByIsbn(conn, row.getIsbn()) != null) {
            row.setExistingBook(true);
            preview.getWarnings().add(new BookImportError("Books", row.getRowNumber(), "isbn",
                    "ISBN đã tồn tại trên hệ thống. Dòng này sẽ được bỏ qua, thông tin đầu sách hiện có "
                    + "giữ nguyên và không bị cập nhật theo tệp."));
        }
        for (String category : row.getCategories()) {
            if (category.length() > 255) {
                preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), "categories",
                        "Tên thể loại không được vượt quá 255 ký tự."));
            }
        }
        for (String tag : row.getTags()) {
            if (tag.length() > 100) {
                preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), "tags",
                        "Tên tag không được vượt quá 100 ký tự."));
            }
        }
    }

    void validateCopyRow(Connection conn, BookImportPreviewDTO preview, BookImportRowDTO row,
            Set<String> availableIsbns, Set<String> seenBarcodes) throws SQLException {
        row.setIsbn(IsbnValidator.normalize(row.getIsbn()));
        row.setBarcode(trimToNull(row.getBarcode()));
        row.setLocation(trimToNull(row.getLocation()));
        boolean hasIsbn = row.getIsbn() != null && !row.getIsbn().isBlank();
        boolean isbnValid = hasIsbn && IsbnValidator.isValid(row.getIsbn());

        // Báo tối đa một lỗi ISBN cho mỗi dòng: sai định dạng thì không xét tiếp việc
        // tham chiếu, vì ISBN sai thì chắc chắn không tìm thấy đầu sách nào.
        // Không dừng cả hàm ở đây — barcode và vị trí vẫn phải được kiểm tra để thủ thư
        // thấy đủ lỗi trong một lần xem trước, đúng như giao diện đã hứa.
        if (!hasIsbn) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "isbn",
                    "ISBN không được để trống."));
        } else if (!isbnValid) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "isbn",
                    "ISBN không hợp lệ. Vui lòng nhập ISBN-10 hoặc ISBN-13 đúng chuẩn."));
        } else if (isbnValid
                && !availableIsbns.contains(row.getIsbn().toLowerCase())
                && bookDAO.findByIsbn(conn, row.getIsbn()) == null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "isbn",
                    "ISBN không tham chiếu tới đầu sách trong tệp hoặc hệ thống."));
        }
        if (row.getBarcode() == null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch không được để trống."));
        } else if (row.getBarcode().length() > 50) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch không được vượt quá 50 ký tự."));
        } else if (!BARCODE_PATTERN.matcher(row.getBarcode()).matches()) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch chỉ được chứa chữ, số và các ký tự - _ . /."));
        } else if (!seenBarcodes.add(row.getBarcode())) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch bị trùng trong tệp import."));
        } else if (bookCopyDAO.findByBarcode(conn, row.getBarcode()) != null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch đã tồn tại trên hệ thống."));
        }
        if (row.getLocation() == null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "location",
                    "Vị trí không được để trống."));
        } else if (row.getLocation().length() > 255) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "location",
                    "Vị trí không được vượt quá 255 ký tự."));
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
