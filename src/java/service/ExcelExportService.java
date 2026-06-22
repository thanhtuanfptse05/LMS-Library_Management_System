package service;

import dto.BorrowDetailDTO;
import dto.FinancialDetailDTO;
import dto.BorrowTrendDTO;
import dto.FinancialTrendDTO;
import dto.InventoryResultDTO;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelExportService {
    
    @SuppressWarnings("unchecked")
    public void exportSystemReportToExcel(Map<String, Object> data, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            
            // Cấu hình style Header
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            // Sheet 1: Borrow Trends
            Sheet borrowSheet = workbook.createSheet("Xu Hướng Mượn Trả");
            List<BorrowTrendDTO> borrowTrends = (List<BorrowTrendDTO>) data.get("borrowTrends");
            if (borrowTrends != null) {
                Row headerRow = borrowSheet.createRow(0);
                createCell(headerRow, 0, "Thời Gian", headerStyle);
                createCell(headerRow, 1, "Tổng Lượt Mượn", headerStyle);
                createCell(headerRow, 2, "Trả Đúng Hạn", headerStyle);
                createCell(headerRow, 3, "Quá Hạn", headerStyle);
                
                int rowNum = 1;
                for (BorrowTrendDTO dto : borrowTrends) {
                    Row row = borrowSheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(dto.getPeriodLabel());
                    row.createCell(1).setCellValue(dto.getTotalBorrowed());
                    row.createCell(2).setCellValue(dto.getTotalReturnedOnTime());
                    row.createCell(3).setCellValue(dto.getTotalOverdue());
                }
                for(int i=0; i<=3; i++) borrowSheet.autoSizeColumn(i);
            }
            
            // Sheet 2: Financial Trends
            Sheet financialSheet = workbook.createSheet("Đối Chiếu Tài Chính");
            List<FinancialTrendDTO> financialTrends = (List<FinancialTrendDTO>) data.get("financialTrends");
            if (financialTrends != null) {
                Row headerRow = financialSheet.createRow(0);
                createCell(headerRow, 0, "Thời Gian", headerStyle);
                createCell(headerRow, 1, "Tiền Đã Thu", headerStyle);
                createCell(headerRow, 2, "Tiền Chưa Thu", headerStyle);
                
                int rowNum = 1;
                for (FinancialTrendDTO dto : financialTrends) {
                    Row row = financialSheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(dto.getPeriodLabel());
                    row.createCell(1).setCellValue(dto.getTotalPaid());
                    row.createCell(2).setCellValue(dto.getTotalUnpaid());
                }
                for(int i=0; i<=2; i++) financialSheet.autoSizeColumn(i);
            }

            // Sheet 3: Inventory
            Sheet inventorySheet = workbook.createSheet("Báo Cáo Kiểm Kê");
            InventoryResultDTO inventoryStats = (InventoryResultDTO) data.get("inventoryStats");
            if (inventoryStats != null) {
                Row headerRow = inventorySheet.createRow(0);
                createCell(headerRow, 0, "Mã Đợt", headerStyle);
                createCell(headerRow, 1, "Ngày Hoàn Thành", headerStyle);
                createCell(headerRow, 2, "Vị Trí", headerStyle);
                createCell(headerRow, 3, "Sách Khớp", headerStyle);
                createCell(headerRow, 4, "Sách Thiếu", headerStyle);
                createCell(headerRow, 5, "Sai Vị Trí", headerStyle);

                Row row = inventorySheet.createRow(1);
                row.createCell(0).setCellValue(inventoryStats.getSessionId());
                row.createCell(1).setCellValue(inventoryStats.getCompletedAt() != null ? inventoryStats.getCompletedAt().toString() : "");
                row.createCell(2).setCellValue(inventoryStats.getLocation());
                row.createCell(3).setCellValue(inventoryStats.getTotalMatched());
                row.createCell(4).setCellValue(inventoryStats.getTotalMissing());
                row.createCell(5).setCellValue(inventoryStats.getTotalMisplaced());
                
                for(int i=0; i<=5; i++) inventorySheet.autoSizeColumn(i);
            }

            workbook.write(out);
        }
    }
    
    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    public void exportDetailedBorrowExcel(List<BorrowDetailDTO> data, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            Sheet sheet = workbook.createSheet("Chi Tiết Mượn Sách");
            Row headerRow = sheet.createRow(0);
            String[] columns = {"Mã Thẻ", "Họ và Tên", "Tên Sách", "Mã Vạch", "Ngày Mượn", "Hạn Trả", "Ngày Trả Thực Tế", "Trạng Thái"};
            for (int i = 0; i < columns.length; i++) {
                createCell(headerRow, i, columns[i], headerStyle);
            }

            int rowNum = 1;
            for (BorrowDetailDTO dto : data) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(dto.getMemberCode() != null ? dto.getMemberCode() : "");
                row.createCell(1).setCellValue(dto.getFullName() != null ? dto.getFullName() : "");
                row.createCell(2).setCellValue(dto.getBookTitle() != null ? dto.getBookTitle() : "");
                row.createCell(3).setCellValue(dto.getBarcode() != null ? dto.getBarcode() : "");
                row.createCell(4).setCellValue(dto.getStartDate() != null ? dto.getStartDate().toString() : "");
                row.createCell(5).setCellValue(dto.getEndDate() != null ? dto.getEndDate().toString() : "");
                row.createCell(6).setCellValue(dto.getReturnedAt() != null ? dto.getReturnedAt().toString() : "");
                
                String statusVn = dto.getStatus();
                if ("borrowed".equals(statusVn)) statusVn = "Đang mượn";
                else if ("returned_good".equals(statusVn)) statusVn = "Đã trả (Tốt)";
                else if ("returned_damaged".equals(statusVn)) statusVn = "Đã trả (Hỏng)";
                else if ("overdue".equals(statusVn)) statusVn = "Quá hạn";
                row.createCell(7).setCellValue(statusVn != null ? statusVn : "");
            }
            
            for(int i=0; i<columns.length; i++) sheet.autoSizeColumn(i);

            workbook.write(out);
        }
    }

    public void exportDetailedFinancialExcel(List<FinancialDetailDTO> data, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            Sheet sheet = workbook.createSheet("Chi Tiết Tài Chính");
            Row headerRow = sheet.createRow(0);
            String[] columns = {"Mã Thẻ", "Họ và Tên", "Lý Do Phạt", "Số Tiền Phạt", "Trạng Thái Phạt", "Số Tiền Đã Thu", "Phương Thức Thanh Toán", "Ngày Thu Tiền"};
            for (int i = 0; i < columns.length; i++) {
                createCell(headerRow, i, columns[i], headerStyle);
            }

            int rowNum = 1;
            for (FinancialDetailDTO dto : data) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(dto.getMemberCode() != null ? dto.getMemberCode() : "");
                row.createCell(1).setCellValue(dto.getFullName() != null ? dto.getFullName() : "");
                row.createCell(2).setCellValue(dto.getReason() != null ? dto.getReason() : "");
                row.createCell(3).setCellValue(dto.getAmount());
                
                String statusVn = dto.getFineStatus();
                if ("paid".equals(statusVn)) statusVn = "Đã thu";
                else if ("unpaid".equals(statusVn)) statusVn = "Chưa thu";
                else if ("partially_paid".equals(statusVn)) statusVn = "Thu một phần";
                row.createCell(4).setCellValue(statusVn != null ? statusVn : "");
                
                row.createCell(5).setCellValue(dto.getPaidAmount());
                row.createCell(6).setCellValue(dto.getPaymentMethod() != null ? dto.getPaymentMethod() : "");
                row.createCell(7).setCellValue(dto.getPaidAt() != null ? dto.getPaidAt().toString() : "");
            }
            
            for(int i=0; i<columns.length; i++) sheet.autoSizeColumn(i);

            workbook.write(out);
        }
    }
}
