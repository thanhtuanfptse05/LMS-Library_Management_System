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
 * ForgotPasswordServlet — Servlet xử lý GET/POST cho luồng Quên mật khẩu & Đặt lại mật khẩu.
 * Mapped tới URL: /forgot-password
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private final AuthService authService = new AuthService();
    private final UserDAO userDAO = new UserDAO();

    /**
     * doGet — Hiển thị trang tương ứng (Quên mật khẩu hoặc Đặt lại mật khẩu).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        if ("reset".equals(step)) {
            request.getRequestDispatcher("/auth/reset-password.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        }
    }

    /**
     * doPost — Tiếp nhận và xử lý yêu cầu reset mật khẩu hoặc đổi mật khẩu.
     * Trả về kết quả JSON để hỗ trợ AJAX Fetch.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if ("reset".equals(action)) {
            handleResetPassword(request, response);
        } else {
            handleForgotPasswordRequest(request, response);
        }
    }

    private void handleForgotPasswordRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Email không được bỏ trống.\"}");
            return;
        }

        email = email.trim();

        // 1. Tìm kiếm User theo email
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // Chống Timing Attack
            authService.runDummyVerify();

            // Chống User Enumeration: Trả về Fake Success
            LOGGER.log(Level.INFO, "Forgot password requested for non-existent email: {0}. Returning fake success.", email);
            response.getWriter().write("{\"success\":true,\"message\":\"Yêu cầu cấp lại mật khẩu đã được gửi tới Admin. Đang chuyển hướng bạn tới trang Đặt lại mật khẩu...\"}");
            return;
        }

        try {
            // 2. Thực hiện sinh mật khẩu tạm thời -> cập nhật DB
            String rawPassword = authService.resetPassword(email);

            if (rawPassword != null) {
                // 3. Gửi email bất đồng bộ tới ADMIN
                String adminEmail = "admin1@lms.com"; // Theo database seed admin
                EmailService.sendAsyncPasswordReset(adminEmail, "Yêu cầu đặt lại mật khẩu từ " + email + ". Mật khẩu tạm thời là: " + rawPassword);
                LOGGER.log(Level.INFO, "Password reset request logged. Temp password generated and email sent asynchronously to Admin for user: {0}", email);
            }

            response.getWriter().write("{\"success\":true,\"message\":\"Yêu cầu cấp lại mật khẩu đã được gửi tới Admin. Đang chuyển hướng bạn tới trang Đặt lại mật khẩu...\"}");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xảy ra trong quá trình reset mật khẩu cho email: " + email, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống khi reset mật khẩu.\"}");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String tempPassword = request.getParameter("tempPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || email.trim().isEmpty()
                || tempPassword == null || tempPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Mọi thông tin bắt buộc đều phải điền đầy đủ.\"}");
            return;
        }

        email = email.trim();

        // 1. Kiểm tra mật khẩu mới khớp nhau
        if (!newPassword.equals(confirmPassword)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Xác nhận mật khẩu không khớp.\"}");
            return;
        }

        // 2. Kiểm tra chính sách mật khẩu (tối thiểu 8 ký tự, bao gồm chữ và số)
        boolean isValidPolicy = newPassword.length() >= 8 
                && newPassword.matches(".*[a-zA-Z].*") 
                && newPassword.matches(".*[0-9].*");
        if (!isValidPolicy) {
            response.getWriter().write("{\"success\":false,\"message\":\"Mật khẩu mới không đáp ứng tiêu chuẩn bảo mật.\"}");
            return;
        }

        // 3. Tìm kiếm người dùng
        User user = userDAO.findByEmail(email);
        if (user == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Email không tồn tại trong hệ thống.\"}");
            return;
        }

        // 4. Đối chiếu mật khẩu tạm thời
        boolean isTempCorrect = authService.verifyPassword(tempPassword, user.getPasswordHash());
        if (!isTempCorrect) {
            response.getWriter().write("{\"success\":false,\"message\":\"Mã xác nhận (Mật khẩu tạm thời) từ Admin không chính xác.\"}");
            return;
        }

        try {
            // 5. Mã hóa BCrypt mật khẩu mới và cập nhật DB
            String hashedNew = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt(10));
            userDAO.updatePasswordHash(user.getUserId(), hashedNew);

            // 6. Ghi Audit Log vào CSDL
            userDAO.insertAuditLog(user.getUserId(), "CHANGE_PASSWORD", "User", user.getUserId(), null, "Password updated successfully via reset flow.");

            LOGGER.log(Level.INFO, "User {0} successfully reset their password via verification code flow.", email);
            response.getWriter().write("{\"success\":true,\"message\":\"Đặt lại mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới.\"}");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xảy ra trong quá trình đặt lại mật khẩu cho email: " + email, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống khi đặt lại mật khẩu.\"}");
        }
    }
}
