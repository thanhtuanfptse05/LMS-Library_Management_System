# Feature Specification: Báo cáo hệ thống và Dashboard Manager (System Reports)
# Version: 1.1 | Chủ sở hữu: @antigravity | Ngày cập nhật: 2026-07-21

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Hỗ trợ Quản lý Thư viện (Library Manager) và Admin theo dõi hoạt động tổng thể của thư viện qua các biểu đồ xu hướng mượn trả, báo cáo tài chính đối chiếu tiền phạt đã thu/chưa thu, thống kê kho sách từ đợt kiểm kê gần nhất và báo cáo hiệu suất hoạt động của các thủ thư.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Xem Dashboard quản lý (xu hướng mượn trả, tài chính, kho sách, các cảnh báo); xem báo cáo thống kê chi tiết; xem báo cáo hiệu suất nhân viên thủ thư; xuất các báo cáo ra file Excel.
* **Quản trị viên (Admin):** Có quyền truy cập tương tự Manager đối với các báo cáo hệ thống và xuất báo cáo để phục vụ công tác giám sát hệ thống toàn diện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-34 (View System Reports):** Actor: Library Manager, Admin | (Xem báo cáo hệ thống): Quản lý thư viện xem các báo cáo thống kê về mượn/trả, tài chính, kho sách với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Actor: Library Manager, Admin | (Xuất báo cáo): Xuất dữ liệu thống kê ra file Excel để lưu trữ hoặc phân tích offline.
* **UC-45 (View Manager Dashboard):** Actor: Library Manager | (Xem bảng điều khiển quản lý): Quản lý thư viện xem các chỉ số hiệu suất tổng hợp (KPI) bao gồm xu hướng mượn trả, thống kê tài chính, tình trạng kho sách, và các cảnh báo hệ thống.
* **UC-54 (View Staff Performance Report):** Actor: Library Manager | (Xem báo cáo hiệu suất nhân viên): Quản lý thư viện theo dõi số lượt giao sách, nhận sách và số tiền phạt thu được của từng thủ thư theo tháng/năm.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-38 (Dashboard Data Isolation):** Mỗi Dashboard (Admin/Manager/Librarian/Student/Lecturer) BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với role của người dùng. Dashboard KHÔNG ĐƯỢC PHÉP truy xuất hoặc hiển thị dữ liệu ngoài phạm vi quyền hạn của role.
* **BR-43 (System Report Integrity):** Dữ liệu thống kê tài chính BẮT BUỘC hiển thị song song cả 2 chiều: tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) để phục vụ đối chiếu minh bạch.
* **BR-44 (System Report Inventory Reconciliation):** Dữ liệu kho sách hiển thị trong báo cáo quản lý bắt buộc phải đối chiếu dựa trên dữ liệu từ đợt kiểm kê gần nhất.
* **BR-45 (System Report Granularity):** Hệ thống phải cung cấp dữ liệu báo cáo phân nhóm linh hoạt theo Ngày, Tháng, Năm để hỗ trợ phân tích chiều hướng phát triển (tăng/giảm) của thư viện.
* **BR-52 (Librarian Performance Isolation):** Báo cáo hiệu suất nhân viên chỉ thống kê các giao dịch được thực hiện bởi các tài khoản có vai trò là LIBRARIAN.
* **BR-73 (Report Export Consistency):** Hệ thống SHALL đảm bảo báo cáo xuất ra khớp chính xác với bộ lọc đang kích hoạt trên giao diện.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-72 (Hiển thị Dashboard Quản lý với KPI):** WHEN ManagerDashboardServlet.doGet() được gọi với filters {startDate, endDate, groupBy}, THE system SHALL: (1) **borrowTrends** = ReportDAO.getBorrowTrendsByPeriod(startDate, endDate, groupBy='day'|'week'|'month') → {date, checkoutCount, checkinCount, activeCount}, (2) **financialTrends** = ReportDAO.getFinancialTrendsByPeriod() → {date, finesCollected, finesPending, cashPayments, onlinePayments}, (3) **inventoryStats** = InventoryReportDAO.getCurrentInventoryStats() → {totalBooks, availableBooks, borrowedBooks, damagedBooks, lostBooks, topBorrowedBooks[], lowStockBooks[]}, (4) **alerts** = {overdueCount, expiredReservationsCount, unpaidFinesCount, incidentsOpenCount}, (5) Forward sang manager/dashboard.jsp với charts library (Chart.js) render trend graphs.
  * *Mapping:* UC-45 / BR-38
* **FR-83 (Xem báo cáo hiệu suất nhân viên):** WHEN StaffPerformanceServlet.doGet() được gọi với month và year chọn lựa (mặc định tháng/năm hiện tại), THE system SHALL: (1) Gọi StaffPerformanceDAO.getStaffPerformance() để tính toán số lần Checkout, Checkin, và tổng tiền phạt đã thu của từng tài khoản LIBRARIAN trong khoảng thời gian đó, (2) Gọi getMonthTotals() lấy tổng toàn hệ thống, (3) Forward sang staff-performance.jsp để hiển thị bảng dữ liệu.
  * *Mapping:* UC-54 / BR-52
* **FR-98 (Hiển thị biểu đồ xu hướng mượn trả):** WHEN SystemReportServlet nhận tham số biểu đồ mượn trả, THE system SHALL truy vấn số lượng mượn/trả qua ReportDAO.getBorrowTrendsByPeriod(), phân nhóm theo Ngày/Tháng/Năm, và render dữ liệu dưới dạng JSON để Chart.js hiển thị biểu đồ đường (Line Chart).
  * *Mapping:* UC-34 / BR-45
* **FR-99 (Hiển thị biểu đồ đối chiếu tài chính):** WHEN hiển thị báo cáo tài chính, THE system SHALL gọi ReportDAO.getFinancialTrendsByPeriod() để lấy dữ liệu đối chiếu số tiền phạt đã thu và chưa thu, vẽ biểu đồ Pie/Bar Chart.
  * *Mapping:* UC-34 / BR-43
* **FR-100 (Truy xuất báo cáo kho sách và kiểm kê):** WHEN hiển thị báo cáo kho sách, THE system SHALL truy vấn kết quả đợt kiểm kê gần nhất từ bảng InventorySession và InventoryItem để tính toán số sách khớp, mất, sai vị trí, đưa ra tỷ lệ thất thoát.
  * *Mapping:* UC-34 / BR-44
* **FR-101 (Tính toán tỷ lệ tăng trưởng):** THE system SHALL tự động so sánh số liệu của chu kỳ hiện tại (ngày/tháng/năm) với chu kỳ trước đó để tính tỷ lệ % tăng/giảm và hiển thị nhận xét xu hướng trên giao diện.
  * *Mapping:* UC-34
* **FR-102 (Xuất báo cáo hệ thống ra Excel):** WHEN ExportReportServlet.doGet() được gọi, THE system SHALL tập hợp dữ liệu thống kê từ ReportService, ghi vào tệp Excel (.xlsx) thông qua Apache POI và ghi nhận AuditLog(EXPORT_REPORT).
  * *Mapping:* UC-35 / BR-73

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Tính trực quan:** Biểu đồ hiển thị mượt mà, sử dụng các thư viện biểu đồ phía Client (Chart.js), hỗ trợ tooltip và tương tác lọc động.
* **Hiệu năng:** Thời gian phản hồi và xử lý của các truy vấn tổng hợp báo cáo (Report Queries) phải được tối ưu hóa để hoàn thành dưới 1.5 giây.
* **Ngôn ngữ:** Tất cả các nhãn, báo cáo, file Excel xuất ra, và thông báo lỗi bắt buộc phải sử dụng tiếng Việt 100%.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord (Giao dịch Mượn/Trả)
* `borrowRecordId` (INT, PK)
* `userId` (INT, FK)
* `bookCopyId` (INT, FK)
* `startDate` (TIMESTAMP)
* `endDate` (TIMESTAMP)
* `returnedAt` (TIMESTAMP)
* `status` (VARCHAR(50)) - 'borrowed', 'returned', 'overdue'
* `createdBy` (INT, FK)

### Bảng Fine (Khoản phạt)
* `fineId` (INT, PK)
* `borrowRecordId` (INT, FK)
* `amount` (DECIMAL)
* `status` (VARCHAR(50)) - 'unpaid', 'paid'

### Bảng Payment (Thanh toán)
* `paymentId` (INT, PK)
* `fineId` (INT, FK)
* `paidAmount` (DECIMAL)
* `status` (VARCHAR(50)) - 'pending', 'completed'
* `paidAt` (TIMESTAMP)
* `processedBy` (INT, FK)

### Bảng InventorySession (Phiên kiểm kê)
* `inventorySessionId` (INT, PK)
* `location` (VARCHAR(100))
* `status` (VARCHAR(50)) - 'completed', 'cancelled', 'in_progress', 'created'
* `completedAt` (TIMESTAMP)

### Bảng InventoryItem (Bản sao kiểm kê)
* `inventoryItemId` (INT, PK)
* `inventorySessionId` (INT, FK)
* `bookCopyId` (INT, FK)
* `result` (VARCHAR(50)) - 'scanned', 'missing', 'resolved'

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE không có dữ liệu báo cáo trong khoảng thời gian được chọn, THE system SHALL hiển thị màn hình trống kèm thông báo thân thiện: "Không có dữ liệu thống kê trong khoảng thời gian được chọn".
* WHERE xảy ra lỗi kết nối CSDL hoặc thư viện Apache POI khi xuất Excel, THE system SHALL ghi log lỗi, rollback transaction (nếu có), hiển thị thông báo lỗi bằng tiếng Việt cho người dùng: "Đã xảy ra lỗi khi tạo tệp Excel. Vui lòng thử lại sau".

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] **Manager Dashboard:** Hiển thị đúng các biểu đồ đường về xu hướng mượn trả và các KPI hoạt động chính (số sách đang lưu hành, sách quá hạn, số tiền phạt chưa thu).
- [ ] **Báo cáo đối chiếu tài chính:** Biểu đồ đối chiếu hiển thị chính xác cả hai chiều: tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid), khớp 100% với dữ liệu database.
- [ ] **Báo cáo kho sách:** Dữ liệu kho sách hiển thị phải được đối chiếu dựa trên dữ liệu từ phiên kiểm kê gần nhất đã hoàn tất (`status = 'completed'`).
- [ ] **Báo cáo hiệu suất thủ thư:** Thống kê đúng số lượng giao dịch Checkout, Checkin và tiền phạt thu được của từng nhân viên thủ thư (`role = 'LIBRARIAN'`) theo khoảng thời gian lọc.
- [ ] **Xuất Excel:** File Excel (.xlsx) xuất ra chứa dữ liệu khớp chính xác với bộ lọc đang chọn trên giao diện và ghi nhận Audit Log tương ứng.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi email báo cáo định kỳ hàng tuần/tháng cho Library Manager.
* Tích hợp thuật toán trí tuệ nhân tạo (AI) để dự báo xu hướng mượn sách trong tương lai.

## 10. Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Toàn bộ cấu trúc báo cáo và Dashboard đã được triển khai đồng bộ và tối ưu hóa hiệu năng truy vấn trên PostgreSQL Supabase.