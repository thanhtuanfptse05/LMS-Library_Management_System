package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Reservation;
import org.junit.Test;
import static org.junit.Assert.*;
import util.DatabaseConnection;

public class ReservationDAOTest {

    private int[] setupDependencies(Connection conn) throws SQLException {
        int[] ids = new int[3];
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        
        String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, 'hash', 'active', 'STUDENT', 0)";
        try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
            psUser.setString(1, "restest_" + suffix + "@uni.edu.vn");
            psUser.executeUpdate();
            try (ResultSet rs = psUser.getGeneratedKeys()) {
                if (rs.next()) ids[0] = rs.getInt(1);
            }
        }
        
        String sqlBook = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status) VALUES (?, 'Res Test Book', 'Author', 'Pub', 2024, 100000, 1, 1, 'available')";
        try (PreparedStatement psBook = conn.prepareStatement(sqlBook, Statement.RETURN_GENERATED_KEYS)) {
            psBook.setString(1, "ISBN-" + suffix);
            psBook.executeUpdate();
            try (ResultSet rs = psBook.getGeneratedKeys()) {
                if (rs.next()) ids[1] = rs.getInt(1);
            }
        }
        
        String sqlCopy = "INSERT INTO BookCopy (bookId, barcode, location, condition, status) VALUES (?, ?, 'Shelf', 'good', 'available')";
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
    public void testInsertWalkIn_Success() throws Exception {
        ReservationDAO rDAO = new ReservationDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                int userId = ids[0];
                int bookId = ids[1];
                int bookCopyId = ids[2];
                
                int reservationId = rDAO.insertWalkIn(conn, userId, bookId, bookCopyId);
                assertTrue("ID reservation phải lớn hơn 0", reservationId > 0);
                
                Reservation r = rDAO.findReservationById(conn, reservationId);
                assertNotNull(r);
                assertEquals("pending", r.getStatus());
                assertEquals(Integer.valueOf(0), r.getQueuePosition());
                assertEquals(bookCopyId, (int) r.getBookCopyId());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testUpdateToReadyPickup_Success() throws Exception {
        ReservationDAO rDAO = new ReservationDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                
                // Insert a pending reservation (queue 1)
                int reservationId = rDAO.insertOnlineReservation(conn, ids[0], ids[1], 1);
                
                // Update to ready pickup
                rDAO.updateToReadyPickup(conn, reservationId, ids[2]);
                
                Reservation r = rDAO.findReservationById(conn, reservationId);
                assertEquals("readypickup", r.getStatus());
                assertEquals(Integer.valueOf(0), r.getQueuePosition());
                assertEquals(ids[2], (int) r.getBookCopyId());
                assertNotNull(r.getEndDate());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testFindNextInQueue_FoundAndNotFound() throws Exception {
        ReservationDAO rDAO = new ReservationDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] ids = setupDependencies(conn);
                
                // Trống rỗng thì find phải trả về null
                Reservation r1 = rDAO.findNextInQueue(conn, ids[1]);
                assertNull("Chưa có ai chờ, phải trả về null", r1);
                
                // Thêm 1 người chờ
                rDAO.insertOnlineReservation(conn, ids[0], ids[1], 1);
                
                Reservation r2 = rDAO.findNextInQueue(conn, ids[1]);
                assertNotNull("Phải tìm thấy người chờ đầu tiên", r2);
                assertEquals(ids[0], r2.getUserId());
                assertEquals(Integer.valueOf(1), r2.getQueuePosition());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }
}
