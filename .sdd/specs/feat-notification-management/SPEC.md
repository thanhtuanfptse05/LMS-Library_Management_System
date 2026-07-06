# Feature Specification: Quản lý thông báo và mẫu văn bản (Notification Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Quản lý Thư viện (Manager) tạo và phát hành thông báo hệ thống đến các vai trò độc giả, ghim thông báo quan trọng, quản lý các mẫu văn bản email tự động, và cho phép độc giả theo dõi thông báo.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Manager):** Tạo, sửa, xóa thông báo, quản lý mẫu email tự động.
* **Độc giả (User):** Xem thông báo hệ thống, đánh dấu đã đọc thông báo.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-24 (Manage Notifications):** Actor: Manager | (Quản lý thông báo): Quản lý thư viện soạn thảo, ghim, phát hành hoặc xóa các thông báo hệ thống.
* **UC-25 (View Notifications):** Actor: User | (Xem thông báo): Người dùng theo dõi thông báo qua biểu tượng chuông và đánh dấu trạng thái đã đọc.
* **UC-26 (Manage Document Templates):** Actor: Manager | (Quản lý mẫu văn bản): Cấu hình các mẫu nội dung email tự động.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-24 (Manage Notifications):** Actor: Manager | (Quản lý thông báo): Quản lý thư viện soạn thảo, ghim, phát hành hoặc xóa các thông báo hệ thống.
* **UC-25 (View Notifications):** Actor: User | (Xem thông báo): Người dùng theo dõi thông báo qua biểu tượng chuông và đánh dấu trạng thái đã đọc.
* **UC-26 (Manage Document Templates):** Actor: Manager | (Quản lý mẫu văn bản): Cấu hình các mẫu nội dung email tự động.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-24 (Manage Notifications):** Actor: Manager | (Quản lý thông báo): Quản lý thư viện soạn thảo, ghim, phát hành hoặc xóa các thông báo hệ thống.
* **UC-25 (View Notifications):** Actor: User | (Xem thông báo): Người dùng theo dõi thông báo qua biểu tượng chuông và đánh dấu trạng thái đã đọc.
* **UC-26 (Manage Document Templates):** Actor: Manager | (Quản lý mẫu văn bản): Cấu hình các mẫu nội dung email tự động.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-44 (Quản lý & Phát hành Thông báo hàng loạt):** WHEN NotificationManagerServlet.doPost(action=create) hoặc action=update được gọi, THE system SHALL: (1) **Validate input**: title không rỗng và ≤ 255 ký tự, content ≤ 10.000 ký tự, type IN ['news', 'announcement', 'maintenance'] (Tin tức và sự kiện đã được gộp chung thành 'news'), isPinned = true/false, (2) **Create/Update Notification**: Mở DB Transaction, INSERT hoặc UPDATE Notification(notificationId, title, content, type, thumbnailUrl, isPinned, status='published', createdBy=managerId, createdAt=NOW() hoặc updatedAt=NOW()), INSERT AuditLog(CREATE_NOTIFICATION hoặc UPDATE_NOTIFICATION, managerId), conn.commit(), (3) **Gửi Email hàng loạt** (chỉ khi action=create VÀ user chọn "Gửi email thông báo"): WHERE templateId được cung cấp, DocumentTempDAO.findById(templateId) để load email template, EmailService.sendBulkNotificationEmails(notificationId, templateId) [async, ngoài transaction]: Query UserDAO.findAllActiveUsersWithRole(['STUDENT', 'LECTURER']), Với mỗi user: render template với variables {userName, notificationTitle, notificationContent, notificationUrl}, enqueue email vào background ExecutorService, ghi log số lượng email queued, (4) **Widget Update**: NotificationWidgetServlet sẽ hiển thị badge số lượng thông báo chưa đọc dựa trên UserNotificationStatus.
  * *Mapping:* UC-24, UC-25
* **FR-52 (Quản lý Mẫu Email):** WHEN DocumentTempManagerServlet.doPost(action=update) cập nhật email template, THE system SHALL: (1) Validate input: tempId tồn tại, subject không rỗng và ≤ 255 ký tự, bodyContent ≤ 50.000 ký tự (hỗ trợ HTML + placeholders), (2) Kiểm tra các placeholders bắt buộc theo loại template: RESET_PASSWORD template MUST chứa {{tempPassword}}, {{userName}}, {{resetLink}}, OVERDUE_NOTICE template MUST chứa {{bookTitle}}, {{dueDate}}, {{daysLate}}, {{fineAmount}}, RESERVATION_READY template MUST chứa {{bookTitle}}, {{pickupDeadline}}, {{libraryLocation}}, WHERE thiếu placeholder bắt buộc: trả lỗi validation "Template thiếu biến bắt buộc: {missingPlaceholders}", (3) Mở DB Transaction: UPDATE DocumentTemp SET subject=?, bodyContent=?, updatedBy=managerId, updatedAt=NOW() WHERE tempId=?, INSERT AuditLog(UPDATE_EMAIL_TEMPLATE, managerId, entityName='DocumentTemp', entityId=tempId, oldValues=JSON.stringify({oldSubject, oldBodyContent}), newValues=JSON.stringify({subject, bodyContent})), conn.commit(), (4) **Clear template cache**: DocumentTemplateCache.invalidate(tempId) để buộc reload template mới khi gửi email tiếp theo, (5) Redirect với flash success "Đã cập nhật mẫu email: {tempName}". **Rendering**: EmailService.sendEmail() sẽ dùng định dạng HTML/Text thông thường, thay thế placeholders bằng SimpleTemplateEngine hoặc String.replace().
  * *Mapping:* UC-26

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Tính khả dụng: Giao diện dễ sử dụng, quản lý thông báo thân thiện.
* Bảo mật: Phân quyền chặt chẽ chỉ Manager mới được phép chỉnh sửa mẫu email.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Notification
* `notificationId` (INT, PK)
* `title` (VARCHAR(500))
* `content` (TEXT)
* `type` (VARCHAR(50))
* `thumbnailUrl` (VARCHAR(500), NULL)
* `targetRole` (VARCHAR(50))
* `isPinned` (BOOLEAN)
* `createdBy` (INT)
* `createdAt` (TIMESTAMP)

### Bảng UserNotificationStatus
* `userId` (INT, PK, FK)
* `notificationId` (INT, PK, FK)
* `readAt` (TIMESTAMP)

### Bảng DocumentTemp
* `tempId` (INT, PK)
* `tempName` (VARCHAR(100), UNIQUE)
* `subject` (VARCHAR(255))
* `bodyContent` (TEXT)
* `managerId` (INT)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE mẫu email chỉnh sửa thiếu biến placeholder bắt buộc, THE system SHALL báo lỗi và không cho phép lưu.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo thông báo ghim thành công: Tạo thông báo mới và ghim -> Hiện lên đầu trang chủ công khai của độc giả.
- [ ] Đọc thông báo: Độc giả nhấn xem thông báo -> Badge số lượng thông báo chưa đọc giảm đi 1.

## 9. Out of Scope (Phạm vi không thực hiện)
* Gửi thông báo riêng cho từng cá nhân (chỉ gửi theo vai trò hoặc toàn thể thư viện).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.