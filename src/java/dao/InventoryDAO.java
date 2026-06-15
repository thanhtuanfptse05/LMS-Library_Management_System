package dao;

import dto.InventorySummaryDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.InventoryItem;
import model.InventorySession;
import util.DatabaseConnection;

public class InventoryDAO {

    public List<InventorySession> findSessions() throws SQLException {
        String sql = sessionSelect() + " ORDER BY s.startedAt DESC, s.inventorySessionId DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<InventorySession> sessions = new ArrayList<>();
            while (rs.next()) sessions.add(mapSession(rs));
            return sessions;
        }
    }

    public InventorySummaryDTO getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) totalSessions, "
                + "SUM(CASE WHEN status IN ('draft','counting') THEN 1 ELSE 0 END) activeSessions, "
                + "SUM(CASE WHEN status = 'reviewing' THEN 1 ELSE 0 END) reviewingSessions, "
                + "(SELECT COUNT(*) FROM InventoryItem WHERE result IN ('missing','misplaced') "
                + "AND resolvedAt IS NULL) unresolvedItems FROM InventorySession";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            InventorySummaryDTO summary = new InventorySummaryDTO();
            if (rs.next()) {
                summary.setTotalSessions(rs.getInt("totalSessions"));
                summary.setActiveSessions(rs.getInt("activeSessions"));
                summary.setReviewingSessions(rs.getInt("reviewingSessions"));
                summary.setUnresolvedItems(rs.getInt("unresolvedItems"));
            }
            return summary;
        }
    }

    public InventorySession findSession(Connection conn, int sessionId, boolean lock) throws SQLException {
        String sql = "SELECT s.inventorySessionId, s.location, s.status, s.startedBy, "
                + "COALESCE(mp.fullName,u.email) startedByName, s.startedAt, s.completedBy, "
                + "s.completedAt, s.note, "
                + "(SELECT COUNT(*) FROM InventoryItem i WHERE i.inventorySessionId=s.inventorySessionId) expectedCount, "
                + "(SELECT COUNT(*) FROM InventoryItem i WHERE i.inventorySessionId=s.inventorySessionId AND i.result='matched') matchedCount, "
                + "(SELECT COUNT(*) FROM InventoryItem i WHERE i.inventorySessionId=s.inventorySessionId AND i.result IN ('missing','misplaced')) discrepancyCount, "
                + "(SELECT COUNT(*) FROM InventoryItem i WHERE i.inventorySessionId=s.inventorySessionId "
                + "AND i.result IN ('missing','misplaced') AND i.resolvedAt IS NULL) unresolvedCount "
                + "FROM InventorySession s JOIN \"User\" u ON u.userId=s.startedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId=s.startedBy WHERE s.inventorySessionId = ?"
                + (lock ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapSession(rs) : null;
            }
        }
    }

    public List<InventoryItem> findItems(int sessionId) throws SQLException {
        String sql = itemSelect() + " WHERE i.inventorySessionId = ? "
                + "ORDER BY CASE i.result WHEN 'missing' THEN 0 WHEN 'misplaced' THEN 1 "
                + "WHEN 'pending' THEN 2 ELSE 3 END, bc.barcode";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                List<InventoryItem> items = new ArrayList<>();
                while (rs.next()) items.add(mapItem(rs));
                return items;
            }
        }
    }

    public InventoryItem findItem(Connection conn, int itemId, boolean lock) throws SQLException {
        String sql = itemSelect("InventoryItem i") + " WHERE i.inventoryItemId = ?"
                + (lock ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapItem(rs) : null;
            }
        }
    }

    public int insertSession(Connection conn, String location, String note, int actorId) throws SQLException {
        String sql = "INSERT INTO InventorySession (location, status, startedBy, startedAt, note) "
                + "VALUES (?, 'draft', ?, NOW(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, location);
            ps.setInt(2, actorId);
            ps.setString(3, note);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        throw new SQLException("Không thể lấy mã phiên kiểm kê.");
    }

    public int createExpectedItems(Connection conn, int sessionId, String location) throws SQLException {
        String sql = "INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, result) "
                + "SELECT ?, bookCopyId, location, 'pending' FROM BookCopy "
                + "WHERE location = ? AND condition = 'good'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ps.setString(2, location);
            return ps.executeUpdate();
        }
    }

    public void updateSessionStatus(Connection conn, int sessionId, String fromStatus, String toStatus,
            Integer actorId) throws SQLException {
        String completed = "completed".equals(toStatus) || "cancelled".equals(toStatus)
                ? ", completedBy = ?, completedAt = NOW()" : "";
        String sql = "UPDATE InventorySession SET status = ?" + completed
                + " WHERE inventorySessionId = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            ps.setString(index++, toStatus);
            if (!completed.isEmpty()) ps.setInt(index++, actorId);
            ps.setInt(index++, sessionId);
            ps.setString(index, fromStatus);
            if (ps.executeUpdate() != 1) throw new SQLException("Phiên kiểm kê không còn ở trạng thái phù hợp.");
        }
    }

    public void recordScan(Connection conn, int sessionId, int bookCopyId, String scannedLocation,
            String result, int actorId, String expectedLocation) throws SQLException {
        String update = "UPDATE InventoryItem SET scannedLocation = ?, result = ?, scannedBy = ?, "
                + "scannedAt = NOW() WHERE inventorySessionId = ? AND bookCopyId = ?";
        try (PreparedStatement ps = conn.prepareStatement(update)) {
            ps.setString(1, scannedLocation);
            ps.setString(2, result);
            ps.setInt(3, actorId);
            ps.setInt(4, sessionId);
            ps.setInt(5, bookCopyId);
            if (ps.executeUpdate() == 1) return;
        }
        String insert = "INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, "
                + "scannedLocation, result, scannedBy, scannedAt) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(insert)) {
            ps.setInt(1, sessionId);
            ps.setInt(2, bookCopyId);
            ps.setString(3, expectedLocation);
            ps.setString(4, scannedLocation);
            ps.setString(5, result);
            ps.setInt(6, actorId);
            ps.executeUpdate();
        }
    }

    public int markMissing(Connection conn, int sessionId) throws SQLException {
        String sql = "UPDATE InventoryItem SET result = 'missing' "
                + "WHERE inventorySessionId = ? AND result = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            return ps.executeUpdate();
        }
    }

    public void resolveItem(Connection conn, int itemId, String resolution, int actorId) throws SQLException {
        String sql = "UPDATE InventoryItem SET resolution = ?, resolvedBy = ?, resolvedAt = NOW() "
                + "WHERE inventoryItemId = ? AND result IN ('missing','misplaced') AND resolvedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resolution);
            ps.setInt(2, actorId);
            ps.setInt(3, itemId);
            if (ps.executeUpdate() != 1) throw new SQLException("Chênh lệch đã được xử lý.");
        }
    }

    public int countUnresolved(Connection conn, int sessionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM InventoryItem WHERE inventorySessionId = ? "
                + "AND result IN ('missing','misplaced') AND resolvedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        }
    }

    private String sessionSelect() { return sessionSelect("InventorySession s"); }
    private String sessionSelect(String table) {
        return "SELECT s.inventorySessionId, s.location, s.status, s.startedBy, "
                + "COALESCE(mp.fullName,u.email) startedByName, s.startedAt, s.completedBy, "
                + "s.completedAt, s.note, COUNT(i.inventoryItemId) expectedCount, "
                + "SUM(CASE WHEN i.result='matched' THEN 1 ELSE 0 END) matchedCount, "
                + "SUM(CASE WHEN i.result IN ('missing','misplaced') THEN 1 ELSE 0 END) discrepancyCount, "
                + "SUM(CASE WHEN i.result IN ('missing','misplaced') AND i.resolvedAt IS NULL THEN 1 ELSE 0 END) unresolvedCount "
                + "FROM " + table + " JOIN \"User\" u ON u.userId=s.startedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId=s.startedBy "
                + "LEFT JOIN InventoryItem i ON i.inventorySessionId=s.inventorySessionId "
                + "GROUP BY s.inventorySessionId,s.location,s.status,s.startedBy,mp.fullName,u.email,"
                + "s.startedAt,s.completedBy,s.completedAt,s.note";
    }
    private String itemSelect() { return itemSelect("InventoryItem i"); }
    private String itemSelect(String table) {
        return "SELECT i.inventoryItemId,i.inventorySessionId,i.bookCopyId,bc.barcode,b.title bookTitle,"
                + "i.expectedLocation,i.scannedLocation,i.result,i.scannedBy,i.scannedAt,i.resolution,"
                + "i.resolvedBy,i.resolvedAt FROM " + table
                + " JOIN BookCopy bc ON bc.bookCopyId=i.bookCopyId JOIN Book b ON b.bookId=bc.bookId";
    }
    private InventorySession mapSession(ResultSet rs) throws SQLException {
        InventorySession s = new InventorySession();
        s.setInventorySessionId(rs.getInt("inventorySessionId")); s.setLocation(rs.getString("location"));
        s.setStatus(rs.getString("status")); s.setStartedBy(rs.getInt("startedBy"));
        s.setStartedByName(rs.getString("startedByName")); s.setStartedAt(rs.getTimestamp("startedAt"));
        int completedBy = rs.getInt("completedBy"); s.setCompletedBy(rs.wasNull() ? null : completedBy);
        s.setCompletedAt(rs.getTimestamp("completedAt")); s.setNote(rs.getString("note"));
        s.setExpectedCount(rs.getInt("expectedCount")); s.setMatchedCount(rs.getInt("matchedCount"));
        s.setDiscrepancyCount(rs.getInt("discrepancyCount")); s.setUnresolvedCount(rs.getInt("unresolvedCount"));
        return s;
    }
    private InventoryItem mapItem(ResultSet rs) throws SQLException {
        InventoryItem i = new InventoryItem();
        i.setInventoryItemId(rs.getInt("inventoryItemId")); i.setInventorySessionId(rs.getInt("inventorySessionId"));
        i.setBookCopyId(rs.getInt("bookCopyId")); i.setBarcode(rs.getString("barcode"));
        i.setBookTitle(rs.getString("bookTitle")); i.setExpectedLocation(rs.getString("expectedLocation"));
        i.setScannedLocation(rs.getString("scannedLocation")); i.setResult(rs.getString("result"));
        int scannedBy = rs.getInt("scannedBy"); i.setScannedBy(rs.wasNull() ? null : scannedBy);
        i.setScannedAt(rs.getTimestamp("scannedAt")); i.setResolution(rs.getString("resolution"));
        int resolvedBy = rs.getInt("resolvedBy"); i.setResolvedBy(rs.wasNull() ? null : resolvedBy);
        i.setResolvedAt(rs.getTimestamp("resolvedAt")); return i;
    }
}
