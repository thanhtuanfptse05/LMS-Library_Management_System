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
 * StudentDAO — Data Access Object for Student table.
 */
// Verified compatibility with PostgreSQL
public class StudentDAO {

    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());

    /**
     * Find student by userId.
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
            LOGGER.log(Level.SEVERE, "Error querying student by userId=" + userId, e);
        }
        return null;
    }
}
