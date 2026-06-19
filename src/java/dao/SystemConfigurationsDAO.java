package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * SystemConfigurationsDAO — Lớp truy xuất dữ liệu từ bảng SystemConfigurations.
 * Phục vụ lấy thông tin cấu hình và nội quy làm ngữ cảnh cho AI Chatbot.
 */
public class SystemConfigurationsDAO {
    private static final Logger LOGGER = Logger.getLogger(SystemConfigurationsDAO.class.getName());

    /**
     * Lấy giá trị cấu hình theo khoá (configKey).
     */
    public String getConfigValue(String configKey) {
        String sql = "SELECT configValue FROM SystemConfigurations WHERE configKey = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, configKey);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("configValue");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn configKey: " + configKey, e);
        }
        return null;
    }

    /**
     * Lấy tất cả cấu hình thuộc nhóm thư viện để làm ngữ cảnh quy định.
     */
    public Map<String, String> getLibraryConfigurations() {
        Map<String, String> configs = new HashMap<>();
        String sql = "SELECT configKey, configValue, description FROM SystemConfigurations WHERE configGroup = 'library'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String key = rs.getString("configKey");
                String value = rs.getString("configValue");
                String desc = rs.getString("description");
                // Lưu chuỗi kết hợp giá trị và mô tả để AI dễ hiểu
                configs.put(key, value + (desc != null && !desc.isEmpty() ? " (" + desc + ")" : ""));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi tải cấu hình thư viện", e);
        }
        return configs;
    }
}
