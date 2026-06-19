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
            // Skeleton doPost
            jsonRes.addProperty("status", "success");
            jsonRes.addProperty("response", "Đang xử lý...");
        } catch (Exception e) {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("response", "Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.");
        }
        
        response.getWriter().write(gson.toJson(jsonRes));
    }
}
