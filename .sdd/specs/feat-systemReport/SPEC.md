# Feature Specification: Báo cáo & Thống kê hệ thống (System Reports & Analytics)
# Version: 1.3 | Chủ sở hữu: Quyet | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ báo cáo thống kê trực quan cho Quản trị viên (Admin) và Admin để theo dõi hiệu suất hoạt động của thư viện: tần suất mượn/trả sách, thống kê sách quá hạn, doanh thu phạt, top độc giả tích cực, top danh mục sách được mượn nhiều nhất và xuất báo cáo ra file Excel.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin) & Admin:** Truy xuất báo cáo, xem biểu đồ thống kê, xuất file Excel/CSV.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-34 (View System Reports):** Actor: Admin | (Xem báo cáo hệ thống): Quản trị viên xem các báo cáo thống kê về mượn/trả, tài chính, kho sách với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Actor: Admin | (Xuất báo cáo): Xuất dữ liệu thống kê ra file Excel để lưu trữ hoặc phân tích offline.
* **UC-54 (View Staff Performance Report):** Actor: Admin | (Xem báo cáo hiệu suất nhân viên): Quản trị viên theo dõi số lượt giao sách, nhận sách và số tiền phạt thu được của từng thủ thư theo tháng/năm.
* **UC-45 (View Admin Dashboard):** Actor: Admin | (Xem bảng điều khiển quản lý): Quản trị viên xem các chỉ số hiệu suất tổng hợp (KPI) bao gồm xu hướng mượn trả, thống kê tài chính, tình trạng kho sách, và các cảnh báo hệ thống.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F11 System Reports, F16 Dashboard — Admin. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-43 (System Report Integrity):** Dữ liệu thống kê tài chính BẮT BUỘC hiển thị song song cả 2 chiều: tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) để phục vụ đối chiếu minh bạch.
* **BR-44 (Inventory Reconciliation Data):** Dữ liệu kiểm kê gần nhất phải đủ để đối chiếu số lượng/vị trí bản sao trong báo cáo quản lý. Trong F13, quy tắc này được đáp ứng bằng InventorySession và InventoryItem; việc hiển thị báo cáo quản trị tổng hợp thuộc feature báo cáo nếu có.
* **BR-45 (System Report Granularity):** Hệ thống phải cung cấp dữ liệu báo cáo phân nhóm linh hoạt theo Ngày, Tháng, Năm để hỗ trợ phân tích chiều hướng phát triển (tăng/giảm) của thư viện.
* **BR-52 (Librarian Performance Isolation):** Báo cáo hiệu suất nhân viên chỉ thống kê các giao dịch được thực hiện bởi các tài khoản có vai trò là LIBRARIAN.
* **BR-73 (Report Export Consistency):** The system SHALL ensure exported reports exactly match the active filters in the UI.
* **BR-81 (Performance Metric Scope):** The system SHALL calculate staff performance metrics based exclusively on transactions executed by Librarian roles.
* **BR-38 (Dashboard Data Isolation):** Mỗi Dashboard (Admin/Librarian/Student/Lecturer) BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với role của người dùng. Dashboard KHÔNG ĐƯỢC PHÉP truy xuất hoặc hiển thị dữ liệu ngoài phạm vi quyền hạn của role.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-98 (Hiển thị biểu đồ xu hướng mượn trả):** WHEN SystemReportServlet nhận tham số biểu đồ mượn trả, THE system SHALL truy vấn số lượng mượn/trả qua ReportDAO.getBorrowTrendsByPeriod(), phân nhóm theo Ngày/Tháng/Năm, và render dữ liệu dưới dạng JSON để Chart.js hiển thị biểu đồ đường (Line Chart).
  * *Mapping:* UC-34 / BR-45
* **FR-99 (Hiển thị biểu đồ đối chiếu tài chính):** WHEN hiển thị báo cáo tài chính, THE system SHALL gọi ReportDAO.getFinancialTrendsByPeriod() để lấy dữ liệu đối chiếu số tiền phạt đã thu và chưa thu, vẽ biểu đồ Pie/Bar Chart.
  * *Mapping:* UC-34 / BR-43
* **FR-100 (Truy xuất báo cáo kho sách và kiểm kê):** WHEN hiển thị báo cáo kho sách, THE system SHALL truy vấn kết quả đợt kiểm kê gần nhất từ bảng InventorySession và InventoryItem để tính toán số sách khớp, mất, sai vị trí, đưa ra tỷ lệ thất thoát.
  * *Mapping:* UC-34 / BR-44
* **FR-101 (Tính toán tỷ lệ tăng trưởng):** THE system SHALL tự động so sánh số liệu của chu kỳ hiện tại (ngày/tháng/năm) với chu kỳ trước đó để tính tỷ lệ % tăng/giảm và hiển thị nhận xét xu hướng trên giao diện.
  * *Mapping:* UC-34
* **FR-102 (Xuất báo cáo hệ thống ra Excel):** WHEN ExportReportServlet.doGet() được gọi, THE system SHALL tập hợp dữ liệu thống kê từ ReportService, ghi vào tệp Excel (.xlsx) thông qua Apache POI và ghi nhận AuditLog(EXPORT_REPORT).
  * *Mapping:* UC-35
* **FR-83 (Xem báo cáo hiệu suất nhân viên):** WHEN StaffPerformanceServlet.doGet() được gọi với month và year chọn lựa (mặc định tháng/năm hiện tại), THE system SHALL: (1) Gọi StaffPerformanceDAO.getStaffPerformance() để tính toán số lần Checkout, Checkin, và tổng tiền phạt đã thu của từng tài khoản LIBRARIAN trong khoảng thời gian đó, (2) Gọi getMonthTotals() lấy tổng toàn hệ thống, (3) Forward sang staff-performance.jsp để hiển thị bảng dữ liệu.
  * *Mapping:* UC-54 / BR-52
* **FR-72 (Hiển thị Dashboard Quản lý với KPI):** WHEN AdminDashboardServlet.doGet() được gọi với filters {startDate, endDate, groupBy}, THE system SHALL: (1) **borrowTrends** = ReportDAO.getBorrowTrendsByPeriod(startDate, endDate, groupBy='day'|'week'|'month') → {date, checkoutCount, checkinCount, activeCount}, (2) **financialTrends** = ReportDAO.getFinancialTrendsByPeriod() → {date, finesCollected, finesPending, cashPayments, onlinePayments}, (3) **inventoryStats** = InventoryReportDAO.getCurrentInventoryStats() → {totalBooks, availableBooks, borrowedBooks, damagedBooks, lostBooks, topBorrowedBooks[], lowStockBooks[]}, (4) **alerts** = {overdueCount, expiredReservationsCount, unpaidFinesCount, incidentsOpenCount}, (5) Forward sang admin/dashboard.jsp với charts library (Chart.js) render trend graphs.
  * *Mapping:* UC-45 / BR-38


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền nghiêm ngặt chỉ Admin mới có quyền xem báo cáo.
* **Hiệu năng:** Xử lý câu truy vấn thống kê dữ liệu lớn trong dưới 500ms bằng index CSDL thích hợp.
* **Giao diện:** Đồ họa biểu đồ đẹp mắt, hỗ trợ xem trên máy tính và tablet, 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BorrowRecord`, `Fine`, `Payment`, `Book`, `Category`
* Thực hiện các câu lệnh `GROUP BY`, `COUNT()`, `SUM()`, `JOIN` tính toán số liệu.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** khoảng ngày chọn không hợp lệ (ngày bắt đầu lớn hơn ngày kết thúc), **THE system SHALL** báo lỗi "Khoảng thời gian báo cáo không hợp lệ".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-REP-01] Xem báo cáo thống kê hiển thị đúng tổng số lượt mượn, tiền phạt thu được.
- [ ] [TC-REP-02] Lọc báo cáo theo tháng/quý tính toán số liệu chính xác với dữ liệu thực tế trong DB.
- [ ] [TC-REP-03] Xuất file Excel chứa đầy đủ các bảng báo cáo tiếng Việt không bị lỗi font.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi file báo cáo hàng tuần qua email cho Ban giám hiệu.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện truy vấn báo cáo thống kê và xuất dữ liệu ra Excel.