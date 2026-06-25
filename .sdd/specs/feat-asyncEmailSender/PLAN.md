# PLAN — Tiến Trình Ngầm: Async Email Sender
# Feature ID: F-AsyncEmail | Version: 1.0.0 | Ngày tạo: 2026-06-25

---

## 1. THIẾT KẾ THÀNH PHẦN (Component Design)

### 1.1 EmailJob (DTO)

```java
// src/java/model/EmailJob.java
public class EmailJob {
    private final String tempName;       // Khóa tra cứu template
    private final String recipientEmail; // Email người nhận
    private final String recipientName;  // Tên người nhận (inject vào {{userName}})
    private final Map<String, String> placeholders; // Tất cả dữ liệu động
    private int attemptCount;            // Số lần đã thử (retry tracking)

    // Constructor + getters
}
```

### 1.2 EmailService (Refactored — Producer API)

```java
// src/java/service/EmailService.java
public class EmailService {
    // Singleton queue — dùng chung toàn ứng dụng
    private static final LinkedBlockingQueue<EmailJob> EMAIL_QUEUE = new LinkedBlockingQueue<>(500);

    // API public cho tất cả phân hệ gọi
    public static void enqueue(EmailJob job) {
        boolean added = EMAIL_QUEUE.offer(job); // non-blocking
        if (!added) {
            LOGGER.warning("Email queue FULL, dropping job: " + job.getTempName());
        }
    }

    // Package-private — chỉ EmailWorker gọi
    static EmailJob take() throws InterruptedException {
        return EMAIL_QUEUE.take(); // blocking wait
    }

    static int queueSize() {
        return EMAIL_QUEUE.size();
    }
}
```

### 1.3 EmailWorker (Daemon Thread Consumer)

```java
// src/java/service/EmailWorker.java
public class EmailWorker implements Runnable {
    private volatile boolean running = true;

    public void shutdown() { this.running = false; }

    @Override
    public void run() {
        while (running || !queueEmpty()) {
            EmailJob job = EmailService.take(); // blocking
            sendWithRetry(job);
        }
    }

    private void sendWithRetry(EmailJob job) {
        int maxRetries = getConfig("EMAIL_MAX_RETRIES", 3);
        int delaySeconds = getConfig("EMAIL_RETRY_DELAY_SECONDS", 30);

        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                DocumentTemp template = documentTempDAO.findByTempName(job.getTempName());
                String body = injectPlaceholders(template.getBodyContent(), job);
                String subject = injectPlaceholders(template.getSubject(), job);
                sendViaSMTP(job.getRecipientEmail(), subject, body);
                LOGGER.info("Email sent OK: " + job.getTempName() + " -> " + job.getRecipientEmail());
                return; // thành công
            } catch (Exception e) {
                LOGGER.warning("Attempt " + attempt + " failed: " + e.getMessage());
                if (attempt < maxRetries) Thread.sleep(delaySeconds * 1000L);
            }
        }
        LOGGER.severe("All retries exhausted for: " + job.getTempName() + " -> " + job.getRecipientEmail());
    }
}
```

### 1.4 AppContextListener (Lifecycle Management)

```java
// Trong contextInitialized():
EmailWorker worker = new EmailWorker();
Thread emailThread = new Thread(worker, "email-worker");
emailThread.setDaemon(true);
emailThread.start();
servletContext.setAttribute("emailWorker", worker);

// Trong contextDestroyed():
EmailWorker worker = (EmailWorker) servletContext.getAttribute("emailWorker");
worker.shutdown();
// drain tối đa 5 giây
emailThread.join(5000);
```

---

## 2. LUỒNG DỮ LIỆU HOÀN CHỈNH (Data Flow per Event)

### Ví dụ: OVERDUE_NOTICE (phức tạp nhất)

```
OverdueProcessor.run()
    │
    ├─► INSERT Fine (fineDAO)
    ├─► UPDATE User.status='locked' (userDAO)
    │
    └─► EmailService.enqueue(new EmailJob(
            "OVERDUE_NOTICE",
            user.getEmail(),
            memberProfile.getFullName(),
            Map.of(
                "userName",    memberProfile.getFullName(),
                "bookTitle",   book.getTitle(),
                "dueDate",     borrowRecord.getEndDate().toString(),
                "overdueDays", String.valueOf(overdueDays),
                "finePerDay",  config.get("OVERDUE_FINE_PER_DAY"),
                "totalFine",   String.valueOf(fineAmount)
            )
        ))

EmailWorker (async, separate thread)
    │
    ├─► DocumentTempDAO.findByTempName("OVERDUE_NOTICE")
    ├─► inject placeholders vào subject + bodyContent
    ├─► build MIME Message (JavaMail)
    └─► Transport.send() → Gmail SMTP → Inbox độc giả
```

---

## 3. KẾ HOẠCH TRIỂN KHAI (Implementation Steps)

### Bước 1: Tạo mới các file cốt lõi
1. `model/EmailJob.java` — DTO
2. `service/EmailWorker.java` — Daemon Thread Consumer
3. Refactor `service/EmailService.java` — chuyển từ fixed thread pool → BlockingQueue producer

### Bước 2: Tích hợp lifecycle vào AppContextListener
- Khởi động EmailWorker daemon thread trong `contextInitialized`
- Graceful shutdown (drain 5s) trong `contextDestroyed`

### Bước 3: Tích hợp vào các phân hệ (thay các TODO cũ)
- `ForgotPasswordServlet` → enqueue RESET_PASSWORD
- `OnlineCirculationService` → enqueue RESERVATION_READY, RENEWAL_CONFIRMATION
- `DeskCirculationService` → enqueue RESERVATION_READY (đôn hàng chờ), INCIDENT_FINE_NOTICE
- `OverdueProcessor` → enqueue OVERDUE_NOTICE
- `ReservationExpirationProcessor` → enqueue RESERVATION_READY
- `CashPaymentServlet` / SePay Webhook → enqueue PAYMENT_CONFIRMATION

### Bước 4: Seed SystemConfigurations
Thêm các keys cấu hình (EMAIL_QUEUE_CAPACITY, EMAIL_MAX_RETRIES, EMAIL_RETRY_DELAY_SECONDS, EMAIL_FROM_NAME) vào seed file nếu chưa có. SMTP credentials được lấy từ AppConfig (env vars / fallback) để đảm bảo an toàn bảo mật.

### Bước 5: Seed DocumentTemp
File `04_document_templates.sql` đã được tạo (DONE ✓).

---

## 4. KIỂM TRA & XÁC NHẬN

| Loại test | Phương thức |
|---|---|
| Unit test EmailWorker | Mock DocumentTempDAO + Mock SMTP, kiểm tra inject placeholder đúng |
| Unit test EmailService.enqueue | Kiểm tra thread-safety khi nhiều thread enqueue đồng thời |
| Unit test retry | Mock SMTP ném exception, kiểm tra số lần retry và delay |
| Manual test | Trigger từng event thực tế, xác nhận email vào Gmail |
| Boundary test | Fill queue tới capacity, kiểm tra drop behavior và log warning |
