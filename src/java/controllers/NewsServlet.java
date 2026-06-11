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
 */
@WebServlet(name = "NewsServlet", urlPatterns = {"/notifications"})
public class NewsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * Xử lý GET — Tải danh sách thông báo từ DB và forward sang view phù hợp.
     *
     * @param request  HttpServletRequest
     * @param response HttpServletResponse
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

        // Lấy danh sách thông báo từ DB
        List<Notification> notifications = notificationDAO.getAll();
        request.setAttribute("notifications", notifications);

        // Forward tới đúng view theo role
        if ("LECTURER".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/lecturer/notifications.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
        }
    }
}
