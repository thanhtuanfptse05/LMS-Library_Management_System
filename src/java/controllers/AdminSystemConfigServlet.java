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

@WebServlet("/admin/system-config")
public class AdminSystemConfigServlet extends HttpServlet {

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
        
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        String groupFilter = request.getParameter("group");

        try {
            List<SystemConfiguration> configs = service.getAll(groupFilter, "ADMIN");
            request.setAttribute("configs", configs);
            request.setAttribute("actorRole", "ADMIN");
            request.setAttribute("groupFilter", groupFilter);
            request.getRequestDispatcher("/admin/system-config-list.jsp").forward(request, response);
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi hệ thống khi tải danh sách cấu hình.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("userId");
        String key = request.getParameter("configKey");
        String value = request.getParameter("configValue");
        String currentGroup = request.getParameter("groupFilter");

        try {
            service.update(key, value, adminId, "ADMIN", getServletContext());
            session.setAttribute("successMessage", "Cập nhật cấu hình thành công!");
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
        }

        String redirectUrl = request.getContextPath() + "/admin/system-config";
        if (currentGroup != null && !currentGroup.isEmpty()) {
            redirectUrl += "?group=" + currentGroup;
        }
        response.sendRedirect(redirectUrl);
    }
}
