Dưới đây là file ngữ cảnh chuẩn, không phụ thuộc vào bất kỳ AI tool nào. Bạn tạo file này ở thư mục gốc (root) của dự án:
# CONTEXT.md — Library Management System (LMS) Project Memory
# Đọc kèm file AGENTS.md để hiểu quy tắc hành vi của dự án.

## TL;DR (Đọc trước — 60 giây)
> Đây là Hệ thống Quản lý Thư viện (LMS) phục vụ trường đại học.
> Stack cốt lõi: Java Web (Servlet/JSP) nguyên khối (Monolith). Không dùng Spring/Spring Boot.
> Database: SQL Server với Raw JDBC + DAO Pattern (Không dùng Hibernate/JPA).
> Auth: Session-based (HttpSession) + @WebFilter chặn URL.
> Điểm nhấn: Quản lý hàng chờ (Reservation), Phân quyền động (RBAC), Thanh toán VNPAY.

## KIẾN TRÚC HỆ THỐNG
Dự án áp dụng kiến trúc Monolith, chia ranh giới theo Module logic:

### Các Module chính:
| Module | Base URL | Controller Package | Trách nhiệm |
|---------|------|--------|------|
| Auth & User | `/auth/*` | `controller.auth` | Đăng nhập, OTP, RBAC, Profile |
| Inventory & AI | `/librarian/book/*` | `controller.book` | Quản lý kho sách, Tag, Gợi ý AI |
| Transaction | `/student/borrow/*` | `controller.transaction`| Mượn/Trả, Gia hạn, Hàng chờ |
| Finance | `/student/fine/*` | `controller.finance` | Tính tiền phạt, Thanh toán VNPAY |

### Flow xử lý giao dịch lõi (Ví dụ: Mượn sách):
Client (JSP) → `AuthorizationFilter` (Check Role Session) → `BorrowServlet` (Nhận HTTP Request)
→ `BorrowService` (Business Rules, Check nợ phạt) → `BorrowDAO` (Mở Transaction: Insert Record + Update Copy) 
→ `AuditUtil` (Ghi log bất biến) → Trả về JSP.

## QUYẾT ĐỊNH KIẾN TRÚC QUAN TRỌNG (ADR)
### ADR-001: Bắt buộc dùng Raw JDBC và DAO Pattern (Cấm ORM)
- Lý do: Ràng buộc của môn học SWP391. AI tuyệt đối KHÔNG ĐƯỢC tự import Hibernate/JPA.
- Nguyên tắc: Mọi logic truy vấn phải viết bằng `PreparedStatement`. Quản lý Transaction (`commit`/`rollback`) thủ công.

### ADR-002: Mô hình Table-per-Type (TPT) cho User
- Lý do: Tách `User` (Bảng cha) và các bảng con (`Student`, `Lecturer`...).
- Nguyên tắc: AI phải dùng lệnh `JOIN` khi query thông tin chi tiết của người dùng.

### ADR-003: Soft-Delete và Audit Log cho giao dịch lõi
- Lý do: Tuân thủ quy tắc nghiệp vụ không xóa lịch sử giao dịch.
- Nguyên tắc: KHÔNG dùng lệnh `DELETE` trên bảng `Borrowing_Record`, `Fine`, `Payment`. Cập nhật `status = Inactive` và luôn `INSERT` vào `Audit_Log`.

## PATTERNS ĐƯỢC SỬ DỤNG
- **Controller - Service - DAO Pattern:** 
  - `Servlet`: Chỉ điều hướng (forward/redirect) và nhận tham số.
  - `Service`: Chứa Business Rules (Cấm chứa câu lệnh SQL).
  - `DAO`: Chỉ chứa logic truy xuất Database (Cấm chứa logic nghiệp vụ).
- **Asynchronous Email:** Mọi thao tác gửi email (OTP, Nhắc hạn) phải chạy qua `ExecutorService` (Async) để không làm block UI.

## LESSONS LEARNED (Những lỗi đã xảy ra và cần tránh)
- **Lỗi SQL Injection:** Đã từng bị lỗi khi dùng phép cộng chuỗi (`+`) trong SQL. Bắt buộc dùng `PreparedStatement` thay thế.
- **Connection Leak:** Đã từng sập DB do quên đóng kết nối. Mọi DAO BẮT BUỘC dùng `try-with-resources` hoặc đóng `ResultSet`, `Connection` trong block `finally`.
- **Lỗi UX do gửi Email đồng bộ:** Ứng dụng bị đơ 5s khi gửi OTP. Đã migrate sang Thread riêng.

## FILE STRUCTURE QUAN TRỌNG
/src/main/java
  /controller    # Servlet classes (Entry points)
  /service       # Business logic
  /dao           # Data access (PreparedStatement)
  /model         # Java Beans map 1-1 với 22 bảng ERD
  /filter        # @WebFilter bảo vệ endpoints
  /util          # AuditUtil, EmailSender, BCrypt
/src/main/webapp
  /views         # JSP files (phân chia theo /admin, /librarian, /student)
  /assets        # CSS/JS tĩnh

## MEMORY LOG (Cho các Agents ghi chú chéo nhau)
# [Các Agent có thể append log/note vào đây khi hoàn thành task lớn để báo cho agent khác]
- [2026-05-26]: DB Schema đã chốt 22 bảng. Không tự ý tạo thêm bảng mà không có RFC.