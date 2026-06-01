package controllers;

import dao.UserDAO;
import model.User;
import service.AuthService;
import service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ForgotPasswordServlet — Servlet xử lý GET/POST cho luồng Quên mật khẩu.
 * Mapped tới URL: /forgot-password
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private final AuthService authService = new AuthService();
    private final UserDAO userDAO = new UserDAO();

    /**
     * doGet — Hiển thị trang quên mật khẩu.
     * Forward tới /auth/forgot-password.jsp
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
    }

    /**
     * doPost — Tiếp nhận và xử lý yêu cầu reset mật khẩu.
     * Trả về kết quả JSON để hỗ trợ giao diện gửi không tải lại trang (AJAX Fetch).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (email == null || email.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Email không được bỏ trống.\"}");
            return;
        }

        email = email.trim();

        // 1. Tìm kiếm User theo email [Node 5.7]
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // Chống Timing Attack: Chạy dummy verify
            authService.runDummyVerify();

            // Chống User Enumeration: Trả về Fake Success [Node 7.11]
            LOGGER.log(Level.INFO, "Forgot password requested for non-existent email: {0}. Returning fake success.", email);
            response.getWriter().write("{\"success\":true,\"message\":\"Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới.\"}");
            return;
        }

        try {
            // 2. Thực hiện reset mật khẩu (sinh mật khẩu thô -> hash BCrypt -> cập nhật DB) [Node 7.12]
            String rawPassword = authService.resetPassword(email);

            if (rawPassword != null) {
                // 3. Gửi email bất đồng bộ chạy ngầm qua ExecutorService [Node 8.14]
                EmailService.sendAsyncPasswordReset(email, rawPassword);
                LOGGER.log(Level.INFO, "Password reset successfully. Async email sent to: {0}", email);
            }

            // Trả về kết quả thành công cho Client [Node 7.11]
            response.getWriter().write("{\"success\":true,\"message\":\"Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới.\"}");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xảy ra trong quá trình reset mật khẩu cho email: " + email, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống khi reset mật khẩu.\"}");
        }
    }
}
