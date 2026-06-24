package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Lecturer;
import util.DatabaseConnection;

/**
 * LecturerDAO — Đối tượng truy cập dữ liệu (DAO) cho bảng Lecturer.
 */
// Đã xác minh tính tương thích với PostgreSQL
public class LecturerDAO {
    private static final Logger LOGGER = Logger.getLogger(LecturerDAO.class.getName());

    /**
     * Tìm kiếm thông tin Giảng viên (Lecturer) theo ID người dùng (userId).
     * 
     * @param userId ID người dùng cần tìm
     * @return Đối tượng Lecturer nếu tìm thấy, ngược lại trả về null
     */
    public Lecturer findByUserId(int userId) {
        String sql = "SELECT userId, lecturerCode, department FROM Lecturer WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Lecturer(rs.getInt("userId"), rs.getString("lecturerCode"), rs.getString("department"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn Lecturer theo userId=" + userId, e);
        }
        return null;
    }
}
