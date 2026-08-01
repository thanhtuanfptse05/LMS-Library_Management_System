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
        String errorParam = request.getParameter("error");
        if (errorParam != null) {
            if ("locked".equals(errorParam)) {
                request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa bởi quản trị viên.");
            }
        }
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

            // Trường hợp đặc biệt: khóa tạm do nhập sai mật khẩu (securitybreach)
            // và thời gian khóa đã hết → tự động mở khóa [Node 10.17]
            if (lockedUntil != null && !lockedUntil.after(now)) {
                userDAO.unlockAccount(user.getUserId());
                user.setStatus("active");
                user.setFailedLoginAttempts(0);
                LOGGER.log(Level.INFO, "Auto-unlocked account for user email: {0}", email);
            } else {
                // Tài khoản vẫn đang bị khóa → kiểm tra lý do
                // Nếu bị khóa do 'unpaid' hoặc 'reservation_penalty' → CHO PHÉP đăng nhập, đặt cờ cảnh báo
                if (authService.isLockedForPenaltyAllowedLogin(user.getUserId())) {
                    dao.UserLockReasonDAO userLockReasonDAO = new dao.UserLockReasonDAO();
                    if (userLockReasonDAO.hasReason(user.getUserId(), "unpaid")) {
                        request.setAttribute("unpaidWarning", true);
                    }
                    if (authService.hasReservationPenaltyLock(user.getUserId())) {
                        request.setAttribute("reservationPenaltyWarning", true);
                    }
                    LOGGER.log(Level.INFO,
                            "User {0} has status=locked for penalty (unpaid/reservation) — allowing login with warning.",
                            email);
                } else if (lockedUntil != null && lockedUntil.after(now)) {
                    // Bị khóa tạm do nhập sai mật khẩu (securitybreach), chưa hết hạn [Node 10.16]
                    request.setAttribute("errorMessage",
                            "Tài khoản bị khóa do đăng nhập sai nhiều lần. Tự động mở khóa lúc: " + lockedUntil);
                    request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                    return;
                } else {
                    // Bị khóa bởi Admin hoặc lý do bảo mật khác (lockedUntil = null + non-unpaid reason)
                    request.setAttribute("errorMessage",
                            "Tài khoản của bạn đã bị khóa bởi quản trị viên. Vui lòng liên hệ thư viện để được hỗ trợ.");
                    request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                    return;
                }
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

            // Fetch and set user's full name in session (if available)
            dao.MemberProfileDAO profileDAO = new dao.MemberProfileDAO();
            model.MemberProfile profile = profileDAO.findByUserId(user.getUserId());
            if (profile != null && profile.getFullName() != null && !profile.getFullName().trim().isEmpty()) {
                session.setAttribute("fullName", profile.getFullName());
            } else {
                // Fallback to name part of email
                String emailName = user.getEmail().contains("@") ? user.getEmail().substring(0, user.getEmail().indexOf('@')) : user.getEmail();
                session.setAttribute("fullName", emailName);
            }

            // Nếu tài khoản bị khóa chỉ do 'unpaid', chuyển flag cảnh báo vào session
            if (Boolean.TRUE.equals(request.getAttribute("unpaidWarning"))) {
                session.setAttribute("unpaidWarning", true);
                LOGGER.log(Level.WARNING,
                        "User {0} logged in with unpaid fines — account status=locked(unpaid only).", email);
            }

            LOGGER.log(Level.INFO, "User logged in successfully: {0} with role {1}", new Object[]{email, user.getRole()});

            // Kiểm tra xem người dùng có truyền tham số redirect để quay lại trang cũ không (ví dụ: book-detail?id=1)
            String redirectParam = request.getParameter("redirect");
            String redirectUrl = getRedirectByRole(request.getContextPath(), user.getRole());
            if (isSafeInternalRedirect(redirectParam)) {
                redirectUrl = request.getContextPath() + "/" + redirectParam;
            }

            // Chuyển hướng người dùng về Dashboard tương ứng hoặc trang được yêu cầu [Node 13.21, 14.23]
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
            case "STUDENT":
                return contextPath + "/student/dashboard";
            case "LECTURER":
                return contextPath + "/lecturer/dashboard";
            default:
                return contextPath + "/";
        }
    }

    private boolean isSafeInternalRedirect(String redirect) {
        if (redirect == null || redirect.isBlank()) {
            return false;
        }
        String value = redirect.trim();
        return !value.startsWith("/")
                && !value.startsWith("\\")
                && !value.contains("://")
                && !value.contains("..")
                && !value.contains("\r")
                && !value.contains("\n");
    }
}
