# Feature Specification: Bảng điều khiển Thủ thư (Dashboard Librarian)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp bảng thống kê và giám sát nhanh dành riêng cho Thủ thư (Librarian) ngay khi đăng nhập để theo dõi lượng giao dịch mượn/trả trong ngày, sách quá hạn, và tình trạng kho sách vật lý.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Xem thống kê giao dịch và hoạt động tại quầy.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-38 (Dashboard Data Isolation):** Mỗi Dashboard BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với vai trò của người dùng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-71 (Hiển thị Dashboard Thủ thư):** WHEN thủ thư đăng nhập và truy cập trang chủ dashboard, THE system SHALL tính toán và hiển thị: (1) Tổng số sách đang được mượn, (2) Số lượt check-out trong ngày, (3) Số lượt check-in trong ngày, (4) Số sách quá hạn hiện tại, (5) Danh sách 10 giao dịch gần nhất, (6) Thống kê tình trạng sách (tốt, hỏng, mất) vẽ biểu đồ tròn.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Trang tải nhanh dưới 500ms.\n* Độ chính xác: Số liệu giao dịch trong ngày phải được cập nhật tức thời theo thời gian thực.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord\n* `borrowRecordId` (INT, PK)\n* `status` (VARCHAR(50))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE lỗi truy xuất dữ liệu thống kê CSDL, THE system SHALL hiển thị thông báo lỗi chung và giữ nguyên giao diện khung dashboard.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Truy cập dashboard: Đăng nhập tài khoản Librarian -> Dashboard hiển thị đầy đủ 4 thẻ thống kê nhanh và biểu đồ hoạt động.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xem báo cáo tài chính chi tiết hoặc cấu hình hệ thống trên dashboard này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
