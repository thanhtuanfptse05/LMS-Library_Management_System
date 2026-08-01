package service;

import config.AppConfig;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.EmailJob;

/**
 * EmailService — Dịch vụ gửi email bất đồng bộ qua hàng đợi LinkedBlockingQueue.
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>Non-blocking: Mọi tác vụ gửi mail được đưa vào hàng đợi thông qua {@link #enqueue(EmailJob)}.</li>
 *   <li>NFR-01: Tuyệt đối không in/log mật khẩu plaintext ra console hay file.</li>
 *   <li>Dùng {@link AppConfig} làm nguồn cấu hình kết nối SMTP duy nhất.</li>
 * </ul>
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    // =========================================================================
    // Public API: Gửi email bất đồng bộ trực tiếp bằng CompletableFuture (Fire-and-forget)
    // =========================================================================

    /**
     * Gửi bất đồng bộ một EmailJob qua CompletableFuture mà không chặn luồng HTTP.
     *
     * @param job Công việc gửi mail cần thực hiện
     */
    public static void enqueue(EmailJob job) {
        if (job == null) {
            return;
        }
        
        String toEmail = job.getRecipientEmail();
        if (toEmail == null || toEmail.trim().isEmpty() || !toEmail.trim().toLowerCase().endsWith("@gmail.com")) {
            LOGGER.log(Level.INFO, "[EMAIL] Bỏ qua gửi email do địa chỉ nhận rỗng hoặc không phải gmail thật: {0}", toEmail);
            return;
        }

        java.util.concurrent.CompletableFuture.runAsync(() -> {
            try {
                if (job.getTempName() == null && job.getDirectBody() != null) {
                    sendEmail(job.getRecipientEmail(), job.getDirectSubject(), job.getDirectBody());
                } else {
                    dao.DocumentTempDAO tempDAO = new dao.DocumentTempDAO();
                    model.DocumentTemp temp = tempDAO.findByTempName(job.getTempName());
                    String[] defaults = getDefaultTemplate(job.getTempName());

                    String subject = (temp != null && temp.getSubject() != null && !temp.getSubject().trim().isEmpty())
                            ? temp.getSubject() : defaults[0];
                    String bodyContent = (temp != null && temp.getBodyContent() != null && !temp.getBodyContent().trim().isEmpty())
                            ? temp.getBodyContent() : defaults[1];

                    if (job.getPlaceholders() != null) {
                        for (java.util.Map.Entry<String, String> entry : job.getPlaceholders().entrySet()) {
                            String key = entry.getKey();
                            String val = entry.getValue() != null ? entry.getValue() : "";
                            bodyContent = bodyContent.replace("{{" + key + "}}", val);
                            bodyContent = bodyContent.replace("{" + key + "}", val);
                            subject = subject.replace("{{" + key + "}}", val);
                            subject = subject.replace("{" + key + "}", val);
                        }
                    }
                    if (job.getRecipientName() != null && !job.getRecipientName().trim().isEmpty()) {
                        String rName = job.getRecipientName().trim();
                        bodyContent = bodyContent.replace("{{userName}}", rName);
                        bodyContent = bodyContent.replace("{userName}", rName);
                        subject = subject.replace("{{userName}}", rName);
                        subject = subject.replace("{userName}", rName);
                    }

                    sendEmail(job.getRecipientEmail(), subject, bodyContent);
                }
                LOGGER.log(Level.INFO, "[EMAIL] Đã gửi email bất đồng bộ thành công cho: {0}", toEmail);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "[EMAIL] Gửi email bất đồng bộ thất bại cho: " + toEmail, e);
            }
        });
    }

    /**
     * Mẫu HTML và Tiêu đề mặc định dự phòng khi CSDL chưa seed hoặc rỗng.
     */
    private static String[] getDefaultTemplate(String tempName) {
        if ("OVERDUE_NOTICE".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Thông báo sách quá hạn mượn - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><h2 style=\"color:#dc2626;margin-top:0;\">⚠️ Thông báo sách quá hạn</h2><p>Xin chào <strong>{{userName}}</strong>,</p><p>Hệ thống ghi nhận cuốn sách bạn mượn đã quá hạn trả:</p><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0;font-size:16px;font-weight:bold;color:#991b1b;\">📖 {{bookTitle}}</p><p style=\"margin:8px 0 0 0;font-size:14px;color:#7f1d1d;\">Hạn trả: <strong>{{dueDate}}</strong> (Trễ <strong>{{overdueDays}}</strong> ngày)</p></div><p>💰 <strong>Mức phạt:</strong> {{finePerDay}} VNĐ/ngày → Tổng phạt: <strong style=\"color:#dc2626;\">{{totalFine}} VNĐ</strong></p><p>Tài khoản của bạn đã bị khóa tạm thời. Vui lòng hoàn trả sách và thanh toán nợ phạt.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("RESERVATION_READY".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Sách đặt trước đã sẵn sàng nhận - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><h2 style=\"color:#16a34a;margin-top:0;\">📚 Sách của bạn đã sẵn sàng!</h2><p>Xin chào <strong>{{userName}}</strong>,</p><p>Cuốn sách bạn đặt trước đã có sẵn tại quầy:</p><div style=\"background:#f0fff4;border:1px solid #bbf7d0;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0;font-size:16px;font-weight:bold;color:#166534;\">📖 {{bookTitle}}</p></div><p>⏰ <strong>Hạn chót nhận sách:</strong> <span style=\"color:#dc2626;font-weight:bold;\">{{pickupDeadline}}</span></p><p>Vui lòng đến quầy thủ thư để nhận sách trước thời hạn trên.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("RESET_PASSWORD".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Khôi phục mật khẩu tài khoản",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><h2 style=\"color:#1a4fa3;margin-top:0;\">🔐 Khôi phục mật khẩu</h2><p>Xin chào <strong>{{userName}}</strong>,</p><p>Mật khẩu tạm thời của bạn là:</p><div style=\"background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 24px;font-size:24px;letter-spacing:4px;font-weight:bold;color:#1a4fa3;text-align:center;\">{{tempPassword}}</div><p style=\"margin-top:20px;\">Vui lòng đăng nhập và đổi mật khẩu ngay để bảo vệ tài khoản.</p></div></body></html>"
            };
        }
        if ("PAYMENT_CONFIRMATION".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Xác nhận thanh toán tiền phạt #{{paymentId}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><h2 style=\"color:#16a34a;margin-top:0;\">✅ Thanh toán tiền phạt thành công</h2><p>Xin chào <strong>{{userName}}</strong>,</p><p>Xác nhận đã nhận thanh toán tiền phạt của bạn:</p><ul><li>Mã phiếu: <strong>#{{paymentId}}</strong></li><li>Số tiền: <strong style=\"color:#16a34a;\">{{amount}} VNĐ</strong></li><li>Phương thức: {{paymentMethod}}</li><li>Thời gian: {{paidAt}}</li></ul></div></body></html>"
            };
        }
        if ("RECALL_NOTICE".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Yêu cầu thu hồi sách mượn - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#c2410c;margin:0;\">📢 Yêu cầu thu hồi sách mượn</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Thư viện xin thông báo yêu cầu <strong>thu hồi lại cuốn sách</strong> bạn đang mượn với lý do sau:</p><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0;font-size:14px;color:#dc2626;font-weight:bold;\">💬 Lý do thu hồi: {{recallReason}}</p></div><div style=\"background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0 0 6px;font-size:16px;font-weight:bold;color:#1a4fa3;\">📖 Tên sách: {{bookTitle}}</p><p style=\"margin:0;font-size:13px;color:#475569;\">🏷️ Mã vạch bản sao: <strong>{{barcode}}</strong></p></div><p>Vui lòng mang cuốn sách này đến <strong>Quầy Lưu thông Thư viện</strong> để trả sách trong thời gian sớm nhất.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("RESERVATION_EXPIRED".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Thông báo hết hạn đơn đặt trước sách - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#dc2626;margin:0;\">⏰ Thông báo hết hạn giữ sách đặt trước</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Đơn đặt trước cuốn sách <strong>{{bookTitle}}</strong> của bạn đã hết thời hạn giữ sách tại quầy.</p><p>Hệ thống đã chuyển lượt mượn cuốn sách này cho độc giả tiếp theo trong hàng chờ.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("RESERVATION_CANCELLED".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Thông báo hủy lượt đặt trước sách",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#dc2626;margin:0;\">🚫 Thông báo hủy lượt đặt trước sách</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Thư viện xin thông báo lượt đặt trước cuốn sách <strong>{{bookTitle}}</strong> của bạn đã bị hủy bởi Thủ thư.</p><div style=\"background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0;font-size:14px;color:#c2410c;font-weight:bold;\">💬 Lý do hủy: {{cancelReason}}</p></div><p>Nếu có thắc mắc, vui lòng liên hệ với quầy thủ thư để được trợ giúp.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p></div></body></html>"
            };
        }
        if ("RESERVATION_DELAYED".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Lượt nhận sách được chuyển lại hàng chờ - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;\"><h2 style=\"color:#c2410c;margin-top:0;\">Thông báo thay đổi lượt nhận sách</h2><p>Xin chào <strong>{{userName}}</strong>,</p><p>Một bản sao vật lý của cuốn <strong>{{bookTitle}}</strong> vừa được ghi nhận hỏng hoặc mất.</p><p>Để bảo đảm dữ liệu tồn kho chính xác, lượt của bạn đã được chuyển về vị trí đầu hàng chờ. Hệ thống sẽ thông báo ngay khi sách có thể nhận lại.</p><p>Thư viện xin lỗi vì sự bất tiện này.</p></div></body></html>"
            };
        }
        if ("CHECKOUT_CONFIRMATION".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Xác nhận mượn sách thành công - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#f0fff4;border:1px solid #bbf7d0;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#166534;margin:0;\">📚 Mượn sách thành công!</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Xác nhận bạn đã làm thủ tục mượn sách thành công tại quầy thư viện:</p><div style=\"background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0 0 8px;font-size:16px;font-weight:bold;color:#1a4fa3;\">📖 {{bookTitle}}</p><p style=\"margin:0;color:#1a4fa3;\">⏰ Hạn trả sách: <strong style=\"color:#dc2626;\">{{endDate}}</strong></p></div><p>Vui lòng bảo quản sách và hoàn trả đúng thời hạn để tránh phát sinh phạt trễ hạn.</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("RENEWAL_CONFIRMATION".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Xác nhận gia hạn sách thành công - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#f0fff4;border:1px solid #bbf7d0;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#166534;margin:0;\">🔄 Gia hạn sách thành công!</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Lượt gia hạn cuốn sách của bạn đã được ghi nhận thành công:</p><div style=\"background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0 0 8px;font-size:16px;font-weight:bold;color:#1a4fa3;\">📖 {{bookTitle}}</p><p style=\"margin:0 0 6px;color:#1a4fa3;\">⏰ Hạn trả mới: <strong style=\"color:#166534;\">{{newDueDate}}</strong></p><p style=\"margin:0;font-size:13px;color:#475569;\">Số lần gia hạn: {{extensionCount}}/{{maxExtension}}</p></div><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        if ("INCIDENT_FINE_NOTICE".equalsIgnoreCase(tempName)) {
            return new String[]{
                "[Thư viện LMS] Thông báo phạt sự cố sách - {{bookTitle}}",
                "<!DOCTYPE html><html lang=\"vi\"><head><meta charset=\"UTF-8\"></head><body style=\"font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;\"><div style=\"max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);\"><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;\"><h2 style=\"color:#dc2626;margin:0;\">⚠️ Thông báo phạt sự cố sách</h2></div><p>Xin chào <strong>{{userName}}</strong>,</p><p>Thư viện ghi nhận thông tin sự cố khi trả sách như sau:</p><div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;\"><p style=\"margin:0 0 6px;font-size:16px;font-weight:bold;color:#991b1b;\">📖 {{bookTitle}}</p><p style=\"margin:0 0 6px;font-size:14px;color:#991b1b;\">Sự cố: <strong>{{incidentType}}</strong></p><p style=\"margin:0;font-size:14px;color:#dc2626;font-weight:bold;\">💰 Tiền phạt đền bù: {{fineAmount}}</p></div><p>Vui lòng hoàn tất thanh toán khoản phạt tại quầy hoặc qua ví điện tử. Cảm ơn bạn!</p><hr style=\"border:none;border-top:1px solid #eee;margin:24px 0;\"/><p style=\"font-size:12px;color:#888;\">Thư viện Đại học LMS.</p></div></body></html>"
            };
        }
        return new String[]{"[Thư viện LMS] Thông báo từ hệ thống", "<p>Xin chào <strong>{{userName}}</strong>,</p><p>Bạn có thông báo mới từ hệ thống thư viện LMS.</p>"};
    }

    // =========================================================================
    // Public API cũ: Giữ nguyên tên hàm để tương thích luồng Active (nhưng định tuyến qua Queue)
    // =========================================================================

    /**
     * Gửi bất đồng bộ email chứa mật khẩu tạm thời tới người dùng (Passive Flow).
     * Định tuyến qua hàng đợi.
     *
     * @param toEmail     Địa chỉ email nhận
     * @param tempPassword Mật khẩu tạm thời (plaintext) - KHÔNG log ra console
     */
    public static void sendAsyncPasswordReset(String toEmail, String tempPassword) {
        // Luồng Passive phục hồi mật khẩu có template là RESET_PASSWORD
        // Ở bước tích hợp sẽ sửa trực tiếp caller, nhưng ta vẫn giữ hàm này để tránh biên dịch lỗi
        java.util.Map<String, String> placeholders = new java.util.HashMap<>();
        placeholders.put("tempPassword", tempPassword);
        
        EmailJob job = new EmailJob("RESET_PASSWORD", toEmail, "", placeholders);
        enqueue(job);
    }

    /**
     * Gửi bất đồng bộ một Email HTML đã được render sẵn (Dùng cho thông báo khẩn Active Flow).
     * Định tuyến qua hàng đợi bằng constructor Direct HTML.
     *
     * @param toEmail       Địa chỉ email người nhận
     * @param subject       Tiêu đề Email
     * @param finalHtmlBody Nội dung HTML hoàn chỉnh
     */
    public static void sendAsyncHtmlEmail(String toEmail, String subject, String finalHtmlBody) {
        EmailJob job = new EmailJob(toEmail, subject, finalHtmlBody);
        enqueue(job);
    }

    // =========================================================================
    // SMTP Sending Logic: Thực hiện kết nối và truyền thư SMTP qua JavaMail
    // =========================================================================

    /**
     * Gửi thư trực tiếp qua giao thức SMTP (Đồng bộ, chỉ gọi bởi EmailWorker).
     */
    public static void sendEmail(String toEmail, String subject, String htmlBody)
            throws MessagingException, UnsupportedEncodingException {
        Session session = buildMailSession();

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(AppConfig.SMTP_USERNAME, AppConfig.SMTP_SENDER_NAME, "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject, "UTF-8");
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static Session buildMailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", AppConfig.SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(AppConfig.SMTP_PORT));
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(AppConfig.SMTP_USERNAME, AppConfig.SMTP_PASSWORD);
            }
        });
    }

    /**
     * Gửi email xác nhận thanh toán nợ phạt thành công (Passive flow).
     *
     * @param paymentId     ID phiếu thanh toán
     * @param userId        ID người dùng thực hiện thanh toán
     * @param paymentMethod Phương thức thanh toán ("Cash" hoặc "BankTransfer")
     */
    public static void sendPaymentConfirmationEmail(int paymentId, int userId, String paymentMethod) {
        try (java.sql.Connection conn = util.DatabaseConnection.getConnection()) {
            dao.UserDAO userDAO = new dao.UserDAO();
            model.User user = userDAO.findByUserId(userId);
            if (user == null || user.getEmail() == null) return;
            
            dao.MemberProfileDAO profileDAO = new dao.MemberProfileDAO();
            model.MemberProfile profile = profileDAO.findByUserId(userId);
            String fullName = (profile != null) ? profile.getFullName() : user.getEmail();
            
            double amount = 0;
            String paidAtStr = "";
            String sql = "SELECT paidAmount, paidAt FROM Payment WHERE paymentId = ?";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, paymentId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        amount = rs.getDouble("paidAmount");
                        java.sql.Timestamp paidAt = rs.getTimestamp("paidAt");
                        if (paidAt != null) {
                            paidAtStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(paidAt);
                        } else {
                            paidAtStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date());
                        }
                    }
                }
            }
            
            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("paymentId", String.valueOf(paymentId));
            placeholders.put("amount", String.format("%,.0f", amount));
            placeholders.put("paymentMethod", "Cash".equalsIgnoreCase(paymentMethod) ? "Tiền mặt" : "Chuyển khoản (SePay)");
            placeholders.put("paidAt", paidAtStr);
            
            EmailJob job = new EmailJob("PAYMENT_CONFIRMATION", user.getEmail(), fullName, placeholders);
            enqueue(job);
            
            LOGGER.log(Level.INFO, "[EMAIL] Đã enqueue email PAYMENT_CONFIRMATION thành công cho paymentId={0}", paymentId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kích hoạt gửi email xác nhận thanh toán cho paymentId=" + paymentId, e);
        }
    }

    /**
     * Gửi email thông báo hủy lượt đặt trước tới độc giả kèm lý do do Thủ thư nhập.
     *
     * @param toEmail      Email nhận
     * @param userName     Tên độc giả
     * @param bookTitle    Tên sách đã đặt
     * @param cancelReason Lý do hủy
     */
    public static void sendReservationCancelledEmail(String toEmail, String userName, String bookTitle, String cancelReason) {
        java.util.Map<String, String> placeholders = new java.util.HashMap<>();
        placeholders.put("userName", userName != null ? userName : "Độc giả");
        placeholders.put("bookTitle", bookTitle != null ? bookTitle : "Sách đã đặt");
        placeholders.put("cancelReason", cancelReason != null && !cancelReason.isBlank() ? cancelReason : "Thủ thư hủy lượt đặt trước theo quy định.");

        EmailJob job = new EmailJob("RESERVATION_CANCELLED", toEmail, userName, placeholders);
        enqueue(job);
        LOGGER.log(Level.INFO, "[EMAIL] Đã enqueue email RESERVATION_CANCELLED thành công cho {0}", toEmail);
    }

    public static void sendReservationDelayedEmail(String toEmail, String userName, String bookTitle) {
        java.util.Map<String, String> placeholders = new java.util.HashMap<>();
        placeholders.put("userName", userName != null ? userName : "Độc giả");
        placeholders.put("bookTitle", bookTitle != null ? bookTitle : "Sách đã đặt");
        enqueue(new EmailJob("RESERVATION_DELAYED", toEmail, userName, placeholders));
        LOGGER.log(Level.INFO, "[EMAIL] Đã enqueue email RESERVATION_DELAYED cho {0}", toEmail);
    }
}
