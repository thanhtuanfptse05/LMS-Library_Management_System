package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Book;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import util.DatabaseConnection;

public class BookDAOTest {

    @Test
    public void insertCreatesBookWithZeroInventory() throws Exception {
        BookDAO bookDAO = new BookDAO();
        Book book = new Book();
        String suffix = String.valueOf(System.nanoTime());
        book.setIsbn("978-TEST-" + suffix.substring(suffix.length() - 8));
        book.setTitle("Đầu sách kiểm thử DAO");
        book.setAuthor("Nhóm kiểm thử");
        book.setPublisher("LMS");
        book.setPublicationYear(2026);
        book.setPrice(new BigDecimal("100000"));
        book.setImagePath("00000000-0000-0000-0000-000000000001.png");

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int bookId = bookDAO.insert(conn, book);
                assertTrue(bookId > 0);
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT imagePath, totalQuantity, availableQuantity FROM Book WHERE bookId = ?")) {
                    ps.setInt(1, bookId);
                    try (ResultSet rs = ps.executeQuery()) {
                        assertTrue(rs.next());
                        assertEquals(book.getImagePath(), rs.getString("imagePath"));
                        assertEquals(0, rs.getInt("totalQuantity"));
                        assertEquals(0, rs.getInt("availableQuantity"));
                    }
                }
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }
}
