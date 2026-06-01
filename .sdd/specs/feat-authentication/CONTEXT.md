# CONTEXT.md — Authentication Feature
# Cập nhật theo ActivityDiagramF1.txt

## 1. PROBLEM STATEMENT
Hệ thống LMS cần bảo vệ các tài nguyên khỏi truy cập trái phép. Luồng xác thực cần xử lý đăng nhập, đăng xuất và khôi phục mật khẩu. Yêu cầu chống tấn công Brute-force thông qua cơ chế khóa tài khoản tạm thời theo quy định `ActivityDiagramF1.txt` và `FR02`.

## 2. STAKEHOLDERS
- Guest: Khách vãng lai chưa xác thực.
- User (Student, Lecturer, Librarian, LibraryManager, Admin): Người dùng hợp lệ cần phân quyền.

## 3. CONSTRAINTS (Ràng buộc hệ thống)
- [C-01] Architecture: Java Web thuần (Servlet, JSP, JDBC, Filter). KHÔNG dùng Framework (Spring/Hibernate).
- [C-02] Session: Sử dụng `HttpSession` mặc định. KHÔNG sử dụng JWT.
- [C-03] Security: BẮT BUỘC sử dụng thuật toán BCrypt (`jbcrypt-0.4.jar`) để mã hóa mật khẩu.
- [C-04] Database: Ghi nhận trực tiếp vào bảng `[User]`.

## 4. ASSUMPTIONS
- Quên mật khẩu sẽ sinh mật khẩu ngẫu nhiên 8 ký tự và gửi qua Email, không áp dụng quy trình xác thực OTP trung gian.