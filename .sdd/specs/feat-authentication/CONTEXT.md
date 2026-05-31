# CONTEXT.md — Authentication Feature

## 1. PROBLEM STATEMENT
Hệ thống LMS cần bảo vệ các route (trang JSP) khỏi truy cập trái phép. Cần xác thực người dùng qua Email/Password và quản lý phiên đăng nhập, đồng thời bảo vệ hệ thống khỏi các cuộc tấn công Brute-force.

## 2. STAKEHOLDERS
- Guest: Người dùng chưa đăng nhập.
- User (Student, Lecturer, Librarian, Admin, LibraryManager): Người dùng hợp lệ.

## 3. CONSTRAINTS (Ràng buộc kỹ thuật cứng)
- Architecture: Java Web thuần (Servlet, JSP, JSTL, JDBC). KHÔNG dùng Spring/Hibernate.
- Routing: Áp dụng Filter để bảo vệ các thư mục `/WEB-INF/views/admin/`, `/member/`, v.v.
- Session: Sử dụng `HttpSession` mặc định của Java EE.

## 4. ASSUMPTIONS (Đã chốt)
- Mật khẩu tạo mới/reset sẽ được gửi thẳng qua Email.
- Bỏ qua cơ chế "Ép đổi mật khẩu lần đầu đăng nhập" (đã chốt ở Feature Quản lý tài khoản).