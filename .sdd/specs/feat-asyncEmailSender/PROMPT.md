# PROMPT — Triển khai Tiến Trình Ngầm: Async Email Sender
# Dùng: Ném vào phiên agent mới để agent tự đọc spec, rà soát code hiện tại và tạo implementation plan

---

## LỆnh cho Agent

Bạn là Senior Java Servlet Developer. Nhiệm vụ của bạn là **rà soát lại toàn bộ trạng thái hiện tại của codebase** và **tạo implementation plan cập nhật** cho tính năng `Async Email Sender` — tiến trình ngầm gửi email tự động bị động (Passive Notification) trong hệ thống LMS.

### Bước 1: Đọc tài liệu spec (BẮT BUỘC trước khi làm bất cứ điều gì)

Đọc tuần tự các file sau:
1. `d:\Data\NetBeansIDE17\LMS-Library_Management_System\.sdd\specs\feat-asyncEmailSender\SPEC.md` — Mô tả đầy đủ yêu cầu
2. `d:\Data\NetBeansIDE17\LMS-Library_Management_System\.sdd\specs\feat-asyncEmailSender\CONTEXT.md` — Bối cảnh kiến trúc và quyết định đã chốt
3. `d:\Data\NetBeansIDE17\LMS-Library_Management_System\.sdd\specs\feat-asyncEmailSender\PLAN.md` — Thiết kế component chi tiết
4. `d:\Data\NetBeansIDE17\LMS-Library_Management_System\.sdd\specs\feat-asyncEmailSender\TASK.md` — Danh sách tasks (có đánh dấu đã xong/chưa)

### Bước 2: Rà soát trạng thái code hiện tại

Kiểm tra từng file sau và đối chiếu với TASK.md:

**Đã hoàn thành (T0.x) — Chỉ cần xác nhận, không cần làm lại:**
- `database/supabase/LMS_Schema_PostgreSQL.sql` — cột `description` trong bảng `documenttemp`
- `database/supabase/seeds/04_document_templates.sql` — 6 mẫu email seed
- `src/java/model/DocumentTemp.java` — field `description`
- `src/java/dao/DocumentTempDAO.java` — `PROTECTED_TEMPLATES`, `isProtected()`, logic chặn xóa
- `src/java/controllers/DocumentTempManagerServlet.java` — gọi `isProtected()` trong handleDelete

**Cần kiểm tra xem đã tồn tại chưa (T1.x, T2.x, T3.x):**
- `src/java/model/EmailJob.java` — DTO email job
- `src/java/service/EmailService.java` — Xem đang dùng mô hình gì (thread pool cũ hay queue mới?)
- `src/java/service/EmailWorker.java` — Daemon thread consumer
- `src/java/config/AppContextListener.java` — Có khởi động EmailWorker chưa?
- Các TODO email trong: `ForgotPasswordServlet`, `OnlineCirculationService`, `DeskCirculationService`, `OverdueProcessor`, `ReservationExpirationProcessor`, `CashPaymentServlet`

**Kiểm tra cấu hình:**
- `database/supabase/seeds/systemconfigurations_rows.sql` — Có đủ các keys SMTP + EMAIL_* chưa?

### Bước 3: Tạo Implementation Plan

Sau khi rà soát, tạo **Implementation Plan** cụ thể với:
- Danh sách tasks **còn lại** (chưa làm) từ TASK.md, đánh dấu rõ ưu tiên
- Chỉ ra các file nào cần tạo mới / sửa đổi / bỏ qua
- Phát hiện và ghi chú bất kỳ xung đột nào giữa code hiện tại và spec
- Đề xuất thứ tự triển khai tối ưu

### Bước 4: Chờ người dùng duyệt

**DỪNG LẠI** sau khi trình bày Implementation Plan. Chờ người dùng phê duyệt trước khi bắt đầu viết code.

---

## Quy tắc kỹ thuật BẮT BUỘC

- Sử dụng `LinkedBlockingQueue<EmailJob>` — không dùng synchronized list hay other concurrent collection
- EmailWorker là Daemon Thread duy nhất — không thread pool, không scheduled executor
- Template inject placeholder bằng `String.replace("{{key}}", value)` — không template engine bên ngoài
- SMTP credentials lấy từ AppConfig (env vars / fallback) — không đọc từ SystemConfigurations và không log mật khẩu thô.
- Retry dùng `Thread.sleep()` trong Worker — không ScheduledExecutorService
- Mọi email là `text/html; charset=UTF-8`
- Giao diện Manager (`/manager/email-templates`) chỉ cho phép chỉnh sửa `subject` và `bodyContent`
- Tuân thủ SEC-03: 100% SQL dùng PreparedStatement
- Tuân thủ UI-01: 100% giao diện tiếng Việt
