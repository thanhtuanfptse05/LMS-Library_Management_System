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
    private static final int TIMEOUT_MS = 5000; // 5 giây (chống kẹt server nếu đứt cáp quang)
    
    /**
     * Gọi Gemini API lấy danh sách ID sách.
     * @param candidatePool Danh sách các ID có thật trong hệ thống
     * @return Danh sách ID AI khuyên dùng, hoặc Null nếu AI lỗi
     */
    public List<Integer> getRecommendations(List<Integer> candidatePool) {
        if (candidatePool == null || candidatePool.isEmpty()) {
            return null;
        }
        
        String prompt = buildPrompt(candidatePool);
        String jsonPayload = buildJsonPayload(prompt);
        
        try {
            String jsonResponse = sendPostRequest(jsonPayload);
            List<Integer> aiRecommendedIds = parseResponse(jsonResponse);
            return filterHallucination(aiRecommendedIds, candidatePool);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "AI Gặp sự cố (Mất mạng/Quá tải/Sai JSON), kích hoạt Fallback. Lỗi: " + e.getMessage());
            return null; 
        }
    }

    /**
     * Tạo câu lệnh yêu cầu AI.
     */
    private String buildPrompt(List<Integer> pool) {
        return "You are an AI librarian. I have a list of valid book IDs: " + pool.toString() + 
               ". Based on standard library patterns, pick EXACTLY 5 diverse book IDs from this list. " +
               "CRITICAL INSTRUCTION: You MUST return ONLY a JSON array of integers like [1, 2, 3]. " +
               "Do NOT return any markdown formatting (no ```json), no code blocks, no text explanations. Just the raw array.";
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
            throw new Exception("Gemini API từ chối. Status code: " + statusCode);
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
            throw new Exception("Gemini không trả về câu trả lời nào.");
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
    private List<Integer> filterHallucination(List<Integer> aiIds, List<Integer> pool) {
        List<Integer> safeList = new ArrayList<>();
        for (Integer id : aiIds) {
            if (pool.contains(id)) {
                safeList.add(id);
            } else {
                LOGGER.warning("ANTI-HALLUCINATION: Đã chặn AI vì bịa ra ID sách không tồn tại = " + id);
            }
        }
        return safeList;
    }
}
