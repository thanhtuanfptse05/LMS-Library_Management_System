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

/**
 * AiChatbotServlet — API Servlet xử lý hội thoại với chatbot hỗ trợ AI.
 * Đường dẫn: /api/chatbot
 */
@WebServlet(name = "AiChatbotServlet", urlPatterns = {"/api/chatbot"})
public class AiChatbotServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private final AiChatbotService chatbotService = new AiChatbotService();

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
     * Tiếp nhận câu hỏi của người dùng, phân loại và gọi AI để phản hồi.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject jsonRes = new JsonObject();
        
        try {
            JsonObject reqBody = gson.fromJson(request.getReader(), JsonObject.class);
            if (reqBody == null || !reqBody.has("message")) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("response", "Yêu cầu không hợp lệ.");
                response.getWriter().write(gson.toJson(jsonRes));
                return;
            }
            
            String userMessage = reqBody.get("message").getAsString().trim();
            String intent = chatbotService.classifyIntent(userMessage);
            
            String aiResponse;
            if ("Irrelevant".equals(intent)) {
                aiResponse = "Tôi chỉ có thể hỗ trợ các vấn đề liên quan đến nội quy thư viện và tìm kiếm sách.";
            } else {
                // Lấy ngữ cảnh dựa trên Intent
                String context;
                String systemPrompt;
                if ("Rules".equals(intent)) {
                    context = chatbotService.retrieveRulesContext();
                    systemPrompt = "Bạn là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib).\n"
                            + "Hãy trả lời câu hỏi của người dùng một cách ngắn gọn, rõ ràng, lịch sự và bằng TIẾNG VIỆT.\n"
                            + "Sử dụng thông tin cấu hình quy định chính thức dưới đây làm nguồn dữ liệu đáng tin cậy duy nhất:\n\n"
                            + context + "\n\n"
                            + "Lưu ý: Chỉ trả lời các quy định dựa trên dữ liệu trên. Nếu thông tin không có trong dữ liệu, hãy trả lời lịch sự rằng bạn chưa nắm rõ quy định cụ thể này và khuyên họ liên hệ trực tiếp thủ thư tại quầy.";
                } else { // Books
                    context = chatbotService.retrieveBooksContext(userMessage);
                    systemPrompt = "Bạn là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib).\n"
                            + "Hãy giới thiệu hoặc gợi ý sách cho người dùng bằng TIẾNG VIỆT một cách ngắn gọn, thân thiện.\n"
                            + "Dưới đây là danh sách sách thực tế đang có trong thư viện (Candidate Pool):\n\n"
                            + context + "\n\n"
                            + "Quy tắc chống ảo giác: BẮT BUỘC chỉ giới thiệu những cuốn sách có trong danh sách trên. "
                            + "Tuyệt đối không bịa đặt tên sách, tác giả hoặc ID sách không có trong danh sách. "
                            + "Nếu không tìm thấy sách phù hợp, hãy trả lời lịch sự rằng thư viện hiện chưa có đầu sách này.";
                }

                // Lấy lịch sử ngắn hạn từ Session
                HttpSession session = request.getSession(true);
                @SuppressWarnings("unchecked")
                List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute("chatHistory");
                if (chatHistory == null) {
                    chatHistory = new ArrayList<>();
                }

                // Giới hạn lịch sử đàm thoại tối đa 5 lượt (5 user + 5 model = 10 tin nhắn)
                List<ChatMessage> recentHistory = new ArrayList<>();
                if (chatHistory.size() > 10) {
                    recentHistory.addAll(chatHistory.subList(chatHistory.size() - 10, chatHistory.size()));
                } else {
                    recentHistory.addAll(chatHistory);
                }

                // Thêm lượt chat hiện tại của người dùng vào context để gửi sang AI
                recentHistory.add(new ChatMessage("user", userMessage));

                // Gọi Gemini API
                aiResponse = chatbotService.callGeminiChat(recentHistory, systemPrompt);
                if (aiResponse == null || aiResponse.trim().isEmpty()) {
                    aiResponse = "Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.";
                }
            }
            
            jsonRes.addProperty("status", "success");
            jsonRes.addProperty("response", aiResponse);
        } catch (Exception e) {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("response", "Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.");
        }
        
        response.getWriter().write(gson.toJson(jsonRes));
    }
}
