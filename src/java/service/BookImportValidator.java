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
        try (Connection conn = DatabaseConnection.getConnection()) {
            for (BookImportRowDTO row : preview.getBooks()) {
                validateBookRow(preview, row);
                if (row.getIsbn() != null && !row.getIsbn().isBlank()) {
                    availableIsbns.add(row.getIsbn().toLowerCase());
                }
            }
            for (BookImportRowDTO row : preview.getBookCopies()) {
                validateCopyRow(conn, preview, row, availableIsbns);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kiểm tra dữ liệu import với cơ sở dữ liệu.", e);
        }
    }

    private void validateBookRow(BookImportPreviewDTO preview, BookImportRowDTO row) {
        Book book = new Book();
        book.setIsbn(row.getIsbn());
        book.setTitle(row.getTitle());
        book.setAuthor(row.getAuthor());
        book.setPublisher(row.getPublisher());
        book.setPublicationYear(row.getPublicationYear());
        book.setPrice(row.getPrice());
        book.setStatus("available");
        try {
            bookService.validate(book, true);
            row.setIsbn(book.getIsbn());
        } catch (ValidationException e) {
            preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), null, e.getMessage()));
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

    private void validateCopyRow(Connection conn, BookImportPreviewDTO preview, BookImportRowDTO row,
            Set<String> availableIsbns) throws SQLException {
        row.setIsbn(IsbnValidator.normalize(row.getIsbn()));
        if (row.getIsbn() != null && !row.getIsbn().isBlank() && !IsbnValidator.isValid(row.getIsbn())) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "isbn",
                    "ISBN không hợp lệ. Vui lòng nhập ISBN-10 hoặc ISBN-13 đúng chuẩn."));
            return;
        }
        if (row.getIsbn() != null && !row.getIsbn().isBlank()
                && !availableIsbns.contains(row.getIsbn().toLowerCase())
                && bookDAO.findByIsbn(conn, row.getIsbn()) == null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "isbn",
                    "ISBN không tham chiếu tới đầu sách trong tệp hoặc hệ thống."));
        }
        if (row.getBarcode() != null && row.getBarcode().length() > 50) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch không được vượt quá 50 ký tự."));
        } else if (row.getBarcode() != null && !row.getBarcode().isBlank()
                && !BARCODE_PATTERN.matcher(row.getBarcode()).matches()) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch chỉ được chứa chữ, số và các ký tự - _ . /."));
        } else if (row.getBarcode() != null && !row.getBarcode().isBlank()
                && bookCopyDAO.findByBarcode(conn, row.getBarcode()) != null) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                    "Mã vạch đã tồn tại trên hệ thống."));
        }
        if (row.getLocation() != null && row.getLocation().length() > 255) {
            preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "location",
                    "Vị trí không được vượt quá 255 ký tự."));
        }
    }
}
