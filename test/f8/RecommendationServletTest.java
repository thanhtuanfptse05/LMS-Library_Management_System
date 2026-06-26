package f8;

import controllers.RecommendationServlet;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import model.Book;
import model.BookSummaryDTO;
import service.AiRecommendationService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Proxy;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class RecommendationServletTest {

    private final int testId;
    private final String scenario;
    private final String userRole; // "GUEST", "STUDENT"
    private final int borrowCount;
    private final boolean aiReturnsNull;
    private final boolean aiReturnsEmpty;
    private final boolean cacheHit;
    private final boolean expectedIsAi;

    // Mock dependencies
    private MockBookDAO mockBookDAO;
    private MockBorrowRecordDAO mockBorrowRecordDAO;
    private MockAiService mockAiService;

    // Invocation outcome tracking
    private String forwardedUrl;
    private final Map<String, Object> requestAttributes = new HashMap<>();
    private final Map<String, Object> sessionAttributes = new HashMap<>();

    public RecommendationServletTest(int testId, String scenario, String userRole, int borrowCount, 
                                     boolean aiReturnsNull, boolean aiReturnsEmpty, boolean cacheHit, boolean expectedIsAi) {
        this.testId = testId;
        this.scenario = scenario;
        this.userRole = userRole;
        this.borrowCount = borrowCount;
        this.aiReturnsNull = aiReturnsNull;
        this.aiReturnsEmpty = aiReturnsEmpty;
        this.cacheHit = cacheHit;
        this.expectedIsAi = expectedIsAi;
    }

    @Parameters(name = "{index}: TestId={0}, Scenario={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // 1-10: Guest scenarios (no login, must fallback to Top Trending)
        for (int i = 1; i <= 10; i++) {
            params.add(new Object[]{i, "guest_fallback_" + i, "GUEST", 0, false, false, false, false});
        }

        // 11-20: User with < 3 borrow history (must fallback to Top Trending)
        for (int i = 11; i <= 20; i++) {
            int count = i % 3; // 0, 1, 2
            params.add(new Object[]{i, "user_few_borrows_" + i, "STUDENT", count, false, false, false, false});
        }

        // 21-25: User with >= 3 borrows but AI returns null or empty (must fallback to Top Trending)
        for (int i = 21; i <= 25; i++) {
            boolean isNull = (i % 2 == 0);
            params.add(new Object[]{i, "ai_failed_" + i, "STUDENT", 5, isNull, !isNull, false, false});
        }

        // 26-35: Success E2E AI-powered recommendations (must return AI books)
        for (int i = 26; i <= 35; i++) {
            params.add(new Object[]{i, "ai_success_" + i, "STUDENT", 3, false, false, false, true});
        }

        // 36-40: Session Cache HIT (returns immediately from cache without calling AI)
        for (int i = 36; i <= 40; i++) {
            params.add(new Object[]{i, "cache_hit_" + i, "STUDENT", 3, false, false, true, true});
        }

        return params;
    }

    @Before
    public void setUp() {
        forwardedUrl = null;
        requestAttributes.clear();
        sessionAttributes.clear();

        mockBookDAO = new MockBookDAO();
        mockBorrowRecordDAO = new MockBorrowRecordDAO();
        mockAiService = new MockAiService();

        // Populate test data into mocks
        mockBorrowRecordDAO.countToReturn = borrowCount;

        // Top trending mock books
        Book trend1 = new Book(); trend1.setBookId(1); trend1.setTitle("Trending 1");
        Book trend2 = new Book(); trend2.setBookId(2); trend2.setTitle("Trending 2");
        mockBookDAO.trendingToReturn = Arrays.asList(trend1, trend2);

        // AI recommendation mock books
        Book aiBook1 = new Book(); aiBook1.setBookId(101); aiBook1.setTitle("AI Book 1");
        Book aiBook2 = new Book(); aiBook2.setBookId(102); aiBook2.setTitle("AI Book 2");
        mockBookDAO.booksMap.put(101, aiBook1);
        mockBookDAO.booksMap.put(102, aiBook2);

        if (aiReturnsNull) {
            mockAiService.recsToReturn = null;
        } else if (aiReturnsEmpty) {
            mockAiService.recsToReturn = Collections.emptyMap();
        } else {
            Map<Integer, String> recs = new LinkedHashMap<>();
            recs.put(101, "Phù hợp với bạn");
            recs.put(102, "Nên đọc cuốn này");
            mockAiService.recsToReturn = recs;
        }

        // Session caching setup
        if (cacheHit) {
            sessionAttributes.put("cachedRecommendations", Arrays.asList(aiBook1, aiBook2));
            sessionAttributes.put("cachedRecommendationReasons", Collections.singletonMap(101, "Cached Reason"));
            sessionAttributes.put("cachedIsAiPowered", true);
        }

        if (!"GUEST".equals(userRole)) {
            sessionAttributes.put("userId", 42);
        }
    }

    @Test
    public void testServletDoGet() throws Exception {
        RecommendationServlet servlet = new RecommendationServlet();
        
        // Inject mocks using reflection
        setField(servlet, "bookDAO", mockBookDAO);
        setField(servlet, "borrowRecordDAO", mockBorrowRecordDAO);
        setField(servlet, "aiService", mockAiService);

        // Mock HttpSession
        HttpSession sessionMock = (HttpSession) Proxy.newProxyInstance(
            HttpSession.class.getClassLoader(),
            new Class[]{HttpSession.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getAttribute".equals(mName)) {
                    return sessionAttributes.get(args[0]);
                }
                if ("setAttribute".equals(mName)) {
                    sessionAttributes.put((String) args[0], args[1]);
                    return null;
                }
                return null;
            }
        );

        // Mock RequestDispatcher
        RequestDispatcher dispatcherMock = (RequestDispatcher) Proxy.newProxyInstance(
            RequestDispatcher.class.getClassLoader(),
            new Class[]{RequestDispatcher.class},
            (proxy, method, args) -> {
                if ("forward".equals(method.getName())) {
                    return null;
                }
                return null;
            }
        );

        // Mock HttpServletRequest
        HttpServletRequest requestMock = (HttpServletRequest) Proxy.newProxyInstance(
            HttpServletRequest.class.getClassLoader(),
            new Class[]{HttpServletRequest.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getSession".equals(mName)) {
                    boolean create = (Boolean) args[0];
                    if (!create && "GUEST".equals(userRole)) return null;
                    return sessionMock;
                }
                if ("setAttribute".equals(mName)) {
                    requestAttributes.put((String) args[0], args[1]);
                    return null;
                }
                if ("getRequestDispatcher".equals(mName)) {
                    forwardedUrl = (String) args[0];
                    return dispatcherMock;
                }
                return null;
            }
        );

        // Mock HttpServletResponse
        HttpServletResponse responseMock = (HttpServletResponse) Proxy.newProxyInstance(
            HttpServletResponse.class.getClassLoader(),
            new Class[]{HttpServletResponse.class},
            (proxy, method, args) -> null
        );

        // Run
        invokeDoGet(servlet, requestMock, responseMock);

        // Assertions
        assertEquals("/common/_recommendation.jsp", forwardedUrl);
        assertNotNull(requestAttributes.get("recommendedBooks"));
        assertNotNull(requestAttributes.get("recommendationReasons"));
        assertEquals(expectedIsAi, requestAttributes.get("isAiPowered"));

        List<?> books = (List<?>) requestAttributes.get("recommendedBooks");
        if (expectedIsAi) {
            assertEquals(2, books.size());
            Book b = (Book) books.get(0);
            assertEquals(101, b.getBookId());
        } else {
            assertEquals(2, books.size());
            Book b = (Book) books.get(0);
            assertEquals(1, b.getBookId());
        }
    }

    // Mock DAO classes
    private static class MockBookDAO extends BookDAO {
        public List<Book> trendingToReturn = new ArrayList<>();
        public Map<String, Map<String, Integer>> freqToReturn = new HashMap<>();
        public List<BookSummaryDTO> recentToReturn = new ArrayList<>();
        public List<BookSummaryDTO> candidateToReturn = new ArrayList<>();
        public Map<Integer, Book> booksMap = new HashMap<>();

        @Override
        public List<Book> getTopTrendingBooks(int limit) {
            return trendingToReturn;
        }

        @Override
        public Map<String, Map<String, Integer>> getUserTagCategoryFrequency(int userId) {
            return freqToReturn;
        }

        @Override
        public List<BookSummaryDTO> getRecentBorrowedSummary(int userId, int limit) {
            return recentToReturn;
        }

        @Override
        public List<BookSummaryDTO> getCandidatePoolWithTagsAndCategories(int userId, int limit) {
            return candidateToReturn;
        }

        @Override
        public Book getBookById(int id) {
            return booksMap.get(id);
        }
    }

    private static class MockBorrowRecordDAO extends BorrowRecordDAO {
        public int countToReturn = 0;

        @Override
        public int countUserBorrowHistory(int userId) {
            return countToReturn;
        }
    }

    private static class MockAiService extends AiRecommendationService {
        public Map<Integer, String> recsToReturn = new HashMap<>();

        @Override
        public Map<Integer, String> getRecommendationsWithReasons(
                Map<String, Map<String, Integer>> frequencyProfile,
                List<BookSummaryDTO> recentHistory,
                List<BookSummaryDTO> candidatePool) {
            return recsToReturn;
        }
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        java.lang.reflect.Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }

    private void invokeDoGet(Object servlet, HttpServletRequest req, HttpServletResponse resp) throws Exception {
        java.lang.reflect.Method method = servlet.getClass().getDeclaredMethod("doGet", HttpServletRequest.class, HttpServletResponse.class);
        method.setAccessible(true);
        method.invoke(servlet, req, resp);
    }
}
