# CHANGELOG.md — Authentication Feature
# Theo dõi lịch sử thay đổi Đặc tả và Kiến trúc của tính năng Xác thực.

---

## [2.0.0] — 2026-06-01
### Summary
Đồng bộ hóa toàn bộ bộ tài liệu đặc tả (CONTEXT, SPEC, PLAN, TASKS) với sơ đồ hoạt động `ActivityDiagramF1.txt`. Chuyển đổi sang chuẩn EARS Notation với Node ID truy vết. Giải quyết xung đột kiến trúc BR22 vs ActivityDiagramF1.

### Changed
- **[Architectural Update 01]:** Cập nhật Đặc tả luồng dữ liệu (Data Flow) toàn bộ 3 luồng (Login, Forgot Password, Logout) dựa trên `ActivityDiagramF1.txt` với đầy đủ Node ID tham chiếu.
- **[Architectural Update 02]:** Chuyển đổi định dạng SPEC.md sang EARS notation (WHEN/WHERE/WHILE/THE SHALL) để tối ưu hóa việc phân tách tác vụ cho AI Agent và đảm bảo tính truy vết.
- **[Architectural Update 03]:** Đổi header version toàn bộ tài liệu từ 1.0.0 lên 2.0.0 để phản ánh sự thay đổi cơ bản trong spec format.
- **[Logic Update 01]:** Tích hợp logic xử lý Fake Success (`Node 7.11`) cho luồng Quên mật khẩu để ngăn chặn User Enumeration — áp dụng cho cả nhánh email không tồn tại.
- **[Logic Update 02]:** Định nghĩa lại cơ chế tự động mở khóa (Auto-unlock) khi `lockedUntil <= NOW` trực tiếp tại thời điểm đăng nhập (`Node 10.17`), thực hiện tại `LoginServlet` không cần Scheduled Job.
- **[Logic Update 03]:** Bổ sung `lockReason='securitybreach'` vào schema mapping của SPEC.md và logic `lockAccount()` trong UserDAO để phân biệt nguyên nhân khóa tài khoản.
- **[Logic Update 04]:** Bổ sung cảnh báo Timing Attack — yêu cầu LoginServlet gọi BCrypt dummy `checkpw()` khi email không tồn tại để cân bằng thời gian phản hồi.
- **[Task Restructure]:** Đổi Task ID sang format `T-AUTH-XX` (từ `T-XX`), giảm từ 14 tasks xuống 8 tasks atomic, đồng bộ Node ID với ActivityDiagramF1.txt.

### Resolved Conflicts
- **[ActivityDiagramF1.txt — Node 7.12]:** Xác nhận sử dụng sinh mật khẩu ngẫu nhiên 8 ký tự (theo `ActivityDiagramF1.txt`).
- **[Swimlane JWT vs HttpSession]:** Xác nhận loại bỏ hoàn toàn JWT ra khỏi scope. Sử dụng 100% `HttpSession` (C-02) theo AGENTS.md và constitution.md.

### Security
- **[Security Constraint]:** BẮT BUỘC sử dụng `jbcrypt-0.4.jar` để mã hóa mật khẩu. Tuyệt đối KHÔNG dùng `MessageDigest` (MD5/SHA-1).
- **[Anti User Enumeration]:** Thống nhất trả lỗi chung "Tài khoản hoặc mật khẩu không chính xác" cho mọi trường hợp sai đăng nhập [Node 16.26].
- **[NFR-01]:** Cấm log plaintext password tại mọi layer (Service, EmailService, Servlet).

---

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