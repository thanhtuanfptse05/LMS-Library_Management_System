# CONTEXT.md — Library Management System (LMS) Project Memory
# Version: 1.2.0 | Updated: 29/5/2026 | Sprint: Milestone 2
# Vai trò: "TẠI SAO" — Kiến trúc, ADR, Patterns, Lessons Learned, DB Schema.
# Xem "CÁI GÌ / AI / KHI NÀO" (Components, Data Flow, Timeline) tại: plan.md

## TL;DR (Đọc trước — 60 giây)
> Đây là Hệ thống Quản lý Thư viện (LMS) phục vụ trường đại học.
> Stack cốt lõi: Java Web (Servlet/JSP) nguyên khối (Monolith). Không dùng Spring/Spring Boot.
> Database: SQL Server với Raw JDBC + DAO Pattern (Không dùng Hibernate/JPA).
> Auth: Session-based (HttpSession) + @WebFilter chặn URL.
> Điểm nhấn: Quản lý hàng chờ (Reservation), Phân quyền động (RBAC), Thanh toán VNPAY.

## KIẾN TRÚC HỆ THỐNG
Dự án áp dụng kiến trúc Monolith, chia ranh giới theo Module logic (Auth, Inventory, Transaction, Finance).

> **Chi tiết Module, Components & Data Flow:** Xem [plan.md](/plan.md) Section 2 & 3.

### Flow xử lý giao dịch lõi (Ví dụ: Mượn sách):
Client (JSP) → `AuthorizationFilter` (Check Role Session) → `BorrowServlet` (Nhận HTTP Request)
→ `BorrowService` (Business Rules, Check nợ phạt) → `BorrowDAO` (Mở Transaction: Insert Record + Update Copy) 
→ `AuditUtil` (Ghi log bất biến) → Trả về JSP.

## QUYẾT ĐỊNH KIẾN TRÚC QUAN TRỌNG (ADR)
### ADR-001: Bắt buộc dùng Raw JDBC và DAO Pattern (Cấm ORM)
- Lý do: Ràng buộc của môn học SWP391. AI tuyệt đối KHÔNG ĐƯỢC tự import Hibernate/JPA.
- Nguyên tắc: Mọi logic truy vấn phải viết bằng `PreparedStatement`. Quản lý Transaction (`commit`/`rollback`) thủ công.

### ADR-002: Mô hình Table-per-Type (TPT) cho User
- Lý do: Tách `User` (Bảng cha) và các bảng con (`Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin`).
- Nguyên tắc: AI phải dùng lệnh `JOIN` khi query thông tin chi tiết của người dùng.

### ADR-003: Soft-Delete và Audit Log cho giao dịch lõi
- Lý do: Tuân thủ quy tắc nghiệp vụ không xóa lịch sử giao dịch.
- Nguyên tắc: KHÔNG dùng lệnh `DELETE` trên bảng `BorrowRecord`, `Fine`, `Payment`. Cập nhật `status` và luôn `INSERT` vào `AuditLogs`.

## PATTERNS ĐƯỢC SỬ DỤNG
- **Controller - Service - DAO Pattern:** 
  - `Servlet`: Chỉ điều hướng (forward/redirect) và nhận tham số.
  - `Service`: Chứa Business Rules (Cấm chứa câu lệnh SQL).
  - `DAO`: Chỉ chứa logic truy xuất Database (Cấm chứa logic nghiệp vụ).
- **Asynchronous Email:** Mọi thao tác gửi email (OTP, Nhắc hạn) phải chạy qua `ExecutorService` (Async) để không làm block UI.

## DB SCHEMA OVERVIEW (20 bảng — theo SQL file hiện tại)
Tham chiếu chi tiết: `database/LMS_Library_Management_System.sql`

| Nhóm | Bảng | Ghi chú |
|------|------|---------|
| **User (TPT)** | `User`, `MemberProfile`, `Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin` | User là bảng cha, các bảng con FK → userId |
| **Catalog** | `Books`, `BookCopy`, `Category`, `Tag`, `BookCategory` (junction), `BookTag` (junction) | BookCopy quản lý từng bản vật lý |
| **Transaction** | `BorrowRecord`, `Reservation`, `Fine`, `Payment` | KHÔNG Hard-delete — chỉ Soft-delete qua status |
| **System** | `SystemConfigurations`, `AuditLogs`, `Notification` | Config lưu API keys, AuditLogs bất biến |

> ⚠️ **Lưu ý:** Con số bảng cần verify nếu team bổ sung thêm bảng. Cập nhật lại section này khi schema thay đổi.

## LESSONS LEARNED (Những lỗi đã xảy ra và cần tránh)
- **[Lỗi Bảo mật] SQL Injection:** Đã từng bị lỗi khi dùng phép cộng chuỗi (`+`) trong SQL. Bắt buộc dùng `PreparedStatement` thay thế.
- **[Lỗi Hệ thống] Connection Leak:** Đã từng sập DB do quên đóng kết nối. Mọi DAO BẮT BUỘC dùng `try-with-resources` hoặc đóng `ResultSet`, `Connection` trong block `finally`.
- **[Lỗi UX] Gửi Email đồng bộ:** Ứng dụng bị đơ 5s khi gửi OTP. Đã migrate sang Thread/ExecutorService riêng.

## FILE STRUCTURE QUAN TRỌNG
```
/src/java                  ← Source code Java (NetBeans structure)
  /controller              # Servlet classes (Entry points)
  /service                 # Business logic
  /dao                     # Data access (PreparedStatement)
  /model                   # Java Beans map 1-1 với DB
  /filter                  # @WebFilter bảo vệ endpoints
  /util                    # AuditUtil, EmailSender, BCrypt
/web                       ← Web resources (NetBeans structure)
  /WEB-INF
    /views                 # JSP files (phân chia theo /admin, /librarian, /student)
    web.xml
  /assets                  # CSS/JS tĩnh (nếu có)
/database                  ← SQL schema files
```

## MEMORY LOG (Cho các Agents ghi chú chéo nhau)
# [Các Agent có thể append log/note vào đây khi hoàn thành task lớn để báo cho agent khác]
- [2026-05-26]: DB Schema đã chốt (xem `database/LMS_Library_Management_System.sql`). Không tự ý tạo thêm bảng mà không có RFC.
- [2026-05-28]: Tái cấu trúc AGENTS.md + CONTEXT.md theo Playbook 4.1/4.2. File paths sửa khớp cấu trúc NetBeans.
- [2026-05-29]: Cập nhật và đồng bộ 31 BR nghiệp vụ (thêm BR30 và BR31), đồng bộ nhất quán các tên Servlet và sửa đổi các ràng buộc hệ thống.