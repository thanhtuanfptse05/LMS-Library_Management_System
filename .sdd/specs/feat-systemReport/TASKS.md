# Tasks: System Report

## Giai đoạn 1: Chuẩn bị Data Layer (DAO & DTO)
- [x] 1. Tạo các DTO class phục vụ phân tích xu hướng: `BorrowTrendDTO`, `FinancialTrendDTO`, `InventoryResultDTO` (có trường lưu Ngày/Tháng/Năm).
- [x] 2. `ReportDAO.java`: Thêm `getBorrowTrends(startDate, endDate, groupBy)` dùng `SELECT COUNT` nhóm theo khoảng thời gian (Ngày/Tháng/Năm) từ `BorrowRecord`.
- [x] 3. `ReportDAO.java`: Thêm `getFinancialTrends(startDate, endDate, groupBy)` tính `SUM` phân tách làm 2 cột: Tiền phạt đã thu (`status='paid'`) và Tiền phạt chưa thu (`status='unpaid'`).
- [x] 4. Tạo `InventoryReportDAO.java`: Thêm `getLatestInventoryStats()` lấy dữ liệu từ `InventorySession` gần nhất (số lượng khớp, mất, sai vị trí).
- [ ] 5. Viết Unit Tests (JUnit 5) kiểm tra tính đúng đắn của các Group By SQL.

## Giai đoạn 2: Business Logic & Export Service
- [x] 6. `ReportService.java`: Viết logic tính toán tỷ lệ tăng/giảm (%) giữa các ngày/tháng để đưa ra Text nhận xét chiều hướng cho View hiển thị.
- [x] 7. `ExcelExportService.java`: 
    - [x] 7.1. Sheet "Xu Hướng Mượn Trả" (Nhóm theo ngày/tháng/năm).
    - [x] 7.2. Sheet "Đối Chiếu Tài Chính" (Đã thu vs Chưa thu).
    - [x] 7.3. Sheet "Báo Cáo Kiểm Kê" (Tình trạng kho sách theo đợt).

## Giai đoạn 3: Controllers & Security Filter
- [x] 8. Kiểm tra `AuthFilter.java` phân quyền `/manager/reports/*`.
- [x] 9. `SystemReportServlet.java`: Xử lý GET request, bắt các param `startDate`, `endDate`, `groupBy` (day/month/year). Forward kết quả sang `system-report.jsp`.
- [x] 10. `ExportReportServlet.java`: Xử lý xuất file với `application/vnd.ms-excel` hoặc `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`.

## Giai đoạn 4: Frontend (JSP & Biểu đồ)
- [x] 11. `system-report.jsp`: Thiết kế giao diện chứa Form bộ lọc (Thời gian và Tiêu chí nhóm).
- [x] 12. Tích hợp `Chart.js`:
    - [x] Biểu đồ Cột (Bar Chart) thể hiện sự mượn/trả.
    - [x] Biểu đồ Đường (Line Chart) so sánh Tiền đã thu và chưa thu.
- [x] 13. Hiển thị thông điệp phân tích dữ liệu kho sách.
