package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import dto.UserDTO;
import service.UserService;

/**
 * UserListServlet — Controller hiển thị danh sách người dùng cho Admin.
 */
@WebServlet(name = "UserListServlet", urlPatterns = {"/admin/user"})
public class UserListServlet extends HttpServlet {

    private final UserService userService;

    public UserListServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Nhận tham số tìm kiếm và lọc
        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }
        
        String role = request.getParameter("role");
        if (role == null || role.trim().isEmpty()) {
            role = "ALL";
        }
        
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // Nhận tham số phân trang
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 10;
        String pageSizeStr = request.getParameter("pageSize");
        if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeStr);
                if (pageSize < 1) pageSize = 10;
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        // Lấy dữ liệu từ Service
        List<UserDTO> users = userService.getUserList(search, role, status, page, pageSize);
        int totalUsers = userService.getTotalUserCount(search, role, status);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        // Đẩy dữ liệu ra View JSP
        request.setAttribute("users", users);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("role", role);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/admin/user-list.jsp").forward(request, response);
    }
}
