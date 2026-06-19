package controllers;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ChatMessage;
import service.AiChatbotService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AiChatbotServlet — API Servlet xử lý hội thoại với chatbot hỗ trợ AI.
 * Đường dẫn: /api/chatbot
 * Hỗ trợ GET (lấy lịch sử chat) và POST (gửi tin nhắn mới).
 */
@WebServlet(name = "AiChatbotServlet", urlPatterns = {"/api/chatbot"})
public class AiChatbotServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AiChatbotServlet.class.getName());
    private final AiChatbotService aiChatbotService = new AiChatbotService();
    private final Gson gson = new Gson();

    /**
     * Lấy lịch sử hội thoại hiện tại từ HttpSession.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        HttpSession session = request.getSession(true);
        @SuppressWarnings("unchecked")
        List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            session.setAttribute("chatHistory", chatHistory);
        }

        JsonObject jsonRes = new JsonObject();
        jsonRes.addProperty("status", "success");
        jsonRes.add("history", gson.toJsonTree(chatHistory));
        
        response.getWriter().write(gson.toJson(jsonRes));
    }

    /**
     * Nhận câu hỏi mới từ người dùng, xử lý qua AI RAG và trả về câu trả lời.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        String userMessage = "";
        try {
            JsonObject jsonReq = gson.fromJson(request.getReader(), JsonObject.class);
            if (jsonReq != null && jsonReq.has("message")) {
                userMessage = jsonReq.get("message").getAsString().trim();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể parse JSON request body: " + e.getMessage());
        }

        JsonObject jsonRes = new JsonObject();

        if (userMessage.isEmpty()) {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("message", "Nội dung câu hỏi không được để trống.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(jsonRes));
            return;
        }

        HttpSession session = request.getSession(true);
        @SuppressWarnings("unchecked")
        List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        // 1. Thêm câu hỏi của user vào lịch sử hội thoại
        chatHistory.add(new ChatMessage("user", userMessage));
        
        // Cắt bớt lịch sử trước khi gọi AI để tránh tràn token (Tối đa 5 lượt = 10 tin nhắn gồm cả tin nhắn user vừa nhập)
        pruneHistory(chatHistory, 9); // Giữ tối đa 9 tin nhắn cũ để thêm tin model thành 10 tin nhắn

        // 2. Phân loại ý định của người dùng
        String intent = aiChatbotService.classifyIntent(userMessage);
        String responseText;

        if ("Irrelevant".equalsIgnoreCase(intent)) {
            // Trường hợp ngoài phạm vi: Phản hồi tĩnh trực tiếp, không tốn token gọi AI
            responseText = "Tôi chỉ có thể hỗ trợ các vấn đề liên quan đến nội quy thư viện và tìm kiếm sách.";
        } else {
            String systemPrompt;
            if ("Rules".equalsIgnoreCase(intent)) {
                // Truy xuất nội quy
                String rulesContext = aiChatbotService.retrieveRulesContext();
                systemPrompt = "Bạn là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib). "
                        + "Hãy trả lời câu hỏi của người dùng dựa vào thông tin nội quy thực tế dưới đây. "
                        + "Trả lời ngắn gọn, rõ ràng và mạch lạc dưới dạng định dạng Markdown tiếng Việt (100% Vietnamese). "
                        + "Nếu câu hỏi không tìm thấy thông tin trong nội quy, hãy trả lời lịch sự rằng bạn không có thông tin chính xác về vấn đề này và khuyên người dùng liên hệ thủ thư.\n\n"
                        + "Thông tin nội quy thực tế:\n" + rulesContext;
            } else {
                // Truy xuất sách phù hợp
                String booksContext = aiChatbotService.retrieveBooksContext(userMessage);
                systemPrompt = "Bạn là trợ lý ảo của thư viện trường đại học (UniLib). "
                        + "Hãy hỗ trợ người dùng tìm và gợi ý sách dựa trên danh sách các đầu sách có sẵn dưới đây. "
                        + "Hãy đưa ra câu trả lời chi tiết bằng tiếng Việt dưới dạng Markdown (100% Vietnamese), có thông tin mô tả cơ bản của sách (nếu có) và khuyên người dùng đến thư viện mượn. "
                        + "Chỉ đề xuất các sách có trong danh sách dưới đây, tuyệt đối không tự bịa ra sách khác.\n\n"
                        + "Danh sách sách có sẵn:\n" + booksContext;
            }

            // Gọi AI Service
            responseText = aiChatbotService.callGeminiChat(chatHistory, systemPrompt);
            
            // Xử lý Fallback khi AI lỗi hoặc timeout
            if (responseText == null || responseText.trim().isEmpty()) {
                responseText = "Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.";
            }
        }

        // 3. Lưu câu trả lời vào lịch sử hội thoại
        chatHistory.add(new ChatMessage("model", responseText));
        
        // Prune lần cuối để đảm bảo tối đa 10 tin nhắn trong Session
        pruneHistory(chatHistory, 10);
        session.setAttribute("chatHistory", chatHistory);

        jsonRes.addProperty("status", "success");
        jsonRes.addProperty("intent", intent);
        jsonRes.addProperty("response", responseText);
        jsonRes.add("history", gson.toJsonTree(chatHistory));

        response.getWriter().write(gson.toJson(jsonRes));
    }

    /**
     * Giới hạn lịch sử đàm thoại trong Session.
     */
    private void pruneHistory(List<ChatMessage> history, int maxMessages) {
        while (history.size() > maxMessages) {
            history.remove(0);
        }
    }
}
