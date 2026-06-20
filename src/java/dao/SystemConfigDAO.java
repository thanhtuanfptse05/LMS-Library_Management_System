package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * SystemConfigDAO — Data Access Object cho bảng SystemConfigurations.
 */
public class SystemConfigDAO {
    private static final Logger LOGGER = Logger.getLogger(SystemConfigDAO.class.getName());

    /**
     * Lấy giá trị cấu hình theo configKey, dùng Connection truyền vào.
     */
    public String getValue(Connection conn, String key, String defaultValue) throws SQLException {
        String sql = "SELECT configValue FROM SystemConfigurations WHERE configKey = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String val = rs.getString("configValue");
                    return (val != null) ? val : defaultValue;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy configKey=" + key, e);
            throw e;
        }
        return defaultValue;
    }

    /**
     * Lấy giá trị cấu hình theo configKey (tự mở và đóng connection).
     */
    public String getValue(String key, String defaultValue) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return getValue(conn, key, defaultValue);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy configKey (no-transaction)=" + key, e);
        }
        return defaultValue;
    }

    /**
     * Lấy giá trị cấu hình kiểu Integer.
     */
    public int getIntValue(Connection conn, String key, int defaultValue) throws SQLException {
        String val = getValue(conn, key, null);
        if (val == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Config key " + key + " value '" + val + "' không phải là số hợp lệ.", e);
            return defaultValue;
        }
    }

    public int getIntValue(String key, int defaultValue) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return getIntValue(conn, key, defaultValue);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy int configKey=" + key, e);
        }
        return defaultValue;
    }
}
