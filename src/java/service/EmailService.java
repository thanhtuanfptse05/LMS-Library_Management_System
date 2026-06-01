package service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailService — Dịch vụ quản lý và gửi email bất đồng bộ (Asynchronous).
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>Không được chặn luồng xử lý HTTP (Non-blocking) nhờ sử dụng {@link ExecutorService}.</li>
 *   <li>NFR-01: Không bao giờ in hoặc lưu log mật khẩu dạng plaintext của người dùng.</li>
 * </ul>
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    
    // Khởi tạo thread pool cố định gồm 2 worker thread để chạy ngầm tác vụ I/O gửi mail
    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(2);

    /**
     * Gửi email phục hồi mật khẩu ngầm (Bất đồng bộ).
     *
     * @param toEmail     Địa chỉ email nhận
     * @param newPassword Mật khẩu tạm thời mới (plaintext)
     */
    public static void sendAsyncPasswordReset(String toEmail, String newPassword) {
        EXECUTOR.submit(() -> {
            try {
                LOGGER.log(Level.INFO, "[ASYNC MAIL] Bắt đầu gửi email phục hồi mật khẩu tới: {0}", toEmail);
                
                // Giả lập độ trễ mạng khi kết nối cổng SMTP / SendGrid API (2 giây)
                Thread.sleep(2000);
                
                // NFR-01: Tuyệt đối KHÔNG ghi log chuỗi newPassword ra màn hình console hay file log
                LOGGER.log(Level.INFO, "[ASYNC MAIL] Đã gửi thành công email phục hồi mật khẩu tạm thời tới: {0}", toEmail);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                LOGGER.log(Level.SEVERE, "[ASYNC MAIL] Luồng gửi email bị ngắt quãng", e);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[ASYNC MAIL] Lỗi khi gửi email phục hồi mật khẩu", e);
            }
        });
    }
}
