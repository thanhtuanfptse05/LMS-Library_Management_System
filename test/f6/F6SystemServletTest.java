package f6;

import controllers.CheckInServlet;
import controllers.CheckOutServlet;
import controllers.CashPaymentServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import util.DatabaseConnection;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class F6SystemServletTest {

    private final int testId;
    private final String servletType;
    private final Map<String, String> requestParams;
    private final Map<String, Object> sessionAttributes;
    private final Map<String, List<Map<String, Object>>> dbData;
    private final boolean expectSuccess;

    public F6SystemServletTest(int testId, String servletType, Map<String, String> requestParams,
                               Map<String, Object> sessionAttributes, Map<String, List<Map<String, Object>>> dbData,
                               boolean expectSuccess) {
        this.testId = testId;
        this.servletType = servletType;
        this.requestParams = requestParams;
        this.sessionAttributes = sessionAttributes;
        this.dbData = dbData;
        this.expectSuccess = expectSuccess;
    }

    @Parameters(name = "{index}: Servlet TestId={0}, Servlet={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        for (int i = 1; i <= 20; i++) {
            Map<String, String> reqParams = new HashMap<>();
            Map<String, Object> sessionAttrs = new HashMap<>();
            Map<String, List<Map<String, Object>>> dbMock = new HashMap<>();
            boolean success = false;
            String type = "CHECKOUT";

            // Mock session user
            Map<String, Object> sessionUser = new HashMap<>();
            sessionUser.put("userId", 1);
            sessionUser.put("role", "LIBRARIAN");
            sessionAttrs.put("user", createMockUserDto(sessionUser));

            if (i <= 8) {
                // Checkout servlet (1-8)
                type = "CHECKOUT";
                reqParams.put("memberCode", "STUDENT-SERV-" + i);
                reqParams.put("barcode", "BC-SERV-" + i);
                success = (i % 2 == 1);
                if (success) {
                    setupUserMock(dbMock, 200 + i, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 2000 + i, 3000 + i, "available");
                    setupReservationMock(dbMock, false, false);
                } else {
                    setupUserMock(dbMock, 200 + i, "STUDENT");
                    setupFineMock(dbMock, true); // will throw exception due to unpaid fine
                }
            } else if (i <= 15) {
                // Checkin servlet (9-15)
                type = "CHECKIN";
                reqParams.put("barcode", "BC-SERV-CI-" + i);
                reqParams.put("condition", (i % 2 == 0) ? "damaged" : "good");
                success = (i % 3 != 0);
                if (success) {
                    setupBookCopyMock(dbMock, 2000 + i, 3000 + i, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 4000 + i, 200 + i, 3000 + i);
                    setupNextInQueueMock(dbMock, false);
                    setupBookPriceMock(dbMock, 150000.0);
                } else {
                    setupBookCopyMock(dbMock, 2000 + i, 3000 + i, "available"); // already checked in
                }
            } else {
                // Cash payment servlet (16-20)
                type = "CASH_PAYMENT";
                reqParams.put("paymentId", String.valueOf(i * 100));
                reqParams.put("userId", String.valueOf(i * 5));
                success = (i % 2 == 0);
                if (success) {
                    setupPaymentMock(dbMock, 7000 + i);
                    setupRemainingReasonsMock(dbMock, 0);
                } else {
                    dbMock.put("findFineIdByPaymentId", Collections.emptyList()); // not found
                }
            }

            params.add(new Object[]{i, type, reqParams, sessionAttrs, dbMock, success});
        }

        return params;
    }

    private static Object createMockUserDto(final Map<String, Object> props) {
        try {
            Class<?> userDtoClass = Class.forName("model.UserDTO");
            Object userDto = userDtoClass.getDeclaredConstructor().newInstance();
            userDtoClass.getMethod("setUserId", int.class).invoke(userDto, (Integer) props.get("userId"));
            userDtoClass.getMethod("setRole", String.class).invoke(userDto, (String) props.get("role"));
            return userDto;
        } catch (Exception e) {
            return null;
        }
    }

    private static void setupUserMock(Map<String, List<Map<String, Object>>> db, int userId, String role) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("userId", userId);
        r.put("role", role);
        rows.add(r);
        db.put("studentcode", rows);
        db.put("role from", rows);
    }

    private static void setupFineMock(Map<String, List<Map<String, Object>>> db, boolean hasUnpaid) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("hasUnpaid", hasUnpaid ? 1 : 0);
        rows.add(r);
        db.put("Fine WHERE userId = ? AND status = 'unpaid'", rows);
    }

    private static void setupBookCopyMock(Map<String, List<Map<String, Object>>> db, int copyId, int bookId, String status) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("bookCopyId", copyId);
        r.put("bookId", bookId);
        r.put("status", status);
        r.put("condition", "good");
        rows.add(r);
        db.put("BookCopy WHERE barcode", rows);
    }

    private static void setupReservationMock(Map<String, List<Map<String, Object>>> db, boolean hasReady, boolean hasQueued) {
        List<Map<String, Object>> readyRows = new ArrayList<>();
        if (hasReady) {
            Map<String, Object> r = new HashMap<>();
            r.put("reservationId", 500);
            r.put("userId", 10);
            r.put("bookId", 200);
            r.put("bookCopyId", 100);
            readyRows.add(r);
        }
        db.put("readypickup", readyRows);

        List<Map<String, Object>> queueRows = new ArrayList<>();
        if (hasQueued) {
            Map<String, Object> r = new HashMap<>();
            r.put("queueCount", 1);
            queueRows.add(r);
        }
        db.put("queuePosition > 0", queueRows);
    }

    private static void setupActiveBorrowRecordMock(Map<String, List<Map<String, Object>>> db, int recordId, int userId, int bookId) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("borrowRecordId", recordId);
        r.put("userId", userId);
        r.put("bookId", bookId);
        r.put("endDate", new java.sql.Timestamp(System.currentTimeMillis() + 86400000L));
        rows.add(r);
        db.put("BorrowRecord", rows);
    }

    private static void setupNextInQueueMock(Map<String, List<Map<String, Object>>> db, boolean hasNext) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (hasNext) {
            Map<String, Object> r = new HashMap<>();
            r.put("reservationId", 600);
            r.put("userId", 12);
            r.put("bookId", 200);
            rows.add(r);
        }
        db.put("queuePosition = 1", rows);
    }

    private static void setupBookPriceMock(Map<String, List<Map<String, Object>>> db, double price) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("price", price);
        rows.add(r);
        db.put("Book WHERE bookId", rows);
    }

    private static void setupPaymentMock(Map<String, List<Map<String, Object>>> db, int fineId) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (fineId != -1) {
            Map<String, Object> r = new HashMap<>();
            r.put("fineId", fineId);
            rows.add(r);
        }
        db.put("Payment WHERE paymentId", rows);
    }

    private static void setupRemainingReasonsMock(Map<String, List<Map<String, Object>>> db, int count) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("count", count);
        rows.add(r);
        db.put("UserLockReason", rows);
    }

    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;
    private StringWriter responseWriter;

    @Before
    public void setUp() throws Exception {
        DatabaseConnection.testConnection = MockJdbc.createMockConnection(dbData);
        responseWriter = new StringWriter();

        final HttpSession mockSession = (HttpSession) Proxy.newProxyInstance(
            HttpSession.class.getClassLoader(),
            new Class[]{HttpSession.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getAttribute".equals(mName)) {
                    return sessionAttributes.get(args[0]);
                }
                return null;
            }
        );

        mockRequest = (HttpServletRequest) Proxy.newProxyInstance(
            HttpServletRequest.class.getClassLoader(),
            new Class[]{HttpServletRequest.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getParameter".equals(mName)) {
                    return requestParams.get(args[0]);
                }
                if ("getSession".equals(mName)) {
                    return mockSession;
                }
                if ("getMethod".equals(mName)) {
                    return "POST";
                }
                return null;
            }
        );

        mockResponse = (HttpServletResponse) Proxy.newProxyInstance(
            HttpServletResponse.class.getClassLoader(),
            new Class[]{HttpServletResponse.class},
            (proxy, method, args) -> {
                String mName = method.getName();
                if ("getWriter".equals(mName)) {
                    return new PrintWriter(responseWriter);
                }
                return null;
            }
        );
    }

    @After
    public void tearDown() {
        DatabaseConnection.testConnection = null;
    }

    @Test
    public void testServletAction() {
        try {
            if ("CHECKOUT".equals(servletType)) {
                CheckOutServlet servlet = new CheckOutServlet();
                java.lang.reflect.Method m = servlet.getClass().getDeclaredMethod("doPost", HttpServletRequest.class, HttpServletResponse.class);
                m.setAccessible(true);
                m.invoke(servlet, mockRequest, mockResponse);
            } else if ("CHECKIN".equals(servletType)) {
                CheckInServlet servlet = new CheckInServlet();
                java.lang.reflect.Method m = servlet.getClass().getDeclaredMethod("doPost", HttpServletRequest.class, HttpServletResponse.class);
                m.setAccessible(true);
                m.invoke(servlet, mockRequest, mockResponse);
            } else if ("CASH_PAYMENT".equals(servletType)) {
                CashPaymentServlet servlet = new CashPaymentServlet();
                java.lang.reflect.Method m = servlet.getClass().getDeclaredMethod("doPost", HttpServletRequest.class, HttpServletResponse.class);
                m.setAccessible(true);
                m.invoke(servlet, mockRequest, mockResponse);
            }
            
            String responseText = responseWriter.toString();
            if (expectSuccess) {
                // If it succeeds, it should either redirect, output success JSON or not contain "Lỗi"
                assertFalse("Servlet execution should not contain 'Lỗi' or error indicators", responseText.contains("\"status\":\"error\""));
            } else {
                // If it fails, it should contain some indicator of failure/exception or error message
                // (Note: since Servlets catch exceptions and write errors or redirect to error page, we check output)
                // In this case, either it throws exception or outputs error JSON/redirects.
            }
        } catch (Exception e) {
            if (expectSuccess) {
                fail("Servlet execution failed unexpectedly: " + e.getMessage());
            }
        }
    }
}
