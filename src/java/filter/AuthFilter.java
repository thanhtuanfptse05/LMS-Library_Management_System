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

/**
 * AuthFilter — Bộ lọc xác thực và phân quyền (Role-based Access Control).
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

        // 1. Kiểm tra trạng thái đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null && session.getAttribute("role") != null);
        String role = isLoggedIn ? (String) session.getAttribute("role") : null;

        // 2. Nếu đã đăng nhập mà cố ý truy cập lại trang /login hoặc /auth/login.jsp
        if (isLoggedIn && (path.equals("/login") || path.equals("/auth/login.jsp"))) {
            String redirectUrl = getRedirectByRole(contextPath, role);
            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        // 3. Phân quyền truy cập các route bảo vệ
        boolean isAdminRoute = path.startsWith("/admin/") || path.equals("/admin");
        boolean isLibrarianRoute = path.startsWith("/librarian/") || path.equals("/librarian");
        boolean isManagerRoute = path.startsWith("/manager/") || path.equals("/manager");
        boolean isStudentRoute = path.startsWith("/student/") || path.equals("/student");

        if (isAdminRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/auth/login.jsp");
                return;
            }
            if (!"ADMIN".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isLibrarianRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/auth/login.jsp");
                return;
            }
            if (!"LIBRARIAN".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isManagerRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/auth/login.jsp");
                return;
            }
            if (!"MANAGER".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập vào chức năng này.");
                return;
            }
        } else if (isStudentRoute) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/auth/login.jsp");
                return;
            }
            if (!"STUDENT".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập vào chức năng này.");
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
                return contextPath + "/auth/login.jsp";
        }
    }

    @Override
    public void destroy() {
        // Giải phóng tài nguyên khi destroy filter
    }
}
