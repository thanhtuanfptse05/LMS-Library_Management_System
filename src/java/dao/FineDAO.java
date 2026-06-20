package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Fine;

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
        String sql = "UPDATE Fine SET status = 'paid' WHERE fineId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật trạng thái Fine thành 'paid' cho fineId=" + fineId, e);
            throw e;
        }
    }

    /**
     * Tạo mới bản ghi tiền phạt đền bù khi sách bị hỏng hoặc mất.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04 — Node 6.17)
     * sau khi UPDATE {@code BorrowRecord} thành công. Số tiền phạt ({@code amount})
     * được tính bởi {@code DeskCirculationService} dựa trên giá gốc của sách
     * (lấy từ {@code BookDAO.findById}). Bản ghi Fine được tạo với
     * {@code status = 'unpaid'} — trạng thái mặc định theo schema.</p>
     *
     * <p>Sau khi INSERT Fine, tầng Service tiếp tục trong cùng Transaction:
     * <ol>
     *   <li>INSERT {@code UserLockReason(reason='unpaid')}</li>
     *   <li>UPDATE {@code [User].status = 'locked'}</li>
     * </ol>
     * Ba bước này PHẢI trong cùng một DB Transaction (BR-24, CONTEXT.md §4).</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit.</p>
     *
     * @param conn           {@code Connection} được quản lý bởi tầng Service
     *                       (đã {@code setAutoCommit(false)})
     * @param borrowRecordId ID bản ghi mượn liên kết với khoản phạt này
     * @param userId         ID người dùng phải chịu phạt (người mượn sách)
     * @param amount         Số tiền phạt đền bù (tính bởi Service từ giá sách)
     * @param reason         Mô tả lý do phạt (ví dụ: "Sách bị hỏng", "Sách bị mất")
     * @return ID của bản ghi Fine vừa được tạo (GENERATED KEY)
     * @throws SQLException nếu có lỗi thực thi câu lệnh INSERT,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.UserLockReasonDAO#insertUnpaidReason(Connection, int)
     * @see dao.UserDAO#updateStatusToLocked(Connection, int)
     */
    // EARS[Event-driven]: WHEN Check-in condition IN ('damaged', 'lost'),
    // THE LMS System SHALL INSERT Fine with status='unpaid'
    // WHERE borrowRecordId=?, userId=? [Node 6.17, FR-F6-04, BR-24]
    public int insertCompensationFine(Connection conn, int borrowRecordId, int userId,
                                      BigDecimal amount, String reason) throws SQLException {
        String sql = "INSERT INTO Fine (borrowRecordId, userId, amount, reason, status) "
                   + "VALUES (?, ?, ?, ?, 'unpaid')";

        try (PreparedStatement ps = conn.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, borrowRecordId);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, amount);
            ps.setString(4, reason);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi INSERT Fine đền bù cho borrowRecordId=" + borrowRecordId
                    + ", userId=" + userId, e);
            throw e;
        }

        throw new SQLException(
                "INSERT Fine đền bù thất bại: không lấy được generated key. "
                + "borrowRecordId=" + borrowRecordId + ", userId=" + userId);
    }

    /**
     * Lấy danh sách các khoản phạt chưa thanh toán (unpaid) của một người dùng,
     * kèm theo paymentId đang pending (nếu có).
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @return Danh sách các khoản phạt unpaid
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Fine> findUnpaidFinesByUserId(Connection conn, int userId) throws SQLException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, f.status, f.createdAt, "
                   + "       p.paymentId, p.status AS paymentStatus "
                   + "FROM   Fine f "
                   + "LEFT JOIN Payment p ON f.fineId = p.fineId AND p.status = 'pending' "
                   + "WHERE  f.userId = ? AND f.status = 'unpaid' "
                   + "ORDER BY f.createdAt DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Fine fine = new Fine();
                    fine.setFineId(rs.getInt("fineId"));
                    fine.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    fine.setUserId(rs.getInt("userId"));
                    fine.setAmount(rs.getBigDecimal("amount"));
                    fine.setReason(rs.getString("reason"));
                    fine.setStatus(rs.getString("status"));
                    fine.setCreatedAt(rs.getTimestamp("createdAt"));
                    
                    int rawPaymentId = rs.getInt("paymentId");
                    fine.setPaymentId(rs.wasNull() ? null : rawPaymentId);
                    fine.setPaymentStatus(rs.getString("paymentStatus"));
                    
                    list.add(fine);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Fine unpaid cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy tổng số tiền phạt chưa thanh toán (unpaid) của một người dùng.
     * Dùng cho Dashboard stats card "Tiền phạt quá hạn".
     *
     * @param conn   Connection đọc
     * @param userId ID người dùng cần tra cứu
     * @return Tổng tiền phạt unpaid (0 nếu không có khoản phạt nào)
     * @throws SQLException nếu có lỗi truy vấn
     */
    public BigDecimal getTotalUnpaidFinesByUser(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM Fine WHERE userId = ? AND status = 'unpaid'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính tổng Fine unpaid cho userId=" + userId, e);
            throw e;
        }
        return BigDecimal.ZERO;
    }

    /**
     * Kiểm tra xem người dùng có bất kỳ khoản phạt chưa thanh toán nào không.
     *
     * <p>Sử dụng trong luồng Check-out (BR-22) và Đặt trước sách (Reservation)
     * để chặn độc giả nợ phạt thực hiện giao dịch mới. Thay thế hoàn toàn
     * cơ chế kiểm tra qua bảng {@code UserLockReason}.</p>
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần kiểm tra
     * @return {@code true} nếu tồn tại ít nhất một Fine có status='unpaid'
     * @throws SQLException nếu có lỗi truy vấn
     */
    public boolean hasUnpaidFines(Connection conn, int userId) throws SQLException {
        String sql = "SELECT 1 FROM Fine WHERE userId = ? AND status = 'unpaid' LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra Fine unpaid cho userId=" + userId, e);
            throw e;
        }
    }

    /**
     * Lấy toàn bộ danh sách khoản phạt của một người dùng (cả paid và unpaid),
     * kèm theo tên sách và thông tin Payment pending (nếu có).
     *
     * <p>Kết quả JOIN qua BorrowRecord -> Book để lấy bookTitle hiển thị trên
     * giao diện quản lý phạt của độc giả (student/fines.jsp, lecturer/fines.jsp).</p>
     *
     * @param conn   Connection đọc
     * @param userId ID người dùng
     * @return Danh sách Fine kèm bookTitle và paymentId/paymentStatus
     * @throws SQLException nếu có lỗi truy vấn
     */
    public List<Fine> findFinesByUserId(Connection conn, int userId) throws SQLException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, "
                   + "       f.status, f.createdAt, "
                   + "       b.title AS bookTitle, "
                   + "       p.paymentId, p.status AS paymentStatus "
                   + "FROM   Fine f "
                   + "JOIN   BorrowRecord br ON f.borrowRecordId = br.borrowRecordId "
                   + "JOIN   Book b ON br.bookId = b.bookId "
                   + "LEFT JOIN Payment p ON f.fineId = p.fineId AND p.status = 'pending' "
                   + "WHERE  f.userId = ? "
                   + "ORDER BY f.createdAt DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Fine fine = new Fine();
                    fine.setFineId(rs.getInt("fineId"));
                    fine.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    fine.setUserId(rs.getInt("userId"));
                    fine.setAmount(rs.getBigDecimal("amount"));
                    fine.setReason(rs.getString("reason"));
                    fine.setStatus(rs.getString("status"));
                    fine.setCreatedAt(rs.getTimestamp("createdAt"));
                    fine.setBookTitle(rs.getString("bookTitle"));

                    int rawPaymentId = rs.getInt("paymentId");
                    fine.setPaymentId(rs.wasNull() ? null : rawPaymentId);
                    fine.setPaymentStatus(rs.getString("paymentStatus"));

                    list.add(fine);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Fine cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Tạo mới bản ghi tiền phạt quá hạn (overdue).
     *
     * <p>Được gọi trong luồng Check-in khi sách được trả muộn. Số tiền phạt
     * được tính bởi Service dựa trên số ngày trễ hạn nhân với mức phạt/ngày
     * từ cấu hình {@code FINE_RATE_PER_DAY}.</p>
     *
     * @param conn           Connection trong Transaction
     * @param borrowRecordId ID bản ghi mượn liên kết
     * @param userId         ID người mượn phải chịu phạt
     * @param amount         Số tiền phạt quá hạn
     * @param reason         Mô tả lý do (ví dụ: "Trả trễ 5 ngày")
     * @return ID của Fine vừa tạo
     * @throws SQLException nếu có lỗi INSERT
     */
    public int insertOverdueFine(Connection conn, int borrowRecordId, int userId,
                                 BigDecimal amount, String reason) throws SQLException {
        String sql = "INSERT INTO Fine (borrowRecordId, userId, amount, reason, status) "
                   + "VALUES (?, ?, ?, ?, 'unpaid')";

        try (PreparedStatement ps = conn.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, borrowRecordId);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, amount);
            ps.setString(4, reason);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi INSERT Fine quá hạn cho borrowRecordId=" + borrowRecordId
                    + ", userId=" + userId, e);
            throw e;
        }

        throw new SQLException(
                "INSERT Fine quá hạn thất bại: không lấy được generated key. "
                + "borrowRecordId=" + borrowRecordId + ", userId=" + userId);
    }
}
