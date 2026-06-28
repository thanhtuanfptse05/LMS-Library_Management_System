package controllers;

import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.NotificationDAO;
import dao.StaffPerformanceDAO;
import dao.UserDAO;
import dto.StaffPerformanceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManagerDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowDAO    = new BorrowRecordDAO();
    private final FineDAO         fineDAO      = new FineDAO();
    private final UserDAO         userDAO      = new UserDAO();
    private final StaffPerformanceDAO staffDAO = new StaffPerformanceDAO();
    private final NotificationDAO  notifDAO    = new NotificationDAO();

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

        // ── Query tất cả KPI trong một Connection ───────────────────────────
        try (Connection conn = DatabaseConnection.getConnection()) {

            // 1. Tổng số mượn trong tháng hiện tại
            int totalBorrowings = borrowDAO.countThisMonth(conn);
            request.setAttribute("totalBorrowings", formatNumber(totalBorrowings));

            // 2. Số thành viên hoạt động
            int activeMembers = userDAO.countActiveMembers(conn);
            request.setAttribute("activeMembers", formatNumber(activeMembers));

            // 3. Doanh thu tiền phạt tháng hiện tại
            BigDecimal fineRevenue = fineDAO.getTotalFineRevenueThisMonth(conn);
            request.setAttribute("fineRevenue", formatFineRevenue(fineRevenue));

            // 4. Tỷ lệ trễ hạn
            double overdueRate = borrowDAO.getOverdueRate(conn);
            request.setAttribute("overdueRate", String.format("%.1f%%", overdueRate));
            request.setAttribute("overdueRateVal", overdueRate);

            // 5. Xu hướng mượn 8 tháng gần nhất (cho biểu đồ)
            List<int[]> monthlyTrend = borrowDAO.getMonthlyTrend(conn, 8);
            request.setAttribute("monthlyTrend", monthlyTrend);

            // Tính max để chuẩn hóa chiều cao cột biểu đồ
            int maxTrend = 1;
            for (int[] row : monthlyTrend) {
                if (row[2] > maxTrend) maxTrend = row[2];
            }
            request.setAttribute("maxTrend", maxTrend);

            // 6. Top 5 nhân viên (preview cho dashboard)
            LocalDate now = LocalDate.now();
            List<StaffPerformanceDTO> staffStats =
                    staffDAO.getStaffPerformance(now.getMonthValue(), now.getYear(), 5);
            request.setAttribute("staffStats", staffStats);

            // 7. Thông báo hệ thống mới nhất (tối đa 3)
            List<?> announcements = notifDAO.getAll();
            int announcementLimit = Math.min(3, announcements.size());
            request.setAttribute("announcements", announcements.subList(0, announcementLimit));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi load Manager Dashboard", e);
            // Graceful degradation: forward JSP với null attributes → JSP dùng fallback
        }

        request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);
    }

    /** Định dạng số nguyên có dấu phẩy phân cách hàng nghìn (VD: 1,254). */
    private String formatNumber(int value) {
        return NumberFormat.getNumberInstance(Locale.US).format(value);
    }

    /**
     * Định dạng số tiền phạt: dưới 1 triệu hiển thị đầy đủ, từ 1 triệu trở lên rút gọn (VD: 2.4M).
     */
    private String formatFineRevenue(BigDecimal amount) {
        if (amount == null) return "0đ";
        long val = amount.longValue();
        if (val >= 1_000_000) {
            double millions = val / 1_000_000.0;
            return String.format("%.1fM", millions);
        }
        return NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(val) + "đ";
    }
}
