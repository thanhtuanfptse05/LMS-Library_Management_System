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
  - `confirmVNPAYCallback(Map<String, String> fields)`: Đối soát chữ ký checksum, hoàn tất cập nhật trạng thái hóa đơn phạt và mở khóa tài khoản.

## 3. Servlets & Listeners
- **`DailyJobScheduler.java`** (triển khai `ServletContextListener`):
  - Khởi tạo một `ScheduledExecutorService` chạy ngầm.
  - Thiết lập lịch chạy tính phạt quá hạn lúc 0h00 hằng ngày và gửi email nhắc nợ.
- **Servlets (controller.finance & controller.admin)**:
  - `PaymentServlet.java` (POST /student/pay-fine)
  - `PaymentCallbackServlet.java` (GET /payment/vnpay-callback)
  - `ConfigureSystemServlet.java` (GET/POST /manager/configurations)
  - `AuditLogServlet.java` (GET /admin/audit-logs)
  - `ManageUserServlet.java` (POST /admin/lock-user)

## 4. Views (JSPs)
- `/web/WEB-INF/views/student/fine-list.jsp`: Danh sách tiền phạt cá nhân và liên kết thanh toán.
- `/web/WEB-INF/views/manager/manage-configs.jsp`: Bảng quản lý cấu hình các thông số nghiệp vụ thư viện.
- `/web/WEB-INF/views/admin/view-audit-logs.jsp`: Bộ lọc và hiển thị nhật ký hệ thống nâng cao.
- `/web/WEB-INF/views/admin/manage-users.jsp`: Danh sách người dùng kèm nút khóa/mở khóa tài khoản.
