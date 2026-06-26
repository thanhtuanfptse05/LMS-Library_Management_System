package controllers;

import dao.CategoryDAO;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import service.CategoryService;
import util.DatabaseConnection;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/book-management/categories"})
public class CategoryServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CategoryServlet.class.getName());
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        boolean canEdit = isEditor((String) session.getAttribute("role"));
        String keyword = trimToNull(request.getParameter("q"));
        String status = normalizeStatus(request.getParameter("status"));
        try {
            request.setAttribute("categories", categoryDAO.search(keyword, status));
            request.setAttribute("summary", categoryDAO.getSummary());
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedStatus", status == null ? "" : status);
            Integer editId = parseOptionalInt(request.getParameter("editId"));
            if (canEdit && editId != null) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    request.setAttribute("editCategory", categoryDAO.findById(conn, editId));
                }
            }
            request.getRequestDispatcher("/librarian/book-categories.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách thể loại.", e);
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
        if (!isEditor((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn chỉ có quyền xem thể loại.");
            return;
        }
        try {
            String action = request.getParameter("action");
            int actorId = (Integer) session.getAttribute("userId");
            if ("create".equals(action)) {
                categoryService.create(readCategory(request, false), actorId);
                session.setAttribute("successMessage", "Tạo thể loại thành công.");
            } else if ("update".equals(action)) {
                categoryService.update(readCategory(request, true), actorId);
                session.setAttribute("successMessage", "Cập nhật thể loại thành công.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Không thể lưu thể loại.", e);
            session.setAttribute("errorMessage", "Không thể lưu thể loại. Vui lòng kiểm tra và thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/book-management/categories");
    }

    private Category readCategory(HttpServletRequest request, boolean updating) {
        Category category = new Category();
        if (updating) {
            category.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        }
        category.setName(trimToNull(request.getParameter("name")));
        category.setDescription(trimToNull(request.getParameter("description")));
        category.setStatus("hidden".equals(request.getParameter("status")) ? "hidden" : "active");
        return category;
    }

    private boolean isEditor(String role) {
        return "LIBRARIAN".equalsIgnoreCase(role);
    }

    private String normalizeStatus(String status) {
        return "active".equals(status) || "hidden".equals(status) ? status : null;
    }

    private Integer parseOptionalInt(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
