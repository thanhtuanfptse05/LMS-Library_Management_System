package controllers;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ExcelExportService;
import service.ReportService;

@WebServlet(name = "ExportReportServlet", urlPatterns = {"/manager/reports/export"})
public class ExportReportServlet extends HttpServlet {

    private ReportService reportService;
    private ExcelExportService excelExportService;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        excelExportService = new ExcelExportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String groupBy = request.getParameter("groupBy");
        
        try {
            Map<String, Object> data = reportService.getDashboardData(startDate, endDate, groupBy);
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"LMS_System_Report.xlsx\"");
            
            excelExportService.exportSystemReportToExcel(data, response.getOutputStream());
            
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xuất file Excel báo cáo: " + ex.getMessage());
        }
    }
}
