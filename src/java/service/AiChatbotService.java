package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import config.AiConfig;
import dao.BookDAO;
import dao.SystemConfigurationsDAO;
import model.Book;
import model.ChatMessage;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AiChatbotService — Xử lý logic nghiệp vụ cho chatbot hỗ trợ AI (F14).
 * Bao gồm phân loại ý định, trích xuất ngữ cảnh RAG và giao tiếp với Google Gemini API.
 */
public class AiChatbotService {

    private static final Logger LOGGER = Logger.getLogger(AiChatbotService.class.getName());
    private static final int TIMEOUT_MS = 15000; // Timeout 15 giây theo quy định SPEC

    private final SystemConfigurationsDAO systemConfigDAO = new SystemConfigurationsDAO();
    private final BookDAO bookDAO = new BookDAO();

    private static volatile Map<String, String> cachedConfigMap;
    private static volatile String cachedRulesContext;
    private static volatile long cacheTimestamp = 0;
    private static final long CACHE_TTL_MS = 10 * 60 * 1000; // 10 phút



    /**
     * Phân loại mục đích câu hỏi của người dùng.
     * Sử dụng mô hình Gemini với số lượng token nhỏ để đưa ra nhãn phân loại: "Rules", "Books", hoặc "Irrelevant".
     */
    public String classifyIntent(String userMessage) {
        return classifyIntent(userMessage, null);
    }

    /**
     * Phân loại mục đích câu hỏi của người dùng kèm theo lịch sử trò chuyện để giữ ngữ cảnh.
     */
    public String classifyIntent(String userMessage, List<ChatMessage> chatHistory) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Irrelevant";
        }

        String m = userMessage.toLowerCase().trim();

        // Lớp 1: Keyword rõ ràng → return ngay (0ms)
        if (m.matches(".*(phạt|nội quy|quy định|giờ mở cửa|quá hạn|gia hạn|bao nhiêu tiền|mấy ngày|mấy cuốn|mấy quyển|tối đa|tôi đa|tối thiểu|bao nhiêu cuốn|bao nhiêu quyển|hạn mượn|mượn được|mượn tối đa|được mượn|mượn trong|đặt trước|giữ sách|trễ hạn|đền bù|làm mất|làm hỏng|mất sách|hỏng sách).*")) {
            return "Rules";
        }
        if (m.matches(".*(tìm sách|sách về|cuốn sách|tác giả|gợi ý sách|đề xuất sách|tìm cuốn).*")) {
            return "Books";
        }
        if (m.matches(".*(xin chào|hello|bạn là ai|cảm ơn|tạm biệt|bye).*")) {
            return "Irrelevant";
        }

        // Lớp 2: Mơ hồ → gọi Gemini classify kèm theo ngữ cảnh lịch sử
        return classifyIntentByAI(userMessage, chatHistory);
    }

    /**
     * Gọi Gemini API để phân loại ý định khi câu hỏi mơ hồ.
     */
    private String classifyIntentByAI(String userMessage, List<ChatMessage> chatHistory) {
        String lowerMsg = userMessage.toLowerCase().trim();
        
        StringBuilder historyBuilder = new StringBuilder();
        if (chatHistory != null && chatHistory.size() > 1) {
            historyBuilder.append("Lịch sử cuộc trò chuyện gần đây để tham khảo ngữ cảnh:\n");
            // Lấy tối đa 4 tin nhắn gần nhất TRƯỚC tin nhắn hiện tại
            int startIdx = Math.max(0, chatHistory.size() - 5);
            for (int i = startIdx; i < chatHistory.size() - 1; i++) {
                ChatMessage msg = chatHistory.get(i);
                String roleName = "user".equalsIgnoreCase(msg.getRole()) ? "Người dùng" : "Trợ lý";
                historyBuilder.append("- ").append(roleName).append(": ").append(msg.getContent()).append("\n");
            }
            historyBuilder.append("\n");
        }

        String systemPrompt = "Bạn là bộ phân loại ý định (Intent Classifier) cho trợ lý ảo thư viện.\n"
                + "Hãy phân loại câu hỏi hiện tại của người dùng vào một trong 3 nhóm duy nhất:\n"
                + "- Rules: Nếu hỏi về mức phạt (tiền phạt, trễ hạn, quá hạn), nội quy, giờ mở cửa, chính sách mượn/trả/gia hạn sách hoặc các câu hỏi nối tiếp có liên quan đến chính sách/nội quy.\n"
                + "- Books: CHỈ KHI người dùng muốn TÌM SÁCH để đọc, tra cứu sách, tìm tác giả, hoặc xin gợi ý sách.\n"
                + "- Irrelevant: Nếu là chào hỏi xã giao, đùa giỡn hoặc các câu hỏi linh tinh không liên quan đến thư viện/sách.\n\n"
                + "Quy tắc: BẮT BUỘC chỉ trả về đúng 1 từ tiếng Anh duy nhất: 'Rules', 'Books', hoặc 'Irrelevant'. "
                + "Không trả về thêm bất kỳ từ nào khác.";

        try {
            // Đóng gói JSON Payload cho cuộc gọi Gemini ngắn hạn
            JsonObject textPart = new JsonObject();
            String promptText = historyBuilder.toString() + "Câu hỏi hiện tại cần phân loại: \"" + userMessage + "\"";
            textPart.addProperty("text", promptText);

            JsonArray parts = new JsonArray();
            parts.add(textPart);

            JsonObject content = new JsonObject();
            content.add("parts", parts);

            JsonArray contents = new JsonArray();
            contents.add(content);

            JsonObject systemInstruction = new JsonObject();
            JsonArray systemParts = new JsonArray();
            JsonObject systemText = new JsonObject();
            systemText.addProperty("text", systemPrompt);
            systemParts.add(systemText);
            systemInstruction.add("parts", systemParts);

            JsonObject root = new JsonObject();
            root.add("systemInstruction", systemInstruction);
            root.add("contents", contents);

            JsonObject generationConfig = new JsonObject();
            generationConfig.addProperty("maxOutputTokens", 10);
            generationConfig.addProperty("temperature", 0.1);

            root.add("generationConfig", generationConfig);

            String jsonPayload = new Gson().toJson(root);
            String response = sendPostRequest(jsonPayload);

            String label = parseTextResponse(response).trim();
            LOGGER.log(Level.INFO, "[AI-SVC] Intent classified for \"{0}\" -> {1}", new Object[]{userMessage, label});

            if (label.contains("Rules")) return "Rules";
            if (label.contains("Books")) return "Books";
            return "Irrelevant";
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[AI-SVC] Lỗi phân loại intent bằng AI, fallback dựa trên từ khóa: " + e.getMessage());
            // Fallback dựa trên từ khoá tiếng Việt thông thường
            if (lowerMsg.matches(".*(phạt|nội quy|quy định|giờ mở cửa|quá hạn|gia hạn|bao nhiêu tiền|mấy ngày|mấy cuốn|mấy quyển|tối đa|tôi đa|tối thiểu|bao nhiêu cuốn|bao nhiêu quyển|hạn mượn|mượn được|mượn tối đa|được mượn|mượn trong|đặt trước|giữ sách|trễ hạn|đền bù|làm mất|làm hỏng|mất sách|hỏng sách).*")) {
                return "Rules";
            }
            if (lowerMsg.contains("sách") || lowerMsg.contains("tác giả") || lowerMsg.contains("cuốn") || lowerMsg.contains("truyện") || lowerMsg.contains("tìm") || lowerMsg.contains("mượn") || lowerMsg.contains("trả")) {
                return "Books";
            }
            return "Irrelevant";
        }
    }

    /**
     * Truy cập map cấu hình từ cache (hoặc tải từ DB nếu hết hạn).
     */
    private Map<String, String> retrieveRulesConfigMap() {
        long now = System.currentTimeMillis();
        if (cachedConfigMap != null && (now - cacheTimestamp) < CACHE_TTL_MS) {
            return cachedConfigMap;
        }
        
        synchronized (AiChatbotService.class) {
            // Double-checked locking
            if (cachedConfigMap != null && (now - cacheTimestamp) < CACHE_TTL_MS) {
                return cachedConfigMap;
            }
            
            Map<String, String> configs = systemConfigDAO.getLibraryConfigurations();
            if (!configs.isEmpty()) {
                StringBuilder sb = new StringBuilder();
                sb.append("Dưới đây là các chính sách và cấu hình vận hành thư viện chính thức:\n");
                for (Map.Entry<String, String> entry : configs.entrySet()) {
                    sb.append("- ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
                }
                cachedRulesContext = sb.toString();
                cachedConfigMap = configs;
                cacheTimestamp = now;
            } else if (cachedConfigMap == null) {
                cachedRulesContext = "Không tìm thấy cấu hình quy định cụ thể trong cơ sở dữ liệu. Thư viện mở cửa từ 8:00 đến 20:00 các ngày từ thứ 2 đến thứ 7.";
                cachedConfigMap = configs;
                cacheTimestamp = now;
            }
        }
        return cachedConfigMap;
    }

    /**
     * Truy xuất các quy định, nội quy của thư viện từ CSDL để nhúng vào Prompt.
     */
    public String retrieveRulesContext() {
        retrieveRulesConfigMap(); // Đảm bảo cache được làm mới nếu cần
        return cachedRulesContext != null ? cachedRulesContext : "Không tìm thấy cấu hình quy định cụ thể.";
    }



    /**
     * Thực hiện RAG tìm kiếm sách từ CSDL dựa trên câu hỏi của người dùng.
     */
    public String retrieveBooksContext(String userMessage) {
        String keyword = extractSearchKeyword(userMessage);
        List<Book> books = bookDAO.searchBooks(keyword, 0, null, true, 1, 10);
        if (books.isEmpty()) {
            return "Không tìm thấy đầu sách nào phù hợp trực tiếp với từ khóa \"" + keyword + "\" trong cơ sở dữ liệu thư viện.";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("Danh sách các sách liên quan có sẵn trong thư viện hiện tại:\n");
        for (Book b : books) {
            sb.append("- ID: ").append(b.getBookId())
              .append(" | Tên sách: ").append(b.getTitle())
              .append(" | Tác giả: ").append(b.getAuthor() != null ? b.getAuthor() : "Chưa rõ")
              .append(" | Nhà xuất bản: ").append(b.getPublisher() != null ? b.getPublisher() : "Chưa rõ")
              .append(" | Số lượng khả dụng: ").append(b.getAvailableQuantity())
              .append(" | Trạng thái: ").append(b.getStatus()).append("\n");
        }
        return sb.toString();
    }

    /**
     * Truy xuất danh sách sách gợi ý cá nhân hóa sử dụng tính năng F8.
     * Nếu không đủ lịch sử mượn hoặc chưa đăng nhập, sử dụng sách thịnh hành (Trending) làm fallback.
     */
    public String retrievePersonalizedBooksContext(Integer userId) {
        List<Book> recommendedBooks = new java.util.ArrayList<>();
        java.util.Map<Integer, String> recommendedReasons = new java.util.HashMap<>();
        if (userId != null) {
            try {
                int borrowCount = new dao.BorrowRecordDAO().countUserBorrowHistory(userId);
                if (borrowCount >= 3) {
                    java.util.Map<String, java.util.Map<String, Integer>> freqProfile = bookDAO.getUserTagCategoryFrequency(userId);
                    List<model.BookSummaryDTO> recentHistory = bookDAO.getRecentBorrowedSummary(userId, 3);
                    List<model.BookSummaryDTO> candidatePool = bookDAO.getCandidatePoolWithTagsAndCategories(userId, 30);
                    
                    AiRecommendationService recommendationService = new AiRecommendationService();
                    java.util.Map<Integer, String> aiRecommendations = recommendationService.getRecommendationsWithReasons(freqProfile, recentHistory, candidatePool);
                    
                    if (aiRecommendations != null && !aiRecommendations.isEmpty()) {
                        for (java.util.Map.Entry<Integer, String> entry : aiRecommendations.entrySet()) {
                            int id = entry.getKey();
                            Book book = bookDAO.getBookById(id);
                            if (book != null) {
                                recommendedBooks.add(book);
                                recommendedReasons.put(id, entry.getValue());
                            }
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "[AI-SVC] Lỗi lấy gợi ý sách cá nhân hóa F8: " + e.getMessage(), e);
            }
        }

        // Fallback: Sách thịnh hành (Top Trending)
        boolean isAiPowered = !recommendedReasons.isEmpty();
        if (recommendedBooks.isEmpty()) {
            try {
                recommendedBooks = bookDAO.getTopTrendingBooks(5);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "[AI-SVC] Lỗi lấy sách thịnh hành: " + e.getMessage(), e);
            }
        }

        StringBuilder sb = new StringBuilder();
        if (isAiPowered) {
            sb.append("Danh sách các sách gợi ý cá nhân hóa dành riêng cho bạn (kèm lý do gợi ý):\n");
            for (Book b : recommendedBooks) {
                sb.append("- ID: ").append(b.getBookId())
                  .append(" | Tên sách: ").append(b.getTitle())
                  .append(" | Tác giả: ").append(b.getAuthor() != null ? b.getAuthor() : "Chưa rõ")
                  .append(" | Nhà xuất bản: ").append(b.getPublisher() != null ? b.getPublisher() : "Chưa rõ")
                  .append(" | Số lượng khả dụng: ").append(b.getAvailableQuantity())
                  .append(" | Trạng thái: ").append(b.getStatus())
                  .append(" | Lý do gợi ý: ").append(recommendedReasons.getOrDefault(b.getBookId(), "Cuốn sách phù hợp với sở thích của bạn."))
                  .append("\n");
            }
        } else {
            sb.append("Danh sách các sách phổ biến, thịnh hành tại thư viện:\n");
            for (Book b : recommendedBooks) {
                sb.append("- ID: ").append(b.getBookId())
                  .append(" | Tên sách: ").append(b.getTitle())
                  .append(" | Tác giả: ").append(b.getAuthor() != null ? b.getAuthor() : "Chưa rõ")
                  .append(" | Nhà xuất bản: ").append(b.getPublisher() != null ? b.getPublisher() : "Chưa rõ")
                  .append(" | Số lượng khả dụng: ").append(b.getAvailableQuantity())
                  .append(" | Trạng thái: ").append(b.getStatus()).append("\n");
            }
        }
        return sb.toString();
    }


    /**
     * Thực hiện cuộc gọi hội thoại nhiều lượt sang Gemini API.
     */
    public String callGeminiChat(List<ChatMessage> history, String systemInstructionText) {
        try {
            JsonObject root = new JsonObject();

            // Set System Instruction
            JsonObject systemInstruction = new JsonObject();
            JsonArray systemParts = new JsonArray();
            JsonObject systemText = new JsonObject();
            systemText.addProperty("text", systemInstructionText);
            systemParts.add(systemText);
            systemInstruction.add("parts", systemParts);
            root.add("systemInstruction", systemInstruction);

            // Set Contents (Lịch sử hội thoại)
            JsonArray contents = new JsonArray();
            for (ChatMessage msg : history) {
                JsonObject contentObj = new JsonObject();
                // Map role sang định dạng Gemini ('user' và 'model')
                contentObj.addProperty("role", "user".equals(msg.getRole()) ? "user" : "model");
                
                JsonArray parts = new JsonArray();
                JsonObject textObj = new JsonObject();
                textObj.addProperty("text", msg.getContent());
                parts.add(textObj);
                contentObj.add("parts", parts);
                
                contents.add(contentObj);
            }
            root.add("contents", contents);

            // Generation config để tăng tính chính xác và loại bỏ thinking latency
            JsonObject generationConfig = new JsonObject();
            generationConfig.addProperty("temperature", 0.7);
            

            root.add("generationConfig", generationConfig);

            String jsonPayload = new Gson().toJson(root);
            String rawResponse = sendPostRequest(jsonPayload);
            return parseTextResponse(rawResponse);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[AI-SVC] Lỗi kết nối hoặc xử lý API AI: " + e.getMessage(), e);
            return null; // Kích hoạt fallback
        }
    }

    /**
     * Tách từ khóa tìm kiếm chính từ câu hỏi tự nhiên của người dùng.
     */
    private String extractSearchKeyword(String message) {
        String clean = message.toLowerCase()
                .replaceAll("tìm sách", "")
                .replaceAll("tìm kiếm", "")
                .replaceAll("tìm cuốn", "")
                .replaceAll("đọc cuốn", "")
                .replaceAll("có sách", "")
                .replaceAll("sách về", "")
                .replaceAll("sách của", "")
                .replaceAll("tác giả", "")
                .replaceAll("thể loại", "")
                .replaceAll("cho tôi hỏi", "")
                .replaceAll("nào không", "")
                .replaceAll("không", "")
                .replaceAll("nhỉ", "")
                .replaceAll("[?.,!]", "")
                .trim();
        return clean.isEmpty() ? message : clean;
    }

    /**
     * Gửi yêu cầu HTTP POST sang Gemini API.
     */
    private String sendPostRequest(String payload) throws Exception {
        URL url = new URL(AiConfig.GEMINI_API_URL + AiConfig.getGeminiChatbotApiKey());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setConnectTimeout(TIMEOUT_MS);
        conn.setReadTimeout(TIMEOUT_MS);
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int statusCode = conn.getResponseCode();
        if (statusCode != HttpURLConnection.HTTP_OK) {
            StringBuilder errorDetails = new StringBuilder();
            if (conn.getErrorStream() != null) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        errorDetails.append(line.trim());
                    }
                } catch (Exception ignored) {}
            }
            throw new Exception("Gemini API rejected request. Status code: " + statusCode +
                    (errorDetails.length() > 0 ? ", Details: " + errorDetails : ""));
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
        }
        return response.toString();
    }

    /**
     * Trích xuất văn bản trả lời từ JSON Response của Gemini API.
     */
    private String parseTextResponse(String jsonResponse) throws Exception {
        JsonObject root = JsonParser.parseString(jsonResponse).getAsJsonObject();
        JsonArray candidates = root.getAsJsonArray("candidates");
        if (candidates == null || candidates.size() == 0) {
            throw new Exception("Gemini did not return any candidate response.");
        }

        JsonObject content = candidates.get(0).getAsJsonObject().getAsJsonObject("content");
        JsonArray parts = content.getAsJsonArray("parts");
        return parts.get(0).getAsJsonObject().get("text").getAsString();
    }

    /**
     * Định dạng ngữ cảnh sách thô thành Markdown đẹp.
     */
    public String formatBooksAsMarkdown(String query, String rawContext) {
        StringBuilder sb = new StringBuilder();
        sb.append("📚 **Kết quả tìm kiếm sách**\n\n");
        String[] lines = rawContext.split("\n");
        int count = 0;
        for (String line : lines) {
            if (line.startsWith("- ID:")) {
                count++;
                String title = extractField(line, "Tên sách:");
                String author = extractField(line, "Tác giả:");
                String available = extractField(line, "Số lượng khả dụng:");
                sb.append("**").append(count).append(". ").append(title).append("**\n");
                sb.append("   Tác giả: ").append(author);
                sb.append(" · Khả dụng: ").append(available).append(" cuốn\n\n");
            }
        }
        if (count > 0) {
            sb.append("*Bạn có thể đến thư viện để mượn trực tiếp các cuốn sách trên.*");
        } else {
            sb.append("Không tìm thấy sách nào phù hợp.");
        }
        return sb.toString();
    }

    private String extractField(String line, String fieldName) {
        int start = line.indexOf(fieldName);
        if (start == -1) return "Chưa rõ";
        start += fieldName.length();
        int end = line.indexOf(" |", start);
        if (end == -1) {
            end = line.length();
        }
        return line.substring(start, end).trim();
    }
}
