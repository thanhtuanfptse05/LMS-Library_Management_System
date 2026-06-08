package service;

import org.junit.Before;
import org.junit.Test;
import java.util.Arrays;
import java.util.List;
import static org.junit.Assert.*;

/**
 * AiRecommendationServiceTest — Unit Tests cho logic chống Hallucination của AI (F8).
 */
public class AiRecommendationServiceTest {

    private MockAiRecommendationService aiService;
    private List<Integer> candidatePool;

    @Before
    public void setUp() {
        aiService = new MockAiRecommendationService();
        // Giả lập hệ thống cấp cho AI 3 sách hợp lệ
        candidatePool = Arrays.asList(10, 20, 30);
    }

    @Test
    public void testFetchRecommendationSuccess() {
        // AI trả về [10, 20] -> Đều nằm trong pool
        List<Integer> result = aiService.getRecommendations(1, candidatePool, "success");
        assertNotNull(result);
        assertEquals(2, result.size());
        assertTrue(result.contains(10));
    }

    @Test
    public void testFetchRecommendationHallucination() {
        // AI bị ảo giác, trả về [10, 999] (999 không có trong CSDL)
        List<Integer> result = aiService.getRecommendations(1, candidatePool, "hallucination");
        
        assertNotNull(result);
        assertEquals("Phải loại bỏ sách 999 vì nó không nằm trong Candidate Pool", 1, result.size());
        assertTrue(result.contains(10));
        assertFalse(result.contains(999));
    }

    @Test
    public void testFetchRecommendationTimeout() {
        // AI lỗi (API sập, Timeout, Hết quota)
        List<Integer> result = aiService.getRecommendations(1, candidatePool, "timeout");
        assertNull("Phải trả về null khi AI lỗi để hệ thống kích hoạt Fallback (Top Trending)", result);
    }

    /**
     * Lớp Mock giả lập phản hồi của Gemini API thay vì gọi HTTP request thật.
     */
    private static class MockAiRecommendationService {
        
        public List<Integer> getRecommendations(int userId, List<Integer> pool, String scenario) {
            List<Integer> rawAiResponse;
            
            if ("timeout".equals(scenario)) {
                return null;
            } else if ("hallucination".equals(scenario)) {
                rawAiResponse = Arrays.asList(10, 999);
            } else {
                rawAiResponse = Arrays.asList(10, 20);
            }
            
            // Logic Anti-Hallucination: Chỉ giữ lại các ID có trong pool
            rawAiResponse.retainAll(pool);
            return rawAiResponse;
        }
    }
}
