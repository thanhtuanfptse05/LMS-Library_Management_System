### .sdd/constraints/business.md
### Owner: @tech-lead | Project: Library Management System (LMS)

#### AUTHENTICATION & AUTHORIZATION
- **Passwords:** BẮT BUỘC dùng BCrypt (`BCryptUtil.hash`). KHÔNG dùng MD5, SHA, hay plaintext (FR01).
- **First Login (BR-LMS-030):** Khi đăng nhập lần đầu thành công với mật khẩu mặc định trùng tên đăng nhập, hệ thống BẮT BUỘC điều hướng sang trang đổi mật khẩu và chặn mọi hành động khác cho đến khi đặt xong mật khẩu mới.
- **Session:** Dùng Session-based Auth (`HttpSession`). KHÔNG dùng JWT vì hệ thống dùng JSP (ADR-004).
- **Access Control:** Mọi route `/admin/*`, `/librarian/*`, `/student/*` phải được bảo vệ bởi `@WebFilter`.
- **Lock Account:** Sai OTP/Password 5 lần liên tiếp -> Auto cập nhật `User.status = 'locked'`, `lock_reason = 'securitybreach'` (BR-LMS-001).

#### DATA MANAGEMENT & SOFT DELETE (Cực kỳ quan trọng)
- **Soft Delete Only:** Các bảng cốt lõi (`User`, `Books`, `BorrowRecord`, `Fine`, `Payment`, `Reservation`) KHÔNG BAO GIỜ bị Hard Delete (Dùng lệnh DELETE SQL). 
- **Cách xóa:** Chỉ dùng `UPDATE status = 'locked/lost/void/cancelled'` (BR-LMS-002, ADR-003).
- **Audit Logs:** Mọi lệnh INSERT/UPDATE/DELETE (soft) trên dữ liệu quan trọng đều phải INSERT 1 dòng tương ứng vào bảng `AuditLogs` (BR-LMS-019).
- **PII Masking:** Khi ghi nhật ký thay đổi thông tin (ví dụ: MemberProfile), hệ thống bắt buộc phải áp dụng thuật toán ẩn danh/masking đối với Email và Số điện thoại trong chuỗi JSON lưu tại cột `old_values` và `new_values` trước khi ghi vào `AuditLogs`.

#### CORE DOMAIN GLOSSARY & BEHAVIORS
- **Reservation (Hàng chờ):** Tất cả yêu cầu mượn sách ĐỀU phải vào bảng `Reservation` trước (Dù có sách hay hết sách). Từ đây mới phân nhánh `pending` hoặc `readypickup`.
- **User Status & Borrow Limit Validation:** 
    - Để tối ưu hiệu năng, mọi thao tác tạo mới Reservation CHỈ CẦN kiểm tra `User.status != 'locked'` (TUYỆT ĐỐI KHÔNG join bảng `Fine` để kiểm tra nợ phạt ở luồng này vì nợ phạt đã được đồng bộ qua trạng thái khóa).
    - Tuy nhiên, hệ thống **bắt buộc** phải kiểm tra điều kiện `BR-LMS-005`: Tổng "Số sách đang mượn" + "Số sách đang đặt trước" < `max_borrow_limit` trước khi tạo Reservation để tránh spam hàng chờ.
- **Fine Sync Logic (Cơ chế đồng bộ trạng thái - BR-LMS-004, BR-LMS-021 & BR-LMS-031):** 
    - **Khi nợ phạt (Lock):** Ngay khi một bản ghi trong bảng `Fine` được tạo mới với trạng thái `unpaid`, hệ thống PHẢI tự động `UPDATE User SET status = 'locked'`. Đồng thời, hệ thống chỉ ghi nhận `lock_reason = 'unpaid'` nếu như `lock_reason` hiện tại đang là `NULL` (TUYỆT ĐỐI KHÔNG được ghi đè lên các lý do khóa nghiêm trọng hơn như `'adminban'` hoặc `'securitybreach'`).
    - **Khi thanh toán xong (Unlock Validation):** Khi tất cả `Fine` của user chuyển thành `paid`, hệ thống **KHÔNG ĐƯỢC** mù quáng mở khóa. Service layer PHẢI kiểm tra điều kiện sau trước khi set `status = 'active'` và `lock_reason = NULL`:
        1. Lý do khóa hiện tại của User bắt buộc phải là `'unpaid'` (hoặc `NULL`). Nếu lý do khóa là `'adminban'` hoặc `'securitybreach'`, hệ thống **giữ nguyên** trạng thái khóa của tài khoản.
        2. User có đang bị khóa do nhập sai mật khẩu 5 lần không? (`failed_login_attempts >= 5` hoặc `locked_until > GETDATE()`) (BR-LMS-001).
        3. User có đang bị khóa thủ công (banned) bởi Admin không? 
        -> Chỉ khi thỏa mãn không còn lý do khóa nào khác và đã sạch nợ phạt, hệ thống mới được phép mở khóa tài khoản hoạt động bình thường.
- **No-Show Tracking (BR-LMS-012):** Để phân biệt giữa việc độc giả tự hủy lượt đặt trước (hợp lệ) và quá hạn không đến lấy sách (no-show vi phạm) mà không làm thay đổi cấu trúc bảng `Reservation` (20 bảng cố định):
    1. **Độc giả tự hủy (Voluntary Cancel):** Khi độc giả hủy chủ động qua `CancelReservationServlet`, hệ thống sẽ cập nhật `status = 'cancelled'` đồng thời **set `end_date = NULL`** (hoặc thời gian hiện tại) như một tín hiệu hợp lệ.
    2. **Hệ thống hủy do quá hạn (System Cleanup/No-Show):** Khi tiến trình `ReservationCleanupJob` hủy lượt đặt trước đã quá hạn nhận sách (3 ngày), hệ thống cập nhật `status = 'cancelled'` nhưng **giữ nguyên giá trị `end_date`** (ngày hết hạn nhận sách ban đầu, vốn nằm trong quá khứ).
    3. **Cách truy vấn số lần No-Show:** Để đếm số lần vi phạm của độc giả, hệ thống truy vấn: `SELECT COUNT(*) FROM Reservation WHERE userId = ? AND status = 'cancelled' AND end_date < GETDATE()`.
- **VNPAY payment timeout:** Do bảng `Payment` không có cột ngày tạo riêng, trường `paid_at` sẽ lưu thời gian khởi tạo đơn hàng khi trạng thái là `'pending'`. Tiến trình dọn dẹp (`PaymentTimeoutJob`) sẽ đối soát cột `paid_at` của các giao dịch `'pending'` để hủy sau 15 phút.

#### PII (Personal Identifiable Information)
- Không được log `password` hoặc `email` đầy đủ ra console hoặc bảng AuditLogs (phải mask như quy định).
