package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * UserLockReasonDAO — Data Access Object cho bảng [UserLockReason].
 *
 * <p>Bảng {@code UserLockReason} lưu các lý do khóa tài khoản của người dùng.
 * Một tài khoản có thể bị khóa bởi nhiều lý do đồng thời (ví dụ: 'adminban',
 * 'securitybreach'). Việc giải quyết một lý do chỉ xóa
 * đúng bản ghi lý do đó, KHÔNG tự động mở khóa tài khoản nếu còn lý do khác.</p>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.
 *       Không sử dụng phép cộng chuỗi (String Concatenation) để tạo SQL.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC (PreparedStatement, ResultSet)
 *       được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>TRANS-01: Mọi hàm nhận {@code Connection} từ tham số để hỗ trợ
 *       Atomic Transaction được kiểm soát từ tầng Service.</li>
 * </ul>
 *
 * <p>Traceability: Mapping với Activity Diagram F6 — Node 5.26, 6.27, 7.28.</p>
 */
public class UserLockReasonDAO {

    private static final Logger LOGGER = Logger.getLogger(UserLockReasonDAO.class.getName());

    public boolean hasReason(int userId, String reason) {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? AND reason = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Không thể kiểm tra lý do khóa cho userId=" + userId, e);
            return false;
        }
    }

    /**
     * Kiểm tra xem người dùng có bất kỳ lý do khóa nào KHÁC 'unpaid' không (ví dụ: admin khóa tay, securitybreach).
     */
    public boolean hasNonUnpaidReason(int userId) {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? AND reason != 'unpaid' LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra lý do khóa khác unpaid cho userId=" + userId, e);
            return false;
        }
    }

    public boolean hasNonUnpaidReason(Connection conn, int userId) throws SQLException {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? AND reason != 'unpaid' LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra xem người dùng có lý do khóa do phạt quá hạn nhận sách đặt trước không.
     */
    public boolean hasReservationPenaltyReason(int userId) {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? AND (reason LIKE '%quá hạn nhận sách đặt trước%' OR reason LIKE '%ReservationID%') LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra lý do khóa reservation penalty cho userId=" + userId, e);
            return false;
        }
    }

    /**
     * Kiểm tra xem người dùng có lý do khóa BẢO MẬT hoặc ADMIN (chặn login hoàn toàn) không.
     * Lý do được phép login (có warning): 'unpaid' và 'Tự động khóa 7 ngày do quá hạn nhận sách đặt trước...'
     */
    public boolean hasBlockingSecurityOrAdminReason(int userId) {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? "
                   + "AND reason != 'unpaid' "
                   + "AND reason NOT LIKE '%quá hạn nhận sách đặt trước%' "
                   + "AND reason NOT LIKE '%ReservationID%' LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra lý do khóa blocking cho userId=" + userId, e);
            return true;
        }
    }

    /**
     * Đếm tổng số lý do khóa hiện tại của một tài khoản người dùng.
     *
     * <p>Được gọi sau khi xóa lý do 'unpaid' (Node 6.27) để quyết định có
     * tự động mở khóa tài khoản hay không. Nếu COUNT == 0 thì mở khóa;
     * nếu COUNT {@literal >} 0 thì tài khoản vẫn bị khóa bởi lý do khác
     * (ví dụ: 'adminban', 'securitybreach').</p>
     *
     * <p><strong>Lưu ý Transaction:</strong> Hàm này nhận {@code Connection} từ
     * tham số để đảm bảo việc đếm và quyết định mở khóa xảy ra trong cùng
     * một DB Transaction với thao tác DELETE trước đó, tránh race condition.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID tài khoản cần kiểm tra
     * @return Số lượng bản ghi lý do khóa còn lại; trả về {@code 0}
     *         nếu không còn lý do nào hoặc xảy ra lỗi đọc ResultSet
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Payment is processed,
    // THE LMS System SHALL COUNT remaining UserLockReason records
    // to evaluate auto-unlock condition [Node 6.27]
    public int countLockReasonsByUserId(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM UserLockReason WHERE userId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi đếm số lý do khóa tài khoản cho userId=" + userId, e);
            throw e;
        }

        return 0;
    }



    /**
     * Lấy danh sách các lý do khóa của người dùng dưới dạng danh sách các chuỗi.
     *
     * @param conn   Connection kết nối cơ sở dữ liệu
     * @param userId ID người dùng cần lấy các lý do khóa
     * @return Danh sách các lý do khóa dưới dạng chuỗi (ví dụ: 'unpaid', 'securitybreach')
     * @throws SQLException nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public java.util.List<String> getReasonsByUserId(Connection conn, int userId) throws SQLException {
        java.util.List<String> reasons = new java.util.ArrayList<>();
        String sql = "SELECT reason FROM UserLockReason WHERE userId = ? ORDER BY createdAt ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reasons.add(rs.getString("reason"));
                }
            }
        }
        return reasons;
    }

    /**
     * Kiểm tra xem người dùng có lý do khóa cụ thể nào không (dùng Connection truyền vào).
     */
    public boolean hasReason(Connection conn, int userId, String reason) throws SQLException {
        String sql = "SELECT 1 FROM UserLockReason WHERE userId = ? AND reason = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra lý do khóa cho userId=" + userId + " và reason=" + reason, e);
            throw e;
        }
    }

    /**
     * Thêm lý do khóa cho người dùng (dùng Connection truyền vào).
     */
    public void insertLockReason(Connection conn, int userId, String reason) throws SQLException {
        String sql = "INSERT INTO UserLockReason (userId, reason, createdAt) VALUES (?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm lý do khóa cho userId=" + userId + " và reason=" + reason, e);
            throw e;
        }
    }

    /**
     * Xóa lý do khóa của người dùng (dùng Connection truyền vào).
     */
    public void deleteLockReason(Connection conn, int userId, String reason) throws SQLException {
        String sql = "DELETE FROM UserLockReason WHERE userId = ? AND reason = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa lý do khóa cho userId=" + userId + " và reason=" + reason, e);
            throw e;
        }
    }
}


