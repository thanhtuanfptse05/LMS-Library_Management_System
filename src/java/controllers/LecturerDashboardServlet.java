package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LecturerDashboardServlet — Servlet xử lý hiển thị Dashboard cho Giảng viên.
 * Mapped tới URL: /lecturer/dashboard
 */
@WebServlet(name = "LecturerDashboardServlet", urlPatterns = {"/lecturer/dashboard"})
public class LecturerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null 
                || !"LECTURER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/lecturer/dashboard.jsp").forward(request, response);
    }
}
