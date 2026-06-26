package f8;

import controllers.RecommendationServlet;
import controllers.BookSearchServlet;
import controllers.BookDetailServlet;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import model.Book;
import model.BookSummaryDTO;
import model.Category;
import model.Tag;
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
import java.sql.Connection;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class BookDiscoverySystemTest {

    private final int testId;
    private final String scenarioName;
    private final String loginRole; // "GUEST", "STUDENT"
    private final int studentBorrowCount;
    private final boolean aiSvcFails;
    private final String searchKeyword;
    private final String detailBookId;

    // Track mock outcomes
    private String redirectUrl;
    private String forwardedUrl;
    private final Map<String, Object> requestAttributes = new HashMap<>();
    private final Map<String, Object> sessionAttributes = new HashMap<>();

    public BookDiscoverySystemTest(int testId, String scenarioName, String loginRole, int studentBorrowCount, 
                                   boolean aiSvcFails, String searchKeyword, String detailBookId) {
        this.testId = testId;
        this.scenarioName = scenarioName;
        this.loginRole = loginRole;
        this.studentBorrowCount = studentBorrowCount;
        this.aiSvcFails = aiSvcFails;
        this.searchKeyword = searchKeyword;
        this.detailBookId = detailBookId;
    }

    @Parameters(name = "{index}: E2E TestId={0}, Scenario={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // 20 distinct system user flow combinations
        for (int i = 1; i <= 20; i++) {
            String role = (i % 2 == 0) ? "STUDENT" : "GUEST";
            int borrows = (i % 3 == 0) ? 5 : ((i % 3 == 1) ? 1 : 0);
            boolean aiFail = (i % 4 == 0);
            String kw = (i % 5 == 0) ? "Java" : "";
            String bookId = (i % 2 == 0) ? "101" : "999";
            params.add(new Object[]{i, "e2e_flow_scenario_" + i, role, borrows, aiFail, kw, bookId});
        }

        return params;
    }

    private MockBookDAO mockBookDAO;
    private MockBorrowRecordDAO mockBorrowRecordDAO;
    private MockAiService mockAiService;

    @Before
    public void setUp() throws Exception {
        redirectUrl = null;
        forwardedUrl = null;
        requestAttributes.clear();
        sessionAttributes.clear();

        mockBookDAO = new MockBookDAO();
        mockBorrowRecordDAO = new MockBorrowRecordDAO();
        mockAiService = new MockAiService();

        // Setup mock connection
        Map<String, List<Map<String, Object>>> queries = new HashMap<>();

        // Mock detail SQL
        List<Map<String, Object>> activeBorrowResult = new ArrayList<>();
        activeBorrowResult.add(Collections.singletonMap("count", 0));
        queries.put("BorrowRecord", activeBorrowResult);

        List<Map<String, Object>> activeResResult = new ArrayList<>();
        activeResResult.add(Collections.singletonMap("1", 0));
        queries.put("Reservation", activeResResult);

        util.DatabaseConnection.testConnection = MockJdbc.createMockConnection(queries);

        // Prep data into mocks
        mockBorrowRecordDAO.countToReturn = studentBorrowCount;

        // Trending
        Book b1 = new Book(); b1.setBookId(1); b1.setTitle("Trending 1");
        Book b2 = new Book(); b2.setBookId(2); b2.setTitle("Trending 2");
        mockBookDAO.trendingToReturn = Arrays.asList(b1, b2);

        // AI books
        Book aiBook = new Book(); aiBook.setBookId(101); aiBook.setTitle("AI Book");
        mockBookDAO.booksMap.put(101, aiBook);

        if (aiSvcFails) {
            mockAiService.recsToReturn = null;
        } else {
            Map<Integer, String> recs = new LinkedHashMap<>();
            recs.put(101, "Gợi ý cho bạn");
            mockAiService.recsToReturn = recs;
        }

        if ("STUDENT".equals(loginRole)) {
            sessionAttributes.put("userId", 88);
            sessionAttributes.put("role", loginRole);
        }
    }

    @Test
    public void testFullSystemDiscoveryFlow() throws Exception {
        // Mock HttpSession
        HttpSession sessionMock = (HttpSession) Proxy.newProxyInstance(
            HttpSession.class.getClassLoader(),
            new Class[]{HttpSession.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getAttribute".equals(mName)) return sessionAttributes.get(args[0]);
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
            (proxy, method, args) -> null
        );

        // Mock HttpServletRequest
        HttpServletRequest requestMock = (HttpServletRequest) Proxy.newProxyInstance(
            HttpServletRequest.class.getClassLoader(),
            new Class[]{HttpServletRequest.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getSession".equals(mName)) {
                    boolean create = (Boolean) args[0];
                    if (!create && "GUEST".equals(loginRole)) return null;
                    return sessionMock;
                }
                if ("getParameter".equals(mName)) {
                    String param = (String) args[0];
                    if ("keyword".equals(param)) return searchKeyword;
                    if ("id".equals(param)) return detailBookId;
                    return null;
                }
                if ("getParameterValues".equals(mName)) return null;
                if ("setAttribute".equals(mName)) {
                    requestAttributes.put((String) args[0], args[1]);
                    return null;
                }
                if ("getRequestDispatcher".equals(mName)) {
                    forwardedUrl = (String) args[0];
                    return dispatcherMock;
                }
                if ("getContextPath".equals(mName)) return "";
                return null;
            }
        );

        // Mock HttpServletResponse
        HttpServletResponse responseMock = (HttpServletResponse) Proxy.newProxyInstance(
            HttpServletResponse.class.getClassLoader(),
            new Class[]{HttpServletResponse.class},
            (proxy, method, args) -> {
                if ("sendRedirect".equals(method.getName())) {
                    redirectUrl = (String) args[0];
                }
                return null;
            }
        );

        // Flow Step 1: Recommendation Engine
        RecommendationServlet recServlet = new RecommendationServlet();
        setField(recServlet, "bookDAO", mockBookDAO);
        setField(recServlet, "borrowRecordDAO", mockBorrowRecordDAO);
        setField(recServlet, "aiService", mockAiService);
        invokeDoGet(recServlet, requestMock, responseMock);

        assertEquals("/common/_recommendation.jsp", forwardedUrl);
        assertNotNull(requestAttributes.get("recommendedBooks"));
        
        boolean expectedIsAi = "STUDENT".equals(loginRole) && (studentBorrowCount >= 3) && !aiSvcFails;
        assertEquals(expectedIsAi, requestAttributes.get("isAiPowered"));

        // Flow Step 2: Book Search (Advanced/Filter search)
        BookSearchServlet searchServlet = new BookSearchServlet();
        setField(searchServlet, "bookDAO", mockBookDAO);
        invokeDoGet(searchServlet, requestMock, responseMock);
        assertEquals("/book-search.jsp", forwardedUrl);
        assertNotNull(requestAttributes.get("books"));

        // Flow Step 3: Book Detail View
        redirectUrl = null;
        forwardedUrl = null;
        BookDetailServlet detailServlet = new BookDetailServlet();
        setField(detailServlet, "bookDAO", mockBookDAO);
        invokeDoGet(detailServlet, requestMock, responseMock);

        if ("999".equals(detailBookId)) {
            // Book not found -> always redirects to search page
            assertEquals("/book-search", redirectUrl);
        } else if ("GUEST".equals(loginRole)) {
            // Guest must be redirected to login
            assertNotNull(redirectUrl);
            assertTrue(redirectUrl.contains("/login"));
        } else {
            // Logged in student + valid book
            assertEquals("/book-detail.jsp", forwardedUrl);
            assertNotNull(requestAttributes.get("book"));
        }
    }

    // Mock DAO & AI implementations
    private static class MockBookDAO extends BookDAO {
        public List<Book> trendingToReturn = new ArrayList<>();
        public Map<Integer, Book> booksMap = new HashMap<>();

        @Override
        public List<Book> getTopTrendingBooks(int limit) {
            return trendingToReturn;
        }

        @Override
        public Map<String, Map<String, Integer>> getUserTagCategoryFrequency(int userId) {
            return new HashMap<>();
        }

        @Override
        public List<BookSummaryDTO> getRecentBorrowedSummary(int userId, int limit) {
            return Collections.emptyList();
        }

        @Override
        public List<BookSummaryDTO> getCandidatePoolWithTagsAndCategories(int userId, int limit) {
            return Collections.emptyList();
        }

        @Override
        public Book getBookById(int id) {
            return booksMap.get(id);
        }

        @Override
        public List<Book> search(String keyword, Integer categoryId, int[] tagIds, String status, 
                                 String sort, int offset, int pageSize) {
            return trendingToReturn;
        }

        @Override
        public int count(String keyword, Integer categoryId, int[] tagIds, String status) {
            return 2;
        }

        @Override
        public List<Category> getAllCategories() {
            return Collections.emptyList();
        }

        @Override
        public List<Tag> getAllTags() {
            return Collections.emptyList();
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
