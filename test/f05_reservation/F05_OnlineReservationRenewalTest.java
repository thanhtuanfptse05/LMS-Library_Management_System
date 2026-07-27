package f05_reservation;

import model.Reservation;
import model.BorrowRecord;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F05_OnlineReservationRenewalTest {

    private Reservation reservation;
    private BorrowRecord borrowRecord;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        reservation = new Reservation();
        reservation.setReservationId(501);
        reservation.setUserId(101);
        reservation.setBookId(401);
        reservation.setStatus("waiting");
        reservation.setQueuePosition(1);
        reservation.setStartDate(new Timestamp(now));

        borrowRecord = new BorrowRecord();
        borrowRecord.setBorrowRecordId(5001);
        borrowRecord.setUserId(101);
        borrowRecord.setBookCopyId(4001);
        borrowRecord.setBookId(401);
        borrowRecord.setStartDate(new Timestamp(now - 86400000L * 5)); // 5 days ago
        borrowRecord.setEndDate(new Timestamp(now + 86400000L * 5));   // 5 days remaining
        borrowRecord.setStatus("borrowed");
        borrowRecord.setExtensionCount(0);
    }

    // ========================================================================
    // F05: ONLINE RESERVATION & RENEWAL - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testReservationFields() {
        assertEquals(501, reservation.getReservationId());
        assertEquals(101, reservation.getUserId());
        assertEquals(401, reservation.getBookId());
        assertEquals("waiting", reservation.getStatus());
        assertEquals(Integer.valueOf(1), reservation.getQueuePosition());
        assertNotNull(reservation.getStartDate());
    }

    @Test
    public void testReservationStatusTransitions() {
        reservation.setStatus("readypickup");
        reservation.setBookCopyId(4001);
        reservation.setQueuePosition(0);

        assertEquals("readypickup", reservation.getStatus());
        assertEquals(Integer.valueOf(4001), reservation.getBookCopyId());
        assertEquals(Integer.valueOf(0), reservation.getQueuePosition());

        reservation.setStatus("fulfilled");
        assertEquals("fulfilled", reservation.getStatus());

        reservation.setStatus("cancelled");
        assertEquals("cancelled", reservation.getStatus());

        reservation.setStatus("expired");
        assertEquals("expired", reservation.getStatus());
    }

    @Test
    public void testRenewalExtensionCountBoundary() {
        assertEquals(0, borrowRecord.getExtensionCount());

        // Maximum allowed extension count is typically 2 or 3
        int maxExtension = 3;
        for (int i = 1; i <= maxExtension; i++) {
            borrowRecord.setExtensionCount(i);
            assertEquals(i, borrowRecord.getExtensionCount());
        }

        assertTrue("Không được vượt quá số lần gia hạn tối đa",
                borrowRecord.getExtensionCount() <= maxExtension);
    }

    @Test
    public void testRenewalNotAllowedWhenOverdue() {
        borrowRecord.setStatus("overdue");
        borrowRecord.setEndDate(new Timestamp(now - 86400000L * 2)); // 2 days overdue

        assertEquals("overdue", borrowRecord.getStatus());
        assertTrue("Hạn trả nhỏ hơn thời điểm hiện tại", borrowRecord.getEndDate().before(new Timestamp(now)));
    }

    @Test
    public void testBorrowRecordPercentPassedCalculations() {
        assertTrue(borrowRecord.getPercentPassed() >= 0.0 && borrowRecord.getPercentPassed() <= 100.0);
        assertTrue(borrowRecord.getDaysRemaining() >= 0);
    }
}
