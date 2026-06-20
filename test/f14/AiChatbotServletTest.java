package f14;

import controllers.AiChatbotServlet;
import model.ChatMessage;
import service.AiChatbotService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static org.junit.Assert.*;

/**
 * AiChatbotServletTest — Unit Tests cho AiChatbotServlet (F14).
 * Sử dụng Dynamic Proxy để mock Servlet Request/Response/Session và Java Reflection để inject mock service.
 */
public class AiChatbotServletTest {

    private AiChatbotServlet servlet;
    private MockAiChatbotService mockService;
    private Map<String, Object> sessionAttributes;
    private String requestJson;
    private StringWriter responseWriter;

    private HttpServletRequest requestProxy;
    private HttpServletResponse responseProxy;

    private static class MockAiChatbotService extends AiChatbotService {
        String lastSystemPrompt;
        String mockBooksContext;

        @Override
        public String classifyIntent(String userMessage) {
            return "Books";
        }

        @Override
        public String retrieveBooksContext(String userMessage) {
            return mockBooksContext;
        }

        @Override
        public String callGeminiChat(List<ChatMessage> history, String systemInstructionText) {
            this.lastSystemPrompt = systemInstructionText;
            return "Mock AI response";
        }
    }

    @Before
    public void setUp() throws Exception {
        servlet = new AiChatbotServlet();
        mockService = new MockAiChatbotService();

        // Inject Mock Service qua Reflection
        Field field = AiChatbotServlet.class.getDeclaredField("aiChatbotService");
        field.setAccessible(true);
        field.set(servlet, mockService);

        sessionAttributes = new HashMap<>();
        responseWriter = new StringWriter();

        // Mock HttpSession
        HttpSession sessionProxy = (HttpSession) Proxy.newProxyInstance(
                HttpSession.class.getClassLoader(),
                new Class[]{HttpSession.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String name = method.getName();
                        if ("getAttribute".equals(name)) {
                            return sessionAttributes.get(args[0]);
                        } else if ("setAttribute".equals(name)) {
                            sessionAttributes.put((String) args[0], args[1]);
                            return null;
                        }
                        return null;
                    }
                }
        );

        // Mock HttpServletRequest
        requestProxy = (HttpServletRequest) Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class[]{HttpServletRequest.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String name = method.getName();
                        if ("getReader".equals(name)) {
                            return new BufferedReader(new StringReader(requestJson));
                        } else if ("getSession".equals(name)) {
                            return sessionProxy;
                        } else if ("getMethod".equals(name)) {
                            return "POST";
                        }
                        return null;
                    }
                }
        );

        // Mock HttpServletResponse
        responseProxy = (HttpServletResponse) Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class[]{HttpServletResponse.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String name = method.getName();
                        if ("getWriter".equals(name)) {
                            return new PrintWriter(responseWriter);
                        } else if ("setContentType".equals(name)) {
                            return null;
                        }
                        return null;
                    }
                }
        );
    }

    @Test
    public void testDoPostWithNoBooksFoundContext() throws Exception {
        // Thiết lập sách không tìm thấy
        mockService.mockBooksContext = "Không tìm thấy đầu sách nào phù hợp trực tiếp với từ khóa \"xyz\"";
        
        JsonObject reqObj = new JsonObject();
        reqObj.addProperty("message", "những quyển sách nào tốt cho tôi");
        requestJson = new Gson().toJson(reqObj);

        servlet.service(requestProxy, responseProxy);

        // Kiểm tra systemPrompt đã được thay đổi cho thủ thư thân thiện
        assertNotNull(mockService.lastSystemPrompt);
        assertTrue(mockService.lastSystemPrompt.contains("thủ thư thân thiện"));
        assertTrue(mockService.lastSystemPrompt.contains("hỏi mở lịch sự"));
        assertTrue(mockService.lastSystemPrompt.contains("Kỹ năng, Công nghệ, Kinh tế, Văn học"));
        assertFalse(mockService.lastSystemPrompt.contains("Chỉ đề xuất các sách có trong danh sách"));

        // Kiểm tra JSON response trả về thành công
        JsonObject resObj = new Gson().fromJson(responseWriter.toString(), JsonObject.class);
        assertEquals("success", resObj.get("status").getAsString());
        assertEquals("Mock AI response", resObj.get("response").getAsString());
    }

    @Test
    public void testDoPostWithValidBooksContext() throws Exception {
        // Thiết lập sách hợp lệ
        mockService.mockBooksContext = "Danh sách các sách liên quan có sẵn trong thư viện hiện tại:\n- ID: 1 | Tên sách: Lập trình Java | Tác giả: Nguyễn Nhật Ánh";
        
        JsonObject reqObj = new JsonObject();
        reqObj.addProperty("message", "sách Java");
        requestJson = new Gson().toJson(reqObj);

        servlet.service(requestProxy, responseProxy);

        // Kiểm tra systemPrompt giữ nguyên logic tìm kiếm sách cũ
        assertNotNull(mockService.lastSystemPrompt);
        assertTrue(mockService.lastSystemPrompt.contains("trợ lý ảo"));
        assertTrue(mockService.lastSystemPrompt.contains("Chỉ đề xuất các sách có trong danh sách dưới đây, tuyệt đối không tự bịa ra sách khác"));
        assertFalse(mockService.lastSystemPrompt.contains("thủ thư thân thiện"));

        // Kiểm tra JSON response trả về thành công
        JsonObject resObj = new Gson().fromJson(responseWriter.toString(), JsonObject.class);
        assertEquals("success", resObj.get("status").getAsString());
        assertEquals("Mock AI response", resObj.get("response").getAsString());
    }
}
