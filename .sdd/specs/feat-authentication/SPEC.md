# SPEC.md — Authentication
# Version: 2.0.0 | Status: DRAFT | Phân loại: Formal Spec

## 1. Context & Goal
Đảm bảo an toàn truy cập bằng cơ chế kiểm soát lỗi đăng nhập và quản lý phiên làm việc thông qua HttpSession.

## 2. Actors & Roles
- Guest: Truy cập `Access Authentication System`.
- LMS System: Xử lý logic, truy vấn DB.
- Email System: Gửi thông báo (Background task).

## 3. Functional Requirements (EARS)

### Luồng Đăng nhập (Login)
- WHEN Guest submits Login Form, THE LMS System SHALL Query User Data dựa trên Email [Node 5.6].
- WHERE Email tồn tại, THE LMS System SHALL Check Account Status [Node 7.10].
- WHILE status = 'locked', THE LMS System SHALL kiểm tra `lockedUntil`. Nếu `lockedUntil <= NOW`, THE LMS System SHALL update status='active', `lockReason`=null, `failedLoginAttempts`=0 [Node 10.17].
- WHEN Account is active, THE LMS System SHALL Verify BCrypt Password [Node 11.18].
- WHERE Password is correct, THE LMS System SHALL Create Http Session (lưu userId, role), set `failedLoginAttempts` = 0, VÀ Redirect To Dashboard theo Role [Node 13.21, 14.23].

### Luồng Quên mật khẩu (Forgot Password)
- WHEN Guest submits Forgot Password Form, THE LMS System SHALL Query User Data For Reset [Node 5.7].
- WHERE Email tồn tại, THE LMS System SHALL Generate New Password (8 ký tự ngẫu nhiên), mã hóa BCrypt VÀ update DB [Node 7.12].
- WHEN New Password is saved, THE Email System SHALL Send Password Email chạy ngầm [Node 8.14].

### Luồng Đăng xuất (Logout)
- WHEN User Requests Logout, THE LMS System SHALL Invalidate Session [Node 16.27] VÀ Redirect To Login [Node 17.28].

## 4. Non-functional Requirements
- [NFR-01] Security: Mật khẩu KHÔNG ĐƯỢC PHÉP log dưới dạng plaintext.
- [NFR-02] Performance: Gửi email [Node 8.14] BẮT BUỘC thực hiện qua ExecutorService (Async) để không block luồng HTTP.

## 5. Data Model (Schema Mapping)
Table: `[User]`
- `email`: Nhận dạng tài khoản.
- `passwordHash`: Đối chiếu BCrypt.
- `status`: 'active' hoặc 'locked'.
- `lockReason`: 'securitybreach' (đối với lỗi đăng nhập).
- `failedLoginAttempts`: INT (Reset về 0 nếu đăng nhập thành công).
- `lockedUntil`: DATETIME.

## 6. Error Handling (Unwanted Patterns)
- WHERE Password incorrect, THE LMS System SHALL Increase `failedLoginAttempts` += 1 [Node 13.20].
- WHERE `failedLoginAttempts` >= 5, THE LMS System SHALL Execute Temp Lock (status='locked', lockedUntil = NOW + 30 phút, lockReason='securitybreach') [Node 15.24].
- WHERE Email không tồn tại VÀ Request = Login, THE LMS System SHALL Return Auth Error chung: "Tài khoản hoặc mật khẩu không chính xác" [Node 16.26]. (Chống User Enumeration).
- WHERE Email không tồn tại VÀ Request = Forgot Password, THE LMS System SHALL Return Fake Success: "Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới" [Node 7.11].
- WHERE Account is locked VÀ `lockedUntil > NOW`, THE LMS System SHALL Return Lock Time Error: "Tài khoản bị khóa... tự mở khóa lúc [lockedUntil]" [Node 10.16].

## 7. Acceptance Criteria (Traceability to EARS)
- [ ] AC1: Đăng nhập sai 5 lần liên tiếp -> Bị khóa đúng 30 phút (status='locked', lockReason='securitybreach').
- [ ] AC2: Đăng nhập lại sau thời gian khóa -> Tự động mở khóa và đăng nhập thành công.
- [ ] AC3: Gửi form Quên mật khẩu với email không tồn tại -> Hiển thị Fake Success.
- [ ] AC4: Session bị invalidate hoàn toàn sau khi nhấn Logout.

## 8. Out of Scope
- KHÔNG hỗ trợ xác thực JWT.
- KHÔNG yêu cầu xác thực OTP hoặc ép đổi mật khẩu sau khi Reset (dựa trên giải quyết xung đột BR22).
