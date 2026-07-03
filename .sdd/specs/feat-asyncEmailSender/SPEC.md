# Feature Specification: Hạ tầng gửi email bất đồng bộ (Async Email Infrastructure)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Thiết lập hệ thống gửi email bất đồng bộ chạy nền bằng Daemon Thread để xử lý gửi OTP xác thực, thông báo phạt quá hạn, thông báo sách sẵn sàng nhận nhằm tối ưu hóa hiệu năng ứng dụng.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Hệ thống (System):** Tự động đưa các yêu cầu gửi email vào hàng đợi và xử lý gửi đi.

## 2.5 Use Cases (Danh sách Use Cases)
*(Không có Use Case riêng biệt)*

## 2.5 Use Cases (Danh sách Use Cases)
*(Không có Use Case riêng biệt)*

## 2.5 Use Cases (Danh sách Use Cases)
*(Không có Use Case riêng biệt)*

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-46 (Email SMTP Configurations):** Các tham số cấu hình SMTP (Host, Port, Username, Password) BẮT BUỘC phải được đọc trực tiếp từ bảng SystemConfigurations.
* **BR-47 (Email Template Protection):** Các mẫu email hệ thống (RESET_PASSWORD, RESERVATION_READY, RENEWAL_CONFIRMATION, OVERDUE_NOTICE, INCIDENT_FINE_NOTICE, PAYMENT_CONFIRMATION) cấm tuyệt đối xóa khỏi hệ thống.
* **BR-48 (Email Worker Error Recovery):** Lỗi kết nối SMTP không được phép làm crash thread Consumer; hệ thống phải tự động retry tối đa số lần cấu hình (EMAIL_MAX_RETRIES) trước khi bỏ qua job.
* **BR-49 (Email Job Queue Limits):** Hàng đợi email bất đồng bộ BẮT BUỘC giới hạn dung lượng tối đa (EMAIL_QUEUE_CAPACITY). Khi hàng đợi đầy, hệ thống SHALL ghi log cảnh báo và bỏ qua (drop) email mới nhất để bảo vệ tính ổn định hệ thống.
* **BR-50 (Email Temp Password Exclusion):** Tiến trình ngầm gửi mail TUYỆT ĐỐI KHÔNG ĐƯỢC log mật khẩu tạm thời (tempPassword) dưới dạng thô nhằm đảm bảo an toàn bảo mật.
* **BR-51 (Email Template Rendering):** Hệ thống hỗ trợ định dạng Markdown và render ra HTML trước khi gửi đi. Placeholders trong email template phải ở định dạng `{{key}}`.
* **BR-52 (Librarian Performance Isolation):** Báo cáo hiệu suất nhân viên chỉ thống kê các giao dịch được thực hiện bởi các tài khoản có vai trò là LIBRARIAN.
* **BR-53 (Payment Config Group Access):** Library Manager chỉ có quyền xem và sửa các cấu hình có prefix `SEPAY_`. Việc phân quyền sửa cấu hình SePay được kiểm soát nghiêm ngặt ở tầng Service.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-103 (Giao diện public cho enqueue EmailJob):** WHEN bất kỳ dịch vụ nào gọi EmailService.enqueue(job), THE system SHALL đẩy job vào LinkedBlockingQueue và trả về kết quả thành công ngay lập tức để tránh block luồng xử lý chính.
  * *Mapping:* BR-41, BR-49
* **FR-104 (Khởi chạy Daemon Thread Worker):** WHEN ứng dụng bắt đầu khởi động, AppContextListener SHALL khởi tạo một instance duy nhất của EmailWorker, đăng ký là Daemon Thread và kích hoạt luồng xử lý chạy nền.
  * *Mapping:* BR-41
* **FR-105 (Consumer lấy Job từ hàng đợi):** WHILE EmailWorker hoạt động, Consumer SHALL liên tục lấy job ra bằng phương thức queue.take() (sử dụng cơ chế block để không tiêu hao tài nguyên CPU khi hàng đợi rỗng).
  * *Mapping:* BR-41
* **FR-106 (Tra cứu template động từ DB):** WHEN xử lý gửi email, THE system SHALL gọi DocumentTempDAO.findByTempName() để lấy nội dung template mới nhất do Manager chỉnh sửa từ CSDL.
  * *Mapping:* BR-41 / BR-47
* **FR-107 (Inject dữ liệu vào Template placeholders):** THE system SHALL quét và thay thế tất cả các placeholder có định dạng `{{key}}` trong nội dung mẫu email bằng giá trị tương ứng truyền vào từ EmailJob.placeholders.
  * *Mapping:* BR-51
* **FR-108 (Gửi email qua SMTP JavaMail):** THE system SHALL sử dụng thư viện JavaMail để kết nối SMTP Server dựa trên các tham số cấu hình (SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD) lấy từ cache hệ thống.
  * *Mapping:* BR-46
* **FR-109 (Cơ chế tự động Retry gửi lỗi):** WHERE xảy ra lỗi kết nối SMTP trong quá trình gửi, Consumer SHALL tự động thử lại sau mỗi EMAIL_RETRY_DELAY_SECONDS giây, tối đa EMAIL_MAX_RETRIES lần.
  * *Mapping:* BR-48
* **FR-110 (Ghi log lỗi khi vượt quá lượt retry):** WHERE vượt quá giới hạn retry cho phép mà email vẫn lỗi, Consumer SHALL ghi nhận log lỗi mức SEVERE và tiếp tục xử lý các email khác trong hàng đợi.
  * *Mapping:* BR-48
* **FR-111 (Chặn xóa mẫu email hệ thống):** WHEN Manager yêu cầu xóa mẫu email, THE system SHALL kiểm tra danh sách PROTECTED_TEMPLATES. WHERE mẫu email nằm trong danh sách được bảo vệ, hệ thống SHALL ngăn chặn hành động và trả về thông báo lỗi bằng tiếng Việt.
  * *Mapping:* BR-47
* **FR-112 (Bảo mật không ghi log mật khẩu thô):** THE system SHALL loại bỏ giá trị của placeholder {{tempPassword}} trước khi ghi log hoặc Audit Log để tránh lộ thông tin nhạy cảm.
  * *Mapping:* BR-50
* **FR-113 (Graceful Shutdown hàng đợi):** WHEN ứng dụng Tomcat tắt (contextDestroyed), THE system SHALL set cờ running=false, đợi tối đa 5 giây cho luồng Consumer xử lý hết các email còn lại trong queue trước khi dừng hẳn thread.
  * *Mapping:* BR-42
* **FR-114 (Tích hợp Email Reset Mật Khẩu):** WHEN người dùng yêu cầu đặt lại mật khẩu thành công, THE system SHALL đẩy một job gửi email với template 'RESET_PASSWORD' và placeholders chứa userName, tempPassword, resetLink vào hàng đợi.
  * *Mapping:* UC-03
* **FR-115 (Tích hợp Email Sách Sẵn Sàng Nhận):** WHEN một bản sao sách được giải phóng hoặc sẵn sàng cho người tiếp theo trong hàng đợi, THE system SHALL đẩy một job gửi email với template 'RESERVATION_READY' và deadline nhận sách vào hàng đợi.
  * *Mapping:* UC-16, UC-43
* **FR-116 (Tích hợp Email Báo Phạt Quá Hạn):** WHEN OverdueProcessor chạy định kỳ phát hiện sách quá hạn, THE system SHALL đẩy job gửi email với template 'OVERDUE_NOTICE' chứa số ngày trễ và tiền phạt ước tính vào hàng đợi.
  * *Mapping:* UC-42
* **FR-117 (Tích hợp Email Báo Sự Cố Sách):** WHEN thủ thư nhận trả sách và phát hiện hỏng/mất sách dẫn đến phạt tiền, THE system SHALL đẩy job gửi email với template 'INCIDENT_FINE_NOTICE' báo chi tiết sự cố và mức phạt vào hàng đợi.
  * *Mapping:* UC-19, UC-28
* **FR-118 (Tích hợp Email Xác Nhận Thanh Toán):** WHEN độc giả thanh toán thành công tiền phạt (qua tiền mặt tại quầy hoặc SePay online), THE system SHALL đẩy job gửi email với template 'PAYMENT_CONFIRMATION' xác nhận hoàn thành nghĩa vụ đóng phạt vào hàng đợi.
  * *Mapping:* UC-20, UC-39

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Độ tin cậy: Không làm nghẽn luồng xử lý HTTP request chính của người dùng khi gửi email.
* Bảo mật: Tuyệt đối không log thông tin mật khẩu thô ra file log.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng EmailTemplate
* `templateId` (INT, PK)
* `tempName` (VARCHAR(100), UNIQUE)
* `subject` (VARCHAR(255))
* `bodyContent` (TEXT)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE xảy ra lỗi kết nối SMTP kéo dài, THE system SHALL tự động hủy job sau khi đạt số lần retry tối đa và ghi log báo động.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Gửi email quên mật khẩu: Người dùng nhấn quên mật khẩu -> Nhận email OTP trong hòm thư, luồng HTTP chính phản hồi ngay lập tức.

## 9. Out of Scope (Phạm vi không thực hiện)
* Quản lý và thống kê tỷ lệ email được mở (open rate) hoặc bị bounce trong hệ thống.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.