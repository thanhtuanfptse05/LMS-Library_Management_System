package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Student;
import util.DatabaseConnection;

/**
 * StudentDAO — Đối tượng truy cập dữ liệu (DAO) cho bảng Student.
 */
// Đã xác minh tính tương thích với PostgreSQL
public class StudentDAO {

    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());

    /**
     * Tìm kiếm sinh viên theo ID người dùng (userId).
     * 
     * @param userId ID người dùng cần tìm
     * @return Đối tượng Student nếu tìm thấy, ngược lại trả về null
     */
    public Student findByUserId(int userId) {
        String sql = "SELECT userId, studentCode, major, enrollmentYear FROM Student WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    student.setUserId(rs.getInt("userId"));
                    student.setStudentCode(rs.getString("studentCode"));
                    student.setMajor(rs.getString("major"));
                    student.setEnrollmentYear(rs.getInt("enrollmentYear"));
                    return student;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn sinh viên theo userId=" + userId, e);
        }
        return null;
    }
}
