package service;

import dao.EmailTemplateDAO;
import dao.AuditLogDAO;
import model.EmailJob;
import model.EmailTemplate;
import model.User;
import jakarta.servlet.ServletContext;
import java.sql.Timestamp;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailWorker — Daemon Thread tiêu thụ (Consumer) các EmailJob trong hàng đợi.
 *
 * <p>Hoạt động song song với luồng chính để lắp ráp mẫu, gửi SMTP và xử lý lỗi.</p>
 */
public class EmailWorker implements Runnable {

    private static final Logger LOGGER = Logger.getLogger(EmailWorker.class.getName());

    private final ServletContext servletContext;
    private final EmailTemplateDAO emailTemplateDAO;
    private final AuditLogDAO auditLogDAO;
    private volatile boolean running = true;

    public EmailWorker(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.emailTemplateDAO = new EmailTemplateDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    /**
     * Phát tín hiệu dừng luồng ngầm một cách an toàn.
     */
    public void shutdown() {
        this.running = false;
    }

    @Override
    public void run() {
        LOGGER.log(Level.INFO, "[EMAIL WORKER] Daemon Thread bắt đầu chạy ngầm...");

        while (running) {
            try {
                EmailJob job = EmailService.take(); // Blocking wait
                sendWithRetry(job);
            } catch (InterruptedException e) {
                LOGGER.log(Level.INFO, "[EMAIL WORKER] Daemon Thread bị ngắt (Interrupted). Đang chuyển sang dừng luồng...");
                break;
            }
        }

        // Thực hiện drain hàng đợi (xử lý nốt các job còn tồn đọng không nghẽn)
        drainQueue();
        LOGGER.log(Level.INFO, "[EMAIL WORKER] Daemon Thread đã dừng hoàn toàn.");
    }

    private void drainQueue() {
        LOGGER.log(Level.INFO, "[EMAIL WORKER] Bắt đầu xử lý nốt các email còn lại trong hàng đợi...");
        // Sử dụng một vòng lặp để lấy hết các job còn trong queue mà không block
        int count = 0;
        while (EmailService.getQueueSize() > 0) {
            try {
                EmailJob job = EmailService.take(); // Lấy nốt
                sendWithRetry(job);
                count++;
            } catch (InterruptedException e) {
                LOGGER.log(Level.WARNING, "[EMAIL WORKER] Drain hàng đợi bị ngắt nửa chừng.");
                break;
            }
        }
        LOGGER.log(Level.INFO, "[EMAIL WORKER] Đã xử lý xong {0} email tồn đọng.", count);
    }

    private void sendWithRetry(EmailJob job) {
        int maxRetries = getConfigInt("EMAIL_MAX_RETRIES", 3);
        int delaySeconds = getConfigInt("EMAIL_RETRY_DELAY_SECONDS", 30);

        job.incrementAttempt(); // Lần thử thứ nhất

        while (true) {
            try {
                String subject;
                String body;

                if (job.getTempName() == null) {
                    // Luồng Active (gửi HTML trực tiếp từ NotificationManagerServlet)
                    subject = job.getDirectSubject();
                    body = job.getDirectBody();
                } else {
                    // Luồng Passive (tra cứu mẫu hệ thống từ bảng EmailTemplate)
                    EmailTemplate template = emailTemplateDAO.findByTempName(job.getTempName());
                    if (template == null) {
                        if ("RECALL_NOTICE".equals(job.getTempName())) {
                            template = new EmailTemplate();
                            template.setTempName("RECALL_NOTICE");
                            template.setSubject("Thông báo: Yêu cầu thu hồi sách mượn — Thư viện LMS");
                            template.setBodyContent("<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#c2410c;margin:0;\">📢 Yêu cầu thu hồi sách mượn</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Thư viện xin thông báo yêu cầu <strong>thu hồi lại cuốn sách</strong> bạn đang mượn với lý do cụ thể sau:</p><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style="margin:0;font-size:14px;color:#dc2626;font-weight:bold;\">💬 Lý do thu hồi: {{recallReason}}</p></div><div style=\"background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0 0 6px;font-size:16px;font-weight:bold;color:#1a4fa3;\">📖 Tên sách: {{bookTitle}}</p><p style=\"margin:0;font-size:13px;color:#475569;\">🏷️ Mã vạch bản sao: <strong>{{barcode}}</strong></p></div><p>Vui lòng mang cuốn sách này đến <strong>Quầy Lưu thông Thư viện</strong> để hoàn tất thủ tục trả sách trong thời gian sớm nhất.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p></div></body></html>");
                        } else {
                            LOGGER.log(Level.SEVERE, "[EMAIL WORKER] Không tìm thấy mẫu email với tên: {0}", job.getTempName());
                            return; // Không tồn tại template -> hủy bỏ job này
                        }
                    }

                    subject = template.getSubject();
                    body = template.getBodyContent();

                    // Ráp placeholders động
                    if (job.getPlaceholders() != null) {
                        for (Map.Entry<String, String> entry : job.getPlaceholders().entrySet()) {
                            String key = entry.getKey();
                            String value = entry.getValue() != null ? entry.getValue() : "";
                            subject = subject.replace("{{" + key + "}}", value);
                            body = body.replace("{{" + key + "}}", value);
                        }
                    }

                    // Ráp {{userName}} mặc định
                    String recName = job.getRecipientName() != null ? job.getRecipientName() : "";
                    subject = subject.replace("{{userName}}", recName);
                    body = body.replace("{{userName}}", recName);
                }

                // Thực hiện gửi SMTP qua EmailService
                EmailService.sendEmail(job.getRecipientEmail(), subject, body);

                LOGGER.log(Level.INFO, "[EMAIL WORKER] Gửi email THÀNH CÔNG: [{0}] tới {1} (Lần thử: {2})",
                        new Object[]{job.getTempName() != null ? job.getTempName() : "DIRECT_HTML", job.getRecipientEmail(), job.getAttemptCount()});

                // Ghi Audit Log thành công
                writeAuditLog(job, "SUCCESS", null);
                return; // Gửi thành công, thoát khỏi retry

            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "[EMAIL WORKER] Gửi email THẤT BẠI (Lần thử {0}/{1}) tới {2}. Lỗi: {3}",
                        new Object[]{job.getAttemptCount(), maxRetries, job.getRecipientEmail(), e.getMessage()});

                if (job.getAttemptCount() < maxRetries) {
                    job.incrementAttempt();
                    try {
                        Thread.sleep(delaySeconds * 1000L);
                    } catch (InterruptedException ie) {
                        LOGGER.log(Level.WARNING, "[EMAIL WORKER] Tiến trình chờ retry bị ngắt quãng.");
                        Thread.currentThread().interrupt(); // khôi phục trạng thái interrupt
                        writeAuditLog(job, "FAILED", ie.getMessage());
                        return;
                    }
                } else {
                    // Hết số lần retry
                    LOGGER.log(Level.SEVERE, "[EMAIL WORKER] Đã thử lại {0} lần nhưng đều thất bại gửi email [{1}] tới {2}.",
                            new Object[]{maxRetries, job.getTempName() != null ? job.getTempName() : "DIRECT_HTML", job.getRecipientEmail()});
                    writeAuditLog(job, "FAILED", e.getMessage());
                    return;
                }
            }
        }
    }

    private int getConfigInt(String key, int defaultValue) {
        if (servletContext == null) {
            return defaultValue;
        }
        return config.SystemConfigCache.getInt(servletContext, key, defaultValue);
    }

    private void writeAuditLog(EmailJob job, String status, String errorMessage) {
        // Không log thông tin mật khẩu tạm để bảo vệ an toàn
        String details = String.format("Status: %s | TempName: %s | Recipient: %s | Attempts: %d",
                status,
                job.getTempName() != null ? job.getTempName() : "DIRECT_HTML",
                job.getRecipientEmail(),
                job.getAttemptCount());
        
        if (errorMessage != null) {
            details += " | Error: " + errorMessage;
        }

        try (java.sql.Connection conn = util.DatabaseConnection.getConnection()) {
            // Ghi Audit Log hệ thống
            auditLogDAO.insert(
                    conn,
                    null, // Tác vụ hệ thống tự động, userId = null
                    "SYSTEM_EMAIL",
                    "EmailJob",
                    null,
                    null,
                    details
            );
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "[EMAIL WORKER] Lỗi khi ghi Audit Log gửi email ngầm", ex);
        }
    }
}
