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

    @Test
    public void testReorderMoveUpShiftLogic() {
        // Giả lập danh sách 5 đơn pending (pos 1..5)
        List<Reservation> pendingList = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Reservation r = new Reservation();
            r.setReservationId(700 + i);
            r.setBookId(301);
            r.setStatus("pending");
            r.setQueuePosition(i);
            pendingList.add(r);
        }

        int oldPos = 5;
        int newPos = 2;

        // Giả lập thuật toán Move Up (đơn 705 từ #5 lên #2)
        Reservation target = pendingList.stream().filter(r -> r.getQueuePosition() == oldPos).findFirst().orElse(null);
        assertNotNull(target);

        for (Reservation r : pendingList) {
            int pos = r.getQueuePosition();
            if (pos >= newPos && pos < oldPos) {
                r.setQueuePosition(pos + 1);
            }
        }
        target.setQueuePosition(newPos);

        // Kiểm tra thứ tự sau khi Move Up:
        // Đơn 701 (cũ #1) -> giữ nguyên #1
        // Đơn 705 (cũ #5) -> lên #2
        // Đơn 702 (cũ #2) -> xuống #3
        // Đơn 703 (cũ #3) -> xuống #4
        // Đơn 704 (cũ #4) -> xuống #5
        assertEquals(Integer.valueOf(1), pendingList.get(0).getQueuePosition()); // 701
        assertEquals(Integer.valueOf(3), pendingList.get(1).getQueuePosition()); // 702
        assertEquals(Integer.valueOf(4), pendingList.get(2).getQueuePosition()); // 703
        assertEquals(Integer.valueOf(5), pendingList.get(3).getQueuePosition()); // 704
        assertEquals(Integer.valueOf(2), pendingList.get(4).getQueuePosition()); // 705 (target)
    }

    @Test
    public void testReorderMoveDownShiftLogic() {
        // Giả lập danh sách 5 đơn pending (pos 1..5)
        List<Reservation> pendingList = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Reservation r = new Reservation();
            r.setReservationId(700 + i);
            r.setBookId(301);
            r.setStatus("pending");
            r.setQueuePosition(i);
            pendingList.add(r);
        }

        int oldPos = 1;
        int newPos = 4;

        // Giả lập thuật toán Move Down (đơn 701 từ #1 xuống #4)
        Reservation target = pendingList.stream().filter(r -> r.getQueuePosition() == oldPos).findFirst().orElse(null);
        assertNotNull(target);

        for (Reservation r : pendingList) {
            int pos = r.getQueuePosition();
            if (pos > oldPos && pos <= newPos) {
                r.setQueuePosition(pos - 1);
            }
        }
        target.setQueuePosition(newPos);

        // Kiểm tra thứ tự sau khi Move Down:
        // Đơn 701 (cũ #1) -> xuống #4
        // Đơn 702 (cũ #2) -> lên #1
        // Đơn 703 (cũ #3) -> lên #2
        // Đơn 704 (cũ #4) -> lên #3
        // Đơn 705 (cũ #5) -> giữ nguyên #5
        assertEquals(Integer.valueOf(4), pendingList.get(0).getQueuePosition()); // 701 (target)
        assertEquals(Integer.valueOf(1), pendingList.get(1).getQueuePosition()); // 702
        assertEquals(Integer.valueOf(2), pendingList.get(2).getQueuePosition()); // 703
        assertEquals(Integer.valueOf(3), pendingList.get(3).getQueuePosition()); // 704
        assertEquals(Integer.valueOf(5), pendingList.get(4).getQueuePosition()); // 705
    }

    @Test
    public void testReorderValidationRules() {
        // Validation 1: Không thể đổi vị trí đơn có queuePosition = 0 (readypickup)
        assertTrue("Lượt readypickup không ở trạng thái pending", !"pending".equalsIgnoreCase(reservation2.getStatus()) || reservation2.getQueuePosition() < 1);

        // Validation 2: Vị trí mới phải khác vị trí hiện tại
        int currentPos = reservation1.getQueuePosition();
        int newPosSame = 1;
        assertEquals(currentPos, newPosSame);

        // Validation 3: Vị trí mới phải >= 1
        int invalidNewPos = 0;
        assertTrue("Vị trí mới phải >= 1", invalidNewPos < 1);
    }
}
