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

    /** Hàng đợi lưu trữ các EmailJob cần gửi ngầm (Sức chứa mặc định: 500) */
    private static final LinkedBlockingQueue<EmailJob> EMAIL_QUEUE = new LinkedBlockingQueue<>(500);

    // =========================================================================
    // Public API: Gửi email bất đồng bộ bằng cách đẩy vào hàng đợi
    // =========================================================================

    /**
     * Đẩy một EmailJob vào hàng đợi gửi thư.
     * Hàm này chạy cực nhanh (< 10ms) và không chặn luồng xử lý HTTP chính.
     *
     * @param job Công việc gửi mail cần thực hiện
     */
    public static void enqueue(EmailJob job) {
        if (job == null) {
            return;
        }
        
        // Tránh gửi tới địa chỉ ảo hoặc rỗng
        String toEmail = job.getRecipientEmail();
        if (toEmail == null || toEmail.trim().isEmpty() || toEmail.trim().endsWith("@lms.com")) {
            LOGGER.log(Level.INFO, "[EMAIL QUEUE] Bỏ qua đẩy vào hàng đợi do địa chỉ nhận rỗng hoặc địa chỉ ảo: {0}", toEmail);
            return;
        }

        boolean offered = EMAIL_QUEUE.offer(job);
        if (!offered) {
            LOGGER.log(Level.WARNING, "[EMAIL QUEUE] Hàng đợi email đã ĐẦY ({0} jobs). Loại bỏ (drop) job gửi tới: {1}",
                    new Object[]{EMAIL_QUEUE.size(), toEmail});
        }
    }

    /**
     * Lấy một EmailJob ra khỏi hàng đợi (Chặn luồng nếu hàng đợi rỗng).
     * Chỉ dùng cho EmailWorker chạy nền.
     *
     * @return EmailJob tiếp theo cần xử lý
     * @throws InterruptedException nếu luồng bị ngắt khi đang đợi lấy job
     */
    public static EmailJob take() throws InterruptedException {
        return EMAIL_QUEUE.take();
    }

    /**
     * Lấy kích thước hiện tại của hàng đợi (phục vụ giám sát).
     *
     * @return số lượng email đang chờ trong queue
     */
    public static int getQueueSize() {
        return EMAIL_QUEUE.size();
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
}
