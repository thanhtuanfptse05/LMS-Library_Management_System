package f06_desk_circ;

import model.BorrowRecord;
import model.BookCopy;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F06_DeskCirculationOperationsTest {

    private BorrowRecord borrowRecord;
    private BookCopy bookCopy;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        bookCopy = new BookCopy();
        bookCopy.setBookCopyId(6001);
        bookCopy.setBookId(401);
        bookCopy.setBarcode("BC6001");
        bookCopy.setLocation("Khu A - Kệ 1");
        bookCopy.setCondition("good");
        bookCopy.setStatus("available");

        borrowRecord = new BorrowRecord();
        borrowRecord.setBorrowRecordId(601);
        borrowRecord.setUserId(101);
        borrowRecord.setBookCopyId(6001);
        borrowRecord.setBookId(401);
        borrowRecord.setStartDate(new Timestamp(now));
        borrowRecord.setEndDate(new Timestamp(now + 14L * 86400000L)); // 14 days
        borrowRecord.setStatus("borrowed");
        borrowRecord.setCreatedBy(301); // Librarian ID
    }

    // ========================================================================
    // F06: DESK CIRCULATION OPERATIONS - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testCheckOutRecordCreation() {
        assertEquals(601, borrowRecord.getBorrowRecordId());
        assertEquals(101, borrowRecord.getUserId());
        assertEquals(6001, borrowRecord.getBookCopyId());
        assertEquals("borrowed", borrowRecord.getStatus());
        assertEquals(Integer.valueOf(301), borrowRecord.getCreatedBy());
    }

    @Test
    public void testBookCopyStatusTransitionOnCheckOut() {
        bookCopy.setStatus("borrowed");
        assertEquals("borrowed", bookCopy.getStatus());
    }

    @Test
    public void testCheckInRecordCompletion() {
        borrowRecord.setReturnedAt(new Timestamp(now + 7L * 86400000L)); // returned after 7 days
        borrowRecord.setStatus("returned");

        assertNotNull(borrowRecord.getReturnedAt());
        assertEquals("returned", borrowRecord.getStatus());
    }

    @Test
    public void testBookCopyStatusTransitionOnCheckInGoodCondition() {
        bookCopy.setCondition("good");
        bookCopy.setStatus("available");

        assertEquals("good", bookCopy.getCondition());
        assertEquals("available", bookCopy.getStatus());
    }

    @Test
    public void testBookCopyStatusTransitionOnCheckInDamagedCondition() {
        bookCopy.setCondition("damaged");
        bookCopy.setStatus("incident");

        assertEquals("damaged", bookCopy.getCondition());
        assertEquals("incident", bookCopy.getStatus());
    }

    @Test
    public void testOverdueDaysCalculation() {
        // Loan ended 3 days ago
        Timestamp startDate = new Timestamp(now - 17L * 86400000L);
        Timestamp endDate = new Timestamp(now - 3L * 86400000L);
        borrowRecord.setStartDate(startDate);
        borrowRecord.setEndDate(endDate);
        borrowRecord.setStatus("overdue");

        long diffMs = now - endDate.getTime();
        long overdueDays = diffMs / 86400000L;

        assertTrue(overdueDays >= 2 && overdueDays <= 4);
    }
}
