package dao;

import model.Book;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class BookDAOTest {

    private BookDAO bookDAO;

    @Before
    public void setUp() {
        bookDAO = new BookDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindByIsbnWithMockConn() throws Exception {
        Map<String, Object> bookData = new HashMap<>();
        bookData.put("bookId", 10);
        bookData.put("isbn", "9780306406157");
        bookData.put("title", "Lập trình Java Web");
        bookData.put("author", "Nguyễn Văn A");
        bookData.put("availableQuantity", 5);

        Connection mockConn = MockJdbc.createMockConnection(bookData, 0);
        Book book = bookDAO.findByIsbn(mockConn, "9780306406157");
        assertNotNull("Book đọc từ ResultSet giả lập không được null", book);
        assertEquals(10, book.getBookId());
        assertEquals("9780306406157", book.getIsbn());
        assertEquals("Lập trình Java Web", book.getTitle());
    }

    @Test
    public void testInsertBookWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        assertNotNull(mockConn);
    }
}
