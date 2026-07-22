package service;

import dto.BorrowTrendDTO;
import dto.FinancialTrendDTO;
import dto.InventoryResultDTO;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static org.junit.Assert.*;

public class ReportServiceTest {

    private ExcelExportService excelExportService;

    @Before
    public void setUp() {
        excelExportService = new ExcelExportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testExportSystemReportToExcelSuccess() throws Exception {
        Map<String, Object> data = new HashMap<>();

        List<BorrowTrendDTO> borrowTrends = new ArrayList<>();
        BorrowTrendDTO bt = new BorrowTrendDTO();
        bt.setPeriodLabel("Tháng 06/2026");
        bt.setTotalBorrowed(150);
        bt.setTotalReturnedOnTime(140);
        bt.setTotalOverdue(10);
        borrowTrends.add(bt);
        data.getOrDefault("borrowTrends", data.put("borrowTrends", borrowTrends));

        List<FinancialTrendDTO> financialTrends = new ArrayList<>();
        FinancialTrendDTO ft = new FinancialTrendDTO();
        ft.setPeriodLabel("Tháng 06/2026");
        ft.setTotalPaid(500000);
        ft.setTotalUnpaid(50000);
        financialTrends.add(ft);
        data.put("financialTrends", financialTrends);

        InventoryResultDTO inventoryStats = new InventoryResultDTO();
        inventoryStats.setSessionId(1);
        inventoryStats.setLocation("Kệ A1");
        inventoryStats.setTotalMatched(100);
        inventoryStats.setTotalMissing(2);
        inventoryStats.setTotalMisplaced(1);
        data.put("inventoryStats", inventoryStats);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        excelExportService.exportSystemReportToExcel(data, baos);

        byte[] bytes = baos.toByteArray();
        assertTrue("File Excel sinh ra phải chứa dữ liệu bytes", bytes.length > 0);

        try (Workbook wb = new XSSFWorkbook(new ByteArrayInputStream(bytes))) {
            assertNotNull(wb.getSheet("Xu Hướng Mượn Trả"));
            assertNotNull(wb.getSheet("Đối Chiếu Tài Chính"));
            assertNotNull(wb.getSheet("Báo Cáo Kiểm Kê"));
        }
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testExportSystemReportWithEmptyDataMap() throws Exception {
        Map<String, Object> emptyData = new HashMap<>();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        excelExportService.exportSystemReportToExcel(emptyData, baos);

        byte[] bytes = baos.toByteArray();
        assertTrue("Workbook phải khởi tạo thành công dù map dữ liệu rỗng", bytes.length > 0);
    }
}
