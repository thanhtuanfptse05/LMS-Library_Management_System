package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseConnection;

public class SuggestionVoteDAO {

    public boolean exists(Connection conn, int suggestionId, int userId) throws SQLException {
        String sql = "SELECT 1 FROM SuggestionVote WHERE suggestionId = ? AND userId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, suggestionId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void insert(Connection conn, int suggestionId, int userId) throws SQLException {
        String sql = "INSERT INTO SuggestionVote (suggestionId, userId, votedAt) VALUES (?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, suggestionId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void delete(Connection conn, int suggestionId, int userId) throws SQLException {
        String sql = "DELETE FROM SuggestionVote WHERE suggestionId = ? AND userId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, suggestionId);
            ps.setInt(2, userId);
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Bạn chưa thực hiện vote cho đề xuất này hoặc bản ghi không tồn tại.");
            }
        }
    }

    public List<Integer> getUserVotedSuggestionIds(int userId) throws SQLException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT suggestionId FROM SuggestionVote WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("suggestionId"));
                }
            }
        }
        return list;
    }

    // Transactional operations for voting
    public void voteTransaction(int suggestionId, int userId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra xem đề xuất có status = 'pending' không
                String checkSql = "SELECT status FROM BookSuggestion WHERE suggestionId = ? FOR UPDATE";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, suggestionId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Đề xuất không tồn tại.");
                        }
                        if (!"pending".equals(rs.getString("status"))) {
                            throw new SQLException("Chỉ được vote cho đề xuất có trạng thái 'pending'.");
                        }
                    }
                }

                // 2. Kiểm tra xem đã vote chưa
                if (exists(conn, suggestionId, userId)) {
                    throw new SQLException("Bạn đã vote cho đề xuất này rồi.");
                }

                // 3. Thêm bản ghi vote
                insert(conn, suggestionId, userId);

                // 4. Cập nhật voteCount
                String updateSql = "UPDATE BookSuggestion SET voteCount = voteCount + 1, updatedAt = NOW() WHERE suggestionId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, suggestionId);
                    ps.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // Transactional operations for unvoting
    public void unvoteTransaction(int suggestionId, int userId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra xem đề xuất có status = 'pending' không
                String checkSql = "SELECT status FROM BookSuggestion WHERE suggestionId = ? FOR UPDATE";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, suggestionId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Đề xuất không tồn tại.");
                        }
                        if (!"pending".equals(rs.getString("status"))) {
                            throw new SQLException("Chỉ được hủy vote cho đề xuất có trạng thái 'pending'.");
                        }
                    }
                }

                // 2. Kiểm tra xem đã vote chưa
                if (!exists(conn, suggestionId, userId)) {
                    throw new SQLException("Bạn chưa vote cho đề xuất này.");
                }

                // 3. Xóa bản ghi vote
                delete(conn, suggestionId, userId);

                // 4. Cập nhật voteCount
                String updateSql = "UPDATE BookSuggestion SET voteCount = voteCount - 1, updatedAt = NOW() WHERE suggestionId = ? AND voteCount > 0";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, suggestionId);
                    ps.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
