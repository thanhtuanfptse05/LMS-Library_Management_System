package controllers;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * NotificationStatusServlet ΓÇö Xß╗¡ l├╜ y├¬u cß║ºu AJAX ─æ├ính dß║Ñu th├┤ng b├ío ─æ├ú ─æß╗ìc.
 *
 * <p>URL Pattern: /notification/mark-read</p>
 * <p>Quyß╗ün truy cß║¡p: STUDENT, LECTURER (─æ─âng nhß║¡p hß╗úp lß╗ç l├á ─æß╗º).</p>
 *
 * <p>Hß╗ù trß╗ú:</p>
 * <ul>
 *   <li>POST action=markOne  : ─É├ính dß║Ñu mß╗Öt th├┤ng b├ío ─æ├ú ─æß╗ìc (tham sß╗æ: notificationId)</li>
 *   <li>POST action=markAll  : ─É├ính dß║Ñu tß║Ñt cß║ú th├┤ng b├ío ─æ├ú ─æß╗ìc</li>
 * </ul>
 *
 * <p>Phß║ún hß╗ôi: JSON ─æ╞ín giß║ún { "status": "ok" } hoß║╖c { "status": "error" }</p>
 */
@WebServlet(name = "NotificationStatusServlet", urlPatterns = {"/notification/mark-read"})
public class NotificationStatusServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * POST ΓÇö ─É├ính dß║Ñu th├┤ng b├ío ─æ├ú ─æß╗ìc qua AJAX.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\",\"message\":\"Ch╞░a ─æ─âng nhß║¡p\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("markAll".equals(action)) {
            notificationDAO.markAllAsRead(userId);
            session.setAttribute("unreadNotificationCount", 0);
            out.print("{\"status\":\"ok\"}");
        } else if ("markOne".equals(action)) {
            String idParam = request.getParameter("notificationId");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"ID kh├┤ng hß╗úp lß╗ç\"}");
                return;
            }
            try {
                int notificationId = Integer.parseInt(idParam.trim());
                notificationDAO.markAsRead(userId, notificationId);
                // Trß║ú vß╗ü sß╗æ l╞░ß╗úng th├┤ng b├ío ch╞░a ─æß╗ìc cß║¡p nhß║¡t mß╗¢i
                int unreadCount = notificationDAO.countUnread(userId);
                session.setAttribute("unreadNotificationCount", unreadCount);
                out.print("{\"status\":\"ok\",\"unreadCount\":" + unreadCount + "}");
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"ID kh├┤ng hß╗úp lß╗ç\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\",\"message\":\"Action kh├┤ng hß╗úp lß╗ç\"}");
        }
    }
}
