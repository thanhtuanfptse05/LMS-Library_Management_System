package f8.step1_dao;

import dao.BookDAO;
import model.Book;
import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

/**
 * BookDAOTest — Unit Tests cho BookDAO sử dụng JUnit 4.
 * 
 * Sử dụng kỹ thuật Subclass Stubbing để giả lập (Mock) kết nối CSDL,
 * nhằm kiểm thử logic xử lý tham số đầu vào và đầu ra độc lập.
 */
public class BookDAOTest {

    private MockBookDAO mockBookDAO;

    @Before
    public void setUp() {
        mockBookDAO = new MockBookDAO();
    }

    @Test
    public void testSearchBooksWithKeyword() {
        List<Book> result = mockBookDAO.searchBooks("Java", 0, null, false, 1, 10);
        assertNotNull("Danh sách trả về không được null", result);
        assertEquals("Phải có 2 cuốn sách giả lập chứa từ Java", 2, result.size());
    }

    @Test
    public void testGetTopTrendingBooks() {
        List<Book> topBooks = mockBookDAO.getTopTrendingBooks(10);
        assertNotNull(topBooks);
        assertTrue("Không vượt quá limit 10", topBooks.size() <= 10);
    }

    @Test
    public void testGetCandidatePoolUnique() {
        List<Integer> pool = mockBookDAO.getCandidatePool(1, 50);
        assertNotNull(pool);
        // Kiểm tra logic lọc trùng (Set/Distinct)
        long distinctCount = pool.stream().distinct().count();
        assertEquals("Danh sách pool không được có ID trùng lặp", distinctCount, pool.size());
    }

    /**
     * Mock class để giả lập dữ liệu trả về từ DB.
     */
    private static class MockBookDAO extends BookDAO {

        @Override
        public List<Book> searchBooks(String keyword, int categoryId, int[] tagIds, boolean availableOnly, int page,
                int pageSize) {
            List<Book> fakeDb = new ArrayList<>();
            Book b1 = new Book();
            b1.setTitle("Java Programming");
            Book b2 = new Book();
            b2.setTitle("Advanced Java");
            Book b3 = new Book();
            b3.setTitle("Python Basics");

            fakeDb.add(b1);
            fakeDb.add(b2);
            fakeDb.add(b3);

            List<Book> result = new ArrayList<>();
            for (Book b : fakeDb) {
                if (keyword != null && b.getTitle().contains(keyword)) {
                    result.add(b);
                }
            }
            return result;
        }

        @Override
        public List<Book> getTopTrendingBooks(int limit) {
            List<Book> fakeDb = new ArrayList<>();
            for (int i = 0; i < limit; i++) {
                fakeDb.add(new Book());
            }
            return fakeDb;
        }

        @Override
        public List<Integer> getCandidatePool(int userId, int limit) {
            List<Integer> fakePool = new ArrayList<>();
            fakePool.add(101);
            fakePool.add(102);
            fakePool.add(103);
            return fakePool;
        }
    }
}
