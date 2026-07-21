package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import model.BorrowRecord;
import org.junit.Test;
import static org.junit.Assert.*;
import util.DatabaseConnection;

public class BorrowRecordDAOTest {

    // Helper method to setup dummy data for FK constraints
    private int[] setupDependencies(Connection conn) throws SQLException {
        int[] ids = new int[3]; // [userId, bookId, bookCopyId]
        
        // 1. Insert User
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, 'hash', 'active', 'STUDENT', 0)";
        try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
            psUser.setString(1, "brtest_" + suffix + "@uni.edu.vn");
            psUser.executeUpdate();
            try (ResultSet rs = psUser.getGeneratedKeys()) {
                if (rs.next()) ids[0] = rs.getInt(1);
            }
        }
        
        // 2. Insert Book
        String sqlBook = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status) VALUES (?, 'Test Book', 'Test Author', 'Publisher', 2024, 100000, 1, 1, 'available')";
        try (PreparedStatement psBook = conn.prepareStatement(sqlBook, Statement.RETURN_GENERATED_KEYS)) {
            psBook.setString(1, "ISBN-" + suffix);
            psBook.executeUpdate();
            try (ResultSet rs = psBook.getGeneratedKeys()) {
                if (rs.next()) ids[1] = rs.getInt(1);
            }
        }
        
        // 3. Insert BookCopy
        String sqlCopy = "INSERT INTO BookCopy (bookId, barcode, location, condition, status) VALUES (?, ?, 'Shelf 1', 'good', 'available')";
        try (PreparedStatement psCopy = conn.prepareStatement(sqlCopy, Statement.RETURN_GENERATED_KEYS)) {
            psCopy.setInt(1, ids[1]);
            psCopy.setString(2, "BC-" + suffix);
            psCopy.executeUpdate();
            try (ResultSet rs = psCopy.getGeneratedKeys()) {
                if (rs.next()) ids[2] = rs.getInt(1);
            }
        }
        return ids;
    }

    @Test
    public void testInsertBorrowRecord_Success() throws Exception {
        BorrowRecordDAO brDAO = new BorrowRecordDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                int userId = ids[0];
                int bookId = ids[1];
                int bookCopyId = ids[2];
                
                Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L); // +7 days
                
                int recordId = brDAO.insert(conn, userId, bookCopyId, bookId, userId, endDate);
                assertTrue("ID phiếu mượn phải lớn hơn 0", recordId > 0);
                
                // Verify DB
                BorrowRecord record = brDAO.findBorrowRecordById(conn, recordId);
                assertNotNull("Phải tìm thấy phiếu mượn", record);
                assertEquals("Trạng thái mặc định phải là borrowed", "borrowed", record.getStatus());
                assertEquals("Người mượn phải khớp", userId, record.getUserId());
                assertEquals("Bản sao sách phải khớp", bookCopyId, record.getBookCopyId());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testInsertBorrowRecord_FK_Failure() throws Exception {
        BorrowRecordDAO brDAO = new BorrowRecordDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L);
                
                // Cố tình truyền userId = -1 (không tồn tại)
                try {
                    brDAO.insert(conn, -1, 1, 1, 1, endDate);
                    fail("Phải văng exception khi vi phạm khóa ngoại (userId không tồn tại)");
                } catch (SQLException e) {
                    assertNotNull(e);
                }
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testUpdateStatusToReturned_Success() throws Exception {
        BorrowRecordDAO brDAO = new BorrowRecordDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L);
                int recordId = brDAO.insert(conn, ids[0], ids[2], ids[1], ids[0], endDate);
                
                brDAO.updateStatusToReturned(conn, recordId);
                
                BorrowRecord record = brDAO.findBorrowRecordById(conn, recordId);
                assertEquals("Trạng thái phải là returned", "returned", record.getStatus());
                assertNotNull("returnedAt không được null", record.getReturnedAt());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testFindActiveBorrowRecord_Found() throws Exception {
        BorrowRecordDAO brDAO = new BorrowRecordDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L);
                brDAO.insert(conn, ids[0], ids[2], ids[1], ids[0], endDate);
                
                // Tìm kiếm theo bookCopyId
                BorrowRecord record = brDAO.findActiveBorrowRecord(conn, ids[2]);
                assertNotNull("Phải tìm thấy active record", record);
                assertEquals(ids[0], record.getUserId());
                assertEquals("borrowed", record.getStatus());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }
}
