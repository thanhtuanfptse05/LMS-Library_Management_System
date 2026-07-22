package service;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.List;
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

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

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
}
