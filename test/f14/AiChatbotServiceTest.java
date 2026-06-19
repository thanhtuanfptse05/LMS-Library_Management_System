package f14;

import org.junit.Before;
import org.junit.Test;
import service.AiChatbotService;
import static org.junit.Assert.*;

/**
 * AiChatbotServiceTest — Unit Tests cho AiChatbotService (F14).
 * Kiểm tra các logic phân loại ý định, trích xuất từ khoá tìm kiếm, và cấu trúc context.
 */
public class AiChatbotServiceTest {

    private AiChatbotService chatbotService;

    @Before
    public void setUp() {
        chatbotService = new AiChatbotService();
    }

    @Test
    public void testClassifyIntentByKeywords() {
        // Kiểm tra phân loại ý định dựa trên các câu chào hỏi / linh tinh (Irrelevant)
        assertEquals("Irrelevant", chatbotService.classifyIntent("xin chào chatbot"));
        assertEquals("Irrelevant", chatbotService.classifyIntent("hello trợ lý ảo"));
        assertEquals("Irrelevant", chatbotService.classifyIntent("thời tiết hôm nay thế nào"));
        
        // Kiểm tra phân loại ý định dựa trên từ khoá Fallback
        assertEquals("Books", chatbotService.classifyIntent("tìm cho tôi cuốn sách Java"));
        assertEquals("Books", chatbotService.classifyIntent("sách của tác giả Nguyễn Nhật Ánh"));
        assertEquals("Rules", chatbotService.classifyIntent("quy định phạt mượn trả thế nào"));
        assertEquals("Rules", chatbotService.classifyIntent("mấy giờ thư viện đóng cửa"));
    }

    @Test
    public void testRetrieveRulesContext() {
        // Kiểm tra hàm lấy nội quy hoạt động bình thường và không bị lỗi NullPointerException
        String context = chatbotService.retrieveRulesContext();
        assertNotNull(context);
        assertFalse(context.isEmpty());
    }

    @Test
    public void testRetrieveBooksContextWithEmptyKeyword() {
        // Kiểm tra việc tìm sách với từ khoá trống
        String context = chatbotService.retrieveBooksContext("tìm sách");
        assertNotNull(context);
    }
}
