# SPEC.md — Authentication
# Version: 1.0.0 | Status: DRAFT | Risk Level: HIGH

## 1. Context & Goal
Xử lý đăng nhập (Login), đăng xuất (Logout) và cấp lại mật khẩu (Reset Password) an toàn cho thư viện LMS.

## 2. Actors & Roles
- Guest: Chỉ truy cập `/login.jsp`, `/forgot-password.jsp`.
- User (All roles): Truy cập các trang theo phân quyền tương ứng.

## 3. Functional Requirements (EARS)

### Đăng nhập (Login)
- WHEN Guest submit form `/login` với email và password hợp lệ, THE system SHALL:
  1. Mã hóa password nhập vào và so sánh với `passwordHash` trong DB.
  2. Tạo `HttpSession` chứa thông tin cơ bản: `userId`, `role`, `email`.
  3. Reset cột `failedLoginAttempts` = 0 trong database.
  4. Redirect user đến trang Dashboard tương ứng với `role`.

### Đăng xuất (Logout)
- WHEN User gọi endpoint `/logout`, THE system SHALL vô hiệu hóa (invalidate) `HttpSession` và redirect về `/login.jsp`.

### Quên mật khẩu (Reset Password)
- WHEN Guest submit email vào `/forgot-password`, THE system SHALL:
  1. Tạo ngẫu nhiên một mật khẩu mới (8 ký tự).
  2. Băm (hash) mật khẩu mới đè vào Database.
  3. Gửi email chứa mật khẩu mới cho người dùng.

## 4. Non-functional
- Security: Mật khẩu BẮT BUỘC mã hóa trước khi lưu/so sánh. Không bao giờ log plaintext password.
- Session Timeout: Mặc định 30 phút.

## 5. Data Model (Tham chiếu)
Table `[User]`:
- `email` (NVARCHAR)
- `passwordHash` (NVARCHAR)
- `status` (active / locked)
- `failedLoginAttempts` (INT)

## 6. Error Handling (Unwanted)
- WHERE thông tin đăng nhập sai (email hoặc password), THE system SHALL tăng `failedLoginAttempts` +1 và hiển thị chung lỗi: "Tài khoản hoặc mật khẩu không chính xác" (Chống User Enumeration).
- WHERE `failedLoginAttempts` >= 5, THE system SHALL cập nhật `status = 'locked'` và thông báo tài khoản bị khóa 30 phút.
- WHERE tài khoản có `status = 'locked'`, THE system SHALL chặn đăng nhập ngay lập tức.
- WHERE email reset password không tồn tại, THE system SHALL vẫn thông báo "Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới" (Chống dò quét email).

## 7. Acceptance Criteria
- [ ] Đăng nhập đúng -> Redirect đúng view theo Role.
- [ ] Đăng nhập sai 5 lần -> DB khóa tài khoản.
- [ ] Thông báo lỗi không phân biệt sai email hay sai password.
- [ ] Mật khẩu trong DB không thể dịch ngược (Không plaintext).

## 8. Out of Scope (Không làm trong sprint này)
- Không làm xác thực 2 bước (2FA/OTP).
- Không chặn đăng nhập nhiều thiết bị cùng lúc (Concurrent login).
- Không yêu cầu ép đổi mật khẩu ở lần đăng nhập đầu tiên.
