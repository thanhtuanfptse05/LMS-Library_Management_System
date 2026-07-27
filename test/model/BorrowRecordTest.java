package model;

import org.junit.Before;
import org.junit.Test;
import java.sql.Timestamp;
import static org.junit.Assert.*;

public class BorrowRecordTest {

    private BorrowRecord record;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();
        record = new BorrowRecord();
    }

    @Test
    public void testGetPercentPassed_NormalMiddle() {
        // Start 5 days ago, end in 5 days (total 10 days, elapsed ~50%)
        Timestamp start = new Timestamp(now - (5L * 86400000L));
        Timestamp end = new Timestamp(now + (5L * 86400000L));
        record.setStartDate(start);
        record.setEndDate(end);
        record.setStatus("borrowed");

        double percent = record.getPercentPassed();
        assertTrue("Percent passed should be around 50%", percent >= 49.0 && percent <= 51.0);
        assertEquals(50, record.getPercentPassedInt());
        assertEquals("bg-primary-custom", record.getBarColorClass());
    }

    @Test
    public void testGetPercentPassed_NearDueWarning() {
        // Start 9 days ago, end in 1 day (total 10 days, elapsed ~90%)
        Timestamp start = new Timestamp(now - (9L * 86400000L));
        Timestamp end = new Timestamp(now + (1L * 86400000L));
        record.setStartDate(start);
        record.setEndDate(end);
        record.setStatus("borrowed");

        assertTrue(record.getPercentPassed() >= 85.0);
        assertEquals("bg-warning", record.getBarColorClass());
    }

    @Test
    public void testGetPercentPassed_Overdue() {
        // Start 15 days ago, end 5 days ago
        Timestamp start = new Timestamp(now - (15L * 86400000L));
        Timestamp end = new Timestamp(now - (5L * 86400000L));
        record.setStartDate(start);
        record.setEndDate(end);
        record.setStatus("overdue");

        assertEquals(100.0, record.getPercentPassed(), 0.001);
        assertEquals(100, record.getPercentPassedInt());
        assertEquals("bg-danger", record.getBarColorClass());
    }

    @Test
    public void testGetDaysRemaining() {
        // End in 3 days
        Timestamp end = new Timestamp(now + (3L * 86400000L));
        record.setEndDate(end);

        assertTrue(record.getDaysRemaining() >= 2 && record.getDaysRemaining() <= 4);
    }
}
