package controllers;

import dao.BookCirculationHistoryDAO;
import dao.BookCopyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import model.BookCopy;
import util.DatabaseConnection;

@WebServlet(name = "BookCirculationHistoryServlet", urlPatterns = {
    "/librarian/book-management/circulation-history",
    "/book-management/circulation-history"
})
public class BookCirculationHistoryServlet extends HttpServlet {

    private static final int PAGE_SIZE = 15;
    private final BookCirculationHistoryDAO historyDAO = new BookCirculationHistoryDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer bookCopyId = parseOptionalInt(request.getParameter("bookCopyId"));
        if (bookCopyId == null) {
            session.setAttribute("errorMessage", "Vui lòng chọn một bản sao để xem lịch sử lưu thông.");
            response.sendRedirect(request.getContextPath() + "/librarian/book-management/copies");
            return;
        }

        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        try (Connection conn = DatabaseConnection.getConnection()) {
            BookCopy copy = bookCopyDAO.findById(conn, bookCopyId);
            if (copy == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bản sao cần xem lịch sử lưu thông.");
                response.sendRedirect(request.getContextPath() + "/librarian/book-management/copies");
                return;
            }

            int totalItems = historyDAO.countByBookCopyId(bookCopyId);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);

            request.setAttribute("copy", copy);
            request.setAttribute("histories", historyDAO.findByBookCopyId(bookCopyId,
                    (page - 1) * PAGE_SIZE, PAGE_SIZE));
            request.setAttribute("bookCopyId", bookCopyId);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);

            request.getRequestDispatcher("/librarian/book-circulation-history.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải lịch sử lưu thông của bản sao.", e);
        }
    }

    private Integer parseOptionalInt(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseInt(String value, int fallback) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
