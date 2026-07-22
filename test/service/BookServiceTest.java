package service;

import exception.ValidationException;
import model.Book;
import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.time.Year;
import static org.junit.Assert.*;

public class BookServiceTest {

    private BookService bookService;

    @Before
    public void setUp() {
        bookService = new BookService();
    }

    private Book createValidBook() {
        Book book = new Book();
        book.setIsbn("9780306406157");
        book.setTitle("Lập Trình Java Web Monolith");
        book.setAuthor("Tác Giả A");
        book.setPublisher("NXB Giáo Dục");
        book.setPublicationYear(2023);
        book.setPrice(new BigDecimal("150000"));
        book.setStatus("available");
        return book;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidBookCreation() throws ValidationException {
        Book book = createValidBook();
        bookService.validate(book, true);
        assertEquals("9780306406157", book.getIsbn());
    }

    @Test
    public void testValidateValidBookUpdate() throws ValidationException {
        Book book = createValidBook();
        book.setBookId(1);
        bookService.validate(book, false);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryPublicationYear() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(1000); // Năm tối thiểu
        bookService.validate(book, true);

        book.setPublicationYear(Year.now().getValue() + 1); // Năm tối đa (năm sau)
        bookService.validate(book, true);
    }

    @Test
    public void testValidateBoundaryTitleLength500() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("A".repeat(500));
        bookService.validate(book, true);
    }

    @Test
    public void testValidateBoundaryZeroPrice() throws ValidationException {
        Book book = createValidBook();
        book.setPrice(BigDecimal.ZERO);
        bookService.validate(book, true);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullIsbnOnCreation() throws ValidationException {
        Book book = createValidBook();
        book.setIsbn(null);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidIsbnFormatOnCreation() throws ValidationException {
        Book book = createValidBook();
        book.setIsbn("123456");
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankTitle() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("   ");
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateTitleExceeds500Chars() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("A".repeat(501));
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidPublicationYearTooOld() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(999);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidPublicationYearInFuture() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(Year.now().getValue() + 2);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNegativePrice() throws ValidationException {
        Book book = createValidBook();
        book.setPrice(new BigDecimal("-1000"));
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Book book = createValidBook();
        book.setStatus("deleted");
        bookService.validate(book, true);
    }
}
