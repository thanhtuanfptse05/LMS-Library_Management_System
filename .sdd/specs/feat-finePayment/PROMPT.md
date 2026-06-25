# Hướng dẫn tạo Prompt triển khai Tiến trình ngầm Quét quá hạn (F9)

Copy đoạn prompt dưới đây và dán vào phiên làm việc mới của AI Agent. Đoạn prompt này tự động hướng dẫn AI Agent đọc và hiểu toàn bộ kiến trúc, rà soát mã nguồn hiện tại, và lập kế hoạch triển khai chi tiết trước khi code.

---

```markdown
Chào bạn, tôi muốn bạn chuẩn bị triển khai tính năng tiến trình ngầm **Quét quá hạn tự động (Overdue Processor)** thuộc phân hệ **F9 (Fine & Payment Management)** trong hệ thống Quản lý Thư viện LMS (Java Monolith Servlet/JSP + JDBC thuần + PostgreSQL).

Hãy thực hiện nhiệm vụ theo quy trình thiết kế và lên kế hoạch (Phase 1: Planning Phase) như sau:

### BƯỚC 1: ĐỌC ĐẶC TẢ & THIẾT KẾ KIẾN TRÚC
1. Đọc tệp đặc tả nghiệp vụ phân hệ F9 tại:
   - [.sdd/specs/feat-finePayment/CONTEXT.md](file:///.sdd/specs/feat-finePayment/CONTEXT.md)
   - [.sdd/specs/feat-finePayment/SPEC.md](file:///.sdd/specs/feat-finePayment/SPEC.md)
   - [.sdd/specs/feat-finePayment/PLAN.md](file:///.sdd/specs/feat-finePayment/PLAN.md)
   - [.sdd/specs/feat-finePayment/TASK.md](file:///.sdd/specs/feat-finePayment/TASK.md)
2. Đọc tệp schema PostgreSQL để hiểu cấu trúc các bảng liên quan:
   - [database/supabase/LMS_Schema_PostgreSQL.sql](file:///database/supabase/LMS_Schema_PostgreSQL.sql) (Chú ý cấu trúc các bảng: `BorrowRecord`, `Fine`, `Payment`, `UserLockReason`, `"User"`, `AuditLogs`, `SystemConfigurations`).
3. Đọc quy tắc chung của dự án tại tệp `AGENTS.md` ở thư mục config hoặc workspace `.agents/AGENTS.md` (nếu có).

### BƯỚC 2: RÀ SOÁT CƠ SỞ MÃ NGUỒN HIỆN TẠI (Impact Analysis)
Hãy phân tích mã nguồn hiện tại để xem các phần nào đã được xây dựng, đặc biệt là:
- Kiểm tra các hàm trong `dao.BorrowRecordDAO` và các lớp DAO liên quan.
- Kiểm tra `service.EmailService` để xem cách gửi email bất đồng bộ qua hàng đợi (EmailService.enqueue và EmailJob).
- Kiểm tra `config.AppContextListener` để xem cách khởi tạo/đóng tài nguyên khi web app chạy.
- Kiểm tra các servlet như `controllers.CashPaymentServlet` hay `controllers.SePayWebhookServlet` để đối chiếu luồng nghiệp vụ.
- Đánh giá xem có thay đổi nào mới từ team đã được push lên ảnh hưởng đến logic của Overdue Processor không.

### BƯỚC 3: LẬP KẾ HOẠCH TRIỂN KHAI (DO NOT CODE YET)
1. Tạo tệp `implementation_plan.md` trong thư mục brain (artifacts directory) của phiên làm việc này. Bản kế hoạch phải có:
   - Tóm tắt luồng nghiệp vụ Quét quá hạn (Overdue Processor).
   - Danh sách cụ thể các file cần tạo mới/sửa đổi.
   - Chi tiết cấu trúc code dự kiến cho `service.OverdueProcessor`, các hàm trong DAO, cấu hình scheduler trong Listener, và nút bấm trên admin dashboard JSP.
   - Kế hoạch kiểm thử tự động (JUnit) và kiểm thử thủ công (các bước tái hiện quá hạn).
2. Tạo tệp `task.md` (artifacts directory) dạng TODO list để theo dõi tiến độ.
3. **QUAN TRỌNG:** Dừng lại hoàn toàn và chờ phản hồi từ người dùng. Tuyệt đối KHÔNG được chỉnh sửa mã nguồn hệ thống chừng nào tôi chưa phê duyệt kế hoạch và ra lệnh "Code đi" hoặc "Thực hiện code".
```
