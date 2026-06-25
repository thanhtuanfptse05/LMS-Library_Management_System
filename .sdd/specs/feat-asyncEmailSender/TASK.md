# TASK — Tiến Trình Ngầm: Async Email Sender
# Feature ID: F-AsyncEmail | Version: 1.0.0 | Ngày tạo: 2026-06-25
# Thứ tự: Thực hiện tuần tự theo số thứ tự (phụ thuộc lẫn nhau)

---

## NHÓM 0 — CƠ SỞ HẠ TẦNG (ĐÃ HOÀN THÀNH)

- [x] **T0.1** Bổ sung cột `description` vào bảng `DocumentTemp` trong `LMS_Schema_PostgreSQL.sql`
- [x] **T0.2** Tạo seed file `04_document_templates.sql` với 6 mẫu email hệ thống
- [x] **T0.3** Cập nhật `model/DocumentTemp.java` — thêm field `description` + constructor + getter/setter
- [x] **T0.4** Cập nhật `dao/DocumentTempDAO.java` — thêm `description` vào SQL, thêm `PROTECTED_TEMPLATES` và logic chặn xóa mẫu hệ thống
- [x] **T0.5** Cập nhật `controllers/DocumentTempManagerServlet.java` — gọi `isProtected()` trong `handleDelete`, hiển thị lỗi tiếng Việt

---

## NHÓM 1 — TẠO MỚI CÁC THÀNH PHẦN CỐT LÕI

- [ ] **T1.1** Tạo `model/EmailJob.java`
  - Fields: `tempName`, `recipientEmail`, `recipientName`, `placeholders: Map<String, String>`, `attemptCount: int`
  - Constructor (String, String, String, Map) + getters + incrementAttempt()

- [ ] **T1.2** Refactor `service/EmailService.java`
  - Thêm `LinkedBlockingQueue<EmailJob> EMAIL_QUEUE` static (capacity từ SystemConfigurations hoặc default 500)
  - Thêm `public static void enqueue(EmailJob job)` — non-blocking offer, log warning nếu đầy
  - Giữ lại phương thức sendEmail thực sự (SMTP logic) để EmailWorker gọi
  - Xóa logic gửi bất đồng bộ cũ dùng `EXECUTOR` (FixedThreadPool), xóa hoàn toàn biến `EXECUTOR` tĩnh cũ này khỏi `EmailService` để tránh leak thread và không cần cleanup nó nữa.


- [ ] **T1.3** Tạo `service/EmailWorker.java`
  - Implements `Runnable`
  - `volatile boolean running` + `shutdown()` method
  - Vòng lặp chính: `queue.take()` → `sendWithRetry(job)`
  - `sendWithRetry()`: tra cứu template DB → inject placeholder → gọi SMTP → retry với delay
  - Placeholder injection: `String.replace("{{key}}", value)` cho mọi entry trong map
  - Ghi Logger INFO khi thành công, WARNING khi retry, SEVERE khi hết retry

---

## NHÓM 2 — TÍCH HỢP LIFECYCLE

- [ ] **T2.1** Cập nhật `config/AppContextListener.java`
  - Trong `contextInitialized`: khởi tạo `EmailWorker`, tạo Thread daemon, start, lưu vào `ServletContext`
  - Trong `contextDestroyed`: lấy worker từ context, gọi `worker.shutdown()`, `thread.join(5000)`

---

## NHÓM 3 — TÍCH HỢP VÀO CÁC PHÂN HỆ

- [ ] **T3.1** `ForgotPasswordServlet.java` — thêm `enqueue(RESET_PASSWORD)` sau khi UPDATE passwordHash thành công
  - Placeholders: `userName`, `tempPassword`

- [ ] **T3.2** `OnlineCirculationService.java` — thêm `enqueue(RESERVATION_READY)` khi sách có sẵn ngay lúc đặt
  - Placeholders: `userName`, `bookTitle`, `pickupDeadline`

- [ ] **T3.3** `OnlineCirculationService.java` — thêm `enqueue(RENEWAL_CONFIRMATION)` sau khi gia hạn thành công
  - Placeholders: `userName`, `bookTitle`, `newDueDate`, `extensionCount`, `maxExtension`

- [ ] **T3.4** `DeskCirculationService.java` — thêm `enqueue(RESERVATION_READY)` khi check-in đôn hàng chờ tiếp theo
  - Placeholders: `userName`, `bookTitle`, `pickupDeadline`

- [ ] **T3.5** `DeskCirculationService.java` — thêm `enqueue(INCIDENT_FINE_NOTICE)` khi check-in sách damaged/lost
  - Placeholders: `userName`, `bookTitle`, `barcode`, `incidentType`, `fineAmount`

- [ ] **T3.6** `OverdueProcessor.java` — thêm `enqueue(OVERDUE_NOTICE)` sau khi INSERT Fine thành công
  - Placeholders: `userName`, `bookTitle`, `dueDate`, `overdueDays`, `finePerDay`, `totalFine`

- [ ] **T3.7** `ReservationExpirationProcessor.java` — thêm `enqueue(RESERVATION_READY)` khi đôn hàng chờ tiếp theo
  - Placeholders: `userName`, `bookTitle`, `pickupDeadline`

- [ ] **T3.8** `CashPaymentServlet.java` — thêm `enqueue(PAYMENT_CONFIRMATION)` sau khi UPDATE Fine.status='paid'
  - Placeholders: `userName`, `paymentId`, `amount`, `paymentMethod`, `paidAt`

- [ ] **T3.9** SePay Webhook handler — thêm `enqueue(PAYMENT_CONFIRMATION)` sau khi xác nhận thanh toán thành công
  - Placeholders: `userName`, `paymentId`, `amount`, `paymentMethod`, `paidAt`

---

## NHÓM 4 — SEED DỮ LIỆU SYSTEMCONFIGURATIONS

- [ ] **T4.1** Kiểm tra `systemconfigurations_rows.sql` — bổ sung các keys còn thiếu:
  - `EMAIL_QUEUE_CAPACITY` = 500
  - `EMAIL_MAX_RETRIES` = 3
  - `EMAIL_RETRY_DELAY_SECONDS` = 30
  - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `EMAIL_FROM_NAME`

---

## NHÓM 5 — KIỂM THỬ

- [ ] **T5.1** Viết unit test `EmailWorkerTest.java`
  - Test inject placeholder đúng
  - Test retry logic (mock SMTP throw exception)
  - Test enqueue khi queue đầy → drop + log warning

- [ ] **T5.2** Manual test: chạy server, trigger từng event, xác nhận email vào hộp thư

---

## PHỤ THUỘC GIỮA CÁC TASK

```
T1.1 → T1.2 → T1.3 → T2.1
                          │
                          └─► T3.1 ... T3.9 (song song)
                                          │
                                          └─► T4.1 → T5.1 → T5.2
```
