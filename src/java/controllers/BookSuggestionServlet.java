package controllers;

import dao.BookSuggestionDAO;
import dao.SuggestionVoteDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BookSuggestion;
import service.BookSuggestionService;
import util.DatabaseConnection;

@WebServlet(name = "BookSuggestionServlet", urlPatterns = {"/lecturer/book-suggestions"})
public class BookSuggestionServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final Logger LOGGER = Logger.getLogger(BookSuggestionServlet.class.getName());
    
    private final BookSuggestionDAO bookSuggestionDAO = new BookSuggestionDAO();
    private final SuggestionVoteDAO suggestionVoteDAO = new SuggestionVoteDAO();
    private final BookSuggestionService bookSuggestionService = new BookSuggestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String keyword = request.getParameter("q");
        String status = request.getParameter("status");
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        try {
            int totalItems = bookSuggestionDAO.countSuggestions(keyword, status);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            if (page > totalPages) {
                page = totalPages;
            }
            int offset = (page - 1) * PAGE_SIZE;

            List<BookSuggestion> list = bookSuggestionDAO.getPaginatedSuggestions(keyword, status, offset, PAGE_SIZE);
            List<Integer> userVotedIds = suggestionVoteDAO.getUserVotedSuggestionIds(userId);

            request.setAttribute("suggestions", list);
            request.setAttribute("userVotedIds", userVotedIds);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("status", status == null ? "" : status);

            // Xử lý nạp dữ liệu sửa đổi nếu có
            String editIdStr = request.getParameter("editId");
            if (editIdStr != null && !editIdStr.isBlank()) {
                try {
                    int editId = Integer.parseInt(editIdStr);
                    try (Connection conn = DatabaseConnection.getConnection()) {
                        BookSuggestion editSuggestion = bookSuggestionDAO.findById(conn, editId);
                        if (editSuggestion != null && editSuggestion.getCreatedBy() == userId 
                                && "pending".equals(editSuggestion.getStatus()) && editSuggestion.getVoteCount() == 1) {
                            request.setAttribute("editSuggestion", editSuggestion);
                        }
                    }
                } catch (NumberFormatException | SQLException e) {
                    // Ignore
                }
            }

            request.getRequestDispatcher("/lecturer/book-suggestions.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn danh sách đề xuất", e);
            throw new ServletException("Không thể tải danh sách đề xuất sách.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int actorId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        // Giữ lại bộ lọc/tìm kiếm/phân trang để redirect về đúng trạng thái
        String q = request.getParameter("q_filter");
        String statusFilter = request.getParameter("status_filter");
        String pageFilter = request.getParameter("page_filter");
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/lecturer/book-suggestions?");
        if (q != null && !q.isBlank()) redirectUrl.append("q=").append(java.net.URLEncoder.encode(q, "UTF-8")).append("&");
        if (statusFilter != null && !statusFilter.isBlank()) redirectUrl.append("status=").append(statusFilter).append("&");
        if (pageFilter != null && !pageFilter.isBlank()) redirectUrl.append("page=").append(pageFilter);

        try {
            if ("create".equals(action)) {
                BookSuggestion suggestion = new BookSuggestion();
                suggestion.setTitle(request.getParameter("title"));
                suggestion.setAuthor(request.getParameter("author"));
                suggestion.setPublisher(request.getParameter("publisher"));
                suggestion.setIsbn(request.getParameter("isbn"));
                suggestion.setReason(request.getParameter("reason"));

                boolean confirmSimilar = "true".equals(request.getParameter("confirmSimilar"));

                try {
                    bookSuggestionService.create(suggestion, actorId, confirmSimilar);
                    session.setAttribute("successMessage", "Gửi đề xuất sách mới thành công.");
                } catch (ValidationException e) {
                    if ("SIMILAR_TITLE_WARNING".equals(e.getMessage())) {
                        // Trả lại các dữ liệu form vừa điền để hiển thị modal cảnh báo
                        session.setAttribute("similarWarning", true);
                        session.setAttribute("tempTitle", suggestion.getTitle());
                        session.setAttribute("tempAuthor", suggestion.getAuthor());
                        session.setAttribute("tempPublisher", suggestion.getPublisher());
                        session.setAttribute("tempIsbn", suggestion.getIsbn());
                        session.setAttribute("tempReason", suggestion.getReason());
                    } else {
                        throw e;
                    }
                }

            } else if ("update".equals(action)) {
                BookSuggestion suggestion = new BookSuggestion();
                suggestion.setSuggestionId(Integer.parseInt(request.getParameter("suggestionId")));
                suggestion.setTitle(request.getParameter("title"));
                suggestion.setAuthor(request.getParameter("author"));
                suggestion.setPublisher(request.getParameter("publisher"));
                suggestion.setIsbn(request.getParameter("isbn"));
                suggestion.setReason(request.getParameter("reason"));

                bookSuggestionService.update(suggestion, actorId);
                session.setAttribute("successMessage", "Cập nhật đề xuất sách thành công.");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("suggestionId"));
                bookSuggestionService.delete(id, actorId);
                session.setAttribute("successMessage", "Xóa đề xuất sách thành công.");

            } else if ("vote".equals(action)) {
                int id = Integer.parseInt(request.getParameter("suggestionId"));
                suggestionVoteDAO.voteTransaction(id, actorId);
                session.setAttribute("successMessage", "Đã vote (+1) cho đề xuất.");

            } else if ("unvote".equals(action)) {
                int id = Integer.parseInt(request.getParameter("suggestionId"));
                suggestionVoteDAO.unvoteTransaction(id, actorId);
                session.setAttribute("successMessage", "Đã hủy vote cho đề xuất.");

            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException | SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi thực thi POST BookSuggestionServlet", e);
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl.toString());
    }
}
