package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import model.Fine;
import org.junit.Test;
import static org.junit.Assert.*;
import util.DatabaseConnection;

public class FineDAOTest {

    private int[] setupDependencies(Connection conn) throws SQLException {
        int[] ids = new int[4]; // user, book, copy, borrowRecord
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        
        String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, 'hash', 'active', 'STUDENT', 0)";
        try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
            psUser.setString(1, "finetest_" + suffix + "@uni.edu.vn");
            psUser.executeUpdate();
            try (ResultSet rs = psUser.getGeneratedKeys()) {
                if (rs.next()) ids[0] = rs.getInt(1);
            }
        }
        
        String sqlBook = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status) VALUES (?, 'Test Book', 'Author', 'Pub', 2024, 100000, 1, 1, 'available')";
        try (PreparedStatement psBook = conn.prepareStatement(sqlBook, Statement.RETURN_GENERATED_KEYS)) {
            psBook.setString(1, "ISBN-" + suffix);
            psBook.executeUpdate();
            try (ResultSet rs = psBook.getGeneratedKeys()) {
                if (rs.next()) ids[1] = rs.getInt(1);
            }
        }
        
        String sqlCopy = "INSERT INTO BookCopy (bookId, barcode, location, condition, status) VALUES (?, ?, 'Shelf', 'good', 'borrowed')";
        try (PreparedStatement psCopy = conn.prepareStatement(sqlCopy, Statement.RETURN_GENERATED_KEYS)) {
            psCopy.setInt(1, ids[1]);
            psCopy.setString(2, "BC-" + suffix);
            psCopy.executeUpdate();
            try (ResultSet rs = psCopy.getGeneratedKeys()) {
                if (rs.next()) ids[2] = rs.getInt(1);
            }
        }

        String sqlBorrow = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, createdBy) VALUES (?, ?, ?, NOW(), NOW(), 'borrowed', ?)";
        try (PreparedStatement psBorrow = conn.prepareStatement(sqlBorrow, Statement.RETURN_GENERATED_KEYS)) {
            psBorrow.setInt(1, ids[0]);
            psBorrow.setInt(2, ids[2]);
            psBorrow.setInt(3, ids[1]);
            psBorrow.setInt(4, ids[0]);
            psBorrow.executeUpdate();
            try (ResultSet rs = psBorrow.getGeneratedKeys()) {
                if (rs.next()) ids[3] = rs.getInt(1);
            }
        }
        return ids;
    }

    @Test
    public void testInsertOverdueFine_Success() throws Exception {
        FineDAO fDAO = new FineDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                BigDecimal amount = new BigDecimal("50000");
                int fineId = fDAO.insertOverdueFine(conn, ids[3], ids[0], amount, "Quá hạn 1 ngày");
                assertTrue("ID tiền phạt phải lớn hơn 0", fineId > 0);
                
                // Verify by total
                BigDecimal total = fDAO.getTotalUnpaidFinesByUser(conn, ids[0]);
                assertEquals(0, amount.compareTo(total));
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testUpdateStatusToPaid_Success() throws Exception {
        FineDAO fDAO = new FineDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                BigDecimal amount = new BigDecimal("50000");
                int fineId = fDAO.insertCompensationFine(conn, ids[3], ids[0], amount, "Làm hỏng sách");
                
                fDAO.updateStatusToPaid(conn, fineId);
                
                // Trả rồi thì total unpaid = 0
                BigDecimal total = fDAO.getTotalUnpaidFinesByUser(conn, ids[0]);
                assertEquals(0, BigDecimal.ZERO.compareTo(total));
                
                // Trả rồi thì không còn hasUnpaidFines
                assertFalse(fDAO.hasUnpaidFines(conn, ids[0]));
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testHasUnpaidFines() throws Exception {
        FineDAO fDAO = new FineDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                
                // Chưa có phạt
                assertFalse("Chưa có phạt thì phải trả về false", fDAO.hasUnpaidFines(conn, ids[0]));
                
                // Thêm 1 khoản phạt
                fDAO.insertOverdueFine(conn, ids[3], ids[0], new BigDecimal("10000"), "Late");
                
                // Bây giờ phải là true
                assertTrue("Có khoản phạt chưa nộp phải trả về true", fDAO.hasUnpaidFines(conn, ids[0]));
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }
}
