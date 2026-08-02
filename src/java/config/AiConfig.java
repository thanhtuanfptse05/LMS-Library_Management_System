package config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * AiConfig — Chứa các cấu hình cần thiết để kết nối và giao tiếp với các dịch
 * vụ AI.
 *
 * BẢO MẬT: API Key được đọc từ System Property hoặc Environment Variable làm dự phòng,
 * hoặc đọc từ Database.
 *
 * File này PHẢI nằm trong .gitignore để tránh lộ cấu hình.
 */
public class AiConfig {

    private static final Logger LOGGER = Logger.getLogger(AiConfig.class.getName());

    private AiConfig() {
        // Utility class
    }

    /**
     * Kiểm tra API Key có hợp lệ hay không.
     * Key bị coi là không hợp lệ nếu:
     * - Null hoặc trống
     * - Bằng chuỗi sentinel "MISSING_API_KEY"
     * - Bắt đầu bằng "YOUR_" (placeholder chưa được thay thế)
     */
    public static boolean isValidApiKey(String key) {
        if (key == null || key.trim().isEmpty()) {
            return false;
        }
        String trimmed = key.trim();
        if (trimmed.equals("MISSING_API_KEY")) {
            return false;
        }
        if (trimmed.startsWith("YOUR_")) {
            return false;
        }
        return true;
    }

    /**
     * Lấy Mã API Key của Google Gemini.
     *
     * Ưu tiên 1: Lấy từ bảng SystemConfigurations trong DB.
     * Ưu tiên 2 (Fallback): Lấy từ System Property / Env Var.
     */
    public static String getGeminiApiKey() {
        return loadApiKey();
    }

    /**
     * Lấy Mã API Key riêng cho AI Chatbot (F14).
     *
     * Ưu tiên 1: Lấy từ bảng SystemConfigurations trong DB.
     * Ưu tiên 2 (Fallback): Lấy từ System Property / Env Var.
     */
    public static String getGeminiChatbotApiKey() {
        return loadChatbotApiKey();
    }

    /**
     * Tải API Key: thử DB trước, nếu không có hoặc là placeholder thì fallback sang JVM/Env.
     */
    private static String loadApiKey() {
        String key = getApiKeyFromDb();
        if (isValidApiKey(key)) {
            return key.trim();
        }
        LOGGER.log(Level.WARNING, "[AiConfig] GEMINI_RECOMMEN_API_KEY trong DB không hợp lệ hoặc là placeholder (''{0}''). Thử đọc từ JVM/Env.", key);
        return resolveApiKey();
    }

    /**
     * Tải API Key riêng cho Chatbot: thử DB trước, nếu không có hoặc là placeholder thì fallback sang JVM/Env.
     */
    private static String loadChatbotApiKey() {
        String key = getChatbotApiKeyFromDb();
        if (isValidApiKey(key)) {
            return key.trim();
        }
        LOGGER.log(Level.WARNING, "[AiConfig] GEMINI_CHATBOT_API_KEY trong DB không hợp lệ hoặc là placeholder (''{0}''). Thử đọc từ JVM/Env.", key);
        return resolveChatbotApiKey();
    }

    /**
     * Endpoint URL dùng alias "gemini-flash-latest" — luôn trỏ tới phiên bản Flash mới nhất.
     * Hiện tại: Gemini 3 Flash (tính đến 2026-07).
     */
    public static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=";

    /**
     * Giải quyết API Key từ nhiều nguồn cấu hình theo thứ tự ưu tiên.
     */
    public static String resolveApiKey() {
        // Ưu tiên 1: System Property (JVM argument -DGEMINI_RECOMMEN_API_KEY=xxx or -DGEMINI_API_KEY=xxx)
        String key = System.getProperty("GEMINI_RECOMMEN_API_KEY");
        if (key == null || key.trim().isEmpty()) {
            key = System.getProperty("GEMINI_API_KEY");
        }
        if (key != null && !key.trim().isEmpty()) {
            return key.trim();
        }

        // Ưu tiên 2: Environment Variable
        key = System.getenv("GEMINI_RECOMMEN_API_KEY");
        if (key == null || key.trim().isEmpty()) {
            key = System.getenv("GEMINI_API_KEY");
        }
        if (key != null && !key.trim().isEmpty()) {
            return key.trim();
        }

        // Fallback: Trả về giá trị mặc định (sẽ fail gracefully khi gọi API)
        return "MISSING_API_KEY";
    }

    /**
     * Giải quyết API Key cho Chatbot từ nhiều nguồn cấu hình.
     */
    public static String resolveChatbotApiKey() {
        // Ưu tiên 1: System Property
        String key = System.getProperty("GEMINI_CHATBOT_API_KEY");
        if (key != null && !key.trim().isEmpty()) {
            return key.trim();
        }

        // Ưu tiên 2: Environment Variable
        key = System.getenv("GEMINI_CHATBOT_API_KEY");
        if (key != null && !key.trim().isEmpty()) {
            return key.trim();
        }

        // Fallback: Trả về giá trị mặc định
        return "MISSING_API_KEY";
    }

    /**
     * Lấy API Key từ bảng SystemConfigurations trong cơ sở dữ liệu.
     * Dùng cho môi trường Production/Staging khi cấu hình được lưu trong DB.
     */
    public static String getApiKeyFromDb() {
        String sql = "SELECT configValue FROM SystemConfigurations WHERE configKey = 'GEMINI_RECOMMEN_API_KEY'";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String val = rs.getString("configValue");
                if (val != null && !val.trim().isEmpty()) {
                    return val.trim();
                }
            }
        } catch (Exception e) {
            // Không làm sập ứng dụng khi DB chưa sẵn sàng
        }
        return "MISSING_API_KEY";
    }

    /**
     * Lấy API Key Chatbot từ bảng SystemConfigurations trong cơ sở dữ liệu.
     */
    public static String getChatbotApiKeyFromDb() {
        String sql = "SELECT configValue FROM SystemConfigurations WHERE configKey = 'GEMINI_CHATBOT_API_KEY'";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String val = rs.getString("configValue");
                if (val != null && !val.trim().isEmpty()) {
                    return val.trim();
                }
            }
        } catch (Exception e) {
            // Không làm sập ứng dụng
        }
        return "MISSING_API_KEY";
    }
}
