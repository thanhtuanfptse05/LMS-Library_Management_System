package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import model.User;
import service.AuthService;

/**
 * AuthFilter - Bộ lọc xác thực và phân quyền (Role-based Access Control).
 * Intercept mọi request để kiểm tra session và quyền truy cập của người dùng.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter nếu cần thiết
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        boolean isStaticResource = path.startsWith("/assets/")
                || path.startsWith("/common/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".gif")
                || path.endsWith(".svg")
                || path.endsWith(".ico")
                || path.endsWith(".woff")
                || path.endsWith(".woff2");

        // Cấm browser caching cho các trang động (chống bấm Back nút quay lại trang cũ/login)
        if (!isStaticResource) {
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);

            // [LAZY LOAD GLOBAL] Tự động quét dọn đơn đặt trước quá hạn và phạt mượn sách quá hạn cho mọi request động
            try {
                new service.ReservationExpirationProcessor().processExpiration();
                new service.OverdueProcessor().processOverdue();
            } catch (Exception e) {
                java.util.logging.Logger.getLogger(AuthFilter.class.getName())
                    .log(java.util.logging.Level.WARNING, "[LAZY LOAD GLOBAL] Lỗi khi quét tự động trong AuthFilter", e);
            }
        }

        // 0. Cho phép SePay Webhook route bypass AuthFilter (tự xác thực bằng API Key riêng)
        if ("/api/sepay-webhook".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 0b. Health check endpoint dùng cho UptimeRobot để giữ Render không sleep
        if ("/health".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 1. Kiểm tra trạng thái đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null
                && session.getAttribute("role") != null);

        if (isLoggedIn) {
            if (!isStaticResource) {
                int userId = (Integer) session.getAttribute("userId");
                UserDAO userDAO = new UserDAO();
                User user = userDAO.findByUserId(userId);

                if (user == null) {
                    // Tài khoản không còn tồn tại trong DB thì đá session ra
                    session.invalidate();
                    isLoggedIn = false;
                    session = null;
                    httpResponse.sendRedirect(contextPath + "/login?error=locked");
                    return;
                }

                if ("locked".equals(user.getStatus())) {
                    // Kiểm tra lý do khóa: nếu chỉ bị khóa do 'unpaid' hoặc 'reservation_penalty' thì cho qua
                    AuthService authService = new AuthService();
                    boolean isAllowedPenaltyLock = authService.isLockedForPenaltyAllowedLogin(userId);

                    if (!isAllowedPenaltyLock) {
                        // Bị khóa vì lý do bảo mật hoặc admin thì đá session ra
                        session.invalidate();
                        isLoggedIn = false;
                        session = null;
                        httpResponse.sendRedirect(contextPath + "/login?error=locked");
                        return;
                    }
                    // Nếu chỉ bị khóa vì phạt nợ/quá hạn đặt trước thì không đá session, cho tiếp tục vào xem trang cá nhân/thanh toán
                }
            }
        }

        String role = isLoggedIn ? (String) session.getAttribute("role") : null;

        // 2. Nếu đã đăng nhập mà cố ý truy cập lại trang /login hoặc /auth/login.jsp
        if (isLoggedIn && (path.equals("/login") || path.equals("/login/") || path.equals("/auth/login.jsp"))) {
            String redirectUrl = getRedirectByRole(contextPath, role);
            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        // 3. Phân quyền truy cập các route bảo vệ
        boolean isAdminRoute = path.startsWith("/admin/") || path.equals("/admin");
        boolean isLibrarianRoute = path.startsWith("/librarian/") || path.equals("/librarian");
        boolean isStudentRoute = path.startsWith("/student/") || path.equals("/student");
        boolean isLecturerRoute = path.startsWith("/lecturer/") || path.equals("/lecturer");
        boolean isLegacyBookManagementRoute = path.startsWith("/book-management/")
                || path.equals("/book-management")
                || path.equals("/book-management/");
        boolean isCanonicalBookManagementRoot = path.equals("/librarian/book-management")
                || path.equals("/librarian/book-management/");
        boolean isBookManagementRoute = isLegacyBookManagementRoute
                || isCanonicalBookManagementRoot
                || path.startsWith("/librarian/book-management/");

        if (isBookManagementRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            if (!"LIBRARIAN".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Chức năng quản lý sách chỉ dành cho Thủ thư.");
                return;
            }
            if (isCanonicalBookManagementRoot
                    || (isLegacyBookManagementRoute && shouldRedirectLegacyBookManagementRoute(httpRequest))) {
                httpResponse.sendRedirect(buildBookManagementRedirectUrl(httpRequest, contextPath, path,
                        isLegacyBookManagementRoute));
                return;
            }
        } else if (isAdminRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            if (!"ADMIN".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isLibrarianRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            if (!"LIBRARIAN".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isStudentRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            if (!"STUDENT".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isLecturerRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            if (!"LECTURER".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        }

        // Đi tiếp nếu hợp lệ hoặc là public route
        chain.doFilter(request, response);
    }

    /**
     * Trả về URL chuyển hướng tương ứng với vai trò của người dùng.
     */
    private String getRedirectByRole(String contextPath, String role) {
        if (role == null) {
            return contextPath + "/auth/login.jsp";
        }
        return contextPath + "/";
    }

    private boolean shouldRedirectLegacyBookManagementRoute(HttpServletRequest request) {
        String method = request.getMethod();
        return "GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method);
    }

    private String buildBookManagementRedirectUrl(HttpServletRequest request, String contextPath,
            String path, boolean legacyRoute) {
        String targetPath;
        if (legacyRoute) {
            if (path.equals("/book-management") || path.equals("/book-management/")) {
                targetPath = "/librarian/book-management/overview";
            } else {
                targetPath = "/librarian" + path;
            }
        } else {
            targetPath = "/librarian/book-management/overview";
        }
        String query = request.getQueryString();
        return contextPath + targetPath + (query == null || query.isBlank() ? "" : "?" + query);
    }

    @Override
    public void destroy() {
        // Giải phóng tài nguyên khi destroy filter
    }
}
