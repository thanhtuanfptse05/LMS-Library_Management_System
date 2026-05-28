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
- **User Status Validation (Luồng Mượn/Đặt sách):** Để tối ưu hiệu năng, mọi thao tác tạo mới Reservation CHỈ CẦN kiểm tra `User.status != 'locked'`. TUYỆT ĐỐI KHÔNG join bảng `Fine` để kiểm tra nợ phạt ở luồng này.Chỉ được tạo ra khi thủ thư xác nhận giao sách vật lý (từ trạng thái `readypickup` của Reservation chuyển thành `fulfilled`).
- **Fine Sync Logic (Cơ chế đồng bộ trạng thái - BR-LMS-035):** 
    - **Khi nợ phạt (Lock):** Ngay khi một bản ghi trong bảng `Fine` được tạo mới với trạng thái `unpaid`, hệ thống PHẢI tự động `UPDATE User SET status = 'locked'`. 
    - **Khi thanh toán xong (Unlock Validation):** Khi tất cả `Fine` của user chuyển thành `paid`, hệ thống **KHÔNG ĐƯỢC** mù quáng mở khóa. Service layer PHẢI kiểm tra lock_reason điều kiện sau trước khi set `status = 'active'`:
        1. User có đang bị khóa do nhập sai mật khẩu 5 lần không? (`failed_login_attempts >= 5` hoặc `locked_until > GETDATE()`) (BR-LMS-016, BR-LMS-031).
        2. User có đang bị khóa thủ công (banned) bởi Admin không? 
        -> Chỉ khi thỏa mãn không vi phạm các lỗi bảo mật/admin khác(tức lock_reason = 'null'), hệ thống mới được phép mở khóa tài khoản.
#### PII (Personal Identifiable Information)
- Không được log `password` hoặc `email` đầy đủ ra console hoặc bảng AuditLogs.
