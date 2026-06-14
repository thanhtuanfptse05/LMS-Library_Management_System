package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import config.AiConfig;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AiRecommendationService — Giao tiếp với Google Gemini API để gợi ý sách.
 * 
 * Luồng hoạt động:
 * 1. Nhận Candidate Pool (Danh sách ID hợp lệ).
 * 2. Đóng gói Prompt gửi qua API.
 * 3. Phân tích kết quả JSON trả về.
 * 4. Kiểm duyệt Anti-Hallucination (Chống ảo giác).
 * 5. Trả về mảng an toàn, hoặc trả về NULL nếu có sự cố (kích hoạt Fallback).
 */
public class AiRecommendationService {

    private static final Logger LOGGER = Logger.getLogger(AiRecommendationService.class.getName());
    private static final int TIMEOUT_MS = 30000; // 30 giây (chống kẹt server nếu đứt cáp quang hoặc AI suy nghĩ lâu)

    /**
     * Gọi Gemini API lấy danh sách ID sách với ngữ cảnh phong phú.
     * 
     * @param frequencyProfile Tần suất category và tag từ lịch sử mượn
     * @param recentHistory 3 cuốn sách mượn gần nhất
     * @param candidatePool 30 cuốn sách chưa mượn ứng viên
     * @return Danh sách ID AI khuyên dùng, hoặc Null nếu AI lỗi
     */
    public List<Integer> getRecommendations(
            java.util.Map<String, java.util.Map<String, Integer>> frequencyProfile,
            List<model.BookSummaryDTO> recentHistory,
            List<model.BookSummaryDTO> candidatePool) {
            
        if (candidatePool == null || candidatePool.isEmpty()) {
            LOGGER.log(Level.WARNING, "[AI-SVC] CandidatePool is empty or null, skipping AI call.");
            return null;
        }

        LOGGER.log(Level.FINE, "[AI-SVC] Calling Gemini API. CandidatePool size={0}, API Key prefix={1}",
                new Object[] { candidatePool.size(),
                        AiConfig.GEMINI_API_KEY.length() > 8
                                ? AiConfig.GEMINI_API_KEY.substring(0, 8) + "..."
                                : AiConfig.GEMINI_API_KEY });

        String prompt = buildPrompt(frequencyProfile, recentHistory, candidatePool);
        String jsonPayload = buildJsonPayload(prompt);

        try {
            String jsonResponse = sendPostRequest(jsonPayload);
            LOGGER.log(Level.FINE, "[AI-SVC] Gemini API returned successfully ({0} characters).", jsonResponse.length());
            List<Integer> aiRecommendedIds = parseResponse(jsonResponse);
            return filterHallucination(aiRecommendedIds, candidatePool);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[AI-SVC] AI error occurred (network/timeout/invalid JSON), triggering fallback: {0}", e.getMessage());
            return null;
        }
    }

    /**
     * Tạo câu lệnh yêu cầu AI phong phú (3 phần).
     */
    private String buildPrompt(
            java.util.Map<String, java.util.Map<String, Integer>> frequencyProfile,
            List<model.BookSummaryDTO> recentHistory,
            List<model.BookSummaryDTO> candidatePool) {
            
        StringBuilder prompt = new StringBuilder();
        prompt.append("You are an expert AI librarian.\n\n");
        
        // Phần 1: Profile user
        prompt.append("=== USER INTEREST PROFILE (From full borrow history) ===\n");
        java.util.Map<String, Integer> catFreq = frequencyProfile.get("categories");
        if (catFreq != null && !catFreq.isEmpty()) {
            prompt.append("Category frequency: ").append(formatFrequencyMap(catFreq, 5)).append("\n");
        }
        java.util.Map<String, Integer> tagFreq = frequencyProfile.get("tags");
        if (tagFreq != null && !tagFreq.isEmpty()) {
            prompt.append("Tag frequency: ").append(formatFrequencyMap(tagFreq, 5)).append("\n");
        }
        prompt.append("\n");
        
        // Phần 2: Sách mượn gần nhất
        prompt.append("=== RECENTLY BORROWED (Last 3 books) ===\n");
        if (recentHistory != null && !recentHistory.isEmpty()) {
            for (model.BookSummaryDTO dto : recentHistory) {
                prompt.append("- ").append(dto.toString()).append("\n");
            }
        } else {
            prompt.append("- None\n");
        }
        prompt.append("\n");
        
        // Phần 3: Candidate pool
        prompt.append("=== CANDIDATE BOOKS (Not yet borrowed, sorted by popularity) ===\n");
        for (model.BookSummaryDTO dto : candidatePool) {
            prompt.append(dto.toString()).append("\n");
        }
        prompt.append("\n");
        
        // Instruction cuối
        prompt.append("=== INSTRUCTIONS ===\n");
        prompt.append("Based on the user's interest profile and recently borrowed books above, ");
        prompt.append("pick EXACTLY 5 diverse book IDs from the CANDIDATE BOOKS list that the user would most likely want to read next.\n");
        prompt.append("CRITICAL INSTRUCTION: You MUST return ONLY a JSON array of integers like [1, 2, 3]. ");
        prompt.append("Do NOT return any markdown formatting (no ```json), no code blocks, no text explanations. Just the raw array.");
        
        return prompt.toString();
    }
    
    private String formatFrequencyMap(java.util.Map<String, Integer> map, int limit) {
        return map.entrySet().stream()
                .limit(limit)
                .map(e -> e.getKey() + "(" + e.getValue() + ")")
                .collect(java.util.stream.Collectors.joining(", "));
    }

    /**
     * Gói câu lệnh vào định dạng chuẩn của Gemini API.
     */
    private String buildJsonPayload(String prompt) {
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonArray parts = new JsonArray();
        parts.add(textPart);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject root = new JsonObject();
        root.add("contents", contents);

        // Tắt tính năng Thinking của Gemini 3.5 để giảm thời gian phản hồi từ ~20s xuống ~1-2s
        JsonObject thinkingConfig = new JsonObject();
        thinkingConfig.addProperty("thinkingBudget", 0);

        JsonObject generationConfig = new JsonObject();
        generationConfig.add("thinkingConfig", thinkingConfig);

        root.add("generationConfig", generationConfig);

        return new Gson().toJson(root);
    }

    /**
     * Thực hiện gửi HTTP POST lên Google.
     */
    private String sendPostRequest(String payload) throws Exception {
        URL url = new URL(AiConfig.GEMINI_API_URL + AiConfig.GEMINI_API_KEY);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setConnectTimeout(TIMEOUT_MS);
        conn.setReadTimeout(TIMEOUT_MS);
        conn.setDoOutput(true);

        // Bắn dữ liệu đi
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Kiểm tra phản hồi
        int statusCode = conn.getResponseCode();
        if (statusCode != HttpURLConnection.HTTP_OK) {
            StringBuilder errorDetails = new StringBuilder();
            if (conn.getErrorStream() != null) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        errorDetails.append(line.trim());
                    }
                } catch (Exception ignored) {
                }
            }
            throw new Exception("Gemini API rejected request. Status code: " + statusCode +
                    (errorDetails.length() > 0 ? ", Details: " + errorDetails.toString() : ""));
        }

        // Đọc dữ liệu trả về
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }
        return response.toString();
    }

    /**
     * Phân tích cục JSON khổng lồ trả về để lấy đoạn Text do AI trả lời.
     */
    private List<Integer> parseResponse(String jsonResponse) throws Exception {
        JsonObject root = JsonParser.parseString(jsonResponse).getAsJsonObject();
        JsonArray candidates = root.getAsJsonArray("candidates");
        if (candidates == null || candidates.size() == 0) {
            throw new Exception("Gemini did not return any candidate response.");
        }

        JsonObject content = candidates.get(0).getAsJsonObject().getAsJsonObject("content");
        JsonArray parts = content.getAsJsonArray("parts");
        String textResponse = parts.get(0).getAsJsonObject().get("text").getAsString().trim();

        // Dọn dẹp phòng trường hợp AI vẫn ngoan cố xuất ra markdown ```json
        textResponse = textResponse.replace("```json", "").replace("```", "").trim();

        // Parse mảng JSON [1, 2, 3]
        JsonArray idsArray = JsonParser.parseString(textResponse).getAsJsonArray();
        List<Integer> list = new ArrayList<>();
        for (JsonElement element : idsArray) {
            list.add(element.getAsInt());
        }
        return list;
    }

    /**
     * FR-46: Anti-Hallucination
     * Gạch bỏ bất kỳ ID nào AI gửi về mà không nằm trong kho ứng viên.
     */
    private List<Integer> filterHallucination(List<Integer> aiIds, List<model.BookSummaryDTO> pool) {
        List<Integer> safeList = new ArrayList<>();
        java.util.Set<Integer> validIds = pool.stream().map(model.BookSummaryDTO::getBookId).collect(java.util.stream.Collectors.toSet());
        
        for (Integer id : aiIds) {
            if (validIds.contains(id)) {
                safeList.add(id);
            } else {
                LOGGER.warning("ANTI-HALLUCINATION: Blocked AI-hallucinated book ID = " + id);
            }
        }
        return safeList;
    }
}
