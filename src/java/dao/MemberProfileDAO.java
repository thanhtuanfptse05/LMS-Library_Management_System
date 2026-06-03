package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.MemberProfile;
import util.DatabaseConnection;

/**
 * MemberProfileDAO — Data Access Object for MemberProfile table.
 */
public class MemberProfileDAO {

    private static final Logger LOGGER = Logger.getLogger(MemberProfileDAO.class.getName());

    /**
     * Find profile by userId.
     */
    public MemberProfile findByUserId(int userId) {
        String sql = "SELECT userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate FROM MemberProfile WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MemberProfile profile = new MemberProfile();
                    profile.setUserId(rs.getInt("userId"));
                    profile.setFullName(rs.getString("fullName"));
                    profile.setPhoneNumber(rs.getString("phoneNumber"));
                    profile.setGender(rs.getString("gender"));
                    profile.setDateOfBirth(rs.getDate("dateOfBirth"));
                    profile.setStartDate(rs.getDate("startDate"));
                    profile.setEndDate(rs.getDate("endDate"));
                    return profile;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error querying member profile by userId=" + userId, e);
        }
        return null;
    }

    /**
     * Upsert profile (Insert if not exists, Update if exists).
     */
    public boolean upsertProfile(MemberProfile profile) {
        boolean exists = false;
        String checkSql = "SELECT COUNT(*) FROM MemberProfile WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, profile.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking existence of member profile for userId=" + profile.getUserId(), e);
            return false;
        }

        if (exists) {
            String updateSql = "UPDATE MemberProfile SET fullName = ?, phoneNumber = ?, gender = ?, dateOfBirth = ? WHERE userId = ?";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, profile.getFullName());
                ps.setString(2, profile.getPhoneNumber());
                ps.setString(3, profile.getGender());
                ps.setDate(4, profile.getDateOfBirth());
                ps.setInt(5, profile.getUserId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error updating member profile for userId=" + profile.getUserId(), e);
            }
        } else {
            String insertSql = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, profile.getUserId());
                ps.setString(2, profile.getFullName());
                ps.setString(3, profile.getPhoneNumber());
                ps.setString(4, profile.getGender());
                ps.setDate(5, profile.getDateOfBirth());
                // Default membership start/end dates if not specified (e.g. today to one year from now)
                ps.setDate(6, profile.getStartDate() != null ? profile.getStartDate() : new java.sql.Date(System.currentTimeMillis()));
                ps.setDate(7, profile.getEndDate() != null ? profile.getEndDate() : new java.sql.Date(System.currentTimeMillis() + 31536000000L)); // 1 year
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error inserting member profile for userId=" + profile.getUserId(), e);
            }
        }
        return false;
    }
}
