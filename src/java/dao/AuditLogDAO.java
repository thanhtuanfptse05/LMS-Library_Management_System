package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditLogDAO {

    public void insert(Connection conn, Integer userId, String actionType, String entityName,
            Integer entityId, String oldValues, String newValues) throws SQLException {
        String sql = "INSERT INTO AuditLogs (userId, actionType, entityName, entityId, oldValues, newValues, timestamp) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, userId);
            }
            ps.setString(2, actionType);
            ps.setString(3, entityName);
            if (entityId == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, entityId);
            }
            ps.setString(5, oldValues);
            ps.setString(6, newValues);
            ps.executeUpdate();
        }
    }

    public java.util.List<dto.SystemConfigLogDTO> getSystemConfigLogs(Connection conn) throws SQLException {
        java.util.List<dto.SystemConfigLogDTO> logs = new java.util.ArrayList<>();
        String sql = "SELECT "
                + "  a.oldValues, "
                + "  a.newValues, "
                + "  a.timestamp, "
                + "  COALESCE(mp.fullName, u.email) AS updaterName, "
                + "  u.email AS updaterEmail "
                + "FROM AuditLogs a "
                + "LEFT JOIN \"User\" u ON a.userId = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "WHERE a.entityName = 'SystemConfigurations' "
                + "  AND a.actionType = 'UPDATE_SYSTEM_CONFIG' "
                + "ORDER BY a.timestamp DESC "
                + "LIMIT 50";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String oldJson = rs.getString("oldValues");
                String newJson = rs.getString("newValues");
                
                String key = extractJsonValue(newJson, "key");
                String oldVal = extractJsonValue(oldJson, "value");
                String newVal = extractJsonValue(newJson, "value");

                dto.SystemConfigLogDTO log = new dto.SystemConfigLogDTO(
                        key,
                        oldVal,
                        newVal,
                        rs.getTimestamp("timestamp"),
                        rs.getString("updaterName"),
                        rs.getString("updaterEmail")
                );
                logs.add(log);
            }
        }
        return logs;
    }

    private String extractJsonValue(String json, String field) {
        if (json == null || json.isEmpty()) return "";
        // Simple manual parsing since we formatted it as {"key":"...", "value":"..."}
        String searchStr = "\"" + field + "\":\"";
        int start = json.indexOf(searchStr);
        if (start == -1) return "";
        start += searchStr.length();
        int end = json.indexOf("\"", start);
        if (end == -1) return "";
        return json.substring(start, end);
    }
}
