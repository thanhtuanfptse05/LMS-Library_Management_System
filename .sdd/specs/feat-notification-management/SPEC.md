# Feature Specification: Quản lý thông báo hệ thống (Notification Management)
# Version: 1.3 | Chủ sở hữu: Tuan | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Quản trị viên (Admin) đăng phát thông báo hệ thống, thông tin lịch nghỉ/bảo trì, sự kiện thư viện, kèm tính năng ghim thông báo quan trọng lên đầu trang và đánh dấu trạng thái Đã đọc/Chưa đọc cho từng người dùng.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Tạo mới, chỉnh sửa, xóa, ghim/bỏ ghim thông báo toàn hệ thống.
* **Tất cả Người dùng (All Roles):** Nhận thông báo trên dashboard, xem danh sách thông báo, đánh dấu đã đọc.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-24 (Manage Notifications):** Actor: Admin | (Quản lý thông báo): Quản trị viên soạn thảo, ghim, phát hành hoặc xóa các thông báo hệ thống.
* **UC-25 (View Notifications):** Actor: User | (Xem thông báo): Người dùng theo dõi thông báo qua biểu tượng chuông và đánh dấu trạng thái đã đọc.
* **UC-26 (Manage Document Templates):** Actor: Admin | (Quản lý mẫu văn bản): Cấu hình các mẫu nội dung email tự động.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F7 Notification Management. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-67 (Notification Pinning Limit):** The system SHALL enforce a maximum limit on the number of concurrently pinned notifications.
* **BR-68 (Notification Visibility):** The system SHALL only show read notifications if specifically requested, prioritizing unread notifications.
* **BR-69 (Template Integrity):** The system SHALL prevent the removal of mandatory placeholders from system email templates.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-44 (Quản lý & Phát hành Thông báo hàng loạt):** WHEN NotificationManagerServlet.doPost(action=create) hoặc action=update được gọi, THE system SHALL: (1) **Validate input**: title không rỗng và ≤ 255 ký tự, content ≤ 10.000 ký tự, type IN ['news', 'announcement', 'maintenance'] (Tin tức và sự kiện đã gộp chung thành 'news'), isPinned = true/false, (2) **Create/Update Notification**: Mở DB Transaction, INSERT hoặc UPDATE Notification(notificationId, title, content, type, thumbnailUrl, isPinned, status='published', createdBy=adminId, createdAt=NOW() hoặc updatedAt=NOW()), INSERT AuditLog(CREATE_NOTIFICATION hoặc UPDATE_NOTIFICATION, adminId), conn.commit(), (3) **Gửi Email hàng loạt** (chỉ khi action=create VÀ user chọn "Gửi email thông báo"): WHERE templateId được cung cấp, DocumentTempDAO.findById(templateId) để load email template, EmailService.sendBulkNotificationEmails(notificationId, templateId) [async, ngoài transaction]: Query UserDAO.findAllActiveUsersWithRole(['STUDENT', 'LECTURER']), Với mỗi user: render template với variables {userName, notificationTitle, notificationContent, notificationUrl}, enqueue email vào background ExecutorService, ghi log số lượng email queued, (4) **Widget Update**: NotificationWidgetServlet sẽ hiển thị badge số lượng thông báo chưa đọc dựa trên UserNotificationStatus.
  * *Mapping:* UC-24, UC-25 / BR-67, BR-68
* **FR-52 (Quản lý Mẫu Email):** WHEN DocumentTempManagerServlet.doPost(action=update) cập nhật email template, THE system SHALL: (1) Validate input: tempId tồn tại, subject không rỗng và ≤ 255 ký tự, bodyContent ≤ 50.000 ký tự (hỗ trợ HTML + placeholders), (2) Kiểm tra các placeholders bắt buộc theo loại template: RESET_PASSWORD template MUST chứa {{tempPassword}}, {{userName}}, {{resetLink}}, OVERDUE_NOTICE template MUST chứa {{bookTitle}}, {{dueDate}}, {{daysLate}}, {{fineAmount}}, RESERVATION_READY template MUST chứa {{bookTitle}}, {{pickupDeadline}}, {{libraryLocation}}, WHERE thiếu placeholder bắt buộc: trả lỗi validation "Template thiếu biến bắt buộc: {missingPlaceholders}", (3) Mở DB Transaction: UPDATE DocumentTemp SET subject=?, bodyContent=?, updatedBy=adminId, updatedAt=NOW() WHERE tempId=?, INSERT AuditLog(UPDATE_EMAIL_TEMPLATE, adminId, entityName='DocumentTemp', entityId=tempId, oldValues=JSON.stringify({oldSubject, oldBodyContent}), newValues=JSON.stringify({subject, bodyContent})), conn.commit(), (4) **Clear template cache**: DocumentTemplateCache.invalidate(tempId) để buộc reload template mới khi gửi email tiếp theo, (5) Redirect với flash success "Đã cập nhật mẫu email: {tempName}". **Rendering**: EmailService.sendEmail() sẽ dùng định dạng HTML/Text thông thường, thay thế placeholders bằng SimpleTemplateEngine hoặc String.replace().
  * *Mapping:* UC-26 / BR-69


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền Admin cho thao tác C/U/D thông báo. Người dùng thường chỉ có quyền đọc và cập nhật trạng thái đọc của chính mình.
* **Giao diện:** 100% Tiếng Việt, có badge màu đỏ hiển thị số thông báo chưa đọc.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Notification`
* `notificationId` (INT, PK), `title`, `content`, `type` (system/academic/maintenance/event), `isPinned` (BOOLEAN), `createdBy` (FK), `createdAt`, `updatedAt`

### Bảng `UserNotificationStatus`
* `userId` (INT, PK/FK REFERENCES `"User"`), `notificationId` (INT, PK/FK), `readAt` (TIMESTAMP)

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** tiêu đề hoặc nội dung thông báo rỗng, **THE system SHALL** báo lỗi "Tiêu đề và Nội dung thông báo không được để trống".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-NOTIF-01] Admin tạo thông báo thành công và hiển thị tức thì trên Dashboard của độc giả.
- [ ] [TC-NOTIF-02] Thông báo được ghim hiển thị ưu tiên ở đầu danh sách.
- [ ] [TC-NOTIF-03] Độc giả click xem thông báo cập nhật đúng trạng thái đã đọc và giảm số dư trên Badge.

## 8. Out of Scope (Phạm vi không thực hiện)
* Gửi thông báo đẩy Web Push Notifications trực tiếp qua trình duyệt (Browser Push API).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện quản lý thông báo hệ thống và ghi nhận trạng thái đã đọc.