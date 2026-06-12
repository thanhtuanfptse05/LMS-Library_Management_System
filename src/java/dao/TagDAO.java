package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Tag;
import dto.ManagementSummaryDTO;
import util.DatabaseConnection;

public class TagDAO {

    public List<Tag> findAll() throws SQLException {
        return search(null, null);
    }

    public List<Tag> search(String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT t.tagId, t.name, t.[status], t.updatedAt, t.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "COUNT(bt.bookId) AS bookCount FROM Tag t "
                + "LEFT JOIN BookTag bt ON bt.tagId = t.tagId "
                + "LEFT JOIN [User] u ON u.userId = t.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = t.updatedBy WHERE 1 = 1 ");
        List<String> values = new ArrayList<>();
        if (keyword != null) {
            sql.append("AND LOWER(t.name) LIKE ? ");
            values.add("%" + keyword.toLowerCase() + "%");
        }
        if (status != null) {
            sql.append("AND t.[status] = ? ");
            values.add(status);
        }
        sql.append("GROUP BY t.tagId, t.name, t.[status], t.updatedAt, t.updatedBy, mp.fullName, u.email "
                + "ORDER BY CASE WHEN t.[status] = 'active' THEN 0 ELSE 1 END, t.name");
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindStrings(ps, values);
            try (ResultSet rs = ps.executeQuery()) {
                List<Tag> tags = new ArrayList<>();
                while (rs.next()) {
                    tags.add(map(rs));
                }
                return tags;
            }
        }
    }

    public ManagementSummaryDTO getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) AS totalCount, "
                + "SUM(CASE WHEN t.[status] = 'active' THEN 1 ELSE 0 END) AS activeCount, "
                + "SUM(CASE WHEN t.[status] = 'hidden' THEN 1 ELSE 0 END) AS hiddenCount, "
                + "SUM(CASE WHEN used.tagId IS NULL THEN 1 ELSE 0 END) AS unusedCount "
                + "FROM Tag t LEFT JOIN (SELECT DISTINCT tagId FROM BookTag) used "
                + "ON used.tagId = t.tagId";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            ManagementSummaryDTO summary = new ManagementSummaryDTO();
            if (rs.next()) {
                summary.setTotalCount(rs.getInt("totalCount"));
                summary.setActiveCount(rs.getInt("activeCount"));
                summary.setHiddenCount(rs.getInt("hiddenCount"));
                summary.setUnusedCount(rs.getInt("unusedCount"));
            }
            return summary;
        }
    }

    public Tag findById(Connection conn, int tagId) throws SQLException {
        String sql = "SELECT t.tagId, t.name, t.[status], t.updatedAt, t.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "(SELECT COUNT(*) FROM BookTag bt WHERE bt.tagId = t.tagId) AS bookCount "
                + "FROM Tag t LEFT JOIN [User] u ON u.userId = t.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = t.updatedBy WHERE t.tagId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tagId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public Tag findByName(Connection conn, String name) throws SQLException {
        String sql = "SELECT t.tagId, t.name, t.[status], t.updatedAt, t.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "(SELECT COUNT(*) FROM BookTag bt WHERE bt.tagId = t.tagId) AS bookCount "
                + "FROM Tag t LEFT JOIN [User] u ON u.userId = t.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = t.updatedBy WHERE LOWER(t.name) = LOWER(?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public boolean existsByName(Connection conn, String name, Integer excludedId) throws SQLException {
        String sql = "SELECT 1 FROM Tag WHERE LOWER(name) = LOWER(?)"
                + (excludedId == null ? "" : " AND tagId <> ?");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            if (excludedId != null) {
                ps.setInt(2, excludedId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int insert(Connection conn, Tag tag, int actorId) throws SQLException {
        String sql = "INSERT INTO Tag (name, [status], updatedAt, updatedBy) VALUES (?, ?, GETDATE(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tag.getName());
            ps.setString(2, tag.getStatus());
            ps.setInt(3, actorId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã tag vừa tạo.");
    }

    public void update(Connection conn, Tag tag, int actorId) throws SQLException {
        String sql = "UPDATE Tag SET name = ?, [status] = ?, updatedAt = GETDATE(), updatedBy = ? WHERE tagId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tag.getName());
            ps.setString(2, tag.getStatus());
            ps.setInt(3, actorId);
            ps.setInt(4, tag.getTagId());
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Tag sách không tồn tại.");
            }
        }
    }

    public void mergeRelations(Connection conn, int sourceId, int targetId) throws SQLException {
        String insertSql = "INSERT INTO BookTag (bookId, tagId) "
                + "SELECT bt.bookId, ? FROM BookTag bt WHERE bt.tagId = ? "
                + "AND NOT EXISTS (SELECT 1 FROM BookTag existing WHERE existing.bookId = bt.bookId AND existing.tagId = ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, targetId);
            ps.setInt(2, sourceId);
            ps.setInt(3, targetId);
            ps.executeUpdate();
        }
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookTag WHERE tagId = ?")) {
            ps.setInt(1, sourceId);
            ps.executeUpdate();
        }
    }

    private Tag map(ResultSet rs) throws SQLException {
        Tag tag = new Tag();
        tag.setTagId(rs.getInt("tagId"));
        tag.setName(rs.getString("name"));
        tag.setStatus(rs.getString("status"));
        tag.setUpdatedAt(rs.getTimestamp("updatedAt"));
        int updatedBy = rs.getInt("updatedBy");
        tag.setUpdatedBy(rs.wasNull() ? null : updatedBy);
        tag.setUpdatedByName(rs.getString("updatedByName"));
        tag.setBookCount(rs.getInt("bookCount"));
        return tag;
    }

    private void bindStrings(PreparedStatement ps, List<String> values) throws SQLException {
        for (int i = 0; i < values.size(); i++) {
            ps.setString(i + 1, values.get(i));
        }
    }
}
