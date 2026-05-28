### .sdd/constraints/business.md
### Owner: @tech-lead | Project: Library Management System (LMS)

#### AUTHENTICATION & AUTHORIZATION
- **Passwords:** BẮT BUỘC dùng BCrypt (`BCryptUtil.hash`). KHÔNG dùng MD5, SHA, hay plaintext (FR01).
- **Session:** Dùng Session-based Auth (`HttpSession`). KHÔNG dùng JWT vì hệ thống dùng JSP (ADR-002).
- **Access Control:** Mọi route `/admin/*`, `/librarian/*`, `/student/*` phải được bảo vệ bởi `@WebFilter`.
- **Lock Account:** Sai OTP/Password 5 lần liên tiếp -> Auto cập nhật `User.status = 'locked'` (BR-LMS-016).

#### DATA MANAGEMENT & SOFT DELETE (Cực kỳ quan trọng)
- **Soft Delete Only:** Các bảng cốt lõi (`User`, `Books`, `BorrowRecord`, `Fine`, `Payment`, `Reservation`) KHÔNG BAO GIỜ bị Hard Delete (Dùng lệnh DELETE SQL). 
- **Cách xóa:** Chỉ dùng `UPDATE status = 'locked/lost/void/cancelled'` (BR-LMS-006, ADR-004).
- **Audit Logs:** Mọi lệnh INSERT/UPDATE/DELETE (soft) trên dữ liệu quan trọng đều phải INSERT 1 dòng tương ứng vào bảng `AuditLogs` (BR-LMS-015).

#### CORE DOMAIN GLOSSARY & BEHAVIORS
- **Reservation (Hàng chờ):** Tất cả yêu cầu mượn sách ĐỀU phải vào bảng `Reservation` trước (Dù có sách hay hết sách). Từ đây mới phân nhánh `pending` hoặc `readypickup`.
- **BorrowRecord (Mượn sách):** Chỉ được tạo ra khi thủ thư xác nhận giao sách vật lý (từ trạng thái `readypickup` của Reservation chuyển thành `fulfilled`).
- **Fine (Phạt):** Chặn không cho tạo `Reservation` nếu bảng `Fine` của user đó đang có trạng thái `unpaid` (BR-LMS-035).

#### PII (Personal Identifiable Information)
- Không được log `password` hoặc `email` đầy đủ ra console hoặc bảng AuditLogs.
