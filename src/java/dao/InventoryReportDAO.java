package dao;

import dto.InventoryResultDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DatabaseConnection;

public class InventoryReportDAO {
    
    /**
     * Lấy thống kê của đợt kiểm kê đã hoàn thành gần nhất
     */
    public InventoryResultDTO getLatestInventoryStats() throws Exception {
        InventoryResultDTO dto = null;
        String sql = "SELECT s.inventorySessionId, s.location, s.completedAt, " +
                     "SUM(CASE WHEN i.result = 'matched' THEN 1 ELSE 0 END) AS totalMatched, " +
                     "SUM(CASE WHEN i.result = 'missing' THEN 1 ELSE 0 END) AS totalMissing, " +
                     "SUM(CASE WHEN i.result = 'misplaced' THEN 1 ELSE 0 END) AS totalMisplaced " +
                     "FROM InventorySession s " +
                     "LEFT JOIN InventoryItem i ON s.inventorySessionId = i.inventorySessionId " +
                     "WHERE s.status = 'completed' " +
                     "GROUP BY s.inventorySessionId, s.location, s.completedAt " +
                     "ORDER BY s.completedAt DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new InventoryResultDTO();
                    dto.setSessionId(rs.getInt("inventorySessionId"));
                    dto.setLocation(rs.getString("location"));
                    dto.setCompletedAt(rs.getTimestamp("completedAt"));
                    dto.setTotalMatched(rs.getInt("totalMatched"));
                    dto.setTotalMissing(rs.getInt("totalMissing"));
                    dto.setTotalMisplaced(rs.getInt("totalMisplaced"));
                }
            }
        }
        return dto;
    }
}
