package service;

import exception.ValidationException;
import java.math.BigDecimal;
import model.Book;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class BookServiceTest {

    private BookService bookService;

    @Before
    public void setUp() {
        bookService = new BookService(null, null);
    }

    @Test
    public void validateAcceptsValidNewBook() throws Exception {
        Book book = validBook();
        bookService.validate(book, true);
        assertTrue(true);
    }

    @Test
    public void validateRejectsMissingIsbnWhenCreating() throws Exception {
        Book book = validBook();
        book.setIsbn(null);
        assertValidationMessage(book, true, "ISBN không được để trống.");
    }

    @Test
    public void validateNormalizesDashedIsbnWhenCreating() throws Exception {
        Book book = validBook();
        book.setIsbn("978-0-13-468599-1");
        bookService.validate(book, true);
        assertTrue("9780134685991".equals(book.getIsbn()));
    }

    @Test
    public void validateRejectsInvalidIsbnChecksumWhenCreating() throws Exception {
        Book book = validBook();
        book.setIsbn("9780134685992");
        assertValidationMessage(book, true, "ISBN không hợp lệ.");
    }

    @Test
    public void validateRejectsNegativePrice() throws Exception {
        Book book = validBook();
        book.setPrice(new BigDecimal("-1"));
        assertValidationMessage(book, true, "Giá sách không được âm.");
    }

    @Test
    public void validateRejectsInvalidStatus() throws Exception {
        Book book = validBook();
        book.setStatus("deleted");
        assertValidationMessage(book, false, "Trạng thái đầu sách không hợp lệ.");
    }

    private void assertValidationMessage(Book book, boolean creating, String expected) throws Exception {
        try {
            bookService.validate(book, creating);
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains(expected));
        }
    }

    private Book validBook() {
        Book book = new Book();
        book.setIsbn("9780134685991");
        book.setTitle("Lập trình Java");
        book.setAuthor("Nguyễn Văn A");
        book.setPublisher("NXB Giáo dục");
        book.setPublicationYear(2025);
        book.setPrice(new BigDecimal("100000"));
        book.setStatus("available");
        return book;
    }
}
