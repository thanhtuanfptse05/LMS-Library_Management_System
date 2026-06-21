package f6;

import dao.*;
import model.*;
import service.DeskCirculationService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import static org.junit.Assert.*;

/**
 * DeskCirculationServiceParameterTest — Parameterized Unit Tests cho DeskCirculationService.
 * Giúp tạo số lượng lớn test cases (120+) bao phủ mọi nhánh điều kiện và biên dữ liệu.
 */
@RunWith(Parameterized.class)
public class DeskCirculationServiceParameterTest {

    // Parameters for Checkout, Checkin, and Payment
    private final String testType; // "checkout", "checkin", "payment"
    
    // Checkout inputs & conditions
    private String memberCode;
    private String barcode;
    private boolean unpaid;
    private boolean hasPreRes;
    private boolean hasQueue;
    
    // Checkin inputs & conditions
    private boolean validBarcode;
    private boolean borrowedStatus;
    private boolean activeRecordExists;
    private String condition;
    
    // Payment inputs & conditions
    private int paymentId;
    private int remainingReasons;
    
    // Global conditions
    private final boolean sqlError;

    private DeskCirculationService service;
    private MockUserLockReasonDAO mockUserLockReasonDAO;
    private MockReservationDAO    mockReservationDAO;
    private MockBookCopyDAO       mockBookCopyDAO;
    private MockBorrowRecordDAO   mockBorrowRecordDAO;
    private MockBookDAO           mockBookDAO;
    private MockFineDAO           mockFineDAO;
    private MockUserDAO           mockUserDAO;
    private MockPaymentDAO        mockPaymentDAO;
    private MockUserLookupDAO     mockUserLookupDAO;

    // Constructor mapping parameters
    public DeskCirculationServiceParameterTest(
            String testType, String memberCode, String barcode, boolean unpaid, boolean hasPreRes, boolean hasQueue,
            boolean validBarcode, boolean borrowedStatus, boolean activeRecordExists, String condition,
            int paymentId, int remainingReasons, boolean sqlError) {
        this.testType = testType;
        this.memberCode = memberCode;
        this.barcode = barcode;
        this.unpaid = unpaid;
        this.hasPreRes = hasPreRes;
        this.hasQueue = hasQueue;
        this.validBarcode = validBarcode;
        this.borrowedStatus = borrowedStatus;
        this.activeRecordExists = activeRecordExists;
        this.condition = condition;
        this.paymentId = paymentId;
        this.remainingReasons = remainingReasons;
        this.sqlError = sqlError;
    }

    @Parameters(name = "{index}: type={0}, sqlError={12}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        // 1. Checkout Scenarios (64 combinations)
        for (int i = 0; i < 64; i++) {
            String member = (i & 1) != 0 ? "ST001" : "invalid";
            String code = (i & 2) != 0 ? "barcode123" : "invalid";
            boolean unpaidVal = (i & 4) != 0;
            boolean preRes = (i & 8) != 0;
            boolean queue = (i & 16) != 0;
            boolean err = (i & 32) != 0;
            params.add(new Object[]{
                "checkout", member, code, unpaidVal, preRes, queue,
                false, false, false, "", 0, 0, err
            });
        }

        // 2. Checkin Scenarios (48 combinations)
        for (int i = 0; i < 48; i++) {
            boolean validBar = (i & 1) != 0;
            boolean statusBorrowed = (i & 2) != 0;
            boolean activeRec = (i & 4) != 0;
            String cond = "good";
            int condIdx = (i / 8) % 3;
            if (condIdx == 1) cond = "damaged";
            if (condIdx == 2) cond = "lost";
            boolean err = (i & 24) != 0; // SQL error scenario
            params.add(new Object[]{
                "checkin", "", "", false, false, false,
                validBar, statusBorrowed, activeRec, cond, 0, 0, err
            });
        }

        // 3. Payment Scenarios (8 combinations)
        for (int i = 0; i < 8; i++) {
            int payId = (i & 1) != 0 ? 100 : -1;
            int reasons = (i & 2) != 0 ? 0 : 2;
            boolean err = (i & 4) != 0;
            params.add(new Object[]{
                "payment", "", "", false, false, false,
                false, false, false, "", payId, reasons, err
            });
        }

        return params;
    }

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

        service = new service.DeskCirculationServiceAccessor(
                mockUserLockReasonDAO, mockReservationDAO, mockBookCopyDAO,
                mockBorrowRecordDAO, mockBookDAO, mockFineDAO, mockUserDAO,
                mockPaymentDAO, mockUserLookupDAO
        ).getService();
    }

    @Test
    public void testCirculationFlow() throws Exception {
        if ("checkout".equals(testType)) {
            runCheckoutTest();
        } else if ("checkin".equals(testType)) {
            runCheckinTest();
        } else if ("payment".equals(testType)) {
            runPaymentTest();
        }
    }

    private void runCheckoutTest() throws Exception {
        mockUserLookupDAO.userIdToReturn = "ST001".equals(memberCode) ? 10 : null;
        mockFineDAO.hasUnpaid = unpaid;
        
        BookCopy copy = null;
        if ("barcode123".equals(barcode)) {
            copy = new BookCopy();
            copy.setBookCopyId(101);
            copy.setBookId(201);
            copy.setBarcode("barcode123");
            copy.setStatus(hasPreRes ? "reserved" : "available");
        }
        mockBookCopyDAO.copyToReturn = copy;

        Reservation res = null;
        if (hasPreRes) {
            res = new Reservation();
            res.setReservationId(301);
            res.setUserId(10);
            res.setBookId(201);
        }
        mockReservationDAO.readyReservationToReturn = res;
        mockReservationDAO.hasQueue = hasQueue;

        if (sqlError) {
            mockBorrowRecordDAO.shouldThrowSQLException = true;
        }

        try {
            service.processCheckOut(1, memberCode, barcode);
            // Verify success parameters
            assertEquals("ST001", memberCode);
            assertEquals("barcode123", barcode);
            assertFalse(unpaid);
            assertTrue(hasPreRes || !hasQueue);
            assertFalse(sqlError);
        } catch (IllegalStateException e) {
            assertTrue(!"ST001".equals(memberCode) || !"barcode123".equals(barcode) || unpaid || (!hasPreRes && hasQueue));
        } catch (SQLException e) {
            assertTrue(sqlError);
        }
    }

    private void runCheckinTest() throws Exception {
        BookCopy copy = null;
        if (validBarcode) {
            copy = new BookCopy();
            copy.setBookCopyId(101);
            copy.setBookId(201);
            copy.setBarcode("barcode123");
            copy.setStatus(borrowedStatus ? "borrowed" : "available");
        }
        mockBookCopyDAO.copyToReturn = copy;

        BorrowRecord rec = null;
        if (activeRecordExists) {
            rec = new BorrowRecord();
            rec.setBorrowRecordId(501);
            rec.setUserId(10);
            rec.setBookId(201);
        }
        mockBorrowRecordDAO.activeRecord = rec;

        Book book = new Book();
        book.setBookId(201);
        book.setPrice(BigDecimal.valueOf(100_000));
        mockBookDAO.bookToReturn = book;

        if (sqlError) {
            mockBorrowRecordDAO.shouldThrowSQLException = true;
        }

        try {
            service.processCheckIn(1, "barcode123", condition);
            assertTrue(validBarcode && borrowedStatus && activeRecordExists && !sqlError);
        } catch (IllegalStateException e) {
            assertTrue(!validBarcode || !borrowedStatus || !activeRecordExists);
        } catch (SQLException e) {
            assertTrue(sqlError);
        }
    }

    private void runPaymentTest() throws Exception {
        mockPaymentDAO.fineIdToReturn = paymentId == 100 ? 50 : -1;
        mockUserLockReasonDAO.remainingReasons = remainingReasons;

        if (sqlError) {
            mockPaymentDAO.shouldThrowSQLException = true;
        }

        try {
            service.approveCashPayment(1, paymentId, 10);
            assertEquals(100, paymentId);
            assertFalse(sqlError);
            if (remainingReasons == 0) {
                assertTrue(mockUserDAO.activeUserIdCalled);
            } else {
                assertFalse(mockUserDAO.activeUserIdCalled);
            }
        } catch (IllegalStateException e) {
            assertTrue(paymentId != 100);
        } catch (SQLException e) {
            assertTrue(sqlError);
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
