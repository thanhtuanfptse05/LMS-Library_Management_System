package service;

import dao.InventoryReportDAO;
import dao.ReportDAO;
import dto.BorrowTrendDTO;
import dto.FinancialTrendDTO;
import dto.InventoryResultDTO;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportService {
    private final ReportDAO reportDAO;
    private final InventoryReportDAO inventoryReportDAO;

    public ReportService() {
        this.reportDAO = new ReportDAO();
        this.inventoryReportDAO = new InventoryReportDAO();
    }

    public Map<String, Object> getDashboardData(String startDate, String endDate, String groupBy) throws Exception {
        Map<String, Object> data = new HashMap<>();
        
        // Nếu không có ngày bắt đầu, mặc định lấy từ đầu tháng
        if (startDate == null || startDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        }
        
        // Nếu không có ngày kết thúc, mặc định là ngày hôm nay
        if (endDate == null || endDate.isEmpty()) {
            endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        
        if (groupBy == null || groupBy.isEmpty()) {
            groupBy = "day"; // Mặc định nhóm theo ngày
        }
        
        List<BorrowTrendDTO> borrowTrends = reportDAO.getBorrowTrends(startDate, endDate, groupBy);
        List<FinancialTrendDTO> financialTrends = reportDAO.getFinancialTrends(startDate, endDate, groupBy);
        InventoryResultDTO inventoryStats = inventoryReportDAO.getLatestInventoryStats();
        
        data.put("startDate", startDate);
        data.put("endDate", endDate);
        data.put("groupBy", groupBy);
        data.put("borrowTrends", borrowTrends);
        data.put("financialTrends", financialTrends);
        data.put("inventoryStats", inventoryStats);
        
        return data;
    }
}
