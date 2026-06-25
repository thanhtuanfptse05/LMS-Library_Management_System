# Hướng dẫn tạo Prompt triển khai Hủy hàng chờ quá hạn (F5)

Copy đoạn prompt dưới đây và dán vào phiên làm việc mới của AI Agent để tiến hành thiết lập kế hoạch và triển khai tính năng **Reservation Expiration (Hủy hàng chờ tự động)**.

---

```markdown
Chào bạn, tôi muốn bạn chuẩn bị triển khai tính năng tiến trình ngầm **Hủy hàng chờ quá hạn (Reservation Expiration)** thuộc phân hệ **F5 (Online Reservation & Renewal)** trong hệ thống Quản lý Thư viện LMS (Java Monolith Servlet/JSP + JDBC thuần + PostgreSQL).

Hãy thực hiện nhiệm vụ theo quy trình thiết kế và lên kế hoạch (Phase 1: Planning Phase) như sau:

### BƯỚC 1: ĐỌC ĐẶC TẢ & THIẾT KẾ KIẾN TRÚC
1. Đọc tệp đặc tả nghiệp vụ phân hệ F5 tại:
   - [.sdd/specs/feat-Reservation&Renewal/CONTEXT.md](file:///.sdd/specs/feat-Reservation&Renewal/CONTEXT.md)
   - [.sdd/specs/feat-Reservation&Renewal/SPEC.md](file:///.sdd/specs/feat-Reservation&Renewal/SPEC.md)
   - [.sdd/specs/feat-Reservation&Renewal/PLAN.md](file:///.sdd/specs/feat-Reservation&Renewal/PLAN.md)
   - [.sdd/specs/feat-Reservation&Renewal/TASK.md](file:///.sdd/specs/feat-Reservation&Renewal/TASK.md)
2. Đọc tệp schema PostgreSQL để hiểu cấu trúc các bảng liên quan:
   - [database/supabase/LMS_Schema_PostgreSQL.sql](file:///database/supabase/LMS_Schema_PostgreSQL.sql) (Đặc biệt chú ý cấu trúc các bảng: `Reservation`, `BookCopy`, `Book`, `"User"`, `AuditLogs`).
3. Đọc quy tắc chung của dự án tại tệp `AGENTS.md` ở thư mục config hoặc workspace `.agents/AGENTS.md` (nếu có).

### BƯỚC 2: RÀ SOÁT CƠ SỞ MÃ NGUỒN HIỆN TẠI (Impact Analysis)
Hãy phân tích mã nguồn hiện tại để xem các phần nào đã được xây dựng, đặc biệt là:
- Rà soát các hàm trong `dao.ReservationDAO` (hàm `cancelExpiredReservations` hiện có cần được nâng cấp để hỗ trợ đôn hàng chờ cho người tiếp theo thay vì trả thẳng về kho).
- Rà soát `config.AppContextListener` để xem cách đăng ký scheduler và quản lý vòng đời thread pool.
- Rà soát `service.OnlineCirculationService` và các servlet để đối chiếu luồng nghiệp vụ.
- Đánh giá xem có thay đổi nào mới từ team đã được push lên ảnh hưởng đến logic của Reservation Expiration không.

### BƯỚC 3: LẬP KẾ HOẠCH TRIỂN KHAI (DO NOT CODE YET)
1. Tạo tệp `implementation_plan.md` trong thư mục brain (artifacts directory) của phiên làm việc này. Bản kế hoạch phải có:
   - Tóm tắt luồng nghiệp vụ Hủy đặt trước quá hạn (Reservation Expiration) và đôn hàng chờ.
   - Danh sách cụ thể các file cần tạo mới/sửa đổi.
   - Chi tiết cấu trúc code dự kiến cho `service.ReservationExpirationProcessor`, việc sửa đổi DAO, đăng ký lập lịch scheduler, và nút bấm trên admin dashboard JSP.
   - Kế hoạch kiểm thử tự động (JUnit) và kiểm thử thủ công (các bước tái hiện).
2. Tạo tệp `task.md` (artifacts directory) dạng TODO list để theo dõi tiến độ.
3. **QUAN TRỌNG VỀ THIẾT KẾ:** Thời gian giữ sách đặt trước chờ lấy (mặc định ban đầu là 3 ngày) không được phép viết cứng mà BẮT BUỘC phải lấy động từ bảng `SystemConfigurations` qua khóa `RESERVATION_HOLD_DAYS`. Hãy chắc chắn cấu trúc code và SQL trong bản thiết kế của bạn tuân thủ đúng yêu cầu này.
4. **QUAN TRỌNG:** Dừng lại hoàn toàn và chờ phản hồi từ người dùng. Tuyệt đối KHÔNG được chỉnh sửa mã nguồn hệ thống chừng nào tôi chưa phê duyệt kế hoạch và ra lệnh "Code đi" hoặc "Thực hiện code".
```
