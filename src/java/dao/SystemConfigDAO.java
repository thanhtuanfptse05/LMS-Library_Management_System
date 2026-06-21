package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.SystemConfiguration;
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

    public List<SystemConfiguration> findAll(Connection conn) throws SQLException {
        List<SystemConfiguration> list = new ArrayList<>();
        String sql = "SELECT sc.configKey, sc.configValue, sc.description, sc.configGroup, "
                + "sc.updatedBy, sc.updatedAt, "
                + "COALESCE(mp.fullName, 'Hệ thống') AS updaterName "
                + "FROM SystemConfigurations sc "
                + "LEFT JOIN \"User\" u ON sc.updatedBy = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "ORDER BY sc.configGroup, sc.configKey";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<SystemConfiguration> findByGroup(Connection conn, String group) throws SQLException {
        List<SystemConfiguration> list = new ArrayList<>();
        String sql = "SELECT sc.configKey, sc.configValue, sc.description, sc.configGroup, "
                + "sc.updatedBy, sc.updatedAt, "
                + "COALESCE(mp.fullName, 'Hệ thống') AS updaterName "
                + "FROM SystemConfigurations sc "
                + "LEFT JOIN \"User\" u ON sc.updatedBy = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "WHERE sc.configGroup = ? "
                + "ORDER BY sc.configKey";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public SystemConfiguration findByKey(Connection conn, String key) throws SQLException {
        String sql = "SELECT sc.configKey, sc.configValue, sc.description, sc.configGroup, "
                + "sc.updatedBy, sc.updatedAt, "
                + "COALESCE(mp.fullName, 'Hệ thống') AS updaterName "
                + "FROM SystemConfigurations sc "
                + "LEFT JOIN \"User\" u ON sc.updatedBy = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "WHERE sc.configKey = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, key);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public void update(Connection conn, String key, String value, Integer updatedBy) throws SQLException {
        String sql = "UPDATE SystemConfigurations "
                + "SET configValue = ?, updatedBy = ?, updatedAt = NOW() "
                + "WHERE configKey = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, value);
            if (updatedBy != null) {
                stmt.setInt(2, updatedBy);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setString(3, key);
            stmt.executeUpdate();
        }
    }

    public void insert(Connection conn, SystemConfiguration config) throws SQLException {
        String sql = "INSERT INTO SystemConfigurations (configKey, configValue, description, configGroup, updatedBy) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, config.getConfigKey());
            stmt.setString(2, config.getConfigValue());
            stmt.setString(3, config.getDescription());
            stmt.setString(4, config.getConfigGroup());
            if (config.getUpdatedBy() != null) {
                stmt.setInt(5, config.getUpdatedBy());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();
        }
    }

    public void delete(Connection conn, String key) throws SQLException {
        String sql = "DELETE FROM SystemConfigurations WHERE configKey = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, key);
            stmt.executeUpdate();
        }
    }

    private SystemConfiguration mapRow(ResultSet rs) throws SQLException {
        SystemConfiguration config = new SystemConfiguration();
        config.setConfigKey(rs.getString("configKey"));
        config.setConfigValue(rs.getString("configValue"));
        config.setDescription(rs.getString("description"));
        config.setConfigGroup(rs.getString("configGroup"));
        int updatedBy = rs.getInt("updatedBy");
        if (!rs.wasNull()) {
            config.setUpdatedBy(updatedBy);
        }
        config.setUpdaterName(rs.getString("updaterName"));
        config.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return config;
    }
}
