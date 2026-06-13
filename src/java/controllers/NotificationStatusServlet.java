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
 * NotificationStatusServlet — Xử lý yêu cầu AJAX đánh dấu thông báo đã đọc.
 *
 * <p>URL Pattern: /notification/mark-read</p>
 * <p>Quyền truy cập: STUDENT, LECTURER (đăng nhập hợp lệ là đủ).</p>
 *
 * <p>Hỗ trợ:</p>
 * <ul>
 *   <li>POST action=markOne  : Đánh dấu một thông báo đã đọc (tham số: notificationId)</li>
 *   <li>POST action=markAll  : Đánh dấu tất cả thông báo đã đọc</li>
 * </ul>
 *
 * <p>Phản hồi: JSON đơn giản { "status": "ok" } hoặc { "status": "error" }</p>
 */
@WebServlet(name = "NotificationStatusServlet", urlPatterns = {"/notification/mark-read"})
public class NotificationStatusServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * POST — Đánh dấu thông báo đã đọc qua AJAX.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\",\"message\":\"Chưa đăng nhập\"}");
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
                out.print("{\"status\":\"error\",\"message\":\"ID không hợp lệ\"}");
                return;
            }
            try {
                int notificationId = Integer.parseInt(idParam.trim());
                notificationDAO.markAsRead(userId, notificationId);
                // Trả về số lượng thông báo chưa đọc cập nhật mới
                int unreadCount = notificationDAO.countUnread(userId);
                session.setAttribute("unreadNotificationCount", unreadCount);
                out.print("{\"status\":\"ok\",\"unreadCount\":" + unreadCount + "}");
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"ID không hợp lệ\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\",\"message\":\"Action không hợp lệ\"}");
        }
    }
}
