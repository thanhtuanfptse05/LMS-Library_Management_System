# Tasks: System Report (Báo cáo hệ thống và Dashboard Admin)

Tài liệu này theo dõi tiến độ thực hiện các công việc liên quan đến Báo cáo hệ thống và Dashboard Admin.

## Giai đoạn 1: Thiết lập Lớp Dữ liệu (Data Layer - DAO & DTO)
- [x] **Task 1.1:** Khởi tạo các DTO lưu trữ dữ liệu báo cáo: `BorrowTrendDTO`, `FinancialTrendDTO`, `InventoryResultDTO`, `StaffPerformanceDTO`, `ManagementSummaryDTO`.
- [x] **Task 1.2:** Phát triển `ReportDAO.java`:
  * `getBorrowTrendsByPeriod(startDate, endDate, groupBy)` gom nhóm mượn trả theo ngày/tháng/năm.
  * `getFinancialTrendsByPeriod(startDate, endDate)` lấy tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) (BR-43).
- [x] **Task 1.3:** Phát triển `InventoryReportDAO.java`:
  * `getCurrentInventoryStats()` lấy dữ liệu đối soát kho từ phiên kiểm kê gần nhất đã hoàn tất (BR-44).
- [x] **Task 1.4:** Phát triển `StaffPerformanceDAO.java`:
  * `getStaffPerformance(month, year)` thống kê giao dịch của từng thủ thư (role LIBRARIAN) (BR-52).
- [ ] **Task 1.5:** Viết Unit Tests (JUnit 5) kiểm tra tính đúng đắn của các câu lệnh SQL gom nhóm và tính toán thống kê trong DAO.

## Giai đoạn 2: Phát triển Lớp Logic nghiệp vụ (Service Layer)
- [x] **Task 2.1:** Triển khai `ReportService.java` xử lý:
  * Tính toán tỷ lệ tăng trưởng phần trăm (%) so với chu kỳ trước (FR-101).
  * Gọi các DAO để tổng hợp dữ liệu báo cáo.
- [x] **Task 2.2:** Tích hợp logic xuất Excel bằng Apache POI (`ReportService.java` & `ExportReportServlet.java`):
  * Sheet "Xu hướng Mượn Trả" (Gom nhóm theo ngày/tháng/năm).
  * Sheet "Đối chiếu Tài chính" (Tiền đã thu vs Tiền chưa thu) (BR-43).
  * Sheet "Báo cáo Kiểm kê" (Số sách khớp, mất, lệch kệ) (BR-44).

## Giai đoạn 3: Điều khiển & Bảo mật (Controller Layer & Filter)
- [x] **Task 3.1:** Cấu hình bảo mật phân quyền trong `AuthFilter.java` đảm bảo chỉ Admin được phép truy cập các tài nguyên báo cáo dưới đường dẫn `/admin/*`.
- [x] **Task 3.2:** Triển khai `AdminDashboardServlet.java` (UC-45, FR-72) phục vụ nạp số liệu KPI thời gian thực.
- [x] **Task 3.3:** Triển khai `SystemReportServlet.java` (UC-34, FR-98, FR-99, FR-100) tiếp nhận các tham số lọc `startDate`, `endDate`, `groupBy` và forward dữ liệu tương ứng.
- [x] **Task 3.4:** Triển khai `StaffPerformanceServlet.java` (UC-54, FR-83) xử lý nạp thống kê hiệu suất thủ thư.
- [x] **Task 3.5:** Triển khai `ExportReportServlet.java` (UC-35, FR-102) xử lý xuất tệp Excel (.xlsx).

## Giai đoạn 4: Giao diện Người dùng (View Layer - JSP)
- [x] **Task 4.1:** Thiết kế `web/admin/dashboard.jsp` hiển thị biểu đồ KPI tổng hợp và bảng cảnh báo quá hạn, sự cố.
- [x] **Task 4.2:** Thiết kế `web/admin/system-report.jsp` chứa form lọc ngày/tháng/năm, và liên kết biểu đồ Chart.js (Line/Bar Chart).
- [x] **Task 4.3:** Thiết kế `web/admin/staff-performance.jsp` hiển thị bảng dữ liệu hiệu suất Checkout/Checkin và thu tiền phạt của các thủ thư.
- [x] **Task 4.4:** Tích hợp script `Chart.js` để render các biểu đồ xu hướng mượn trả và đối chiếu tài chính động trên giao diện (FR-98, FR-99).
