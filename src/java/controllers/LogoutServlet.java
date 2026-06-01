package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LogoutServlet — Servlet xử lý đăng xuất khỏi hệ thống.
 * Mapped tới URL: /logout
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    /**
     * doGet — Vô hiệu hóa session hiện tại và chuyển hướng về /login.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * doPost — Vô hiệu hóa session hiện tại và chuyển hướng về /login.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * Xử lý đăng xuất: Vô hiệu hóa session [Node 16.27] và chuyển hướng về /login [Node 17.28].
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Dùng getSession(false) để không tạo session mới nếu không có session
        HttpSession session = request.getSession(false);
        if (session != null) {
            String email = (String) session.getAttribute("email");
            LOGGER.log(Level.INFO, "User logging out: {0}", email != null ? email : "unknown");
            
            // Hủy session [Node 16.27]
            session.invalidate();
        }

        // Chuyển hướng người dùng về trang đăng nhập [Node 17.28]
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
