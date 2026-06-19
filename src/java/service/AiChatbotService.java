package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import config.AiConfig;
import dao.BookDAO;
import dao.SystemConfigurationsDAO;
import model.Book;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AiChatbotService — Xử lý logic nghiệp vụ cho chatbot hỗ trợ AI (F14).
 * Chứa bộ phân loại ý định và các phương thức trích xuất ngữ cảnh RAG (Nội quy/Sách).
 */
public class AiChatbotService {

    private static final Logger LOGGER = Logger.getLogger(AiChatbotService.class.getName());
    private static final int TIMEOUT_MS = 15000;

    private final SystemConfigurationsDAO systemConfigDAO = new SystemConfigurationsDAO();
    private final BookDAO bookDAO = new BookDAO();

    /**
     * Phân loại mục đích câu hỏi của người dùng.
     */
    public String classifyIntent(String userMessage) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Irrelevant";
        }

        String lowerMsg = userMessage.toLowerCase().trim();
        if (lowerMsg.matches(".*(xin chào|hi|hello|bạn là ai|chatbot là gì|khỏe không|tạm biệt|bye|cảm ơn|thanks).*")) {
            if (!lowerMsg.contains("sách") && !lowerMsg.contains("quy định") && !lowerMsg.contains("mượn") && !lowerMsg.contains("trả")) {
                return "Irrelevant";
            }
        }

        String systemPrompt = "Bạn là bộ phân loại ý định (Intent Classifier) cho trợ lý ảo thư viện.\n"
                + "Hãy phân loại câu hỏi của người dùng vào một trong 3 nhóm duy nhất:\n"
                + "- Rules: Nếu hỏi về nội quy, giờ mở cửa, quy tắc phạt, mượn trả, gia hạn sách.\n"
                + "- Books: Nếu hỏi về tìm sách, tra cứu sách, tìm tác giả, gợi ý đọc sách, cuốn sách cụ thể.\n"
                + "- Irrelevant: Nếu là chào hỏi xã giao, đùa giỡn hoặc các câu hỏi linh tinh không liên quan đến thư viện/sách.\n\n"
                + "Quy tắc: BẮT BUỘC chỉ trả về đúng 1 từ tiếng Anh duy nhất: 'Rules', 'Books', hoặc 'Irrelevant'. "
                + "Không trả về thêm bất kỳ từ nào khác.";

        try {
            JsonObject textPart = new JsonObject();
            textPart.addProperty("text", "Câu hỏi: \"" + userMessage + "\"");

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
            
            JsonObject thinkingConfig = new JsonObject();
            thinkingConfig.addProperty("thinkingBudget", 0);
            generationConfig.add("thinkingConfig", thinkingConfig);
            root.add("generationConfig", generationConfig);

            String jsonPayload = new Gson().toJson(root);
            String response = sendPostRequest(jsonPayload);
            String label = parseTextResponse(response).trim();
            
            if (label.contains("Rules")) return "Rules";
            if (label.contains("Books")) return "Books";
            return "Irrelevant";
        } catch (Exception e) {
            if (lowerMsg.contains("sách") || lowerMsg.contains("tác giả") || lowerMsg.contains("cuốn") || lowerMsg.contains("truyện") || lowerMsg.contains("tìm")) {
                return "Books";
            }
            if (lowerMsg.contains("nội quy") || lowerMsg.contains("quy định") || lowerMsg.contains("phạt") || lowerMsg.contains("mượn") || lowerMsg.contains("trả") || lowerMsg.contains("giờ")) {
                return "Rules";
            }
            return "Irrelevant";
        }
    }

    /**
     * Truy xuất các quy định, nội quy của thư viện từ CSDL để nhúng vào Prompt.
     */
    public String retrieveRulesContext() {
        Map<String, String> configs = systemConfigDAO.getLibraryConfigurations();
        if (configs.isEmpty()) {
            return "Không tìm thấy cấu hình quy định cụ thể trong cơ sở dữ liệu. Thư viện mở cửa từ 8:00 đến 20:00 các ngày từ thứ 2 đến thứ 7.";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("Dưới đây là các chính sách và cấu hình vận hành thư viện chính thức:\n");
        for (Map.Entry<String, String> entry : configs.entrySet()) {
            sb.append("- ").append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
        }
        return sb.toString();
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

    private String sendPostRequest(String payload) throws Exception {
        URL url = new URL(AiConfig.GEMINI_API_URL + AiConfig.GEMINI_CHATBOT_API_KEY);
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
            throw new Exception("Gemini API rejected request. Status code: " + statusCode);
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
}
