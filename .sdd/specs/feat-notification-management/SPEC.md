# Feature Specification: Quản lý thông báo hệ thống (Notification Management)
# Version: 1.2 | Chủ sở hữu: @tuan | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Quản lý Thư viện (Library Manager) đăng phát thông báo hệ thống, thông tin lịch nghỉ/bảo trì, sự kiện thư viện, kèm tính năng ghim thông báo quan trọng lên đầu trang và đánh dấu trạng thái Đã đọc/Chưa đọc cho từng người dùng.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Tạo mới, chỉnh sửa, xóa, ghim/bỏ ghim thông báo toàn hệ thống.
* **Tất cả Người dùng (All Roles):** Nhận thông báo trên dashboard, xem danh sách thông báo, đánh dấu đã đọc.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-32 (Create/Manage Notifications):** Actor: Library Manager | Tạo mới thông báo, gán phân loại và ghim thông báo quan trọng.
* **UC-33 (View & Mark Notification Read):** Actor: All Users | Xem thông báo trên giao diện cá nhân và đánh dấu đã đọc.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-35 (Pinned Notifications Order):** Thông báo được ghim (`isPinned=true`) BẮT BUỘC hiển thị ở vị trí ưu tiên đầu tiên trong danh sách thông báo của mọi người dùng.
* **BR-36 (Read Status Persistence):** Trạng thái đọc thông báo được theo dõi độc lập cho từng người dùng trong bảng `UserNotificationStatus`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-40 (Tạo & Đăng thông báo):** WHEN Manager gửi thông báo tại `NotificationManagerServlet`, THE system SHALL lưu thông báo vào bảng `Notification` (`title`, `content`, `type`, `isPinned`, `createdBy`). WHERE `isPinned=true`, tự động đưa lên đầu trang. Ghi `AuditLogs`.
  * *Mapping:* UC-32 / BR-35
* **FR-41 (Đánh dấu Đã đọc & Đếm thông báo mới):** WHEN người dùng bấm xem thông báo tại `NotificationStatusServlet`, THE system SHALL chèn hoặc cập nhật bản ghi vào `UserNotificationStatus(userId, notificationId, readAt = NOW())`. Đếm số lượng thông báo chưa đọc để hiển thị trên huy hiệu (Badge) thanh tiêu đề.
  * *Mapping:* UC-33 / BR-36

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền Manager cho thao tác C/U/D thông báo. Người dùng thường chỉ có quyền đọc và cập nhật trạng thái đọc của chính mình.
* **Giao diện:** 100% Tiếng Việt, có badge màu đỏ hiển thị số thông báo chưa đọc.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Notification`
* `notificationId` (INT, PK), `title`, `content`, `type` (system/academic/maintenance/event), `isPinned` (BOOLEAN), `createdBy` (FK), `createdAt`, `updatedAt`

### Bảng `UserNotificationStatus`
* `userId` (INT, PK/FK REFERENCES `"User"`), `notificationId` (INT, PK/FK), `readAt` (TIMESTAMP)

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** tiêu đề hoặc nội dung thông báo rỗng, **THE system SHALL** báo lỗi "Tiêu đề và Nội dung thông báo không được để trống".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-NOTIF-01] Manager tạo thông báo thành công và hiển thị tức thì trên Dashboard của độc giả.
- [ ] [TC-NOTIF-02] Thông báo được ghim hiển thị ưu tiên ở đầu danh sách.
- [ ] [TC-NOTIF-03] Độc giả click xem thông báo cập nhật đúng trạng thái đã đọc và giảm số dư trên Badge.

## 8. Out of Scope (Phạm vi không thực hiện)
* Gửi thông báo đẩy Web Push Notifications trực tiếp qua trình duyệt (Browser Push API).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện quản lý thông báo hệ thống và ghi nhận trạng thái đã đọc.