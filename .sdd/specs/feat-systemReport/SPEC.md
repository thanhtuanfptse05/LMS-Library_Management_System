# Feature Specification: Báo cáo hệ thống và Dashboard Manager (System Reports)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Hỗ trợ Quản lý Thư viện (Manager) theo dõi hoạt động tổng thể của thư viện qua các biểu đồ xu hướng mượn trả, báo cáo tài chính đối chiếu tiền phạt đã thu/chưa thu, thống kê kho sách và hiệu suất của thủ thư.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Xem các báo cáo thống kê, xu hướng hoạt động, xuất báo cáo ra Excel.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-34 (View System Reports):** Actor: Library Manager, Admin | (Xem báo cáo hệ thống): Quản lý thư viện xem các báo cáo thống kê về mượn/trả, tài chính, kho sách với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Actor: Library Manager, Admin | (Xuất báo cáo): Xuất dữ liệu thống kê ra file Excel để lưu trữ hoặc phân tích offline.
* **UC-54 (View Staff Performance Report):** Actor: Library Manager | (Xem báo cáo hiệu suất nhân viên): Quản lý thư viện theo dõi số lượt giao sách, nhận sách và số tiền phạt thu được của từng thủ thư theo tháng/năm.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-45 (View Manager Dashboard):** Actor: Library Manager | (Xem bảng điều khiển quản lý): Quản lý thư viện xem các chỉ số hiệu suất tổng hợp (KPI) bao gồm xu hướng mượn trả, thống kê tài chính, tình trạng kho sách, và các cảnh báo hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-34 (View System Reports):** Actor: Library Manager, Admin | (Xem báo cáo hệ thống): Quản lý thư viện xem các báo cáo thống kê về mượn/trả, tài chính, kho sách với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Actor: Library Manager, Admin | (Xuất báo cáo): Xuất dữ liệu thống kê ra file Excel để lưu trữ hoặc phân tích offline.
* **UC-54 (View Staff Performance Report):** Actor: Library Manager | (Xem báo cáo hiệu suất nhân viên): Quản lý thư viện theo dõi số lượt giao sách, nhận sách và số tiền phạt thu được của từng thủ thư theo tháng/năm.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-45 (View Manager Dashboard):** Actor: Library Manager | (Xem bảng điều khiển quản lý): Quản lý thư viện xem các chỉ số hiệu suất tổng hợp (KPI) bao gồm xu hướng mượn trả, thống kê tài chính, tình trạng kho sách, và các cảnh báo hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-34 (View System Reports):** Actor: Library Manager, Admin | (Xem báo cáo hệ thống): Quản lý thư viện xem các báo cáo thống kê về mượn/trả, tài chính, kho sách với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Actor: Library Manager, Admin | (Xuất báo cáo): Xuất dữ liệu thống kê ra file Excel để lưu trữ hoặc phân tích offline.
* **UC-54 (View Staff Performance Report):** Actor: Library Manager | (Xem báo cáo hiệu suất nhân viên): Quản lý thư viện theo dõi số lượt giao sách, nhận sách và số tiền phạt thu được của từng thủ thư theo tháng/năm.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-45 (View Manager Dashboard):** Actor: Library Manager | (Xem bảng điều khiển quản lý): Quản lý thư viện xem các chỉ số hiệu suất tổng hợp (KPI) bao gồm xu hướng mượn trả, thống kê tài chính, tình trạng kho sách, và các cảnh báo hệ thống.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-72 (Hiển thị Dashboard Quản lý với KPI):** WHEN ManagerDashboardServlet.doGet() được gọi với filters {startDate, endDate, groupBy}, THE system SHALL: (1) **borrowTrends** = ReportDAO.getBorrowTrendsByPeriod(startDate, endDate, groupBy='day'|'week'|'month') → {date, checkoutCount, checkinCount, activeCount}, (2) **financialTrends** = ReportDAO.getFinancialTrendsByPeriod() → {date, finesCollected, finesPending, cashPayments, onlinePayments}, (3) **inventoryStats** = InventoryReportDAO.getCurrentInventoryStats() → {totalBooks, availableBooks, borrowedBooks, damagedBooks, lostBooks, topBorrowedBooks[], lowStockBooks[]}, (4) **alerts** = {overdueCount, expiredReservationsCount, unpaidFinesCount, incidentsOpenCount}, (5) Forward sang manager/dashboard.jsp với charts library (Chart.js) render trend graphs.
  * *Mapping:* UC-45 / BR-38

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Tính trực quan: Biểu đồ tải mượt mà, sử dụng các thư viện biểu đồ phía Client (Chart.js).
* Thời gian xử lý: Báo cáo tổng hợp phải hoàn thành truy vấn dưới 1.5 giây.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord
* `borrowRecordId` (INT, PK)
* `status` (VARCHAR(50))

### Bảng Fine
* `fineId` (INT, PK)
* `amount` (DECIMAL)
* `status` (VARCHAR(50))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE không có dữ liệu trong khoảng thời gian chọn, THE system SHALL hiển thị màn hình trống kèm thông báo thân thiện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Xem Dashboard: Hiển thị đúng biểu đồ xu hướng mượn trả và các thống kê KPI chính.
- [ ] Xuất Excel: File Excel chứa đúng các bảng biểu báo cáo tài chính và kho sách khớp với DB.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi báo cáo định kỳ hàng tuần/tháng qua email cho Manager.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.