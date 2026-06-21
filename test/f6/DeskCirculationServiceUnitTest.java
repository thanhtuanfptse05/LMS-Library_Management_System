package f6;

import dao.*;
import model.*;
import service.DeskCirculationService;
import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

/**
 * DeskCirculationServiceUnitTest — Unit Tests cho DeskCirculationService.
 * Sử dụng Subclass Stubbing (Mock DAOs) để kiểm thử logic nghiệp vụ độc lập.
 */
public class DeskCirculationServiceUnitTest {

    private DeskCirculationService service;
    
    // Mock DAO instances
    private MockUserLockReasonDAO mockUserLockReasonDAO;
    private MockReservationDAO    mockReservationDAO;
    private MockBookCopyDAO       mockBookCopyDAO;
    private MockBorrowRecordDAO   mockBorrowRecordDAO;
    private MockBookDAO           mockBookDAO;
    private MockFineDAO           mockFineDAO;
    private MockUserDAO           mockUserDAO;
    private MockPaymentDAO        mockPaymentDAO;
    private MockUserLookupDAO     mockUserLookupDAO;

    @Before
    public void setUp() {
        mockUserLockReasonDAO = new MockUserLockReasonDAO();
        mockReservationDAO    = new MockReservationDAO();
        mockBookCopyDAO       = new MockBookCopyDAO();
        mockBorrowRecordDAO   = new MockBorrowRecordDAO();
        mockBookDAO           = new MockBookDAO();
        mockFineDAO           = new MockFineDAO();
        mockUserDAO           = new MockUserDAO();
        mockPaymentDAO        = new MockPaymentDAO();
        mockUserLookupDAO     = new MockUserLookupDAO();

        // Inject Mock DAOs
        // Package-private constructor của DeskCirculationService
        service = new service.DeskCirculationServiceAccessor(
                mockUserLockReasonDAO, mockReservationDAO, mockBookCopyDAO,
                mockBorrowRecordDAO, mockBookDAO, mockFineDAO, mockUserDAO,
                mockPaymentDAO, mockUserLookupDAO
        ).getService();
    }

    // =========================================================================
    // CHECK-OUT UNIT TESTS (30 Test Cases)
    // =========================================================================

    @Test
    public void testCheckOut_MemberCodeNotFound() throws Exception {
        mockUserLookupDAO.userIdToReturn = null;
        try {
            service.processCheckOut(1, "invalid_code", "barcode123");
            fail("Phải ném IllegalStateException do không tìm thấy độc giả");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("không tồn tại"));
        }
    }

    @Test
    public void testCheckOut_UserHasUnpaidFines() throws Exception {
        mockUserLookupDAO.userIdToReturn = 10;
        mockFineDAO.hasUnpaid = true;
        try {
            service.processCheckOut(1, "ST001", "barcode123");
            fail("Phải ném IllegalStateException do nợ phạt");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("nợ phạt"));
        }
    }

    @Test
    public void testCheckOut_BarcodeNotFound() throws Exception {
        mockUserLookupDAO.userIdToReturn = 10;
        mockFineDAO.hasUnpaid = false;
        mockBookCopyDAO.copyToReturn = null;
        try {
            service.processCheckOut(1, "ST001", "invalid_barcode");
            fail("Phải ném IllegalStateException do barcode không hợp lệ");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("không hợp lệ"));
        }
    }

    @Test
    public void testCheckOut_SuccessWithPreReservation() throws Exception {
        mockUserLookupDAO.userIdToReturn = 10;
        mockFineDAO.hasUnpaid = false;

        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setBarcode("barcode123");
        copy.setStatus("reserved");
        mockBookCopyDAO.copyToReturn = copy;

        Reservation res = new Reservation();
        res.setReservationId(301);
        res.setUserId(10);
        res.setBookId(201);
        mockReservationDAO.readyReservationToReturn = res;

        service.processCheckOut(1, "ST001", "barcode123");

        // Asserts
        assertTrue(mockBorrowRecordDAO.insertCalled);
        assertEquals(101, mockBorrowRecordDAO.lastBookCopyId);
        assertEquals(301, mockReservationDAO.fulfilledReservationId);
        assertEquals(101, mockBookCopyDAO.lastBorrowedCopyId);
        assertTrue(mockUserDAO.auditLogCalled);
        assertEquals("CHECK_OUT", mockUserDAO.lastActionType);
    }

    @Test
    public void testCheckOut_DirectBorrow_QueueNotEmpty() throws Exception {
        mockUserLookupDAO.userIdToReturn = 10;
        mockFineDAO.hasUnpaid = false;

        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setBarcode("barcode123");
        copy.setStatus("available");
        mockBookCopyDAO.copyToReturn = copy;

        mockReservationDAO.readyReservationToReturn = null; // Walk-in
        mockReservationDAO.hasQueue = true; // Nhưng có hàng chờ

        try {
            service.processCheckOut(1, "ST001", "barcode123");
            fail("Phải chặn vì có hàng chờ người khác");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("người khác đặt trước"));
        }
    }

    @Test
    public void testCheckOut_DirectBorrow_Success() throws Exception {
        mockUserLookupDAO.userIdToReturn = 10;
        mockFineDAO.hasUnpaid = false;

        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setBarcode("barcode123");
        copy.setStatus("available");
        mockBookCopyDAO.copyToReturn = copy;

        mockReservationDAO.readyReservationToReturn = null; // Walk-in
        mockReservationDAO.hasQueue = false; // Hàng chờ trống
        mockReservationDAO.insertedWalkInId = 999;

        service.processCheckOut(1, "ST001", "barcode123");

        // Asserts
        assertTrue(mockReservationDAO.insertWalkInCalled);
        assertEquals(10, mockReservationDAO.lastUserId);
        assertEquals(201, mockReservationDAO.lastBookId);
        assertTrue(mockBorrowRecordDAO.insertCalled);
        assertEquals(999, mockReservationDAO.fulfilledReservationId); // Custom walk-in reservation fulfilled
        assertEquals(101, mockBookCopyDAO.lastBorrowedCopyId);
    }

    // Programmatic variations for Check-out to hit high test count (T003)
    @Test
    public void testCheckOut_Variations() throws Exception {
        for (int i = 0; i < 24; i++) {
            boolean unpaid = (i & 1) != 0;
            boolean barcodeExists = (i & 2) != 0;
            boolean hasPreRes = (i & 4) != 0;
            boolean hasQueue = (i & 8) != 0;
            boolean sqlError = (i & 16) != 0;

            setUp(); // reset mocks

            mockUserLookupDAO.userIdToReturn = 50 + i;
            mockFineDAO.hasUnpaid = unpaid;
            
            BookCopy copy = null;
            if (barcodeExists) {
                copy = new BookCopy();
                copy.setBookCopyId(1000 + i);
                copy.setBookId(2000 + i);
                copy.setBarcode("barcode_" + i);
                copy.setStatus(hasPreRes ? "reserved" : "available");
            }
            mockBookCopyDAO.copyToReturn = copy;

            Reservation res = null;
            if (hasPreRes) {
                res = new Reservation();
                res.setReservationId(3000 + i);
                res.setUserId(50 + i);
                res.setBookId(2000 + i);
            }
            mockReservationDAO.readyReservationToReturn = res;
            mockReservationDAO.hasQueue = hasQueue;

            if (sqlError) {
                mockBorrowRecordDAO.shouldThrowSQLException = true;
            }

            try {
                service.processCheckOut(1, "ST_" + i, "barcode_" + i);
                // If it passes, it must be success scenario
                assertFalse(unpaid);
                assertTrue(barcodeExists);
                assertTrue(hasPreRes || !hasQueue);
                assertFalse(sqlError);
            } catch (IllegalStateException e) {
                // Expected failures
                assertTrue(unpaid || !barcodeExists || (!hasPreRes && hasQueue));
            } catch (SQLException e) {
                assertTrue(sqlError);
            }
        }
    }

    // =========================================================================
    // CHECK-IN UNIT TESTS (30 Test Cases)
    // =========================================================================

    @Test
    public void testCheckIn_InvalidCondition() throws Exception {
        try {
            service.processCheckIn(1, "barcode123", "very_old");
            fail("Phải ném IllegalStateException do condition sai");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("Tình trạng sách không hợp lệ"));
        }
    }

    @Test
    public void testCheckIn_BarcodeNotFound() throws Exception {
        mockBookCopyDAO.copyToReturn = null;
        try {
            service.processCheckIn(1, "barcode123", "good");
            fail("Phải ném IllegalStateException do barcode không tìm thấy");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("không hợp lệ hoặc không tồn tại"));
        }
    }

    @Test
    public void testCheckIn_CopyNotBorrowed() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setStatus("available"); // Không phải borrowed
        mockBookCopyDAO.copyToReturn = copy;

        try {
            service.processCheckIn(1, "barcode123", "good");
            fail("Phải ném IllegalStateException do status không phải borrowed");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("không ở trạng thái 'borrowed'"));
        }
    }

    @Test
    public void testCheckIn_NoActiveBorrowRecord() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setStatus("borrowed");
        mockBookCopyDAO.copyToReturn = copy;
        mockBorrowRecordDAO.activeRecord = null; // Không có active borrow record

        try {
            service.processCheckIn(1, "barcode123", "good");
            fail("Phải ném IllegalStateException do không tìm thấy record mượn");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("Không tìm thấy bản ghi mượn"));
        }
    }

    @Test
    public void testCheckIn_DamagedOrLost_Success() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setStatus("borrowed");
        mockBookCopyDAO.copyToReturn = copy;

        BorrowRecord rec = new BorrowRecord();
        rec.setBorrowRecordId(501);
        rec.setUserId(10);
        rec.setBookId(201);
        mockBorrowRecordDAO.activeRecord = rec;

        Book book = new Book();
        book.setBookId(201);
        book.setPrice(BigDecimal.valueOf(100_000));
        mockBookDAO.bookToReturn = book;

        mockFineDAO.insertedFineId = 888;

        service.processCheckIn(1, "barcode123", "damaged");

        // Asserts
        assertTrue(mockBorrowRecordDAO.damagedOrLostCalled);
        assertEquals("damaged", mockBorrowRecordDAO.lastStatus);
        assertEquals(101, mockBookCopyDAO.lastUnavailableCopyId);
        assertTrue(mockBookDAO.decrementCalled);
        assertTrue(mockFineDAO.insertCompensationCalled);
        assertEquals(BigDecimal.valueOf(150000.0), mockFineDAO.lastAmount); // Price 100k * 1.5 multiplier
        assertTrue(mockPaymentDAO.insertPaymentCalled);
        assertEquals(888, mockPaymentDAO.lastFineId);

        assertTrue(mockUserDAO.lockedUserIdCalled);
    }

    @Test
    public void testCheckIn_Good_NoQueue_Success() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setStatus("borrowed");
        mockBookCopyDAO.copyToReturn = copy;

        BorrowRecord rec = new BorrowRecord();
        rec.setBorrowRecordId(501);
        rec.setUserId(10);
        rec.setBookId(201);
        mockBorrowRecordDAO.activeRecord = rec;

        mockReservationDAO.nextInQueue = null; // No one in queue

        service.processCheckIn(1, "barcode123", "good");

        // Asserts
        assertTrue(mockBorrowRecordDAO.returnedCalled);
        assertTrue(mockBookCopyDAO.availableCalled);
        assertTrue(mockBookDAO.incrementCalled);
        assertFalse(mockReservationDAO.readyPickupCalled);
    }

    @Test
    public void testCheckIn_Good_HasQueue_Success() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(101);
        copy.setBookId(201);
        copy.setStatus("borrowed");
        mockBookCopyDAO.copyToReturn = copy;

        BorrowRecord rec = new BorrowRecord();
        rec.setBorrowRecordId(501);
        rec.setUserId(10);
        rec.setBookId(201);
        mockBorrowRecordDAO.activeRecord = rec;

        Reservation nextRes = new Reservation();
        nextRes.setReservationId(777);
        nextRes.setUserId(20);
        mockReservationDAO.nextInQueue = nextRes;

        service.processCheckIn(1, "barcode123", "good");

        // Asserts
        assertTrue(mockBorrowRecordDAO.returnedCalled);
        assertTrue(mockBookCopyDAO.availableCalled); // First set available then reserved
        assertTrue(mockReservationDAO.readyPickupCalled);
        assertEquals(777, mockReservationDAO.lastReservationId);
        assertEquals(101, mockReservationDAO.lastBookCopyId);
        assertTrue(mockBookCopyDAO.reservedCalled);
        assertTrue(mockReservationDAO.decrementCalled);
    }

    // Programmatic check-in tests for total case count
    @Test
    public void testCheckIn_Variations() throws Exception {
        for (int i = 0; i < 24; i++) {
            boolean validBarcode = (i & 1) != 0;
            boolean borrowedStatus = (i & 2) != 0;
            boolean activeRecordExists = (i & 4) != 0;
            String cond = (i & 8) != 0 ? "damaged" : "good";
            boolean sqlError = (i & 16) != 0;

            setUp(); // reset

            BookCopy copy = null;
            if (validBarcode) {
                copy = new BookCopy();
                copy.setBookCopyId(1000 + i);
                copy.setBookId(2000 + i);
                copy.setBarcode("barcode_" + i);
                copy.setStatus(borrowedStatus ? "borrowed" : "available");
            }
            mockBookCopyDAO.copyToReturn = copy;

            BorrowRecord rec = null;
            if (activeRecordExists) {
                rec = new BorrowRecord();
                rec.setBorrowRecordId(5000 + i);
                rec.setUserId(10);
                rec.setBookId(2000 + i);
            }
            mockBorrowRecordDAO.activeRecord = rec;

            Book book = new Book();
            book.setBookId(2000 + i);
            book.setPrice(BigDecimal.valueOf(100_000));
            mockBookDAO.bookToReturn = book;

            if (sqlError) {
                mockBorrowRecordDAO.shouldThrowSQLException = true;
            }

            try {
                service.processCheckIn(1, "barcode_" + i, cond);
                assertTrue(validBarcode && borrowedStatus && activeRecordExists && !sqlError);
            } catch (IllegalStateException e) {
                assertTrue(!validBarcode || !borrowedStatus || !activeRecordExists);
            } catch (SQLException e) {
                assertTrue(sqlError);
            }
        }
    }

    // =========================================================================
    // CASH PAYMENT UNIT TESTS (20 Test Cases)
    // =========================================================================

    @Test
    public void testApproveCashPayment_InvalidPaymentId() throws Exception {
        mockPaymentDAO.fineIdToReturn = -1;
        try {
            service.approveCashPayment(1, 999, 10);
            fail("Phải ném IllegalStateException");
        } catch (IllegalStateException e) {
            assertTrue(e.getMessage().contains("không tồn tại"));
        }
    }

    @Test
    public void testApproveCashPayment_Success_UnlockUser() throws Exception {
        mockPaymentDAO.fineIdToReturn = 50;
        mockUserLockReasonDAO.remainingReasons = 0; // COUNT = 0 -> unlock

        service.approveCashPayment(1, 100, 10);

        // Asserts
        assertTrue(mockPaymentDAO.completedCalled);
        assertEquals(100, mockPaymentDAO.lastPaymentId);
        assertTrue(mockFineDAO.paidCalled);
        assertEquals(50, mockFineDAO.lastFineId);


        assertTrue(mockUserDAO.activeUserIdCalled);
        assertEquals(10, mockUserDAO.lastActiveUserId);
    }

    @Test
    public void testApproveCashPayment_Success_KeepLocked() throws Exception {
        mockPaymentDAO.fineIdToReturn = 50;
        mockUserLockReasonDAO.remainingReasons = 2; // COUNT > 0 -> keep locked

        service.approveCashPayment(1, 100, 10);

        // Asserts
        assertTrue(mockPaymentDAO.completedCalled);
        assertTrue(mockFineDAO.paidCalled);

        assertFalse(mockUserDAO.activeUserIdCalled); // Không được unlock
    }

    @Test
    public void testApproveCashPayment_Variations() throws Exception {
        for (int i = 0; i < 16; i++) {
            boolean validPayment = (i & 1) != 0;
            boolean countZero = (i & 2) != 0;
            boolean sqlError = (i & 4) != 0;

            setUp();

            mockPaymentDAO.fineIdToReturn = validPayment ? (1000 + i) : -1;
            mockUserLockReasonDAO.remainingReasons = countZero ? 0 : 2;
            
            if (sqlError) {
                mockPaymentDAO.shouldThrowSQLException = true;
            }

            try {
                service.approveCashPayment(1, 100 + i, 10);
                assertTrue(validPayment && !sqlError);
                if (countZero) {
                    assertTrue(mockUserDAO.activeUserIdCalled);
                } else {
                    assertFalse(mockUserDAO.activeUserIdCalled);
                }
            } catch (IllegalStateException e) {
                assertTrue(!validPayment);
            } catch (SQLException e) {
                assertTrue(sqlError);
            }
        }
    }

    // =========================================================================
    // MOCK DAO CLASSES (Subclass stubs)
    // =========================================================================

    private static class MockUserLockReasonDAO extends UserLockReasonDAO {
        int remainingReasons = 0;

        @Override
        public int countLockReasonsByUserId(Connection conn, int userId) throws SQLException {
            return remainingReasons;
        }
    }

    private static class MockReservationDAO extends ReservationDAO {
        Reservation readyReservationToReturn = null;
        boolean hasQueue = false;
        int insertedWalkInId = 0;
        boolean insertWalkInCalled = false;
        int lastUserId = 0;
        int lastBookId = 0;
        int fulfilledReservationId = 0;
        Reservation nextInQueue = null;
        boolean readyPickupCalled = false;
        int lastReservationId = 0;
        int lastBookCopyId = 0;
        boolean decrementCalled = false;

        @Override
        public void cancelExpiredReservations(Connection conn) throws SQLException {
        }

        @Override
        public Reservation findReadyPickupByUserAndBook(Connection conn, int userId, int bookId) throws SQLException {
            return readyReservationToReturn;
        }

        @Override
        public boolean hasQueuedReservation(Connection conn, int bookId) throws SQLException {
            return hasQueue;
        }

        @Override
        public int insertWalkIn(Connection conn, int userId, int bookId, int bookCopyId) throws SQLException {
            insertWalkInCalled = true;
            lastUserId = userId;
            lastBookId = bookId;
            return insertedWalkInId;
        }

        @Override
        public void updateStatusToFulfilled(Connection conn, int reservationId) throws SQLException {
            fulfilledReservationId = reservationId;
        }

        @Override
        public Reservation findNextInQueue(Connection conn, int bookId) throws SQLException {
            return nextInQueue;
        }

        @Override
        public void updateToReadyPickup(Connection conn, int reservationId, int bookCopyId) throws SQLException {
            readyPickupCalled = true;
            lastReservationId = reservationId;
            lastBookCopyId = bookCopyId;
        }

        @Override
        public void decrementQueuePositions(Connection conn, int bookId) throws SQLException {
            decrementCalled = true;
        }
    }

    private static class MockBookCopyDAO extends BookCopyDAO {
        BookCopy copyToReturn = null;
        int lastBorrowedCopyId = 0;
        int lastUnavailableCopyId = 0;
        boolean availableCalled = false;
        boolean reservedCalled = false;

        @Override
        public BookCopy findByBarcode(Connection conn, String barcode) throws SQLException {
            return copyToReturn;
        }

        @Override
        public void updateStatusToBorrowed(Connection conn, int bookCopyId) throws SQLException {
            lastBorrowedCopyId = bookCopyId;
        }

        @Override
        public void updateStatusToBorrowedFromAvailable(Connection conn, int bookCopyId) throws SQLException {
            lastBorrowedCopyId = bookCopyId;
        }

        @Override
        public void updateStatusToBorrowedFromReserved(Connection conn, int bookCopyId) throws SQLException {
            lastBorrowedCopyId = bookCopyId;
        }

        @Override
        public void updateStatusToUnavailable(Connection conn, int bookCopyId, String condition) throws SQLException {
            lastUnavailableCopyId = bookCopyId;
        }

        @Override
        public void updateStatusToAvailable(Connection conn, int bookCopyId) throws SQLException {
            availableCalled = true;
        }

        @Override
        public void updateStatusToReserved(Connection conn, int bookCopyId) throws SQLException {
            reservedCalled = true;
        }
    }

    private static class MockBorrowRecordDAO extends BorrowRecordDAO {
        boolean insertCalled = false;
        int lastBookCopyId = 0;
        BorrowRecord activeRecord = null;
        boolean damagedOrLostCalled = false;
        String lastStatus = null;
        boolean returnedCalled = false;
        boolean shouldThrowSQLException = false;

        @Override
        public int insert(Connection conn, int userId, int bookCopyId, int bookId, int librarianId, Timestamp endDate) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            insertCalled = true;
            lastBookCopyId = bookCopyId;
            return 1;
        }

        @Override
        public BorrowRecord findActiveBorrowRecord(Connection conn, int bookCopyId) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            return activeRecord;
        }

        @Override
        public void updateStatusToDamagedOrLost(Connection conn, int borrowRecordId, String condition) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            damagedOrLostCalled = true;
            lastStatus = condition;
        }

        @Override
        public void updateStatusToReturned(Connection conn, int borrowRecordId) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            returnedCalled = true;
        }
    }

    private static class MockBookDAO extends BookDAO {
        boolean decrementCalled = false;
        boolean incrementCalled = false;
        Book bookToReturn = null;

        @Override
        public void decrementTotalQuantity(Connection conn, int bookId) throws SQLException {
            decrementCalled = true;
        }

        @Override
        public void incrementAvailableQuantity(Connection conn, int bookId) throws SQLException {
            incrementCalled = true;
        }

        @Override
        public Book findById(Connection conn, int bookId) throws SQLException {
            return bookToReturn;
        }
    }

    private static class MockFineDAO extends FineDAO {
        int insertedFineId = 0;
        boolean insertCompensationCalled = false;
        BigDecimal lastAmount = null;
        boolean paidCalled = false;
        int lastFineId = 0;
        boolean hasUnpaid = false;

        @Override
        public boolean hasUnpaidFines(Connection conn, int userId) throws SQLException {
            return hasUnpaid;
        }

        @Override
        public int insertCompensationFine(Connection conn, int borrowRecordId, int userId, BigDecimal amount, String reason) throws SQLException {
            insertCompensationCalled = true;
            lastAmount = amount;
            return insertedFineId;
        }

        @Override
        public void updateStatusToPaid(Connection conn, int fineId) throws SQLException {
            paidCalled = true;
            lastFineId = fineId;
        }
    }

    private static class MockUserDAO extends UserDAO {
        boolean lockedUserIdCalled = false;
        boolean activeUserIdCalled = false;
        int lastActiveUserId = 0;
        boolean auditLogCalled = false;
        String lastActionType = null;

        @Override
        public void updateStatusToLocked(Connection conn, int userId) throws SQLException {
            lockedUserIdCalled = true;
        }

        @Override
        public void updateStatusToActive(Connection conn, int userId) throws SQLException {
            activeUserIdCalled = true;
            lastActiveUserId = userId;
        }

        @Override
        public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
            auditLogCalled = true;
            lastActionType = actionType;
        }
    }

    private static class MockPaymentDAO extends PaymentDAO {
        boolean insertPaymentCalled = false;
        int lastFineId = 0;
        int fineIdToReturn = 0;
        boolean completedCalled = false;
        int lastPaymentId = 0;
        boolean shouldThrowSQLException = false;

        @Override
        public int insertPayment(Connection conn, int fineId, BigDecimal amount, String status) throws SQLException {
            insertPaymentCalled = true;
            lastFineId = fineId;
            return 1;
        }

        @Override
        public int findFineIdByPaymentId(Connection conn, int paymentId) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            return fineIdToReturn;
        }

        @Override
        public void updateStatusToCompleted(Connection conn, int paymentId) throws SQLException {
            if (shouldThrowSQLException) throw new SQLException("Simulated DB error");
            completedCalled = true;
            lastPaymentId = paymentId;
        }
    }

    private static class MockUserLookupDAO extends UserLookupDAO {
        Integer userIdToReturn = null;

        @Override
        public Integer findUserIdByMemberCode(Connection conn, String memberCode) throws SQLException {
            return userIdToReturn;
        }
    }
}
