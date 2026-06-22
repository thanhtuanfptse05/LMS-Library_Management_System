# Tasks: System Report

## Giai đoạn 1: Chuẩn bị Data Layer (DAO & DTO)
- [ ] 1. Tạo các DTO class phục vụ phân tích xu hướng: `BorrowTrendDTO`, `FinancialTrendDTO`, `InventoryResultDTO` (có trường lưu Ngày/Tháng/Năm).
- [ ] 2. `ReportDAO.java`: Thêm `getBorrowTrends(startDate, endDate, groupBy)` dùng `SELECT COUNT` nhóm theo khoảng thời gian (Ngày/Tháng/Năm) từ `BorrowRecord`.
- [ ] 3. `ReportDAO.java`: Thêm `getFinancialTrends(startDate, endDate, groupBy)` tính `SUM` phân tách làm 2 cột: Tiền phạt đã thu (`status='paid'`) và Tiền phạt chưa thu (`status='unpaid'`).
- [ ] 4. Tạo `InventoryReportDAO.java`: Thêm `getLatestInventoryStats()` lấy dữ liệu từ `InventorySession` gần nhất (số lượng khớp, mất, sai vị trí).
- [ ] 5. Viết Unit Tests (JUnit 5) kiểm tra tính đúng đắn của các Group By SQL.

## Giai đoạn 2: Business Logic & Export Service
- [ ] 6. `ReportService.java`: Viết logic tính toán tỷ lệ tăng/giảm (%) giữa các ngày/tháng để đưa ra Text nhận xét chiều hướng cho View hiển thị.
- [ ] 7. `ExcelExportService.java`: 
    - [ ] 7.1. Sheet "Xu Hướng Mượn Trả" (Nhóm theo ngày/tháng/năm).
    - [ ] 7.2. Sheet "Đối Chiếu Tài Chính" (Đã thu vs Chưa thu).
    - [ ] 7.3. Sheet "Báo Cáo Kiểm Kê" (Tình trạng kho sách theo đợt).

## Giai đoạn 3: Controllers & Security Filter
- [ ] 8. Kiểm tra `AuthFilter.java` phân quyền `/manager/reports/*`.
- [ ] 9. `SystemReportServlet.java`: Xử lý GET request, bắt các param `startDate`, `endDate`, `groupBy` (day/month/year). Forward kết quả sang `dashboard.jsp`.
- [ ] 10. `ExportReportServlet.java`: Xử lý xuất file với `application/vnd.ms-excel`.

## Giai đoạn 4: Frontend (JSP & Biểu đồ)
- [ ] 11. `dashboard.jsp`: Thiết kế giao diện chứa Form bộ lọc (Thời gian và Tiêu chí nhóm).
- [ ] 12. Tích hợp `Chart.js`:
    - [ ] Biểu đồ Đường (Line Chart) thể hiện sự tăng/giảm lượt mượn theo thời gian.
    - [ ] Biểu đồ Cột Kép (Grouped Bar Chart) so sánh Tiền đã thu và chưa thu.
    - [ ] Biểu đồ Tròn (Pie Chart) thể hiện kết quả kiểm kê.
- [ ] 13. Hiển thị thông điệp phân tích dữ liệu (VD: "Lượt mượn tháng này tăng 15% so với tháng trước").
