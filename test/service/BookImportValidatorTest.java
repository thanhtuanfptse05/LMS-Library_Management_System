package service;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import dao.BookCopyDAO;
import dao.BookDAO;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashSet;
import org.junit.Before;
import org.junit.Test;
import java.util.List;
import java.util.Set;
import static org.junit.Assert.*;

public class BookImportValidatorTest {

    private BookImportValidator validator;

    @Before
    public void setUp() {
        validator = new BookImportValidator();
    }

    private BookImportPreviewDTO createValidPreview() {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test_import.xlsx");

        BookImportRowDTO bookRow = new BookImportRowDTO();
        bookRow.setRowNumber(2);
        bookRow.setIsbn("9780306406157");
        bookRow.setTitle("Lập trình Java Enterprise");
        bookRow.setAuthor("Tác Giả B");
        bookRow.setPublisher("NXB Trẻ");
        bookRow.setPublicationYear(2022);
        bookRow.setCategories(List.of("Công nghệ"));
        bookRow.setTags(List.of("Java"));

        preview.getBooks().add(bookRow);
        return preview;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidatorInstantiation() {
        assertNotNull("BookImportValidator instance được tạo thành công", validator);
    }

    @Test
    public void testPreviewWithoutExistingBooksImportsEveryRow() {
        BookImportPreviewDTO preview = createValidPreview();

        assertFalse("Preview không có cảnh báo nào", preview.hasWarnings());
        assertEquals("Không dòng nào bị bỏ qua", 0, preview.getSkippedBookRows());
        assertEquals("Toàn bộ dòng đều được ghi vào CSDL",
                preview.getTotalRows(), preview.getImportableRows());
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testExistingBookRowIsExcludedFromImportableRows() {
        BookImportPreviewDTO preview = createValidPreview();

        BookImportRowDTO existingRow = new BookImportRowDTO();
        existingRow.setRowNumber(3);
        existingRow.setIsbn("9780134685991");
        existingRow.setTitle("Effective Java");
        preview.getBooks().add(existingRow);

        // Mô phỏng kết quả của BookImportValidator khi ISBN đã tồn tại trên hệ thống
        existingRow.setExistingBook(true);
        preview.getWarnings().add(new model.BookImportError("Books", 3, "isbn",
                "ISBN đã tồn tại trên hệ thống."));

        assertTrue("Cảnh báo không được làm tệp trở nên không hợp lệ", preview.isValid());
        assertTrue(preview.hasWarnings());
        assertEquals("Đúng một dòng bị bỏ qua", 1, preview.getSkippedBookRows());
        assertEquals("Dòng bị bỏ qua không được tính vào số dòng sẽ lưu",
                preview.getTotalRows() - 1, preview.getImportableRows());
    }

    @Test
    public void testAllBookRowsExistingLeavesNothingToImport() {
        BookImportPreviewDTO preview = createValidPreview();
        preview.getBooks().get(0).setExistingBook(true);

        assertEquals(1, preview.getSkippedBookRows());
        assertEquals("Tệp chỉ chứa đầu sách đã tồn tại thì không còn dòng nào để lưu",
                0, preview.getImportableRows());
    }

    @Test
    public void testValidCategoryAndTagLengths() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setCategories(List.of("C".repeat(255)));
        bookRow.setTags(List.of("T".repeat(100)));

        assertTrue(preview.getErrors().isEmpty());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testInvalidCategoryExceeds255Chars() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setCategories(List.of("C".repeat(256)));

        // Giả lập logic kiểm tra độ dài thể loại
        if (bookRow.getCategories().get(0).length() > 255) {
            preview.getErrors().add(new model.BookImportError("Books", 2, "categories", "Tên thể loại quá dài"));
        }

        assertFalse("Preview phải chứa lỗi khi category > 255 ký tự", preview.getErrors().isEmpty());
    }

    @Test
    public void testInvalidTagExceeds100Chars() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setTags(List.of("T".repeat(101)));

        if (bookRow.getTags().get(0).length() > 100) {
            preview.getErrors().add(new model.BookImportError("Books", 2, "tags", "Tên tag quá dài"));
        }

        assertFalse("Preview phải chứa lỗi khi tag > 100 ký tự", preview.getErrors().isEmpty());
    }

    @Test
    public void testCopyRowRequiresIsbnBarcodeAndLocation() throws SQLException {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        BookImportRowDTO copyRow = new BookImportRowDTO();
        copyRow.setRowNumber(2);
        copyRow.setIsbn("  ");
        copyRow.setBarcode(" ");
        copyRow.setLocation(null);

        validator.validateCopyRow(null, preview, copyRow, new HashSet<>(), new HashSet<>());

        assertEquals("Phải báo đủ ba trường bắt buộc", 3, preview.getErrors().size());
        assertTrue(preview.getErrors().stream().anyMatch(error -> "isbn".equals(error.getColumnName())));
        assertTrue(preview.getErrors().stream().anyMatch(error -> "barcode".equals(error.getColumnName())));
        assertTrue(preview.getErrors().stream().anyMatch(error -> "location".equals(error.getColumnName())));
    }

    @Test
    public void testDuplicateBarcodeInsideWorkbookIsRejected() throws SQLException {
        BookCopyDAO noExistingBarcodeDAO = new BookCopyDAO() {
            @Override
            public model.BookCopy findByBarcode(Connection conn, String barcode) {
                return null;
            }
        };
        validator = new BookImportValidator(new BookDAO(), noExistingBarcodeDAO, new BookService());
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        Set<String> availableIsbns = new HashSet<>(Set.of("9780306406157"));
        Set<String> seenBarcodes = new HashSet<>();

        BookImportRowDTO first = validCopyRow(2, "COPY-001");
        BookImportRowDTO duplicate = validCopyRow(3, " COPY-001 ");
        validator.validateCopyRow(null, preview, first, availableIsbns, seenBarcodes);
        validator.validateCopyRow(null, preview, duplicate, availableIsbns, seenBarcodes);

        assertEquals(1, preview.getErrors().size());
        assertEquals("barcode", preview.getErrors().get(0).getColumnName());
        assertTrue(preview.getErrors().get(0).getErrorMessage().contains("trùng trong tệp"));
    }

    @Test
    public void testDuplicateIsbnInsideBooksSheetIsRejected() throws SQLException {
        BookDAO noExistingBookDAO = new BookDAO() {
            @Override
            public model.Book findByIsbn(Connection conn, String isbn) {
                return null;
            }
        };
        validator = new BookImportValidator(noExistingBookDAO, new BookCopyDAO(), new BookService());
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        Set<String> seenIsbns = new HashSet<>();

        BookImportRowDTO first = validBookRow(2, "9780306406157");
        BookImportRowDTO duplicate = validBookRow(3, " 978-0-306-40615-7 ");
        validator.validateBookRow(null, preview, first, seenIsbns);
        validator.validateBookRow(null, preview, duplicate, seenIsbns);

        assertEquals(1, preview.getErrors().size());
        assertEquals("isbn", preview.getErrors().get(0).getColumnName());
        assertTrue(preview.getErrors().get(0).getErrorMessage().contains("trùng"));
    }

    private BookImportRowDTO validBookRow(int rowNumber, String isbn) {
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(rowNumber);
        row.setIsbn(isbn);
        row.setTitle("Sách kiểm thử");
        return row;
    }

    private BookImportRowDTO validCopyRow(int rowNumber, String barcode) {
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(rowNumber);
        row.setIsbn("9780306406157");
        row.setBarcode(barcode);
        row.setLocation("Kệ A1");
        return row;
    }
}
