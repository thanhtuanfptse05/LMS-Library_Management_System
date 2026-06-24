package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Admin;
import util.DatabaseConnection;

/**
 * AdminDAO — Đối tượng truy cập dữ liệu (DAO) cho bảng Admin.
 */
// Đã xác minh tính tương thích với PostgreSQL
public class AdminDAO {
    private static final Logger LOGGER = Logger.getLogger(AdminDAO.class.getName());

    /**
     * Tìm kiếm thông tin Quản trị viên (Admin) theo ID người dùng (userId).
     * 
     * @param userId ID người dùng cần tìm
     * @return Đối tượng Admin nếu tìm thấy, ngược lại trả về null
     */
    public Admin findByUserId(int userId) {
        String sql = "SELECT userId, staffCode FROM Admin WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Admin(rs.getInt("userId"), rs.getString("staffCode"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn Admin theo userId=" + userId, e);
        }
        return null;
    }
}
