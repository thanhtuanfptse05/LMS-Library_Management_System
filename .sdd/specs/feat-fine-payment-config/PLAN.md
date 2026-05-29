# Implementation Plan: feat-fine-payment-config (Xử lý Phạt, VNPAY, Cấu hình & Nhật ký hệ thống)

## 1. Database & Models
- `Fine.java` (fineId, borrowRecordId, userId, amount, reason, status, createdAt)
- `Payment.java` (paymentId, fineId, paidAmount, paymentMethod, transactionReference, processBy, status, paidAt)
- `SystemConfiguration.java` (configKey, configValue, description, updatedBy, updatedAt)
- `Notification.java` (notificationId, title, content, createdBy, createdAt)

## 2. Service & DAO Layers
- **`FineDAO.java`**:
  - `createFine(Fine fine)`
  - `getFinesByUserId(int userId)`
  - `updateFineStatus(int fineId, String status, Connection conn)`
  - `updateFineAmount(int fineId, BigDecimal amount, Connection conn)`: Cập nhật số tiền phạt lũy kế.
  - `getUnpaidFineByBorrowRecordId(int borrowRecordId)`: Tìm bản ghi phạt unpaid cũ để cập nhật cộng dồn.
- **`PaymentDAO.java`**:
  - `insertPayment(Payment payment, Connection conn)`
  - `getPaymentByTxnRef(String txnRef)`
- **`SystemConfigurationsDAO.java`**:
  - `getConfigValue(String key)`
  - `updateConfigValue(String key, String value, int managerId, Connection conn)`
- **`FineService.java`**:
  - `calculateFinesJob()`: Hàm thực thi tính toán tiền phạt quá hạn hàng ngày.
- **`PaymentService.java`**:
  - `processVNPAYPayment(int fineId)`: Sinh URL thanh toán VNPAY Sandbox.
  - `confirmVNPAYCallback(Map<String, String> fields)`: Đối soát chữ ký checksum, hoàn tất cập nhật trạng thái hóa đơn phạt. **Bảo đảm thực hiện quy tắc BR31: Chỉ tự động mở khóa (status = 'active') nếu lý do khóa hiện tại của User là 'unpaid' và không còn bất kỳ lý do khóa nghiêm trọng nào khác (failed login attempts, admin ban).**
- **`NotificationDAO.java`**:
  - `insertNotification(Notification notification, Connection conn)`: Lưu thông báo mới vào DB.
  - `getLatestNotifications(int limit)`: Lấy các thông báo mới nhất.
- **`NotificationService.java`**:
  - `publishNotification(Notification notification)`: Đăng tải thông báo chung hệ thống và gọi AuditLogDAO ghi log.
- **`AuditLogService.java`**:
  - `getAuditLogs(String entityName, String actionType, Integer userId, Date fromDate, Date toDate, int page, int pageSize)`: Lọc và truy vấn danh sách log kiểm toán cho Admin (gọi `AuditLogDAO`).

## 3. Servlets & Listeners
- **`DailyJobScheduler.java`** (triển khai `ServletContextListener`):
  - Khởi tạo một `ScheduledExecutorService` chạy ngầm.
  - Thiết lập lịch chạy tính phạt quá hạn lúc 0h00 hằng ngày và gửi email nhắc nợ.
  - Chạy `PaymentTimeoutJob` định kỳ mỗi 15 phút: Quét các đơn hàng `Payment` có status là `'pending'` và ngày khởi tạo (lưu tại trường `paid_at` mặc định) đã quá 15 phút để tự động hủy đơn.
- **Servlets (controller.finance & controller.admin)**:
  - `PaymentServlet.java` (POST `/student/payment`)
  - `PaymentCallbackServlet.java` (GET `/student/payment-callback`)
  - `SystemConfigServlet.java` (POST `/manager/system-config`)
  - `AuditLogServlet.java` (GET `/admin/audit-log`): Gọi `AuditLogService` để lấy danh sách nhật ký kiểm toán (tuân thủ `ARCH-01`).
  - `UserLockServlet.java` (POST `/admin/user-lock`)

## 4. Views (JSPs)
- `/web/WEB-INF/views/student/fine-list.jsp`: Danh sách tiền phạt cá nhân và liên kết thanh toán.
- `/web/WEB-INF/views/manager/manage-configs.jsp`: Bảng quản lý cấu hình các thông số nghiệp vụ thư viện.
- `/web/WEB-INF/views/admin/view-audit-logs.jsp`: Bộ lọc và hiển thị nhật ký hệ thống nâng cao.
- `/web/WEB-INF/views/admin/manage-users.jsp`: Danh sách người dùng kèm nút khóa/mở khóa tài khoản.
