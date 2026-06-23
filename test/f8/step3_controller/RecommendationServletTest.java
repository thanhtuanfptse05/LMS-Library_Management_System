package f8.step3_controller;

import controllers.RecommendationServlet;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import model.Book;
import org.junit.Before;
import org.junit.Test;
import service.AiRecommendationService;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Field;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

/**
 * RecommendationServletTest — Unit Tests cho RecommendationServlet.
 * 
 * Kiểm thử chi tiết luồng xử lý của Servlet bằng cách sử dụng reflection để inject mock DAOs/Services,
 * và dynamic proxies để mock servlet request/response/session tĩnh không phụ thuộc database.
 */
public class RecommendationServletTest {

    private RecommendationServlet servlet;
    private MockBookDAO mockBookDAO;
    private MockBorrowRecordDAO mockBorrowRecordDAO;
    private MockAiRecommendationService mockAiService;

    @Before
    public void setUp() throws Exception {
        servlet = new RecommendationServlet();
        mockBookDAO = new MockBookDAO();
        mockBorrowRecordDAO = new MockBorrowRecordDAO();
        mockAiService = new MockAiRecommendationService();

        // Inject mocks using reflection
        setPrivateField(servlet, "bookDAO", mockBookDAO);
        setPrivateField(servlet, "borrowRecordDAO", mockBorrowRecordDAO);
        setPrivateField(servlet, "aiService", mockAiService);
    }

    private void setPrivateField(Object obj, String fieldName, Object value) throws Exception {
        Field field = obj.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(obj, value);
    }

    @SuppressWarnings("unchecked")
    @Test
    public void testGuestAccess_ShouldFallbackToTopTrending() throws Exception {
        Map<String, Object> sessionAttributes = null; // Guest (Không có session)
        Map<String, Object> requestAttributes = new HashMap<>();
        String[] forwardedUrl = new String[1];

        HttpServletRequest request = createMockRequest(sessionAttributes, requestAttributes, forwardedUrl);
        HttpServletResponse response = createMockResponse();

        servlet.service(request, response);

        // Kiểm tra request attributes
        List<Book> result = (List<Book>) requestAttributes.get("recommendedBooks");
        assertNotNull(result);
        assertEquals("Phải trả về 5 sách mặc định cho Guest", 5, result.size());
        assertEquals("Trending 1", result.get(0).getTitle());
        assertEquals("/common/_recommendation.jsp", forwardedUrl[0]);

        // Kiểm tra số lần gọi đến DAO/Service
        assertEquals(0, mockBorrowRecordDAO.countUserBorrowCalls);
        assertEquals(0, mockAiService.getRecommendationsCalls);
        assertEquals(1, mockBookDAO.getTopTrendingCalls);
    }

    @SuppressWarnings("unchecked")
    @Test
    public void testUserBelowThreshold_ShouldFallbackToTopTrending() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userId", 123); // Đã đăng nhập
        mockBorrowRecordDAO.borrowCountToReturn = 2; // Số lượt mượn < 3 (chưa đạt ngưỡng AI)

        Map<String, Object> requestAttributes = new HashMap<>();
        String[] forwardedUrl = new String[1];

        HttpServletRequest request = createMockRequest(sessionAttributes, requestAttributes, forwardedUrl);
        HttpServletResponse response = createMockResponse();

        servlet.service(request, response);

        List<Book> result = (List<Book>) requestAttributes.get("recommendedBooks");
        assertNotNull(result);
        assertEquals(5, result.size());
        assertEquals("Trending 1", result.get(0).getTitle());
        assertEquals("/common/_recommendation.jsp", forwardedUrl[0]);

        assertEquals(1, mockBorrowRecordDAO.countUserBorrowCalls);
        assertEquals(0, mockAiService.getRecommendationsCalls);
        assertEquals(1, mockBookDAO.getTopTrendingCalls);
    }

    @SuppressWarnings("unchecked")
    @Test
    public void testUserAboveThreshold_FirstTimeCallsAiAndCaches() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userId", 123); // Đã đăng nhập
        mockBorrowRecordDAO.borrowCountToReturn = 5; // Số lượt mượn >= 3 (đủ điều kiện gọi AI)
        mockAiService.recommendationsToReturn = Arrays.asList(2, 3);

        Map<String, Object> requestAttributes = new HashMap<>();
        String[] forwardedUrl = new String[1];

        HttpServletRequest request = createMockRequest(sessionAttributes, requestAttributes, forwardedUrl);
        HttpServletResponse response = createMockResponse();

        servlet.service(request, response);

        List<Book> result = (List<Book>) requestAttributes.get("recommendedBooks");
        assertNotNull(result);
        assertEquals("AI trả về đúng 2 sách", 2, result.size());
        assertEquals("Book 2", result.get(0).getTitle());
        assertEquals("Book 3", result.get(1).getTitle());
        assertEquals("/common/_recommendation.jsp", forwardedUrl[0]);

        // Xác nhận kết quả gợi ý đã được cache vào Session
        List<Book> cachedResult = (List<Book>) sessionAttributes.get("cachedRecommendations");
        assertNotNull("Phải lưu kết quả gợi ý AI vào session cache", cachedResult);
        assertEquals(2, cachedResult.size());

        assertEquals(1, mockBorrowRecordDAO.countUserBorrowCalls);
        assertEquals(1, mockAiService.getRecommendationsCalls);
        assertEquals(2, mockBookDAO.getBookByIdCalls); // Gọi tìm thông tin cho Book 2 và Book 3
        assertEquals(0, mockBookDAO.getTopTrendingCalls); // Không gọi fallback
    }

    @SuppressWarnings("unchecked")
    @Test
    public void testUserAboveThreshold_SecondTimeUsesSessionCache() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userId", 123); // Đã đăng nhập
        
        // Tự đắp cache giả vào Session trước
        List<Book> cache = new ArrayList<>();
        Book cachedBook = new Book();
        cachedBook.setBookId(999);
        cachedBook.setTitle("Cached Book");
        cache.add(cachedBook);
        sessionAttributes.put("cachedRecommendations", cache);

        Map<String, Object> requestAttributes = new HashMap<>();
        String[] forwardedUrl = new String[1];

        HttpServletRequest request = createMockRequest(sessionAttributes, requestAttributes, forwardedUrl);
        HttpServletResponse response = createMockResponse();

        servlet.service(request, response);

        List<Book> result = (List<Book>) requestAttributes.get("recommendedBooks");
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("Cached Book", result.get(0).getTitle());
        assertEquals("/common/_recommendation.jsp", forwardedUrl[0]);

        // Toàn bộ các dịch vụ DB/AI phải có số lần gọi bằng 0 vì đã hit cache!
        assertEquals(0, mockBorrowRecordDAO.countUserBorrowCalls);
        assertEquals(0, mockAiService.getRecommendationsCalls);
        assertEquals(0, mockBookDAO.getTopTrendingCalls);
    }

    @SuppressWarnings("unchecked")
    @Test
    public void testAiHallucinationWarning_FallsBackToTrending() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userId", 123); // Đã đăng nhập
        mockBorrowRecordDAO.borrowCountToReturn = 5;
        mockAiService.recommendationsToReturn = new ArrayList<>(); // AI bị ảo giác 100%, sau khi filter bị rỗng

        Map<String, Object> requestAttributes = new HashMap<>();
        String[] forwardedUrl = new String[1];

        HttpServletRequest request = createMockRequest(sessionAttributes, requestAttributes, forwardedUrl);
        HttpServletResponse response = createMockResponse();

        servlet.service(request, response);

        List<Book> result = (List<Book>) requestAttributes.get("recommendedBooks");
        assertNotNull(result);
        assertEquals("Khi AI bị rỗng do ảo giác, phải fallback trending", 5, result.size());
        assertEquals("Trending 1", result.get(0).getTitle());
        assertEquals("/common/_recommendation.jsp", forwardedUrl[0]);

        assertEquals(1, mockBorrowRecordDAO.countUserBorrowCalls);
        assertEquals(1, mockAiService.getRecommendationsCalls);
        assertEquals(1, mockBookDAO.getTopTrendingCalls);
        assertNull("Không cache kết quả rỗng/fallback vào session", sessionAttributes.get("cachedRecommendations"));
    }

    @SuppressWarnings("unchecked")
    private HttpServletRequest createMockRequest(Map<String, Object> sessionAttributes, Map<String, Object> requestAttributes, final String[] forwardedUrl) {
        final HttpSession mockSession;
        if (sessionAttributes != null) {
            mockSession = (HttpSession) Proxy.newProxyInstance(
                    HttpSession.class.getClassLoader(),
                    new Class[]{HttpSession.class},
                    (proxy, method, args) -> {
                        if (method.getName().equals("getAttribute")) {
                            return sessionAttributes.get(args[0]);
                        } else if (method.getName().equals("setAttribute")) {
                            sessionAttributes.put((String) args[0], args[1]);
                            return null;
                        }
                        return null;
                    }
            );
        } else {
            mockSession = null;
        }

        final RequestDispatcher mockDispatcher = (RequestDispatcher) Proxy.newProxyInstance(
                RequestDispatcher.class.getClassLoader(),
                new Class[]{RequestDispatcher.class},
                (proxy, method, args) -> {
                    if (method.getName().equals("forward")) {
                        forwardedUrl[0] = (String) requestAttributes.get("forwardedTo");
                        return null;
                    }
                    return null;
                }
        );

        return (HttpServletRequest) Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class[]{HttpServletRequest.class},
                (proxy, method, args) -> {
                    if (method.getName().equals("getSession")) {
                        boolean create = args.length > 0 && (Boolean) args[0];
                        return mockSession;
                    } else if (method.getName().equals("setAttribute")) {
                        requestAttributes.put((String) args[0], args[1]);
                        return null;
                    } else if (method.getName().equals("getAttribute")) {
                        return requestAttributes.get(args[0]);
                    } else if (method.getName().equals("getRequestDispatcher")) {
                        requestAttributes.put("forwardedTo", args[0]);
                        return mockDispatcher;
                    } else if (method.getName().equals("getMethod")) {
                        return "GET";
                    }
                    return null;
                }
        );
    }

    private HttpServletResponse createMockResponse() {
        return (HttpServletResponse) Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class[]{HttpServletResponse.class},
                (proxy, method, args) -> null
        );
    }

    private static class MockBookDAO extends BookDAO {
        int getBookByIdCalls = 0;
        int getTopTrendingCalls = 0;
        int getCandidatePoolCalls = 0;

        @Override
        public Book getBookById(int bookId) {
            getBookByIdCalls++;
            Book b = new Book();
            b.setBookId(bookId);
            b.setTitle("Book " + bookId);
            b.setImagePath("http://example.com/cover_" + bookId + ".jpg");
            return b;
        }

        @Override
        public List<Book> getTopTrendingBooks(int limit) {
            getTopTrendingCalls++;
            List<Book> trending = new ArrayList<>();
            for (int i = 1; i <= limit; i++) {
                Book b = new Book();
                b.setBookId(i * 100);
                b.setTitle("Trending " + i);
                b.setImagePath("http://example.com/trending_" + i + ".jpg");
                trending.add(b);
            }
            return trending;
        }

        @Override
        public Map<String, Map<String, Integer>> getUserTagCategoryFrequency(int userId) {
            Map<String, Map<String, Integer>> result = new HashMap<>();
            Map<String, Integer> categories = new HashMap<>();
            categories.put("Programming", 5);
            Map<String, Integer> tags = new HashMap<>();
            tags.put("Java", 3);
            result.put("categories", categories);
            result.put("tags", tags);
            return result;
        }

        @Override
        public List<model.BookSummaryDTO> getRecentBorrowedSummary(int userId, int limit) {
            List<model.BookSummaryDTO> list = new ArrayList<>();
            list.add(new model.BookSummaryDTO(1, Arrays.asList("Programming"), Arrays.asList("Java")));
            return list;
        }

        @Override
        public List<model.BookSummaryDTO> getCandidatePoolWithTagsAndCategories(int userId, int limit) {
            getCandidatePoolCalls++;
            List<model.BookSummaryDTO> pool = new ArrayList<>();
            pool.add(new model.BookSummaryDTO(1, Arrays.asList("Programming"), Arrays.asList("Java")));
            pool.add(new model.BookSummaryDTO(2, Arrays.asList("Programming"), Arrays.asList("Java")));
            pool.add(new model.BookSummaryDTO(3, Arrays.asList("Databases"), Arrays.asList("SQL")));
            pool.add(new model.BookSummaryDTO(4, Arrays.asList("Web"), Arrays.asList("JS")));
            pool.add(new model.BookSummaryDTO(5, Arrays.asList("AI"), Arrays.asList("Python")));
            return pool;
        }
    }

    private static class MockBorrowRecordDAO extends BorrowRecordDAO {
        int countUserBorrowCalls = 0;
        int borrowCountToReturn = 5;

        @Override
        public int countUserBorrowHistory(int userId) {
            countUserBorrowCalls++;
            return borrowCountToReturn;
        }
    }

    private static class MockAiRecommendationService extends AiRecommendationService {
        int getRecommendationsCalls = 0;
        List<Integer> recommendationsToReturn = Arrays.asList(2, 3);

        @Override
        public List<Integer> getRecommendations(
                Map<String, Map<String, Integer>> frequencyProfile,
                List<model.BookSummaryDTO> recentHistory,
                List<model.BookSummaryDTO> candidatePool) {
            getRecommendationsCalls++;
            return recommendationsToReturn;
        }

        @Override
        public java.util.Map<Integer, String> getRecommendationsWithReasons(
                Map<String, Map<String, Integer>> frequencyProfile,
                List<model.BookSummaryDTO> recentHistory,
                List<model.BookSummaryDTO> candidatePool) {
            getRecommendationsCalls++;
            java.util.Map<Integer, String> result = new java.util.LinkedHashMap<>();
            if (recommendationsToReturn != null) {
                for (Integer id : recommendationsToReturn) {
                    result.put(id, "Lý do gợi ý cho sách " + id);
                }
            }
            return result;
        }
    }
}
