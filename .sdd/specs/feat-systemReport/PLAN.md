# Implementation Plan: System Report (Báo cáo hệ thống và Dashboard Manager)

**Branch**: `main` | **Date**: 2026-07-21 | **Spec**: [SPEC.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-systemReport/SPEC.md)

## Summary (Tóm tắt)
Triển khai hệ thống Báo cáo thống kê trực quan và Bảng điều khiển dành cho Quản lý Thư viện (Manager Dashboard). Hệ thống hỗ trợ phân tích xu hướng mượn trả theo Ngày/Tháng/Năm, đối chiếu doanh thu tài chính (phạt đã thu vs phạt chưa thu), thống kê kho sách và rủi ro thất thoát dựa vào kết quả kiểm kê gần nhất, và báo cáo hiệu suất hoạt động của từng thủ thư. Chức năng kết xuất Excel được xây dựng bằng Apache POI, và biểu đồ trực quan phía client sử dụng thư viện Chart.js.

## Technical Context (Bối cảnh kỹ thuật)
* **Backend:** Java 17, Java Servlet (Servlet 4.0/5.0)
* **Database:** PostgreSQL (JDBC + DAO Pattern)
* **Libraries:** Apache POI 5.2.5 (Excel Export), Chart.js (Frontend charts rendering)
* **Auth & Authorization:** Session-based authorization và `@WebFilter` (chặn bảo vệ `/manager/*`)

## Project Structure (Cấu trúc dự án thực tế)
### Source Code
```text
src/java/
├── controllers/
│   ├── ManagerDashboardServlet.java   # Controller cho Dashboard của Manager (UC-45, FR-72)
│   ├── SystemReportServlet.java       # Controller cho báo cáo xu hướng, tài chính (UC-34, FR-98, FR-99, FR-100, FR-101)
│   ├── StaffPerformanceServlet.java   # Controller cho báo cáo hiệu suất thủ thư (UC-54, FR-83)
│   └── ExportReportServlet.java       # Controller cho kết xuất báo cáo Excel (UC-35, FR-102)
├── dao/
│   ├── ReportDAO.java                 # Truy vấn dữ liệu xu hướng mượn trả, đối chiếu tài chính
│   ├── InventoryReportDAO.java        # Truy vấn dữ liệu kho sách và kết quả kiểm kê gần nhất
│   └── StaffPerformanceDAO.java       # Truy vấn dữ liệu hiệu suất của các thủ thư
├── dto/
│   ├── BorrowTrendDTO.java            # DTO chứa dữ liệu xu hướng mượn trả
│   ├── FinancialTrendDTO.java         # DTO chứa dữ liệu đối chiếu tài chính (đã thu vs chưa thu)
│   ├── InventoryResultDTO.java        # DTO chứa dữ liệu thống kê kiểm kê kho
│   ├── StaffPerformanceDTO.java       # DTO chứa dữ liệu hiệu suất thủ thư
│   └── ManagementSummaryDTO.java      # DTO tổng hợp chỉ số KPI cho Dashboard
└── service/
    └── ReportService.java             # Xử lý business logic tính toán báo cáo và xuất Excel

web/manager/                           # Giao diện dành cho Manager
├── dashboard.jsp                      # Trang Dashboard Manager (biểu đồ KPI và cảnh báo nhanh)
├── system-report.jsp                  # Trang xem báo cáo xu hướng mượn trả, tài chính, kiểm kê
├── staff-performance.jsp              # Trang xem báo cáo hiệu suất hoạt động thủ thư
└── fragments/                         # Các fragment JSP dùng chung (header, sidebar, footer)
```

## Technical Decisions & Implementation Details (Quyết định kỹ thuật & Chi tiết triển khai)
1. **Phân nhóm dữ liệu báo cáo (Grouping):** `ReportDAO` sử dụng hàm định dạng thời gian của PostgreSQL (`TO_CHAR`) để gom nhóm động theo Ngày (`YYYY-MM-DD`), Tháng (`YYYY-MM`), hoặc Năm (`YYYY`) dựa trên tham số `groupBy` từ servlet truyền xuống.
2. **Đối chiếu tài chính 2 chiều (BR-43):** Câu lệnh SQL trong `ReportDAO` thực hiện truy vấn gộp (JOIN) bảng `Fine` và `Payment` để bóc tách số tiền phạt thực tế đã thu (`Payment.status = 'completed'`) và chưa thu (`Fine.status = 'unpaid'`).
3. **Thống kê kho và kiểm kê (BR-44):** `InventoryReportDAO` thực hiện tìm kiếm đợt kiểm kê gần nhất có trạng thái `completed`. Từ đó thống kê tổng số bản sao sách khớp, bị mất (`missing`), hoặc sai vị trí để tính toán tỷ lệ thất thoát.
4. **Cô lập hiệu suất thủ thư (BR-52):** Truy vấn trong `StaffPerformanceDAO` chỉ gộp dữ liệu từ các tài khoản có vai trò là `LIBRARIAN` thông qua JOIN với bảng `Librarian` và bảng `User`.
5. **Kết xuất Excel nhất quán (BR-73):** `ReportService` và `ExportReportServlet` nhận cùng bộ tham số lọc (`startDate`, `endDate`, `groupBy`) từ giao diện để sinh ra tệp Excel (.xlsx) gồm 3 sheets chứa dữ liệu đối chiếu chính xác tương ứng.
