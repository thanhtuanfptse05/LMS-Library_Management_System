# Feature Specification: Quản lý thông báo và mẫu văn bản (Notification Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Quản lý Thư viện (Manager) tạo và phát hành thông báo hệ thống đến các vai trò độc giả, ghim thông báo quan trọng, quản lý các mẫu văn bản email tự động, và cho phép độc giả theo dõi thông báo.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Manager):** Tạo, sửa, xóa thông báo, quản lý mẫu email tự động.\n* **Độc giả (User):** Xem thông báo hệ thống, đánh dấu đã đọc thông báo.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-47 (Email Template Protection):** Các mẫu email hệ thống (RESET_PASSWORD, RESERVATION_READY, OVERDUE_NOTICE, v.v.) cấm tuyệt đối xóa khỏi hệ thống.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-44 (Quản lý & Phát hành thông báo hàng loạt):** WHEN Manager tạo thông báo mới, THE system SHALL lưu vào bảng Notification. WHERE có tùy chọn gửi email, SHALL tải email template, kết xuất nội dung và xếp hàng gửi email async đến toàn bộ độc giả hoạt động.\n* **FR-52 (Quản lý Mẫu Email Markdown):** WHEN Manager sửa template, THE system SHALL kiểm tra các placeholder bắt buộc (ví dụ: {{tempPassword}} cho mẫu reset mật khẩu). WHERE đầy đủ, SHALL cập nhật DB, ghi Audit Log và clear cache template.\n* **FR-111 (Chặn xóa mẫu email hệ thống):** WHEN Manager yêu cầu xóa mẫu email, THE system SHALL kiểm tra danh sách bảo vệ và từ chối nếu mẫu thuộc danh sách hệ thống bắt buộc.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Tính khả dụng: Hỗ trợ viết nội dung thông báo bằng định dạng Markdown.\n* Bảo mật: Phân quyền chặt chẽ chỉ Manager mới được phép chỉnh sửa mẫu email.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Notification\n* `notificationId` (INT, PK)\n* `title` (VARCHAR(500))\n* `content` (TEXT)\n* `type` (VARCHAR(50))\n* `targetRole` (VARCHAR(50))\n* `isPinned` (BOOLEAN)\n* `createdBy` (INT)\n* `createdAt` (TIMESTAMP)\n\n### Bảng UserNotificationStatus\n* `userId` (INT, PK, FK)\n* `notificationId` (INT, PK, FK)\n* `readAt` (TIMESTAMP)\n\n### Bảng DocumentTemp\n* `tempId` (INT, PK)\n* `tempName` (VARCHAR(100), UNIQUE)\n* `subject` (VARCHAR(255))\n* `bodyContent` (TEXT)\n* `managerId` (INT)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE mẫu email chỉnh sửa thiếu biến placeholder bắt buộc, THE system SHALL báo lỗi và không cho phép lưu.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo thông báo ghim thành công: Tạo thông báo mới và ghim -> Hiện lên đầu trang chủ công khai của độc giả.\n- [ ] Đọc thông báo: Độc giả nhấn xem thông báo -> Badge số lượng thông báo chưa đọc giảm đi 1.

## 9. Out of Scope (Phạm vi không thực hiện)
* Gửi thông báo riêng cho từng cá nhân (chỉ gửi theo vai trò hoặc toàn thể thư viện).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
