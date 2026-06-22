# Implementation Plan: System Report

**Branch**: `main` | **Date**: 2026-06-22 | **Spec**: [SPEC.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-systemReport/SPEC.md)

## Summary
Triển khai Báo cáo thống kê với các chức năng phân tích xu hướng theo Ngày/Tháng/Năm. 
Sử dụng Chart.js để render biểu đồ hiển thị chiều hướng thay đổi. Báo cáo tài chính sẽ hiển thị đối chiếu cả tiền đã thu và chưa thu. Kho sách được thống kê dựa vào kết quả đối soát của đợt kiểm kê (`InventorySession`).

## Technical Context
**Language/Version**: Java 17, Servlet 4.0/5.0, JSP
**Primary Dependencies**: JDBC, Apache POI 5.2.5 (Excel), **Chart.js (Frontend UI)**
**Storage**: PostgreSQL (Supabase)

## Project Structure
### Source Code
```text
src/
├── java/
│   ├── controllers/
│   │   ├── SystemReportServlet.java
│   │   └── ExportReportServlet.java
│   ├── dao/
│   │   ├── ReportDAO.java
│   │   └── InventoryReportDAO.java
│   ├── dto/
│   │   ├── BorrowTrendDTO.java
│   │   ├── FinancialTrendDTO.java
│   │   └── InventoryResultDTO.java
│   └── service/
│       ├── ReportService.java
│       └── ExcelExportService.java
web/
├── views/
│   └── report/
│       ├── dashboard.jsp
│       └── components/
│           ├── filter-form.jsp
│           └── chart-scripts.jsp
```

**Structure Decision**: 
* Thêm các hàm tính toán xu hướng (%) trong `ReportService` để đẩy ra `dashboard.jsp` giúp người dùng có cái nhìn tổng quát về sự biến động.
* Tạo thêm `InventoryReportDAO.java` để chuyên trách xử lý SQL join với `InventorySession` (do query phức tạp).
