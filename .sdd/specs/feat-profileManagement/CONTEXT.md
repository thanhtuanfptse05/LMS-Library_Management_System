# CONTEXT.md — Quản lý hồ sơ người dùng (feat-profileManagement)
# Trạng thái: LOCKED | Ngày: 2026-06-01

## 1. PROBLEM STATEMENT
Người dùng đã xác thực cần giao diện quản lý thông tin cá nhân và thay đổi mật khẩu nhằm bảo vệ tài khoản, duy trì tính chính xác của dữ liệu trong hệ thống LMS (tham chiếu FR04, FR05).

## 2. DOMAIN KNOWLEDGE
* Dữ liệu hồ sơ người dùng được phân tách thành 2 thực thể: bảng `[User]` quản lý thông tin đăng nhập (credential) và trạng thái; bảng `MemberProfile` quản lý thông tin định danh mở rộng.

## 3. STAKEHOLDERS
* **Authenticated User (Tất cả Roles):** Đối tượng thực thi truy vấn và cập nhật dữ liệu cá nhân.

## 4. CONSTRAINTS (Ràng buộc cứng)
* **Kiến trúc:** Java Web thuần (Servlet, JSP, JSTL, JDBC).
* **Mã hóa:** Mật khẩu BẮT BUỘC mã hóa bằng thư viện `jbcrypt-0.4.jar` trước khi lưu trữ.
* **Chính sách mật khẩu (BR22 rút gọn):** Mật khẩu mới BẮT BUỘC đáp ứng tối thiểu 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt. 

## 5. ASSUMPTIONS & ARCHITECTURAL DECISIONS
* **[DECISION-01]:** Cập nhật mật khẩu trong luồng Profile Management KHÔNG yêu cầu mã xác thực OTP. Người dùng chỉ cần cung cấp chính xác "Mật khẩu hiện tại" để xác thực hành vi (tuân thủ luồng Activity F2 thay vì BR22 nguyên bản).
* **[ASSUMPTION-01]:** `HttpSession` chứa `userId` hợp lệ đã được khởi tạo trước khi truy cập luồng này thông qua hệ thống Authentication.
