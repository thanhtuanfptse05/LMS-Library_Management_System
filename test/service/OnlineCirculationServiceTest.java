package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.DocumentTempDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import exception.ValidationException;
import exception.DatabaseException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import model.Book;
import model.BookCopy;
import model.BorrowRecord;
import model.DocumentTemp;
import model.MemberProfile;
import model.Reservation;
import model.User;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * OnlineCirculationServiceTest — Unit Tests cho OnlineCirculationService sử dụng JUnit 4.
 * 
 * Sử dụng kỹ thuật Subclass Stubbing (Mock DAOs) để kiểm thử logic nghiệp vụ độc lập,
 * hoàn toàn không chạm tới PostgreSQL database vật lý.
 */
public class OnlineCirculationServiceTest {

    private OnlineCirculationService service;
    private MockUserDAO mockUserDAO;
    private MockBorrowRecordDAO mockBorrowRecordDAO;
    private MockReservationDAO mockReservationDAO;
    private MockBookDAO mockBookDAO;
    private MockBookCopyDAO mockBookCopyDAO;
    private MockSystemConfigDAO mockSystemConfigDAO;
    private MockAuditLogDAO mockAuditLogDAO;
    private MockMemberProfileDAO mockMemberProfileDAO;
    private MockDocumentTempDAO mockDocumentTempDAO;
    private MockUserLockReasonDAO mockUserLockReasonDAO;

    @Before
    public void setUp() {
        mockUserDAO = new MockUserDAO();
        mockBorrowRecordDAO = new MockBorrowRecordDAO();
        mockReservationDAO = new MockReservationDAO();
        mockBookDAO = new MockBookDAO();
        mockBookCopyDAO = new MockBookCopyDAO();
        mockSystemConfigDAO = new MockSystemConfigDAO();
        mockAuditLogDAO = new MockAuditLogDAO();
        mockMemberProfileDAO = new MockMemberProfileDAO();
        mockDocumentTempDAO = new MockDocumentTempDAO();
        mockUserLockReasonDAO = new MockUserLockReasonDAO();

        service = new OnlineCirculationService(
                mockBookDAO, mockBookCopyDAO, mockReservationDAO, mockBorrowRecordDAO,
                mockSystemConfigDAO, mockAuditLogDAO, mockUserDAO, mockUserLockReasonDAO,
                mockMemberProfileDAO, mockDocumentTempDAO
        );

        // Tạo Mock Connection bằng Proxy để tránh kết nối đến database Supabase thật
        Connection mockConn = (Connection) java.lang.reflect.Proxy.newProxyInstance(
                Connection.class.getClassLoader(),
                new Class[] { Connection.class },
                new java.lang.reflect.InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, java.lang.reflect.Method method, Object[] args) throws Throwable {
                        if ("setAutoCommit".equals(method.getName()) || "commit".equals(method.getName())
                                || "rollback".equals(method.getName()) || "close".equals(method.getName())) {
                            return null;
                        }
                        return null;
                    }
                }
        );
        util.DatabaseConnection.testConnection = mockConn;
    }

    @org.junit.After
    public void tearDown() {
        util.DatabaseConnection.testConnection = null;
    }

    // =========================================================================
    // LUỒNG 1: ĐẶT TRƯỚC SÁCH (RESERVE BOOK) - 10 TEST CASES
    // =========================================================================

    @Test
    public void testReserveBook_UserNotFound() throws Exception {
        mockUserDAO.userToReturn = null;
        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do tài khoản không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không tồn tại"));
        }
    }

    @Test
    public void testReserveBook_UserNotActive() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("locked");
        mockUserDAO.userToReturn = user;

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do tài khoản bị khóa");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("bị khóa hoặc ngưng hoạt động"));
        }
    }

    @Test
    public void testReserveBook_AlreadyBorrowed() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = true; // Đang mượn cuốn này

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do đang mượn sách");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đang mượn cuốn sách này"));
        }
    }

    @Test
    public void testReserveBook_AlreadyReserved() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = true; // Đã đặt trước cuốn này

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do đã đặt trước");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đã đặt trước cuốn sách này rồi"));
        }
    }

    @Test
    public void testReserveBook_LimitExceeded_Student() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        mockSystemConfigDAO.configs.put("STUDENT_MAX_BORROW_LIMIT", 5);
        
        mockBorrowRecordDAO.activeBorrowsCount = 3;
        mockReservationDAO.activeReservationsCount = 2; // Tổng = 5 (đạt giới hạn)

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do vượt giới hạn mượn/đặt");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đạt giới hạn tối đa mượn và đặt trước"));
        }
    }

    @Test
    public void testReserveBook_LimitExceeded_Lecturer() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        mockSystemConfigDAO.configs.put("LECTURER_MAX_BORROW_LIMIT", 10);
        
        mockBorrowRecordDAO.activeBorrowsCount = 6;
        mockReservationDAO.activeReservationsCount = 4; // Tổng = 10 (đạt giới hạn)

        try {
            service.reserveBook(1, 101, "lecturer");
            fail("Phải ném ValidationException do vượt giới hạn mượn/đặt của giảng viên");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đạt giới hạn tối đa mượn và đặt trước"));
        }
    }

    @Test
    public void testReserveBook_BookNotFound() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        mockBookDAO.bookToReturn = null; // Sách không tồn tại

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do sách không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("Đầu sách không tồn tại"));
        }
    }

    @Test
    public void testReserveBook_BookNotAvailable() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        
        Book book = new Book();
        book.setBookId(101);
        book.setStatus("deleted"); // Sách bị xoá, không khả dụng
        mockBookDAO.bookToReturn = book;

        try {
            service.reserveBook(1, 101, "student");
            fail("Phải ném ValidationException do sách không khả dụng");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không khả dụng để đặt trước"));
        }
    }

    @Test
    public void testReserveBook_Success_ReadyPickup() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        user.setEmail("student@lms.com");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        
        Book book = new Book();
        book.setBookId(101);
        book.setTitle("Lập trình Java");
        book.setStatus("available");
        book.setAvailableQuantity(1); // Sách còn trong kho
        mockBookDAO.bookToReturn = book;

        BookCopy copy = new BookCopy();
        copy.setBookCopyId(202);
        copy.setBookId(101);
        mockBookCopyDAO.copyToReturn = copy;

        mockReservationDAO.insertedReservationId = 555;

        int resId = service.reserveBook(1, 101, "student");

        assertEquals(555, resId);
        assertTrue(mockBookCopyDAO.updateStatusToReservedCalled);
        assertTrue(mockBookDAO.updateQuantitiesCalled);
        assertEquals(-1, mockBookDAO.lastAvailableQtyChange);
        assertTrue(mockReservationDAO.insertCalled);
        assertEquals(0, mockReservationDAO.lastQueuePositionInserted);
        assertEquals(Integer.valueOf(202), mockReservationDAO.lastBookCopyIdInserted);
        assertTrue(mockAuditLogDAO.insertCalled);
        assertEquals("RESERVE_READY", mockAuditLogDAO.lastActionType);
    }

    @Test
    public void testReserveBook_Success_PendingQueue() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.hasActive = false;
        mockReservationDAO.hasActive = false;
        
        Book book = new Book();
        book.setBookId(101);
        book.setStatus("available");
        book.setAvailableQuantity(0); // Sách đã hết -> hàng chờ
        mockBookDAO.bookToReturn = book;

        mockReservationDAO.insertedReservationId = 777;
        mockReservationDAO.maxQueuePositionToReturn = 2; // Giả sử maxQueue hiện tại

        int resId = service.reserveBook(1, 101, "student");

        assertEquals(777, resId);
        assertFalse(mockBookCopyDAO.updateStatusToReservedCalled); // Không gán copy
        assertTrue(mockReservationDAO.insertCalled);
        // queuePosition insert sẽ = maxQueuePositionToReturn + 1 = 3
        assertEquals(3, mockReservationDAO.lastQueuePositionInserted);
        assertNull(mockReservationDAO.lastBookCopyIdInserted);
        assertTrue(mockAuditLogDAO.insertCalled);
        assertEquals("RESERVE_PENDING", mockAuditLogDAO.lastActionType);
    }

    // =========================================================================
    // LUỒNG 2: HỦY ĐẶT TRƯỚC SÁCH (CANCEL RESERVATION) - 8 TEST CASES
    // =========================================================================

    @Test
    public void testCancelReservation_UserNotFound() throws Exception {
        mockUserDAO.userToReturn = null;
        try {
            service.cancelReservation(1, 555);
            fail("Phải ném ValidationException do tài khoản không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không tồn tại"));
        }
    }

    @Test
    public void testCancelReservation_UserNotActive() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("locked");
        mockUserDAO.userToReturn = user;

        try {
            service.cancelReservation(1, 555);
            fail("Phải ném ValidationException do tài khoản bị khóa");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("bị khóa hoặc ngưng hoạt động"));
        }
    }

    @Test
    public void testCancelReservation_ResNotFound() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockReservationDAO.reservationToReturn = null; // Đơn đặt trước không tồn tại

        try {
            service.cancelReservation(1, 555);
            fail("Phải ném ValidationException do đơn đặt trước không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("Đơn đặt trước không tồn tại"));
        }
    }

    @Test
    public void testCancelReservation_NotOwner() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        Reservation res = new Reservation();
        res.setReservationId(555);
        res.setUserId(99); // Chủ sở hữu khác (user 99)
        mockReservationDAO.reservationToReturn = res;

        try {
            service.cancelReservation(1, 555);
            fail("Phải ném ValidationException do không sở hữu đơn đặt");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không sở hữu đơn đặt trước này"));
        }
    }

    @Test
    public void testCancelReservation_NotActiveStatus() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        Reservation res = new Reservation();
        res.setReservationId(555);
        res.setUserId(1);
        res.setStatus("fulfilled"); // Trạng thái đã hoàn tất -> không được hủy
        mockReservationDAO.reservationToReturn = res;

        try {
            service.cancelReservation(1, 555);
            fail("Phải ném ValidationException do status không hợp lệ");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không còn ở trạng thái hoạt động để hủy"));
        }
    }

    @Test
    public void testCancelReservation_Success_PendingQueue() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        Reservation res = new Reservation();
        res.setReservationId(555);
        res.setUserId(1);
        res.setBookId(101);
        res.setStatus("pending");
        res.setQueuePosition(2); // Trong hàng chờ
        mockReservationDAO.reservationToReturn = res;

        service.cancelReservation(1, 555);

        assertTrue(mockReservationDAO.cancelCalled);
        assertTrue(mockReservationDAO.shiftQueueCalled); // Dịch chuyển những người đứng sau
        assertTrue(mockAuditLogDAO.insertCalled);
        assertEquals("CANCEL_RESERVATION", mockAuditLogDAO.lastActionType);
    }

    @Test
    public void testCancelReservation_Success_ReadyPickup_NoNextQueue() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        Reservation res = new Reservation();
        res.setReservationId(555);
        res.setUserId(1);
        res.setBookId(101);
        res.setBookCopyId(202);
        res.setStatus("readypickup");
        res.setQueuePosition(0); // Sách đã có sẵn để lấy
        mockReservationDAO.reservationToReturn = res;

        mockReservationDAO.nextInQueue = null; // Không ai xếp hàng tiếp theo

        service.cancelReservation(1, 555);

        assertTrue(mockReservationDAO.cancelCalled);
        assertTrue(mockBookCopyDAO.updateStatusToAvailableCalled); // Trả copy về available
        assertTrue(mockBookDAO.updateQuantitiesCalled);
        assertEquals(1, mockBookDAO.lastAvailableQtyChange); // Tăng availableQuantity của Book
        assertFalse(mockReservationDAO.updateToReadyPickupCalled); // Không đôn ai lên
        assertTrue(mockAuditLogDAO.insertCalled);
    }

    @Test
    public void testCancelReservation_Success_ReadyPickup_WithNextQueue() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        Reservation res = new Reservation();
        res.setReservationId(555);
        res.setUserId(1);
        res.setBookId(101);
        res.setBookCopyId(202);
        res.setStatus("readypickup");
        res.setQueuePosition(0);
        mockReservationDAO.reservationToReturn = res;

        Reservation nextRes = new Reservation();
        nextRes.setReservationId(666);
        nextRes.setUserId(2);
        nextRes.setBookId(101);
        mockReservationDAO.nextInQueue = nextRes; // Có người xếp hàng tiếp theo

        User nextUser = new User();
        nextUser.setUserId(2);
        nextUser.setEmail("next_student@lms.com");
        mockUserDAO.userMap.put(2, nextUser);

        service.cancelReservation(1, 555);

        assertTrue(mockReservationDAO.cancelCalled);
        assertTrue(mockReservationDAO.updateToReadyPickupCalled); // Đôn người tiếp theo lên
        assertEquals(666, mockReservationDAO.lastReservationReady);
        assertEquals(Integer.valueOf(202), mockReservationDAO.lastBookCopyReady);
        assertTrue(mockReservationDAO.decrementQueueCalled); // Dịch chuyển queue
        assertFalse(mockBookCopyDAO.updateStatusToAvailableCalled); // Bản sao gán luôn cho người mới, không rảnh rỗi
    }

    // =========================================================================
    // LUỒNG 3: GIA HẠN SÁCH (RENEW BOOK) - 9 TEST CASES
    // =========================================================================

    @Test
    public void testRenewBook_UserNotFound() throws Exception {
        mockUserDAO.userToReturn = null;
        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do tài khoản không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không tồn tại"));
        }
    }

    @Test
    public void testRenewBook_UserNotActive() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("locked");
        mockUserDAO.userToReturn = user;

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do tài khoản bị khóa");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("bị khóa hoặc ngưng hoạt động"));
        }
    }

    @Test
    public void testRenewBook_RecordNotFound() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;
        mockBorrowRecordDAO.recordToReturn = null; // Bản ghi mượn không tồn tại

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do record mượn không tồn tại");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("mượn sách không tồn tại"));
        }
    }

    @Test
    public void testRenewBook_NotOwner() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(99); // Sở hữu bởi user khác
        mockBorrowRecordDAO.recordToReturn = br;

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do không sở hữu");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không sở hữu bản ghi mượn"));
        }
    }

    @Test
    public void testRenewBook_NotBorrowed() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(1);
        br.setStatus("returned"); // Đã trả rồi -> không thể gia hạn
        mockBorrowRecordDAO.recordToReturn = br;

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do trạng thái không phải borrowed");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không còn ở trạng thái đang mượn"));
        }
    }

    @Test
    public void testRenewBook_ThresholdNotMet() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        long now = System.currentTimeMillis();
        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(1);
        br.setStatus("borrowed");
        // Đặt thời gian mượn 14 ngày. Trả sách vào ngày đầu tiên (chưa quá 50%)
        br.setStartDate(new Timestamp(now - 1 * 24 * 60 * 60 * 1000));
        br.setEndDate(new Timestamp(now + 13 * 24 * 60 * 60 * 1000));
        mockBorrowRecordDAO.recordToReturn = br;

        mockSystemConfigDAO.configs.put("RENEW_THRESHOLD_PERCENT", 50);

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do chưa dùng đủ 50% thời hạn");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("chỉ được gia hạn khi đã sử dụng ít nhất"));
        }
    }

    @Test
    public void testRenewBook_MaxExtensionExceeded() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        long now = System.currentTimeMillis();
        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(1);
        br.setStatus("borrowed");
        br.setStartDate(new Timestamp(now - 10 * 24 * 60 * 60 * 1000));
        br.setEndDate(new Timestamp(now + 4 * 24 * 60 * 60 * 1000));
        br.setExtensionCount(3); // Đã gia hạn 3 lần (đạt max)
        mockBorrowRecordDAO.recordToReturn = br;

        mockSystemConfigDAO.configs.put("RENEW_THRESHOLD_PERCENT", 50);
        mockSystemConfigDAO.configs.put("MAX_EXTENSION_COUNT", 3);

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do vượt tối đa lượt gia hạn");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("vượt quá số lần gia hạn cho phép"));
        }
    }

    @Test
    public void testRenewBook_HasQueuedReservation() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        long now = System.currentTimeMillis();
        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(1);
        br.setBookId(101);
        br.setStatus("borrowed");
        br.setStartDate(new Timestamp(now - 10 * 24 * 60 * 60 * 1000));
        br.setEndDate(new Timestamp(now + 4 * 24 * 60 * 60 * 1000));
        br.setExtensionCount(1);
        mockBorrowRecordDAO.recordToReturn = br;

        mockSystemConfigDAO.configs.put("RENEW_THRESHOLD_PERCENT", 50);
        mockSystemConfigDAO.configs.put("MAX_EXTENSION_COUNT", 3);

        mockReservationDAO.hasQueued = true; // Sách này đang có người xếp hàng chờ đặt trước

        try {
            service.renewBook(1, 888);
            fail("Phải ném ValidationException do sách đang có người xếp hàng chờ");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đang có độc giả khác xếp hàng chờ đặt trước"));
        }
    }

    @Test
    public void testRenewBook_Success() throws Exception {
        User user = new User();
        user.setUserId(1);
        user.setStatus("active");
        mockUserDAO.userToReturn = user;

        long now = System.currentTimeMillis();
        BorrowRecord br = new BorrowRecord();
        br.setBorrowRecordId(888);
        br.setUserId(1);
        br.setBookId(101);
        br.setStatus("borrowed");
        br.setStartDate(new Timestamp(now - 10 * 24 * 60 * 60 * 1000));
        br.setEndDate(new Timestamp(now + 4 * 24 * 60 * 60 * 1000));
        br.setExtensionCount(1);
        mockBorrowRecordDAO.recordToReturn = br;

        mockSystemConfigDAO.configs.put("RENEW_THRESHOLD_PERCENT", 50);
        mockSystemConfigDAO.configs.put("MAX_EXTENSION_COUNT", 3);
        mockSystemConfigDAO.configs.put("RENEW_DURATION_DAYS", 14);

        mockReservationDAO.hasQueued = false; // Hàng chờ trống

        service.renewBook(1, 888);

        assertTrue(mockBorrowRecordDAO.incrementExtensionCalled);
        assertEquals(888, mockBorrowRecordDAO.lastBorrowRecordIdExtended);
        assertEquals(14, mockBorrowRecordDAO.lastExtendedDays);
        assertTrue(mockAuditLogDAO.insertCalled);
        assertEquals("RENEW_BOOK", mockAuditLogDAO.lastActionType);
    }

    // =========================================================================
    // MOCK DAO CLASSES (Subclass stubs)
    // =========================================================================

    private static class MockUserDAO extends UserDAO {
        User userToReturn = null;
        Map<Integer, User> userMap = new HashMap<>();

        @Override
        public User findByUserId(int userId) {
            if (userMap.containsKey(userId)) {
                return userMap.get(userId);
            }
            return userToReturn;
        }
    }

    private static class MockBorrowRecordDAO extends BorrowRecordDAO {
        boolean hasActive = false;
        int activeBorrowsCount = 0;
        BorrowRecord recordToReturn = null;
        boolean incrementExtensionCalled = false;
        int lastBorrowRecordIdExtended = -1;
        int lastExtendedDays = -1;

        @Override
        public boolean hasActiveBorrowRecord(Connection conn, int userId, int bookId) throws SQLException {
            return hasActive;
        }

        @Override
        public int countActiveBorrowsByUser(Connection conn, int userId) throws SQLException {
            return activeBorrowsCount;
        }

        @Override
        public BorrowRecord findBorrowRecordById(Connection conn, int borrowRecordId) throws SQLException {
            return recordToReturn;
        }

        @Override
        public void incrementExtension(Connection conn, int borrowRecordId, int extraDays) throws SQLException {
            incrementExtensionCalled = true;
            lastBorrowRecordIdExtended = borrowRecordId;
            lastExtendedDays = extraDays;
        }
    }

    private static class MockReservationDAO extends ReservationDAO {
        boolean hasActive = false;
        int activeReservationsCount = 0;
        int insertedReservationId = 999;
        boolean insertCalled = false;
        int lastQueuePositionInserted = -1;
        Integer lastBookCopyIdInserted = null;
        Reservation reservationToReturn = null;
        boolean cancelCalled = false;
        Reservation nextInQueue = null;
        boolean updateToReadyPickupCalled = false;
        int lastReservationReady = -1;
        Integer lastBookCopyReady = null;
        boolean decrementQueueCalled = false;
        boolean shiftQueueCalled = false;
        boolean hasQueued = false;
        int maxQueuePositionToReturn = 0;

        @Override
        public int getMaxQueuePosition(Connection conn, int bookId) throws SQLException {
            return maxQueuePositionToReturn;
        }

        @Override
        public boolean hasActiveReservation(Connection conn, int userId, int bookId) throws SQLException {
            return hasActive;
        }

        @Override
        public int countActiveReservationsByUser(Connection conn, int userId) throws SQLException {
            return activeReservationsCount;
        }

        @Override
        public int insertOnlineReservation(Connection conn, int userId, int bookId, int queuePosition, Integer bookCopyId) throws SQLException {
            insertCalled = true;
            lastQueuePositionInserted = queuePosition;
            lastBookCopyIdInserted = bookCopyId;
            return insertedReservationId;
        }

        @Override
        public Reservation findReservationById(Connection conn, int reservationId) throws SQLException {
            return reservationToReturn;
        }

        @Override
        public void cancelReservation(Connection conn, int reservationId, int userId) throws SQLException {
            cancelCalled = true;
        }

        @Override
        public Reservation findNextInQueue(Connection conn, int bookId) throws SQLException {
            return nextInQueue;
        }

        @Override
        public void updateToReadyPickup(Connection conn, int reservationId, int bookCopyId) throws SQLException {
            updateToReadyPickupCalled = true;
            lastReservationReady = reservationId;
            lastBookCopyReady = bookCopyId;
        }

        @Override
        public void decrementQueuePositions(Connection conn, int bookId) throws SQLException {
            decrementQueueCalled = true;
        }

        @Override
        public void shiftQueuePositions(Connection conn, int bookId, int queuePosition) throws SQLException {
            shiftQueueCalled = true;
        }

        @Override
        public boolean hasQueuedReservation(Connection conn, int bookId) throws SQLException {
            return hasQueued;
        }
    }

    private static class MockBookDAO extends BookDAO {
        Book bookToReturn = null;
        boolean updateQuantitiesCalled = false;
        int lastAvailableQtyChange = 0;

        @Override
        public Book findByIdForUpdate(Connection conn, int bookId) throws SQLException {
            return bookToReturn;
        }

        @Override
        public Book findById(Connection conn, int bookId) throws SQLException {
            return bookToReturn;
        }

        @Override
        public void updateQuantities(Connection conn, int bookId, int totalQuantityChange, int availableQuantityChange) throws SQLException {
            updateQuantitiesCalled = true;
            lastAvailableQtyChange = availableQuantityChange;
        }
    }

    private static class MockBookCopyDAO extends BookCopyDAO {
        BookCopy copyToReturn = null;
        boolean updateStatusToReservedCalled = false;
        boolean updateStatusToAvailableCalled = false;

        @Override
        public BookCopy findAvailableCopyByBookId(Connection conn, int bookId) throws SQLException {
            return copyToReturn;
        }

        @Override
        public void updateStatusToReserved(Connection conn, int bookCopyId) throws SQLException {
            updateStatusToReservedCalled = true;
        }

        @Override
        public void updateStatusToAvailable(Connection conn, int bookCopyId) throws SQLException {
            updateStatusToAvailableCalled = true;
        }
    }

    private static class MockSystemConfigDAO extends SystemConfigDAO {
        Map<String, Integer> configs = new HashMap<>();

        @Override
        public int getIntValue(Connection conn, String key, int defaultValue) throws SQLException {
            return configs.containsKey(key) ? configs.get(key) : defaultValue;
        }
    }

    private static class MockAuditLogDAO extends AuditLogDAO {
        boolean insertCalled = false;
        String lastActionType = null;

        @Override
        public void insert(Connection conn, Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) throws SQLException {
            insertCalled = true;
            lastActionType = actionType;
        }
    }

    private static class MockMemberProfileDAO extends MemberProfileDAO {
        MemberProfile profileToReturn = null;

        @Override
        public MemberProfile findByUserId(int userId) {
            return profileToReturn;
        }
    }

    private static class MockDocumentTempDAO extends DocumentTempDAO {
        DocumentTemp tempToReturn = null;

        @Override
        public DocumentTemp findByTempName(String tempName) {
            return tempToReturn;
        }
    }

    private static class MockUserLockReasonDAO extends UserLockReasonDAO {
        // Trống vì không được gọi trong OnlineCirculationService
    }
}
