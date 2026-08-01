package f06_desk_circ;

import model.BorrowRecord;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F06_RecallBookEmailTest {

    private BorrowRecord borrowRecord;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();
        borrowRecord = new BorrowRecord();
        borrowRecord.setBorrowRecordId(801);
        borrowRecord.setUserId(301);
        borrowRecord.setBookCopyId(6005);
        borrowRecord.setBookId(405);
        borrowRecord.setStartDate(new Timestamp(now - 86400000L * 10)); // 10 days ago
        borrowRecord.setEndDate(new Timestamp(now + 86400000L * 4));   // 4 days left
        borrowRecord.setStatus("borrowed");
    }

    @Test
    public void testRecallNoticeParameters() {
        String recallReason = "Thu hồi sách phục vụ môn học mới";
        Integer librarianId = 50;

        assertNotNull(borrowRecord.getBorrowRecordId());
        assertNotNull(borrowRecord.getUserId());
        assertEquals("borrowed", borrowRecord.getStatus());
        assertNotNull(recallReason);
        assertFalse(recallReason.trim().isEmpty());
        assertEquals(Integer.valueOf(50), librarianId);
    }

    @Test
    public void testOverdueBorrowRecordFilterUnpaidOnly() {
        borrowRecord.setStatus("overdue");
        
        // Active overdue record without returnedAt date (unpaid / active overdue)
        assertNull(borrowRecord.getReturnedAt());
        assertEquals("overdue", borrowRecord.getStatus());

        // Once returned and fine paid, returnedAt is non-null
        borrowRecord.setReturnedAt(new Timestamp(now));
        borrowRecord.setStatus("returned");
        assertNotNull(borrowRecord.getReturnedAt());
        assertEquals("returned", borrowRecord.getStatus());
    }
}
