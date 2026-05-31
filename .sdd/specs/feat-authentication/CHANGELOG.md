# CHANGELOG.md — Authentication Feature
# Theo dõi lịch sử thay đổi Đặc tả và Kiến trúc của tính năng Xác thực.

## [1.0.0] — 2026-05-31
### Added (Khởi tạo)
- Khởi tạo bộ tài liệu Đặc tả gốc bao gồm `CONTEXT.md`, `SPEC.md`, `PLAN.md`, và `TASKS.md`.
- Áp dụng các luật EARS cho luồng Login, Logout và Forgot Password.
- Áp dụng BR01, BR03 và ràng buộc lưu vết Audit Log.

### Changed (Quyết định Kiến trúc & Xung đột đã giải quyết)
- **[Architectural Decision 01]:** Đã thống nhất sử dụng `HttpSession` thuần của Java EE thay cho `JWT Token`. Lý do: Đảm bảo tính nhất quán (Consistency) với Database Schema hiện tại (không có bảng lưu token) và phù hợp với kiến trúc Servlet nguyên bản.
- **[Architectural Decision 02]:** Chốt phương án quản lý khóa tài khoản tạm thời 30 phút bằng cách cập nhật cột `lockedUntil` trong Database thay vì dùng Job chạy ngầm (Scheduled Task). Tối ưu hiệu năng hệ thống.

### Security (Bảo mật)
- **[Security Constraint]:** BẮT BUỘC sử dụng thư viện `jbcrypt-0.4.jar` (đã thêm vào `/WEB-INF/lib/`) để mã hóa mật khẩu. Tuyệt đối KHÔNG sử dụng `MessageDigest` (MD5/SHA-1) có sẵn của Java để tránh lỗ hổng bảo mật.
- Bổ sung cơ chế chống dò quét tài khoản (User Enumeration): Báo lỗi chung "Tài khoản hoặc mật khẩu không chính xác" cho cả trường hợp sai email và sai password.