package controllers;

import dao.BookCopyDAO;
import dao.InventoryDAO;
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
import model.InventorySession;
import service.InventoryReconciliationService;
import util.DatabaseConnection;

@WebServlet(name = "InventoryReconciliationServlet", urlPatterns = {
    "/librarian/book-management/inventory",
    "/book-management/inventory"
})
public class InventoryReconciliationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(InventoryReconciliationServlet.class.getName());
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final BookCopyDAO copyDAO = new BookCopyDAO();
    private final InventoryReconciliationService service = new InventoryReconciliationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        boolean canEdit = isEditor((String) session.getAttribute("role"));
        try {
            request.setAttribute("sessions", inventoryDAO.findSessions());
            request.setAttribute("summary", inventoryDAO.getSummary());
            request.setAttribute("locations", copyDAO.findLocations());
            request.setAttribute("canEdit", canEdit);
            Integer sessionId = optionalInt(request.getParameter("sessionId"));
            if (sessionId != null) {
                InventorySession selectedSession;
                try (Connection conn = DatabaseConnection.getConnection()) {
                    selectedSession = inventoryDAO.findSession(conn, sessionId, false);
                    request.setAttribute("selectedSession", selectedSession);
                }
                if (selectedSession != null) {
                    request.setAttribute("locationSummary",
                            copyDAO.getInventoryLocationSummary(selectedSession.getLocation()));
                }
                request.setAttribute("items", inventoryDAO.findItems(sessionId));
            }
            request.getRequestDispatcher("/librarian/book-inventory-reconciliation.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải dữ liệu đối chiếu tồn kho.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!isEditor((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn chỉ có quyền xem đối chiếu tồn kho.");
            return;
        }
        Integer redirectId = optionalInt(request.getParameter("sessionId"));
        try {
            int actorId = (Integer) session.getAttribute("userId");
            String action = request.getParameter("action");
            if ("create".equals(action)) {
                redirectId = service.create(trim(request.getParameter("location")), trim(request.getParameter("note")), actorId);
                success(session, "Đã tạo phiên kiểm kê.");
            } else if ("start".equals(action)) {
                service.start(requiredInt(request.getParameter("sessionId")), actorId); success(session, "Đã bắt đầu kiểm đếm.");
            } else if ("scan".equals(action)) {
                service.scan(requiredInt(request.getParameter("sessionId")), trim(request.getParameter("barcode")), actorId);
                success(session, "Đã ghi nhận mã vạch.");
            } else if ("finish-counting".equals(action)) {
                service.finishCounting(requiredInt(request.getParameter("sessionId")), actorId); success(session, "Đã kết thúc quét và tạo danh sách chênh lệch.");
            } else if ("resolve-misplaced".equals(action)) {
                String resolutionMode = request.getParameter("resolutionMode");
                service.resolveMisplaced(requiredInt(request.getParameter("itemId")), resolutionMode, actorId);
                success(session, "return_to_expected".equals(resolutionMode)
                        ? "Đã ghi nhận bản sao được đưa về vị trí đăng ký."
                        : "Đã chuyển vị trí đăng ký của bản sao sang nơi kiểm kê.");
            } else if ("resolve-missing".equals(action)) {
                service.resolveMissing(requiredInt(request.getParameter("itemId")), actorId); success(session, "Đã tạo ghi nhận sự cố mất.");
            } else if ("resolve-unexpected".equals(action)) {
                service.resolveUnexpected(requiredInt(request.getParameter("itemId")), actorId);
                success(session, "Đã xác minh và chuyển bản sao bất thường sang quy trình phù hợp.");
            } else if ("complete".equals(action)) {
                service.complete(requiredInt(request.getParameter("sessionId")), actorId); success(session, "Đã hoàn tất phiên kiểm kê.");
            } else if ("cancel".equals(action)) {
                service.cancel(requiredInt(request.getParameter("sessionId")), actorId); success(session, "Đã hủy phiên kiểm kê.");
            } else throw new ValidationException("Thao tác không hợp lệ.");
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Không thể xử lý đối chiếu tồn kho.", e);
            session.setAttribute("errorMessage", "Không thể xử lý đối chiếu tồn kho. Vui lòng thử lại.");
        }
        String target = request.getContextPath() + "/librarian/book-management/inventory";
        if (redirectId != null) target += "?sessionId=" + redirectId;
        response.sendRedirect(target);
    }
    private void success(HttpSession session, String message) { session.setAttribute("successMessage", message); }
    private boolean isEditor(String role) { return "LIBRARIAN".equalsIgnoreCase(role); }
    private String trim(String value) { return value == null || value.trim().isEmpty() ? null : value.trim(); }
    private Integer optionalInt(String value) { try { return value == null || value.isBlank() ? null : Integer.valueOf(value); } catch (NumberFormatException e) { return null; } }
    private int requiredInt(String value) throws ValidationException { Integer id = optionalInt(value); if (id == null || id <= 0) throw new ValidationException("Mã dữ liệu không hợp lệ."); return id; }
}
