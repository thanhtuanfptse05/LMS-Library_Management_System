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
 * NotificationManagerServlet ΓÇö Servlet quß║ún l├╜ Bß║úng tin hß╗ç thß╗æng cho Manager.
 *
 * <p>URL Pattern: /manager/notifications</p>
 * <p>Quyß╗ün truy cß║¡p: MANAGER (kiß╗âm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Hß╗ù trß╗ú c├íc thao t├íc:</p>
 * <ul>
 *   <li>GET              : Hiß╗ân thß╗ï danh s├ích th├┤ng b├ío c├│ ph├ón trang v├á lß╗ìc.</li>
 *   <li>GET action=edit  : Load form chß╗ënh sß╗¡a th├┤ng b├ío theo notificationId.</li>
 *   <li>POST action=create : Tß║ío th├┤ng b├ío mß╗¢i.</li>
 *   <li>POST action=update : Cß║¡p nhß║¡t th├┤ng b├ío ─æ├ú c├│.</li>
 *   <li>POST action=delete : X├│a mß╗Öt th├┤ng b├ío.</li>
 * </ul>
 *
 * <p>Ghi AuditLog: Mß╗ìi thao t├íc CREATE/UPDATE/DELETE ─æß╗üu ─æ╞░ß╗úc ghi v├áo AuditLogs (ARCH-02).</p>
 */
@WebServlet(name = "NotificationManagerServlet", urlPatterns = {"/manager/notifications"})
public class NotificationManagerServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(NotificationManagerServlet.class.getName());

    private static final int PAGE_SIZE = 8;
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * GET ΓÇö Tß║úi danh s├ích th├┤ng b├ío (c├│ ph├ón trang, lß╗ìc) v├á forward sang trang quß║ún l├╜.
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

        // ─Éß╗ìc tham sß╗æ lß╗ìc v├á ph├ón trang
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

        request.getRequestDispatcher("/manager/manage-notifications.jsp").forward(request, response);
    }

    /**
     * POST ΓÇö Xß╗¡ l├╜ tß║ío mß╗¢i, cß║¡p nhß║¡t hoß║╖c x├│a th├┤ng b├ío.
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

    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    // HANDLERS
    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ

    /**
     * Load form chß╗ënh sß╗¡a th├┤ng b├ío (GET action=edit).
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("notificationId");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectWithError(request, response, "ID kh├┤ng hß╗úp lß╗ç");
            return;
        }
        try {
            int notificationId = Integer.parseInt(idParam.trim());
            Notification existing = notificationDAO.findById(notificationId);
            if (existing == null) {
                redirectWithError(request, response, "Kh├┤ng t├¼m thß║Ñy th├┤ng b├ío");
                return;
            }
            request.setAttribute("editNotification", existing);
            // Vß║½n load danh s├ích cho bß║úng b├¬n cß║ính
            request.setAttribute("notifications", notificationDAO.getAll());
            request.setAttribute("totalCount",    notificationDAO.count());
            request.setAttribute("currentPage",   1);
            request.setAttribute("totalPages",    1);
            request.getRequestDispatcher("/manager/manage-notifications.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID kh├┤ng hß╗úp lß╗ç");
        }
    }

    /**
     * Xß╗¡ l├╜ tß║ío th├┤ng b├ío mß╗¢i (POST action=create). Ghi AuditLog sau INSERT.
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String title    = request.getParameter("title");
        String content  = request.getParameter("content");
        String type     = request.getParameter("type");
        boolean isPinned = "on".equals(request.getParameter("isPinned"));

        if (title == null || title.trim().isEmpty()) {
            redirectWithError(request, response, "Ti├¬u ─æß╗ü kh├┤ng ─æ╞░ß╗úc ─æß╗â trß╗æng");
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

            // ΓöÇΓöÇ Gß╗¡i Email Khß║⌐n Cß║Ñp (Async) nß║┐u loß║íi l├á urgent ΓöÇΓöÇ
            if ("urgent".equals(type)) {
                sendUrgentEmailAsync(title, content);
            }

            redirectWithSuccess(request, response, "─É├ú ─æ─âng th├┤ng b├ío th├ánh c├┤ng");
        } else {
            redirectWithError(request, response, "C├│ lß╗ùi xß║úy ra khi l╞░u th├┤ng b├ío");
        }
    }

    /**
     * Xß╗¡ l├╜ cß║¡p nhß║¡t th├┤ng b├ío ─æ├ú c├│ (POST action=update). Ghi AuditLog sau UPDATE.
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam  = request.getParameter("notificationId");
        String title    = request.getParameter("title");
        String content  = request.getParameter("content");
        String type     = request.getParameter("type");
        boolean isPinned = "on".equals(request.getParameter("isPinned"));

        if (idParam == null || idParam.trim().isEmpty() || title == null || title.trim().isEmpty()) {
            redirectWithError(request, response, "Dß╗» liß╗çu kh├┤ng hß╗úp lß╗ç");
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

                // ΓöÇΓöÇ Gß╗¡i Email Khß║⌐n Cß║Ñp (Async) nß║┐u loß║íi l├á urgent sau khi cß║¡p nhß║¡t ΓöÇΓöÇ
                if ("urgent".equals(type)) {
                    sendUrgentEmailAsync(title, content);
                }

                redirectWithSuccess(request, response, "─É├ú cß║¡p nhß║¡t th├┤ng b├ío th├ánh c├┤ng");
            } else {
                redirectWithError(request, response, "Cß║¡p nhß║¡t thß║Ñt bß║íi");
            }
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID kh├┤ng hß╗úp lß╗ç");
        }
    }

    /**
     * Xß╗¡ l├╜ x├│a th├┤ng b├ío (POST action=delete). Ghi AuditLog sau DELETE.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam = request.getParameter("notificationId");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectWithError(request, response, "ID kh├┤ng hß╗úp lß╗ç");
            return;
        }

        try {
            int notificationId = Integer.parseInt(idParam.trim());
            boolean deleted = notificationDAO.delete(notificationId);
            if (deleted) {
                notificationDAO.insertAuditLog(managerId, "DELETE_NOTIFICATION", "Notification", notificationId,
                        "id=" + notificationId, null);
                redirectWithSuccess(request, response, "─É├ú x├│a th├┤ng b├ío th├ánh c├┤ng");
            } else {
                redirectWithError(request, response, "Kh├┤ng t├¼m thß║Ñy th├┤ng b├ío cß║ºn x├│a");
            }
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "ID kh├┤ng hß╗úp lß╗ç");
        }
    }

    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    // URGENT EMAIL HELPER
    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ

    /**
     * Gß╗¡i Email Th├┤ng b├ío Khß║⌐n cß║Ñp bß║Ñt ─æß╗ông bß╗Ö tß╗¢i to├án bß╗Ö STUDENT v├á LECTURER ─æang active.
     * Sß╗¡ dß╗Ñng mß║½u email c├│ t├¬n ─æß╗ïnh danh 'URGENT_NOTIFICATION' tß╗½ bß║úng DocumentTemp.
     * Nß╗Öi dung Markdown ─æ╞░ß╗úc chuyß╗ân ─æß╗òi sang HTML tr╞░ß╗¢c khi gß╗¡i.
     *
     * @param notifTitle   Ti├¬u ─æß╗ü th├┤ng b├ío (replace v├áo {{notificationTitle}})
     * @param notifContent Nß╗Öi dung th├┤ng b├ío dß║íng Markdown (replace v├áo {{notificationContent}})
     */
    private void sendUrgentEmailAsync(String notifTitle, String notifContent) {
        DocumentTemp template = documentTempDAO.findByTempName("URGENT_NOTIFICATION");
        if (template == null) {
            LOGGER.warning("[URGENT EMAIL] Kh├┤ng t├¼m thß║Ñy mß║½u email 'URGENT_NOTIFICATION' trong DocumentTemp. Bß╗Å qua gß╗¡i email.");
            return;
        }

        List<UserContactDTO> contacts = userDAO.getActiveContactsByRoles("STUDENT", "LECTURER");
        if (contacts.isEmpty()) {
            LOGGER.info("[URGENT EMAIL] Kh├┤ng c├│ STUDENT hoß║╖c LECTURER n├áo ─æang active ─æß╗â gß╗¡i.");
            return;
        }

        // Chuyß╗ân Markdown sang HTML mß╗Öt lß║ºn (d├╣ng chung cho tß║Ñt cß║ú ng╞░ß╗¥i nhß║¡n)
        String contentHtml = MarkdownUtil.toHtml(notifContent != null ? notifContent : "");

        LOGGER.log(Level.INFO,
                "[URGENT EMAIL] Bß║»t ─æß║ºu gß╗¡i {0} email khß║⌐n cß║Ñp cho STUDENT/LECTURER.",
                contacts.size());

        for (UserContactDTO contact : contacts) {
            String displayName = (contact.getFullName() != null && !contact.getFullName().isBlank())
                    ? contact.getFullName() : "Bß║ín";

            String finalSubject = template.getSubject()
                    .replace("{{notificationTitle}}", notifTitle);

            String finalBody = template.getBodyContent()
                    .replace("{{userName}}", displayName)
                    .replace("{{notificationTitle}}", notifTitle)
                    .replace("{{notificationContent}}", contentHtml);

            EmailService.sendAsyncHtmlEmail(contact.getEmail(), finalSubject, finalBody);
        }
    }

    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    // HELPERS

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manager/notifications?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manager/notifications?success=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }

    // ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ

    /** Kiß╗âm tra type hß╗úp lß╗ç */
    private boolean isValidType(String type) {
        return type != null && (type.equals("general") || type.equals("urgent")
                || type.equals("policy") || type.equals("event"));
    }

    /** Kiß╗âm tra x├íc thß╗▒c v├á ph├ón quyß╗ün Manager. */
    private boolean isAuthorizedManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        String role = (String) session.getAttribute("role");
        if (!"MANAGER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Kh├┤ng c├│ quyß╗ün truy cß║¡p.");
            return false;
        }
        return true;
    }
}
