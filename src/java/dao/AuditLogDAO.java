package dao;

import dto.AuditLogDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseConnection;

public class AuditLogDAO {

    public void insert(Connection conn, Integer userId, String actionType, String entityName,
            Integer entityId, String oldValues, String newValues) throws SQLException {
        String sql = "INSERT INTO AuditLogs (userId, actionType, entityName, entityId, oldValues, newValues, timestamp) "
                + "VALUES (?, ?, ?, ?, ?, ?, timezone('Asia/Ho_Chi_Minh', NOW()))";
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

    /**
     * Truy vấn danh sách audit log có lọc, phân trang.
     * LEFT JOIN "User" để lấy email người thực hiện.
     * Sắp xếp theo timestamp giảm dần.
     */
    public List<AuditLogDTO> findWithFilters(String actionType, String entityName, String email,
            Timestamp fromDate, Timestamp toDate, String keyword, int page, int pageSize) throws SQLException {
        List<AuditLogDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT a.auditLogId, a.userId, a.actionType, a.entityName, a.entityId, a.oldValues, a.newValues, a.timestamp, u.email AS userEmail ");
        sql.append("FROM AuditLogs a LEFT JOIN \"User\" u ON a.userId = u.userId WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        buildWhereClause(sql, params, actionType, entityName, email, fromDate, toDate, keyword);

        sql.append(" ORDER BY a.timestamp DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDTO(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi theo filter (dùng cho phân trang).
     */
    public int countWithFilters(String actionType, String entityName, String email,
            Timestamp fromDate, Timestamp toDate, String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM AuditLogs a LEFT JOIN \"User\" u ON a.userId = u.userId WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        buildWhereClause(sql, params, actionType, entityName, email, fromDate, toDate, keyword);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Tìm chi tiết 1 bản ghi audit log theo ID.
     */
    public AuditLogDTO findById(int auditLogId) throws SQLException {
        String sql = "SELECT a.auditLogId, a.userId, a.actionType, a.entityName, a.entityId, a.oldValues, a.newValues, a.timestamp, u.email AS userEmail "
                + "FROM AuditLogs a LEFT JOIN \"User\" u ON a.userId = u.userId WHERE a.auditLogId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, auditLogId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDTO(rs);
                }
            }
        }
        return null;
    }

    /**
     * Lấy danh sách DISTINCT actionType để populate dropdown bộ lọc.
     */
    public List<String> getDistinctActionTypes() throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT actionType FROM AuditLogs WHERE actionType IS NOT NULL AND actionType != '' ORDER BY actionType";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("actionType"));
            }
        }
        return list;
    }

    /**
     * Lấy danh sách DISTINCT entityName để populate dropdown bộ lọc.
     */
    public List<String> getDistinctEntityNames() throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT entityName FROM AuditLogs WHERE entityName IS NOT NULL AND entityName != '' ORDER BY entityName";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("entityName"));
            }
        }
        return list;
    }

    private void buildWhereClause(StringBuilder sql, List<Object> params, String actionType,
            String entityName, String email, Timestamp fromDate, Timestamp toDate, String keyword) {
        if (actionType != null && !actionType.trim().isEmpty()) {
            sql.append(" AND a.actionType = ?");
            params.add(actionType.trim());
        }
        if (entityName != null && !entityName.trim().isEmpty()) {
            sql.append(" AND a.entityName = ?");
            params.add(entityName.trim());
        }
        if (email != null && !email.trim().isEmpty()) {
            sql.append(" AND u.email ILIKE ?");
            params.add("%" + email.trim() + "%");
        }
        if (fromDate != null) {
            sql.append(" AND a.timestamp >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND a.timestamp <= ?");
            params.add(toDate);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (a.actionType ILIKE ? OR a.entityName ILIKE ? OR u.email ILIKE ? OR a.oldValues ILIKE ? OR a.newValues ILIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }
    }

    private AuditLogDTO mapResultSetToDTO(ResultSet rs) throws SQLException {
        AuditLogDTO dto = new AuditLogDTO();
        dto.setAuditLogId(rs.getInt("auditLogId"));

        int userId = rs.getInt("userId");
        dto.setUserId(rs.wasNull() ? null : userId);

        dto.setActionType(rs.getString("actionType"));
        dto.setEntityName(rs.getString("entityName"));

        int entityId = rs.getInt("entityId");
        dto.setEntityId(rs.wasNull() ? null : entityId);

        dto.setOldValues(rs.getString("oldValues"));
        dto.setNewValues(rs.getString("newValues"));
        dto.setTimestamp(rs.getTimestamp("timestamp"));
        dto.setUserEmail(rs.getString("userEmail"));
        return dto;
    }
}
