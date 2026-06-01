package controllers;

import dao.UserDAO;
import model.User;
import service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LoginServlet — Servlet xử lý GET/POST cho luồng Đăng nhập (Login).
 * Mapped tới URL: /login
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final AuthService authService = new AuthService();
    private final UserDAO userDAO = new UserDAO();

    /**
     * doGet — Hiển thị trang đăng nhập.
     * Forward tới /auth/login.jsp
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }

    /**
     * doPost — Xử lý dữ liệu đăng nhập từ Login Form.
     * Thực hiện tuần tự các bước kiểm tra theo EARS & Activity Diagram.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 1. Kiểm tra đầu vào thô
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không được bỏ trống.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // 2. Tìm kiếm User theo email [Node 5.6]
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // Chống Timing Attack: Gọi BCrypt dummy verify để cân bằng thời gian phản hồi
            authService.runDummyVerify();

            // Chống User Enumeration: Trả về thông báo lỗi chung
            request.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra trạng thái tài khoản [Node 7.10]
        if ("locked".equals(user.getStatus())) {
            Timestamp lockedUntil = user.getLockedUntil();
            Timestamp now = new Timestamp(System.currentTimeMillis());

            if (lockedUntil != null && lockedUntil.after(now)) {
                // Tài khoản vẫn đang bị khóa tạm thời [Node 10.16]
                request.setAttribute("errorMessage", "Tài khoản bị khóa do đăng nhập sai nhiều lần. Tự động mở khóa lúc: " + lockedUntil);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            } else {
                // Đã hết thời gian khóa tạm thời -> Tự động mở khóa [Node 10.17]
                userDAO.unlockAccount(user.getUserId());
                user.setStatus("active");
                user.setFailedLoginAttempts(0);
                LOGGER.log(Level.INFO, "Auto-unlocked account for user email: {0}", email);
            }
        }

        // 4. Xác thực mật khẩu qua BCrypt [Node 11.18]
        boolean isPasswordCorrect = authService.verifyPassword(password, user.getPasswordHash());

        if (isPasswordCorrect) {
            // Đăng nhập thành công -> Reset failedLoginAttempts về 0
            userDAO.resetFailedAttempts(user.getUserId());

            // Tạo Http Session và lưu trữ các thuộc tính định danh người dùng
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("email", user.getEmail());

            LOGGER.log(Level.INFO, "User logged in successfully: {0} with role {1}", new Object[]{email, user.getRole()});

            // Chuyển hướng người dùng về Dashboard tương ứng theo vai trò [Node 13.21, 14.23]
            String redirectUrl = getRedirectByRole(request.getContextPath(), user.getRole());
            response.sendRedirect(redirectUrl);
        } else {
            // Đăng nhập thất bại -> Tăng số lần đăng nhập sai [Node 13.20]
            int failedAttempts = authService.handleFailedLogin(user);

            if (failedAttempts >= 5) {
                request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa tạm thời trong 30 phút do nhập sai mật khẩu 5 lần.");
            } else {
                request.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác. Số lần còn lại trước khi khóa: " + (5 - failedAttempts));
            }
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }

    /**
     * Trả về URL chuyển hướng tương ứng với vai trò của người dùng.
     */
    private String getRedirectByRole(String contextPath, String role) {
        if (role == null) {
            return contextPath + "/login";
        }
        switch (role.toUpperCase()) {
            case "ADMIN":
                return contextPath + "/admin/dashboard";
            case "LIBRARIAN":
                return contextPath + "/librarian/dashboard";
            case "MANAGER":
                return contextPath + "/manager/dashboard";
            case "STUDENT":
                return contextPath + "/student/dashboard";
            default:
                return contextPath + "/login";
        }
    }
}
