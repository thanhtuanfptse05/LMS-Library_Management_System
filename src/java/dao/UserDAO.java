package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import util.DatabaseConnection;

/**
 * UserDAO — Data Access Object cho bảng [User].
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.
 *       Không sử dụng phép cộng chuỗi (String Concatenation) để tạo SQL.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC (Connection, PreparedStatement, ResultSet)
 *       được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 * </ul>
 *
 * <p>Traceability: Mỗi hàm được mapping với EARS pattern và Node ID
 * từ SPEC.md và ActivityDiagramF1.txt.</p>
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Tìm kiếm tài khoản người dùng theo địa chỉ email.
     *
     * <p>Sử dụng cho cả luồng Login [Node 5.6] và Forgot Password [Node 5.7].</p>
     *
     * @param email Địa chỉ email cần tìm
     * @return Đối tượng {@link User} nếu tìm thấy, {@code null} nếu không tồn tại
     */
    // EARS[Event-driven]: WHEN Guest submits Login/Forgot Password Form,
    // THE LMS System SHALL Query User Data dựa trên Email [Node 5.6, 5.7]
    public User findByEmail(String email) {
        String sql = "SELECT userId, email, passwordHash, [status], [role], "
                + "failedLoginAttempts, lockedUntil "
                + "FROM [User] WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error querying user by email", e);
        }
        return null;
    }

    /**
     * Tìm kiếm tài khoản người dùng theo ID tài khoản.
     *
     * @param userId ID tài khoản cần tìm
     * @return Đối tượng User nếu tìm thấy, null nếu không tồn tại
     */
    public User findByUserId(int userId) {
        String sql = "SELECT userId, email, passwordHash, [status], [role], "
                + "failedLoginAttempts, lockedUntil "
                + "FROM [User] WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error querying user by userId=" + userId, e);
        }
        return null;
    }


    /**
     * Cập nhật số lần đăng nhập sai liên tiếp.
     *
     * <p>Được gọi khi người dùng nhập sai mật khẩu [Node 13.20].</p>
     *
     * @param userId   ID tài khoản cần cập nhật
     * @param attempts Số lần đăng nhập sai mới
     */
    // EARS[Unwanted]: WHERE Password incorrect, THE LMS System SHALL
    // Increase failedLoginAttempts += 1 [Node 13.20]
    public void updateFailedAttempts(int userId, int attempts) {
        String sql = "UPDATE [User] SET failedLoginAttempts = ? WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attempts);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating failed login attempts for userId=" + userId, e);
        }
    }

    /**
     * Khóa tài khoản tạm thời 30 phút do nhập sai mật khẩu quá 5 lần.
     *
     * <p>Cập nhật đồng thời trạng thái khóa, thời điểm mở khóa và số lần đăng nhập sai.
     * lockedUntil = NOW + 30 phút (tính bằng DATEADD phía SQL Server để tránh
     * timezone mismatch giữa JVM và DB), failedLoginAttempts = 0.</p>
     *
     * @param userId ID tài khoản cần khóa
     */
    // EARS[Unwanted]: WHERE failedLoginAttempts >= 5, THE LMS System SHALL
    // Execute Temp Lock (status='locked', lockedUntil=NOW+30min,
    // failedLoginAttempts=0) [Node 15.24]
    public void lockAccount(int userId) {
        String sql = "UPDATE [User] SET [status] = 'locked', "
                + "lockedUntil = DATEADD(minute, 30, GETDATE()), "
                + "failedLoginAttempts = 0 "
                + "WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error locking account for userId=" + userId, e);
        }
    }

    /**
     * Mở khóa tài khoản — reset về trạng thái hoạt động bình thường.
     *
     * <p>Được gọi khi phát hiện {@code lockedUntil <= NOW} tại thời điểm
     * đăng nhập [Node 10.17], hoặc khi Admin chủ động mở khóa.</p>
     *
     * @param userId ID tài khoản cần mở khóa
     */
    // EARS[State-driven]: WHILE status='locked' AND lockedUntil <= NOW,
    // THE LMS System SHALL update status='active',
    // failedLoginAttempts=0 [Node 10.17]
    public void unlockAccount(int userId) {
        String sql = "UPDATE [User] SET [status] = 'active', "
                + "lockedUntil = NULL, "
                + "failedLoginAttempts = 0 "
                + "WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unlocking account for userId=" + userId, e);
        }
    }

    /**
     * Cập nhật mật khẩu đã mã hóa BCrypt vào cơ sở dữ liệu.
     *
     * <p>Dùng cho luồng Quên mật khẩu sau khi sinh mật khẩu ngẫu nhiên 8 ký tự
     * và mã hóa BCrypt [Node 7.12].</p>
     *
     * <p>Lưu ý: Hàm này nhận vào hash đã mã hóa, KHÔNG nhận plaintext.
     * Việc mã hóa BCrypt phải được thực hiện tại tầng Service (AuthService).</p>
     *
     * @param userId  ID tài khoản cần đổi mật khẩu
     * @param newHash Chuỗi BCrypt hash mới (đã mã hóa)
     */
    // EARS[Event-driven]: WHERE Email tồn tại, THE LMS System SHALL
    // Generate New Password, mã hóa BCrypt VÀ update DB [Node 7.12]
    public void updatePasswordHash(int userId, String newHash) {
        String sql = "UPDATE [User] SET passwordHash = ? WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password hash for userId=" + userId, e);
        }
    }

    /**
     * Reset số lần đăng nhập sai về 0 sau khi đăng nhập thành công.
     *
     * @param userId ID tài khoản vừa đăng nhập thành công
     */
    // EARS[Event-driven]: WHERE Password is correct, THE LMS System SHALL
    // set failedLoginAttempts = 0 [Node 13.21]
    public void resetFailedAttempts(int userId) {
        String sql = "UPDATE [User] SET failedLoginAttempts = 0 WHERE userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error resetting failed attempts for userId=" + userId, e);
        }
    }

    /**
     * Ghi Audit Log vào bảng AuditLogs.
     *
     * @param userId     ID tài khoản thực hiện hành động (có thể null)
     * @param actionType Loại hành động (ví dụ: 'CHANGE_PASSWORD', 'RESET_PASSWORD')
     * @param entityName Tên bảng hoặc thực thể chịu tác động
     * @param entityId   ID của thực thể chịu tác động (có thể null)
     * @param oldValues  Giá trị cũ dưới dạng JSON/Text (có thể null)
     * @param newValues  Giá trị mới dưới dạng JSON/Text (có thể null)
     */
    public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
        String sql = "INSERT INTO AuditLogs (userId, actionType, [entityName], [entityId], oldValues, newValues, [timestamp]) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, actionType);
            ps.setString(3, entityName);
            if (entityId != null) {
                ps.setInt(4, entityId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, oldValues);
            ps.setString(6, newValues);

            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting audit log for action=" + actionType, e);
        }
    }

    /**
     * Hàm tiện ích nội bộ — ánh xạ một dòng ResultSet thành đối tượng User.
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng User đã được populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu từ ResultSet
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("passwordHash"));
        user.setStatus(rs.getString("status"));
        user.setRole(rs.getString("role"));
        user.setLockReason(null);
        user.setFailedLoginAttempts(rs.getInt("failedLoginAttempts"));
        user.setLockedUntil(rs.getTimestamp("lockedUntil"));
        return user;
    }
}
