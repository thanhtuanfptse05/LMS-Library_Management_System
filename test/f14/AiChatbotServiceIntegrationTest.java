package f14;

import model.ChatMessage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import service.AiChatbotService;
import util.DatabaseConnection;

import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class AiChatbotServiceIntegrationTest {

    private final int testId;
    private final String query;
    private final Integer userId;
    private final Map<String, List<Map<String, Object>>> dbData;
    private final boolean expectedPersonalized;

    public AiChatbotServiceIntegrationTest(int testId, String query, Integer userId,
                                           Map<String, List<Map<String, Object>>> dbData,
                                           boolean expectedPersonalized) {
        this.testId = testId;
        this.query = query;
        this.userId = userId;
        this.dbData = dbData;
        this.expectedPersonalized = expectedPersonalized;
    }

    @Parameters(name = "{index}: F14 Integration TestId={0}, Query={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        for (int i = 1; i <= 30; i++) {
            String q = "Java";
            Integer uId = null;
            Map<String, List<Map<String, Object>>> dbMock = new HashMap<>();
            boolean isPersonalized = false;

            if (i <= 10) {
                // Testing RAG Book Retrieval
                q = "Java Programming " + i;
                setupBookMock(dbMock, i, "Sách Lập trình Java " + i, "Nguyễn Văn " + i);
            } else if (i <= 20) {
                // Testing Personalized Books Retrieval (User with history)
                q = "Gợi ý sách";
                uId = 100 + i;
                isPersonalized = true;
                setupUserBorrowHistory(dbMock, uId, 5); // 5 borrow records
                setupBookMock(dbMock, i, "Sách Gợi ý " + i, "Tác giả " + i);
                setupFrequencyProfile(dbMock);
            } else {
                // Testing fallback books retrieval (No history)
                q = "Sách thịnh hành";
                uId = 200 + i;
                isPersonalized = false;
                setupUserBorrowHistory(dbMock, uId, 0); // 0 borrow records -> triggers fallback
                setupTrendingBookMock(dbMock, i, "Sách Hot " + i);
            }

            params.add(new Object[]{i, q, uId, dbMock, isPersonalized});
        }

        return params;
    }

    private static void setupBookMock(Map<String, List<Map<String, Object>>> db, int bookId, String title, String author) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("bookId", bookId);
        r.put("title", title);
        r.put("author", author);
        r.put("publisher", "NXB KHTN");
        r.put("availableQuantity", 5);
        r.put("status", "available");
        r.put("totalQuantity", 10);
        rows.add(r);
        db.put("Book", rows);
    }

    private static void setupTrendingBookMock(Map<String, List<Map<String, Object>>> db, int bookId, String title) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("bookId", bookId);
        r.put("title", title);
        r.put("author", "NXB Trẻ");
        r.put("publisher", "NXB Trẻ");
        r.put("availableQuantity", 3);
        r.put("status", "available");
        r.put("totalQuantity", 5);
        rows.add(r);
        db.put("getTopTrendingBooks", rows);
    }

    private static void setupUserBorrowHistory(Map<String, List<Map<String, Object>>> db, int userId, int count) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("borrowCount", count);
        rows.add(r);
        db.put("countUserBorrowHistory", rows);
    }

    private static void setupFrequencyProfile(Map<String, List<Map<String, Object>>> db) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("tagName", "Tech");
        r.put("frequency", 5);
        rows.add(r);
        db.put("getUserTagCategoryFrequency", rows);
    }

    @Before
    public void setUp() {
        DatabaseConnection.testConnection = MockJdbc.createMockConnection(dbData);
    }

    @After
    public void tearDown() {
        DatabaseConnection.testConnection = null;
    }

    @Test
    public void testIntegration() {
        AiChatbotService service = new AiChatbotService();
        if (testId <= 10) {
            String booksContext = service.retrieveBooksContext(query);
            assertNotNull(booksContext);
            assertTrue(booksContext.contains("Danh sách") || booksContext.contains("Không tìm thấy"));
        } else {
            String personalizedContext = service.retrievePersonalizedBooksContext(userId);
            assertNotNull(personalizedContext);
            if (expectedPersonalized) {
                // It should look up custom history and recommendations
                assertTrue(personalizedContext.contains("phổ biến") || personalizedContext.contains("cá nhân hóa") || personalizedContext.contains("Danh sách"));
            } else {
                // Fallback trending books context
                assertTrue(personalizedContext.contains("thịnh hành") || personalizedContext.contains("phổ biến") || personalizedContext.contains("Danh sách"));
            }
        }
    }
}
