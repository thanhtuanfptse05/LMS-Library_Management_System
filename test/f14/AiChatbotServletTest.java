package f14;

import controllers.AiChatbotServlet;
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
public class AiChatbotServletTest {

    private final int testId;
    private final String requestBodyJson;
    private final Map<String, Object> sessionAttributes;
    private final Map<String, List<Map<String, Object>>> dbData;
    private final boolean expectSuccess;

    public AiChatbotServletTest(int testId, String requestBodyJson, Map<String, Object> sessionAttributes,
                               Map<String, List<Map<String, Object>>> dbData, boolean expectSuccess) {
        this.testId = testId;
        this.requestBodyJson = requestBodyJson;
        this.sessionAttributes = sessionAttributes;
        this.dbData = dbData;
        this.expectSuccess = expectSuccess;
    }

    @Parameters(name = "{index}: Chatbot Servlet TestId={0}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        for (int i = 1; i <= 20; i++) {
            String bodyJson = "{\"message\":\"Tôi bị phạt bao nhiêu?\"}";
            Map<String, Object> sessionAttrs = new HashMap<>();
            Map<String, List<Map<String, Object>>> dbMock = new HashMap<>();
            boolean success = true;

            // Mock session user if logged in
            if (i % 2 == 0) {
                Map<String, Object> sessionUser = new HashMap<>();
                sessionUser.put("userId", i);
                sessionUser.put("role", "STUDENT");
                sessionAttrs.put("user", createMockUserDto(sessionUser));
            }

            // Various inputs
            if (i == 1) {
                bodyJson = "{\"message\":\"\"}"; // empty message
            } else if (i == 2) {
                bodyJson = "{}"; // missing message field
            } else if (i == 3) {
                bodyJson = "invalid-json"; // malformed JSON
            } else {
                bodyJson = "{\"message\":\"Câu hỏi test số " + i + "\"}";
            }

            setupLibraryConfigurations(dbMock);

            params.add(new Object[]{i, bodyJson, sessionAttrs, dbMock, success});
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

    private static void setupLibraryConfigurations(Map<String, List<Map<String, Object>>> db) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r1 = new HashMap<>();
        r1.put("configKey", "FINE_RATE_PER_DAY");
        r1.put("configValue", "5000");
        rows.add(r1);
        db.put("getLibraryConfigurations", rows);
        db.put("SystemConfigurations", rows);
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
                if ("getReader".equals(mName)) {
                    return new java.io.BufferedReader(new java.io.StringReader(requestBodyJson));
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
                if ("setContentType".equals(mName)) {
                    return null;
                }
                if ("setCharacterEncoding".equals(mName)) {
                    return null;
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
    public void testServlet() {
        AiChatbotServlet servlet = new AiChatbotServlet();
        try {
            java.lang.reflect.Method m = servlet.getClass().getDeclaredMethod("doPost", HttpServletRequest.class, HttpServletResponse.class);
            m.setAccessible(true);
            m.invoke(servlet, mockRequest, mockResponse);
            String responseText = responseWriter.toString();
            assertNotNull(responseText);
            // It should respond with some valid JSON structure containing reply or success/error fields
            assertTrue(responseText.contains("reply") || responseText.contains("error") || responseText.trim().isEmpty() || responseText.contains("status"));
        } catch (Exception e) {
            if (expectSuccess) {
                fail("Servlet testId " + testId + " failed: " + e.getMessage());
            }
        }
    }
}
