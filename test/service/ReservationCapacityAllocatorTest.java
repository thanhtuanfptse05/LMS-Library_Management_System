package service;

import dao.AuditLogDAO;
import dao.BookDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import java.sql.Connection;
import java.sql.SQLException;
import model.Book;
import model.Reservation;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ReservationCapacityAllocatorTest {

    private FakeReservationDAO reservationDAO;
    private FakeBookDAO bookDAO;
    private FakeAuditLogDAO auditLogDAO;
    private ReservationCapacityAllocator allocator;
    private Book book;

    @Before
    public void setUp() {
        reservationDAO = new FakeReservationDAO();
        bookDAO = new FakeBookDAO();
        auditLogDAO = new FakeAuditLogDAO();
        allocator = new ReservationCapacityAllocator(reservationDAO, bookDAO, auditLogDAO,
                new FixedSystemConfigDAO(), new UserDAO(), new MemberProfileDAO());
        book = new Book();
        book.setBookId(10);
        book.setTitle("Sách kiểm thử");
        book.setStatus("available");
    }

    @Test
    public void newCopyPromotesFirstPendingReservationWithoutIncreasingAvailableQuantity()
            throws SQLException {
        Reservation pending = new Reservation();
        pending.setReservationId(101);
        pending.setUserId(201);
        pending.setBookId(10);
        pending.setStatus("pending");
        pending.setQueuePosition(1);
        reservationDAO.next = pending;

        Reservation promoted = allocator.registerNewCopy(null, book, 1, "test");

        assertSame(pending, promoted);
        assertEquals(1, bookDAO.totalDelta);
        assertEquals(0, bookDAO.availableDelta);
        assertEquals(101, reservationDAO.promotedReservationId);
        assertTrue(reservationDAO.queueDecremented);
        assertTrue(auditLogDAO.inserted);
    }

    @Test
    public void newCopyIncreasesAvailableQuantityWhenQueueIsEmpty() throws SQLException {
        Reservation promoted = allocator.registerNewCopy(null, book, 1, "test");

        assertNull(promoted);
        assertEquals(1, bookDAO.totalDelta);
        assertEquals(1, bookDAO.availableDelta);
        assertFalse(reservationDAO.queueDecremented);
    }

    @Test
    public void newCopyOfStoppedBookOnlyIncreasesTotalQuantity() throws SQLException {
        book.setStatus("unavailable");

        Reservation promoted = allocator.registerNewCopy(null, book, 1, "test");

        assertNull(promoted);
        assertEquals(1, bookDAO.totalDelta);
        assertEquals(0, bookDAO.availableDelta);
        assertEquals(0, reservationDAO.findCalls);
    }

    private static final class FakeReservationDAO extends ReservationDAO {
        private Reservation next;
        private int findCalls;
        private int promotedReservationId;
        private boolean queueDecremented;

        @Override
        public Reservation findNextInQueue(Connection conn, int bookId) {
            findCalls++;
            return next;
        }

        @Override
        public void updateToReadyPickupWithoutCopy(Connection conn, int reservationId, int holdDays) {
            promotedReservationId = reservationId;
            assertEquals(3, holdDays);
        }

        @Override
        public void decrementQueuePositions(Connection conn, int bookId) {
            queueDecremented = true;
        }
    }

    private static final class FakeBookDAO extends BookDAO {
        private int totalDelta;
        private int availableDelta;

        @Override
        public void updateQuantities(Connection conn, int bookId, int totalDelta, int availableDelta) {
            this.totalDelta += totalDelta;
            this.availableDelta += availableDelta;
        }
    }

    private static final class FakeAuditLogDAO extends AuditLogDAO {
        private boolean inserted;

        @Override
        public void insert(Connection conn, Integer userId, String actionType, String entityName,
                Integer entityId, String oldValues, String newValues) {
            inserted = true;
        }
    }

    private static final class FixedSystemConfigDAO extends SystemConfigDAO {
        @Override
        public int getIntValue(Connection conn, String key, int defaultValue) {
            return 3;
        }
    }
}
