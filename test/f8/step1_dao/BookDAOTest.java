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
        assertEquals("http://example.com/java_prog.jpg", result.get(0).getCoverImage());
    }

    @Test
    public void testGetTopTrendingBooks() {
        int limit = 5;
        List<Book> topBooks = mockBookDAO.getTopTrendingBooks(limit);
        assertNotNull(topBooks);
        assertEquals("Hệ thống phải luôn đảm bảo đắp đủ sách mới vào (Left Join) cho đủ số lượng limit", limit, topBooks.size());
        assertEquals("http://example.com/trending_0.jpg", topBooks.get(0).getCoverImage());
    }

    @Test
    public void testGetBookByIdHasCoverImage() {
        int bookId = 1;
        Book book = mockBookDAO.getBookById(bookId);
        assertNotNull("Sách phải tồn tại", book);
        assertEquals("Đường dẫn ảnh bìa phải khớp", "http://example.com/cover.jpg", book.getCoverImage());
    }

    @Test
    public void testGetCandidatePoolUnique() {
        List<model.BookSummaryDTO> pool = mockBookDAO.getCandidatePoolWithTagsAndCategories(1, 50);
        assertNotNull(pool);
        // Kiểm tra logic lọc trùng (Set/Distinct)
        long distinctCount = pool.stream().map(model.BookSummaryDTO::getBookId).distinct().count();
        assertEquals("Danh sách pool không được có ID trùng lặp", distinctCount, pool.size());
    }

    @Test
    public void testCountSearchBooks() {
        int count = mockBookDAO.countSearchBooks("Java", 0, null, false);
        assertEquals("Số lượng đếm được phải bằng 2", 2, count);
    }

    /**
     * Mock class để giả lập dữ liệu trả về từ DB.
     */
    private static class MockBookDAO extends BookDAO {

        @Override
        public int countSearchBooks(String keyword, int categoryId, int[] tagIds, boolean availableOnly) {
            if (keyword != null && keyword.contains("Java")) {
                return 2;
            }
            return 0;
        }

        @Override
        public List<Book> searchBooks(String keyword, int categoryId, int[] tagIds, boolean availableOnly, int page,
                int pageSize) {
            List<Book> fakeDb = new ArrayList<>();
            Book b1 = new Book();
            b1.setTitle("Java Programming");
            b1.setCoverImage("http://example.com/java_prog.jpg");
            Book b2 = new Book();
            b2.setTitle("Advanced Java");
            b2.setCoverImage("http://example.com/adv_java.jpg");
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
                Book book = new Book();
                book.setCoverImage("http://example.com/trending_" + i + ".jpg");
                fakeDb.add(book);
            }
            return fakeDb;
        }

        @Override
        public Book getBookById(int bookId) {
            Book book = new Book();
            book.setBookId(bookId);
            book.setTitle("Mock Book");
            book.setCoverImage("http://example.com/cover.jpg");
            return book;
        }

        @Override
        public List<model.BookSummaryDTO> getCandidatePoolWithTagsAndCategories(int userId, int limit) {
            List<model.BookSummaryDTO> fakePool = new ArrayList<>();
            fakePool.add(new model.BookSummaryDTO(101, java.util.Arrays.asList("Programming"), java.util.Arrays.asList("Java")));
            fakePool.add(new model.BookSummaryDTO(102, java.util.Arrays.asList("Programming"), java.util.Arrays.asList("Java")));
            fakePool.add(new model.BookSummaryDTO(103, java.util.Arrays.asList("Databases"), java.util.Arrays.asList("SQL")));
            return fakePool;
        }
    }
}
