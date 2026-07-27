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
 * MemberProfileDAO — Đối tượng truy cập dữ liệu (DAO) cho bảng MemberProfile.
 */
// Đã xác minh tính tương thích với PostgreSQL
public class MemberProfileDAO {

    private static final Logger LOGGER = Logger.getLogger(MemberProfileDAO.class.getName());

    /**
     * Tìm kiếm hồ sơ thành viên theo ID người dùng.
     * 
     * @param userId ID người dùng cần tìm
     * @return Đối tượng MemberProfile nếu tìm thấy, ngược lại trả về null
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
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn hồ sơ thành viên theo userId=" + userId, e);
        }
        return null;
    }

    /**
     * Cập nhật thông tin hồ sơ cá nhân của thành viên.
     * 
     * @param profile Đối tượng MemberProfile chứa thông tin cập nhật
     * @return true nếu cập nhật thành công, ngược lại trả về false
     */
    public boolean updateProfile(MemberProfile profile) {
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
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật hồ sơ thành viên theo userId=" + profile.getUserId(), e);
            return false;
        }
    }

    /**
     * Alias giữ tương thích cho upsertProfile.
     */
    public boolean upsertProfile(MemberProfile profile) {
        return updateProfile(profile);
    }

    /**
     * Lấy số lượng lượt mượn sách đang hoạt động (Đang mượn hoặc Quá hạn).
     * 
     * @param userId ID người dùng
     * @return Số lượng lượt mượn sách đang hoạt động
     */
    public int getActiveLoansCount(int userId) {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND status IN ('borrowed', 'overdue')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi đếm số sách đang mượn hoạt động theo userId=" + userId, e);
        }
        return 0;
    }

    /**
     * Lấy số lượng yêu cầu đặt trước sách đang hoạt động (Đang chờ hoặc Sẵn sàng lấy).
     * 
     * @param userId ID người dùng
     * @return Số lượng yêu cầu đặt trước đang hoạt động
     */
    public int getActiveReservationsCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Reservation WHERE userId = ? AND status IN ('pending', 'readypickup')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi đếm số lượng đặt trước hoạt động theo userId=" + userId, e);
        }
        return 0;
    }
}
