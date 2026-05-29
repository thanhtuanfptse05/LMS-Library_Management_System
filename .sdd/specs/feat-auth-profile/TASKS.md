# Task Breakdown: feat-auth-profile

- [ ] **Database & Models Development**
  - [ ] Tạo các class Model: `User`, `MemberProfile`, `Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin`.
  - [ ] Viết các unit tests khởi tạo mô hình và kiểm tra getters/setters.

- [ ] **DAO & Security Utility Development**
  - [ ] Viết `UserDAO.java` sử dụng PreparedStatement và đóng resource an toàn.
  - [ ] Viết `ProfileDAO.java` và các DAO phân vai học sinh, giảng viên.
  - [ ] Tích hợp thư viện BCrypt băm mật khẩu.

- [ ] **Service & Authentication Logic**
  - [ ] Viết `AuthService.java` xử lý nghiệp vụ kiểm tra thông tin đăng nhập và logic khóa tài khoản.
  - [ ] Cấu hình `ExecutorService` trong `EmailService` để gửi OTP bất đồng bộ.

- [ ] **RBAC WebFilter**
  - [ ] Viết `AuthorizationFilter.java` lọc session và check quyền hạn của các thư mục chức năng.
  - [ ] Test chặn truy cập trái phép của Guest và kiểm tra chuyển hướng.

- [ ] **JSP Views & Servlets Integration**
  - [ ] Tạo `login.jsp`, `forgot-password.jsp`, và `profile.jsp`.
  - [ ] Triển khai `LoginServlet`, `LogoutServlet`, và `ProfileServlet`.
  - [ ] Tích hợp logic bắt buộc đổi mật khẩu lần đầu (redirect sang trang đổi mật khẩu và khóa chức năng khác cho đến khi hoàn thành) (BR30).
  - [ ] Kiểm tra validation dữ liệu ở cả giao diện bằng JS và phía Backend.
