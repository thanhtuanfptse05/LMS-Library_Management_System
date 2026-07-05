package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.BookSuggestion;
import util.DatabaseConnection;

public class BookSuggestionDAO {

    public BookSuggestion findById(Connection conn, int suggestionId) throws SQLException {
        String sql = "SELECT bs.*, "
                + "COALESCE(mp.fullName, u.email) AS createdByName, "
                + "COALESCE(mp_rev.fullName, u_rev.email) AS reviewedByName "
                + "FROM BookSuggestion bs "
                + "JOIN \"User\" u ON bs.createdBy = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "LEFT JOIN \"User\" u_rev ON bs.reviewedBy = u_rev.userId "
                + "LEFT JOIN MemberProfile mp_rev ON u_rev.userId = mp_rev.userId "
                + "WHERE bs.suggestionId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, suggestionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public List<BookSuggestion> getPaginatedSuggestions(String keyword, String status, int offset, int limit) throws SQLException {
        List<BookSuggestion> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT bs.*, "
                + "COALESCE(mp.fullName, u.email) AS createdByName, "
                + "COALESCE(mp_rev.fullName, u_rev.email) AS reviewedByName "
                + "FROM BookSuggestion bs "
                + "JOIN \"User\" u ON bs.createdBy = u.userId "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "LEFT JOIN \"User\" u_rev ON bs.reviewedBy = u_rev.userId "
                + "LEFT JOIN MemberProfile mp_rev ON u_rev.userId = mp_rev.userId "
                + "WHERE 1 = 1 "
        );
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (bs.title ILIKE ? OR bs.author ILIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND bs.status = ? ");
            params.add(status);
        }
        
        sql.append("ORDER BY bs.voteCount DESC, bs.createdAt ASC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int countSuggestions(String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BookSuggestion bs WHERE 1 = 1 ");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (bs.title ILIKE ? OR bs.author ILIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND bs.status = ? ");
            params.add(status);
        }
        
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

    public int countPendingByLecturer(Connection conn, int lecturerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BookSuggestion WHERE createdBy = ? AND status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean existsSimilarTitle(Connection conn, String title) throws SQLException {
        String sql = "SELECT 1 FROM BookSuggestion WHERE title ILIKE ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int insert(Connection conn, BookSuggestion suggestion) throws SQLException {
        String sql = "INSERT INTO BookSuggestion (title, author, publisher, isbn, reason, status, voteCount, createdBy, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, 'pending', 1, ?, NOW(), NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, suggestion.getTitle().trim());
            ps.setString(2, suggestion.getAuthor().trim());
            
            if (suggestion.getPublisher() == null || suggestion.getPublisher().trim().isEmpty()) {
                ps.setNull(3, Types.VARCHAR);
            } else {
                ps.setString(3, suggestion.getPublisher().trim());
            }
            
            if (suggestion.getIsbn() == null || suggestion.getIsbn().trim().isEmpty()) {
                ps.setNull(4, Types.VARCHAR);
            } else {
                ps.setString(4, suggestion.getIsbn().trim());
            }
            
            ps.setString(5, suggestion.getReason().trim());
            ps.setInt(6, suggestion.getCreatedBy());
            
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Tạo đề xuất sách thất bại, không lấy được ID.");
    }

    public void update(Connection conn, BookSuggestion suggestion) throws SQLException {
        String sql = "UPDATE BookSuggestion SET title = ?, author = ?, publisher = ?, isbn = ?, reason = ?, updatedAt = NOW() "
                + "WHERE suggestionId = ? AND status = 'pending' AND voteCount = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, suggestion.getTitle().trim());
            ps.setString(2, suggestion.getAuthor().trim());
            
            if (suggestion.getPublisher() == null || suggestion.getPublisher().trim().isEmpty()) {
                ps.setNull(3, Types.VARCHAR);
            } else {
                ps.setString(3, suggestion.getPublisher().trim());
            }
            
            if (suggestion.getIsbn() == null || suggestion.getIsbn().trim().isEmpty()) {
                ps.setNull(4, Types.VARCHAR);
            } else {
                ps.setString(4, suggestion.getIsbn().trim());
            }
            
            ps.setString(5, suggestion.getReason().trim());
            ps.setInt(6, suggestion.getSuggestionId());
            
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Cập nhật đề xuất thất bại. Bản ghi đã đổi trạng thái hoặc có người vote.");
            }
        }
    }

    public void delete(Connection conn, int suggestionId) throws SQLException {
        String sql = "DELETE FROM BookSuggestion WHERE suggestionId = ? AND status = 'pending' AND voteCount = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, suggestionId);
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Xóa đề xuất thất bại. Bản ghi đã đổi trạng thái hoặc có người vote.");
            }
        }
    }

    public void updateStatus(Connection conn, int suggestionId, String status, String librarianNote, int reviewedBy) throws SQLException {
        String sql = "UPDATE BookSuggestion SET status = ?, librarianNote = ?, reviewedBy = ?, updatedAt = NOW() WHERE suggestionId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (librarianNote == null || librarianNote.trim().isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, librarianNote.trim());
            }
            ps.setInt(3, reviewedBy);
            ps.setInt(4, suggestionId);
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Cập nhật trạng thái đề xuất thất bại. Bản ghi không tồn tại.");
            }
        }
    }

    private BookSuggestion map(ResultSet rs) throws SQLException {
        BookSuggestion bs = new BookSuggestion();
        bs.setSuggestionId(rs.getInt("suggestionId"));
        bs.setTitle(rs.getString("title"));
        bs.setAuthor(rs.getString("author"));
        bs.setPublisher(rs.getString("publisher"));
        bs.setIsbn(rs.getString("isbn"));
        bs.setReason(rs.getString("reason"));
        bs.setStatus(rs.getString("status"));
        bs.setVoteCount(rs.getInt("voteCount"));
        bs.setLibrarianNote(rs.getString("librarianNote"));
        bs.setCreatedBy(rs.getInt("createdBy"));
        
        int reviewedBy = rs.getInt("reviewedBy");
        bs.setReviewedBy(rs.wasNull() ? null : reviewedBy);
        
        bs.setCreatedAt(rs.getTimestamp("createdAt"));
        bs.setUpdatedAt(rs.getTimestamp("updatedAt"));
        
        bs.setCreatedByName(rs.getString("createdByName"));
        bs.setReviewedByName(rs.getString("reviewedByName"));
        return bs;
    }
}
