package controllers;

import config.SystemConfigCache;
import dao.BookCopyDAO;
import dao.UserDAO;
import dao.FineDAO;
import dao.PaymentDAO;
import dao.AuditLogDAO;
import dto.AuditLogDTO;
import util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.UserDTO;
import service.UserService;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Lấy danh sách 5 tài khoản người dùng thực tế từ DB để hiển thị
        List<UserDTO> adminUsers = userService.getUserList("", "ALL", "ALL", 1, 5);
        request.setAttribute("adminUsers", adminUsers);

        // 2. Lấy dữ liệu thống kê thật cho 4 ô KPI
        BookCopyDAO bookCopyDAO = new BookCopyDAO();
        UserDAO userDAO = new UserDAO();
        FineDAO fineDAO = new FineDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        int totalBooks = 0;
        int totalMembers = 0;
        BigDecimal unpaidFines = BigDecimal.ZERO;
        int pendingPayments = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            totalBooks = bookCopyDAO.count(null, null, null);
            totalMembers = userDAO.countAllUsers("", "ALL", "ALL");
            unpaidFines = fineDAO.getTotalUnpaidFines(conn);
            pendingPayments = paymentDAO.countPendingPayments(conn);
        } catch (Exception e) {
            java.util.logging.Logger.getLogger(AdminDashboardServlet.class.getName())
                .log(java.util.logging.Level.SEVERE, "Lỗi khi lấy dữ liệu thống kê Dashboard", e);
        }

        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("unpaidFines", unpaidFines);
        request.setAttribute("pendingPayments", pendingPayments);

        // 3. Lấy 5 bản ghi Audit Log thực tế mới nhất từ DB
        List<AuditLogDTO> auditLogs = null;
        try {
            auditLogs = auditLogDAO.findWithFilters(null, null, null, null, null, null, 1, 5);
        } catch (Exception e) {
            java.util.logging.Logger.getLogger(AdminDashboardServlet.class.getName())
                .log(java.util.logging.Level.SEVERE, "Lỗi khi lấy dữ liệu audit logs Dashboard", e);
        }
        request.setAttribute("auditLogs", auditLogs);

        // 4. Lấy cấu hình hệ thống thực tế từ Cache (Database)
        Map<String, String> sysConfig = new HashMap<>();
        sysConfig.put("maxLoanDays", SystemConfigCache.get(getServletContext(), "STUDENT_MAX_BORROW_DAYS"));
        sysConfig.put("penaltyRate", SystemConfigCache.get(getServletContext(), "FINE_RATE_PER_DAY"));

        String holdDaysStr = SystemConfigCache.get(getServletContext(), "RESERVATION_HOLD_DAYS");
        sysConfig.put("reservationHoldDays", holdDaysStr != null ? holdDaysStr : "3");
        if (holdDaysStr != null) {
            try {
                int hours = Integer.parseInt(holdDaysStr) * 24;
                sysConfig.put("reservationExpiryHrs", String.valueOf(hours));
            } catch (NumberFormatException e) {
                sysConfig.put("reservationExpiryHrs", "72");
            }
        } else {
            sysConfig.put("reservationExpiryHrs", "72");
        }
        
        sysConfig.put("autoRenewLimit", SystemConfigCache.get(getServletContext(), "MAX_EXTENSION_COUNT"));
        request.setAttribute("sysConfig", sysConfig);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

