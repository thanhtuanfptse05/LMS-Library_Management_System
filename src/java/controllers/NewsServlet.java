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
 * NewsServlet — Servlet hiển thị Bảng tin hệ thống cho Student và Lecturer.
 *
 * <p>URL Pattern: /notifications — Dùng chung cho cả 2 role. Servlet tự kiểm tra
 * role trong Session để forward tới đúng trang JSP tương ứng.</p>
 *
 * <p>Quyền truy cập: STUDENT, LECTURER (kiểm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Tính năng:</p>
 * <ul>
 *   <li>Lấy danh sách thông báo kèm trạng thái đã đọc/chưa đọc của người dùng.</li>
 *   <li>Hỗ trợ phân trang (pageSize=10) và lọc theo từ khóa và loại thông báo.</li>
 *   <li>Đưa số thông báo chưa đọc vào session để hiển thị badge trên toàn hệ thống.</li>
 * </ul>
 */
@WebServlet(name = "NewsServlet", urlPatterns = {"/notifications"})
public class NewsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;
    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * Xử lý GET — Tải danh sách thông báo từ DB và forward sang view phù hợp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra xác thực
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Chỉ Student và Lecturer được phép xem
        if (!"STUDENT".equalsIgnoreCase(role) && !"LECTURER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập trang này.");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Đọc tham số lọc và phân trang
        String keyword    = request.getParameter("keyword");
        String typeFilter = request.getParameter("typeFilter");
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
        } catch (NumberFormatException ignored) { }

        // Lấy danh sách thông báo kèm trạng thái đọc
        int totalCount = notificationDAO.countFiltered(keyword, typeFilter);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        List<Notification> notifications = notificationDAO.getAllForUser(userId, keyword, typeFilter, page, PAGE_SIZE);

        // Đếm số thông báo chưa đọc → cập nhật vào session để badge hiển thị khắp nơi
        int unreadCount = notificationDAO.countUnread(userId);
        session.setAttribute("unreadNotificationCount", unreadCount);

        request.setAttribute("notifications", notifications);
        request.setAttribute("keyword",       keyword != null ? keyword : "");
        request.setAttribute("typeFilter",    typeFilter != null ? typeFilter : "");
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("totalCount",    totalCount);
        request.setAttribute("unreadCount",   unreadCount);

        // Forward tới đúng view theo role
        if ("LECTURER".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/lecturer/notifications.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
        }
    }
}
