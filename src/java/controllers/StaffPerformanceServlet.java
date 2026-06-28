package controllers;

import dao.StaffPerformanceDAO;
import dto.StaffPerformanceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * StaffPerformanceServlet — Hiển thị trang Hiệu suất Nhân viên cho Manager.
 *
 * <p>URL: /manager/staff-performance</p>
 * <p>Hỗ trợ lọc theo tháng/năm qua query param: ?month=6&year=2026</p>
 */
@WebServlet(name = "StaffPerformanceServlet", urlPatterns = {"/manager/staff-performance"})
public class StaffPerformanceServlet extends HttpServlet {

    private final StaffPerformanceDAO staffDAO = new StaffPerformanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Kiểm tra phân quyền ─────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null
                || session.getAttribute("userId") == null
                || !"MANAGER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Lấy tham số tháng/năm (mặc định = tháng hiện tại) ──────────────
        LocalDate now = LocalDate.now();
        int selectedMonth = now.getMonthValue();
        int selectedYear  = now.getYear();

        try {
            String paramMonth = request.getParameter("month");
            String paramYear  = request.getParameter("year");
            if (paramMonth != null && !paramMonth.isBlank()) {
                int m = Integer.parseInt(paramMonth);
                if (m >= 1 && m <= 12) selectedMonth = m;
            }
            if (paramYear != null && !paramYear.isBlank()) {
                int y = Integer.parseInt(paramYear);
                if (y >= 2020 && y <= now.getYear() + 1) selectedYear = y;
            }
        } catch (NumberFormatException ignored) {
            // giữ giá trị mặc định
        }

        // ── Query dữ liệu ────────────────────────────────────────────────────
        List<StaffPerformanceDTO> staffList =
                staffDAO.getStaffPerformance(selectedMonth, selectedYear, 0); // 0 = không giới hạn
        long[] totals = staffDAO.getMonthTotals(selectedMonth, selectedYear);

        // ── Set attributes cho JSP ───────────────────────────────────────────
        request.setAttribute("staffList",     staffList);
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("selectedYear",  selectedYear);
        request.setAttribute("totalIssues",   totals[0]);
        request.setAttribute("totalReturns",  totals[1]);
        request.setAttribute("totalFine",     totals[2]);
        request.setAttribute("currentYear",   now.getYear());

        request.getRequestDispatcher("/manager/staff-performance.jsp")
               .forward(request, response);
    }
}
