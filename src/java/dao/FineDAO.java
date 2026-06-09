package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * FineDAO — Data Access Object cho bảng [Fine].
 *
 * <p>Bảng {@code Fine} lưu thông tin các khoản tiền phạt phát sinh từ việc
 * trả sách trễ, trả sách bị hỏng, hoặc mất sách. Mỗi bản ghi Fine liên kết
 * với một {@code BorrowRecord} và một {@code User}. Trạng thái có thể là:
 * 'unpaid' (chưa thanh toán) hoặc 'paid' (đã thanh toán).</p>
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
 * Tiền Mặt (FR-F6-07) và Luồng Nhận Sách Hỏng/Mất (FR-F6-04).</p>
 */
public class FineDAO {

    private static final Logger LOGGER = Logger.getLogger(FineDAO.class.getName());

    /**
     * Cập nhật trạng thái của một khoản phạt thành 'paid' (đã thanh toán).
     *
     * <p>Được gọi là bước thứ hai trong luồng Duyệt Thanh Toán Tiền Mặt
     * (FR-F6-07), ngay sau khi {@code PaymentDAO#updateStatusToCompleted}
     * thực thi thành công. Việc cập nhật Fine và Payment phải xảy ra trong
     * cùng một DB Transaction để đảm bảo tính nhất quán dữ liệu — không có
     * trạng thái Payment='completed' mà Fine vẫn='unpaid' hoặc ngược lại.</p>
     *
     * <p>Sau khi hàm này được gọi thành công, tầng Service sẽ tiếp tục gọi
     * {@code UserLockReasonDAO#deleteUnpaidReasonByUserId} để gỡ cờ khóa tài
     * khoản nếu khoản phạt được thanh toán (PLAN.md §3 — Atomic Block).</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit. Việc commit/rollback
     * được kiểm soát hoàn toàn bởi {@code DeskCirculationService} để đảm bảo
     * tính nguyên tử của toàn bộ luồng thanh toán (BR-25).</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param fineId ID của bản ghi Fine cần cập nhật trạng thái
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.PaymentDAO#updateStatusToCompleted(Connection, int)
     * @see dao.UserLockReasonDAO#deleteUnpaidReasonByUserId(Connection, int)
     */
    // EARS[Event-driven]: WHEN Payment status is updated to 'completed',
    // THE LMS System SHALL UPDATE Fine.status = 'paid'
    // WHERE fineId matches [FR-F6-07, PLAN.md §3]
    public void updateStatusToPaid(Connection conn, int fineId) throws SQLException {
        String sql = "UPDATE [Fine] SET [status] = 'paid' WHERE fineId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật trạng thái Fine thành 'paid' cho fineId=" + fineId, e);
            throw e;
        }
    }
}
