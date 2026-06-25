package service;

import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import model.BorrowRecord;
import model.Fine;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.junit.Assert.*;

/**
 * OverdueProcessorTest - Kiểm thử tự động tiến trình quét quá hạn trả sách tự động.
 */
public class OverdueProcessorTest {
    private static final Logger LOGGER = Logger.getLogger(OverdueProcessorTest.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();
    private final UserDAO userDAO = new UserDAO();

    private int testUserId;
    private int testBookId;
    private int testBookCopyId;
    private int testBorrowRecordId;

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
                // 1. Tạo 1 User kiểm thử
                String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role) VALUES (?, 'hash', 'active', 'STUDENT')";
                try (PreparedStatement ps = conn.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, "test_overdue_u1@example.com");
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            testUserId = rs.getInt(1);
                        }
                    }
                }

                // 2. Tạo Member Profile
                String sqlProfile = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) "
                                  + "VALUES (?, 'Độc Giả Quá Hạn A', '0901234567', 'male', '2000-01-01', NOW(), NOW() + INTERVAL '4 years')";
                try (PreparedStatement ps = conn.prepareStatement(sqlProfile)) {
                    ps.setInt(1, testUserId);
                    ps.executeUpdate();
                }

                // 3. Tạo Book
                String sqlBook = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status) "
                               + "VALUES ('TEST-ISBN-OD1', 'Sách Kiểm Thử Quá Hạn', 'Tác giả', 'Nhà XB', 2026, 100000, 1, 0, 'available')";
                try (PreparedStatement ps = conn.prepareStatement(sqlBook, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            testBookId = rs.getInt(1);
                        }
                    }
                }

                // 4. Tạo BookCopy
                String sqlCopy = "INSERT INTO BookCopy (bookId, location, condition, status, barcode) "
                               + "VALUES (?, 'Kệ A1', 'good', 'borrowed', 'BARCODE-OD-001')";
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

    private void cleanupDatabase() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Xóa Fine trước
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Fine WHERE userId IN (SELECT userId FROM \"User\" WHERE email = 'test_overdue_u1@example.com')")) {
                    ps.executeUpdate();
                }
                // Xóa BorrowRecord
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BorrowRecord WHERE userId IN (SELECT userId FROM \"User\" WHERE email = 'test_overdue_u1@example.com')")) {
                    ps.executeUpdate();
                }
                // Xóa BookCopy
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookCopy WHERE bookId IN (SELECT bookId FROM Book WHERE isbn = 'TEST-ISBN-OD1')")) {
                    ps.executeUpdate();
                }
                // Xóa Book
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Book WHERE isbn = 'TEST-ISBN-OD1'")) {
                    ps.executeUpdate();
                }
                // Xóa MemberProfile
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM MemberProfile WHERE userId IN (SELECT userId FROM \"User\" WHERE email = 'test_overdue_u1@example.com')")) {
                    ps.executeUpdate();
                }
                // Xóa LockReason
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM UserLockReason WHERE userId IN (SELECT userId FROM \"User\" WHERE email = 'test_overdue_u1@example.com')")) {
                    ps.executeUpdate();
                }
                // Xóa AuditLogs
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM AuditLogs WHERE actionType = 'LOCK_USER' AND entityId IN (SELECT userId FROM \"User\" WHERE email = 'test_overdue_u1@example.com')")) {
                    ps.executeUpdate();
                }
                // Xóa User
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM \"User\" WHERE email = 'test_overdue_u1@example.com'")) {
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
    public void testProcessNoOverdueRecords() throws SQLException {
        // Chuẩn bị kịch bản: Hạn trả là ngày mai (chưa quá hạn)
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sqlBorrow = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, extensionCount) "
                             + "VALUES (?, ?, ?, NOW() - INTERVAL '1 day', NOW() + INTERVAL '1 day', 'borrowed', 0)";
            try (PreparedStatement ps = conn.prepareStatement(sqlBorrow)) {
                ps.setInt(1, testUserId);
                ps.setInt(2, testBookCopyId);
                ps.setInt(3, testBookId);
                ps.executeUpdate();
            }
        }

        OverdueProcessor processor = new OverdueProcessor();
        OverdueProcessor.OverdueResult result = processor.processOverdue();

        assertEquals("Nếu không có record trễ hạn, processedRecords phải bằng 0", 0, result.processedRecords);
        assertEquals("Nếu không có record trễ hạn, lockedUsers phải bằng 0", 0, result.lockedUsers);
    }

    @Test
    public void testProcessOneOverdueRecord() throws SQLException {
        // Chuẩn bị kịch bản: Hạn trả là ngày hôm qua (trễ hạn 1 ngày)
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sqlBorrow = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, extensionCount) "
                             + "VALUES (?, ?, ?, NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day', 'borrowed', 0)";
            try (PreparedStatement ps = conn.prepareStatement(sqlBorrow, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, testUserId);
                ps.setInt(2, testBookCopyId);
                ps.setInt(3, testBookId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        testBorrowRecordId = rs.getInt(1);
                    }
                }
            }
        }

        OverdueProcessor processor = new OverdueProcessor();
        OverdueProcessor.OverdueResult result = processor.processOverdue();

        assertEquals("Phải xử lý thành công 1 record quá hạn", 1, result.processedRecords);
        assertEquals("Phải khóa thêm 1 tài khoản độc giả", 1, result.lockedUsers);

        // Kiểm tra xem dữ liệu trong DB đã cập nhật đúng chưa
        try (Connection conn = DatabaseConnection.getConnection()) {
            // 1. BorrowRecord status chuyển sang 'overdue'
            String sqlCheckBorrow = "SELECT status FROM BorrowRecord WHERE borrowRecordId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckBorrow)) {
                ps.setInt(1, testBorrowRecordId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals("overdue", rs.getString("status"));
                }
            }

            // 2. Có bản ghi Fine unpaid được tạo với số tiền 5000 VND
            String sqlCheckFine = "SELECT amount, status FROM Fine WHERE borrowRecordId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckFine)) {
                ps.setInt(1, testBorrowRecordId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals(0, BigDecimal.valueOf(5000).compareTo(rs.getBigDecimal("amount")));
                    assertEquals("unpaid", rs.getString("status"));
                }
            }

            // 3. User có lý do khóa 'unpaid' và status = 'locked'
            String sqlCheckUser = "SELECT status FROM \"User\" WHERE userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckUser)) {
                ps.setInt(1, testUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals("locked", rs.getString("status"));
                }
            }

            assertTrue("UserLockReason phải chứa cờ 'unpaid'", userLockReasonDAO.hasReason(testUserId, "unpaid"));
        }
    }
}
