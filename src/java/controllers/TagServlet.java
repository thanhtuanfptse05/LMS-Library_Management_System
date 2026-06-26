package controllers;

import dao.TagDAO;
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
import model.Tag;
import service.TagService;
import util.DatabaseConnection;

@WebServlet(name = "TagServlet", urlPatterns = {"/book-management/tags"})
public class TagServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TagServlet.class.getName());
    private final TagDAO tagDAO = new TagDAO();
    private final TagService tagService = new TagService();

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
            request.setAttribute("tags", tagDAO.search(keyword, status));
            request.setAttribute("allTags", tagDAO.findAll());
            request.setAttribute("summary", tagDAO.getSummary());
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedStatus", status == null ? "" : status);
            Integer editId = parseOptionalInt(request.getParameter("editId"));
            if (canEdit && editId != null) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    request.setAttribute("editTag", tagDAO.findById(conn, editId));
                }
            }
            request.getRequestDispatcher("/librarian/book-tags.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách tag sách.", e);
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn chỉ có quyền xem tag sách.");
            return;
        }
        try {
            String action = request.getParameter("action");
            int actorId = (Integer) session.getAttribute("userId");
            if ("create".equals(action)) {
                tagService.create(readTag(request, false), actorId);
                session.setAttribute("successMessage", "Tạo tag sách thành công.");
            } else if ("update".equals(action)) {
                tagService.update(readTag(request, true), actorId);
                session.setAttribute("successMessage", "Cập nhật tag sách thành công.");
            } else if ("merge".equals(action)) {
                tagService.merge(Integer.parseInt(request.getParameter("sourceTagId")),
                        Integer.parseInt(request.getParameter("targetTagId")), actorId);
                session.setAttribute("successMessage", "Gộp tag thành công. Tag nguồn đã được ẩn.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Không thể lưu tag sách.", e);
            session.setAttribute("errorMessage", "Không thể lưu tag sách. Vui lòng kiểm tra và thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/book-management/tags");
    }

    private Tag readTag(HttpServletRequest request, boolean updating) {
        Tag tag = new Tag();
        if (updating) {
            tag.setTagId(Integer.parseInt(request.getParameter("tagId")));
        }
        tag.setName(trimToNull(request.getParameter("name")));
        tag.setStatus("hidden".equals(request.getParameter("status")) ? "hidden" : "active");
        return tag;
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
