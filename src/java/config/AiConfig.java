package config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    private AiConfig() {
        // Utility class
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
     * Tải API Key: thử DB trước, nếu không có thì fallback sang JVM/Env.
     */
    private static String loadApiKey() {
        String key = getApiKeyFromDb();
        if (key != null && !key.equals("MISSING_API_KEY")) {
            return key;
        }
        return resolveApiKey();
    }

    /**
     * Tải API Key riêng cho Chatbot.
     */
    private static String loadChatbotApiKey() {
        String key = getChatbotApiKeyFromDb();
        if (key != null && !key.equals("MISSING_API_KEY")) {
            return key;
        }
        return resolveChatbotApiKey();
    }

    /**
     * Endpoint URL của mô hình Gemini 3.5 Flash (Mô hình tiêu chuẩn hiện tại năm 2026).
     */
    public static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=";

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
