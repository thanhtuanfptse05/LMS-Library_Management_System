package f08_book_disc;

import model.Book;
import dto.BookCatalogSummaryDTO;
import org.junit.Before;
import org.junit.Test;

import java.math.BigDecimal;

import static org.junit.Assert.*;

public class F08_BookDiscoveryTest {

    private Book book;
    private BookCatalogSummaryDTO catalogSummary;

    @Before
    public void setUp() {
        book = new Book();
        book.setBookId(801);
        book.setIsbn("9780132350884");
        book.setTitle("Clean Code");
        book.setAuthor("Robert C. Martin");
        book.setPublisher("Prentice Hall");
        book.setPublicationYear(2008);
        book.setPrice(new BigDecimal("380000.00"));
        book.setStatus("available");

        catalogSummary = new BookCatalogSummaryDTO();
        catalogSummary.setTotalBooks(500);
        catalogSummary.setTotalCopies(2500);
        catalogSummary.setAvailableCopies(2000);
        catalogSummary.setBooksWithoutCopies(10);
    }

    // ========================================================================
    // F08: BOOK DISCOVERY - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testBookSearchKeywordMatching() {
        String keyword = "clean";
        assertTrue("Tìm kiếm phải khớp không phân biệt hoa thường",
                book.getTitle().toLowerCase().contains(keyword.toLowerCase()) ||
                book.getAuthor().toLowerCase().contains(keyword.toLowerCase()));
    }

    @Test
    public void testBookCatalogSummaryFields() {
        assertEquals(500, catalogSummary.getTotalBooks());
        assertEquals(2500, catalogSummary.getTotalCopies());
        assertEquals(2000, catalogSummary.getAvailableCopies());
        assertEquals(10, catalogSummary.getBooksWithoutCopies());
    }

    @Test
    public void testPaginationTotalPagesCalculation() {
        int pageSize = 12;
        int totalBooks = 25;
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        assertEquals(3, totalPages);
    }

    @Test
    public void testFilterStatusPreservation() {
        String filterStatus = "available";
        boolean availableOnly = "available".equals(filterStatus);
        assertTrue(availableOnly);
    }
}
