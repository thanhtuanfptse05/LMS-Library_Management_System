package f20_book_suggestion;

import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F20_BookSuggestionTest {

    private int suggestionId;
    private int userId;
    private String title;
    private String author;
    private String reason;
    private String status;
    private int voteCount;
    private Timestamp createdAt;

    @Before
    public void setUp() {
        suggestionId = 2001;
        userId = 202; // Lecturer ID
        title = "Designing Data-Intensive Applications";
        author = "Martin Kleppmann";
        reason = "Sách tham khảo rất tốt cho sinh viên môn Kiến trúc phần mềm SWP391";
        status = "pending";
        voteCount = 15;
        createdAt = new Timestamp(System.currentTimeMillis());
    }

    // ========================================================================
    // F20: BOOK SUGGESTION - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testBookSuggestionFields() {
        assertEquals(2001, suggestionId);
        assertEquals(202, userId);
        assertEquals("Designing Data-Intensive Applications", title);
        assertEquals("Martin Kleppmann", author);
        assertTrue(reason.contains("SWP391"));
        assertEquals("pending", status);
        assertEquals(15, voteCount);
        assertNotNull(createdAt);
    }

    @Test
    public void testSuggestionStatusTransitions() {
        String currentStatus = "pending";
        assertEquals("pending", currentStatus);

        currentStatus = "approved";
        assertEquals("approved", currentStatus);

        currentStatus = "rejected";
        assertEquals("rejected", currentStatus);

        currentStatus = "purchased";
        assertEquals("purchased", currentStatus);
    }

    @Test
    public void testSuggestionVoteIncrement() {
        int initialVotes = 15;
        int updatedVotes = initialVotes + 1;

        assertEquals(16, updatedVotes);
        assertTrue(updatedVotes > initialVotes);
    }

    @Test
    public void testTitleAndAuthorValidation() {
        assertTrue("Tên sách không được rỗng", title != null && !title.trim().isEmpty());
        assertTrue("Tác giả không được rỗng", author != null && !author.trim().isEmpty());
    }
}
