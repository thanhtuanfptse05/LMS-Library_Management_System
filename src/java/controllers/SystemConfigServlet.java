package controllers;

import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.SystemConfiguration;
import service.SystemConfigService;

@WebServlet("/manager/system-config")
public class SystemConfigServlet extends HttpServlet {

    private SystemConfigService service;

    @Override
    public void init() throws ServletException {
        this.service = new SystemConfigService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"MANAGER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        try {
            List<SystemConfiguration> configs = service.getAll(null, "MANAGER");
            request.setAttribute("configs", configs);
            request.setAttribute("actorRole", "MANAGER");
            request.getRequestDispatcher("/manager/system-config-list.jsp").forward(request, response);
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi hệ thống khi tải danh sách cấu hình.");
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"MANAGER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        Integer managerId = (Integer) session.getAttribute("userId");
        String key = request.getParameter("configKey");
        String value = request.getParameter("configValue");

        try {
            service.update(key, value, managerId, "MANAGER", getServletContext());
            session.setAttribute("successMessage", "Cập nhật cấu hình thành công!");
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/manager/system-config");
    }
}
