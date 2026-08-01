package f05_reservation;

import model.Reservation;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F05_CancelReservationWithReasonTest {

    private Reservation reservation;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();
        reservation = new Reservation();
        reservation.setReservationId(701);
        reservation.setUserId(201);
        reservation.setBookId(501);
        reservation.setStatus("readypickup");
        reservation.setQueuePosition(0);
        reservation.setStartDate(new Timestamp(now - 86400000L));
        reservation.setEndDate(new Timestamp(now + 86400000L * 2));
    }

    @Test
    public void testCancelReservationByLibrarianWithReason() {
        String cancelReason = "Độc giả yêu cầu hủy đơn qua điện thoại";
        reservation.setStatus("cancelled");
        reservation.setCancelReason(cancelReason);

        assertEquals("cancelled", reservation.getStatus());
        assertEquals("Độc giả yêu cầu hủy đơn qua điện thoại", reservation.getCancelReason());
    }

    @Test
    public void testCancelReasonDefaultOrNull() {
        assertNull(reservation.getCancelReason());
        
        String defaultReason = "Thủ thư hủy từ hàng chờ";
        reservation.setCancelReason(defaultReason);
        assertEquals("Thủ thư hủy từ hàng chờ", reservation.getCancelReason());
    }

    @Test
    public void testExpiredReservationReason() {
        String expiredReason = "Expired - không nhận sách trong thời hạn";
        reservation.setStatus("cancelled");
        reservation.setCancelReason(expiredReason);

        assertEquals("cancelled", reservation.getStatus());
        assertTrue(reservation.getCancelReason().contains("Expired"));
    }
}
