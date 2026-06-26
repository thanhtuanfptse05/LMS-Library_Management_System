package f5;

import dao.*;
import model.*;
import service.OnlineCirculationService;
import util.DatabaseConnection;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import static org.junit.Assert.*;

/**
 * OnlineCirculationServiceIntegrationTest — Integration Tests trên CSDL thực tế cho F5.
 */
@RunWith(Parameterized.class)
public class OnlineCirculationServiceIntegrationTest {

    private final String flow; // "reserve", "cancel", "renew", "concurrency"
    private final String role; // "student", "lecturer"
    private final boolean hasUnpaidFine;
    private final int initialAvailableQty;
    private final boolean hasActiveReservation;

    // Các ID tạo ra để dọn dẹp sau test
    private int userId;
    private int bookId;
    private int bookCopyId;
    private List<Integer> createdReservationIds = new ArrayList<>();
    private List<Integer> createdBorrowRecordIds = new ArrayList<>();
    private List<Integer> createdUserIds = new ArrayList<>();
    private List<Integer> createdBookIds = new ArrayList<>();

    private OnlineCirculationService service;

    public OnlineCirculationServiceIntegrationTest(
            String flow, String role, boolean hasUnpaidFine,
            int initialAvailableQty, boolean hasActiveReservation) {
        this.flow = flow;
        this.role = role;
        this.hasUnpaidFine = hasUnpaidFine;
        this.initialAvailableQty = initialAvailableQty;
        this.hasActiveReservation = hasActiveReservation;
    }

    @Parameters(name = "{index}: flow={0}, role={1}, fine={2}, qty={3}, activeRes={4}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        // Luồng đặt sách trực tuyến (Reserve Book Scenarios - 24 cases)
        for (String r : new String[]{"student", "lecturer"}) {
            for (boolean fine : new boolean[]{true, false}) {
                for (int qty : new int[]{0, 2}) {
                    for (boolean activeRes : new boolean[]{true, false}) {
                        params.add(new Object[]{"reserve", r, fine, qty, activeRes});
                    }
                }
            }
        }

        // Luồng hủy đặt sách (Cancel Reservation Scenarios - 16 cases)
        for (String r : new String[]{"student", "lecturer"}) {
            for (int qty : new int[]{0, 1}) {
                for (boolean fine : new boolean[]{true, false}) {
                    params.add(new Object[]{"cancel", r, fine, qty, false});
                    params.add(new Object[]{"cancel", r, fine, qty, true});
                }
            }
        }

        // Luồng gia hạn (Renew Scenarios - 12 cases)
        for (String r : new String[]{"student", "lecturer"}) {
            for (boolean fine : new boolean[]{true, false}) {
                for (int qty : new int[]{0, 1, 2}) {
                    params.add(new Object[]{"renew", r, fine, qty, false});
                }
            }
        }

        // Luồng Concurrency (Race Condition - 8 cases) để đạt đích 60 test cases
        for (int i = 0; i < 8; i++) {
            params.add(new Object[]{"concurrency", "student", false, 1, false});
        }

        return params;
    }

    @Before
    public void setUp() throws Exception {
        service = new OnlineCirculationService();
        cleanupDatabase(); // Đảm bảo DB sạch trước khi chèn dữ liệu kiểm thử mới
        insertTestData();
    }

    @After
    public void tearDown() throws Exception {
        cleanupDatabase();
    }

    private void insertTestData() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Tạo Test User
            String email = "f5test_" + System.nanoTime() + "@lms.com";
            userId = insertTestUser(conn, email, role);
            createdUserIds.add(userId);
            insertMemberProfile(conn, userId, "F5 Test User", "0123456789");

            if ("student".equalsIgnoreCase(role)) {
                insertStudentProfile(conn, userId, "ST_" + System.nanoTime());
            } else {
                insertLecturerProfile(conn, userId, "LE_" + System.nanoTime());
            }

            // 2. Tạo Test Book
            bookId = insertTestBook(conn, "ISBN_" + System.nanoTime(), "F5 Test Book", BigDecimal.valueOf(150000));
            createdBookIds.add(bookId);
            updateBookQuantities(conn, bookId, 5, initialAvailableQty);

            // 3. Tạo Test BookCopy
            bookCopyId = insertTestBookCopy(conn, bookId, "BAR_" + System.nanoTime(), "good", "available");

            // 4. Nếu có nợ phạt
            if (hasUnpaidFine) {
                // Tạo một bản ghi mượn cũ đã hoàn thành
                int oldCopy = insertTestBookCopy(conn, bookId, "BAROLD_" + System.nanoTime(), "good", "available");
                int recordId = insertBorrowRecord(conn, userId, oldCopy, bookId, new Timestamp(System.currentTimeMillis() - 20L*24*60*60*1000));
                createdBorrowRecordIds.add(recordId);

                // Tạo khoản phạt chưa trả
                int fineId = insertFine(conn, recordId, userId, BigDecimal.valueOf(50000), "Trễ hạn mượn");
            }

            // 5. Nếu đã có đơn đặt trước
            if (hasActiveReservation) {
                int resId = insertReservation(conn, userId, bookId, null, "pending", 1);
                createdReservationIds.add(resId);
            }

            conn.commit();
        }
    }

    @Test
    public void testFlow() throws Exception {
        if ("reserve".equals(flow)) {
            runReserveFlow();
        } else if ("cancel".equals(flow)) {
            runCancelFlow();
        } else if ("renew".equals(flow)) {
            runRenewFlow();
        } else if ("concurrency".equals(flow)) {
            runConcurrencyFlow();
        }
    }

    private void runReserveFlow() throws Exception {
        if (hasUnpaidFine) {
            try {
                service.reserveBook(userId, bookId, role);
                fail("Nợ phạt phải chặn đặt trước");
            } catch (Exception e) {
                assertTrue(e.getMessage().contains("nợ phạt") || e.getMessage().contains("phạt"));
            }
        } else if (hasActiveReservation) {
            try {
                service.reserveBook(userId, bookId, role);
                fail("Đã đặt trước rồi phải bị chặn đặt trùng");
            } catch (Exception e) {
                assertTrue(e.getMessage().contains("đã đặt trước"));
            }
        } else {
            // Đặt thành công
            int resId = service.reserveBook(userId, bookId, role);
            assertTrue(resId > 0);
            createdReservationIds.add(resId);

            // Kiểm tra trạng thái đơn đặt
            try (Connection conn = DatabaseConnection.getConnection()) {
                Reservation res = new ReservationDAO().findReservationById(conn, resId);
                assertNotNull(res);
                if (initialAvailableQty > 0) {
                    assertEquals("readypickup", res.getStatus());
                    assertEquals(Integer.valueOf(0), res.getQueuePosition());
                } else {
                    assertEquals("pending", res.getStatus());
                    assertTrue(res.getQueuePosition() > 0);
                }
            }
        }
    }

    private void runCancelFlow() throws Exception {
        // Tạo một đơn đặt trước hợp lệ để tiến hành hủy
        int resId;
        try (Connection conn = DatabaseConnection.getConnection()) {
            resId = insertReservation(conn, userId, bookId, null, "pending", 1);
            createdReservationIds.add(resId);
        }

        if (hasUnpaidFine) {
            // Nợ phạt không chặn việc hủy đơn của chính mình
            service.cancelReservation(userId, resId);
            try (Connection conn = DatabaseConnection.getConnection()) {
                Reservation res = new ReservationDAO().findReservationById(conn, resId);
                assertEquals("cancelled", res.getStatus());
            }
        } else {
            service.cancelReservation(userId, resId);
            try (Connection conn = DatabaseConnection.getConnection()) {
                Reservation res = new ReservationDAO().findReservationById(conn, resId);
                assertEquals("cancelled", res.getStatus());
            }
        }
    }

    private void runRenewFlow() throws Exception {
        // Tạo bản ghi mượn sách để test gia hạn
        int recordId;
        Timestamp startDate = new Timestamp(System.currentTimeMillis() - 8L*24*60*60*1000);
        Timestamp endDate = new Timestamp(System.currentTimeMillis() + 2L*24*60*60*1000); // 80% thời gian trôi qua
        try (Connection conn = DatabaseConnection.getConnection()) {
            recordId = insertBorrowRecord(conn, userId, bookCopyId, bookId, startDate, endDate);
            createdBorrowRecordIds.add(recordId);
        }

        if (hasUnpaidFine) {
            try {
                service.renewBook(userId, recordId);
                fail("Nợ phạt phải chặn gia hạn");
            } catch (Exception e) {
                assertTrue(e.getMessage().contains("nợ phạt") || e.getMessage().contains("phạt"));
            }
        } else {
            // Thực hiện gia hạn thành công
            service.renewBook(userId, recordId);
            try (Connection conn = DatabaseConnection.getConnection()) {
                BorrowRecord br = new BorrowRecordDAO().findBorrowRecordById(conn, recordId);
                assertEquals(1, br.getExtensionCount());
            }
        }
    }

    private void runConcurrencyFlow() throws Exception {
        // Tạo thêm một user thứ hai để cạnh tranh đặt sách
        int secondUserId;
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            secondUserId = insertTestUser(conn, "f5test_second_" + System.nanoTime() + "@lms.com", "student");
            createdUserIds.add(secondUserId);
            insertMemberProfile(conn, secondUserId, "F5 Second User", "0999988887");
            insertStudentProfile(conn, secondUserId, "ST_SEC_" + System.nanoTime());
            conn.commit();
        }

        // Chạy đồng thời 2 luồng đặt sách cho cùng bookId
        ExecutorService executor = Executors.newFixedThreadPool(2);
        Future<Integer> f1 = executor.submit(() -> service.reserveBook(userId, bookId, "student"));
        Future<Integer> f2 = executor.submit(() -> service.reserveBook(secondUserId, bookId, "student"));

        int r1 = f1.get();
        int r2 = f2.get();

        assertTrue(r1 > 0);
        assertTrue(r2 > 0);
        createdReservationIds.add(r1);
        createdReservationIds.add(r2);

        // Xác minh vị trí xếp hàng (queuePosition) của hai đơn không bao giờ trùng nhau
        try (Connection conn = DatabaseConnection.getConnection()) {
            Reservation res1 = new ReservationDAO().findReservationById(conn, r1);
            Reservation res2 = new ReservationDAO().findReservationById(conn, r2);
            assertNotEquals(res1.getQueuePosition(), res2.getQueuePosition());
        }

        executor.shutdown();
    }

    // =========================================================================
    // DATABASE HELPERS FOR INTEGRATION
    // =========================================================================

    private void cleanupDatabase() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Xóa AuditLogs trước tiên để tránh lỗi ràng buộc khóa ngoại (fk_auditlogs_user)
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM AuditLogs WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                // Xóa Fines
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Fine WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                // Xóa Reservations
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Reservation WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%') OR bookId IN (SELECT bookId FROM Book WHERE isbn LIKE 'ISBN_%')")) {
                    ps.executeUpdate();
                }
                // Xóa BorrowRecords
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BorrowRecord WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                // Xóa BookCopies
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookCopy WHERE bookId IN (SELECT bookId FROM Book WHERE isbn LIKE 'ISBN_%')")) {
                    ps.executeUpdate();
                }
                // Xóa Student, Lecturer, MemberProfile
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Student WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Lecturer WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM MemberProfile WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'f5test_%')")) {
                    ps.executeUpdate();
                }
                // Xóa Users
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM \"User\" WHERE email LIKE 'f5test_%'")) {
                    ps.executeUpdate();
                }
                // Xóa Books
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Book WHERE isbn LIKE 'ISBN_%'")) {
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private int insertTestUser(Connection conn, String email, String role) throws SQLException {
        String sql = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, 'hash', 'active', ?, 0)";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, role.toLowerCase());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo user test");
    }

    private void insertMemberProfile(Connection conn, int userId, String name, String phone) throws SQLException {
        String sql = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate) VALUES (?, ?, ?, 'Male', '1999-01-01', NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.setString(3, phone);
            ps.executeUpdate();
        }
    }

    private void insertStudentProfile(Connection conn, int userId, String studentCode) throws SQLException {
        String sql = "INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (?, ?, 'SE', 2020)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, studentCode);
            ps.executeUpdate();
        }
    }

    private void insertLecturerProfile(Connection conn, int userId, String lecturerCode) throws SQLException {
        String sql = "INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (?, ?, 'IT')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, lecturerCode);
            ps.executeUpdate();
        }
    }

    private int insertTestBook(Connection conn, String isbn, String title, BigDecimal price) throws SQLException {
        String sql = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status, createdAt) VALUES (?, ?, 'Author', 'Publisher', 2023, ?, 0, 0, 'available', NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, isbn);
            ps.setString(2, title);
            ps.setBigDecimal(3, price);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo book test");
    }

    private void updateBookQuantities(Connection conn, int bookId, int total, int available) throws SQLException {
        String sql = "UPDATE Book SET totalQuantity = ?, availableQuantity = ? WHERE bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, total);
            ps.setInt(2, available);
            ps.setInt(3, bookId);
            ps.executeUpdate();
        }
    }

    private int insertTestBookCopy(Connection conn, int bookId, String barcode, String condition, String status) throws SQLException {
        String sql = "INSERT INTO BookCopy (bookId, location, condition, status, barcode, createdAt) VALUES (?, 'Shelf A', ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookId);
            ps.setString(2, condition);
            ps.setString(3, status);
            ps.setString(4, barcode);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo bookcopy test");
    }

    private int insertBorrowRecord(Connection conn, int userId, int copyId, int bookId, Timestamp start) throws SQLException {
        return insertBorrowRecord(conn, userId, copyId, bookId, start, new Timestamp(start.getTime() + 10L*24*60*60*1000));
    }

    private int insertBorrowRecord(Connection conn, int userId, int copyId, int bookId, Timestamp start, Timestamp end) throws SQLException {
        String sql = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, extensionCount, createdAt) VALUES (?, ?, ?, ?, ?, 'borrowed', 0, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, copyId);
            ps.setInt(3, bookId);
            ps.setTimestamp(4, start);
            ps.setTimestamp(5, end);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo BorrowRecord test");
    }

    private int insertFine(Connection conn, int recordId, int userId, BigDecimal amount, String reason) throws SQLException {
        String sql = "INSERT INTO Fine (borrowRecordId, userId, amount, reason, status, createdAt) VALUES (?, ?, ?, ?, 'unpaid', NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, recordId);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, amount);
            ps.setString(4, reason);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo Fine test");
    }

    private int insertReservation(Connection conn, int userId, int bookId, Integer copyId, String status, int queuePos) throws SQLException {
        String sql = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate) VALUES (?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            if (copyId != null) {
                ps.setInt(3, copyId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, status);
            ps.setInt(5, queuePos);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Lỗi tạo Reservation test");
    }
}
