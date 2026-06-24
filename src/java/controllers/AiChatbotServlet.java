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
        
        // Cắt bớt lịch sử trước khi gọi AI để tránh tràn token (Tối đa 3 lượt = 6 tin nhắn gồm cả tin nhắn user vừa nhập)
        pruneHistory(chatHistory, 5); // Giữ tối đa 5 tin nhắn cũ để thêm tin model thành 6 tin nhắn (3 lượt)

        // 2. Phân loại ý định của người dùng
        String intent = aiChatbotService.classifyIntent(userMessage);

        // Reset lịch sử hội thoại nếu chuyển hướng ý định (Intent-based reset)
        String lastIntent = (String) session.getAttribute("lastChatIntent");
        if (lastIntent != null && !lastIntent.equals(intent)) {
            chatHistory.clear();
            chatHistory.add(new ChatMessage("user", userMessage));
        }
        session.setAttribute("lastChatIntent", intent);
        String responseText;

        if ("Irrelevant".equalsIgnoreCase(intent)) {
            // Trường hợp ngoài phạm vi: Phản hồi tĩnh trực tiếp, không tốn token gọi AI
            responseText = "Tôi chỉ có thể hỗ trợ các vấn đề liên quan đến nội quy thư viện và tìm kiếm sách.";
        } else {
            String systemPrompt = "";
            boolean bypassGemini = false;

            if ("Rules".equalsIgnoreCase(intent)) {
                // Thử khớp FAQ trước để tránh gọi Gemini API
                String faqResponse = aiChatbotService.matchRulesFAQ(userMessage);
                if (faqResponse != null) {
                    responseText = faqResponse;
                    bypassGemini = true;
                } else {
                    // Truy xuất nội quy
                    String rulesContext = aiChatbotService.retrieveRulesContext();
                    systemPrompt = "Bạn là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib). "
                            + "Nhiệm vụ của bạn là trả lời câu hỏi dựa TRÊN ĐÚNG thông tin cấu hình và nội quy được cung cấp bên dưới, TUYỆT ĐỐI KHÔNG tự bịa ra con số (ví dụ: tiền phạt, số ngày). "
                            + "Hãy trả lời THẬT NGẮN GỌN, đúng trọng tâm, KHÔNG dông dài. KHÔNG DÙNG công thức toán học phức tạp (như $$...$$), chỉ dùng văn bản Markdown đơn giản, thân thiện, dễ đọc. "
                            + "Nếu câu hỏi không có trong nội dung cấu hình dưới đây, hãy trả lời: 'Tôi không có thông tin về vấn đề này. Vui lòng liên hệ thủ thư.'\n\n"
                            + "Thông tin cấu hình/nội quy THỰC TẾ:\n" + rulesContext;
                }
            } else {
                // Phân tách 2 sub-intent trong nhóm Books
                boolean isDirectSearch = userMessage.toLowerCase()
                        .matches(".*(tìm sách|sách về|cuốn sách|có sách|sách của tác giả|tìm cuốn).*");
                boolean isAdvice = userMessage.toLowerCase()
                        .matches(".*(gợi ý|đề xuất|khuyên đọc|phù hợp với|đọc gì|nên đọc).*");

                if (isDirectSearch && !isAdvice) {
                    // Luồng A: DB Search trực tiếp, không qua AI (0 API call)
                    String booksContext = aiChatbotService.retrieveBooksContext(userMessage);
                    if (booksContext == null || booksContext.trim().isEmpty() || booksContext.contains("Không tìm thấy")) {
                        responseText = "Không tìm thấy sách phù hợp với từ khóa của bạn. "
                                     + "Bạn có thể thử tìm kiếm từ khóa khác hoặc hỏi mình gợi ý sách nhé!";
                    } else {
                        responseText = aiChatbotService.formatBooksAsMarkdown(userMessage, booksContext);
                    }
                    bypassGemini = true;
                } else {
                    // Luồng B: Cần AI tư vấn (gợi ý sách cá nhân hóa/thịnh hành)
                    boolean isRecommend = userMessage.toLowerCase().matches(".*(gợi ý|đề xuất|khuyên đọc|phù hợp với tôi|nên đọc).*");
                    String booksContext;
                    boolean useF8 = false;

                    if (isRecommend) {
                        // Nếu là yêu cầu gợi ý, sử dụng F8 để lấy sách cá nhân hóa/thịnh hành
                        Integer userId = (Integer) session.getAttribute("userId");
                        booksContext = aiChatbotService.retrievePersonalizedBooksContext(userId);
                        useF8 = true;
                    } else {
                        // Ngược lại, tìm kiếm sách theo từ khóa bình thường
                        booksContext = aiChatbotService.retrieveBooksContext(userMessage);
                        // Nếu tìm kiếm không thấy sách nào, fallback sang F8 để gợi ý sách
                        if (booksContext == null || booksContext.trim().isEmpty() || booksContext.contains("Không tìm thấy")) {
                            Integer userId = (Integer) session.getAttribute("userId");
                            booksContext = aiChatbotService.retrievePersonalizedBooksContext(userId);
                            useF8 = true;
                        }
                    }

                    if (useF8) {
                        if (booksContext == null || booksContext.trim().isEmpty() || booksContext.contains("Không tìm thấy")) {
                            systemPrompt = "Bạn là một thủ thư thân thiện của thư viện trường đại học (UniLib). "
                                    + "Người dùng đang tìm kiếm sách nhưng hệ thống không tìm thấy kết quả phù hợp trực tiếp cho từ khóa của họ. "
                                    + "Hãy đóng vai trò là một thủ thư thân thiện, hỏi mở lịch sự để làm rõ nhu cầu của người dùng (ví dụ: họ muốn tìm sách thuộc thể loại nào, tác giả nào, hoặc phục vụ cho môn học/đề tài gì). "
                                    + "Đồng thời, hãy gợi ý cho họ 3-4 danh mục sách phổ biến nhất tại thư viện (như Kỹ năng, Công nghệ, Kinh tế, Văn học...) dưới dạng danh sách Markdown để họ lựa chọn. "
                                    + "Hãy phản hồi bằng tiếng Việt thân thiện, ấm áp và chuyên nghiệp dưới dạng Markdown (100% Vietnamese), và tuyệt đối KHÔNG được báo là 'không tìm thấy sách' hay 'không có sách'.";
                        } else {
                            systemPrompt = "Bạn là trợ lý ảo kiêm thủ thư thân thiện của thư viện trường đại học (UniLib). "
                                    + "Hãy đóng vai trò là một thủ thư thân thiện, giới thiệu và gợi ý cho người dùng danh sách các cuốn sách được tuyển chọn dưới đây. "
                                    + "Hãy đưa ra câu trả lời chi tiết bằng tiếng Việt dưới dạng Markdown (100% Vietnamese), giới thiệu sơ lược về các cuốn sách này và khuyên người dùng đến thư viện mượn. "
                                    + "Tuyệt đối không báo là 'không tìm thấy sách'.\n\n"
                                    + "Danh sách sách gợi ý:\n" + booksContext;
                        }
                    } else {
                        systemPrompt = "Bạn là trợ lý ảo của thư viện trường đại học (UniLib). "
                                + "Hãy hỗ trợ người dùng tìm và gợi ý sách dựa trên danh sách các đầu sách có sẵn dưới đây. "
                                + "Hãy đưa ra câu trả lời chi tiết bằng tiếng Việt dưới dạng Markdown (100% Vietnamese), có thông tin mô tả cơ bản của sách (nếu có) và khuyên người dùng đến thư viện mượn. "
                                + "Chỉ đề xuất các sách có trong danh sách dưới đây, tuyệt đối không tự bịa ra sách khác.\n\n"
                                + "Danh sách sách có sẵn:\n" + booksContext;
                    }
                }
            }

            if (!bypassGemini) {
                // Gọi AI Service
                responseText = aiChatbotService.callGeminiChat(chatHistory, systemPrompt);
                
                // Xử lý Fallback khi AI lỗi hoặc timeout
                if (responseText == null || responseText.trim().isEmpty()) {
                    responseText = "Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.";
                }
            }
        }

        // 3. Lưu câu trả lời vào lịch sử hội thoại
        chatHistory.add(new ChatMessage("model", responseText));
        
        // Prune lần cuối để đảm bảo tối đa 6 tin nhắn trong Session (3 lượt)
        pruneHistory(chatHistory, 6);
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
