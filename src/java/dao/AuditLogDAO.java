package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditLogDAO {

    public void insert(Connection conn, Integer userId, String actionType, String entityName,
            Integer entityId, String oldValues, String newValues) throws SQLException {
        String sql = "INSERT INTO AuditLogs (userId, actionType, [entityName], [entityId], oldValues, newValues, [timestamp]) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
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
}
