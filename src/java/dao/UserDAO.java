package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.MemberProfile;
import model.User;
import dto.UserContactDTO;
import dto.UserDTO;
import util.DatabaseConnection;

/**
 * UserDAO — Data Access Object cho bảng [User].
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.
 *       Không sử dụng phép cộng chuỗi (String Concatenation) để tạo SQL.</li>
 *   <li>ENG-01: Mỗi tài nguyên JDBC (Connection, PreparedStatement, ResultSet)
 *       được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>1B: lockReason được lưu trong bảng UserLockReason thay vì cột trong [User].</li>
 * </ul>
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // =========================================================================
    // AUTH CORE METHODS (dùng UserLockReason theo Phương án 1B)
    // =========================================================================

    /**
     * Tìm kiếm tài khoản người dùng theo địa chỉ email.
     * lockReason được lấy từ bảng UserLockReason (TOP 1, sắp xếp theo thời gian mới nhất).
     */
    // EARS[Event-driven]: WHEN Guest submits Login/Forgot Password Form,
    // THE LMS System SHALL Query User Data dựa trên Email [Node 5.6, 5.7]
    public User findByEmail(String email) {
        String sql = "SELECT userId, email, passwordHash, status, role, "
                + "failedLoginAttempts, lockedUntil "
                + "FROM \"User\" WHERE email = ?";

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
     * lockReason được lấy từ bảng UserLockReason (TOP 1, sắp xếp theo thời gian mới nhất).
     */
    public User findByUserId(int userId) {
        String sql = "SELECT userId, email, passwordHash, status, role, "
                + "failedLoginAttempts, lockedUntil "
                + "FROM \"User\" WHERE userId = ?";

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
     * Tìm kiếm vai trò người dùng (dùng trong cùng một connection transaction).
     */
    public String findRoleByUserId(Connection conn, int userId) throws SQLException {
        String sql = "SELECT role FROM \"User\" WHERE userId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role");
                }
            }
        }
        return "STUDENT"; // Mặc định
    }

    /**
     * Cập nhật số lần đăng nhập sai liên tiếp.
     */
    // EARS[Unwanted]: WHERE Password incorrect, THE LMS System SHALL
    // Increase failedLoginAttempts += 1 [Node 13.20]
    public void updateFailedAttempts(int userId, int attempts) {
        String sql = "UPDATE \"User\" SET failedLoginAttempts = ? WHERE userId = ?";

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
     * Ghi lý do khóa vào bảng UserLockReason thay vì cột lockReason.
     */
    // EARS[Unwanted]: WHERE failedLoginAttempts >= 5, THE LMS System SHALL
    // Execute Temp Lock (status='locked', lockedUntil=NOW+30min,
    // reason='securitybreach' in UserLockReason, failedLoginAttempts=0) [Node 15.24]
    public void lockAccount(int userId) {
        String sql = "UPDATE \"User\" SET status = 'locked', "
                + "lockedUntil = NOW() + INTERVAL '30 minutes', "
                + "failedLoginAttempts = 0 "
                + "WHERE userId = ?";
        String sqlReason = "INSERT INTO UserLockReason (userId, reason) VALUES (?, 'securitybreach')";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 PreparedStatement psReason = conn.prepareStatement(sqlReason)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                psReason.setInt(1, userId);
                psReason.executeUpdate();
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error locking account for userId=" + userId, e);
        }
    }

    /**
     * Mở khóa tài khoản — reset về trạng thái hoạt động bình thường.
     * KHÔNG xóa bản ghi trong UserLockReason để giữ audit history.
     */
    // EARS[State-driven]: WHILE status='locked' AND lockedUntil <= NOW,
    // THE LMS System SHALL update status='active', failedLoginAttempts=0 [Node 10.17]
    public void unlockAccount(int userId) {
        String sql = "UPDATE \"User\" SET status = 'active', "
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
     */
    // EARS[Event-driven]: WHERE Email tồn tại, THE LMS System SHALL
    // Generate New Password, mã hóa BCrypt VÀ update DB [Node 7.12]
    public void updatePasswordHash(int userId, String newHash) {
        String sql = "UPDATE \"User\" SET passwordHash = ? WHERE userId = ?";

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
     */
    // EARS[Event-driven]: WHERE Password is correct, THE LMS System SHALL
    // set failedLoginAttempts = 0 [Node 13.21]
    public void resetFailedAttempts(int userId) {
        String sql = "UPDATE \"User\" SET failedLoginAttempts = 0 WHERE userId = ?";

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
     */
    public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
        String sql = "INSERT INTO AuditLogs (userId, actionType, entityName, entityId, oldValues, newValues, timestamp) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

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
     * Lấy danh sách Email và Tên đầy đủ của các tài khoản đang Active
     * thuộc một hoặc nhiều Role cụ thể. Dùng để gửi Email thông báo hàng loạt.
     *
     * @param roles Danh sách role cần lấy (VD: "student", "lecturer")
     * @return Danh sách UserContactDTO, rỗng nếu không tìm thấy
     */
    public List<UserContactDTO> getActiveContactsByRoles(String... roles) {
        if (roles == null || roles.length == 0) {
            return new ArrayList<>();
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < roles.length; i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }

        String sql = "SELECT u.email, COALESCE(mp.fullName, SUBSTRING(u.email FROM 1 FOR POSITION('@' IN u.email) - 1)) AS fullName "
                + "FROM \"User\" u "
                + "LEFT JOIN MemberProfile mp ON u.userId = mp.userId "
                + "WHERE u.status = 'active' AND UPPER(u.role) IN (" + placeholders + ")";

        List<UserContactDTO> result = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < roles.length; i++) {
                ps.setString(i + 1, roles[i].toUpperCase());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new UserContactDTO(rs.getString("email"), rs.getString("fullName")));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching active contacts by roles", e);
        }
        return result;
    }

    /**
     * Hàm tiện ích nội bộ — ánh xạ một dòng ResultSet thành đối tượng User.
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("passwordHash"));
        user.setStatus(rs.getString("status"));
        user.setRole(rs.getString("role"));
        user.setFailedLoginAttempts(rs.getInt("failedLoginAttempts"));
        user.setLockedUntil(rs.getTimestamp("lockedUntil"));
        return user;
    }

    // =========================================================================
    // ADMIN USER MANAGEMENT METHODS (từ dev, cập nhật dùng UserLockReason)
    // =========================================================================

    /**
     * Truy vấn danh sách người dùng gộp thông tin DTO, hỗ trợ tìm kiếm, lọc, phân trang.
     * lockReason được lấy qua subquery từ UserLockReason.
     */
    public List<UserDTO> findAllUsers(String search, String role, String status, int offset, int limit) {
        List<UserDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT u.userId, u.email, u.status, u.role, u.failedLoginAttempts, u.lockedUntil, "
              + "p.fullName, p.phoneNumber, p.gender, p.dateOfBirth, p.startDate, p.endDate, "
              + "COALESCE(s.studentCode, l.lecturerCode, lib.staffCode, mgr.staffCode, adm.staffCode) as code, "
              + "s.major, s.enrollmentYear, l.department "
              + "FROM \"User\" u "
              + "LEFT JOIN MemberProfile p ON u.userId = p.userId "
              + "LEFT JOIN Student s ON u.userId = s.userId "
              + "LEFT JOIN Lecturer l ON u.userId = l.userId "
              + "LEFT JOIN Librarian lib ON u.userId = lib.userId "
              + "LEFT JOIN LibraryManager mgr ON u.userId = mgr.userId "
              + "LEFT JOIN Admin adm ON u.userId = adm.userId "
              + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            String likeSearch = "%" + search.trim() + "%";
            sql.append("AND (u.email LIKE ? OR p.fullName LIKE ? OR s.studentCode LIKE ? OR l.lecturerCode LIKE ? OR lib.staffCode LIKE ? OR mgr.staffCode LIKE ? OR adm.staffCode LIKE ?) ");
            for (int i = 0; i < 7; i++) {
                params.add(likeSearch);
            }
        }
        if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) {
            sql.append("AND UPPER(u.role) = ? ");
            params.add(role.trim().toUpperCase());
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND UPPER(u.status) = ? ");
            params.add(status.trim().toUpperCase());
        }

        sql.append("ORDER BY u.userId DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUserDTO(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in findAllUsers", e);
        }
        return list;
    }

    /**
     * Đếm tổng số người dùng thỏa mãn điều kiện tìm kiếm và lọc.
     */
    public int countAllUsers(String search, String role, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
              + "FROM \"User\" u "
              + "LEFT JOIN MemberProfile p ON u.userId = p.userId "
              + "LEFT JOIN Student s ON u.userId = s.userId "
              + "LEFT JOIN Lecturer l ON u.userId = l.userId "
              + "LEFT JOIN Librarian lib ON u.userId = lib.userId "
              + "LEFT JOIN LibraryManager mgr ON u.userId = mgr.userId "
              + "LEFT JOIN Admin adm ON u.userId = adm.userId "
              + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            String likeSearch = "%" + search.trim() + "%";
            sql.append("AND (u.email LIKE ? OR p.fullName LIKE ? OR s.studentCode LIKE ? OR l.lecturerCode LIKE ? OR lib.staffCode LIKE ? OR mgr.staffCode LIKE ? OR adm.staffCode LIKE ?) ");
            for (int i = 0; i < 7; i++) {
                params.add(likeSearch);
            }
        }
        if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) {
            sql.append("AND UPPER(u.role) = ? ");
            params.add(role.trim().toUpperCase());
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND UPPER(u.status) = ? ");
            params.add(status.trim().toUpperCase());
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countAllUsers", e);
        }
        return 0;
    }

    /**
     * Kiểm tra Email đã tồn tại hay chưa.
     */
    public boolean existsByEmail(String email, Integer excludeUserId) {
        String sql = "SELECT COUNT(*) FROM \"User\" WHERE email = ?";
        if (excludeUserId != null) {
            sql += " AND userId != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeUserId != null) {
                ps.setInt(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email existence", e);
        }
        return false;
    }

    /**
     * Kiểm tra Mã số định danh (studentCode/lecturerCode/staffCode) đã tồn tại hay chưa.
     */
    public boolean existsByCode(String code, String role, Integer excludeUserId) {
        String sql = "";
        if ("STUDENT".equalsIgnoreCase(role)) {
            sql = "SELECT COUNT(*) FROM Student WHERE studentCode = ?";
        } else if ("LECTURER".equalsIgnoreCase(role)) {
            sql = "SELECT COUNT(*) FROM Lecturer WHERE lecturerCode = ?";
        } else if ("LIBRARIAN".equalsIgnoreCase(role)) {
            sql = "SELECT COUNT(*) FROM Librarian WHERE staffCode = ?";
        } else if ("MANAGER".equalsIgnoreCase(role)) {
            sql = "SELECT COUNT(*) FROM LibraryManager WHERE staffCode = ?";
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            sql = "SELECT COUNT(*) FROM Admin WHERE staffCode = ?";
        } else {
            return false;
        }

        if (excludeUserId != null) {
            sql += " AND userId != ?";
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            if (excludeUserId != null) {
                ps.setInt(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking code existence", e);
        }
        return false;
    }

    /**
     * Tạo tài khoản mới cùng hồ sơ cá nhân và bảng vai trò trong 1 DB Transaction.
     * Không còn cột lockReason trong [User] — sử dụng UserLockReason khi cần.
     */
    public boolean createUserWithProfile(User user, MemberProfile profile, String code, String major, Integer enrollmentYear, String department) throws SQLException {
        Connection conn = null;
        String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, ?, ?, ?, 0)";
        String sqlProfile = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = 0;
            // 1. Insert User
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, user.getEmail());
                psUser.setString(2, user.getPasswordHash());
                psUser.setString(3, user.getStatus() != null ? user.getStatus() : "active");
                psUser.setString(4, user.getRole());
                psUser.executeUpdate();

                try (ResultSet rsUser = psUser.getGeneratedKeys()) {
                    if (rsUser.next()) {
                        userId = rsUser.getInt(1);
                    } else {
                        throw new SQLException("Creating user failed, no ID obtained.");
                    }
                }
            }
            user.setUserId(userId);

            // 2. Insert MemberProfile
            try (PreparedStatement psProfile = conn.prepareStatement(sqlProfile)) {
                psProfile.setInt(1, userId);
                psProfile.setString(2, profile.getFullName());
                psProfile.setString(3, profile.getPhoneNumber());
                psProfile.setString(4, profile.getGender());
                psProfile.setDate(5, profile.getDateOfBirth());
                psProfile.setDate(6, profile.getStartDate() != null ? profile.getStartDate() : new java.sql.Date(System.currentTimeMillis()));
                psProfile.setDate(7, profile.getEndDate() != null ? profile.getEndDate() : new java.sql.Date(System.currentTimeMillis() + 31536000000L));
                psProfile.executeUpdate();
            }

            // 3. Insert Role Table
            String sqlRole = "";
            if ("STUDENT".equalsIgnoreCase(user.getRole())) {
                sqlRole = "INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (?, ?, ?, ?)";
            } else if ("LECTURER".equalsIgnoreCase(user.getRole())) {
                sqlRole = "INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (?, ?, ?)";
            } else if ("LIBRARIAN".equalsIgnoreCase(user.getRole())) {
                sqlRole = "INSERT INTO Librarian (userId, staffCode) VALUES (?, ?)";
            } else if ("MANAGER".equalsIgnoreCase(user.getRole())) {
                sqlRole = "INSERT INTO LibraryManager (userId, staffCode) VALUES (?, ?)";
            } else if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                sqlRole = "INSERT INTO Admin (userId, staffCode) VALUES (?, ?)";
            }

            if (!sqlRole.isEmpty()) {
                try (PreparedStatement psRole = conn.prepareStatement(sqlRole)) {
                    psRole.setInt(1, userId);
                    psRole.setString(2, code);
                    if ("STUDENT".equalsIgnoreCase(user.getRole())) {
                        psRole.setString(3, major);
                        if (enrollmentYear != null) {
                            psRole.setInt(4, enrollmentYear);
                        } else {
                            psRole.setNull(4, java.sql.Types.INTEGER);
                        }
                    } else if ("LECTURER".equalsIgnoreCase(user.getRole())) {
                        psRole.setString(3, department);
                    }
                    psRole.executeUpdate();
                }
            }

            // LockReason is handled by toggleUserStatus separately if needed

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error in createUserWithProfile", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", ex);
                }
            }
        }
    }

    /**
     * Cập nhật tài khoản, hồ sơ cá nhân và bảng vai trò (sử dụng UPSERT cho Profile).
     * Thay đổi status/lockReason: nếu lockReason thay đổi, ghi vào UserLockReason.
     */
    public boolean updateUserWithProfile(User user, MemberProfile profile, String code, String major, Integer enrollmentYear, String department) throws SQLException {
        Connection conn = null;
        // Chỉ cập nhật [status] trên bảng [User] — không còn cột lockReason
        String sqlUser = "UPDATE \"User\" SET status = ? WHERE userId = ?";

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Update User status
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                psUser.setString(1, user.getStatus());
                psUser.setInt(2, user.getUserId());
                psUser.executeUpdate();
            }

            // LockReason is handled by toggleUserStatus separately if needed

            // 2. UPSERT MemberProfile (BR-15)
            boolean profileExists = false;
            String sqlCheckProfile = "SELECT COUNT(*) FROM MemberProfile WHERE userId = ?";
            try (PreparedStatement psCheckProfile = conn.prepareStatement(sqlCheckProfile)) {
                psCheckProfile.setInt(1, user.getUserId());
                try (ResultSet rsCheck = psCheckProfile.executeQuery()) {
                    if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                        profileExists = true;
                    }
                }
            }

            String sqlProfile;
            if (profileExists) {
                sqlProfile = "UPDATE MemberProfile SET fullName = ?, phoneNumber = ?, gender = ?, dateOfBirth = ? WHERE userId = ?";
            } else {
                sqlProfile = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
            }

            try (PreparedStatement psProfile = conn.prepareStatement(sqlProfile)) {
                if (profileExists) {
                    psProfile.setString(1, profile.getFullName());
                    psProfile.setString(2, profile.getPhoneNumber());
                    psProfile.setString(3, profile.getGender());
                    psProfile.setDate(4, profile.getDateOfBirth());
                    psProfile.setInt(5, user.getUserId());
                } else {
                    psProfile.setInt(1, user.getUserId());
                    psProfile.setString(2, profile.getFullName());
                    psProfile.setString(3, profile.getPhoneNumber());
                    psProfile.setString(4, profile.getGender());
                    psProfile.setDate(5, profile.getDateOfBirth());
                    psProfile.setDate(6, profile.getStartDate() != null ? profile.getStartDate() : new java.sql.Date(System.currentTimeMillis()));
                    psProfile.setDate(7, profile.getEndDate() != null ? profile.getEndDate() : new java.sql.Date(System.currentTimeMillis() + 31536000000L));
                }
                psProfile.executeUpdate();
            }

            // 3. Update Role Table
            String sqlRole = "";
            if ("STUDENT".equalsIgnoreCase(user.getRole())) {
                sqlRole = "UPDATE Student SET studentCode = ?, major = ?, enrollmentYear = ? WHERE userId = ?";
            } else if ("LECTURER".equalsIgnoreCase(user.getRole())) {
                sqlRole = "UPDATE Lecturer SET lecturerCode = ?, department = ? WHERE userId = ?";
            } else if ("LIBRARIAN".equalsIgnoreCase(user.getRole())) {
                sqlRole = "UPDATE Librarian SET staffCode = ? WHERE userId = ?";
            } else if ("MANAGER".equalsIgnoreCase(user.getRole())) {
                sqlRole = "UPDATE LibraryManager SET staffCode = ? WHERE userId = ?";
            } else if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                sqlRole = "UPDATE Admin SET staffCode = ? WHERE userId = ?";
            }

            if (!sqlRole.isEmpty()) {
                try (PreparedStatement psRole = conn.prepareStatement(sqlRole)) {
                    psRole.setString(1, code);
                    if ("STUDENT".equalsIgnoreCase(user.getRole())) {
                        psRole.setString(2, major);
                        if (enrollmentYear != null) {
                            psRole.setInt(3, enrollmentYear);
                        } else {
                            psRole.setNull(3, java.sql.Types.INTEGER);
                        }
                        psRole.setInt(4, user.getUserId());
                    } else if ("LECTURER".equalsIgnoreCase(user.getRole())) {
                        psRole.setString(2, department);
                        psRole.setInt(3, user.getUserId());
                    } else {
                        psRole.setInt(2, user.getUserId());
                    }
                    psRole.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error in updateUserWithProfile", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", ex);
                }
            }
        }
    }

    /**
     * Cập nhật nhanh trạng thái hoạt động/khóa của người dùng.
     * Nếu lockReason được cung cấp và status='locked', ghi vào UserLockReason.
     */
    public boolean updateUserStatus(int userId, String status, String lockReason) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlStatus = "UPDATE \"User\" SET status = ? WHERE userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlStatus)) {
                ps.setString(1, status);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            if ("locked".equalsIgnoreCase(status) && lockReason != null && !lockReason.trim().isEmpty()) {
                String sqlReason = "INSERT INTO UserLockReason (userId, reason) VALUES (?, ?)";
                try (PreparedStatement psReason = conn.prepareStatement(sqlReason)) {
                    psReason.setInt(1, userId);
                    psReason.setString(2, lockReason);
                    psReason.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back updateUserStatus", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error in updateUserStatus", e);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", ex);
                }
            }
        }
        return false;
    }

    /**
     * Tìm kiếm thông tin gộp UserDTO theo ID.
     */
    public UserDTO findUserDTOById(int userId) {
        String sql = "SELECT u.userId, u.email, u.status, u.role, u.failedLoginAttempts, u.lockedUntil, "
              + "p.fullName, p.phoneNumber, p.gender, p.dateOfBirth, p.startDate, p.endDate, "
              + "COALESCE(s.studentCode, l.lecturerCode, lib.staffCode, mgr.staffCode, adm.staffCode) as code, "
              + "s.major, s.enrollmentYear, l.department "
              + "FROM \"User\" u "
              + "LEFT JOIN MemberProfile p ON u.userId = p.userId "
              + "LEFT JOIN Student s ON u.userId = s.userId "
              + "LEFT JOIN Lecturer l ON u.userId = l.userId "
              + "LEFT JOIN Librarian lib ON u.userId = lib.userId "
              + "LEFT JOIN LibraryManager mgr ON u.userId = mgr.userId "
              + "LEFT JOIN Admin adm ON u.userId = adm.userId "
              + "WHERE u.userId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUserDTO(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in findUserDTOById", e);
        }
        return null;
    }

    /**
     * Ánh xạ ResultSet thành UserDTO.
     */
    private UserDTO mapResultSetToUserDTO(ResultSet rs) throws SQLException {
        UserDTO dto = new UserDTO();
        dto.setUserId(rs.getInt("userId"));
        dto.setEmail(rs.getString("email"));
        dto.setStatus(rs.getString("status"));
        dto.setRole(rs.getString("role"));
        dto.setFailedLoginAttempts(rs.getInt("failedLoginAttempts"));
        dto.setLockedUntil(rs.getTimestamp("lockedUntil"));

        dto.setFullName(rs.getString("fullName"));
        dto.setPhoneNumber(rs.getString("phoneNumber"));
        dto.setGender(rs.getString("gender"));
        dto.setDateOfBirth(rs.getDate("dateOfBirth"));
        dto.setStartDate(rs.getDate("startDate"));
        dto.setEndDate(rs.getDate("endDate"));

        dto.setCode(rs.getString("code"));
        dto.setMajor(rs.getString("major"));

        int year = rs.getInt("enrollmentYear");
        dto.setEnrollmentYear(rs.wasNull() ? null : year);

        dto.setDepartment(rs.getString("department"));
        return dto;
    }

    /**
     * Nhập danh sách tài khoản hàng loạt trong 1 Database Transaction duy nhất (All-or-Nothing).
     */
    public boolean importUsersBatch(List<UserDTO> users, String role) throws SQLException {
        Connection conn = null;
        String sqlUser = "INSERT INTO \"User\" (email, passwordHash, status, role, failedLoginAttempts) VALUES (?, ?, 'active', ?, 0)";
        String sqlProfile = "INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psProfile = conn.prepareStatement(sqlProfile)) {

                String sqlRole = "";
                if ("STUDENT".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (?, ?, ?, ?)";
                } else if ("LECTURER".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (?, ?, ?)";
                } else if ("LIBRARIAN".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO Librarian (userId, staffCode) VALUES (?, ?)";
                } else if ("MANAGER".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO LibraryManager (userId, staffCode) VALUES (?, ?)";
                } else if ("ADMIN".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO Admin (userId, staffCode) VALUES (?, ?)";
                }

                PreparedStatement psRole = null;
                try {
                    if (!sqlRole.isEmpty()) {
                        psRole = conn.prepareStatement(sqlRole);
                    }

                    for (UserDTO u : users) {
                        // 1. Insert User
                        psUser.setString(1, u.getEmail());
                        psUser.setString(2, u.getPasswordHash());
                        psUser.setString(3, role);
                        psUser.executeUpdate();

                        int userId = 0;
                        try (ResultSet rsUser = psUser.getGeneratedKeys()) {
                            if (rsUser.next()) {
                                userId = rsUser.getInt(1);
                            } else {
                                throw new SQLException("Creating user failed during batch import, no ID obtained.");
                            }
                        }

                        // 2. Insert Profile
                        psProfile.setInt(1, userId);
                        psProfile.setString(2, u.getFullName());
                        psProfile.setString(3, u.getPhoneNumber() != null ? u.getPhoneNumber() : "");
                        psProfile.setString(4, u.getGender() != null ? u.getGender() : "Khác");
                        psProfile.setDate(5, u.getDateOfBirth() != null ? u.getDateOfBirth() : new java.sql.Date(System.currentTimeMillis()));
                        psProfile.setDate(6, new java.sql.Date(System.currentTimeMillis()));
                        if ("STUDENT".equalsIgnoreCase(role)) {
                            java.time.LocalDate localStartDate = java.time.LocalDate.now();
                            psProfile.setDate(7, java.sql.Date.valueOf(localStartDate.plusYears(4)));
                        } else {
                            psProfile.setDate(7, new java.sql.Date(System.currentTimeMillis() + 31536000000L));
                        }
                        psProfile.executeUpdate();

                        // 3. Insert Role Table
                        if (psRole != null) {
                            psRole.setInt(1, userId);
                            psRole.setString(2, u.getCode());
                            if ("STUDENT".equalsIgnoreCase(role)) {
                                psRole.setString(3, u.getMajor());
                                if (u.getEnrollmentYear() != null) {
                                    psRole.setInt(4, u.getEnrollmentYear());
                                } else {
                                    psRole.setNull(4, java.sql.Types.INTEGER);
                                }
                            } else if ("LECTURER".equalsIgnoreCase(role)) {
                                psRole.setString(3, u.getDepartment());
                            }
                            psRole.executeUpdate();
                        }
                    }
                } finally {
                    if (psRole != null) {
                        psRole.close();
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back batch import transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error in importUsersBatch", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", ex);
                }
            }
        }
    }

    // =========================================================================
    // F6 DESK CIRCULATION METHODS (từ nhánh Thai)
    // =========================================================================

    /**
     * Cập nhật trạng thái tài khoản thành 'active' sau khi người dùng thanh toán
     * hết nợ phạt.
     *
     * <p>Được gọi bởi {@code DeskCirculationService} trong luồng thu tiền phạt
     * (FR-F6-08 — Node 8.x): Khi không còn bản ghi nào trong {@code UserLockReason}
     * có reason='unpaid', tài khoản sẽ được mở khóa tự động.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID người dùng cần cập nhật trạng thái
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    public void updateStatusToLocked(Connection conn, int userId) throws SQLException {
        String sql = "UPDATE \"User\" "
                   + "SET    status = 'locked' "
                   + "WHERE  userId  = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật [User].status thành 'locked' cho userId=" + userId, e);
            throw e;
        }
    }

    // EARS[Condition-driven]: WHERE COUNT UserLockReason == 0 after payment,
    // THE LMS System SHALL UPDATE [User].status = 'active' [FR-F6-08, BR-25]
    public void updateStatusToActive(Connection conn, int userId) throws SQLException {
        String sql = "UPDATE \"User\" "
                   + "SET    status = 'active' "
                   + "WHERE  userId  = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật [User].status thành 'active' cho userId=" + userId, e);
            throw e;
        }
    }

    // =========================================================================
    // MANAGER DASHBOARD KPI METHOD
    // =========================================================================

    /**
     * Đếm số thành viên hoạt động (status='active', role IN STUDENT/LECTURER).
     * Dùng cho KPI card "Thành viên hoạt động" trên Manager Dashboard.
     *
     * @param conn Connection đọc
     * @return Số lượng thành viên active
     * @throws SQLException nếu có lỗi truy vấn
     */
    public int countActiveMembers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM \"User\" "
                   + "WHERE status = 'active' "
                   + "  AND role IN ('STUDENT', 'LECTURER')";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số thành viên hoạt động", e);
            throw e;
        }
        return 0;
    }
}
