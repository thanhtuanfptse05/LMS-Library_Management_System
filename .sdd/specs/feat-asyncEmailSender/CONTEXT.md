# CONTEXT — Tiến Trình Ngầm: Async Email Sender
# Feature ID: F-AsyncEmail | Version: 1.0.0 | Ngày tạo: 2026-06-25

---

## 1. BỐI CẢNH & LÝ DO TỒN TẠI

### Vị trí trong hệ thống

`Async Email Sender` là **tầng hạ tầng chia sẻ (Shared Infrastructure)**, nằm ngang qua tất cả các phân hệ khác. Không giống Overdue Processor (chỉ thuộc F9) hay Reservation Expiration (chỉ thuộc F5), Email Sender **không thuộc về một feature cụ thể nào** — nó là dịch vụ nền tảng.

```
F1 Auth ─────────────────────────────────────────────────┐
F5 Reservation/Renewal ──────────────────────────────────┤
F6 Desk Circulation ─────────────────────────────────────┼──► EmailService.enqueue()
F9 OverdueProcessor/Payment ─────────────────────────────┤        │
ReservationExpirationProcessor ──────────────────────────┘        ▼
                                                         EmailWorker (Daemon Thread)
                                                                   │
                                                         DocumentTempDAO (SMTP send)
```

### Tại sao cần async?

Gửi email qua SMTP có latency cao (50ms–3000ms tùy server), không ổn định và có thể timeout. Nếu gửi đồng bộ trong HTTP request sẽ:
- Làm chậm response cho người dùng
- Có thể gây lỗi nếu SMTP gián đoạn
- Không thể retry tự động

### Tại sao chọn BlockingQueue + Daemon Thread?

Phù hợp với kiến trúc Monolith Java Servlet của dự án:
- Không cần message broker bên ngoài (Kafka, RabbitMQ)
- Không cần Spring Boot hay framework bổ sung
- Lifecycle được quản lý bởi `AppContextListener` của Servlet Container
- Đủ đáp ứng cho quy mô thư viện đại học (< 5000 sinh viên)

---

## 2. QUYẾT ĐỊNH THIẾT KẾ ĐÃ CHỐT

| # | Quyết định | Lý do |
|---|---|---|
| D1 | Dùng `LinkedBlockingQueue` thay vì synchronized list | Thread-safe built-in, không cần lock thủ công |
| D2 | Daemon Thread duy nhất (không pool) | Đủ throughput, đơn giản, không race condition |
| D3 | Template lấy từ DB mỗi lần gửi (có thể cache) | Manager cần chỉnh sửa template và thấy hiệu lực ngay |
| D4 | Placeholder dạng `{{key}}` thay vào bằng `String.replace()` | Không cần template engine phức tạp |
| D5 | Retry với `Thread.sleep()` trong Worker | Đơn giản, phù hợp Monolith — không cần ScheduledExecutorService phức tạp |
| D6 | Graceful shutdown drain queue 5 giây | Tránh mất email trong queue khi restart server |
| D7 | `DocumentTemp` là System Config table | Manager chỉnh sửa nội dung, không được xóa 6 mẫu hệ thống |
| D8 | SMTP credentials lấy từ AppConfig (env/fallback) | Bảo mật thông tin nhạy cảm, dễ dàng cấu hình qua biến môi trường hoặc fallback cứng |

---

## 3. PHỤ THUỘC (Dependencies)

### Code phụ thuộc đến EmailService:
- `ForgotPasswordServlet` → `RESET_PASSWORD`
- `OnlineCirculationService` → `RESERVATION_READY`, `RENEWAL_CONFIRMATION`
- `DeskCirculationService` → `RESERVATION_READY`, `INCIDENT_FINE_NOTICE`
- `OverdueProcessor` → `OVERDUE_NOTICE`
- `CashPaymentServlet` + SePay Webhook → `PAYMENT_CONFIRMATION`
- `ReservationExpirationProcessor` → `RESERVATION_READY`

### Thư viện:
- `jakarta.mail-2.0.1.jar` — JavaMail API (đã có trong `allowedlib/`)
- Không cần thêm dependency mới

### Bảng CSDL:
- `DocumentTemp` — lưu trữ template email (đã có + đã bổ sung cột `description`)
- `SystemConfigurations` — lưu cấu hình tham số retry và email từ tên hiển thị
- `AuditLogs` — ghi nhận kết quả gửi email (để truy vết)

---

## 4. GIẢ ĐỊNH & RÀNG BUỘC

- **GA-01:** SMTP credentials (host, port, user, password) đã được cấu hình trong `AppConfig` (qua biến môi trường hoặc fallback cứng) trước khi deploy.
- **GA-02:** Manager mặc định (managerId = ID của MANAGER đầu tiên trong DB) đã tồn tại trong bảng `LibraryManager` từ seed data.
- **GA-03:** Template HTML trong `bodyContent` đã được kiểm tra render đúng trên Gmail, Outlook.
- **CB-01:** Daemon Thread sẽ bị kill ngay khi JVM tắt hoàn toàn — đây là hành vi bình thường của Daemon Thread.
- **CB-02:** Không hỗ trợ attachment file trong phiên bản này.
- **CB-03:** Tất cả email là MIME HTML (`text/html; charset=UTF-8`).
