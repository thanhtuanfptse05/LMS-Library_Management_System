# CHANGELOG — Tiến Trình Ngầm: Async Email Sender
# Feature ID: F-AsyncEmail

---

## [1.0.0] — 2026-06-25

### Added
- Tạo mới thư mục spec `feat-asyncEmailSender` với đầy đủ: SPEC.md, CONTEXT.md, PLAN.md, TASK.md
- Xác định kiến trúc Producer-Consumer: `LinkedBlockingQueue` + Daemon Thread
- Định nghĩa 6 Email Events chính thức (bỏ Event 3 Check-out và Event 5 Check-in để tránh spam)
- Định nghĩa `PROTECTED_TEMPLATES` — 6 mẫu hệ thống không được phép xóa
- Tạo seed file `04_document_templates.sql` với 6 mẫu email HTML đầy đủ

### Changed
- `LMS_Schema_PostgreSQL.sql` — Thêm cột `description VARCHAR` vào bảng `documenttemp`
- `model/DocumentTemp.java` — Thêm field `description`, cập nhật constructor và Javadoc
- `dao/DocumentTempDAO.java` — Thêm `description` vào tất cả SQL, thêm `PROTECTED_TEMPLATES` Set, thêm logic bảo vệ trong `delete()`, thêm `isProtected()` helper
- `controllers/DocumentTempManagerServlet.java` — Gọi `isProtected()` trước khi xóa, hiển thị thông báo lỗi tiếng Việt rõ ràng

### Decisions
- Chọn kiến trúc Option A: JavaMail SMTP (giữ nguyên, không đổi sang REST API)
- Bỏ Emergency Broadcast khỏi phạm vi — `DocumentTemp` chỉ dùng cho email bị động hệ thống
- Bỏ Event Check-out Confirmation và Check-in Confirmation để tránh spam hộp thư độc giả
- Thời gian giữ reservation lấy từ `SystemConfigurations.RESERVATION_HOLD_DAYS` (dynamic, không hardcode)
