package f8;

import controllers.BookSearchServlet;
import controllers.BookDetailServlet;
import dao.BookDAO;
import model.Book;
import model.Category;
import model.Tag;
import org.junit.After;
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
public class BookServletsTest {

    private final int testId;
    private final String servletType; // "search", "detail"
    private final String keyword;
    private final String categoryIdParam;
    private final String[] tagParams;
    private final String pageParam;
    private final String detailIdParam;
    private final String userRole; // "GUEST", "STUDENT", null
    private final String expectedRedirect;
    private final String expectedForward;

    // Mock outcome tracking
    private String redirectUrl;
    private String forwardedUrl;
    private final Map<String, Object> requestAttributes = new HashMap<>();
    private final Map<String, Object> sessionAttributes = new HashMap<>();

    public BookServletsTest(int testId, String servletType, String keyword, String categoryIdParam, 
                             String[] tagParams, String pageParam, String detailIdParam, String userRole,
                             String expectedRedirect, String expectedForward) {
        this.testId = testId;
        this.servletType = servletType;
        this.keyword = keyword;
        this.categoryIdParam = categoryIdParam;
        this.tagParams = tagParams;
        this.pageParam = pageParam;
        this.detailIdParam = detailIdParam;
        this.userRole = userRole;
        this.expectedRedirect = expectedRedirect;
        this.expectedForward = expectedForward;
    }

    @Parameters(name = "{index}: TestId={0}, Servlet={1}, ExpectedForward={9}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // 1-10: BookSearchServlet scenarios (pagination, search, filtering)
        for (int i = 1; i <= 10; i++) {
            String kw = (i % 2 == 0) ? "Java" : "";
            String cat = (i % 3 == 0) ? "1" : "";
            String[] tags = (i % 4 == 0) ? new String[]{"2", "3"} : null;
            String pg = (i % 2 == 0) ? "2" : "1";
            params.add(new Object[]{i, "search", kw, cat, tags, pg, null, "STUDENT", null, "/book-search.jsp"});
        }

        // 11-15: BookDetailServlet - redirects and negative test cases
        params.add(new Object[]{11, "detail", null, null, null, null, null, "STUDENT", "/book-search", null}); // Null ID
        params.add(new Object[]{12, "detail", null, null, null, null, " ", "STUDENT", "/book-search", null}); // Empty ID
        params.add(new Object[]{13, "detail", null, null, null, null, "999", "STUDENT", "/book-search", null}); // Book not found
        params.add(new Object[]{14, "detail", null, null, null, null, "101", "GUEST", "/login?redirect=book-detail?id=101", null}); // Guest redirect
        params.add(new Object[]{15, "detail", null, null, null, null, "invalid", "STUDENT", "/book-search", null}); // Invalid format ID

        // 16-20: BookDetailServlet - success detail pages
        for (int i = 16; i <= 20; i++) {
            params.add(new Object[]{i, "detail", null, null, null, null, "101", "STUDENT", null, "/book-detail.jsp"});
        }

        return params;
    }

    private Connection mockConnection;
    private MockBookDAO mockBookDAO;

    @Before
    public void setUp() throws Exception {
        redirectUrl = null;
        forwardedUrl = null;
        requestAttributes.clear();
        sessionAttributes.clear();

        mockBookDAO = new MockBookDAO();

        // Setup mock connection
        Map<String, List<Map<String, Object>>> queries = new HashMap<>();

        // Mock detail servlet SQLs
        List<Map<String, Object>> activeBorrowResult = new ArrayList<>();
        activeBorrowResult.add(Collections.singletonMap("count", 0)); // No active borrow
        queries.put("BorrowRecord", activeBorrowResult);

        List<Map<String, Object>> activeResResult = new ArrayList<>();
        activeResResult.add(Collections.singletonMap("1", 0)); // No active reservation
        queries.put("Reservation", activeResResult);

        mockConnection = MockJdbc.createMockConnection(queries);
        util.DatabaseConnection.testConnection = mockConnection;

        // Session role setup
        if (userRole != null && !"GUEST".equals(userRole)) {
            sessionAttributes.put("userId", 42);
            sessionAttributes.put("role", userRole);
        }
    }

    @After
    public void tearDown() {
        util.DatabaseConnection.testConnection = null;
    }

    @Test
    public void testServletRequest() throws Exception {
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
                    if (!create && "GUEST".equals(userRole)) return null;
                    if (!create && userRole == null) return null;
                    return sessionMock;
                }
                if ("getParameter".equals(mName)) {
                    String param = (String) args[0];
                    if ("keyword".equals(param)) return keyword;
                    if ("categoryId".equals(param)) return categoryIdParam;
                    if ("page".equals(param)) return pageParam;
                    if ("id".equals(param)) return detailIdParam;
                    return null;
                }
                if ("getParameterValues".equals(mName)) {
                    String param = (String) args[0];
                    if ("tagId".equals(param)) return tagParams;
                    return null;
                }
                if ("setAttribute".equals(mName)) {
                    requestAttributes.put((String) args[0], args[1]);
                    return null;
                }
                if ("getRequestDispatcher".equals(mName)) {
                    forwardedUrl = (String) args[0];
                    return dispatcherMock;
                }
                if ("getContextPath".equals(mName)) {
                    return "";
                }
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
                    return null;
                }
                return null;
            }
        );

        if ("search".equals(servletType)) {
            BookSearchServlet servlet = new BookSearchServlet();
            setField(servlet, "bookDAO", mockBookDAO);
            invokeDoGet(servlet, requestMock, responseMock);

            if (expectedForward != null) {
                assertEquals(expectedForward, forwardedUrl);
                assertNotNull(requestAttributes.get("books"));
                assertNotNull(requestAttributes.get("categories"));
                assertNotNull(requestAttributes.get("tags"));
                assertEquals(Integer.parseInt(pageParam), requestAttributes.get("currentPage"));
                assertEquals(1, requestAttributes.get("totalPages"));
            }
        } else {
            BookDetailServlet servlet = new BookDetailServlet();
            setField(servlet, "bookDAO", mockBookDAO);
            invokeDoGet(servlet, requestMock, responseMock);

            if (expectedRedirect != null) {
                assertEquals(expectedRedirect, redirectUrl);
            }
            if (expectedForward != null) {
                assertEquals(expectedForward, forwardedUrl);
                assertNotNull(requestAttributes.get("book"));
                assertEquals(101, ((Book) requestAttributes.get("book")).getBookId());
            }
        }
    }

    // Mock BookDAO for Servlets Test
    private static class MockBookDAO extends BookDAO {
        @Override
        public List<Book> search(String keyword, Integer categoryId, int[] tagIds, String status, 
                                 String sort, int offset, int pageSize) {
            Book book1 = new Book(); book1.setBookId(101); book1.setTitle("Java Programming");
            return Collections.singletonList(book1);
        }

        @Override
        public int count(String keyword, Integer categoryId, int[] tagIds, String status) {
            return 1;
        }

        @Override
        public Book getBookById(int id) {
            if (id == 101) {
                Book book = new Book();
                book.setBookId(101);
                book.setTitle("Java Programming");
                return book;
            }
            return null;
        }

        @Override
        public List<Category> getAllCategories() {
            return Collections.singletonList(new Category(1, "Tech", "Tech"));
        }

        @Override
        public List<Tag> getAllTags() {
            Tag tag = new Tag(1, "java");
            tag.setStatus("active");
            return Collections.singletonList(tag);
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
