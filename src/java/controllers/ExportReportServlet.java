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
import dao.ReportDAO;
import dto.BorrowDetailDTO;
import dto.FinancialDetailDTO;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet(name = "ExportReportServlet", urlPatterns = {"/admin/reports/export"})
public class ExportReportServlet extends HttpServlet {

    private ReportService reportService;
    private ExcelExportService excelExportService;
    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        excelExportService = new ExcelExportService();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String groupBy = request.getParameter("groupBy");
        String exportType = request.getParameter("exportType");
        if (exportType == null || exportType.isEmpty()) {
            exportType = "summary";
        }
        
        if (startDate == null || startDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            
            if ("borrow_detail".equals(exportType)) {
                response.setHeader("Content-Disposition", "attachment; filename=\"LMS_Chi_Tiet_Muon_Tra.xlsx\"");
                List<BorrowDetailDTO> borrowData = reportDAO.getDetailedBorrowRecords(startDate, endDate);
                excelExportService.exportDetailedBorrowExcel(borrowData, response.getOutputStream());
                
            } else if ("finance_detail".equals(exportType)) {
                response.setHeader("Content-Disposition", "attachment; filename=\"LMS_Chi_Tiet_Tai_Chinh.xlsx\"");
                List<FinancialDetailDTO> financeData = reportDAO.getDetailedFinancialRecords(startDate, endDate);
                excelExportService.exportDetailedFinancialExcel(financeData, response.getOutputStream());
                
            } else {
                // Mặc định xuất báo cáo tổng hợp
                response.setHeader("Content-Disposition", "attachment; filename=\"LMS_System_Report.xlsx\"");
                Map<String, Object> data = reportService.getDashboardData(startDate, endDate, groupBy);
                excelExportService.exportSystemReportToExcel(data, response.getOutputStream());
            }
            
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xuất file Excel báo cáo: " + ex.getMessage());
        }
    }
}
