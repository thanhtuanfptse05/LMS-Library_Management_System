# Feature Specification: Gửi Email bất đồng bộ (Async Email Sender)
# Version: 1.3 | Chủ sở hữu: Bao | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp dịch vụ gửi Email thông báo tự động (Mật khẩu tạm thời, Nhắc sách sắp quá hạn/quá hạn, Thông báo sách đặt trước đã có sẵn, Cảnh báo nợ phạt) chạy hoàn toàn bất đồng bộ (Async) thông qua `ExecutorService` của Java, đảm bảo không làm gián đoạn hoặc gây nghẽn luồng xử lý Web Request.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Hệ thống (System Engine):** Tự động đẩy công việc gửi email vào hàng chờ (Queue) khi phát sinh sự kiện.
* **Quản trị viên (Admin):** Khai báo và quản lý mẫu nội dung email (`DocumentTemp`).

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F19 Async Email Infrastructure. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-42 (Graceful Shutdown Email Queue):** Khi ứng dụng shutdown, hệ thống PHẢI dừng tiếp nhận email mới vào hàng đợi, chờ tối đa 5 giây để gửi nốt các email còn tồn đọng trong queue rồi mới ngắt luồng Consumer.
* **BR-46 (Email SMTP Configurations):** Các tham số cấu hình SMTP (Host, Port, Username, Password) BẮT BUỘC phải được đọc trực tiếp từ bảng SystemConfigurations.
* **BR-47 (Email Template Protection):** Các mẫu email hệ thống (RESET_PASSWORD, RESERVATION_READY, RENEWAL_CONFIRMATION, OVERDUE_NOTICE, INCIDENT_FINE_NOTICE, PAYMENT_CONFIRMATION) cấm tuyệt đối xóa khỏi hệ thống.
* **BR-48 (Email Worker Error Recovery):** Lỗi kết nối SMTP không được phép làm crash thread Consumer; hệ thống phải tự động retry tối đa số lần cấu hình (EMAIL_MAX_RETRIES) trước khi bỏ qua job.
* **BR-49 (Email Job Queue Limits):** Hàng đợi email bất đồng bộ BẮT BUỘC giới hạn dung lượng tối đa (EMAIL_QUEUE_CAPACITY). Khi hàng đợi đầy, hệ thống SHALL ghi log cảnh báo và bỏ qua (drop) email mới nhất để bảo vệ tính ổn định hệ thống.
* **BR-50 (Email Temp Password Exclusion):** Tiến trình ngầm gửi mail TUYỆT ĐỐI KHÔNG ĐƯỢC log mật khẩu tạm thời (tempPassword) dưới dạng thô nhằm đảm bảo an toàn bảo mật.
* **BR-51 (Email Template Rendering):** Hệ thống hỗ trợ định dạng Markdown và render ra HTML trước khi gửi đi. Placeholders trong email template phải ở định dạng `{{key}}`.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-103 (Gửi email bất đồng bộ trực tiếp qua CompletableFuture):** WHEN bất kỳ dịch vụ nào gọi EmailService.enqueue(job), THE system SHALL tự động chạy tác vụ gửi email trong CompletableFuture.runAsync() và trả về ngay lập tức để tránh block luồng xử lý HTTP chính.
  * *Mapping:* BR-49
* **FR-104 (Thay thế Daemon Thread bằng CompletableFuture):** THE system SHALL thực hiện gửi email bất đồng bộ qua CompletableFuture mà không cần khởi tạo luồng Daemon Thread chạy ngầm liên tục tại AppContextListener.
* **FR-105 (Consumer lấy Job từ hàng đợi):** WHILE EmailWorker hoạt động, Consumer SHALL liên tục lấy job ra bằng phương thức queue.take() (sử dụng cơ chế block để không tiêu hao tài nguyên CPU khi hàng đợi rỗng).
  * *Mapping:* BR-49
* **FR-106 (Tra cứu template động từ DB):** WHEN xử lý gửi email, THE system SHALL gọi DocumentTempDAO.findByTempName() để lấy nội dung template mới nhất do Admin chỉnh sửa từ CSDL.
  * *Mapping:* BR-47, BR-51
* **FR-107 (Inject dữ liệu vào Template placeholders):** THE system SHALL quét và thay thế tất cả các placeholder có định dạng `{{key}}` trong nội dung mẫu email bằng giá trị tương ứng truyền vào từ EmailJob.placeholders.
  * *Mapping:* BR-51
* **FR-108 (Gửi email qua SMTP JavaMail):** THE system SHALL sử dụng thư viện JavaMail để kết nối SMTP Server dựa trên các tham số cấu hình (SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD) lấy từ cache hệ thống.
  * *Mapping:* BR-46
* **FR-109 (Cơ chế tự động Retry gửi lỗi):** WHERE xảy ra lỗi kết nối SMTP trong quá trình gửi, Consumer SHALL tự động thử lại sau mỗi EMAIL_RETRY_DELAY_SECONDS giây, tối đa EMAIL_MAX_RETRIES lần.
  * *Mapping:* BR-48
* **FR-110 (Ghi log lỗi khi vượt quá lượt retry):** WHERE vượt quá giới hạn retry cho phép mà email vẫn lỗi, Consumer SHALL ghi nhận log lỗi mức SEVERE và tiếp tục xử lý các email khác trong hàng đợi.
  * *Mapping:* BR-48
* **FR-111 (Chặn xóa mẫu email hệ thống):** WHEN Admin yêu cầu xóa mẫu email, THE system SHALL kiểm tra danh sách PROTECTED_TEMPLATES. WHERE mẫu email nằm trong danh sách được bảo vệ, hệ thống SHALL ngăn chặn hành động và trả về thông báo lỗi bằng tiếng Việt.
  * *Mapping:* BR-47
* **FR-112 (Bảo mật không ghi log mật khẩu thô):** THE system SHALL loại bỏ giá trị của placeholder {{tempPassword}} trước khi ghi log hoặc Audit Log để tránh lộ thông tin nhạy cảm.
  * *Mapping:* BR-50
* **FR-113 (Graceful Shutdown hàng đợi):** WHEN ứng dụng Tomcat tắt (contextDestroyed), THE system SHALL set cờ running=false, đợi tối đa 5 giây cho luồng Consumer xử lý hết các email còn lại trong queue trước khi dừng hẳn thread.
  * *Mapping:* BR-42
* **FR-114 (Tích hợp Email Reset Mật Khẩu):** WHEN người dùng yêu cầu đặt lại mật khẩu thành công, THE system SHALL đẩy một job gửi email với template 'RESET_PASSWORD' và placeholders chứa userName, tempPassword, resetLink vào hàng đợi.
  * *Mapping:* BR-49, BR-50, BR-51
  * *External Trigger:* UC-03
* **FR-115 (Tích hợp Email Sách Sẵn Sàng Nhận):** WHEN một bản sao sách được giải phóng hoặc sẵn sàng cho người tiếp theo trong hàng đợi, THE system SHALL đẩy một job gửi email với template 'RESERVATION_READY' và deadline nhận sách vào hàng đợi.
  * *Mapping:* BR-49, BR-51
  * *External Trigger:* UC-16, UC-43
* **FR-116 (Tích hợp Email Báo Phạt Quá Hạn):** WHEN OverdueProcessor chạy định kỳ phát hiện sách quá hạn, THE system SHALL đẩy job gửi email với template 'OVERDUE_NOTICE' chứa số ngày trễ và tiền phạt ước tính vào hàng đợi.
  * *Mapping:* BR-49, BR-51
  * *External Trigger:* UC-42
* **FR-117 (Tích hợp Email Báo Sự Cố Sách):** WHEN thủ thư nhận trả sách và phát hiện hỏng/mất sách dẫn đến phạt tiền, THE system SHALL đẩy job gửi email với template 'INCIDENT_FINE_NOTICE' báo chi tiết sự cố và mức phạt vào hàng đợi.
  * *Mapping:* BR-49, BR-51
  * *External Trigger:* UC-19, UC-28
* **FR-118 (Tích hợp Email Xác Nhận Thanh Toán):** WHEN độc giả thanh toán thành công tiền phạt (qua tiền mặt tại quầy hoặc SePay online), THE system SHALL đẩy job gửi email với template 'PAYMENT_CONFIRMATION' xác nhận hoàn thành nghĩa vụ đóng phạt vào hàng đợi.
  * *Mapping:* BR-49, BR-51
  * *External Trigger:* UC-20, UC-39


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Thời gian nộp đơn hàng chờ gửi email < 10ms. Không ảnh hưởng đến thời gian phản hồi trang Web.
* **Độ tin cậy:** Khởi tạo và giải phóng Thread Pool an toàn trong `AppContextListener` khi ứng dụng Start/Stop.
* **Giao diện:** Mẫu email chuẩn HTML Responsive 100% Tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `DocumentTemp`
* `tempId` (INT, PK), `tempName` (VARCHAR, UNIQUE), `subject`, `bodyContent` (TEXT), `adminId` (FK), `updatedAt`

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
