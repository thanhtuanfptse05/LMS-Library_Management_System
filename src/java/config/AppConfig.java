package config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

/**
 * AppConfig — Trung tâm cấu hình toàn cục cho ứng dụng LMS.
 *
 * <p>Lưu trữ các hằng số cấu hình cho SMTP (Gmail), v.v.</p>
 *
 * <p><strong>BẢO MẬT:</strong> File này KHÔNG được commit lên public repository.
 * Đã được thêm vào .gitignore. Thay thế bằng biến môi trường khi deploy production.</p>
 */
public final class AppConfig {

    private static final Properties LOCAL_PROPERTIES = loadLocalProperties();

    private AppConfig() {
        // Utility class - không cho phép khởi tạo
    }

    // =========================================================================
    // SMTP / Gmail Configuration
    // =========================================================================

    /** Địa chỉ Gmail dùng để gửi email hệ thống */
    public static final String SMTP_USERNAME = "ngochuyen2k2lx@gmail.com";

    /**
     * Gmail App Password (Mật khẩu ứng dụng) của ngochuyen2k2lx@gmail.com.
     * Được tạo tại: Google Account > Security > App Passwords
     */
    public static final String SMTP_PASSWORD = "gvwonzsvublgxtht";

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

    public static final String SUPABASE_URL = readConfig("SUPABASE_URL");
    public static final String SUPABASE_SERVICE_ROLE_KEY = readConfig("SUPABASE_SERVICE_ROLE_KEY");
    public static final String SUPABASE_BOOK_COVER_BUCKET = readConfig("SUPABASE_BOOK_COVER_BUCKET", "book-covers");

    private static String readConfig(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        if (value == null || value.trim().isEmpty()) {
            value = LOCAL_PROPERTIES.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private static String readConfig(String key, String defaultValue) {
        String value = readConfig(key);
        return value == null ? defaultValue : value;
    }

    private static Properties loadLocalProperties() {
        Properties properties = new Properties();
        Path configFile = Path.of(System.getProperty("user.home"), ".lms", "app.properties");
        if (!Files.isRegularFile(configFile)) {
            return properties;
        }
        try (InputStream input = Files.newInputStream(configFile)) {
            properties.load(input);
        } catch (IOException ignored) {
            // Nếu file cấu hình local lỗi, ứng dụng vẫn dùng env/system properties.
        }
        return properties;
    }
}
