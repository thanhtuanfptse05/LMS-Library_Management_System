package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.BookCopy;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import util.DatabaseConnection;

public class BookCopyDAOTest {

    @Test
    public void insertCreatesGoodAvailableCopy() throws Exception {
        BookCopyDAO bookCopyDAO = new BookCopyDAO();
        BookDAO bookDAO = new BookDAO();
        BookCopy copy = new BookCopy();
        copy.setBookId(findBookId());
        copy.setBarcode("BC-TEST-" + System.nanoTime());
        copy.setLocation("Kho kiểm thử · Kệ 01");

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int[] before = findQuantities(conn, copy.getBookId());
                int copyId = bookCopyDAO.insert(conn, copy);
                bookDAO.updateQuantities(conn, copy.getBookId(), 1, 1);
                assertTrue(copyId > 0);
                BookCopy saved = bookCopyDAO.findById(conn, copyId);
                assertNotNull(saved);
                assertEquals("good", saved.getCondition());
                assertEquals("available", saved.getStatus());
                int[] after = findQuantities(conn, copy.getBookId());
                assertEquals(before[0] + 1, after[0]);
                assertEquals(before[1] + 1, after[1]);
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    private int[] findQuantities(Connection conn, int bookId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT totalQuantity, availableQuantity FROM Book WHERE bookId = ?")) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                return new int[]{rs.getInt("totalQuantity"), rs.getInt("availableQuantity")};
            }
        }
    }

    private int findBookId() throws Exception {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT bookId FROM Book ORDER BY bookId LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            assertTrue("Database cần ít nhất một đầu sách để kiểm thử BookCopyDAO.", rs.next());
            return rs.getInt(1);
        }
    }
}
