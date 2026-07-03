# Feature Specification: Hạ tầng gửi email bất đồng bộ (Async Email Infrastructure)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Thiết lập hệ thống gửi email bất đồng bộ chạy nền bằng Daemon Thread để xử lý gửi OTP xác thực, thông báo phạt quá hạn, thông báo sách sẵn sàng nhận nhằm tối ưu hóa hiệu năng ứng dụng.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Hệ thống (System):** Tự động đưa các yêu cầu gửi email vào hàng đợi và xử lý gửi đi.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-46 (Email SMTP Configurations):** Các tham số cấu hình SMTP (Host, Port, Username, Password) BẮT BUỘC phải được đọc trực tiếp từ bảng SystemConfigurations.\n* **BR-48 (Email Worker Error Recovery):** Lỗi kết nối SMTP không được phép làm crash thread Consumer; hệ thống phải tự động retry tối đa số lần cấu hình (EMAIL_MAX_RETRIES) trước khi bỏ qua job.\n* **BR-49 (Email Job Queue Limits):** Hàng đợi email bất đồng bộ BẮT BUỘC giới hạn dung lượng tối đa. Khi hàng đợi đầy, hệ thống SHALL ghi log cảnh báo và bỏ qua email mới nhất để bảo vệ tính ổn định hệ thống.\n* **BR-50 (Email Temp Password Exclusion):** Tiến trình ngầm gửi mail TUYỆT ĐỐI KHÔNG ĐƯỢC log mật khẩu tạm thời dưới dạng thô.\n* **BR-42 (Graceful Shutdown Email Queue):** Khi ứng dụng shutdown, hệ thống PHẢI dừng tiếp nhận email mới vào hàng đợi, chờ tối đa 5 giây để gửi nốt các email còn tồn đọng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-103 (Giao diện public cho enqueue EmailJob):** WHEN các nghiệp vụ khác gọi EmailService, THE system SHALL đẩy job vào LinkedBlockingQueue và trả về kết quả thành công tức thì.\n* **.FR-104 (Khởi chạy Daemon Thread Worker):** WHEN ứng dụng khởi động (ServletContextListener), THE system SHALL khởi tạo luồng Daemon Thread chạy ngầm xử lý hàng đợi.\n* **FR-105 (Consumer lấy Job từ hàng đợi):** Consumer SHALL block cho đến khi có email job mới xuất hiện trong hàng đợi để xử lý.\n* **FR-106 (Tra cứu template động từ DB):** WHEN xử lý email, THE system SHALL truy vấn mẫu thư điện tử mới nhất từ bảng DocumentTemp hoặc EmailTemplate.\n* **FR-107 (Inject dữ liệu vào Template):** THE system SHALL thay thế toàn bộ placeholders định dạng `{{key}}` bằng giá trị thực.\n* **FR-108 (Gửi email qua SMTP JavaMail):** THE system SHALL kết nối SMTP Server dựa trên cấu hình hệ thống nạp sẵn để gửi email HTML.\n* **FR-109 (Cơ chế tự động Retry gửi lỗi):** WHERE gửi lỗi, THE system SHALL tự động thử lại sau mỗi khoảng thời gian delay cho đến khi thành công hoặc đạt số lần tối đa.\n* **FR-113 (Graceful Shutdown hàng đợi):** WHEN Tomcat tắt, THE system SHALL dừng nhận job mới, chờ tối đa 5 giây cho các email trong hàng đợi gửi nốt trước khi kết thúc luồng.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Độ tin cậy: Không làm nghẽn luồng xử lý HTTP request chính của người dùng khi gửi email.\n* Bảo mật: Tuyệt đối không log thông tin mật khẩu thô ra file log.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng EmailTemplate\n* `templateId` (INT, PK)\n* `tempName` (VARCHAR(100), UNIQUE)\n* `subject` (VARCHAR(255))\n* `bodyContent` (TEXT)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE xảy ra lỗi kết nối SMTP kéo dài, THE system SHALL tự động hủy job sau khi đạt số lần retry tối đa và ghi log báo động.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Gửi email quên mật khẩu: Người dùng nhấn quên mật khẩu -> Nhận email OTP trong hòm thư, luồng HTTP chính phản hồi ngay lập tức.

## 9. Out of Scope (Phạm vi không thực hiện)
* Quản lý và thống kê tỷ lệ email được mở (open rate) hoặc bị bounce trong hệ thống.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
