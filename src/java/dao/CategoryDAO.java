package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import dto.ManagementSummaryDTO;
import util.DatabaseConnection;

public class CategoryDAO {

    public List<Category> findAll() throws SQLException {
        return search(null, null);
    }

    public List<Category> search(String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT c.categoryId, c.name, c.description, c.[status], c.updatedAt, c.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "COUNT(bc.bookId) AS bookCount FROM Category c "
                + "LEFT JOIN BookCategory bc ON bc.categoryId = c.categoryId "
                + "LEFT JOIN [User] u ON u.userId = c.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = c.updatedBy WHERE 1 = 1 ");
        List<String> values = new ArrayList<>();
        if (keyword != null) {
            sql.append("AND (LOWER(c.name) LIKE ? OR LOWER(COALESCE(c.description, N'')) LIKE ?) ");
            values.add("%" + keyword.toLowerCase() + "%");
            values.add("%" + keyword.toLowerCase() + "%");
        }
        if (status != null) {
            sql.append("AND c.[status] = ? ");
            values.add(status);
        }
        sql.append("GROUP BY c.categoryId, c.name, c.description, c.[status], c.updatedAt, c.updatedBy, "
                + "mp.fullName, u.email ORDER BY CASE WHEN c.[status] = 'active' THEN 0 ELSE 1 END, c.name");
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindStrings(ps, values);
            try (ResultSet rs = ps.executeQuery()) {
                List<Category> categories = new ArrayList<>();
                while (rs.next()) {
                    categories.add(map(rs));
                }
                return categories;
            }
        }
    }

    public ManagementSummaryDTO getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) AS totalCount, "
                + "SUM(CASE WHEN c.[status] = 'active' THEN 1 ELSE 0 END) AS activeCount, "
                + "SUM(CASE WHEN c.[status] = 'hidden' THEN 1 ELSE 0 END) AS hiddenCount, "
                + "SUM(CASE WHEN used.categoryId IS NULL THEN 1 ELSE 0 END) AS unusedCount "
                + "FROM Category c LEFT JOIN (SELECT DISTINCT categoryId FROM BookCategory) used "
                + "ON used.categoryId = c.categoryId";
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

    public Category findById(Connection conn, int categoryId) throws SQLException {
        String sql = "SELECT c.categoryId, c.name, c.description, c.[status], c.updatedAt, c.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "(SELECT COUNT(*) FROM BookCategory bc WHERE bc.categoryId = c.categoryId) AS bookCount "
                + "FROM Category c LEFT JOIN [User] u ON u.userId = c.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = c.updatedBy WHERE c.categoryId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public Category findByName(Connection conn, String name) throws SQLException {
        String sql = "SELECT c.categoryId, c.name, c.description, c.[status], c.updatedAt, c.updatedBy, "
                + "COALESCE(mp.fullName, u.email, N'Chưa cập nhật') AS updatedByName, "
                + "(SELECT COUNT(*) FROM BookCategory bc WHERE bc.categoryId = c.categoryId) AS bookCount "
                + "FROM Category c LEFT JOIN [User] u ON u.userId = c.updatedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = c.updatedBy WHERE LOWER(c.name) = LOWER(?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public boolean existsByName(Connection conn, String name, Integer excludedId) throws SQLException {
        String sql = "SELECT 1 FROM Category WHERE LOWER(name) = LOWER(?)"
                + (excludedId == null ? "" : " AND categoryId <> ?");
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

    public int insert(Connection conn, Category category, int actorId) throws SQLException {
        String sql = "INSERT INTO Category (name, description, [status], updatedAt, updatedBy) "
                + "VALUES (?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getStatus());
            ps.setInt(4, actorId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã thể loại vừa tạo.");
    }

    public void update(Connection conn, Category category, int actorId) throws SQLException {
        String sql = "UPDATE Category SET name = ?, description = ?, [status] = ?, "
                + "updatedAt = GETDATE(), updatedBy = ? WHERE categoryId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getStatus());
            ps.setInt(4, actorId);
            ps.setInt(5, category.getCategoryId());
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Thể loại không tồn tại.");
            }
        }
    }

    private Category map(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("categoryId"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));
        category.setUpdatedAt(rs.getTimestamp("updatedAt"));
        int updatedBy = rs.getInt("updatedBy");
        category.setUpdatedBy(rs.wasNull() ? null : updatedBy);
        category.setUpdatedByName(rs.getString("updatedByName"));
        category.setBookCount(rs.getInt("bookCount"));
        return category;
    }

    private void bindStrings(PreparedStatement ps, List<String> values) throws SQLException {
        for (int i = 0; i < values.size(); i++) {
            ps.setString(i + 1, values.get(i));
        }
    }
}
