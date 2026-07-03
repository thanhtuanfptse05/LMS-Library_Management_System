# Feature Specification: Xác thực tài khoản (Authentication)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng này cung cấp cơ chế xác thực bảo mật cho toàn bộ người dùng trong hệ thống thư viện (LMS), bao gồm các chức năng đăng nhập, đăng xuất, phục hồi mật khẩu và đăng nhập SSO Google, cùng với cơ chế phân quyền dựa trên vai trò (RBAC) để bảo vệ các tài nguyên hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách (Guest):** Có thể truy cập trang đăng nhập, đăng nhập bằng Google, và yêu cầu quên mật khẩu.\n* **Người dùng đã đăng nhập (User):** Có thể thực hiện đăng xuất và thay đổi mật khẩu cá nhân.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-01 (Authentication):** Hệ thống SHALL tạm đình chỉ quyền truy cập nếu người dùng cung cấp thông tin xác thực sai 5 lần liên tiếp.\n* **BR-02 (Authentication):** Thời gian đình chỉ quyền truy cập mặc định cho các vi phạm bảo mật SHALL là 30 phút kể từ lần cuối.\n* **BR-03 (Security):** Hệ thống SHALL cung cấp thông báo lỗi chung cho xác thực thất bại để ngăn chặn việc dò quét thông tin.\n* **BR-04 (Security):** Đối với yêu cầu khôi phục mật khẩu, hệ thống SHALL trả về thông báo giả định chung bất kể định danh tồn tại hay không.\n* **BR-05 (Authentication):** Việc tự động khôi phục quyền truy cập SHALL chỉ áp dụng cho tài khoản bị đình chỉ do sai sót thông tin xác thực.\n* **BR-06 (Authentication):** Tài khoản bị đình chỉ do vi phạm hành chính hoặc nợ phạt SHALL KHÔNG được tự động khôi phục theo thời gian.\n* **BR-07 (Security):** Thông tin xác thực tạm thời được cấp tự động (khi quên mật khẩu) SHALL bao gồm đúng 8 ký tự ngẫu nhiên.\n* **BR-09 (Security):** Mật khẩu mới BẮT BUỘC đáp ứng tiêu chuẩn bảo mật (tối thiểu 8 ký tự, bao gồm chữ và số).\n* **BR-26 (Google SSO):** Tính năng Google SSO KHÔNG ĐƯỢC PHÉP tự động tạo tài khoản mới. Hệ thống BẮT BUỘC trả về lỗi nếu email Google chưa được Admin cấp phát trước.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-01 (Xác minh danh tính):** WHEN người dùng gửi thông tin đăng nhập, THE system SHALL kiểm tra email trong DB. WHERE email tồn tại, THE system SHALL mã hóa password bằng BCrypt và đối chiếu. WHERE không tồn tại, THE system SHALL gọi runDummyVerify() để ngăn Timing Attack. Hệ thống SHALL trả về thông báo lỗi chung.\n* **FR-02 (Kiểm soát trạng thái khóa):** AFTER xác thực thành công, THE system SHALL kiểm tra lý do khóa. WHERE tồn tại reason='unpaid' và không có lý do khác, THE system SHALL cho phép đăng nhập và đặt warning. WHERE có 'securitybreach' hoặc 'adminban', THE system SHALL chặn đăng nhập.\n* **FR-03 (Tự động mở khóa):** WHERE User.status='locked' và lockedUntil < NOW(), THE system SHALL tự động xóa lý do 'securitybreach' và kích hoạt lại tài khoản.\n* **FR-04 (Đăng nhập sai và khóa tạm):** WHEN đăng nhập thất bại, THE system SHALL tăng số lần failedLoginAttempts. WHERE đạt 5 lần, THE system SHALL khóa tài khoản 30 phút, đặt status='locked' và insert UserLockReason.\n* **FR-05 (Tạo session & redirect theo role):** WHEN đăng nhập thành công, THE system SHALL tạo HttpSession và điều hướng về dashboard phù hợp: ADMIN->/admin/dashboard, LIBRARIAN->/librarian/dashboard, MANAGER->/manager/dashboard, STUDENT->/student/dashboard, LECTURER->/lecturer/dashboard.\n* **FR-06 (Đăng xuất):** WHEN người dùng yêu cầu đăng xuất, THE system SHALL vô hiệu hóa session và redirect về trang đăng nhập.\n* **FR-07 (Forgot Password giả định):** WHEN yêu cầu quên mật khẩu gửi lên, THE system SHALL trả về thông báo thành công chung để tránh dò email.\n* **FR-08 (Cấp mật khẩu tạm):** WHEN xác nhận email thành công cho Forgot Password, THE system SHALL sinh 8 ký tự ngẫu nhiên làm mật khẩu tạm, lưu hash BCrypt và gửi email async.\n* **FR-42 (Google Login SSO):** WHEN nhận callback code từ Google OAuth, THE system SHALL xác thực email Google. WHERE email không tồn tại trong DB, SHALL báo lỗi. WHERE tồn tại, SHALL đăng nhập và redirect theo vai trò.\n* **FR-77 (Safe Redirect Validation):** WHEN redirect dựa trên query parameter, THE system SHALL validate đường dẫn an toàn (chống Open Redirect).

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Chống SQL Injection bằng PreparedStatement, mã hóa BCrypt cho mật khẩu, bảo vệ chống Session Fixation và Open Redirect.\n* Hiệu năng: Thời gian xác thực thông tin đăng nhập dưới 300ms (ngoại trừ dummy verify để cân bằng thời gian).

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng User\n* `userId` (INT, PK, Identity)\n* `email` (VARCHAR(255), UNIQUE, NOT NULL)\n* `passwordHash` (VARCHAR(255), NOT NULL)\n* `status` (VARCHAR(50), DEFAULT 'active')\n* `role` (VARCHAR(50), NOT NULL)\n* `failedLoginAttempts` (INT, DEFAULT 0)\n* `lockedUntil` (TIMESTAMP, NULL)\n\n### Bảng UserLockReason\n* `lockReasonId` (INT, PK, Identity)\n* `userId` (INT, FK, REFERENCES "User")\n* `reason` (VARCHAR(50), NOT NULL)\n* `createdAt` (TIMESTAMP, DEFAULT NOW())\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE thông tin đăng nhập trống hoặc sai định dạng, THE system SHALL trả về thông báo lỗi chi tiết trên biểu mẫu.\n* WHERE lỗi kết nối CSDL xảy ra, THE system SHALL ghi log lỗi và chuyển hướng đến trang báo lỗi hệ thống thân thiện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Happy Path: Đăng nhập thành công với email và mật khẩu đúng, chuyển hướng đến đúng dashboard theo vai trò.\n- [ ] Đăng nhập sai 5 lần liên tiếp: Tài khoản bị khóa tạm trong 30 phút, kiểm tra bảng UserLockReason có dòng mới.\n- [ ] Quên mật khẩu: Gửi email chứa mật khẩu tạm thời 8 ký tự, mật khẩu mới hoạt động bình thường.\n- [ ] Bypass Authentication: Truy cập trực tiếp các trang trong /admin/* mà chưa đăng nhập, bị chặn bởi AuthFilter và redirect về /login.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tự đăng ký tài khoản mới trực tuyến (tất cả tài khoản phải được Admin cấp phát).\n* Tích hợp xác thực 2 thành phần (2FA) qua SMS hoặc ứng dụng Authenticator trong sprint này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
