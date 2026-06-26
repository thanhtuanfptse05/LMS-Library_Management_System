package f8;

import model.BookSummaryDTO;
import service.AiRecommendationService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class AiRecommendationServiceTest {

    // Test parameters
    private final int testId;
    private final String scenario;
    private final List<Integer> candidatePoolIds;
    private final String apiResponse;
    private final Exception apiException;
    private final List<Integer> expectedIds;

    // Subclass of AiRecommendationService to intercept HTTP request
    private static class AiRecommendationServiceMock extends AiRecommendationService {
        private final String mockResponse;
        private final Exception mockException;

        public AiRecommendationServiceMock(String mockResponse, Exception mockException) {
            this.mockResponse = mockResponse;
            this.mockException = mockException;
        }

        @Override
        protected String sendPostRequest(String payload) throws Exception {
            if (mockException != null) {
                throw mockException;
            }
            return mockResponse;
        }
    }

    public AiRecommendationServiceTest(int testId, String scenario, List<Integer> candidatePoolIds, 
                                      String apiResponse, Exception apiException, List<Integer> expectedIds) {
        this.testId = testId;
        this.scenario = scenario;
        this.candidatePoolIds = candidatePoolIds;
        this.apiResponse = apiResponse;
        this.apiException = apiException;
        this.expectedIds = expectedIds;
    }

    @Parameters(name = "{index}: TestId={0}, Scenario={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // Setup base candidate pool IDs
        List<Integer> standardPool = Arrays.asList(10, 11, 12, 13, 14, 15, 16, 17, 18, 19);

        // Standard JSON response containing matching recommendations with Vietnamese reasons
        String validJson = createMockResponseJson("[\n" +
                "  {\"id\": 10, \"reason\": \"Phù hợp với bạn\"},\n" +
                "  {\"id\": 11, \"reason\": \"Nên đọc cuốn này\"}\n" +
                "]");

        // JSON response with markdown code block formatting (must be sanitized by parser)
        String markdownJson = createMockResponseJson("```json\n[\n" +
                "  {\"id\": 12, \"reason\": \"Phù hợp với bạn\"},\n" +
                "  {\"id\": 13, \"reason\": \"Nên đọc cuốn này\"}\n" +
                "]\n```");

        // JSON response with some hallucinated IDs (e.g. ID 99 which is not in candidate pool)
        String hallucinatedJson = createMockResponseJson("[\n" +
                "  {\"id\": 10, \"reason\": \"Hợp lý\"},\n" +
                "  {\"id\": 99, \"reason\": \"Ảo giác\"}\n" +
                "]");

        // Invalid JSON content
        String invalidFormatJson = createMockResponseJson("This is not json at all!");

        // 1-10: Success scenarios
        for (int i = 1; i <= 10; i++) {
            params.add(new Object[]{
                i, "success_valid_" + i, standardPool, validJson, null, Arrays.asList(10, 11)
            });
        }

        // 11-20: Markdown wrapping cleanup check
        for (int i = 11; i <= 20; i++) {
            params.add(new Object[]{
                i, "success_markdown_" + i, standardPool, markdownJson, null, Arrays.asList(12, 13)
            });
        }

        // 21-30: Anti-hallucination checks (must filter out ID 99)
        for (int i = 21; i <= 30; i++) {
            params.add(new Object[]{
                i, "hallucination_check_" + i, standardPool, hallucinatedJson, null, Collections.singletonList(10)
            });
        }

        // 31-35: API Errors / Exceptions (fallback triggered, returns null)
        Exception netException = new java.io.IOException("Connection timeout");
        for (int i = 31; i <= 35; i++) {
            params.add(new Object[]{
                i, "network_failure_" + i, standardPool, null, netException, null
            });
        }

        // 36-40: Invalid JSON formats (fallback triggered, returns null)
        for (int i = 36; i <= 40; i++) {
            params.add(new Object[]{
                i, "invalid_json_format_" + i, standardPool, invalidFormatJson, null, null
            });
        }

        return params;
    }

    private AiRecommendationService service;
    private Map<String, Map<String, Integer>> frequencyProfile;
    private List<BookSummaryDTO> recentHistory;
    private List<BookSummaryDTO> candidatePool;

    @Before
    public void setUp() {
        // Instantiate mock service
        service = new AiRecommendationServiceMock(apiResponse, apiException);

        // Build mock frequency profile
        frequencyProfile = new HashMap<>();
        Map<String, Integer> categories = new HashMap<>();
        categories.put("Science Fiction", 4);
        categories.put("Technology", 2);
        frequencyProfile.put("categories", categories);

        Map<String, Integer> tags = new HashMap<>();
        tags.put("AI", 3);
        frequencyProfile.put("tags", tags);

        // Build mock history
        recentHistory = new ArrayList<>();
        recentHistory.add(new BookSummaryDTO(1, "Sample Book 1", Collections.singletonList("Tech"), Collections.singletonList("AI")));

        // Build mock candidate pool from pool IDs
        candidatePool = new ArrayList<>();
        if (candidatePoolIds != null) {
            for (int id : candidatePoolIds) {
                candidatePool.add(new BookSummaryDTO(id, "Book " + id, Collections.singletonList("Science Fiction"), Collections.singletonList("AI")));
            }
        }
    }

    @Test
    public void testGetRecommendations() {
        if (candidatePoolIds == null || candidatePoolIds.isEmpty()) {
            // Null/empty pool input check
            List<Integer> recs = service.getRecommendations(frequencyProfile, recentHistory, Collections.emptyList());
            assertNull(recs);
        } else {
            List<Integer> recs = service.getRecommendations(frequencyProfile, recentHistory, candidatePool);
            if (expectedIds == null) {
                assertNull(recs);
            } else {
                assertNotNull(recs);
                assertEquals(expectedIds.size(), recs.size());
                for (int j = 0; j < expectedIds.size(); j++) {
                    assertEquals(expectedIds.get(j), recs.get(j));
                }
            }
        }
    }

    private static String createMockResponseJson(String textContent) {
        com.google.gson.JsonObject root = new com.google.gson.JsonObject();
        com.google.gson.JsonArray candidates = new com.google.gson.JsonArray();
        com.google.gson.JsonObject candidate = new com.google.gson.JsonObject();
        com.google.gson.JsonObject content = new com.google.gson.JsonObject();
        com.google.gson.JsonArray parts = new com.google.gson.JsonArray();
        com.google.gson.JsonObject part = new com.google.gson.JsonObject();
        
        part.addProperty("text", textContent);
        parts.add(part);
        content.add("parts", parts);
        candidate.add("content", content);
        candidates.add(candidate);
        root.add("candidates", candidates);
        
        return new com.google.gson.Gson().toJson(root);
    }
}
