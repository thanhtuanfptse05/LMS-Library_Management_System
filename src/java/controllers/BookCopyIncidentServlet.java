package controllers;

import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
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
import service.BookCopyIncidentService;
import util.DatabaseConnection;

@WebServlet(name = "BookCopyIncidentServlet", urlPatterns = {"/book-management/incidents"})
public class BookCopyIncidentServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;
    private static final Logger LOGGER = Logger.getLogger(BookCopyIncidentServlet.class.getName());
    private final BookCopyIncidentDAO incidentDAO = new BookCopyIncidentDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookCopyIncidentService incidentService = new BookCopyIncidentService();

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
        String type = normalizeType(request.getParameter("type"));
        String status = normalizeStatus(request.getParameter("status"));
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        try {
            int totalItems = incidentDAO.count(keyword, type, status);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);
            request.setAttribute("incidents", incidentDAO.search(keyword, type, status,
                    (page - 1) * PAGE_SIZE, PAGE_SIZE));
            request.setAttribute("summary", incidentDAO.getSummary());
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedType", type == null ? "" : type);
            request.setAttribute("selectedStatus", status == null ? "" : status);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            loadRequestedModal(request, canEdit);
            request.getRequestDispatcher("/librarian/book-damaged-lost.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách sự cố bản sao.", e);
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn chỉ có quyền xem danh sách sự cố bản sao.");
            return;
        }
        try {
            int actorId = (Integer) session.getAttribute("userId");
            String action = request.getParameter("action");
            if ("restore".equals(action)) {
                incidentService.restoreAfterRepair(parseRequiredInt(request.getParameter("incidentId")),
                        trimToNull(request.getParameter("repairNote")), actorId);
                session.setAttribute("successMessage", "Đã khôi phục bản sao về trạng thái sẵn sàng lưu thông.");
            } else if ("report".equals(action)) {
                incidentService.report(trimToNull(request.getParameter("barcode")),
                        request.getParameter("incidentType"), trimToNull(request.getParameter("description")),
                        actorId);
                session.setAttribute("successMessage",
                        "Ghi nhận sự cố thành công. Bản sao đã ngừng lưu thông và tồn kho đã được đồng bộ.");
            } else if ("investigate".equals(action)) {
                incidentService.startInvestigating(parseRequiredInt(request.getParameter("incidentId")), actorId);
                session.setAttribute("successMessage", "Đã chuyển sự cố sang trạng thái đang xác minh.");
            } else if ("resolve".equals(action)) {
                incidentService.resolve(parseRequiredInt(request.getParameter("incidentId")),
                        trimToNull(request.getParameter("resolution")), actorId);
                session.setAttribute("successMessage", "Đã kết luận sự cố và cập nhật tình trạng bản sao.");
            } else if ("reject".equals(action)) {
                incidentService.reject(parseRequiredInt(request.getParameter("incidentId")),
                        trimToNull(request.getParameter("resolution")), actorId);
                session.setAttribute("successMessage", "Đã bác bỏ báo cáo và hoàn trả bản sao vào kho.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Không thể xử lý sự cố bản sao.", e);
            session.setAttribute("errorMessage", "Không thể xử lý sự cố. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/book-management/incidents");
    }

    private void loadRequestedModal(HttpServletRequest request, boolean canEdit) throws SQLException {
        Integer bookCopyId = parseOptionalInt(request.getParameter("bookCopyId"));
        Integer incidentId = parseOptionalInt(request.getParameter("incidentId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (canEdit && bookCopyId != null) {
                request.setAttribute("reportCopy", bookCopyDAO.findById(conn, bookCopyId));
            }
            if (incidentId != null) {
                request.setAttribute("selectedIncident", incidentDAO.findById(conn, incidentId));
            }
        }
    }

    private boolean isEditor(String role) {
        return "LIBRARIAN".equalsIgnoreCase(role);
    }

    private String normalizeType(String type) {
        return "damaged".equals(type) || "lost".equals(type) ? type : null;
    }

    private String normalizeStatus(String status) {
        return "pending".equals(status) || "investigating".equals(status)
                || "resolved".equals(status) || "rejected".equals(status) ? status : null;
    }

    private int parseRequiredInt(String value) throws ValidationException {
        try {
            int parsed = Integer.parseInt(value);
            if (parsed <= 0) {
                throw new NumberFormatException();
            }
            return parsed;
        } catch (NumberFormatException e) {
            throw new ValidationException("Mã sự cố không hợp lệ.");
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

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
