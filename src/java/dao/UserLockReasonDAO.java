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
 * Một tài khoản có thể bị khóa bởi nhiều lý do đồng thời (ví dụ: 'unpaid', 'adminban',
 * 'securitybreach'). Việc giải quyết một lý do (ví dụ: đóng tiền phạt) chỉ xóa
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
     *
     * @see #deleteUnpaidReasonByUserId(Connection, int)
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
     * Xóa bản ghi lý do khóa 'unpaid' của một tài khoản người dùng.
     *
     * <p>Được gọi trong luồng Duyệt Thanh Toán Tiền Mặt (Node 5.26) sau khi
     * cập nhật {@code Payment} và {@code Fine} thành công. Chỉ xóa đúng bản ghi
     * có {@code reason = 'unpaid'} — KHÔNG ảnh hưởng đến các lý do khóa khác
     * như 'adminban' hay 'securitybreach'.</p>
     *
     * <p><strong>Lưu ý Transaction:</strong> Hàm này nhận {@code Connection} từ
     * tham số và KHÔNG tự commit. Việc commit/rollback được kiểm soát hoàn toàn
     * bởi {@code DeskCirculationService} để đảm bảo tính nguyên tử của toàn bộ
     * luồng thanh toán (BR-25).</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID tài khoản cần gỡ lý do khóa 'unpaid'
     * @throws SQLException nếu có lỗi thực thi câu lệnh DELETE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see #countLockReasonsByUserId(Connection, int)
     */
    // EARS[Event-driven]: WHEN Cash Payment is approved,
    // THE LMS System SHALL DELETE UserLockReason record WHERE reason = 'unpaid'
    // for the paying user [Node 5.26]
    public void deleteUnpaidReasonByUserId(Connection conn, int userId) throws SQLException {
        String sql = "DELETE FROM UserLockReason WHERE userId = ? AND reason = 'unpaid'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi xóa lý do khóa 'unpaid' cho userId=" + userId, e);
            throw e;
        }
    }

    /**
     * Kiểm tra nhanh xem tài khoản có đang có lý do khóa 'unpaid' hay không.
     *
     * <p>Được gọi là bước đầu tiên trong luồng Check-out (Node 6.6) để
     * thực thi BR-22: nếu tài khoản đang nợ phạt, từ chối giao dịch ngay lập tức
     * mà không cần thực thi bất kỳ thao tác ghi nào.</p>
     *
     * <p>Khác biệt so với {@link #countLockReasonsByUserId(Connection, int)}:
     * hàm này chỉ kiểm tra sự tồn tại của lý do 'unpaid', không đếm tổng.
     * Phù hợp cho gate-check nghiệp vụ cần kết quả boolean rõ ràng.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số để đảm bảo việc kiểm tra nằm trong cùng
     * Transaction với các thao tác ghi tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID tài khoản cần kiểm tra
     * @return {@code true} nếu tồn tại bản ghi với {@code reason = 'unpaid'};
     *         {@code false} nếu không có nợ phạt
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see #deleteUnpaidReasonByUserId(Connection, int)
     */
    // EARS[Condition-driven]: WHERE Check-out request arrives,
    // THE LMS System SHALL check IF UserLockReason WHERE userId=? AND reason='unpaid' EXISTS
    // to enforce BR-22 [Node 6.6, FR-F6-01]
    public boolean hasUnpaidReason(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) "
                   + "FROM   UserLockReason "
                   + "WHERE  userId = ? "
                   + "  AND  reason = 'unpaid'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi kiểm tra lý do khóa 'unpaid' cho userId=" + userId, e);
            throw e;
        }

        return false;
    }

    /**
     * Thêm mới bản ghi lý do khóa 'unpaid' cho một tài khoản người dùng.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04 — Node 6.17)
     * sau khi INSERT {@code Fine} thành công. Việc INSERT lý do khóa NÀY là bằng chứng
     * rõ ràng cho hệ thống biết tài khoản có nợ phạt chưa thanh toán (BR-24).
     * Sau đó thủ thư gọi {@code UserDAO.updateStatusToLocked} để khóa tài khoản
     * trong cùng Transaction.</p>
     *
     * <p><strong>Khác biệt so với deleteUnpaidReasonByUserId:</strong>
     * Hàm này thêm mới lý do khóa (tạo ra nợ phạt mới),
     * ngược lại {@link #deleteUnpaidReasonByUserId(Connection, int)}
     * xóa lý do khóa (giải quyết nợ phạt).</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID tài khoản cần thêm lý do khóa 'unpaid'
     * @throws SQLException nếu có lỗi thực thi câu lệnh INSERT,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.FineDAO#insertCompensationFine(Connection, int, int, java.math.BigDecimal, String)
     * @see dao.UserDAO#updateStatusToLocked(Connection, int)
     */
    // EARS[Event-driven]: WHEN Fine is inserted for damaged/lost book,
    // THE LMS System SHALL INSERT UserLockReason (reason='unpaid')
    // WHERE userId = ? [Node 6.17, FR-F6-04, BR-24]
    public void insertUnpaidReason(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO UserLockReason (userId, reason) "
                   + "VALUES (?, 'unpaid')";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi INSERT lý do khóa 'unpaid' cho userId=" + userId, e);
            throw e;
        }
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách lý do khóa cho userId=" + userId, e);
            throw e;
        }
        return reasons;
    }
}

