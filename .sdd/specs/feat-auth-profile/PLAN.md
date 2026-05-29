# Implementation Plan: feat-auth-profile (Xác thực, Phân quyền & Quản lý hồ sơ)

## 1. Database & Models
Ánh xạ các class Model tương ứng với các bảng:
- `User.java` (userId, email, passwordHash, status, role, lockReason, failedLoginAttempts, lockedUntil)
- `MemberProfile.java` (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
- `Student.java` (userId, studentCode, major, enrollmentYear) - kế thừa/chứa `User`
- `Lecturer.java` (userId, lecturerCode, department) - kế thừa/chứa `User`

## 2. Service & DAO Layers (PreparedStatement thuần, try-with-resources)
- **`UserDAO.java`**:
  - `getUserByEmail(String email)`
  - `updateFailedAttemptsAndLock(int userId, int attempts, Timestamp lockedUntil)`
  - `resetFailedAttempts(int userId)`
  - `updatePassword(int userId, String newPasswordHash)`
- **`ProfileDAO.java`**:
  - `getProfileByUserId(int userId)`
  - `updateProfile(MemberProfile profile)`
  - `isPhoneExists(String phone, int excludeUserId)`
- **`StudentDAO.java` & `LecturerDAO.java`**:
  - Thực hiện các câu lệnh `JOIN` với bảng `User` để lấy thông tin cụ thể (Table-per-Type).
  - Cập nhật thông tin chi tiết của học sinh/giảng viên.
- **`AuthService.java`**: Xử lý logic kiểm tra đăng nhập bằng BCrypt, cập nhật số lần đăng nhập sai.
- **`EmailService.java`**: Gửi mã OTP khôi phục mật khẩu bất đồng bộ qua `ExecutorService`.

## 3. Servlets (Controllers)
Tất cả các Servlet đặt tại package `controller.auth`:
- `LoginServlet.java` (POST/GET `/auth/login`)
- `LogoutServlet.java` (GET `/auth/logout`)
- `ForgotPasswordServlet.java` (GET/POST `/auth/forgot-password`)
- `VerifyOTPServlet.java` (GET/POST `/auth/verify-otp`)
- `ChangePasswordServlet.java` (GET/POST `/auth/change-password`)
- `ProfileServlet.java` (GET/POST `/student/profile`)

## 4. Web Filters (RBAC)
- **`AuthorizationFilter.java`** (`@WebFilter("/*")`):
  - Chặn các requests bắt đầu bằng `/student/*`, `/librarian/*`, `/manager/*`, `/admin/*`.
  - Kiểm tra xem session có chứa thông tin `User` hợp lệ hay không.
  - Kiểm tra vai trò của User có khớp với tiền tố đường dẫn không. Nếu không, trả về trang lỗi Access Denied (HTTP 403) hoặc redirect về `/auth/login`.

## 5. Views (JSPs)
Các file giao diện đặt tại thư mục `/web/WEB-INF/views/auth/`:
- `login.jsp`: Trang đăng nhập đẹp mắt, hỗ trợ responsive.
- `forgot-password.jsp`: Form nhập email nhận OTP.
- `verify-otp.jsp`: Nhập OTP và mật khẩu mới.
- `change-password.jsp`: Nhập mật khẩu mới cho lần đăng nhập đầu tiên.
- `profile.jsp`: Trang hiển thị thông tin hồ sơ và form cập nhật động theo Role.
