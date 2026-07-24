package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import dto.BookSummaryDTO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import service.AiRecommendationService;

/**
 * RecommendationServlet — Xử lý logic hiển thị sách gợi ý.
 * Trả về một JSP fragment để nhúng vào trang chủ thông qua AJAX.
 *
 * Luồng hoạt động:
 * 1. Kiểm tra Session Cache → có thì trả ngay (tránh gọi AI lại).
 * 2. Xác định userId từ Session → không có thì Fallback Top Trending.
 * 3. Kiểm tra borrowCount >= 3 → đủ thì gọi AI, không đủ thì Fallback.
 * 4. Lưu kết quả AI vào Session Cache cho lần sau.
 */
@WebServlet(name = "RecommendationServlet", urlPatterns = { "/recommendation" })
public class RecommendationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RecommendationServlet.class.getName());

    BookDAO bookDAO = new BookDAO();
    BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    AiRecommendationService aiService = new AiRecommendationService();

    private static final String CACHE_KEY = "cachedRecommendations";
    private static final String REASONS_CACHE_KEY = "cachedRecommendationReasons";
    private static final String IS_AI_CACHE_KEY = "cachedIsAiPowered";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Book> recommendedBooks = new ArrayList<>();
        java.util.Map<Integer, String> recommendationReasons = new java.util.HashMap<>();
        boolean isAiPowered = false;
        HttpSession session = request.getSession(false);

        // --- Bước 1: Kiểm tra Session Cache (Task #5) ---
        if (session != null) {
            @SuppressWarnings("unchecked")
            List<Book> cached = (List<Book>) session.getAttribute(CACHE_KEY);
            @SuppressWarnings("unchecked")
            java.util.Map<Integer, String> cachedReasons = (java.util.Map<Integer, String>) session.getAttribute(REASONS_CACHE_KEY);
            Boolean cachedIsAi = (Boolean) session.getAttribute(IS_AI_CACHE_KEY);
            
            if (cached != null && !cached.isEmpty()) {
                LOGGER.log(Level.FINE, "[AI-REC] Cache HIT - Returning cached recommendations ({0} books).", cached.size());
                request.setAttribute("recommendedBooks", cached);
                request.setAttribute("recommendationReasons", cachedReasons != null ? cachedReasons : new java.util.HashMap<>());
                request.setAttribute("isAiPowered", cachedIsAi != null ? cachedIsAi : false);
                String layout = request.getParameter("layout");
                String targetJsp = "bento".equals(layout) ? "/common/_recommendation_bento.jsp" : "/common/_recommendation.jsp";
                request.getRequestDispatcher(targetJsp).forward(request, response);
                return;
            }
        }

        // --- Bước 2: Xác định userId từ Session (Task #1 — Fix Bug) ---
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        LOGGER.log(Level.FINE, "[AI-REC] Session={0}, userId={1}",
                new Object[] { session != null ? "EXISTS" : "NULL", userId });

        if (userId != null) {
            // Đã đăng nhập: Kiểm tra lịch sử mượn
            int borrowCount = borrowRecordDAO.countUserBorrowHistory(userId);
            LOGGER.log(Level.FINE, "[AI-REC] userId={0}, borrowCount={1} (requires >= 3)",
                    new Object[] { userId, borrowCount });

            if (borrowCount >= 3) {
                // Đủ điều kiện: Gọi AI
                java.util.Map<String, java.util.Map<String, Integer>> freqProfile = bookDAO.getUserTagCategoryFrequency(userId);
                List<BookSummaryDTO> recentHistory = bookDAO.getRecentBorrowedSummary(userId, 3);
                List<BookSummaryDTO> candidatePool = bookDAO.getCandidatePoolWithTagsAndCategories(userId, 30);
                
                LOGGER.log(Level.FINE, "[AI-REC] Preparing context... CandidatePool size={0}", candidatePool.size());

                java.util.Map<Integer, String> aiRecommendations = aiService.getRecommendationsWithReasons(freqProfile, recentHistory, candidatePool);
                LOGGER.log(Level.FINE, "[AI-REC] AI returned recommendations count: {0}",
                        aiRecommendations != null ? aiRecommendations.size() : "NULL (API error)");

                if (aiRecommendations != null && !aiRecommendations.isEmpty()) {
                    for (java.util.Map.Entry<Integer, String> entry : aiRecommendations.entrySet()) {
                        int id = entry.getKey();
                        Book book = bookDAO.getBookById(id);
                        if (book != null) {
                            recommendedBooks.add(book);
                            recommendationReasons.put(id, entry.getValue());
                        }
                    }
                    isAiPowered = true;
                }

                // --- Task #2: Log cảnh báo nếu AI trả về kết quả rỗng (100% ảo giác bị lọc) ---
                if (aiRecommendations != null && aiRecommendations.isEmpty()) {
                    LOGGER.log(Level.WARNING,
                            "[AI-REC] AI returned empty list after Anti-Hallucination filter (userId={0}). "
                                    + "Wasted 1 API call. Fallback to Top Trending.",
                            userId);
                }

                // --- Bước 3: Lưu kết quả AI vào Session Cache (Task #5) ---
                if (!recommendedBooks.isEmpty() && session != null) {
                    session.setAttribute(CACHE_KEY, recommendedBooks);
                    session.setAttribute(REASONS_CACHE_KEY, recommendationReasons);
                    session.setAttribute(IS_AI_CACHE_KEY, isAiPowered);
                    LOGGER.log(Level.FINE, "[AI-REC] Cached {0} AI recommendations for userId={1}.",
                            new Object[] { recommendedBooks.size(), userId });
                }
            }
        }

        // Fallback: Nếu không đăng nhập, hoặc mượn < 3, hoặc AI lỗi
        if (recommendedBooks.isEmpty()) {
            LOGGER.log(Level.FINE, "[AI-REC] FALLBACK -> Top Trending (userId={0})", userId);
            recommendedBooks = bookDAO.getTopTrendingBooks(5); // Top 5
            isAiPowered = false;
        }

        // Đẩy sang view fragment
        request.setAttribute("recommendedBooks", recommendedBooks);
        request.setAttribute("recommendationReasons", recommendationReasons);
        request.setAttribute("isAiPowered", isAiPowered);
        String layout = request.getParameter("layout");
        String targetJsp = "bento".equals(layout) ? "/common/_recommendation_bento.jsp" : "/common/_recommendation.jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
    }
}
