package controllers;

import dao.UserDAO;
import model.User;
import util.GoogleSSOUtil;
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

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/login-google"})
public class GoogleLoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleLoginServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            // Chuyển hướng người dùng sang trang đăng nhập của Google
            response.sendRedirect(GoogleSSOUtil.getLoginUrl());
            return;
        }

        // Xử lý callback từ Google
        try {
            // 1. Đổi code lấy Access Token
            String accessToken = GoogleSSOUtil.getToken(code);
            
            // 2. Dùng Access Token lấy thông tin User (Email)
            String email = GoogleSSOUtil.getUserEmail(accessToken);
            
            // 3. Kiểm tra email trong hệ thống (Phương án A: Không tự động tạo tài khoản)
            User user = userDAO.findByEmail(email);
            
            if (user == null) {
                // Trả về thông báo lỗi thay vì tạo tài khoản mới
                request.setAttribute("errorMessage", "Tài khoản Google (" + email + ") chưa được liên kết với hệ thống. Vui lòng liên hệ Admin.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            
            // 4. Kiểm tra trạng thái tài khoản
            if ("locked".equals(user.getStatus())) {
                Timestamp lockedUntil = user.getLockedUntil();
                Timestamp now = new Timestamp(System.currentTimeMillis());

                if (lockedUntil != null && lockedUntil.after(now)) {
                    request.setAttribute("errorMessage", "Tài khoản bị khóa do đăng nhập sai nhiều lần. Tự động mở khóa lúc: " + lockedUntil);
                    request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                    return;
                } else {
                    userDAO.unlockAccount(user.getUserId());
                    user.setStatus("active");
                    user.setFailedLoginAttempts(0);
                    LOGGER.log(Level.INFO, "Auto-unlocked account for user email via Google SSO: {0}", email);
                }
            }

            // 5. Đăng nhập thành công -> Set Session
            userDAO.resetFailedAttempts(user.getUserId());

            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("email", user.getEmail());

            LOGGER.log(Level.INFO, "User logged in successfully via Google SSO: {0} with role {1}", new Object[]{email, user.getRole()});

            String redirectUrl = getRedirectByRole(request.getContextPath(), user.getRole());
            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during Google SSO Login", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi xác thực với Google. Vui lòng thử lại.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }

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
                return contextPath + "/";
            default:
                return contextPath + "/login";
        }
    }
}
