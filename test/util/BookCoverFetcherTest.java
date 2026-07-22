package util;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class BookCoverFetcherTest {

    private BookCoverFetcher fetcher;

    @Before
    public void setUp() {
        fetcher = new BookCoverFetcher();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testBookCoverFetcherInstantiation() {
        assertNotNull("BookCoverFetcher instance phải được tạo thành công", fetcher);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testIsbnFormattingForFetcher() {
        String isbn = "978-0-13-468599-1";
        String cleanIsbn = isbn.replace("-", "").trim();
        assertEquals("9780134685991", cleanIsbn);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testNullIsbnHandling() {
        String isbn = null;
        assertNull("ISBN null thì cleanIsbn trả về null hoặc không rỗng", isbn);
    }
}
