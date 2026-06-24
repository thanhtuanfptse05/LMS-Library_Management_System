package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.LibraryManager;
import util.DatabaseConnection;

// Đã xác minh tương thích với PostgreSQL
public class LibraryManagerDAO {
    private static final Logger LOGGER = Logger.getLogger(LibraryManagerDAO.class.getName());

    /**
     * Tìm kiếm thông tin Quản lý thư viện (LibraryManager) theo ID người dùng.
     * 
     * @param userId ID người dùng cần tìm
     * @return Đối tượng LibraryManager nếu tìm thấy, ngược lại trả về null
     */
    public LibraryManager findByUserId(int userId) {
        String sql = "SELECT userId, staffCode FROM LibraryManager WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new LibraryManager(rs.getInt("userId"), rs.getString("staffCode"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn LibraryManager theo userId=" + userId, e);
        }
        return null;
    }
}
