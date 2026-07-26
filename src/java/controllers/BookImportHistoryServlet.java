package controllers;

import dao.BookImportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "BookImportHistoryServlet", urlPatterns = {
    "/librarian/book-management/import-history",
    "/book-management/import-history"
})
public class BookImportHistoryServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;
    private final BookImportDAO importDAO = new BookImportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = trimToNull(request.getParameter("q"));
        String status = normalizeStatus(request.getParameter("status"));
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        try {
            int totalItems = importDAO.count(keyword, status);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);
            request.setAttribute("batches", importDAO.search(keyword, status, (page - 1) * PAGE_SIZE, PAGE_SIZE));
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedStatus", status == null ? "" : status);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("pageSize", PAGE_SIZE);
            Integer batchId = parseOptionalInt(request.getParameter("batchId"));
            if (batchId != null) {
                request.setAttribute("selectedBatch", importDAO.findById(batchId));
            }
            request.getRequestDispatcher("/librarian/book-import-history.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải lịch sử import.", e);
        }
    }

    private String normalizeStatus(String status) {
        return "success".equals(status) || "failed".equals(status) ? status : null;
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

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
