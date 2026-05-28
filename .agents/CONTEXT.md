# CONTEXT.md — Library Management System (LMS)
# Version: 1.0.0 | Sprint: Milestone 2 (Core Transaction Flow)

## TL;DR (Đọc trước — 60 giây)
Hệ thống LMS trường đại học. Monolith Java Web.
Auth: Session-based (HttpSession) + @WebFilter.
Database: MS SQL Server. Mô hình Table-per-Type (Bảng `User` là cha của `Student`, `Lecturer`, `Librarian`...).
Đặc trưng: Quản lý hàng chờ đặt sách (Reservation), tính phạt quá hạn, thanh toán VNPAY.

## KIẾN TRÚC & FILE STRUCTURE
Áp dụng Controller - Service - DAO Pattern:
- `controller/`: Chỉ điều hướng (forward/redirect) và nhận tham số. (Tên file: PascalCase + Servlet suffix, vd: `BorrowBookServlet.java`).
- `service/`: Chứa Business Rules. Cấm chứa câu lệnh SQL.
- `dao/`: Chỉ chứa logic truy xuất Database (PreparedStatement). (Tên file: PascalCase + DAO suffix, vd: `BookDAO.java`).
- `model/`: Java Beans map 1-1 với DB.
- `views/`: Chứa file `.jsp` (Tên file: kebab-case, vd: `book-list.jsp`).

## CORE TRANSACTION FLOW (Luồng Mượn Sách)
JSP Client → `AuthorizationFilter` (Check Role) → `BorrowServlet` → `BorrowService` (Check nợ phạt, Check availability) → `BorrowDAO` (Mở Transaction: INSERT `BorrowRecord` + UPDATE `BookCopy`) → `AuditUtil` (Ghi log) → Return JSP.

## QUAN TRỌNG — LESSONS LEARNED (Không lặp lại lỗi này)
- [Lỗi Bảo mật] Lỗi SQL Injection: Đã từng sập hệ thống do dùng phép cộng chuỗi `+` trong SQL. BẮT BUỘC dùng PreparedStatement.
- [Lỗi Hệ thống] Connection Leak: Đã từng sập DB do quên đóng kết nối. Mọi DAO BẮT BUỘC dùng `try-with-resources` hoặc đóng `ResultSet`, `Connection` trong block `finally`.
- [Lỗi UX] App bị đơ 5s khi gửi OTP/Email: Việc gửi mail đồng bộ làm block UI. Phải migrate sang Thread/ExecutorService riêng.

## CURRENT SPRINT FOCUS
Milestone 2 (Core Transaction Flow): Xây dựng tính năng Xác thực bảo mật (Login/OTP/Filter) và Luồng giao dịch lõi (Tìm sách, Mượn sách, Trả sách, Tính phạt).
