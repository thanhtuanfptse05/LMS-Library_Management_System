package service;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public class BookImportServiceTest {

    private BookImportService importService;

    @Before
    public void setUp() {
        importService = new BookImportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testBookImportServiceInstantiation() {
        assertNotNull("BookImportService phải được khởi tạo thành công", importService);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidatePreviewWithErrors() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("books_test.xlsx");
        List<BookImportRowDTO> books = new ArrayList<>();
        BookImportRowDTO invalidBook = new BookImportRowDTO();
        invalidBook.setIsbn("INVALID-ISBN");
        invalidBook.setTitle("");
        books.add(invalidBook);
        preview.setBooks(books);

        importService.validate(preview, 1);
        assertFalse("Preview không hợp lệ phải trả về false", preview.isValid());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testValidateEmptyPreview() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("empty.xlsx");
        preview.setBooks(new ArrayList<>());
        preview.setBookCopies(new ArrayList<>());

        importService.validate(preview, 1);
        assertNotNull(preview.getErrors());
    }
}
