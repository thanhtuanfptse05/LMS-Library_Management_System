# CONTEXT.md — Ngữ cảnh & Phạm vi
Phiên bản: 1.0.0 | Ngày: 2026-06-10

## 1.1 Problem Statement
Quản lý thư viện hiện thiếu công cụ để truyền thông các chính sách mới (lịch nghỉ, quy định mượn trả) tới toàn bộ người dùng và không thể chủ động điều chỉnh nội dung các email tự động dẫn đến việc thông tin bị cứng nhắc, khó thay đổi theo từng thời điểm [UC19, FR24].

## 1.2 Domain Knowledge
* **Internal Broadcast:** Thông báo hiển thị trực tiếp trên Dashboard của mọi người dùng thông qua bảng Notification.
* **Transaction Templates:** Các mẫu email/thông báo tự động được kích hoạt bởi sự kiện nghiệp vụ (quá hạn, mượn sách), lưu tại bảng DocumentTemp.
* **Placeholder Pattern:** Sử dụng cú pháp {{user_name}}, {{book_title}} trong template để hệ thống tự động điền dữ liệu động khi gửi.

## 1.3 Constraints
* **Quyền hạn (RBAC):** Chỉ người dùng có role LibraryManager mới được phép truy cập phân hệ này [FR24].
* **Bảo mật:** Không được nhúng mã script độc hại (XSS) vào nội dung thông báo.
* **Database:** Phải sử dụng đúng cấu trúc bảng Notification và DocumentTemp đã định nghĩa trong Schema.
