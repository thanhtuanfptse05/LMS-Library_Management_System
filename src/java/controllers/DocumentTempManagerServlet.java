package controllers;

import dao.DocumentTempDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.DocumentTemp;

/**
 * DocumentTempManagerServlet ΓÇö Servlet quß║ún l├╜ Mß║½u Email cho Manager.
 *
 * <p>URL Pattern: /manager/email-templates</p>
 * <p>Quyß╗ün truy cß║¡p: MANAGER (kiß╗âm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Hß╗ù trß╗ú c├íc thao t├íc:</p>
 * <ul>
 *   <li>GET: Hiß╗ân thß╗ï danh s├ích mß║½u Email.</li>
 *   <li>GET action=edit&amp;tempId=X: Hiß╗ân thß╗ï form chß╗ënh sß╗¡a mß╗Öt mß║½u Email.</li>
 *   <li>POST action=update: L╞░u lß║íi nß╗Öi dung mß║½u Email ─æ├ú sß╗¡a.</li>
 * </ul>
 *
 * <p>Ghi AuditLog: Thao t├íc UPDATE ghi v├áo bß║úng AuditLogs (ARCH-02).</p>
 */
@WebServlet(name = "DocumentTempManagerServlet", urlPatterns = {"/manager/email-templates"})
public class DocumentTempManagerServlet extends HttpServlet {

    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO(); // D├╣ng ─æß╗â ghi AuditLog

    /**
     * GET ΓÇö Hiß╗ân thß╗ï danh s├ích mß║½u Email hoß║╖c form chß╗ënh sß╗¡a.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            // Hiß╗ân thß╗ï form chß╗ënh sß╗¡a mß╗Öt mß║½u cß╗Ñ thß╗â
            String idParam = request.getParameter("tempId");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=ID+kh├┤ng+hß╗úp+lß╗ç");
                return;
            }
            try {
                int tempId = Integer.parseInt(idParam.trim());
                DocumentTemp dt = documentTempDAO.findById(tempId);
                if (dt == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=Kh├┤ng+t├¼m+thß║Ñy+mß║½u+email");
                    return;
                }
                request.setAttribute("editTemplate", dt);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=ID+kh├┤ng+hß╗úp+lß╗ç");
                return;
            }
        }

        // Lu├┤n load danh s├ích ─æß╗â hiß╗ân thß╗ï sidebar/table
        List<DocumentTemp> templates = documentTempDAO.getAll();
        request.setAttribute("templates", templates);
        request.getRequestDispatcher("/manager/manage-email-templates.jsp").forward(request, response);
    }

    /**
     * POST ΓÇö Cß║¡p nhß║¡t nß╗Öi dung mß║½u Email.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        int managerId = (int) session.getAttribute("userId");

        if ("update".equals(action)) {
            handleUpdate(request, response, managerId);
        } else if ("create".equals(action)) {
            handleCreate(request, response, managerId);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/email-templates");
        }
    }

    /**
     * Xß╗¡ l├╜ tß║ío mß╗¢i mß║½u Email (POST action=create). Ghi AuditLog sau INSERT.
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String tempName   = request.getParameter("tempName");
        String subject    = request.getParameter("subject");
        String bodyContent = request.getParameter("bodyContent");

        if (tempName == null || tempName.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()) {
            redirectTo(response, request, "error", "Dß╗» liß╗çu kh├┤ng hß╗úp lß╗ç");
            return;
        }

        DocumentTemp dt = new DocumentTemp();
        dt.setTempName(tempName.trim().toUpperCase().replace(" ", "_"));
        dt.setSubject(subject.trim());
        dt.setBodyContent(bodyContent != null ? bodyContent.trim() : "");
        dt.setManagerId(managerId);

        int newId = documentTempDAO.insert(dt);
        if (newId > 0) {
            notificationDAO.insertAuditLog(managerId, "CREATE_EMAIL_TEMPLATE", "DocumentTemp", newId,
                    null, "tempName=" + dt.getTempName() + "; subject=" + subject);
            redirectTo(response, request, "success", "─É├ú tß║ío mß║½u email th├ánh c├┤ng");
        } else {
            redirectTo(response, request, "error", "Tß║ío mß║½u thß║Ñt bß║íi hoß║╖c m├ú ─æß╗ïnh danh ─æ├ú tß╗ôn tß║íi");
        }
    }

    /**
     * Xß╗¡ l├╜ cß║¡p nhß║¡t nß╗Öi dung mß║½u Email.
     * Ghi AuditLog sau khi UPDATE th├ánh c├┤ng (ARCH-02).
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam = request.getParameter("tempId");
        String subject = request.getParameter("subject");
        String bodyContent = request.getParameter("bodyContent");

        if (idParam == null || idParam.trim().isEmpty() || subject == null || subject.trim().isEmpty()) {
            redirectTo(response, request, "error", "Dß╗» liß╗çu kh├┤ng hß╗úp lß╗ç");
            return;
        }

        try {
            int tempId = Integer.parseInt(idParam.trim());

            // Lß║Ñy dß╗» liß╗çu c┼⌐ ─æß╗â ghi AuditLog
            DocumentTemp old = documentTempDAO.findById(tempId);

            DocumentTemp dt = new DocumentTemp();
            dt.setTempId(tempId);
            dt.setSubject(subject.trim());
            dt.setBodyContent(bodyContent != null ? bodyContent.trim() : "");

            boolean updated = documentTempDAO.update(dt);

            if (updated) {
                String oldVal = old != null ? "subject=" + old.getSubject() : null;
                String newVal = "subject=" + subject;
                notificationDAO.insertAuditLog(managerId, "UPDATE_EMAIL_TEMPLATE", "DocumentTemp", tempId, oldVal, newVal);
                redirectTo(response, request, "success", "─É├ú cß║¡p nhß║¡t mß║½u email th├ánh c├┤ng");
            } else {
                redirectTo(response, request, "error", "Cß║¡p nhß║¡t thß║Ñt bß║íi");
            }
        } catch (NumberFormatException e) {
            redirectTo(response, request, "error", "ID kh├┤ng hß╗úp lß╗ç");
        }
    }

    /** Helper: redirect vß╗¢i message ─æ├ú ─æ╞░ß╗úc URL-encode ─æ├║ng chuß║⌐n UTF-8. */
    private void redirectTo(HttpServletResponse response, HttpServletRequest request,
                            String paramName, String message) throws IOException {
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/manager/email-templates?" + paramName + "=" + encoded);
    }

    /**
     * Kiß╗âm tra x├íc thß╗▒c v├á ph├ón quyß╗ün Manager.
     *
     * @return true nß║┐u hß╗úp lß╗ç, false nß║┐u ─æ├ú redirect/error
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Kh├┤ng c├│ quyß╗ün truy cß║¡p.");
            return false;
        }
        return true;
    }
}
