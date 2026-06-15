package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Admin;
import util.DatabaseConnection;

// Verified compatibility with PostgreSQL
public class AdminDAO {
    private static final Logger LOGGER = Logger.getLogger(AdminDAO.class.getName());

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
            LOGGER.log(Level.SEVERE, "Error querying Admin by userId=" + userId, e);
        }
        return null;
    }
}
