package f8;

import dao.BookDAO;
import model.Book;
import model.BookSummaryDTO;
import model.Category;
import model.Tag;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class BookDAOTest {

    private final int testId;
    private final String method;
    private final String keyword;
    private final Integer categoryId;
    private final int[] tagIds;
    private final String status;
    private final String sort;
    private final int limit;
    private final int expectedCount;

    public BookDAOTest(int testId, String method, String keyword, Integer categoryId, int[] tagIds, 
                      String status, String sort, int limit, int expectedCount) {
        this.testId = testId;
        this.method = method;
        this.keyword = keyword;
        this.categoryId = categoryId;
        this.tagIds = tagIds;
        this.status = status;
        this.sort = sort;
        this.limit = limit;
        this.expectedCount = expectedCount;
    }

    @Parameters(name = "{index}: TestId={0}, Method={1}, Keyword={2}, Expected={8}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // 30 cases for search
        String[] sorts = {"title_asc", "title_desc", "available_desc", "available_asc", "published_desc", "published_asc", "updated_desc", null};
        for (int i = 1; i <= 30; i++) {
            String kw = (i % 3 == 0) ? "Java" : ((i % 3 == 1) ? "" : "NonExistingBook");
            Integer catId = (i % 2 == 0) ? 1 : null;
            int[] tags = (i % 4 == 0) ? new int[]{1, 2} : ((i % 4 == 1) ? new int[]{3} : null);
            String st = (i % 5 == 0) ? "available" : null;
            String s = sorts[i % sorts.length];
            params.add(new Object[]{i, "search", kw, catId, tags, st, s, 0, (kw.contains("NonExisting") ? 0 : 2)});
        }

        // 15 cases for count
        for (int i = 31; i <= 45; i++) {
            String kw = (i % 2 == 0) ? "LMS" : "";
            Integer catId = (i % 3 == 0) ? 2 : null;
            int[] tags = (i % 4 == 0) ? new int[]{4} : null;
            String st = (i % 2 == 0) ? "available" : "unavailable";
            params.add(new Object[]{i, "count", kw, catId, tags, st, null, 0, (i % 2 == 0 ? 5 : 10)});
        }

        // 5 cases for getUserTagCategoryFrequency
        for (int i = 46; i <= 50; i++) {
            params.add(new Object[]{i, "getUserTagCategoryFrequency", null, null, null, null, null, 0, 3});
        }

        // 3 cases for getRecentBorrowedSummary
        params.add(new Object[]{51, "getRecentBorrowedSummary", null, null, null, null, null, 3, 2});
        params.add(new Object[]{52, "getRecentBorrowedSummary", null, null, null, null, null, 1, 1});
        params.add(new Object[]{53, "getRecentBorrowedSummary", null, null, null, null, null, 5, 2});

        // 3 cases for getCandidatePoolWithTagsAndCategories
        params.add(new Object[]{54, "getCandidatePoolWithTagsAndCategories", null, null, null, null, null, 5, 2});
        params.add(new Object[]{55, "getCandidatePoolWithTagsAndCategories", null, null, null, null, null, 2, 2});
        params.add(new Object[]{56, "getCandidatePoolWithTagsAndCategories", null, null, null, null, null, 10, 2});

        // 4 cases for others: getBookById, getTopTrendingBooks, getAllCategories, getAllTags
        params.add(new Object[]{57, "getBookById", null, null, null, null, null, 0, 1});
        params.add(new Object[]{58, "getTopTrendingBooks", null, null, null, null, null, 5, 3});
        params.add(new Object[]{59, "getAllCategories", null, null, null, null, null, 0, 4});
        params.add(new Object[]{60, "getAllTags", null, null, null, null, null, 0, 4});

        return params;
    }

    private Connection mockConnection;
    private BookDAO bookDAO;

    @Before
    public void setUp() throws Exception {
        bookDAO = new BookDAO();
        Map<String, List<Map<String, Object>>> queries = new HashMap<>();

        // Setup mock data based on the method under test
        if ("search".equals(method)) {
            List<Map<String, Object>> books = new ArrayList<>();
            if (expectedCount > 0) {
                Map<String, Object> book1 = createMockBookMap(101, "ISBN1", "Java Programming", "Author A", "Publisher A", 2020, 150.0, "available", 5, 5);
                Map<String, Object> book2 = createMockBookMap(102, "ISBN2", "Advanced Java", "Author B", "Publisher B", 2022, 200.0, "available", 3, 2);
                books.add(book1);
                books.add(book2);
            }
            queries.put("FROM Book b WHERE 1=1", books);

            // Mock categories and tags relations (with matching bookId)
            List<Map<String, Object>> cats = new ArrayList<>();
            cats.add(createMockCategoryMap(101, 1, "Technology", "Tech books"));
            cats.add(createMockCategoryMap(102, 1, "Technology", "Tech books"));
            queries.put("BookCategory bc", cats);

            List<Map<String, Object>> tags = new ArrayList<>();
            tags.add(createMockTagMap(101, 1, "Science", "active"));
            tags.add(createMockTagMap(102, 1, "Science", "active"));
            queries.put("BookTag bt", tags);

        } else if ("count".equals(method)) {
            List<Map<String, Object>> countResult = new ArrayList<>();
            Map<String, Object> row = new HashMap<>();
            row.put("1", expectedCount);
            countResult.add(row);
            queries.put("SELECT COUNT(*)", countResult);

        } else if ("getUserTagCategoryFrequency".equals(method)) {
            List<Map<String, Object>> freq = new ArrayList<>();
            Map<String, Object> row1 = new HashMap<>();
            row1.put("name", "Java");
            row1.put("frequency", 5);
            Map<String, Object> row2 = new HashMap<>();
            row2.put("name", "Web");
            row2.put("frequency", 3);
            freq.add(row1);
            freq.add(row2);
            queries.put("GROUP BY m.name", freq);

        } else if ("getRecentBorrowedSummary".equals(method)) {
            List<Map<String, Object>> recentIds = new ArrayList<>();
            for (int j = 0; j < Math.min(limit, 2); j++) {
                recentIds.add(Collections.singletonMap("bookId", 101 + j));
            }
            queries.put("br.userId = ? ORDER BY br.startDate", recentIds);

            // mock Book details for findById
            List<Map<String, Object>> books = new ArrayList<>();
            books.add(createMockBookMap(101, "ISBN1", "Java Programming", "Author A", "Publisher A", 2020, 150.0, "available", 5, 5));
            books.add(createMockBookMap(102, "ISBN2", "Advanced Java", "Author B", "Publisher B", 2022, 200.0, "available", 3, 2));
            queries.put("WHERE bookId = ?", books);
            
            // mock relations
            queries.put("BookCategory bc", Collections.emptyList());
            queries.put("BookTag bt", Collections.emptyList());

        } else if ("getCandidatePoolWithTagsAndCategories".equals(method)) {
            List<Map<String, Object>> pool = new ArrayList<>();
            for (int j = 0; j < Math.min(limit, 2); j++) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookId", 101 + j);
                row.put("recommendationScore", 1.5 - j * 0.5);
                pool.add(row);
            }
            queries.put("recommendationScore", pool);

            // mock findById details
            List<Map<String, Object>> books = new ArrayList<>();
            books.add(createMockBookMap(101, "ISBN1", "Java Programming", "Author A", "Publisher A", 2020, 150.0, "available", 5, 5));
            books.add(createMockBookMap(102, "ISBN2", "Advanced Java", "Author B", "Publisher B", 2022, 200.0, "available", 3, 2));
            queries.put("WHERE bookId = ?", books);

            queries.put("BookCategory bc", Collections.emptyList());
            queries.put("BookTag bt", Collections.emptyList());

        } else if ("getBookById".equals(method)) {
            List<Map<String, Object>> books = new ArrayList<>();
            books.add(createMockBookMap(1, "ISBN1", "Java Programming", "Author A", "Publisher A", 2020, 150.0, "available", 5, 5));
            queries.put("WHERE bookId = ?", books);
            queries.put("BookCategory bc", Collections.emptyList());
            queries.put("BookTag bt", Collections.emptyList());

        } else if ("getTopTrendingBooks".equals(method)) {
            List<Map<String, Object>> books = new ArrayList<>();
            int returnCount = Math.min(limit, 3);
            if (returnCount >= 1) books.add(createMockBookMap(101, "ISBN1", "Java Programming", "Author A", "Publisher A", 2020, 150.0, "available", 5, 5));
            if (returnCount >= 2) books.add(createMockBookMap(102, "ISBN2", "Advanced Java", "Author B", "Publisher B", 2022, 200.0, "available", 3, 2));
            if (returnCount >= 3) books.add(createMockBookMap(103, "ISBN3", "Web Dev", "Author C", "Publisher C", 2021, 120.0, "available", 2, 1));
            
            queries.put("COUNT(br.borrowRecordId) DESC", books);
            queries.put("BookCategory bc", Collections.emptyList());
            queries.put("BookTag bt", Collections.emptyList());

        } else if ("getAllCategories".equals(method)) {
            List<Map<String, Object>> cats = new ArrayList<>();
            cats.add(createMockCategoryMap(0, 1, "Tech", "Tech"));
            cats.add(createMockCategoryMap(0, 2, "Science", "Sci"));
            cats.add(createMockCategoryMap(0, 3, "Literature", "Lit"));
            cats.add(createMockCategoryMap(0, 4, "History", "Hist"));
            queries.put("Category ORDER BY name", cats);

        } else if ("getAllTags".equals(method)) {
            List<Map<String, Object>> tags = new ArrayList<>();
            tags.add(createMockTagMap(0, 1, "java", "active"));
            tags.add(createMockTagMap(0, 2, "web", "active"));
            tags.add(createMockTagMap(0, 3, "db", "active"));
            tags.add(createMockTagMap(0, 4, "spring", "active"));
            queries.put("Tag ORDER BY name", tags);
        }

        mockConnection = MockJdbc.createMockConnection(queries);
        util.DatabaseConnection.testConnection = mockConnection;
    }

    @After
    public void tearDown() {
        util.DatabaseConnection.testConnection = null;
    }

    @Test
    public void testExecution() throws SQLException {
        if ("search".equals(method)) {
            List<Book> result = bookDAO.search(keyword, categoryId, tagIds, status, sort, 0, 10);
            assertNotNull(result);
            assertEquals(expectedCount, result.size());
            if (expectedCount > 0) {
                assertEquals("Java Programming", result.get(0).getTitle());
            }
        } else if ("count".equals(method)) {
            int result = bookDAO.count(keyword, categoryId, tagIds, status);
            assertEquals(expectedCount, result);
        } else if ("getUserTagCategoryFrequency".equals(method)) {
            Map<String, Map<String, Integer>> result = bookDAO.getUserTagCategoryFrequency(1);
            assertNotNull(result);
            assertTrue(result.containsKey("categories"));
            assertTrue(result.containsKey("tags"));
            assertEquals(5, (int) result.get("categories").get("Java"));
            assertEquals(3, (int) result.get("tags").get("Web"));
        } else if ("getRecentBorrowedSummary".equals(method)) {
            List<BookSummaryDTO> result = bookDAO.getRecentBorrowedSummary(1, limit);
            assertNotNull(result);
            assertTrue(result.size() <= limit);
            assertEquals(Math.min(limit, 2), result.size());
        } else if ("getCandidatePoolWithTagsAndCategories".equals(method)) {
            List<BookSummaryDTO> result = bookDAO.getCandidatePoolWithTagsAndCategories(1, limit);
            assertNotNull(result);
            assertTrue(result.size() <= limit);
            assertEquals(Math.min(limit, 2), result.size());
        } else if ("getBookById".equals(method)) {
            Book result = bookDAO.getBookById(1);
            assertNotNull(result);
            assertEquals("Java Programming", result.getTitle());
        } else if ("getTopTrendingBooks".equals(method)) {
            List<Book> result = bookDAO.getTopTrendingBooks(limit);
            assertNotNull(result);
            assertEquals(Math.min(limit, 3), result.size());
        } else if ("getAllCategories".equals(method)) {
            List<Category> result = bookDAO.getAllCategories();
            assertNotNull(result);
            assertEquals(4, result.size());
        } else if ("getAllTags".equals(method)) {
            List<Tag> result = bookDAO.getAllTags();
            assertNotNull(result);
            assertEquals(4, result.size());
        }
    }

    // Helper functions to construct mock maps
    private Map<String, Object> createMockBookMap(int id, String isbn, String title, String author, String publisher, 
                                                 int year, double price, String status, int total, int avail) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("bookId", id);
        map.put("isbn", isbn);
        map.put("title", title);
        map.put("author", author);
        map.put("publisher", publisher);
        map.put("publicationYear", year);
        map.put("price", new java.math.BigDecimal(price));
        map.put("imagePath", "path/to/img");
        map.put("totalQuantity", total);
        map.put("availableQuantity", avail);
        map.put("status", status);
        map.put("createdAt", new java.sql.Timestamp(System.currentTimeMillis()));
        map.put("updatedAt", new java.sql.Timestamp(System.currentTimeMillis()));
        return map;
    }

    private Map<String, Object> createMockCategoryMap(int bookId, int id, String name, String desc) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("bookId", bookId);
        map.put("categoryId", id);
        map.put("name", name);
        map.put("description", desc);
        map.put("status", "active");
        return map;
    }

    private Map<String, Object> createMockTagMap(int bookId, int id, String name, String status) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("bookId", bookId);
        map.put("tagId", id);
        map.put("name", name);
        map.put("status", status);
        return map;
    }
}
