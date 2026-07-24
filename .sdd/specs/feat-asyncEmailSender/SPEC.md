# Feature Specification: Gửi Email bất đồng bộ (Async Email Sender)
# Version: 1.2 | Chủ sở hữu: @bao, @tuan | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp dịch vụ gửi Email thông báo tự động (Mật khẩu tạm thời, Nhắc sách sắp quá hạn/quá hạn, Thông báo sách đặt trước đã có sẵn, Cảnh báo nợ phạt) chạy hoàn toàn bất đồng bộ (Async) thông qua `ExecutorService` của Java, đảm bảo không làm gián đoạn hoặc gây nghẽn luồng xử lý Web Request.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Hệ thống (System Engine):** Tự động đẩy công việc gửi email vào hàng chờ (Queue) khi phát sinh sự kiện.
* **Quản lý Thư viện (Library Manager):** Khai báo và quản lý mẫu nội dung email (`DocumentTemp`).

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-35 (Manage Email Templates):** Actor: Manager | Quản lý và chỉnh sửa các mẫu Email thông báo (`DocumentTemp`).
* **UC-36 (Async Email Dispatch):** Actor: System Engine | Thực thi gửi email thông báo bất đồng bộ qua luồng chạy ngầm.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-39 (Non-blocking I/O):** NGHIÊM CẤM gọi trực tiếp hàm gửi email đồng bộ (Synchronous SMTP/SendGrid) trong HTTP Request Thread. Bắt buộc chuyển giao cho `ExecutorService` xử lý ngầm.
* **BR-40 (Template Parameter Dynamic Replacement):** Nội dung email BẮT BUỘC sử dụng mẫu từ `DocumentTemp` và thay thế linh hoạt các tham số động (ví dụ: `{{fullName}}`, `{{bookTitle}}`, `{{dueDate}}`).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-44 (Quản lý mẫu Email):** WHEN Manager truy cập `DocumentTempManagerServlet`, THE system SHALL cho phép cập nhật tiêu đề (`subject`) và nội dung html (`bodyContent`) của các mẫu email thông báo hệ thống. Ghi `AuditLogs`.
  * *Mapping:* UC-35
* **FR-45 (Đẩy tác vụ gửi Email Async):** WHEN một module yêu cầu gửi email (ví dụ: `ForgotPasswordServlet`, nhắc quá hạn mượn sách), THE system SHALL gọi `EmailService.sendAsyncEmail(toEmail, subject, bodyContent)` để nộp tác vụ cho Thread Pool `ExecutorService`. HTTP Thread được giải phóng lập tức.
  * *Mapping:* UC-36 / BR-39, BR-40

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Thời gian nộp đơn hàng chờ gửi email < 10ms. Không ảnh hưởng đến thời gian phản hồi trang Web.
* **Độ tin cậy:** Khởi tạo và giải phóng Thread Pool an toàn trong `AppContextListener` khi ứng dụng Start/Stop.
* **Giao diện:** Mẫu email chuẩn HTML Responsive 100% Tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `DocumentTemp`
* `tempId` (INT, PK), `tempName` (VARCHAR, UNIQUE), `subject`, `bodyContent` (TEXT), `managerId` (FK), `updatedAt`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** gửi email qua SMTP/SendGrid bị lỗi mạng, **THE system SHALL** catch ngoại lệ trong luồng async, ghi log lỗi chi tiết và thử lại tối đa 3 lần trước khi đánh dấu thất bại.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-EMAIL-01] Yêu cầu gửi email mật khẩu tạm phản hồi ngay lập tức cho client mà không bị trễ do mạng SMTP.
- [ ] [TC-EMAIL-02] Mẫu email tự động thay thế đúng các biến động {{fullName}}, {{bookTitle}}.
- [ ] [TC-EMAIL-03] Quản lý chỉnh sửa thành công mẫu email trong DocumentTempManagerServlet.

## 8. Out of Scope (Phạm vi không thực hiện)
* Xây dựng máy chủ SMTP riêng (dùng Jakarta Mail / SendGrid API).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện EmailService async tích hợp AppContextListener.