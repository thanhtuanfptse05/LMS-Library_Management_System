# SPEC — Tiến Trình Ngầm: Async Email Sender (Luồng Gửi Email)
# Feature ID: F-AsyncEmail | Truy vết: FR-31, NFR-02
# Version: 1.0.0 | Ngày tạo: 2026-06-25

---

## 1. TỔNG QUAN (Overview)

### 1.1 Mô tả

`Async Email Sender` là **tiến trình ngầm hạ tầng dùng chung (Shared Infrastructure Background Process)** — không thuộc về bất kỳ phân hệ chức năng cụ thể nào, mà phục vụ toàn bộ hệ thống LMS.

Tiến trình này hoạt động theo mô hình **Producer-Consumer**:
- **Producers (Người sản xuất):** Bất kỳ phân hệ nào (F1, F5, F6, F9) cần gửi email đều đẩy payload vào một **hàng đợi chung (BlockingQueue)** thông qua API public của `EmailService`.
- **Consumer (Người tiêu thụ):** Một **Daemon Thread** duy nhất chạy nền liên tục, lấy từng job từ hàng đợi → tra cứu template từ `DocumentTemp` → inject placeholder → gửi qua SMTP → ghi log kết quả.

### 1.2 Phạm vi tác nhân

| Actor | Vai trò |
|---|---|
| Hệ thống (System) | Vận hành toàn bộ tiến trình tự động, không có tương tác người dùng trực tiếp |
| Library Manager | Có thể xem và chỉnh sửa nội dung mẫu email tại `/manager/email-templates` |

### 1.3 Vị trí trong kiến trúc

```
Tất cả các phân hệ (F1, F5, F6, F9)
        │
        ▼ gọi EmailService.enqueue(EmailJob)
┌─────────────────────────────────────────┐
│         EmailService (Producer API)      │
│  LinkedBlockingQueue<EmailJob> (buffer)  │
└─────────────────┬───────────────────────┘
                  │ Daemon Thread lấy job
                  ▼
┌─────────────────────────────────────────┐
│         EmailWorker (Consumer)           │
│  1. findByTempName(job.tempName) → DAO   │
│  2. inject placeholders vào template     │
│  3. build MIME message                   │
│  4. SMTP send (JavaMail)                 │
│  5. retry nếu thất bại (max N lần)       │
│  6. ghi AuditLog kết quả                │
└─────────────────────────────────────────┘
```

---

## 2. YÊU CẦU CHỨC NĂNG (Functional Requirements)

### 2.1 Hàng đợi Email (EmailJob Queue)

| ID | Mô tả |
|---|---|
| FR-31.1 | Hệ thống PHẢI cung cấp phương thức `EmailService.enqueue(EmailJob)` thread-safe để bất kỳ luồng nào cũng có thể đẩy job vào hàng đợi mà không block. |
| FR-31.2 | `EmailJob` PHẢI chứa: `tempName`, `recipientEmail`, `recipientName`, `placeholders` (Map<String, String>). |
| FR-31.3 | Hàng đợi PHẢI là `LinkedBlockingQueue<EmailJob>` với sức chứa tối đa cấu hình từ `SystemConfigurations.EMAIL_QUEUE_CAPACITY` (mặc định: 500). |
| FR-31.4 | Nếu hàng đợi đầy (queue full), hệ thống PHẢI ghi log cảnh báo và loại bỏ job mới nhất (drop) — không được block luồng Producer. |

### 2.2 Daemon Thread Worker

| ID | Mô tả |
|---|---|
| FR-31.5 | Hệ thống PHẢI khởi động một Daemon Thread duy nhất khi ứng dụng start (trong `AppContextListener.contextInitialized`). |
| FR-31.6 | Worker PHẢI dùng `queue.take()` (blocking) để chờ job mà không tiêu tốn CPU khi hàng đợi rỗng. |
| FR-31.7 | Worker PHẢI tra cứu template từ `DocumentTempDAO.findByTempName(tempName)` mỗi lần gửi để lấy nội dung mới nhất Manager đã chỉnh sửa. Có thể cache trong RAM để tối ưu. |
| FR-31.8 | Worker PHẢI inject dữ liệu động vào template bằng cách thay thế các placeholder dạng `{{key}}` → giá trị tương ứng từ `EmailJob.placeholders`. |
| FR-31.9 | Worker PHẢI gửi email qua SMTP (JavaMail) sử dụng cấu hình `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD` từ `SystemConfigurations`. |

### 2.3 Cơ chế Retry

| ID | Mô tả |
|---|---|
| FR-31.10 | Nếu gửi thất bại (Exception SMTP), Worker PHẢI thử lại tối đa `EMAIL_MAX_RETRIES` lần (mặc định: 3, lấy từ SystemConfigurations). |
| FR-31.11 | Giữa các lần retry, Worker PHẢI chờ `EMAIL_RETRY_DELAY_SECONDS` giây (mặc định: 30 giây, lấy từ SystemConfigurations). |
| FR-31.12 | Sau khi vượt quá số lần retry, Worker PHẢI ghi log lỗi và tiếp tục xử lý job tiếp theo (không crash thread). |

### 2.4 Template & DocumentTemp

| ID | Mô tả |
|---|---|
| FR-31.13 | Template được lưu trong bảng `DocumentTemp` với khóa `tempName`. 6 mẫu hệ thống bên dưới được seed sẵn khi deploy. |
| FR-31.14 | Manager được phép chỉnh sửa `subject` và `bodyContent` của template tại `/manager/email-templates`. |
| FR-31.15 | 6 mẫu hệ thống KHÔNG ĐƯỢC PHÉP XÓA: `RESET_PASSWORD`, `RESERVATION_READY`, `RENEWAL_CONFIRMATION`, `OVERDUE_NOTICE`, `INCIDENT_FINE_NOTICE`, `PAYMENT_CONFIRMATION`. |

### 2.5 Graceful Shutdown

| ID | Mô tả |
|---|---|
| FR-31.16 | Khi ứng dụng shutdown (`AppContextListener.contextDestroyed`), hệ thống PHẢI dừng tiếp nhận job mới, chờ tối đa 5 giây để drain các job còn lại trong hàng đợi rồi mới tắt Worker thread. |

---

## 3. CÁC SỰ KIỆN GỬI EMAIL (Email Event Catalog)

| # | tempName | Phân hệ nguồn | Trigger Point |
|---|---|---|---|
| 1 | `RESET_PASSWORD` | F1 - Auth | `ForgotPasswordServlet` → sau khi UPDATE passwordHash thành công |
| 2 | `RESERVATION_READY` | F5 - Reservation | 3 nguồn: (a) `OnlineCirculationService` sách có sẵn, (b) `DeskCirculationService` trả sách đôn hàng chờ, (c) `ReservationExpirationProcessor` hủy đơn đôn hàng chờ |
| 3 | `RENEWAL_CONFIRMATION` | F5 - Renewal | `OnlineCirculationService` → sau UPDATE BorrowRecord.endDate thành công |
| 4 | `OVERDUE_NOTICE` | F9 - OverdueProcessor | `OverdueProcessor` → sau INSERT Fine + UPDATE User.status='locked' |
| 5 | `INCIDENT_FINE_NOTICE` | F6 - DeskCirculation | `DeskCirculationService` → sau INSERT Fine khi check-in sách damaged/lost |
| 6 | `PAYMENT_CONFIRMATION` | F9 - Payment | `CashPaymentServlet` và SePay Webhook handler |

---

## 4. QUY TẮC NGHIỆP VỤ (Business Rules — EARS)

| ID | Rule |
|---|---|
| BR-37.1 | WHEN bất kỳ phân hệ nào gọi `EmailService.enqueue(job)`, THE system SHALL đẩy job vào `LinkedBlockingQueue` mà không block luồng gọi. |
| BR-37.2 | WHEN hàng đợi đạt `EMAIL_QUEUE_CAPACITY`, THE system SHALL ghi log WARNING và loại bỏ job mới nhất (drop), ưu tiên bảo vệ tính ổn định hệ thống. |
| BR-37.3 | WHEN Worker lấy job từ hàng đợi, THE system SHALL tra cứu template từ `DocumentTemp` theo `tempName` để luôn dùng nội dung mới nhất Manager đã chỉnh sửa. |
| BR-37.4 | WHEN gửi email thất bại lần đầu, THE system SHALL thử lại tối đa `EMAIL_MAX_RETRIES` lần với khoảng chờ `EMAIL_RETRY_DELAY_SECONDS` giữa các lần. |
| BR-37.5 | WHEN vượt quá số lần retry, THE system SHALL ghi log SEVERE với đầy đủ thông tin (tempName, recipientEmail, exception) và tiếp tục xử lý job tiếp theo. |
| BR-37.6 | WHEN ứng dụng nhận lệnh shutdown, THE system SHALL đánh dấu cờ `running = false`, đợi tối đa 5 giây drain queue, rồi interrupt Worker thread. |
| BR-37.7 | WHEN Manager cố gắng xóa mẫu email hệ thống, THE system SHALL từ chối và hiển thị thông báo lỗi bằng tiếng Việt rõ ràng. |
| BR-37.8 | WHEN xử lý job RESET_PASSWORD, Worker PHẢI KHÔNG log giá trị mật khẩu tạm `{{tempPassword}}` dưới bất kỳ hình thức nào để đảm bảo bảo mật. |

---

## 5. YÊU CẦU PHI CHỨC NĂNG (Non-Functional Requirements)

| ID | Yêu cầu |
|---|---|
| NFR-02.1 | **Performance:** Thao tác `enqueue()` phải trả về trong < 10ms để không ảnh hưởng HTTP response của luồng chính. |
| NFR-02.2 | **Reliability:** Worker là Daemon Thread — không làm treo JVM khi tắt. Phải xử lý Exception không để crash. |
| NFR-02.3 | **Observability:** Mọi sự kiện gửi email (success/fail/retry) phải được ghi vào Java Logger với đủ thông tin: tempName, recipientEmail, attempt number. |
| NFR-02.4 | **Configurability:** Các tham số (queue capacity, max retries, retry delay, email from name) phải đọc từ `SystemConfigurations` — không hardcode. |

---

## 6. CẤU HÌNH HỆ THỐNG (SystemConfigurations Keys)

| configKey | configValue mặc định | Mô tả |
|---|---|---|
| `EMAIL_QUEUE_CAPACITY` | `500` | Sức chứa tối đa của hàng đợi EmailJob |
| `EMAIL_MAX_RETRIES` | `3` | Số lần thử lại tối đa khi gửi thất bại |
| `EMAIL_RETRY_DELAY_SECONDS` | `30` | Thời gian chờ (giây) giữa các lần retry |
| `EMAIL_FROM_NAME` | `Thư viện LMS` | Tên hiển thị ở trường "From" |

---

## 7. CẤU TRÚC FILE TRIỂN KHAI

```
src/java/
├── service/
│   ├── EmailService.java          [MODIFY] Refactor thành queue-based producer
│   └── EmailWorker.java           [NEW]    Daemon Thread consumer
├── model/
│   └── EmailJob.java              [NEW]    DTO chứa payload gửi email
├── dao/
│   └── DocumentTempDAO.java       [DONE ✓] Đã có findByTempName(), PROTECTED_TEMPLATES
├── model/
│   └── DocumentTemp.java          [DONE ✓] Đã bổ sung description field
└── config/
    └── AppContextListener.java    [MODIFY] Khởi động/dừng EmailWorker daemon thread

database/supabase/seeds/
└── 04_document_templates.sql      [DONE ✓] 6 mẫu email hệ thống đã seed
```

---

## 8. RÀNG BUỘC & GIẢ ĐỊNH

- **Giả định:** SMTP credentials đã được cấu hình trong `AppConfig` (thông qua biến môi trường hoặc giá trị fallback cứng) trước khi deploy.
- **Giả định:** Manager mặc định (managerId=6) đã tồn tại trong DB (từ seed data).
- **Ràng buộc:** Chỉ dùng JavaMail (đã có trong `allowedlib/jakarta.mail-2.0.1.jar`). Không dùng API bên ngoài.
- **Ràng buộc:** Một Worker thread duy nhất — không scale-out (đủ cho quy mô thư viện đại học).
- **Ràng buộc:** Template hỗ trợ placeholder dạng `{{key}}` (không dùng engine phức tạp như Thymeleaf).
- **Lưu ý bảo mật:** Tuyệt đối không log thông tin mật khẩu thô của người dùng trong hệ thống (đặc biệt khi thực hiện job `RESET_PASSWORD`).

---

## 9. THIẾT KẾ LIFECYCLE VÀ THỨ TỰ KHỞI TẠO (AppContextListener Lifecycle)

Để tránh lỗi phụ thuộc thời gian chạy giữa các tiến trình ngầm (như việc processor quét quá hạn hoặc hủy hàng chờ cố gắng đẩy email vào hàng đợi khi worker gửi mail chưa khởi động, hoặc caches chưa load xong cấu hình), `AppContextListener` sẽ quản lý vòng đời khởi tạo và dọn dẹp tài nguyên theo thứ tự nghiêm ngặt sau:

### 9.1 Khởi tạo (`contextInitialized`)
1. **Khởi tạo Cache Cấu hình:** `SystemConfigCache.load(context)` — Nạp cấu hình từ DB lên bộ nhớ (ví dụ: `EMAIL_QUEUE_CAPACITY`, `RESERVATION_HOLD_DAYS`). Bắt buộc phải có để các tiến trình sau hoạt động chính xác.
2. **Khởi động Async Email Worker:** Khởi tạo `EmailWorker`, đăng ký Daemon Thread và bắt đầu chạy (`thread.start()`). Lưu đối tượng `EmailWorker` vào `ServletContext` để có thể truy xuất khi shutdown.
3. **Khởi chạy Overdue Processor (F9):** Khởi tạo `ScheduledExecutorService` cho `OverdueProcessor`, thiết lập trigger chạy định kỳ hàng đêm vào lúc 00:00 AM.
4. **Khởi chạy Reservation Expiration Processor (F5):** Khởi tạo `ScheduledExecutorService` cho `ReservationExpirationProcessor`, thiết lập chạy định kỳ mỗi 1 giờ.

### 9.2 Hủy bỏ (`contextDestroyed`)
1. **Dừng các Processor lập lịch (F9 và F5):** Gọi `shutdownNow()` đối với cả hai `ScheduledExecutorService` của `OverdueProcessor` và `ReservationExpirationProcessor` để lập tức ngắt các luồng lập lịch quét mới.
2. **Dừng và Drain Email Queue:** Gọi `EmailWorker.shutdown()`, sau đó chờ tối đa 5 giây (`thread.join(5000)`) để worker xử lý nốt các job email còn tồn đọng trong queue trước khi JVM shutdown.
3. **Giải phóng Driver JDBC:** Thực hiện deregister các driver SQL để tránh lỗi rò rỉ bộ nhớ (memory leak) của Tomcat/Glassfish container.


