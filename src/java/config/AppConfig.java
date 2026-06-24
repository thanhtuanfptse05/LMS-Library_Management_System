package config;

/**
 * AppConfig — Trung tâm cấu hình toàn cục cho ứng dụng LMS.
 *
 * <p>Lưu trữ các hằng số cấu hình cho SMTP (Gmail), v.v.</p>
 *
 * <p><strong>BẢO MẬT:</strong> File này KHÔNG được commit lên public repository.
 * Đã được thêm vào .gitignore. Thay thế bằng biến môi trường khi deploy production.</p>
 */
public final class AppConfig {

    private AppConfig() {
        // Utility class - không cho phép khởi tạo
    }

    // =========================================================================
    // SMTP / Gmail Configuration
    // =========================================================================

    /**
     * Địa chỉ Gmail dùng để gửi email hệ thống.
     * Production: đọc từ env var SMTP_USERNAME (cấu hình trên Render).
     * Local dev: fallback về giá trị hardcode.
     */
    public static final String SMTP_USERNAME = readConfig("SMTP_USERNAME", "caotuan2k50112@gmail.com");

    /**
     * Gmail App Password (Mật khẩu ứng dụng).
     * Production: đọc từ env var SMTP_PASSWORD (cấu hình trên Render).
     * Local dev: fallback về giá trị hardcode.
     * Tạo tại: Google Account > Security > App Passwords
     */
    public static final String SMTP_PASSWORD = readConfig("SMTP_PASSWORD", "dxsmtjqarnioued");

    /** SMTP Host - Gmail */
    public static final String SMTP_HOST = "smtp.gmail.com";

    /** SMTP Port - TLS */
    public static final int SMTP_PORT = 587;

    /** Tên hiển thị trên email người gửi */
    public static final String SMTP_SENDER_NAME = "LMS University Library";

    /**
     * Thư mục lưu ảnh bìa đầu sách bên ngoài WAR để ảnh không mất khi triển khai lại.
     * Có thể cấu hình bằng biến môi trường LMS_BOOK_IMAGE_DIR.
     */
    public static final String BOOK_IMAGE_DIRECTORY = readConfig("LMS_BOOK_IMAGE_DIR",
            System.getProperty("user.home") + "/.lms/book-images");

    public static String getSupabaseUrl() {
        return readConfig("SUPABASE_URL");
    }

    public static String getSupabaseServiceRoleKey() {
        return readConfig("SUPABASE_SERVICE_ROLE_KEY");
    }

    public static String getSupabaseBookCoverBucket() {
        return readConfig("SUPABASE_BOOK_COVER_BUCKET", "book-covers");
    }

    /**
     * Đọc cấu hình runtime từ biến môi trường trước, sau đó tới VM Options -D.
     * Không đọc file local để tránh lệ thuộc cấu hình ẩn theo từng máy.
     */
    private static String readConfig(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private static String readConfig(String key, String defaultValue) {
        String value = readConfig(key);
        return value == null ? defaultValue : value;
    }
}
