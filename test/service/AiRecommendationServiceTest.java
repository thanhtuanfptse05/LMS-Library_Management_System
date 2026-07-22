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
