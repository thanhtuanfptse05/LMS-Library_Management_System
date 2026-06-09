package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.User;
import service.AiRecommendationService;

/**
 * RecommendationServlet — Xử lý logic hiển thị sách gợi ý.
 * Trả về một JSP fragment để nhúng vào trang chủ thông qua AJAX.
 */
@WebServlet(name = "RecommendationServlet", urlPatterns = {"/recommendation"})
public class RecommendationServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final AiRecommendationService aiService = new AiRecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Book> recommendedBooks = new ArrayList<>();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            // Đã đăng nhập: Kiểm tra lịch sử mượn
            int borrowCount = borrowRecordDAO.countUserBorrowHistory(user.getUserId());
            
            if (borrowCount >= 3) {
                // Đủ điều kiện: Gọi AI
                List<Integer> candidatePool = bookDAO.getCandidatePool(user.getUserId(), 50); // Pool 50 sách
                List<Integer> aiRecommendedIds = aiService.getRecommendations(candidatePool);
                
                if (aiRecommendedIds != null && !aiRecommendedIds.isEmpty()) {
                    for (Integer id : aiRecommendedIds) {
                        Book book = bookDAO.getBookById(id);
                        if (book != null) {
                            recommendedBooks.add(book);
                        }
                    }
                }
            }
        }

        // Fallback: Nếu không đăng nhập, hoặc mượn < 3, hoặc AI lỗi
        if (recommendedBooks.isEmpty()) {
            recommendedBooks = bookDAO.getTopTrendingBooks(5); // Top 5
        }

        // Đẩy sang view fragment
        request.setAttribute("recommendedBooks", recommendedBooks);
        request.getRequestDispatcher("/common/_recommendation.jsp").forward(request, response);
    }
}
