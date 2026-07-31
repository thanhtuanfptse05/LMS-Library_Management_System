package f05_reservation;

import model.Reservation;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

/**
 * LibrarianReservationQueueTest — Unit test kiểm thử mô hình và bộ lọc hàng chờ cho Thủ thư.
 */
public class LibrarianReservationQueueTest {

    private Reservation reservation1;
    private Reservation reservation2;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        reservation1 = new Reservation();
        reservation1.setReservationId(601);
        reservation1.setUserId(201);
        reservation1.setBookId(301);
        reservation1.setStatus("pending");
        reservation1.setQueuePosition(1);
        reservation1.setStartDate(new Timestamp(now));
        reservation1.setMemberName("Nguyễn Văn A");
        reservation1.setMemberCode("HE150001");
        reservation1.setBookTitle("Giáo trình Lap trinh Java");

        reservation2 = new Reservation();
        reservation2.setReservationId(602);
        reservation2.setUserId(202);
        reservation2.setBookId(301);
        reservation2.setStatus("readypickup");
        reservation2.setQueuePosition(0);
        reservation2.setStartDate(new Timestamp(now - 3600000L));
        reservation2.setEndDate(new Timestamp(now + 86400000L * 3));
        reservation2.setMemberName("Trần Thị B");
        reservation2.setMemberCode("GV001");
        reservation2.setBookTitle("Giáo trình Lap trinh Java");
    }

    @Test
    public void testReservationQueueFields() {
        assertEquals(601, reservation1.getReservationId());
        assertEquals(201, reservation1.getUserId());
        assertEquals(301, reservation1.getBookId());
        assertEquals("pending", reservation1.getStatus());
        assertEquals(Integer.valueOf(1), reservation1.getQueuePosition());
        assertEquals("Nguyễn Văn A", reservation1.getMemberName());
        assertEquals("HE150001", reservation1.getMemberCode());
        assertEquals("Giáo trình Lap trinh Java", reservation1.getBookTitle());
    }

    @Test
    public void testReadyPickupQueuePositionZero() {
        assertEquals("readypickup", reservation2.getStatus());
        assertEquals(Integer.valueOf(0), reservation2.getQueuePosition());
        assertNull(reservation2.getBookCopyId()); // Phù hợp quy tắc 100% no-bookCopy
        assertNotNull(reservation2.getEndDate());
    }

    @Test
    public void testQueueCancellationShift() {
        List<Reservation> queue = new ArrayList<>();
        queue.add(reservation2); // position 0
        queue.add(reservation1); // position 1

        // Giả lập khi Hủy đơn position 0
        queue.remove(0); // Hủy đơn 602
        Reservation nextInQueue = queue.get(0); // Độc giả 601 đôn lên position 0
        nextInQueue.setQueuePosition(0);
        nextInQueue.setStatus("readypickup");
        nextInQueue.setEndDate(new Timestamp(now + 86400000L * 3));

        assertEquals(601, nextInQueue.getReservationId());
        assertEquals(Integer.valueOf(0), nextInQueue.getQueuePosition());
        assertEquals("readypickup", nextInQueue.getStatus());
    }
}
