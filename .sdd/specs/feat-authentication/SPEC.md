# Feature Specification: Xác thực tài khoản (Authentication)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng này cung cấp cơ chế xác thực bảo mật cho toàn bộ người dùng trong hệ thống thư viện (LMS), bao gồm các chức năng đăng nhập, đăng xuất, phục hồi mật khẩu và đăng nhập SSO Google, cùng với cơ chế phân quyền dựa trên vai trò (RBAC) để bảo vệ các tài nguyên hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách (Guest):** Có thể truy cập trang đăng nhập, đăng nhập bằng Google, và yêu cầu quên mật khẩu.
* **Người dùng đã đăng nhập (User):** Có thể thực hiện đăng xuất và thay đổi mật khẩu cá nhân.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-01 (Login):** Actor: Guest, User | (Đăng nhập): Người dùng cung cấp Email và Mật khẩu để xác thực quyền truy cập hệ thống.
* **UC-02 (Logout):** Actor: User | (Đăng xuất): Người dùng chủ động kết thúc phiên làm việc để bảo mật thông tin cá nhân.
* **UC-03 (Reset Password):** Actor: Guest | (Quên mật khẩu): Người dùng yêu cầu hệ thống cấp mật khẩu tạm thời qua Email khi không thể truy cập.
* **UC-21 (Login with Google):** Actor: Guest | (Đăng nhập bằng Google): Người dùng sử dụng tài khoản Google SSO để xác thực. Hệ thống chỉ cho phép đăng nhập nếu email đã được cấp tài khoản.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-01 (Login):** Actor: Guest, User | (Đăng nhập): Người dùng cung cấp Email và Mật khẩu để xác thực quyền truy cập hệ thống.
* **UC-02 (Logout):** Actor: User | (Đăng xuất): Người dùng chủ động kết thúc phiên làm việc để bảo mật thông tin cá nhân.
* **UC-03 (Reset Password):** Actor: Guest | (Quên mật khẩu): Người dùng yêu cầu hệ thống cấp mật khẩu tạm thời qua Email khi không thể truy cập.
* **UC-21 (Login with Google):** Actor: Guest | (Đăng nhập bằng Google): Người dùng sử dụng tài khoản Google SSO để xác thực. Hệ thống chỉ cho phép đăng nhập nếu email đã được cấp tài khoản.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-01 (Login):** Actor: Guest, User | (Đăng nhập): Người dùng cung cấp Email và Mật khẩu để xác thực quyền truy cập hệ thống.
* **UC-02 (Logout):** Actor: User | (Đăng xuất): Người dùng chủ động kết thúc phiên làm việc để bảo mật thông tin cá nhân.
* **UC-03 (Reset Password):** Actor: Guest | (Quên mật khẩu): Người dùng yêu cầu hệ thống cấp mật khẩu tạm thời qua Email khi không thể truy cập.
* **UC-21 (Login with Google):** Actor: Guest | (Đăng nhập bằng Google): Người dùng sử dụng tài khoản Google SSO để xác thực. Hệ thống chỉ cho phép đăng nhập nếu email đã được cấp tài khoản.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-01 (Authentication):** Hệ thống SHALL tạm đình chỉ quyền truy cập nếu người dùng cung cấp thông tin xác thực sai 5 lần liên tiếp.
* **BR-02 (Authentication):** Thời gian đình chỉ quyền truy cập mặc định cho các vi phạm bảo mật SHALL là 30 phút kể từ lần cuối.
* **BR-03 (Security):** Hệ thống SHALL cung cấp thông báo lỗi chung cho xác thực thất bại để ngăn chặn việc dò quét thông tin.
* **BR-04 (Security):** Đối với yêu cầu khôi phục mật khẩu, hệ thống SHALL trả về thông báo giả định chung bất kể định danh tồn tại hay không.
* **BR-05 (Authentication):** Việc tự động khôi phục quyền truy cập SHALL chỉ áp dụng cho tài khoản bị đình chỉ do sai sót thông tin xác thực.
* **BR-06 (Authentication):** Tài khoản bị đình chỉ do vi phạm hành chính hoặc nợ phạt SHALL KHÔNG được tự động khôi phục theo thời gian.
* **BR-07 (Security):** Thông tin xác thực tạm thời được cấp tự động (khi quên mật khẩu) SHALL bao gồm đúng 8 ký tự ngẫu nhiên.
* **BR-09 (Security):** Mật khẩu mới BẮT BUỘC đáp ứng tiêu chuẩn bảo mật.
* **BR-26 (Google SSO Registration Policy):** Tính năng Google SSO KHÔNG ĐƯỢC PHÉP tự động tạo tài khoản mới. Hệ thống BẮT BUỘC trả về lỗi nếu email Google chưa được Admin cấp phát trước.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-01 (Xác minh danh tính với chống Timing Attack):** WHEN người dùng gửi thông tin đăng nhập, THE system SHALL kiểm tra email trong DB. WHERE email tồn tại, THE system SHALL mã hóa plaintext password bằng BCrypt và đối chiếu với passwordHash đã lưu. WHERE email KHÔNG tồn tại, THE system SHALL gọi authService.runDummyVerify() để cân bằng thời gian phản hồi, ngăn chặn Timing Attack. THE system SHALL LUÔN trả về thông báo lỗi chung "Tài khoản hoặc mật khẩu không chính xác" để chống User Enumeration.
  * *Mapping:* UC-01 / BR-03, BR-09
* **FR-02 (Kiểm soát trạng thái phân biệt lý do khóa):** AFTER xác thực thành công, THE system SHALL truy vấn bảng UserLockReason để kiểm tra lý do khóa. WHERE tồn tại reason='unpaid' VÀ KHÔNG có reason='securitybreach' hoặc 'adminban', THE system SHALL CHO PHÉP đăng nhập VÀ đặt flag unpaidWarning=true vào session để hiển thị cảnh báo. WHERE tồn tại reason='securitybreach' hoặc 'adminban', THE system SHALL CHẶN đăng nhập VÀ redirect về /login?error=locked.
  * *Mapping:* UC-01 / BR-06
* **FR-03 (Tự động khôi phục khi hết thời gian khóa tạm):** WHERE User.status='locked' VÀ lockedUntil != NULL VÀ NOW() > lockedUntil, THE system SHALL tự động xóa reason='securitybreach' trong UserLockReason, UPDATE User.status='active', VÀ reset failedLoginAttempts=0. THEN CHO PHÉP đăng nhập tiếp. (Chỉ áp dụng cho khóa tạm do sai mật khẩu, KHÔNG áp dụng cho adminban hoặc lockedUntil=NULL).
  * *Mapping:* UC-01 / BR-05
* **FR-04 (Ghi nhận đăng nhập sai và khóa tự động):** WHEN mật khẩu không khớp, THE system SHALL gọi authService.handleFailedLogin(user) để tăng User.failedLoginAttempts lên 1. WHERE failedLoginAttempts ≥ 5, THE system SHALL tự động gọi lockAccount(userId, 30 phút) để: (1) INSERT UserLockReason(userId, reason='securitybreach'), (2) UPDATE User.status='locked' VÀ User.lockedUntil = NOW() + 30 phút, (3) Trả về số lần đăng nhập sai = 5 để hiển thị thông báo.
  * *Mapping:* UC-01 / BR-01, BR-02
* **FR-05 (Tạo session và redirect theo role):** WHEN đăng nhập thành công, THE system SHALL tạo HttpSession mới chứa: {userId, role, email, fullName, unpaidWarning (nếu có)}. THEN THE system SHALL gọi getRedirectByRole(role) để redirect về dashboard tương ứng: ADMIN→/admin/dashboard, LIBRARIAN→/librarian/dashboard, MANAGER→/manager/dashboard, STUDENT→/student/dashboard, LECTURER→/lecturer/dashboard. WHERE có query param redirect hợp lệ (qua isSafeInternalRedirect), ưu tiên redirect theo param.
  * *Mapping:* UC-01
* **FR-06 (Hủy bỏ phiên làm việc):** WHEN có yêu cầu đăng xuất, THE system SHALL vô hiệu hóa hoàn toàn HttpSession hiện tại và điều hướng trình duyệt về màn hình đăng nhập.
  * *Mapping:* UC-02
* **FR-07 (Trả kết quả giả định cho Forgot Password):** WHEN ForgotPasswordServlet.handleForgotPasswordRequest(email) được gọi, THE system SHALL tìm user theo email. WHERE email KHÔNG tồn tại, THE system SHALL KHÔNG gọi authService.resetPassword() NHƯNG VẪN trả về JSON {success:true, message:"Mật khẩu tạm thời đã được gửi đến email của bạn"} để chống User Enumeration. WHERE email tồn tại, gọi resetPassword() và enqueue email RESET_PASSWORD async.
  * *Mapping:* UC-03 / BR-04
* **FR-08 (Cấp mật khẩu tạm và Reset mật khẩu):** WHEN authService.resetPassword(email) được gọi, THE system SHALL: (1) Gọi generateRandomPassword() để sinh 8 ký tự ngẫu nhiên từ [A-Za-z0-9], (2) Mã hóa BCrypt, (3) Gọi UserDAO.updatePasswordHash(), (4) Trả về plaintext password để ForgotPasswordServlet enqueue email. WHEN handleResetPassword(email, tempPassword, newPassword, confirmPassword), THE system SHALL validate: newPassword ≥ 8 ký tự VÀ chứa [a-zA-Z] VÀ [0-9], tempPassword khớp với DB, confirmPassword == newPassword. THEN mã hóa BCrypt newPassword, updatePasswordHash, INSERT AuditLog(CHANGE_PASSWORD).
  * *Mapping:* UC-03 / BR-07, BR-09
* **FR-42 (Google SSO Verification):** WHEN GoogleLoginServlet.doGet() nhận code param từ Google OAuth callback, THE system SHALL: (1) Đổi code → accessToken qua GoogleSSOUtil.exchangeCodeForToken(code), (2) Lấy email từ Google Token bằng GoogleSSOUtil.getUserEmail(accessToken), (3) Tìm User bằng email trong DB: UserDAO.findByEmail(email). WHERE email KHÔNG tồn tại, THE system SHALL trả lỗi "Email chưa được cấp tài khoản trong hệ thống LMS". WHERE tồn tại, kiểm tra locked tương tự FR-02 (phân biệt unpaid vs securitybreach/adminban), FR-03 (auto-unlock nếu hết thời gian khóa tạm). THEN tạo HttpSession với {userId, role, email, fullName} và gọi getRedirectByRole(role) để redirect. **BUG HIỆN TẠI**: GoogleLoginServlet.getRedirectByRole() hiện luôn return "/" thay vì dashboard đúng theo role → CẦN SỬA để redirect logic giống LoginServlet (ADMIN→/admin/dashboard, LIBRARIAN→/librarian/dashboard, MANAGER→/manager/dashboard, STUDENT→/student/dashboard, LECTURER→/lecturer/dashboard). WHERE có query param redirect, áp dụng FR-77 (whitelist validation) trước khi redirect.
  * *Mapping:* UC-21 / BR-26
* **FR-77 (Whitelist validation cho Safe Redirect):** WHEN LoginServlet hoặc GoogleLoginServlet nhận query param redirect, THE system SHALL gọi isSafeInternalRedirect(redirect) để kiểm tra: redirect KHÔNG chứa ["://", "..", "\\", "\r", "
"]. WHERE hợp lệ, redirect theo param. WHERE không hợp lệ, bỏ qua param và redirect theo role mặc định từ getRedirectByRole(role). Whitelist validation ngăn chặn Open Redirect Attack bằng cách chặn: (1) Absolute URLs với protocol ("://"), (2) Path traversal (".."), (3) Windows path separator ("\\"), (4) CRLF injection ("\r", "
").
  * *Mapping:* UC-01, UC-21

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Chống SQL Injection bằng PreparedStatement, mã hóa BCrypt cho mật khẩu, bảo vệ chống Session Fixation và Open Redirect.
* Hiệu năng: Thời gian xác thực thông tin đăng nhập dưới 300ms (ngoại trừ dummy verify để cân bằng thời gian).

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng User
* `userId` (INT, PK, Identity)
* `email` (VARCHAR(255), UNIQUE, NOT NULL)
* `passwordHash` (VARCHAR(255), NOT NULL)
* `status` (VARCHAR(50), DEFAULT 'active')
* `role` (VARCHAR(50), NOT NULL)
* `failedLoginAttempts` (INT, DEFAULT 0)
* `lockedUntil` (TIMESTAMP, NULL)

### Bảng UserLockReason
* `lockReasonId` (INT, PK, Identity)
* `userId` (INT, FK, REFERENCES "User")
* `reason` (VARCHAR(50), NOT NULL)
* `createdAt` (TIMESTAMP, DEFAULT NOW())



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE thông tin đăng nhập trống hoặc sai định dạng, THE system SHALL trả về thông báo lỗi chi tiết trên biểu mẫu.
* WHERE lỗi kết nối CSDL xảy ra, THE system SHALL ghi log lỗi và chuyển hướng đến trang báo lỗi hệ thống thân thiện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Happy Path: Đăng nhập thành công với email và mật khẩu đúng, chuyển hướng đến đúng dashboard theo vai trò.
- [ ] Đăng nhập sai 5 lần liên tiếp: Tài khoản bị khóa tạm trong 30 phút, kiểm tra bảng UserLockReason có dòng mới.
- [ ] Quên mật khẩu: Gửi email chứa mật khẩu tạm thời 8 ký tự, mật khẩu mới hoạt động bình thường.
- [ ] Bypass Authentication: Truy cập trực tiếp các trang trong /admin/* mà chưa đăng nhập, bị chặn bởi AuthFilter và redirect về /login.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tự đăng ký tài khoản mới trực tuyến (tất cả tài khoản phải được Admin cấp phát).
* Tích hợp xác thực 2 thành phần (2FA) qua SMS hoặc ứng dụng Authenticator trong sprint này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.