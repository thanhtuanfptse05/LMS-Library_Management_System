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
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailService — Dịch vụ gửi email bất đồng bộ qua Gmail SMTP.
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>Non-blocking: Mọi tác vụ gửi mail chạy ngầm qua {@link ExecutorService}.</li>
 *   <li>NFR-01: Tuyệt đối không in/log mật khẩu plaintext ra console hay file.</li>
 *   <li>Dùng {@link AppConfig} làm nguồn cấu hình duy nhất (Single Source of Truth).</li>
 * </ul>
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    /** Thread pool cố định 2 worker chạy ngầm các tác vụ I/O gửi mail */
    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(2);

    // =========================================================================
    // Private helper: Tạo Jakarta Mail Session kết nối tới Gmail SMTP
    // =========================================================================

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

    // =========================================================================
    // Private helper: Gửi email (dùng nội bộ, đồng bộ, gọi từ trong EXECUTOR)
    // =========================================================================

    private static void sendEmail(String toEmail, String subject, String htmlBody)
            throws MessagingException, UnsupportedEncodingException {
        Session session = buildMailSession();

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(AppConfig.SMTP_USERNAME, AppConfig.SMTP_SENDER_NAME, "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject, "UTF-8");
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    // =========================================================================
    // Public API: Gửi email phục hồi mật khẩu (Bất đồng bộ)
    // =========================================================================

    /**
     * Gửi bất đồng bộ email chứa mật khẩu tạm thời tới người dùng.
     *
     * @param toEmail     Địa chỉ email nhận
     * @param tempPassword Mật khẩu tạm thời (plaintext) - KHÔNG log ra console
     */
    public static void sendAsyncPasswordReset(String toEmail, String tempPassword) {
        if (toEmail == null || toEmail.trim().isEmpty() || toEmail.trim().endsWith("@lms.com")) {
            LOGGER.log(Level.INFO, "[ASYNC MAIL] Bỏ qua gửi email khôi phục mật khẩu tới địa chỉ rỗng hoặc địa chỉ ảo: {0}", toEmail);
            return;
        }
        EXECUTOR.submit(() -> {
            try {
                LOGGER.log(Level.INFO, "[ASYNC MAIL] Đang gửi email khôi phục mật khẩu tới: {0}", toEmail);

                String subject = "Khôi phục mật khẩu — LMS University Library";
                String htmlBody = buildPasswordResetEmailBody(tempPassword);

                sendEmail(toEmail, subject, htmlBody);

                LOGGER.log(Level.INFO, "[ASYNC MAIL] Gửi email khôi phục mật khẩu thành công tới: {0}", toEmail);
            } catch (MessagingException | UnsupportedEncodingException e) {
                LOGGER.log(Level.SEVERE, "[ASYNC MAIL] Lỗi khi gửi email khôi phục mật khẩu tới: " + toEmail, e);
            }
        });
    }

    // =========================================================================
    // Public API: Gửi Email HTML tùy ý (Bất đồng bộ) — dùng cho Thông báo Khẩn
    // =========================================================================

    /**
     * Gửi bất đồng bộ một Email HTML đã được render sẵn.
     * Dùng để gửi Thông báo Khẩn cấp (urgent notification) tới Student/Lecturer.
     *
     * <p>Nội dung {@code finalHtmlBody} phải là HTML hoàn chỉnh (các placeholder
     * {{...}} đã được replace tại Controller trước khi gọi hàm này).</p>
     *
     * @param toEmail       Địa chỉ email người nhận
     * @param subject       Tiêu đề Email
     * @param finalHtmlBody Nội dung HTML hoàn chỉnh, sẵn sàng để gửi
     */
    public static void sendAsyncHtmlEmail(String toEmail, String subject, String finalHtmlBody) {
        if (toEmail == null || toEmail.trim().isEmpty() || toEmail.trim().endsWith("@lms.com")) {
            LOGGER.log(Level.WARNING, "[ASYNC MAIL] Bỏ qua gửi email tới địa chỉ rỗng hoặc địa chỉ ảo: {0}", toEmail);
            return;
        }
        EXECUTOR.submit(() -> {
            try {
                LOGGER.log(Level.INFO, "[ASYNC MAIL] Đang gửi email HTML tới: {0}", toEmail);
                sendEmail(toEmail, subject, finalHtmlBody);
                LOGGER.log(Level.INFO, "[ASYNC MAIL] Gửi email HTML thành công tới: {0}", toEmail);
            } catch (MessagingException | UnsupportedEncodingException e) {
                LOGGER.log(Level.SEVERE, "[ASYNC MAIL] Lỗi khi gửi email HTML tới: " + toEmail, e);
            }
        });
    }

    // =========================================================================
    // Private helper: Tạo nội dung HTML cho email khôi phục mật khẩu
    // =========================================================================

    private static String buildPasswordResetEmailBody(String tempPassword) {
        return "<!DOCTYPE html>"
                + "<html lang='vi'><head><meta charset='UTF-8'></head><body "
                + "style='font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;'>"
                + "<div style='max-width:520px;margin:auto;background:#fff;border-radius:10px;"
                + "padding:32px;box-shadow:0 2px 12px rgba(0,0,0,0.08);'>"
                + "<h2 style='color:#1a4fa3;margin-top:0;'>🔐 Khôi phục mật khẩu</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Hệ thống <strong>LMS University Library</strong> đã nhận được yêu cầu"
                + " khôi phục mật khẩu cho tài khoản của bạn.</p>"
                + "<p>Mật khẩu tạm thời của bạn là:</p>"
                + "<div style='background:#f0f4ff;border:1px solid #c7d6f7;border-radius:6px;"
                + "padding:14px 20px;font-size:22px;letter-spacing:3px;font-weight:bold;"
                + "color:#1a4fa3;text-align:center;'>"
                + tempPassword
                + "</div>"
                + "<p style='margin-top:20px;'>Vui lòng <strong>đăng nhập ngay</strong> bằng"
                + " mật khẩu tạm thời này và đổi sang mật khẩu mới để bảo vệ tài khoản.</p>"
                + "<hr style='border:none;border-top:1px solid #eee;margin:24px 0;'/>"
                + "<p style='font-size:12px;color:#888;'>Nếu bạn không yêu cầu khôi phục"
                + " mật khẩu, hãy bỏ qua email này. Mật khẩu cũ của bạn vẫn sẽ không thay đổi"
                + " nếu bạn không sử dụng mật khẩu tạm thời này để đăng nhập.</p>"
                + "</div></body></html>";
    }
}
