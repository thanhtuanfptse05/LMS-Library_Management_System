# Feature Specification: Xác thực tài khoản (Authentication)
# Version: 1.2 | Chủ sở hữu: @tuan | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng này cung cấp cơ chế xác thực bảo mật cho toàn bộ người dùng trong hệ thống Quản lý Thư viện (LMS), bao gồm các chức năng Đăng nhập, Đăng xuất, Quên/Khôi phục mật khẩu và Đăng nhập SSO bằng tài khoản Google, kết hợp với cơ chế phân quyền dựa trên vai trò (RBAC) để bảo vệ tài nguyên hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách (Guest):** Truy cập trang đăng nhập, thực hiện đăng nhập bằng Email/Password hoặc Google SSO, yêu cầu phục hồi mật khẩu qua email.
* **Người dùng đã đăng nhập (User - All Roles):** Thực hiện đăng xuất và thay đổi mật khẩu cá nhân.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-01 (Login):** Actor: Guest | Người dùng cung cấp Email và Mật khẩu để hệ thống xác thực.
* **UC-02 (Logout):** Actor: User | Người dùng chủ động kết thúc phiên làm việc.
* **UC-03 (Reset Password):** Actor: Guest | Người dùng yêu cầu mật khẩu tạm thời qua Email khi quên mật khẩu.
* **UC-21 (Login with Google):** Actor: Guest | Đăng nhập nhanh bằng tài khoản Google SSO (chỉ cho phép email đã cấp phát trước trong hệ thống).

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-01 (Authentication):** Hệ thống SHALL tự động khóa tài khoản tạm thời 30 phút nếu nhập sai mật khẩu 5 lần liên tiếp.
* **BR-02 (Security - Anti User Enumeration):** Thông báo lỗi đăng nhập hoặc quên mật khẩu SHALL là thông báo giả định chung, không tiết lộ sự tồn tại của email trong CSDL.
* **BR-03 (Security - Anti Timing Attack):** Khi email không tồn tại trong CSDL, hệ thống SHALL gọi hàm `runDummyVerify()` để giả lập thời gian mã hóa BCrypt nhằm cân bằng thời gian phản hồi.
* **BR-04 (Auto Unlock):** Tài khoản bị khóa tạm do sai mật khẩu (`reason='securitybreach'`) SHALL được tự động mở khóa sau 30 phút. Không tự động mở khóa cho tài khoản bị cấm bởi Admin (`adminban`).
* **BR-26 (Google SSO Policy):** Đăng nhập Google SSO KHÔNG ĐƯỢC tự động tạo tài khoản mới. Nếu email chưa được Admin cấp phát trước, hệ thống SHALL từ chối truy cập.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-01 (Xác thực thông thường):** WHEN người dùng gửi thông tin đăng nhập từ `LoginServlet`, THE system SHALL kiểm tra email trong bảng `"User"`. WHERE email tồn tại, hệ thống SHALL mã hóa bcrypt và so sánh passwordHash. WHERE email không tồn tại, hệ thống SHALL thực thi `authService.runDummyVerify()` để chống Timing Attack, sau đó LUÔN trả về lỗi chung "Tài khoản hoặc mật khẩu không chính xác".
  * *Mapping:* UC-01 / BR-02, BR-03
* **FR-02 (Phân loại lý do khóa):** AFTER xác thực thành công, THE system SHALL kiểm tra bảng `UserLockReason`. WHERE có `reason='unpaid'` và không có `adminban` hay `securitybreach`, hệ thống CHO PHÉP đăng nhập và bật `unpaidWarning=true` trong session. WHERE có `reason='securitybreach'` hoặc `adminban`, hệ thống CHẶN đăng nhập và hiển thị lí do khóa.
  * *Mapping:* UC-01 / BR-01, BR-04
* **FR-03 (Tự động mở khóa tạm):** WHERE `User.status='locked'` VÀ `NOW() > User.lockedUntil`, THE system SHALL tự động xóa lý do `securitybreach`, chuyển status sang `'active'`, reset `failedLoginAttempts=0` và CHO PHÉP người dùng đăng nhập tiếp.
  * *Mapping:* UC-01 / BR-04
* **FR-04 (Tăng đếm và Khóa tự động):** WHEN mật khẩu không khớp, THE system SHALL gọi `handleFailedLogin()` tăng `failedLoginAttempts` thêm 1. WHERE `failedLoginAttempts >= 5`, hệ thống tự động chèn bản ghi `UserLockReason(userId, 'securitybreach')`, cập nhật `status='locked'` và `lockedUntil = NOW() + 30 minutes`.
  * *Mapping:* UC-01 / BR-01
* **FR-05 (Điều hướng theo Vai trò):** WHEN đăng nhập thành công, THE system SHALL khởi tạo `HttpSession` chứa `{userId, role, email, fullName}`. THEN hệ thống gọi `getRedirectByRole(role)` để chuyển hướng: ADMIN→`/admin/dashboard`, LIBRARIAN→`/librarian/dashboard`, MANAGER→`/manager/dashboard`, STUDENT→`/student/dashboard`, LECTURER→`/lecturer/dashboard`.
  * *Mapping:* UC-01
* **FR-06 (Đăng xuất):** WHEN người dùng gửi yêu cầu đăng xuất tới `LogoutServlet`, THE system SHALL hủy phiên `HttpSession.invalidate()` và chuyển hướng về `/login`.
  * *Mapping:* UC-02
* **FR-07 (Quên mật khẩu & Chống lộ thông tin):** WHEN `ForgotPasswordServlet` nhận email khôi phục, hệ thống SHALL LUÔN hiển thị thông báo "Mật khẩu tạm thời đã được gửi đến email của bạn". WHERE email tồn tại trong DB, hệ thống sinh mật khẩu ngẫu nhiên 8 ký tự, hash BCrypt, cập nhật `passwordHash` và gửi email async qua `EmailService`.
  * *Mapping:* UC-03 / BR-02
* **FR-08 (Đăng nhập Google SSO):** WHEN `GoogleLoginServlet` nhận auth code từ Google, hệ thống SHALL trao đổi lấy `accessToken` và trích xuất email. WHERE email chưa tồn tại trong DB, hệ thống từ chối với thông báo "Email chưa được cấp tài khoản". WHERE hợp lệ, tiến hành tạo session và redirect theo role.
  * *Mapping:* UC-21 / BR-26

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Mật khẩu lưu trong CSDL bắt buộc dùng BCrypt hash (strength 10+). Tham số đường dẫn redirect phải qua Whitelist validation để chống Open Redirect.
* **Hiệu năng:** Đơn tạo email gửi mật khẩu tạm chạy async không làm nghẽn luồng xử lý web (HTTP Thread).
* **Giao diện:** 100% tiếng Việt, thân thiện và hỗ trợ đầy đủ các thông báo alert.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `"User"`
* `userId` (INT, PK, SERIAL)
* `email` (VARCHAR(255), UNIQUE, NOT NULL)
* `passwordHash` (VARCHAR(255), NOT NULL)
* `status` (VARCHAR(20), NOT NULL) — active / locked / inactive
* `role` (VARCHAR(50), NOT NULL) — ADMIN / LIBRARIAN / MANAGER / STUDENT / LECTURER
* `failedLoginAttempts` (INT, DEFAULT 0)
* `lockedUntil` (TIMESTAMP, NULL)

### Bảng `UserLockReason`
* `lockReasonId` (INT, PK, SERIAL)
* `userId` (INT, FK REFERENCES `"User"`)
* `reason` (VARCHAR(100), NOT NULL) — securitybreach / unpaid / adminban
* `createdAt` (TIMESTAMP, DEFAULT NOW())

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** thông tin đăng nhập không hợp lệ, **THE system SHALL** trả về lỗi "Tài khoản hoặc mật khẩu không chính xác".
* **WHERE** kết nối CSDL bị đứt gãy (`DatabaseException`), **THE system SHALL** ghi log chi tiết phía server và hiển thị thông báo lỗi hệ thống thân thiện.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-AUTH-01] Đăng nhập thành công với email và password đúng, chuyển hướng đúng dashboard theo role.
- [ ] [TC-AUTH-02] Đăng nhập thất bại 5 lần liên tiếp khiến tài khoản bị khóa trong 30 phút.
- [ ] [TC-AUTH-03] Quên mật khẩu tạo mật khẩu 8 ký tự gửi qua email và đăng nhập thành công bằng mật khẩu mới.
- [ ] [TC-AUTH-04] Đăng nhập Google SSO thành công nếu email đã tồn tại trong DB, báo lỗi nếu email lạ.
- [ ] [TC-AUTH-05] Đăng xuất vô hiệu hóa Session và redirect về trang `/login`.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động đăng ký tài khoản công khai thông qua Google SSO.
* Xác thực 2 yếu tố (2FA / OTP SMS).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã cấu hình và hoàn thiện Google SSO và BCrypt password hashing.