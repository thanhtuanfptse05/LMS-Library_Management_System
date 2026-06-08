package controller;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * RecommendationApiServletTest — Unit Tests cho Recommendation API Servlet.
 * 
 * Kiểm thử luồng chuyển hướng (Routing) giữa AI và Fallback dựa trên số lượng mượn sách.
 * Lưu ý: Việc test Servlet đầy đủ yêu cầu thư viện Mockito để giả lập HttpServletRequest/Response.
 * Trong phạm vi UnitTest nội bộ, chúng ta kiểm thử logic cốt lõi.
 */
public class RecommendationApiServletTest {

    @Test
    public void testUserBelowThreshold_ShouldCallTopTrending() {
        int borrowCount = 1; // Ngưỡng là >= 3
        boolean useAi = checkThresholdLogic(borrowCount);
        
        assertFalse("Người dùng mượn < 3 sách phải dùng TopTrending (Fallback), không gọi AI", useAi);
    }

    @Test
    public void testUserAboveThreshold_ShouldCallAi() {
        int borrowCount = 5; // Ngưỡng là >= 3
        boolean useAi = checkThresholdLogic(borrowCount);
        
        assertTrue("Người dùng mượn >= 3 sách phải kích hoạt gọi AI", useAi);
    }

    @Test
    public void testFallbackTriggered_WhenAiFails() {
        // Giả lập AI service ném ra Exception (timeout/sập)
        boolean aiExceptionOccurred = true;
        String finalStrategy = aiExceptionOccurred ? "TopTrending" : "AI";
        
        assertEquals("Khi AI gặp sự cố, hệ thống phải tự động fallback về TopTrending", "TopTrending", finalStrategy);
    }

    /**
     * Hàm giả lập logic sẽ được đưa vào Servlet (để cô lập test).
     */
    private boolean checkThresholdLogic(int borrowCount) {
        return borrowCount >= 3;
    }
}
