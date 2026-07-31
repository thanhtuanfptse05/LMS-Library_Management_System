package controllers;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ReportService;

@WebServlet(name = "SystemReportServlet", urlPatterns = {"/admin/reports/dashboard"})
public class SystemReportServlet extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String groupBy = request.getParameter("groupBy");
        
        try {
            Map<String, Object> data = reportService.getDashboardData(startDate, endDate, groupBy);
            
            request.setAttribute("startDate", data.get("startDate"));
            request.setAttribute("endDate", data.get("endDate"));
            request.setAttribute("groupBy", data.get("groupBy"));
            request.setAttribute("borrowTrends", data.get("borrowTrends"));
            request.setAttribute("financialTrends", data.get("financialTrends"));
            request.setAttribute("inventoryStats", data.get("inventoryStats"));
            
            request.getRequestDispatcher("/admin/system-report.jsp").forward(request, response);
            
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi tải báo cáo: " + ex.getMessage());
        }
    }
}
