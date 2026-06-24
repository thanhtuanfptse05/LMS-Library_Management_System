package controllers;

import dao.DocumentTempDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DocumentTemp;
import model.Notification;
import model.UserContactDTO;
import service.EmailService;
import service.MarkdownUtil;

/**
 * NotificationManagerServlet — Servlet quản lý Bảng tin hệ thống cho Manager.
 *
 * <p>URL Pattern: /manager/notifications</p>
 * <p>Quyền truy cập: MANAGER (kiểm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Hỗ trợ các thao tác:</p>
 * <ul>
 *   <li>GET              : Hiển thị danh sách thông báo có phân trang và lọc.</li>
 *   <li>GET action=edit  : Load form chỉnh sửa thông báo theo notificationId.</li>
 *   <li>POST action=create : Tạo thông báo mới.</li>
 *   <li>POST action=update : Cập nhật thông báo đã có.</li>
 *   <li>POST action=delete : Xóa một thông báo.</li>
 * </ul>
 *
 * <p>Ghi AuditLog: Mọi thao tác CREATE/UPDATE/DELETE đều được ghi vào AuditLogs (ARCH-02).</p>
 */
@WebServlet(name = "NotificationManagerServlet", urlPatterns = {"/manager/notifications"})
public class NotificationManagerServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(NotificationManagerServlet.class.getName());

    private static final int PAGE_SIZE = 8;
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * GET — Tải danh sách thông báo (có phân trang, lọc) và forward sang trang quản lý.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditForm(request, response);
            return;
        }

        // Đọc tham số lọc và phân trang
        String keyword    = request.getParameter("keyword");
        String typeFilter = request.getParameter("typeFilter");
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
        } catch (NumberFormatException ignored) { }

        int totalCount    = notificationDAO.countFiltered(keyword, typeFilter);
        int totalPages    = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        List<Notification> notifications = notificationDAO.getAllPaged(keyword, typeFilter, page, PAGE_SIZE);

        request.setAttribute("notifications", notifications);
        request.setAttribute("keyword",       keyword != null ? keyword : "");
        request.setAttribute("typeFilter",    typeFilter != null ? typeFilter : "");
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("totalCount",    totalCount);
        // Load danh sách mẫu email để JSP render dropdown chọn mẫu
        request.setAttribute("emailTemplates", documentTempDAO.getAll());

        request.getRequestDispatcher("/manager/manage-notifications.jsp").forward(request, response);
    }

    /**
     * POST — Xử lý tạo mới, cập nhật hoặc xóa thông báo.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        int managerId = (int) session.getAttribute("userId");

        switch (action != null ? action : "") {
            case "create" -> handleCreate(request, response, managerId);
            case "update" -> handleUpdate(request, response, managerId);
            case "delete" -> handleDelete(request, response, managerId);
            default       -> response.sendRedirect(request.getContextPath() + "/manager/notifications");
        }
    }

    // ─────────────────────────────────────────────────────────────
    // HANDLERS
    // ─────────────────────────────────────────────────────────────

    /**
     * Load form chỉnh sửa thông báo (GET action=edit).
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("notificationId");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectWithError(request, response, "ID không hợp lệ");
            return;
        }
        try {
            int notificationId = Integer.parseInt(idParam.trim());
            Notification existing = notificationDAO.findById(notificationId);
            if (existing == null) {
                redirectWithError(request, response, "Không tìm thấy thông báo");
                return;
            }
            request.setAttribute("editNotification", existing);
            // Vẫn load danh sách cho bảng bên cạnh
            request.setAttribute("notifications", notificationDAO.getAll());
            request.setAttribute("totalCount",    notificationDAO.count());
            request.setAttribute("currentPage",   1);
            request.setAttribute("totalPages",    1);
            // Load danh sách mẫu email để JSP render dropdown chọn mẫu
            request.setAttribute("emailTemplates", documentTempDAO.getAll());
            request.getRequestDispatcher("/manager/manage-notifications.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID không hợp lệ");
        }
    }

    /**
     * Xử lý tạo thông báo mới (POST action=create). Ghi AuditLog sau INSERT.
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String title    = request.getParameter("title");
        String content  = request.getParameter("content");
        String type     = request.getParameter("type");
        boolean isPinned = "on".equals(request.getParameter("isPinned"));
        boolean isSendEmail = "on".equals(request.getParameter("isSendEmail"));
        String targetRole   = request.getParameter("targetRole");
        // Mẫu email do người dùng chủ động chọn từ dropdown
        String selectedTemplateName = request.getParameter("templateName");

        if (title == null || title.trim().isEmpty()) {
            redirectWithError(request, response, "Tiêu đề không được để trống");
            return;
        }

        if (isSendEmail && (selectedTemplateName == null || selectedTemplateName.trim().isEmpty())) {
            redirectWithError(request, response, "Vui lòng chọn mẫu Email để gửi kèm");
            return;
        }

        Notification notification = new Notification();
        notification.setTitle(title.trim());
        notification.setContent(content != null ? content.trim() : "");
        notification.setType(isValidType(type) ? type : "general");
        notification.setPinned(isPinned);
        notification.setCreatedBy(managerId);

        int newId = notificationDAO.insert(notification);
        if (newId > 0) {
            notificationDAO.insertAuditLog(managerId, "CREATE_NOTIFICATION", "Notification", newId,
                    null, "title=" + title + "; type=" + type);

            // ── Gửi Email Thông Báo (Async) ──
            if (isSendEmail && selectedTemplateName != null && !selectedTemplateName.trim().isEmpty()) {
                sendNotificationEmailAsync(selectedTemplateName.trim(), targetRole, title, content);
            }

            redirectWithSuccess(request, response, "Đã đăng thông báo thành công");
        } else {
            redirectWithError(request, response, "Có lỗi xảy ra khi lưu thông báo");
        }
    }

    /**
     * Xử lý cập nhật thông báo đã có (POST action=update). Ghi AuditLog sau UPDATE.
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam  = request.getParameter("notificationId");
        String title    = request.getParameter("title");
        String content  = request.getParameter("content");
        String type     = request.getParameter("type");
        boolean isPinned = "on".equals(request.getParameter("isPinned"));
        boolean isSendEmail = "on".equals(request.getParameter("isSendEmail"));
        String targetRole   = request.getParameter("targetRole");
        // Mẫu email do người dùng chủ động chọn từ dropdown
        String selectedTemplateName = request.getParameter("templateName");

        if (idParam == null || idParam.trim().isEmpty() || title == null || title.trim().isEmpty()) {
            redirectWithError(request, response, "Dữ liệu không hợp lệ");
            return;
        }

        if (isSendEmail && (selectedTemplateName == null || selectedTemplateName.trim().isEmpty())) {
            redirectWithError(request, response, "Vui lòng chọn mẫu Email để gửi kèm");
            return;
        }

        try {
            int notificationId = Integer.parseInt(idParam.trim());
            Notification old   = notificationDAO.findById(notificationId);

            Notification updated = new Notification();
            updated.setNotificationId(notificationId);
            updated.setTitle(title.trim());
            updated.setContent(content != null ? content.trim() : "");
            updated.setType(isValidType(type) ? type : "general");
            updated.setPinned(isPinned);

            boolean success = notificationDAO.update(updated);
            if (success) {
                String oldVal = old != null ? "title=" + old.getTitle() + "; type=" + old.getType() : null;
                String newVal = "title=" + title + "; type=" + type + "; isPinned=" + isPinned;
                notificationDAO.insertAuditLog(managerId, "UPDATE_NOTIFICATION", "Notification", notificationId, oldVal, newVal);

                // ── Gửi Email Thông Báo (Async) ──
                if (isSendEmail && selectedTemplateName != null && !selectedTemplateName.trim().isEmpty()) {
                    sendNotificationEmailAsync(selectedTemplateName.trim(), targetRole, title, content);
                }

                redirectWithSuccess(request, response, "Đã cập nhật thông báo thành công");
            } else {
                redirectWithError(request, response, "Cập nhật thất bại");
            }
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID không hợp lệ");
        }
    }

    /**
     * Xử lý xóa thông báo (POST action=delete). Ghi AuditLog sau DELETE.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam = request.getParameter("notificationId");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectWithError(request, response, "ID không hợp lệ");
            return;
        }

        try {
            int notificationId = Integer.parseInt(idParam.trim());
            boolean deleted = notificationDAO.delete(notificationId);
            if (deleted) {
                notificationDAO.insertAuditLog(managerId, "DELETE_NOTIFICATION", "Notification", notificationId,
                        "id=" + notificationId, null);
                redirectWithSuccess(request, response, "Đã xóa thông báo thành công");
            } else {
                redirectWithError(request, response, "Không tìm thấy thông báo cần xóa");
            }
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID không hợp lệ");
        }
    }

    // ─────────────────────────────────────────────────────────────
    // URGENT EMAIL HELPER
    // ─────────────────────────────────────────────────────────────

    /**
     * Gửi Email Thông báo bất đồng bộ.
     * Mẫu email được xác định qua {@code tempName} do người dùng chọn từ dropdown,
     * không còn hardcode theo loại thông báo.
     *
     * @param tempName      Tên định danh mẫu Email (tempName) trong bảng DocumentTemp
     * @param targetRole    Đối tượng nhận: "STUDENT", "LECTURER" hoặc "ALL"
     * @param notifTitle    Tiêu đề thông báo để thay thế placeholder {{notificationTitle}}
     * @param notifContent  Nội dung thông báo để thay thế placeholder {{notificationContent}}
     */
    private void sendNotificationEmailAsync(String tempName, String targetRole, String notifTitle, String notifContent) {
        DocumentTemp template = documentTempDAO.findByTempName(tempName);
        if (template == null) {
            LOGGER.warning("[NOTIFICATION EMAIL] Không tìm thấy mẫu email '" + tempName + "' trong DocumentTemp. Bỏ qua gửi email.");
            return;
        }

        List<UserContactDTO> contacts;
        if ("STUDENT".equals(targetRole)) {
            contacts = userDAO.getActiveContactsByRoles("student");
        } else if ("LECTURER".equals(targetRole)) {
            contacts = userDAO.getActiveContactsByRoles("lecturer");
        } else {
            contacts = userDAO.getActiveContactsByRoles("student", "lecturer");
        }

        if (contacts.isEmpty()) {
            LOGGER.info("[NOTIFICATION EMAIL] Không có người dùng nào (role=" + targetRole + ") đang active để gửi.");
            return;
        }

        // Chuyển Markdown sang HTML một lần (dùng chung cho tất cả người nhận)
        String contentHtml = MarkdownUtil.toHtml(notifContent != null ? notifContent : "");

        LOGGER.log(Level.INFO, "[NOTIFICATION EMAIL] Bắt đầu gửi {0} email bằng mẫu {1} cho {2}.",
                new Object[]{contacts.size(), tempName, targetRole});

        for (UserContactDTO contact : contacts) {
            String displayName = (contact.getFullName() != null && !contact.getFullName().isBlank())
                    ? contact.getFullName() : "Bạn";

            String finalSubject = template.getSubject()
                    .replace("{{notificationTitle}}", notifTitle);

            String finalBody = template.getBodyContent()
                    .replace("{{userName}}", displayName)
                    .replace("{{notificationTitle}}", notifTitle)
                    .replace("{{notificationContent}}", contentHtml);

            EmailService.sendAsyncHtmlEmail(contact.getEmail(), finalSubject, finalBody);
        }
    }

    // ─────────────────────────────────────────────────────────────
    // HELPERS

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manager/notifications?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manager/notifications?success=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }

    // ─────────────────────────────────────────────────────────────

    /** Kiểm tra type hợp lệ */
    private boolean isValidType(String type) {
        return type != null && (type.equals("general") || type.equals("urgent")
                || type.equals("policy") || type.equals("event"));
    }

    /** Kiểm tra xác thực và phân quyền Manager. */
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
