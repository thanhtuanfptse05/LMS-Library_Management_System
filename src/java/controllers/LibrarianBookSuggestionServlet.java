package controllers;

import dao.BookSuggestionDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BookSuggestion;
import service.BookSuggestionService;

@WebServlet(name = "LibrarianBookSuggestionServlet", urlPatterns = {"/librarian/book-suggestions"})
public class LibrarianBookSuggestionServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final Logger LOGGER = Logger.getLogger(LibrarianBookSuggestionServlet.class.getName());

    private final BookSuggestionDAO bookSuggestionDAO = new BookSuggestionDAO();
    private final BookSuggestionService bookSuggestionService = new BookSuggestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

            request.setAttribute("suggestions", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("status", status == null ? "" : status);

            request.getRequestDispatcher("/librarian/book-suggestions.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn danh sách đề xuất (thủ thư)", e);
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

        // Giữ bộ lọc khi redirect
        String q = request.getParameter("q_filter");
        String statusFilter = request.getParameter("status_filter");
        String pageFilter = request.getParameter("page_filter");

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/librarian/book-suggestions?");
        if (q != null && !q.isBlank()) redirectUrl.append("q=").append(java.net.URLEncoder.encode(q, "UTF-8")).append("&");
        if (statusFilter != null && !statusFilter.isBlank()) redirectUrl.append("status=").append(statusFilter).append("&");
        if (pageFilter != null && !pageFilter.isBlank()) redirectUrl.append("page=").append(pageFilter);

        try {
            if ("updateStatus".equals(action)) {
                int suggestionId = Integer.parseInt(request.getParameter("suggestionId"));
                String status = request.getParameter("status");
                String librarianNote = request.getParameter("librarianNote");

                bookSuggestionService.updateStatus(suggestionId, status, librarianNote, actorId);
                session.setAttribute("successMessage", "Cập nhật trạng thái đề xuất thành công.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật trạng thái đề xuất", e);
            session.setAttribute("errorMessage", "Không thể cập nhật đề xuất: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl.toString());
    }
}
