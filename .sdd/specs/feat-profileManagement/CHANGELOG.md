# CHANGELOG.md — Quản lý hồ sơ người dùng (feat-profileManagement)

## [1.1.0] — 2026-06-01
### Added (SPEC.md — FR & Unwanted Patterns)
* **[FR mới — AuditLog]:** Sau khi đổi mật khẩu thành công, hệ thống SHALL ghi bản ghi vào bảng `AuditLogs` với `actionType='CHANGE_PASSWORD'` (tuân thủ ARCH-02).
* **[FR mới — Session Invalidation]:** Sau khi đổi mật khẩu thành công, hệ thống SHALL hủy `HttpSession` hiện tại và buộc người dùng đăng nhập lại (tăng cường bảo mật).
* **[Unwanted Pattern mới — UPSERT]:** Khi bản ghi `MemberProfile` chưa tồn tại cho `userId`, hệ thống SHALL thực thi `INSERT` thay vì `UPDATE`, ngăn chặn lỗi dữ liệu cho user mới.

### Changed (TASKS.md — DoD cập nhật)
* **T-01 DoD:** Thay thế hàm `updateProfile()` bằng `upsertProfile()` — hàm mới xử lý cả Insert và Update trong một transaction.
* **T-03 DoD:** Bổ sung item (3) — `changeUserPassword` phải gọi ghi log `AuditLogs` sau khi đổi mật khẩu thành công.
* **T-05 DoD:** Bổ sung item (5) — `session.invalidate()` bắt buộc được gọi trước redirect sau khi đổi mật khẩu. Est tăng từ `2h` lên `2.5h`.

---

## [1.0.0] — 2026-06-01
### Added
* Thiết lập trạng thái LOCKED cho toàn bộ tài liệu đặc tả của Feature: Profile Management.
* Chốt luồng dữ liệu (Data Flow) cho các tính năng Xem hồ sơ, Cập nhật thông tin định danh và Thay đổi mật khẩu theo sơ đồ `ActivityDiagramF2.txt`.
* Thiết kế truy vết chức năng thay đổi mật khẩu an toàn sử dụng Regex và thuật toán BCrypt.
* Phân rã 06 Tasks thực thi kỹ thuật (T-01 đến T-06) tuân thủ kiến trúc Servlet MVC.

### Changed (Kiến trúc & Quyết định hệ thống)
* **[Architectural Decision 01 - Bỏ qua OTP]:** Dựa trên xác nhận ở Cổng Làm Rõ (Clarification Gate), hệ thống chính thức áp dụng phương án KHÔNG tích hợp gửi/xác thực mã OTP cho tiến trình đổi mật khẩu trong giao diện hồ sơ. Xác thực thay đổi mật khẩu hoàn toàn dựa trên việc kiểm tra chéo "Mật khẩu hiện tại" lưu tại bảng `[User]`.

### Security
* Áp dụng xác thực Policy mật khẩu bằng Server-side Regex. 
* Kế thừa module chống SQL Injection thông qua bắt buộc sử dụng `PreparedStatement`.
