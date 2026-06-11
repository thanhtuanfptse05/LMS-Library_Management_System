package controllers;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Notification;

/**
 * NotificationManagerServlet — Servlet quản lý Bảng tin hệ thống cho Manager.
 *
 * <p>URL Pattern: /manager/notifications</p>
 * <p>Quyền truy cập: MANAGER (kiểm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Hỗ trợ các thao tác:</p>
 * <ul>
 *   <li>GET: Hiển thị danh sách thông báo và form tạo mới.</li>
 *   <li>POST action=create: Manager tạo thông báo mới (Broadcast cho toàn hệ thống).</li>
 *   <li>POST action=delete: Manager xóa một thông báo cụ thể.</li>
 * </ul>
 *
 * <p>Ghi AuditLog: Mọi thao tác CREATE/DELETE đều được ghi vào bảng AuditLogs (ARCH-02).</p>
 */
@WebServlet(name = "NotificationManagerServlet", urlPatterns = {"/manager/notifications"})
public class NotificationManagerServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * GET — Tải danh sách thông báo và forward sang trang quản lý.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        List<Notification> notifications = notificationDAO.getAll();
        request.setAttribute("notifications", notifications);
        request.getRequestDispatcher("/manager/manage-notifications.jsp").forward(request, response);
    }

    /**
     * POST — Xử lý tạo mới hoặc xóa thông báo.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        int managerId = (int) session.getAttribute("userId");

        if ("create".equals(action)) {
            handleCreate(request, response, managerId);
        } else if ("delete".equals(action)) {
            handleDelete(request, response, managerId);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/notifications");
        }
    }

    /**
     * Xử lý tạo thông báo mới.
     * Ghi AuditLog sau khi INSERT thành công (ARCH-02).
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // Validation cơ bản
        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/notifications?error=Tiêu+đề+không+được+để+trống");
            return;
        }

        Notification notification = new Notification();
        notification.setTitle(title.trim());
        notification.setContent(content != null ? content.trim() : "");
        notification.setCreatedBy(managerId);

        int newId = notificationDAO.insert(notification);

        if (newId > 0) {
            // Ghi AuditLog — ARCH-02
            notificationDAO.insertAuditLog(managerId, "CREATE_NOTIFICATION", "Notification", newId,
                    null, "title=" + title);
            response.sendRedirect(request.getContextPath() + "/manager/notifications?success=Đã+đăng+thông+báo+thành+công");
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/notifications?error=Có+lỗi+xảy+ra+khi+lưu+thông+báo");
        }
    }

    /**
     * Xử lý xóa thông báo theo ID.
     * Ghi AuditLog sau khi DELETE thành công (ARCH-02).
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam = request.getParameter("notificationId");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/notifications?error=ID+không+hợp+lệ");
            return;
        }

        try {
            int notificationId = Integer.parseInt(idParam.trim());
            boolean deleted = notificationDAO.delete(notificationId);

            if (deleted) {
                // Ghi AuditLog — ARCH-02
                notificationDAO.insertAuditLog(managerId, "DELETE_NOTIFICATION", "Notification", notificationId,
                        "id=" + notificationId, null);
                response.sendRedirect(request.getContextPath() + "/manager/notifications?success=Đã+xóa+thông+báo+thành+công");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/notifications?error=Không+tìm+thấy+thông+báo+cần+xóa");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/notifications?error=ID+không+hợp+lệ");
        }
    }

    /**
     * Kiểm tra xác thực và phân quyền Manager.
     *
     * @return true nếu hợp lệ, false nếu đã redirect
     */
    private boolean isAuthorizedManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = (String) session.getAttribute("role");
        if (!"MANAGER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            return false;
        }
        return true;
    }
}
