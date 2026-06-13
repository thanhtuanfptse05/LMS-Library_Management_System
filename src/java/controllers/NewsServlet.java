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
 * NewsServlet ΓÇö Servlet hiß╗ân thß╗ï Bß║úng tin hß╗ç thß╗æng cho Student v├á Lecturer.
 *
 * <p>URL Pattern: /notifications ΓÇö D├╣ng chung cho cß║ú 2 role. Servlet tß╗▒ kiß╗âm tra
 * role trong Session ─æß╗â forward tß╗¢i ─æ├║ng trang JSP t╞░╞íng ß╗⌐ng.</p>
 *
 * <p>Quyß╗ün truy cß║¡p: STUDENT, LECTURER (kiß╗âm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>T├¡nh n─âng:</p>
 * <ul>
 *   <li>Lß║Ñy danh s├ích th├┤ng b├ío k├¿m trß║íng th├íi ─æ├ú ─æß╗ìc/ch╞░a ─æß╗ìc cß╗ºa ng╞░ß╗¥i d├╣ng.</li>
 *   <li>Hß╗ù trß╗ú ph├ón trang (pageSize=10) v├á lß╗ìc theo tß╗½ kh├│a v├á loß║íi th├┤ng b├ío.</li>
 *   <li>─É╞░a sß╗æ th├┤ng b├ío ch╞░a ─æß╗ìc v├áo session ─æß╗â hiß╗ân thß╗ï badge tr├¬n to├án hß╗ç thß╗æng.</li>
 * </ul>
 */
@WebServlet(name = "NewsServlet", urlPatterns = {"/notifications"})
public class NewsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;
    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * Xß╗¡ l├╜ GET ΓÇö Tß║úi danh s├ích th├┤ng b├ío tß╗½ DB v├á forward sang view ph├╣ hß╗úp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiß╗âm tra x├íc thß╗▒c
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Chß╗ë Student v├á Lecturer ─æ╞░ß╗úc ph├⌐p xem
        if (!"STUDENT".equalsIgnoreCase(role) && !"LECTURER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Kh├┤ng c├│ quyß╗ün truy cß║¡p trang n├áy.");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // ─Éß╗ìc tham sß╗æ lß╗ìc v├á ph├ón trang
        String keyword    = request.getParameter("keyword");
        String typeFilter = request.getParameter("typeFilter");
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
        } catch (NumberFormatException ignored) { }

        // Lß║Ñy danh s├ích th├┤ng b├ío k├¿m trß║íng th├íi ─æß╗ìc
        int totalCount = notificationDAO.countFiltered(keyword, typeFilter);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        List<Notification> notifications = notificationDAO.getAllForUser(userId, keyword, typeFilter, page, PAGE_SIZE);

        // ─Éß║┐m sß╗æ th├┤ng b├ío ch╞░a ─æß╗ìc ΓåÆ cß║¡p nhß║¡t v├áo session ─æß╗â badge hiß╗ân thß╗ï khß║»p n╞íi
        int unreadCount = notificationDAO.countUnread(userId);
        session.setAttribute("unreadNotificationCount", unreadCount);

        request.setAttribute("notifications", notifications);
        request.setAttribute("keyword",       keyword != null ? keyword : "");
        request.setAttribute("typeFilter",    typeFilter != null ? typeFilter : "");
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("totalCount",    totalCount);
        request.setAttribute("unreadCount",   unreadCount);

        // Forward tß╗¢i ─æ├║ng view theo role
        if ("LECTURER".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/lecturer/notifications.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
        }
    }
}
