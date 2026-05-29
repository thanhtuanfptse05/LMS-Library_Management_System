# Task Breakdown: feat-fine-payment-config

- [ ] **Fine Engine & Daily Batch Job**
  - [ ] Khai báo model `Fine`, `Payment`, `SystemConfiguration`, và `Notification`.
  - [ ] Viết `DailyJobScheduler.java` sử dụng `ScheduledExecutorService` để chạy ngầm tiến trình hằng ngày.
  - [ ] Code logic tính phạt quá hạn tại `FineService.java` theo đúng công thức giới hạn (`min(fine, price * 1.5)`).

- [ ] **VNPAY Sandbox Integration**
  - [ ] Đọc các thông số VNPAY (vnp_TmnCode, vnp_HashSecret, vnp_PayUrl) từ file `.env` hoặc DB.
  - [ ] Viết `PaymentServlet.java` (POST /payment) tạo URL thanh toán chuyển hướng sang VNPAY Sandbox.
  - [ ] Viết `PaymentCallbackServlet.java` (GET /payment-callback) để hứng kết quả trả về, thực hiện kiểm tra chữ ký Secure Hash, cập nhật trạng thái hóa đơn phạt và mở khóa tài khoản người dùng tương ứng.
  - [ ] Triển khai kiểm tra logic mở khóa an toàn `BR31` trong callback xử lý thanh toán.

- [ ] **System Configuration & Notifications**
  - [ ] Viết `SystemConfigurationsDAO.java` để đọc/ghi các thông số cấu hình chính sách.
  - [ ] Xây dựng `SystemConfigServlet.java` (POST /system-config) và trang JSP `manage-configs.jsp` cho quản lý sửa thông số chính sách thư viện.
  - [ ] Xây dựng tính năng đăng thông báo hệ thống và hiển thị banner trên trang chủ của người dùng.

- [ ] **Admin Audit Trail & Account Management**
  - [ ] Viết API/Servlet `AuditLogServlet.java` (GET /audit-log) truy vấn và lọc dữ liệu `AuditLogs`.
  - [ ] Thiết kế giao diện lọc nhật ký nâng cao `view-audit-logs.jsp` cho Admin.
  - [ ] Triển khai tính năng khóa/mở khóa tài khoản người dùng tại `UserLockServlet.java` (POST /user-lock) và giao diện `manage-users.jsp` (Cập nhật User status và lock_reason, tuyệt đối không được xóa).
