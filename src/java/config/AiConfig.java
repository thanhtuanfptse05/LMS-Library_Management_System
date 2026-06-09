package config;

/**
 * AiConfig — Chứa các cấu hình cần thiết để kết nối và giao tiếp với các dịch vụ AI.
 * 
 * Lưu ý: Tương lai có thể di chuyển cấu hình này vào bảng SystemConfigurations trong Database
 * để hỗ trợ Admin thay đổi API Key mà không cần deploy lại code.
 */
public class AiConfig {
    
    private AiConfig() {
        // Utility class
    }

    /**
     * Mã API Key của Google Gemini.
     * CẦN ĐIỀN API KEY THẬT VÀO ĐÂY TRƯỚC KHI CHẠY.
     */
    public static final String GEMINI_API_KEY = "DUMMY_GEMINI_API_KEY_PLEASE_REPLACE";

    /**
     * Endpoint URL của mô hình Gemini 1.5 Flash (Thường dùng cho tốc độ cao và giá rẻ).
     */
    public static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

}
