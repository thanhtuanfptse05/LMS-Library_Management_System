# Feature Specification: System Report (Báo Cáo Hệ Thống)
# Version: 1.1 (DRAFT) | Chủ sở hữu: @antigravity | Ngày cập nhật: 2026-06-22
# Mapping: UC-34, UC-35 | BR: (none global) | FR: (nội bộ: FR-RPT-01..FR-RPT-05 — xem spec file)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng System Report cung cấp công cụ báo cáo và biểu đồ thống kê để theo dõi mượn/trả, tài chính, kho sách. Hệ thống cung cấp khả năng phân tích dữ liệu và xu hướng (trends) theo nhiều mốc thời gian (Ngày/Tháng/Năm) để LibraryManager nắm bắt được sự thay đổi, dự đoán xu hướng và ra quyết định vận hành hiệu quả.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **LibraryManager (Quản lý thư viện):** Có quyền truy cập toàn bộ các báo cáo thống kê, xem phân tích và xuất báo cáo ra file Excel.
* **Admin (Quản trị viên):** Có thể xem các báo cáo tổng quan.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **[BR-RPT-01]:** Dữ liệu thống kê tài chính phải minh bạch cả 2 chiều: đối chiếu "Tiền phạt đã thu" (`status = 'paid'`) và "Tiền phạt chưa thu" (`status = 'unpaid'`).
* **[BR-RPT-02]:** Dữ liệu kho sách bắt buộc phải đối chiếu dựa trên dữ liệu từ đợt kiểm kê gần nhất (`InventorySession` và `InventoryItem`).
* **[BR-RPT-03]:** Hệ thống phải cung cấp dữ liệu phân nhóm linh hoạt theo **Ngày, Tháng, Năm** để hỗ trợ phân tích chiều hướng phát triển (tăng/giảm).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **[FR-RPT-01]:** WHEN LibraryManager xem báo cáo mượn trả, THE system SHALL hiển thị biểu đồ xu hướng theo (Ngày/Tháng/Năm) tùy người dùng lựa chọn.
* **[FR-RPT-02]:** WHEN xem báo cáo tài chính, THE system SHALL hiển thị biểu đồ đối chiếu giữa tổng tiền phạt đã thu và chưa thu.
* **[FR-RPT-03]:** WHEN xem báo cáo kho sách, THE system SHALL truy xuất kết quả đợt kiểm kê gần nhất (số lượng khớp, thiếu, sai vị trí) để đưa ra tỷ lệ thất thoát.
* **[FR-RPT-04]:** THE system SHALL tính toán tỷ lệ tăng/giảm so với chu kỳ trước đó để hiển thị thông điệp nhận xét xu hướng.
* **[FR-RPT-05]:** THE system SHALL xuất toàn bộ số liệu thống kê ra file Excel.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** API/Servlet xử lý Báo cáo phải được bảo vệ bởi `@WebFilter` kiểm tra role hợp lệ. Sử dụng `PreparedStatement` chặn SQL Injection.
* **Giao diện (UI/UX):** Sử dụng **Chart.js** để vẽ biểu đồ đường (Line Chart) cho xu hướng thời gian, Bar/Pie cho tồn kho và tài chính.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
Sử dụng các lệnh truy vấn phức tạp kết hợp `GROUP BY` thời gian:
* `BorrowRecord` (lọc theo khoảng thời gian và nhóm theo day/month/year).
* `Fine`, `Payment` (join để lấy số tiền paid và unpaid).
* `InventorySession`, `InventoryItem`, `BookCopy` (truy vấn kết quả kiểm kê).
