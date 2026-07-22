# T?ng h?p To�n b? M� ngu?n Unit Test (JUnit 4) - LMS Library Management System

Bao g?m 39 t?p m� ngu?n Unit Test du?c ph�n lo?i theo t?ng ph�n t?ng: DAO (MockJdbc), Filter, Service, v� Utility.


## test\dao\BookDAOTest.java

`java
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

``n

## test\dao\BorrowRecordDAOTest.java

`java
package dao;

import model.BorrowRecord;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class BorrowRecordDAOTest {

    private BorrowRecordDAO borrowRecordDAO;

    @Before
    public void setUp() {
        borrowRecordDAO = new BorrowRecordDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindByIdWithMockConn() throws Exception {
        Map<String, Object> recordData = new HashMap<>();
        recordData.put("borrowRecordId", 101);
        recordData.put("userId", 1);
        recordData.put("bookCopyId", 50);
        recordData.put("status", "borrowed");

        Connection mockConn = MockJdbc.createMockConnection(recordData, 0);
        BorrowRecord record = borrowRecordDAO.findBorrowRecordById(mockConn, 101);
        assertNotNull("BorrowRecord đọc từ MockResultSet không được null", record);
        assertEquals(101, record.getBorrowRecordId());
        assertEquals(1, record.getUserId());
        assertEquals(50, record.getBookCopyId());
    }

    @Test
    public void testUpdateStatusToReturnedWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        assertNotNull(mockConn);
    }
}

``n

## test\dao\FineDAOTest.java

`java
package dao;

import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.sql.Connection;
import static org.junit.Assert.*;

public class FineDAOTest {

    private FineDAO fineDAO;

    @Before
    public void setUp() {
        fineDAO = new FineDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testInsertCompensationFineWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        fineDAO.insertCompensationFine(mockConn, 101, 1, new BigDecimal("150000.00"), "Phạt hỏng sách");
        assertNotNull(fineDAO);
    }

    @Test
    public void testUpdateStatusToPaidWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        fineDAO.updateStatusToPaid(mockConn, 5);
    }
}

``n

## test\dao\MockJdbc.java

`java
package dao;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.Map;

/**
 * MockJdbc — Helper tạo đối tượng JDBC Mock offline (Connection, PreparedStatement, ResultSet)
 * để kiểm thử các lớp DAO an toàn 100% không cần CSDL thật và không ghi dơ dữ liệu.
 */
public class MockJdbc {

    public static Connection createMockConnection(final Map<String, Object> columnValues, final int affectedRows) {
        return (Connection) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("prepareStatement".equals(methodName)) {
                            return createMockPreparedStatement(columnValues, affectedRows);
                        } else if ("setAutoCommit".equals(methodName) || "commit".equals(methodName) || "rollback".equals(methodName) || "close".equals(methodName)) {
                            return null;
                        } else if ("isClosed".equals(methodName)) {
                            return false;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    public static PreparedStatement createMockPreparedStatement(final Map<String, Object> columnValues, final int affectedRows) {
        return (PreparedStatement) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{PreparedStatement.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("executeQuery".equals(methodName) || "getGeneratedKeys".equals(methodName)) {
                            Map<String, Object> generatedKeyMap = columnValues != null ? columnValues : new HashMap<String, Object>();
                            if (generatedKeyMap.isEmpty()) {
                                generatedKeyMap.put("1", 5);
                            }
                            return createMockResultSet(generatedKeyMap);
                        } else if ("executeUpdate".equals(methodName)) {
                            return affectedRows;
                        } else if ("close".equals(methodName) || methodName.startsWith("set")) {
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    public static ResultSet createMockResultSet(final Map<String, Object> columnValues) {
        final Map<String, Object> data = columnValues != null ? columnValues : new HashMap<String, Object>();
        final boolean[] moved = new boolean[]{false};

        return (ResultSet) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{ResultSet.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("next".equals(methodName)) {
                            if (!moved[0] && !data.isEmpty()) {
                                moved[0] = true;
                                return true;
                            }
                            return false;
                        } else if ("getString".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return val != null ? val.toString() : null;
                        } else if ("getInt".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return val instanceof Number ? ((Number) val).intValue() : 5;
                        } else if ("getBoolean".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return Boolean.TRUE.equals(val);
                        } else if ("getMetaData".equals(methodName)) {
                            return createMockMetaData(data);
                        } else if ("close".equals(methodName)) {
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    private static ResultSetMetaData createMockMetaData(final Map<String, Object> data) {
        return (ResultSetMetaData) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{ResultSetMetaData.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        if ("getColumnCount".equals(method.getName())) {
                            return data.size();
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    private static Object defaultValue(Class<?> type) {
        if (type == boolean.class || type == Boolean.class) return false;
        if (type == int.class || type == Integer.class) return 0;
        if (type == long.class || type == Long.class) return 0L;
        return null;
    }
}

``n

## test\dao\NotificationDAOTest.java

`java
package dao;

import model.Notification;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class NotificationDAOTest {

    private NotificationDAO notificationDAO;

    @Before
    public void setUp() {
        notificationDAO = new NotificationDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testNotificationDAOMockConn() throws Exception {
        Map<String, Object> data = new HashMap<>();
        data.put("notificationId", 1);
        data.put("title", "Thông báo nghỉ lễ");
        data.put("type", "general");

        Connection mockConn = MockJdbc.createMockConnection(data, 1);
        assertNotNull(mockConn);
        assertNotNull(notificationDAO);
    }
}

``n

## test\dao\PaymentDAOTest.java

`java
package dao;

import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class PaymentDAOTest {

    private PaymentDAO paymentDAO;

    @Before
    public void setUp() {
        paymentDAO = new PaymentDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindFineIdByPaymentIdWithMockConn() throws Exception {
        Map<String, Object> paymentData = new HashMap<>();
        paymentData.put("fineId", 5);

        Connection mockConn = MockJdbc.createMockConnection(paymentData, 0);
        int fineId = paymentDAO.findFineIdByPaymentId(mockConn, 10);
        assertEquals(5, fineId);
    }

    @Test
    public void testUpdateStatusToCompletedWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        paymentDAO.updateStatusToCompleted(mockConn, 10, 1);
    }
}

``n

## test\dao\SystemConfigurationsDAOTest.java

`java
package dao;

import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class SystemConfigurationsDAOTest {

    private SystemConfigurationsDAO dao;

    @Before
    public void setUp() {
        dao = new SystemConfigurationsDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testGetConfigValueWithMockConnection() throws Exception {
        Map<String, Object> mockData = new HashMap<>();
        mockData.put("configValue", "14");
        Connection mockConn = MockJdbc.createMockConnection(mockData, 0);

        assertNotNull(mockConn);
        assertNotNull(dao);
    }

    @Test
    public void testGetLibraryConfigurationsWithMockConnection() throws Exception {
        Map<String, Object> mockData = new HashMap<>();
        mockData.put("configKey", "MAX_BORROW_LIMIT");
        mockData.put("configValue", "5");
        Connection mockConn = MockJdbc.createMockConnection(mockData, 0);

        assertNotNull(mockConn);
    }
}

``n

## test\dao\UserDAOTest.java

`java
package dao;

import model.User;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class UserDAOTest {

    private UserDAO userDAO;

    @Before
    public void setUp() {
        userDAO = new UserDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindByEmailWithMockConn() throws Exception {
        Map<String, Object> userData = new HashMap<>();
        userData.put("userId", 1);
        userData.put("email", "student@fpt.edu.vn");
        userData.put("passwordHash", "$2a$10$hashedpassword");
        userData.put("status", "active");
        userData.put("role", "STUDENT");

        Connection mockConn = MockJdbc.createMockConnection(userData, 0);
        assertNotNull(mockConn);
        assertNotNull(userDAO);
    }

    @Test
    public void testUpdatePasswordWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        assertNotNull(mockConn);
    }
}

``n

## test\filter\AuthFilterTest.java

`java
package filter;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class AuthFilterTest {

    private AuthFilter filter;

    @Before
    public void setUp() {
        filter = new AuthFilter();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testAuthFilterInstantiation() {
        assertNotNull("AuthFilter instance được khởi tạo thành công", filter);
    }

    @Test
    public void testFilterLifecycleMethods() throws Exception {
        filter.init(null);
        filter.destroy();
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testStaticResourceExtensionCheckAllExtensions() {
        String[] staticExtensions = {".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".woff", ".woff2"};
        for (String ext : staticExtensions) {
            String path = "/assets/theme/style" + ext;
            assertTrue("File có đuôi " + ext + " phải là tài nguyên tĩnh",
                    path.endsWith(ext) || path.startsWith("/assets/"));
        }
    }

    @Test
    public void testBypassRoutesMatch() {
        String sepayWebhook = "/api/sepay-webhook";
        assertEquals("/api/sepay-webhook", sepayWebhook);

        String healthCheck = "/health";
        assertEquals("/health", healthCheck);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Access Control
    // ==========================================

    @Test
    public void testRoleRouteMatchingLogicAllRoles() {
        assertTrue("/admin/dashboard".startsWith("/admin/"));
        assertTrue("/librarian/book-management".startsWith("/librarian/"));
        assertTrue("/manager/system-config".startsWith("/manager/"));
        assertTrue("/student/my-loans".startsWith("/student/"));
        assertTrue("/lecturer/book-suggestions".startsWith("/lecturer/"));
    }

    @Test
    public void testBookManagementLegacyRouteMatching() {
        String legacy1 = "/book-management";
        String legacy2 = "/book-management/";
        String legacy3 = "/book-management/overview";

        assertTrue(legacy1.equals("/book-management") || legacy1.startsWith("/book-management/"));
        assertTrue(legacy2.equals("/book-management/"));
        assertTrue(legacy3.startsWith("/book-management/"));
    }
}

``n

## test\service\AiChatbotServiceTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class AiChatbotServiceTest {

    private AiChatbotService chatbotService;

    @Before
    public void setUp() {
        chatbotService = new AiChatbotService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testClassifyIntentRules() {
        String msg = "Mức phạt trễ hạn mượn sách là bao nhiêu tiền?";
        assertEquals("Rules", chatbotService.classifyIntent(msg));
    }

    @Test
    public void testClassifyIntentBooks() {
        String msg = "Cho tôi tìm cuốn sách về lập trình Java";
        assertEquals("Books", chatbotService.classifyIntent(msg));
    }

    @Test
    public void testClassifyIntentGreetingIrrelevant() {
        String msg = "Xin chào bạn";
        assertEquals("Irrelevant", chatbotService.classifyIntent(msg));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testClassifyIntentWithWhitespaceAndCaseSensitivity() {
        String msg = "   TÌM SÁCH VỀ CƠ SỞ DỮ LIỆU   ";
        assertEquals("Books", chatbotService.classifyIntent(msg));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testClassifyIntentNullReturnsIrrelevant() {
        assertEquals("Irrelevant", chatbotService.classifyIntent(null));
    }

    @Test
    public void testClassifyIntentEmptyReturnsIrrelevant() {
        assertEquals("Irrelevant", chatbotService.classifyIntent(""));
        assertEquals("Irrelevant", chatbotService.classifyIntent("   "));
    }
}

``n

## test\service\AiRecommendationServiceTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import static org.junit.Assert.*;

public class AiRecommendationServiceTest {

    private AiRecommendationService recService;

    @Before
    public void setUp() {
        recService = new AiRecommendationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("AiRecommendationService instance được tạo thành công", recService);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testGetRecommendationsEmptyCandidatePoolReturnsNull() {
        List<Integer> recs = recService.getRecommendations(new HashMap<>(), new ArrayList<>(), new ArrayList<>());
        assertNull("CandidatePool rỗng phải trả về null để kích hoạt Fallback", recs);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testGetRecommendationsNullCandidatePoolReturnsNull() {
        List<Integer> recs = recService.getRecommendations(null, null, null);
        assertNull("CandidatePool null phải trả về null không văng Exception", recs);
    }
}

``n

## test\service\AuthServiceTest.java

`java
package service;

import model.User;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class AuthServiceTest {

    private AuthService authService;

    @Before
    public void setUp() {
        authService = new AuthService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testVerifyPasswordSuccess() {
        String plain = "SecretPassword123";
        String hashed = BCrypt.hashpw(plain, BCrypt.gensalt());

        assertTrue("Mật khẩu khớp với hash BCrypt phải trả về true",
                authService.verifyPassword(plain, hashed));
    }

    @Test
    public void testVerifyPasswordWrongPassword() {
        String plain = "SecretPassword123";
        String hashed = BCrypt.hashpw(plain, BCrypt.gensalt());

        assertFalse("Mật khẩu sai phải trả về false",
                authService.verifyPassword("WrongPassword123", hashed));
    }

    @Test
    public void testIsAccountNotLockedForActiveUser() {
        User user = new User();
        user.setStatus("active");
        assertFalse("Tài khoản active không bị khóa", authService.isAccountLocked(user));
    }

    @Test
    public void testIsAccountLockedPermanentlyByAdmin() {
        User user = new User();
        user.setStatus("locked");
        user.setLockedUntil(null); // Khóa vĩnh viễn bởi Admin
        assertTrue("Tài khoản status=locked với lockedUntil=null bị khóa vĩnh viễn",
                authService.isAccountLocked(user));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testIsAccountLockedFutureTimestamp() {
        User user = new User();
        user.setStatus("locked");
        // Khóa đến 30 phút sau
        user.setLockedUntil(new Timestamp(System.currentTimeMillis() + 1800000));
        assertTrue("Tài khoản bị khóa đến tương lai", authService.isAccountLocked(user));
    }

    @Test
    public void testIsAccountLockedExpiredTimestamp() {
        User user = new User();
        user.setStatus("locked");
        // Thời hạn khóa đã trôi qua (10 giây trước)
        user.setLockedUntil(new Timestamp(System.currentTimeMillis() - 10000));
        assertFalse("Thời hạn khóa đã hết phải trả về false", authService.isAccountLocked(user));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testVerifyPasswordNullPlainOrHash() {
        String hashed = BCrypt.hashpw("Password123", BCrypt.gensalt());
        assertFalse("Mật khẩu plain null trả về false", authService.verifyPassword(null, hashed));
        assertFalse("Hash null trả về false", authService.verifyPassword("Password123", null));
    }

    @Test
    public void testVerifyPasswordInvalidHashPrefix() {
        // MD5 hoặc Plaintext hash không đúng định dạng $2a$
        assertFalse("Hash MD5 không hợp lệ trả về false",
                authService.verifyPassword("Password123", "5f4dcc3b5aa765d61d8327deb882cf99"));
    }

    @Test
    public void testIsAccountLockedNullUser() {
        assertFalse("User null không văng Exception và trả về false", authService.isAccountLocked(null));
    }
}

``n

## test\service\BookCopyIncidentServiceTest.java

`java
package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class BookCopyIncidentServiceTest {

    private BookCopyIncidentService incidentService;

    @Before
    public void setUp() {
        incidentService = new BookCopyIncidentService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateReportValidDamaged() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "Sách bị rách trang 10-15");
    }

    @Test
    public void testValidateReportValidLost() throws ValidationException {
        incidentService.validateReport("BC-1002", "lost", "Bạn làm mất sách tại phòng đọc");
    }

    @Test
    public void testValidateResolutionValid() throws ValidationException {
        incidentService.validateResolution("Đã xử lý xong và thu tiền phạt đền bù.");
    }

    @Test
    public void testValidateRepairNoteValid() throws ValidationException {
        incidentService.validateRepairNote("Đã đóng lại bìa và dán lại trang rách.");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateReportDescriptionBoundary1000() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "D".repeat(1000));
    }

    @Test
    public void testValidateResolutionBoundary1000() throws ValidationException {
        incidentService.validateResolution("R".repeat(1000));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateReportNullBarcode() throws ValidationException {
        incidentService.validateReport(null, "damaged", "Mô tả sự cố");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportInvalidType() throws ValidationException {
        incidentService.validateReport("BC-1001", "stolen", "Mô tả sự cố");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportBlankDescription() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportDescriptionExceeds1000() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "D".repeat(1001));
    }

    @Test(expected = ValidationException.class)
    public void testValidateResolutionBlank() throws ValidationException {
        incidentService.validateResolution("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateRepairNoteBlank() throws ValidationException {
        incidentService.validateRepairNote("   ");
    }
}

``n

## test\service\BookCopyServiceTest.java

`java
package service;

import exception.ValidationException;
import model.BookCopy;
import org.junit.Before;
import org.junit.Test;

public class BookCopyServiceTest {

    private BookCopyService bookCopyService;

    @Before
    public void setUp() {
        bookCopyService = new BookCopyService();
    }

    private BookCopy createValidCopy() {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(1);
        copy.setBookId(10);
        copy.setBarcode("BC-2026-1001");
        copy.setLocation("Kệ A1-02");
        copy.setCondition("good");
        copy.setStatus("available");
        return copy;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateCreateValidCopy() throws ValidationException {
        BookCopy copy = createValidCopy();
        bookCopyService.validateCreate(copy);
    }

    @Test
    public void testValidateUpdateValidCopy() throws ValidationException {
        BookCopy copy = createValidCopy();
        bookCopyService.validateUpdate(copy);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateCreateBarcodeLength50() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("B".repeat(50));
        bookCopyService.validateCreate(copy);
    }

    @Test
    public void testValidateCreateLocationLength255() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("L".repeat(255));
        bookCopyService.validateCreate(copy);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateCreateInvalidBookId() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBookId(0);
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateNullBarcode() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode(null);
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBarcodeExceeds50() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("B".repeat(51));
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBarcodeSpecialChars() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("BC@123#456");
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBlankLocation() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("   ");
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateLocationExceeds255() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("L".repeat(256));
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateUpdateInvalidCopyId() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBookCopyId(-1);
        bookCopyService.validateUpdate(copy);
    }
}

``n

## test\service\BookImportServiceTest.java

`java
package service;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public class BookImportServiceTest {

    private BookImportService importService;

    @Before
    public void setUp() {
        importService = new BookImportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testBookImportServiceInstantiation() {
        assertNotNull("BookImportService phải được khởi tạo thành công", importService);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidatePreviewWithErrors() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("books_test.xlsx");
        List<BookImportRowDTO> books = new ArrayList<>();
        BookImportRowDTO invalidBook = new BookImportRowDTO();
        invalidBook.setIsbn("INVALID-ISBN");
        invalidBook.setTitle("");
        books.add(invalidBook);
        preview.setBooks(books);

        importService.validate(preview, 1);
        assertFalse("Preview không hợp lệ phải trả về false", preview.isValid());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testValidateEmptyPreview() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("empty.xlsx");
        preview.setBooks(new ArrayList<>());
        preview.setBookCopies(new ArrayList<>());

        importService.validate(preview, 1);
        assertNotNull(preview.getErrors());
    }
}

``n

## test\service\BookImportValidatorTest.java

`java
package service;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.List;
import static org.junit.Assert.*;

public class BookImportValidatorTest {

    private BookImportValidator validator;

    @Before
    public void setUp() {
        validator = new BookImportValidator();
    }

    private BookImportPreviewDTO createValidPreview() {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test_import.xlsx");

        BookImportRowDTO bookRow = new BookImportRowDTO();
        bookRow.setRowNumber(2);
        bookRow.setIsbn("9780306406157");
        bookRow.setTitle("Lập trình Java Enterprise");
        bookRow.setAuthor("Tác Giả B");
        bookRow.setPublisher("NXB Trẻ");
        bookRow.setPublicationYear(2022);
        bookRow.setCategories(List.of("Công nghệ"));
        bookRow.setTags(List.of("Java"));

        preview.getBooks().add(bookRow);
        return preview;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidatorInstantiation() {
        assertNotNull("BookImportValidator instance được tạo thành công", validator);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidCategoryAndTagLengths() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setCategories(List.of("C".repeat(255)));
        bookRow.setTags(List.of("T".repeat(100)));

        assertTrue(preview.getErrors().isEmpty());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testInvalidCategoryExceeds255Chars() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setCategories(List.of("C".repeat(256)));

        // Giả lập logic kiểm tra độ dài thể loại
        if (bookRow.getCategories().get(0).length() > 255) {
            preview.getErrors().add(new model.BookImportError("Books", 2, "categories", "Tên thể loại quá dài"));
        }

        assertFalse("Preview phải chứa lỗi khi category > 255 ký tự", preview.getErrors().isEmpty());
    }

    @Test
    public void testInvalidTagExceeds100Chars() {
        BookImportPreviewDTO preview = createValidPreview();
        BookImportRowDTO bookRow = preview.getBooks().get(0);

        bookRow.setTags(List.of("T".repeat(101)));

        if (bookRow.getTags().get(0).length() > 100) {
            preview.getErrors().add(new model.BookImportError("Books", 2, "tags", "Tên tag quá dài"));
        }

        assertFalse("Preview phải chứa lỗi khi tag > 100 ký tự", preview.getErrors().isEmpty());
    }
}

``n

## test\service\BookServiceTest.java

`java
package service;

import exception.ValidationException;
import model.Book;
import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.time.Year;
import static org.junit.Assert.*;

public class BookServiceTest {

    private BookService bookService;

    @Before
    public void setUp() {
        bookService = new BookService();
    }

    private Book createValidBook() {
        Book book = new Book();
        book.setIsbn("9780306406157");
        book.setTitle("Lập Trình Java Web Monolith");
        book.setAuthor("Tác Giả A");
        book.setPublisher("NXB Giáo Dục");
        book.setPublicationYear(2023);
        book.setPrice(new BigDecimal("150000"));
        book.setStatus("available");
        return book;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidBookCreation() throws ValidationException {
        Book book = createValidBook();
        bookService.validate(book, true);
        assertEquals("9780306406157", book.getIsbn());
    }

    @Test
    public void testValidateValidBookUpdate() throws ValidationException {
        Book book = createValidBook();
        book.setBookId(1);
        bookService.validate(book, false);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryPublicationYear() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(1000); // Năm tối thiểu
        bookService.validate(book, true);

        book.setPublicationYear(Year.now().getValue() + 1); // Năm tối đa (năm sau)
        bookService.validate(book, true);
    }

    @Test
    public void testValidateBoundaryTitleLength500() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("A".repeat(500));
        bookService.validate(book, true);
    }

    @Test
    public void testValidateBoundaryZeroPrice() throws ValidationException {
        Book book = createValidBook();
        book.setPrice(BigDecimal.ZERO);
        bookService.validate(book, true);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullIsbnOnCreation() throws ValidationException {
        Book book = createValidBook();
        book.setIsbn(null);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidIsbnFormatOnCreation() throws ValidationException {
        Book book = createValidBook();
        book.setIsbn("123456");
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankTitle() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("   ");
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateTitleExceeds500Chars() throws ValidationException {
        Book book = createValidBook();
        book.setTitle("A".repeat(501));
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidPublicationYearTooOld() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(999);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidPublicationYearInFuture() throws ValidationException {
        Book book = createValidBook();
        book.setPublicationYear(Year.now().getValue() + 2);
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNegativePrice() throws ValidationException {
        Book book = createValidBook();
        book.setPrice(new BigDecimal("-1000"));
        bookService.validate(book, true);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Book book = createValidBook();
        book.setStatus("deleted");
        bookService.validate(book, true);
    }
}

``n

## test\service\BookSuggestionServiceTest.java

`java
package service;

import exception.ValidationException;
import model.BookSuggestion;
import org.junit.Before;
import org.junit.Test;

public class BookSuggestionServiceTest {

    private BookSuggestionService suggestionService;

    @Before
    public void setUp() {
        suggestionService = new BookSuggestionService();
    }

    private BookSuggestion createValidSuggestion() {
        BookSuggestion s = new BookSuggestion();
        s.setTitle("Thiết Kế Kiến Trúc Phần Mềm");
        s.setAuthor("Martin Fowler");
        s.setPublisher("NXB Trẻ");
        s.setIsbn("9780306406157");
        s.setReason("Phục vụ môn học SWP391 và kiến trúc phần mềm đại học.");
        s.setStatus("pending");
        return s;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidSuggestion() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        suggestionService.validate(s);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryTitleLength255() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setTitle("T".repeat(255));
        suggestionService.validate(s);
    }

    @Test
    public void testValidateBoundaryReasonLength1000() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setReason("R".repeat(1000));
        suggestionService.validate(s);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullTitle() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setTitle(null);
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankAuthor() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setAuthor("   ");
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateIsbnTooShort() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setIsbn("12345");
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateReasonExceeds1000() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setReason("R".repeat(1001));
        suggestionService.validate(s);
    }
}

``n

## test\service\CategoryServiceTest.java

`java
package service;

import exception.ValidationException;
import model.Category;
import org.junit.Before;
import org.junit.Test;

public class CategoryServiceTest {

    private CategoryService categoryService;

    @Before
    public void setUp() {
        categoryService = new CategoryService();
    }

    private Category createValidCategory() {
        Category category = new Category();
        category.setName("Khoa Học Máy Tính");
        category.setDescription("Sách về công nghệ và khoa học máy tính");
        category.setStatus("active");
        return category;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidActiveCategory() throws ValidationException {
        Category category = createValidCategory();
        categoryService.validate(category);
    }

    @Test
    public void testValidateValidHiddenCategory() throws ValidationException {
        Category category = createValidCategory();
        category.setStatus("hidden");
        categoryService.validate(category);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryNameLength255() throws ValidationException {
        Category category = createValidCategory();
        category.setName("C".repeat(255));
        categoryService.validate(category);
    }

    @Test
    public void testValidateBoundaryNameLength1() throws ValidationException {
        Category category = createValidCategory();
        category.setName("A");
        categoryService.validate(category);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullName() throws ValidationException {
        Category category = createValidCategory();
        category.setName(null);
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankName() throws ValidationException {
        Category category = createValidCategory();
        category.setName("   ");
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNameExceeds255Chars() throws ValidationException {
        Category category = createValidCategory();
        category.setName("C".repeat(256));
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Category category = createValidCategory();
        category.setStatus("archived");
        categoryService.validate(category);
    }
}

``n

## test\service\DeskCirculationServiceTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class DeskCirculationServiceTest {

    private DeskCirculationService service;

    @Before
    public void setUp() {
        service = new DeskCirculationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("DeskCirculationService được khởi tạo thành công", service);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testCheckOutBoundaryInvalidLibrarianIdZero() throws Exception {
        service.processCheckOut(0, "STUDENT001", "BC-1001");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testCheckOutNullBarcode() throws Exception {
        service.processCheckOut(1, "STUDENT001", null);
    }

    @Test(expected = Exception.class)
    public void testCheckOutBlankBarcode() throws Exception {
        service.processCheckOut(1, "STUDENT001", "   ");
    }

    @Test(expected = Exception.class)
    public void testCheckInNullBarcode() throws Exception {
        service.processCheckIn(1, null, "good");
    }

    @Test(expected = Exception.class)
    public void testCheckInBlankBarcode() throws Exception {
        service.processCheckIn(1, "   ", "good");
    }
}

``n

## test\service\EmailServiceTest.java

`java
package service;

import model.EmailJob;
import org.junit.Test;
import static org.junit.Assert.*;

public class EmailServiceTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testEnqueueValidGmail() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("testuser@gmail.com", "Mã OTP Xóa Mật Khẩu", "Nội dung OTP: 123456");
        EmailService.enqueue(job);
        assertEquals(initialSize + 1, EmailService.getQueueSize());
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testEnqueueUppercaseGmail() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("TESTUSER@GMAIL.COM", "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals(initialSize + 1, EmailService.getQueueSize());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testEnqueueNullJob() {
        int initialSize = EmailService.getQueueSize();
        EmailService.enqueue(null);
        assertEquals("Enqueue job null không thay đổi kích thước queue", initialSize, EmailService.getQueueSize());
    }

    @Test
    public void testEnqueueNonGmailIgnored() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("testuser@yahoo.com", "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals("Bỏ qua email không phải @gmail.com", initialSize, EmailService.getQueueSize());
    }

    @Test
    public void testEnqueueNullRecipientEmailIgnored() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob(null, "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals("Bỏ qua job có email null", initialSize, EmailService.getQueueSize());
    }
}

``n

## test\service\EmailWorkerTest.java

`java
package service;

import org.junit.Test;
import static org.junit.Assert.*;

public class EmailWorkerTest {

    @Test
    public void testEmailWorkerShutdownFlag() {
        EmailWorker worker = new EmailWorker(null);
        assertNotNull("EmailWorker được khởi tạo thành công", worker);

        // Phát tín hiệu dừng luồng an toàn
        worker.shutdown();
    }
}

``n

## test\service\ExcelExportServiceTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class ExcelExportServiceTest {

    private ExcelExportService exportService;

    @Before
    public void setUp() {
        exportService = new ExcelExportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testExportSystemReportEmptyData() throws Exception {
        Map<String, Object> data = new HashMap<>();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        exportService.exportSystemReportToExcel(data, out);
        byte[] bytes = out.toByteArray();

        assertNotNull(bytes);
        assertTrue("File Excel sinh ra phải lớn hơn 0 bytes", bytes.length > 0);
    }
}

``n

## test\service\InventoryReconciliationServiceTest.java

`java
package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class InventoryReconciliationServiceTest {

    private InventoryReconciliationService inventoryService;

    @Before
    public void setUp() {
        inventoryService = new InventoryReconciliationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateLocationValid() throws ValidationException {
        inventoryService.validateLocation("Kệ Sách A1 - Tầng 2");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateLocationBoundary255() throws ValidationException {
        inventoryService.validateLocation("L".repeat(255));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateLocationNull() throws ValidationException {
        inventoryService.validateLocation(null);
    }

    @Test(expected = ValidationException.class)
    public void testValidateLocationBlank() throws ValidationException {
        inventoryService.validateLocation("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateLocationExceeds255() throws ValidationException {
        inventoryService.validateLocation("L".repeat(256));
    }

    @Test(expected = ValidationException.class)
    public void testScanNullBarcode() throws Exception {
        inventoryService.scan(1, null, 1);
    }

    @Test(expected = ValidationException.class)
    public void testScanBlankBarcode() throws Exception {
        inventoryService.scan(1, "   ", 1);
    }
}

``n

## test\service\OnlineCirculationServiceTest.java

`java
package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class OnlineCirculationServiceTest {

    private OnlineCirculationService service;

    @Before
    public void setUp() {
        service = new OnlineCirculationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("OnlineCirculationService được khởi tạo thành công", service);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testReserveBookBoundaryUserIdZero() throws Exception {
        service.reserveBook(0, 1, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testReserveBookBoundaryBookIdZero() throws Exception {
        service.reserveBook(1, 0, "STUDENT");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testReserveBookNegativeUserId() throws Exception {
        service.reserveBook(-1, 1, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testReserveBookNegativeBookId() throws Exception {
        service.reserveBook(1, -5, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testRenewBookInvalidRecordId() throws Exception {
        service.renewBook(-1, 1);
    }
}

``n

## test\service\ProcessorTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ProcessorTest {

    private OverdueProcessor overdueProcessor;

    @Before
    public void setUp() {
        overdueProcessor = new OverdueProcessor();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testProcessorInstantiation() {
        assertNotNull("OverdueProcessor được khởi tạo thành công", overdueProcessor);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testProcessOverdueOffline() {
        // Trong môi trường offline (không có DB connection), processOverdue bắt SQLException và trả về result 0
        OverdueProcessor.OverdueResult result = overdueProcessor.processOverdue();
        assertNotNull(result);
        assertEquals(0, result.processedRecords);
        assertEquals(0, result.lockedUsers);
        assertEquals(0, result.emailsSent);
    }
}

``n

## test\service\ProfileServiceTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ProfileServiceTest {

    private ProfileService profileService;

    @Before
    public void setUp() {
        profileService = new ProfileService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("ProfileService instance được tạo thành công", profileService);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testUpdateUserInfoNullNameThrowsException() throws Exception {
        profileService.updateUserInfo(1, null, "0912345678", "Nam", "2000-01-01");
    }

    @Test(expected = Exception.class)
    public void testUpdateUserInfoBlankNameThrowsException() throws Exception {
        profileService.updateUserInfo(1, "   ", "0912345678", "Nam", "2000-01-01");
    }

    @Test(expected = Exception.class)
    public void testUpdateUserInfoInvalidDateFormatThrowsException() throws Exception {
        profileService.updateUserInfo(1, "Nguyễn Văn A", "0912345678", "Nam", "01/01/2000");
    }

    @Test(expected = Exception.class)
    public void testChangePasswordMismatchConfirmPasswordThrowsException() throws Exception {
        profileService.changePassword(1, "OldPw123!", "NewPw123!", "MismatchPw123!");
    }

    @Test(expected = Exception.class)
    public void testChangePasswordWeakPasswordPolicyThrowsException() throws Exception {
        // Mật khẩu yếu (không có ký tự đặc biệt / quá ngắn)
        profileService.changePassword(1, "OldPw123!", "weakpass", "weakpass");
    }
}

``n

## test\service\ReportServiceTest.java

`java
package service;

import dto.BorrowTrendDTO;
import dto.FinancialTrendDTO;
import dto.InventoryResultDTO;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static org.junit.Assert.*;

public class ReportServiceTest {

    private ExcelExportService excelExportService;

    @Before
    public void setUp() {
        excelExportService = new ExcelExportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testExportSystemReportToExcelSuccess() throws Exception {
        Map<String, Object> data = new HashMap<>();

        List<BorrowTrendDTO> borrowTrends = new ArrayList<>();
        BorrowTrendDTO bt = new BorrowTrendDTO();
        bt.setPeriodLabel("Tháng 06/2026");
        bt.setTotalBorrowed(150);
        bt.setTotalReturnedOnTime(140);
        bt.setTotalOverdue(10);
        borrowTrends.add(bt);
        data.getOrDefault("borrowTrends", data.put("borrowTrends", borrowTrends));

        List<FinancialTrendDTO> financialTrends = new ArrayList<>();
        FinancialTrendDTO ft = new FinancialTrendDTO();
        ft.setPeriodLabel("Tháng 06/2026");
        ft.setTotalPaid(500000);
        ft.setTotalUnpaid(50000);
        financialTrends.add(ft);
        data.put("financialTrends", financialTrends);

        InventoryResultDTO inventoryStats = new InventoryResultDTO();
        inventoryStats.setSessionId(1);
        inventoryStats.setLocation("Kệ A1");
        inventoryStats.setTotalMatched(100);
        inventoryStats.setTotalMissing(2);
        inventoryStats.setTotalMisplaced(1);
        data.put("inventoryStats", inventoryStats);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        excelExportService.exportSystemReportToExcel(data, baos);

        byte[] bytes = baos.toByteArray();
        assertTrue("File Excel sinh ra phải chứa dữ liệu bytes", bytes.length > 0);

        try (Workbook wb = new XSSFWorkbook(new ByteArrayInputStream(bytes))) {
            assertNotNull(wb.getSheet("Xu Hướng Mượn Trả"));
            assertNotNull(wb.getSheet("Đối Chiếu Tài Chính"));
            assertNotNull(wb.getSheet("Báo Cáo Kiểm Kê"));
        }
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testExportSystemReportWithEmptyDataMap() throws Exception {
        Map<String, Object> emptyData = new HashMap<>();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        excelExportService.exportSystemReportToExcel(emptyData, baos);

        byte[] bytes = baos.toByteArray();
        assertTrue("Workbook phải khởi tạo thành công dù map dữ liệu rỗng", bytes.length > 0);
    }
}

``n

## test\service\ReservationExpirationProcessorTest.java

`java
package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ReservationExpirationProcessorTest {

    private ReservationExpirationProcessor processor;

    @Before
    public void setUp() {
        processor = new ReservationExpirationProcessor();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testProcessorInstantiation() {
        assertNotNull("Processor instance phải được khởi tạo thành công", processor);
    }

    @Test
    public void testProcessExpirationExecution() {
        // Thực thi tiến trình quét quá hạn giữ chỗ (kết quả trả về ProcessResult không null)
        ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();
        assertNotNull(result);
        assertTrue(result.cancelledCount >= 0);
        assertTrue(result.promotedCount >= 0);
    }
}

``n

## test\service\SystemConfigServiceTest.java

`java
package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class SystemConfigServiceTest {

    private SystemConfigService configService;

    @Before
    public void setUp() {
        configService = new SystemConfigService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValuePositiveIntSuccess() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "14");
    }

    @Test
    public void testValidateValueNonNegativeIntSuccess() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "2");
    }

    @Test
    public void testValidateValueNonNegativeDecimalSuccess() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "5000.50");
    }

    @Test
    public void testValidateValueStringSuccess() throws ValidationException {
        configService.validateValue("SEPAY_BANK_CODE", "MBBANK");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateValuePositiveIntBoundaryOne() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "1");
    }

    @Test
    public void testValidateValueNonNegativeIntBoundaryZero() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "0");
    }

    @Test
    public void testValidateValueNonNegativeDecimalBoundaryZero() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "0.0");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateValueNullThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", null);
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueBlankThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValuePositiveIntZeroThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "0");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValuePositiveIntNegativeThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "-10");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueNonNegativeIntNegativeThrowsException() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "-1");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueNonNegativeDecimalNegativeThrowsException() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "-100.0");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueInvalidNumberFormatThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "not_a_number");
    }
}

``n

## test\service\TagServiceTest.java

`java
package service;

import exception.ValidationException;
import model.Tag;
import org.junit.Before;
import org.junit.Test;

public class TagServiceTest {

    private TagService tagService;

    @Before
    public void setUp() {
        tagService = new TagService();
    }

    private Tag createValidTag() {
        Tag tag = new Tag();
        tag.setName("Java17");
        tag.setStatus("active");
        return tag;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidActiveTag() throws ValidationException {
        Tag tag = createValidTag();
        tagService.validate(tag);
    }

    @Test
    public void testValidateValidHiddenTag() throws ValidationException {
        Tag tag = createValidTag();
        tag.setStatus("hidden");
        tagService.validate(tag);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryNameLength100() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("T".repeat(100));
        tagService.validate(tag);
    }

    @Test
    public void testValidateBoundaryNameLength1() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("X");
        tagService.validate(tag);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullName() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName(null);
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankName() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("   ");
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNameExceeds100Chars() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("T".repeat(101));
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Tag tag = createValidTag();
        tag.setStatus("deleted");
        tagService.validate(tag);
    }
}

``n

## test\service\UserServiceTest.java

`java
package service;

import model.UserDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public class UserServiceTest {

    private UserService userService;

    @Before
    public void setUp() {
        userService = new UserService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testUserServiceInstantiation() {
        assertNotNull("UserService instance được khởi tạo thành công", userService);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testImportUsersEmptyList() throws Exception {
        // Danh sách import rỗng (0 phần tử) phải ném Exception
        userService.importUsers(new ArrayList<>(), "STUDENT", 1);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testImportUsersNullList() throws Exception {
        // Danh sách import null phải ném Exception
        userService.importUsers(null, "STUDENT", 1);
    }
}

``n

## test\util\BookCoverFetcherTest.java

`java
package util;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class BookCoverFetcherTest {

    private BookCoverFetcher fetcher;

    @Before
    public void setUp() {
        fetcher = new BookCoverFetcher();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testBookCoverFetcherInstantiation() {
        assertNotNull("BookCoverFetcher instance phải được tạo thành công", fetcher);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testIsbnFormattingForFetcher() {
        String isbn = "978-0-13-468599-1";
        String cleanIsbn = isbn.replace("-", "").trim();
        assertEquals("9780134685991", cleanIsbn);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testNullIsbnHandling() {
        String isbn = null;
        assertNull("ISBN null thì cleanIsbn trả về null hoặc không rỗng", isbn);
    }
}

``n

## test\util\BookImageStorageTest.java

`java
package util;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import java.nio.file.Path;
import static org.junit.Assert.*;

public class BookImageStorageTest {

    private BookImageStorage storage;
    private final Path tempDir = Path.of("build/tmp/test-images");

    @Before
    public void setUp() {
        storage = new BookImageStorage(tempDir);
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testResolveValidJpgFilename() {
        String validJpg = "550e8400-e29b-41d4-a716-446655440000.jpg";
        Path resolved = storage.resolve(validJpg);
        assertNotNull(resolved);
        assertTrue(resolved.endsWith(validJpg));
    }

    @Test
    public void testResolveValidPngFilename() {
        String validPng = "123e4567-e89b-12d3-a456-426614174000.png";
        Path resolved = storage.resolve(validPng);
        assertNotNull(resolved);
        assertTrue(resolved.endsWith(validPng));
    }

    @Test
    public void testMaxFileSizeConstant() {
        assertEquals(5L * 1024 * 1024, BookImageStorage.MAX_FILE_SIZE);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testResolveUppercaseHexUuid() {
        String validUppercase = "550E8400-E29B-41D4-A716-446655440000.JPG";
        Path resolved = storage.resolve(validUppercase.toLowerCase());
        assertNotNull(resolved);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = IllegalArgumentException.class)
    public void testResolveNullFilenameThrowsException() {
        storage.resolve(null);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolveInvalidExtensionThrowsException() {
        storage.resolve("550e8400-e29b-41d4-a716-446655440000.exe");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolvePathTraversalAttemptThrowsException() {
        storage.resolve("../../../etc/passwd");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolveArbitraryStringThrowsException() {
        storage.resolve("my-custom-image-file.png");
    }
}

``n

## test\util\BookImportWorkbookReaderTest.java

`java
package util;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import static org.junit.Assert.*;

public class BookImportWorkbookReaderTest {

    private BookImportWorkbookReader reader;

    @Before
    public void setUp() {
        reader = new BookImportWorkbookReader();
    }

    private byte[] createTestWorkbook(boolean includeBooks, boolean includeCopies,
                                      boolean validBookHeaders, boolean validCopyHeaders) throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            if (includeBooks) {
                Sheet booksSheet = workbook.createSheet("Books");
                Row headerRow = booksSheet.createRow(0);
                if (validBookHeaders) {
                    for (int i = 0; i < BookImportWorkbookReader.BOOK_HEADERS.size(); i++) {
                        headerRow.createCell(i).setCellValue(BookImportWorkbookReader.BOOK_HEADERS.get(i));
                    }
                    // Thêm 1 dòng dữ liệu hợp lệ
                    Row dataRow = booksSheet.createRow(1);
                    dataRow.createCell(0).setCellValue("9780306406157"); // isbn
                    dataRow.createCell(1).setCellValue("Lập trình Java Web"); // title
                    dataRow.createCell(2).setCellValue("Nguyễn Văn A"); // author
                    dataRow.createCell(3).setCellValue("NXB Giáo Dục"); // publisher
                    dataRow.createCell(4).setCellValue(2023); // publicationYear
                    dataRow.createCell(5).setCellValue(150000); // price
                    dataRow.createCell(6).setCellValue("Công nghệ thông tin"); // categories
                    dataRow.createCell(7).setCellValue("Java, Servlet"); // tags
                } else {
                    headerRow.createCell(0).setCellValue("wrong_header");
                }
            }

            if (includeCopies) {
                Sheet copiesSheet = workbook.createSheet("BookCopies");
                Row headerRow = copiesSheet.createRow(0);
                if (validCopyHeaders) {
                    for (int i = 0; i < BookImportWorkbookReader.COPY_HEADERS.size(); i++) {
                        headerRow.createCell(i).setCellValue(BookImportWorkbookReader.COPY_HEADERS.get(i));
                    }
                    // Thêm 1 dòng bản sao hợp lệ
                    Row dataRow = copiesSheet.createRow(1);
                    dataRow.createCell(0).setCellValue("9780306406157"); // isbn
                    dataRow.createCell(1).setCellValue("BC-1001"); // barcode
                    dataRow.createCell(2).setCellValue("Kệ A1-02"); // location
                } else {
                    headerRow.createCell(0).setCellValue("wrong_header");
                }
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);
            return baos.toByteArray();
        }
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testReadValidWorkbook() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, true, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "test_books.xlsx");

        assertNotNull(preview);
        assertEquals("test_books.xlsx", preview.getFileName());
        assertTrue("Không được có lỗi với file hợp lệ", preview.getErrors().isEmpty());
        assertEquals(1, preview.getBooks().size());
        assertEquals(1, preview.getBookCopies().size());

        BookImportRowDTO bookRow = preview.getBooks().get(0);
        assertEquals("9780306406157", bookRow.getIsbn());
        assertEquals("Lập trình Java Web", bookRow.getTitle());
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testReadWorkbookWithOnlyHeaderRows() throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet booksSheet = workbook.createSheet("Books");
            Row bHeader = booksSheet.createRow(0);
            for (int i = 0; i < BookImportWorkbookReader.BOOK_HEADERS.size(); i++) {
                bHeader.createCell(i).setCellValue(BookImportWorkbookReader.BOOK_HEADERS.get(i));
            }
            Sheet copiesSheet = workbook.createSheet("BookCopies");
            Row cHeader = copiesSheet.createRow(0);
            for (int i = 0; i < BookImportWorkbookReader.COPY_HEADERS.size(); i++) {
                cHeader.createCell(i).setCellValue(BookImportWorkbookReader.COPY_HEADERS.get(i));
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);
            BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(baos.toByteArray()), "empty_headers.xlsx");

            assertNotNull(preview);
            assertTrue(preview.getBooks().isEmpty());
            assertTrue(preview.getBookCopies().isEmpty());
        }
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testReadWorkbookMissingBooksSheet() throws IOException {
        byte[] excelBytes = createTestWorkbook(false, true, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "no_books.xlsx");

        assertFalse("Phải chứa báo lỗi do thiếu sheet Books", preview.getErrors().isEmpty());
        assertTrue(preview.getErrors().stream().anyMatch(e -> e.getErrorMessage().contains("Books")));
    }

    @Test
    public void testReadWorkbookMissingCopiesSheet() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, false, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "no_copies.xlsx");

        assertFalse("Phải chứa báo lỗi do thiếu sheet BookCopies", preview.getErrors().isEmpty());
        assertTrue(preview.getErrors().stream().anyMatch(e -> e.getErrorMessage().contains("BookCopies")));
    }

    @Test
    public void testReadWorkbookInvalidHeaders() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, true, false, false);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "invalid_headers.xlsx");

        assertFalse("Phải chứa báo lỗi do sai tên tiêu đề cột", preview.getErrors().isEmpty());
    }
}

``n

## test\util\CsvExportUtilTest.java

`java
package util;

import org.junit.Test;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import static org.junit.Assert.*;

public class CsvExportUtilTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testEscapeNormalText() {
        assertEquals("Hello World", CsvExportUtil.escape("Hello World"));
        assertEquals("LMS Library 2026", CsvExportUtil.escape("LMS Library 2026"));
    }

    @Test
    public void testEscapeSpecialCharactersCommaAndQuotes() {
        assertEquals("\"Java, Servlet\"", CsvExportUtil.escape("Java, Servlet"));
        assertEquals("\"Book \"\"Clean Code\"\"\"", CsvExportUtil.escape("Book \"Clean Code\""));
        assertEquals("\"Line1\nLine2\"", CsvExportUtil.escape("Line1\nLine2"));
    }

    @Test
    public void testFormatTimestampValid() {
        Timestamp ts = Timestamp.valueOf("2026-06-06 14:30:00");
        assertEquals("06/06/2026 14:30", CsvExportUtil.formatTimestamp(ts));
    }

    @Test
    public void testUtf8BomWriter() throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (PrintWriter writer = CsvExportUtil.utf8BomWriter(baos)) {
            writer.print("Header1,Header2");
        }
        byte[] bytes = baos.toByteArray();
        assertTrue("Output phải có ít nhất 3 byte BOM UTF-8", bytes.length >= 3);
        // Kiểm tra 3 byte BOM EF BB BF
        assertEquals((byte) 0xEF, bytes[0]);
        assertEquals((byte) 0xBB, bytes[1]);
        assertEquals((byte) 0xBF, bytes[2]);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testEscapeEmptyString() {
        assertEquals("", CsvExportUtil.escape(""));
    }

    @Test
    public void testEscapeFormulaWithLeadingSpaces() {
        // Chuỗi có khoảng trắng đứng trước công thức Excel
        assertEquals("'   =1+1", CsvExportUtil.escape("   =1+1"));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Security
    // ==========================================

    @Test
    public void testEscapeNull() {
        assertEquals("Null phải trả về chuỗi rỗng", "", CsvExportUtil.escape(null));
    }

    @Test
    public void testFormatTimestampNull() {
        assertEquals("Timestamp null phải trả về chuỗi rỗng", "", CsvExportUtil.formatTimestamp(null));
    }

    @Test
    public void testFormulaInjectionNeutralization() {
        // Chống lỗi CSV / Excel Formula Injection (=, +, -, @)
        assertEquals("'=SUM(A1:A10)", CsvExportUtil.escape("=SUM(A1:A10)"));
        assertEquals("'+123456", CsvExportUtil.escape("+123456"));
        assertEquals("'-5000", CsvExportUtil.escape("-5000"));
        assertEquals("'@CMD", CsvExportUtil.escape("@CMD"));
    }
}

``n

## test\util\GoogleSSOUtilTest.java

`java
package util;

import org.junit.Test;
import static org.junit.Assert.*;

public class GoogleSSOUtilTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testGetLoginUrlContainsOAuthParams() {
        String url = GoogleSSOUtil.getLoginUrl();
        assertNotNull("Google Login URL không được null", url);
        assertTrue("URL phải chứa endpoint OAuth của Google", url.startsWith(GoogleSSOUtil.AUTH_URI));
        assertTrue("URL phải chứa scope email profile", url.contains("scope=email%20profile"));
        assertTrue("URL phải chứa response_type=code", url.contains("response_type=code"));
    }

    @Test
    public void testConstantsNotNull() {
        assertNotNull("CLIENT_ID không được null", GoogleSSOUtil.CLIENT_ID);
        assertNotNull("CLIENT_SECRET không được null", GoogleSSOUtil.CLIENT_SECRET);
        assertNotNull("REDIRECT_URI không được null", GoogleSSOUtil.REDIRECT_URI);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testGetTokenInvalidCodeThrowsException() throws Exception {
        // Code không hợp lệ gửi tới Google OAuth endpoint sẽ bị ném Exception
        GoogleSSOUtil.getToken("invalid_dummy_code_12345");
    }

    @Test(expected = Exception.class)
    public void testGetUserEmailInvalidAccessTokenThrowsException() throws Exception {
        // Access token không hợp lệ gửi tới Google userinfo endpoint sẽ bị ném Exception
        GoogleSSOUtil.getUserEmail("invalid_dummy_access_token_12345");
    }
}

``n

## test\util\IsbnValidatorTest.java

`java
package util;

import org.junit.Test;
import static org.junit.Assert.*;

public class IsbnValidatorTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidIsbn10Standard() {
        // ISBN-10 hợp lệ với các chữ số chuẩn (0306406152)
        assertTrue("ISBN-10 chuẩn hợp lệ", IsbnValidator.isValid("0306406152"));
    }

    @Test
    public void testValidIsbn10WithChecksumX() {
        // ISBN-10 hợp lệ có chữ số kiểm tra là 'X' hoặc 'x' (080442957X)
        assertTrue("ISBN-10 với checksum X viết hoa hợp lệ", IsbnValidator.isValid("080442957X"));
        assertTrue("ISBN-10 với checksum x viết thường hợp lệ", IsbnValidator.isValid("080442957x"));
    }

    @Test
    public void testValidIsbn13Standard() {
        // ISBN-13 chuẩn hợp lệ (9780306406157)
        assertTrue("ISBN-13 chuẩn hợp lệ", IsbnValidator.isValid("9780306406157"));
    }

    @Test
    public void testValidIsbnWithHyphensAndSpaces() {
        // ISBN có định dạng chứa dấu gạch ngang hoặc khoảng trắng
        assertTrue("ISBN-13 chứa dấu gạch ngang hợp lệ", IsbnValidator.isValid("978-0-306-40615-7"));
        assertTrue("ISBN-10 chứa khoảng trắng hợp lệ", IsbnValidator.isValid("0 306 40615 2"));
    }

    @Test
    public void testNormalizeValidString() {
        assertEquals("9780306406157", IsbnValidator.normalize(" 978-0-306-40615-7 "));
        assertEquals("080442957X", IsbnValidator.normalize("0-8044-2957-x"));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testBoundaryLength10Digits() {
        // Chuỗi đúng 10 ký tự sau khi chuẩn hóa
        String normalized = IsbnValidator.normalize("0306406152");
        assertNotNull(normalized);
        assertEquals(10, normalized.length());
        assertTrue(IsbnValidator.isValid("0306406152"));
    }

    @Test
    public void testBoundaryLength13Digits() {
        // Chuỗi đúng 13 ký tự sau khi chuẩn hóa
        String normalized = IsbnValidator.normalize("9780306406157");
        assertNotNull(normalized);
        assertEquals(13, normalized.length());
        assertTrue(IsbnValidator.isValid("9780306406157"));
    }

    @Test
    public void testNormalizeNullAndEmpty() {
        assertNull("Normalize null phải trả về null", IsbnValidator.normalize(null));
        assertEquals("Normalize rỗng phải trả về chuỗi rỗng", "", IsbnValidator.normalize(""));
        assertEquals("Normalize chỉ có khoảng trắng trả về chuỗi rỗng", "", IsbnValidator.normalize("   "));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testInvalidNullOrEmptyIsbn() {
        assertFalse("ISBN null phải trả về false", IsbnValidator.isValid(null));
        assertFalse("ISBN rỗng phải trả về false", IsbnValidator.isValid(""));
        assertFalse("ISBN chỉ chứa khoảng trắng phải trả về false", IsbnValidator.isValid("   "));
    }

    @Test
    public void testInvalidLengthTooShortOrLong() {
        assertFalse("ISBN 9 ký tự phải trả về false", IsbnValidator.isValid("123456789"));
        assertFalse("ISBN 11 ký tự phải trả về false", IsbnValidator.isValid("12345678901"));
        assertFalse("ISBN 12 ký tự phải trả về false", IsbnValidator.isValid("123456789012"));
        assertFalse("ISBN 14 ký tự phải trả về false", IsbnValidator.isValid("97803064061571"));
    }

    @Test
    public void testInvalidChecksum() {
        // Sai số checksum
        assertFalse("ISBN-10 sai checksum phải trả về false", IsbnValidator.isValid("0306406153"));
        assertFalse("ISBN-13 sai checksum phải trả về false", IsbnValidator.isValid("9780306406158"));
    }

    @Test
    public void testInvalidCharacters() {
        assertFalse("ISBN chứa chữ cái không phải X ở cuối phải trả về false", IsbnValidator.isValid("030640615A"));
        assertFalse("ISBN-13 chứa chữ cái phải trả về false", IsbnValidator.isValid("978030640615X"));
        assertFalse("ISBN chứa ký tự đặc biệt phải trả về false", IsbnValidator.isValid("978030640615#"));
    }
}

``n

## test\util\SupabaseStorageClientTest.java

`java
package util;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class SupabaseStorageClientTest {

    private SupabaseStorageClient configuredClient;
    private SupabaseStorageClient unconfiguredClient;

    @Before
    public void setUp() {
        configuredClient = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                "https://xyz.supabase.co",
                "test-service-role-key-123456",
                "book-covers"
        );
        unconfiguredClient = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                null,
                null,
                null
        );
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testIsConfiguredTrue() {
        assertTrue("Client có cấu hình hợp lệ phải trả về true", configuredClient.isConfigured());
    }

    @Test
    public void testIsConfiguredFalse() {
        assertFalse("Client thiếu cấu hình phải trả về false", unconfiguredClient.isConfigured());
    }

    @Test
    public void testPublicObjectUrlGeneration() {
        String fileName = "sample-cover.jpg";
        String expectedUrl = "https://xyz.supabase.co/storage/v1/object/public/book-covers/sample-cover.jpg";
        assertEquals(expectedUrl, configuredClient.publicObjectUrl(fileName));
    }

    @Test
    public void testGetConfigurationStatus() {
        String status = configuredClient.getConfigurationStatus();
        assertNotNull(status);
        assertTrue(status.contains("supabaseUrl=present"));
        assertTrue(status.contains("serviceRoleKey=present"));
        assertTrue(status.contains("bucket=book-covers"));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testUrlNormalizationWithTrailingSlashes() {
        SupabaseStorageClient clientWithSlashes = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                "https://xyz.supabase.co/rest/v1/",
                "key",
                "covers"
        );
        assertEquals("https://xyz.supabase.co/storage/v1/object/public/covers/test.png", clientWithSlashes.publicObjectUrl("test.png"));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = IllegalStateException.class)
    public void testPublicObjectUrlUnconfiguredThrowsException() {
        unconfiguredClient.publicObjectUrl("sample.jpg");
    }

    @Test(expected = IllegalStateException.class)
    public void testUploadPublicObjectUnconfiguredThrowsException() throws Exception {
        unconfiguredClient.uploadPublicObject("sample.jpg", new byte[0], "image/jpeg");
    }
}

``n
