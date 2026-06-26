package service;

import dao.BookCopyDAO;
import dao.BookDAO;
import dao.ReservationDAO;
import dao.UserDAO;
import model.Reservation;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.junit.Assert.*;

/**
 * ReservationExpirationProcessorTest - Unit/Integration Tests cho tiến trình hủy đặt trước quá hạn.
 */
public class ReservationExpirationProcessorTest {
    private static final Logger LOGGER = Logger.getLogger(ReservationExpirationProcessorTest.class.getName());

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookDAO bookDAO = new BookDAO();

    private int testUserId1;
    private int testUserId2;
    private int testUserId3;
    private int testBookId;
    private int testBookCopyId;

    @Before
    public void setUp() throws Exception {
        cleanupDatabase();
        prepareTestData();
    }

    @After
    public void tearDown() throws Exception {
        cleanupDatabase();
    }

    private void prepareTestData() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Tạo 3 Users kiểm thử
                testUserId1 = insertTestUser(conn, "test_exp_u1@example.com", "student");
                testUserId2 = insertTestUser(conn, "test_exp_u2@example.com", "student");
                testUserId3 = insertTestUser(conn, "test_exp_u3@example.com", "student");

                // Tạo profile cho user để tránh NPE khi lấy thông tin gửi email
                insertMemberProfile(conn, testUserId1, "Người A");
                insertMemberProfile(conn, testUserId2, "Người B");
                insertMemberProfile(conn, testUserId3, "Người C");

                // 2. Tạo 1 Book
                String sqlBook = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status) "
                               + "VALUES ('EXP-ISBN-123', 'Sách Kiểm Thử Quá Hạn', 'Tác giả', 'Nhà XB', 2026, 50000, 1, 0, 'available')";
                try (PreparedStatement ps = conn.prepareStatement(sqlBook, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            testBookId = rs.getInt(1);
                        }
                    }
                }

                // 3. Tạo 1 BookCopy
                String sqlCopy = "INSERT INTO BookCopy (bookId, location, condition, status, barcode) "
                               + "VALUES (?, 'Kệ A1', 'good', 'reserved', 'BARCODE-EXP-001')";
                try (PreparedStatement ps = conn.prepareStatement(sqlCopy, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, testBookId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            testBookCopyId = rs.getInt(1);
                        }
                    }
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private int insertTestUser(Connection conn, String email, String role) throws SQLException {
        String sql = "INSERT INTO \"User\" (email, passwordHash, status, role) VALUES (?, 'hash', 'active', ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, role);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private void insertMemberProfile(Connection conn, int userId, String fullName) throws SQLException {
        String sql = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) "
                   + "VALUES (?, ?, '0901234567', 'male', '2000-01-01', NOW(), NOW() + INTERVAL '4 years')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, fullName);
            ps.executeUpdate();
        }
    }

    private void cleanupDatabase() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Xóa Reservation trước
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Reservation WHERE bookId IN (SELECT bookId FROM Book WHERE isbn = 'EXP-ISBN-123')")) {
                    ps.executeUpdate();
                }
                // Xóa BookCopy
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookCopy WHERE bookId IN (SELECT bookId FROM Book WHERE isbn = 'EXP-ISBN-123')")) {
                    ps.executeUpdate();
                }
                // Xóa Book
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Book WHERE isbn = 'EXP-ISBN-123'")) {
                    ps.executeUpdate();
                }
                // Xóa MemberProfile
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM MemberProfile WHERE userId IN (SELECT userId FROM \"User\" WHERE email LIKE 'test_exp_%')")) {
                    ps.executeUpdate();
                }
                // Xóa AuditLogs
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM AuditLogs WHERE actionType = 'CANCEL_EXPIRED_RESERVATION'")) {
                    ps.executeUpdate();
                }
                // Xóa User
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM \"User\" WHERE email LIKE 'test_exp_%'")) {
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    @Test
    public void testProcessNoExpiredReservations() {
        ReservationExpirationProcessor processor = new ReservationExpirationProcessor();
        ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();
        assertEquals("Nếu không có đơn đặt trước quá hạn, cancelledCount phải bằng 0", 0, result.cancelledCount);
        assertEquals("Nếu không có đơn đặt trước quá hạn, promotedCount phải bằng 0", 0, result.promotedCount);
    }

    @Test
    public void testProcessExpiredWithPromotedNextUser() throws SQLException {
        // Chuẩn bị kịch bản: Người A quá hạn (status='readypickup', endDate hôm qua), Người B pending (queuePosition=1)
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Đơn Người A quá hạn (bookCopyId = null theo logic mới)
            String sqlA = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate) "
                        + "VALUES (?, ?, NULL, 'readypickup', 0, NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day')";
            try (PreparedStatement ps = conn.prepareStatement(sqlA)) {
                ps.setInt(1, testUserId1);
                ps.setInt(2, testBookId);
                ps.executeUpdate();
            }

            // Đơn Người B đang pending ở queuePosition = 1
            String sqlB = "INSERT INTO Reservation (userId, bookId, status, queuePosition, startDate, endDate) "
                        + "VALUES (?, ?, 'pending', 1, NOW() - INTERVAL '3 days', NOW() + INTERVAL '2 days')";
            try (PreparedStatement ps = conn.prepareStatement(sqlB)) {
                ps.setInt(1, testUserId2);
                ps.setInt(2, testBookId);
                ps.executeUpdate();
            }
        }

        // Chạy tiến trình xử lý
        ReservationExpirationProcessor processor = new ReservationExpirationProcessor();
        ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();

        assertEquals("Phải hủy thành công 1 đơn quá hạn", 1, result.cancelledCount);
        assertEquals("Phải đôn thành công 1 người chờ tiếp theo", 1, result.promotedCount);

        // Kiểm tra trạng thái trong DB sau khi chạy
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Đơn Người A phải bị hủy
            try (PreparedStatement ps = conn.prepareStatement("SELECT status, queuePosition FROM Reservation WHERE userId = ? AND bookId = ?")) {
                ps.setInt(1, testUserId1);
                ps.setInt(2, testBookId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals("cancelled", rs.getString("status"));
                    assertNull(rs.getObject("queuePosition"));
                }
            }

            // Đơn Người B phải được đôn lên readypickup và bookCopyId vẫn là null
            try (PreparedStatement ps = conn.prepareStatement("SELECT status, queuePosition, bookCopyId FROM Reservation WHERE userId = ? AND bookId = ?")) {
                ps.setInt(1, testUserId2);
                ps.setInt(2, testBookId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals("readypickup", rs.getString("status"));
                    assertEquals(0, rs.getInt("queuePosition"));
                    assertNull(rs.getObject("bookCopyId"));
                }
            }
        }
    }

    @Test
    public void testProcessExpiredQueueEmpty() throws SQLException {
        // Chuẩn bị kịch bản: Người A quá hạn (status='readypickup', endDate hôm qua), Hàng chờ rỗng
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sqlA = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate) "
                        + "VALUES (?, ?, NULL, 'readypickup', 0, NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day')";
            try (PreparedStatement ps = conn.prepareStatement(sqlA)) {
                ps.setInt(1, testUserId1);
                ps.setInt(2, testBookId);
                ps.executeUpdate();
            }
        }

        // Chạy tiến trình xử lý
        ReservationExpirationProcessor processor = new ReservationExpirationProcessor();
        ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();

        assertEquals("Phải hủy thành công 1 đơn quá hạn", 1, result.cancelledCount);
        assertEquals("Hàng chờ rỗng nên promotedCount phải bằng 0", 0, result.promotedCount);

        // Kiểm tra trạng thái trong DB sau khi chạy
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Số lượng khả dụng của sách phải tăng lên 1 (hoàn trả chỗ đã giữ)
            try (PreparedStatement ps = conn.prepareStatement("SELECT availableQuantity FROM Book WHERE bookId = ?")) {
                ps.setInt(1, testBookId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals(1, rs.getInt("availableQuantity"));
                }
            }
        }
    }
}
