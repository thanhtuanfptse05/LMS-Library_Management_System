package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * PaymentDAO — Data Access Object cho bảng [Payment].
 *
 * <p>Bảng {@code Payment} lưu thông tin các giao dịch thanh toán tiền phạt.
 * Mỗi bản ghi Payment liên kết với một bản ghi {@code Fine} và theo dõi
 * trạng thái xử lý: 'pending' (đang chờ), 'completed' (đã hoàn tất),
 * 'canceled' (đã hủy).</p>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.
 *       Không sử dụng phép cộng chuỗi (String Concatenation) để tạo SQL.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC (PreparedStatement)
 *       được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>TRANS-01: Mọi hàm nhận {@code Connection} từ tham số để hỗ trợ
 *       Atomic Transaction được kiểm soát từ tầng Service. Hàm KHÔNG tự commit.</li>
 * </ul>
 *
 * <p>Traceability: Mapping với Activity Diagram F6 — Luồng Duyệt Thanh Toán
 * Tiền Mặt (FR-F6-07, PLAN.md §3).</p>
 */
public class PaymentDAO {

    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());

    /**
     * Cập nhật trạng thái của một đơn Payment thành 'completed'.
     *
     * <p>Được gọi là bước đầu tiên trong luồng Duyệt Thanh Toán Tiền Mặt
     * (FR-F6-07). Thủ thư xác nhận đã nhận đủ tiền mặt từ độc giả, hệ thống
     * ghi nhận Payment là hoàn tất. Bước này PHẢI xảy ra trước khi cập nhật
     * trạng thái {@code Fine} (xem {@code FineDAO#updateStatusToPaid}) trong
     * cùng một DB Transaction.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit. Việc commit/rollback
     * được kiểm soát hoàn toàn bởi {@code DeskCirculationService} để đảm bảo
     * tính nguyên tử của toàn bộ luồng thanh toán (PLAN.md §3 — Atomic Block).</p>
     *
     * @param conn      {@code Connection} được quản lý bởi tầng Service
     *                  (đã {@code setAutoCommit(false)})
     * @param paymentId ID của bản ghi Payment cần cập nhật trạng thái
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.FineDAO#updateStatusToPaid(Connection, int)
     */
    // EARS[Event-driven]: WHEN Librarian approves cash payment,
    // THE LMS System SHALL UPDATE Payment.status = 'completed'
    // WHERE paymentId matches [FR-F6-07, PLAN.md §3]
    public void updateStatusToCompleted(Connection conn, int paymentId) throws SQLException {
        String sql = "UPDATE Payment SET status = 'completed' WHERE paymentId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật trạng thái Payment thành 'completed' cho paymentId=" + paymentId, e);
            throw e;
        }
    }

    /**
     * Lấy {@code fineId} liên kết với một giao dịch Payment.
     *
     * <p>Được gọi là bước đầu tiên trong luồng Duyệt Thanh Toán (FR-F6-07)
     * để giải quyết bài toán: {@code approveCashPayment} nhận {@code paymentId},
     * nhưng {@code FineDAO.updateStatusToPaid} cần {@code fineId}.
     * Hàm này là cầu nối duy nhất giữa hai bảng trong luồng thanh toán.</p>
     *
     * <p>Nếu hàm trả về {@code -1}, tầng Service ném
     * {@code IllegalStateException} để Controller hiển thị thông báo lỗi
     * "Phiếu thanh toán không tồn tại" (SPEC §6 — Error Handling).</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm nhận
     * {@code Connection} từ tham số để đảm bảo việc đọc xảy ra trong cùng
     * Transaction với các thao tác ghi tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn      {@code Connection} được quản lý bởi tầng Service
     *                  (đã {@code setAutoCommit(false)})
     * @param paymentId ID của giao dịch Payment cần tra cứu
     * @return {@code fineId} liên kết với Payment này;
     *         {@code -1} nếu không tìm thấy bản ghi Payment tương ứng
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.FineDAO#updateStatusToPaid(Connection, int)
     */
    // EARS[Event-driven]: WHEN Librarian approves cash payment,
    // THE LMS System SHALL find fineId FROM [Payment] WHERE paymentId = ?
    // to bridge Payment → Fine update in same Transaction [FR-F6-07]
    public int findFineIdByPaymentId(Connection conn, int paymentId) throws SQLException {
        String sql = "SELECT fineId FROM Payment WHERE paymentId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("fineId");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu fineId cho paymentId=" + paymentId, e);
            throw e;
        }

        return -1;
    }

    /**
     * Tạo mới một bản ghi Payment (phiếu thanh toán) ở trạng thái 'pending' (chờ thu tiền).
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04) để sinh ra bản ghi
     * thanh toán liên kết với Fine vừa được tạo, giúp giải phóng luồng thanh toán tiền mặt.</p>
     *
     * @param conn   {@code Connection} trong Transaction
     * @param fineId ID của khoản phạt liên kết
     * @param amount Số tiền phạt cần đóng
     * @param status Trạng thái ban đầu (thường là 'pending')
     * @return ID của bản ghi Payment vừa được tạo (GENERATED KEY)
     * @throws SQLException nếu có lỗi thực thi câu lệnh INSERT
     */
    public int insertPayment(Connection conn, int fineId, java.math.BigDecimal amount, String status)
            throws SQLException {
        String sql = "INSERT INTO Payment (fineId, paidAmount, paymentMethod, status, paidAt) "
                   + "VALUES (?, ?, 'Cash', ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fineId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, status);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi INSERT Payment mới cho fineId=" + fineId, e);
            throw e;
        }

        throw new SQLException("INSERT Payment thất bại: không lấy được generated key.");
    }
}
