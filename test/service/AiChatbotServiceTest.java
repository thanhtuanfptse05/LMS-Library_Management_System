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
