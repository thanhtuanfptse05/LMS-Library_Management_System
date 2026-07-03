# Feature Specification: Nhật ký hoạt động và Dashboard Admin (Audit Log)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Ghi nhận và hiển thị tất cả các hành động thay đổi dữ liệu cốt lõi (Thêm, Sửa, Xóa, Import, Giao dịch) của mọi tài khoản trong hệ thống dưới dạng nhật ký kiểm toán so sánh giá trị cũ và mới chi tiết.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Xem danh sách audit log, xem chi tiết so sánh 1-1, xuất nhật ký ra Excel.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-40 (View Audit Log):** Actor: SysAdmin | (Xem Nhật ký Kiểm toán): Quản trị viên truy cập trang Nhật ký Kiểm toán để xem danh sách toàn bộ hành động thay đổi dữ liệu của người dùng, lọc theo nhiều tiêu chí, và xem chi tiết so sánh giá trị cũ/mới.
* **UC-41 (Export Audit Log):** Actor: SysAdmin | (Xuất Nhật ký Kiểm toán): Quản trị viên xuất dữ liệu Nhật ký Kiểm toán ra file Excel để phục vụ báo cáo và lưu trữ ngoài hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-46 (View Admin Dashboard):** Actor: Admin | (Xem bảng điều khiển quản trị): Quản trị viên hệ thống xem tổng quan toàn hệ thống bao gồm tổng số tài khoản, sách, tiền phạt chưa thu, giao dịch đang chờ, hoạt động gần đây và cấu hình hệ thống quan trọng.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-40 (View Audit Log):** Actor: SysAdmin | (Xem Nhật ký Kiểm toán): Quản trị viên truy cập trang Nhật ký Kiểm toán để xem danh sách toàn bộ hành động thay đổi dữ liệu của người dùng, lọc theo nhiều tiêu chí, và xem chi tiết so sánh giá trị cũ/mới.
* **UC-41 (Export Audit Log):** Actor: SysAdmin | (Xuất Nhật ký Kiểm toán): Quản trị viên xuất dữ liệu Nhật ký Kiểm toán ra file Excel để phục vụ báo cáo và lưu trữ ngoài hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-46 (View Admin Dashboard):** Actor: Admin | (Xem bảng điều khiển quản trị): Quản trị viên hệ thống xem tổng quan toàn hệ thống bao gồm tổng số tài khoản, sách, tiền phạt chưa thu, giao dịch đang chờ, hoạt động gần đây và cấu hình hệ thống quan trọng.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-40 (View Audit Log):** Actor: SysAdmin | (Xem Nhật ký Kiểm toán): Quản trị viên truy cập trang Nhật ký Kiểm toán để xem danh sách toàn bộ hành động thay đổi dữ liệu của người dùng, lọc theo nhiều tiêu chí, và xem chi tiết so sánh giá trị cũ/mới.
* **UC-41 (Export Audit Log):** Actor: SysAdmin | (Xuất Nhật ký Kiểm toán): Quản trị viên xuất dữ liệu Nhật ký Kiểm toán ra file Excel để phục vụ báo cáo và lưu trữ ngoài hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-46 (View Admin Dashboard):** Actor: Admin | (Xem bảng điều khiển quản trị): Quản trị viên hệ thống xem tổng quan toàn hệ thống bao gồm tổng số tài khoản, sách, tiền phạt chưa thu, giao dịch đang chờ, hoạt động gần đây và cấu hình hệ thống quan trọng.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-73 (Hiển thị Dashboard Admin với tổng quan hệ thống):** WHEN AdminDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu toàn hệ thống: (1) **totalBooks** = BookCopyDAO.count(null, null, null) — tổng số bản sao vật lý, (2) **totalMembers** = UserDAO.countAllUsers("", "ALL", "ALL") — tổng số tài khoản, (3) **unpaidFines** = FineDAO.getTotalUnpaidFines() — tổng tiền phạt chưa thu (VNĐ), (4) **pendingPayments** = PaymentDAO.countPendingPayments() — số giao dịch đang chờ, (5) **recentUsers** = UserService.getUserList("", "ALL", "ALL", page=1, pageSize=5) — 5 user mới nhất, (6) **recentAuditLogs** = AuditLogDAO.findWithFilters(null, page=1, pageSize=5) — 5 log gần nhất, (7) Forward sang admin/dashboard.jsp. Dashboard có quick links: "Quản lý người dùng", "Xem Audit Log", "Cấu hình hệ thống".
  * *Mapping:* UC-46 / BR-38
* **FR-74 (Hiển thị Cấu hình Quan trọng trên Admin Dashboard):** WHEN AdminDashboardServlet.doGet() render dashboard, THE system SHALL đọc SystemConfigCache để lấy các cấu hình quan trọng: (1) STUDENT_MAX_BORROW_DAYS (số ngày mượn SV), (2) LECTURER_MAX_BORROW_DAYS (số ngày mượn GV), (3) FINE_RATE_PER_DAY (tiền phạt/ngày VNĐ), (4) RESERVATION_HOLD_DAYS (số ngày giữ sách đặt trước), (5) MAX_EXTENSION_COUNT (số lần gia hạn tối đa), (6) STUDENT_MAX_BORROW_BOOKS (hạn mức sách SV), (7) LECTURER_MAX_BORROW_BOOKS (hạn mức sách GV). Hiển thị trong panel "Cấu hình Hệ thống Quan trọng" với button "Chỉnh sửa" → redirect sang /admin/system-config. WHERE cache miss: load từ DB và populate cache.
  * *Mapping:* UC-46

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Nhật ký kiểm toán là read-only đối với người dùng (kể cả Admin qua giao diện không thể xóa log).
* Ràng buộc: Giá trị thay đổi bắt buộc lưu định dạng JSON.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng AuditLogs
* `auditLogId` (INT, PK, Identity)
* `userId` (INT, FK REFERENCES "User")
* `actionType` (VARCHAR(100))
* `entityName` (VARCHAR(255))
* `entityId` (INT)
* `oldValues` (TEXT - JSON format)
* `newValues` (TEXT - JSON format)
* `timestamp` (TIMESTAMP)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE dữ liệu JSON trong log bị lỗi cú pháp, THE system SHALL hiển thị thẻ đơn kèm viền đỏ cảnh báo thay vì làm crash giao diện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Ghi nhận log: Tạo sách mới -> Hệ thống tự động insert 1 log hành động 'CREATE_BOOK' chứa JSON thông tin sách mới.
- [ ] Xem chi tiết log: Nhấn xem chi tiết cập nhật -> Modal mở ra hiển thị rõ cột trái giá trị cũ, cột phải giá trị mới song song.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa hoặc sửa đổi bất kỳ dòng nhật ký nào trong bảng AuditLogs thông qua ứng dụng web.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.