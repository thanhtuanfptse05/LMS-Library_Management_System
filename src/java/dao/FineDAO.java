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
     * <p>Sau khi hàm này được gọi thành công, khoản phạt được đánh dấu là
     * đã thanh toán.</p>
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
     * <p>Sau khi INSERT Fine, tầng Service tiếp tục cập nhật audit log.
     * Transaction sẽ do Service kiểm soát (BR-24, CONTEXT.md §4).</p>
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
     *
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

    /**
     * Lấy danh sách các khoản phạt chưa thanh toán trong hệ thống kèm thông tin độc giả.
     */
    public List<Fine> findUnpaidFines(Connection conn, int limit) throws SQLException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, f.status, f.createdAt, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode "
                   + "FROM Fine f "
                   + "JOIN MemberProfile mp ON f.userId = mp.userId "
                   + "LEFT JOIN Student s ON f.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON f.userId = l.userId "
                   + "WHERE f.status = 'unpaid' "
                   + "ORDER BY f.createdAt DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
                    fine.setMemberName(rs.getString("memberName"));
                    fine.setMemberCode(rs.getString("memberCode"));
                    list.add(fine);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Fine unpaid", e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy danh sách các khoản phạt gần đây trong hệ thống (cả đã thanh toán và chưa thanh toán) kèm thông tin độc giả.
     */
    public List<Fine> findAllRecentFines(Connection conn, int limit) throws SQLException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, f.status, f.createdAt, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode "
                   + "FROM Fine f "
                   + "JOIN MemberProfile mp ON f.userId = mp.userId "
                   + "LEFT JOIN Student s ON f.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON f.userId = l.userId "
                   + "ORDER BY f.createdAt DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
                    fine.setMemberName(rs.getString("memberName"));
                    fine.setMemberCode(rs.getString("memberCode"));
                    list.add(fine);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Fine gần đây", e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy TẤT CẢ các khoản phạt/vi phạm trong hệ thống kèm thông tin độc giả và thông tin sách.
     */
    public List<Fine> findAllFinesWithMemberInfo(Connection conn) throws SQLException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, f.status, f.createdAt, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM Fine f "
                   + "JOIN MemberProfile mp ON f.userId = mp.userId "
                   + "LEFT JOIN Student s ON f.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON f.userId = l.userId "
                   + "LEFT JOIN BorrowRecord br ON f.borrowRecordId = br.borrowRecordId "
                   + "LEFT JOIN Book b ON br.bookId = b.bookId "
                   + "ORDER BY f.createdAt DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Fine fine = new Fine();
                fine.setFineId(rs.getInt("fineId"));
                fine.setBorrowRecordId(rs.getInt("borrowRecordId"));
                fine.setUserId(rs.getInt("userId"));
                fine.setAmount(rs.getBigDecimal("amount"));
                fine.setReason(rs.getString("reason"));
                fine.setStatus(rs.getString("status"));
                fine.setCreatedAt(rs.getTimestamp("createdAt"));
                fine.setMemberName(rs.getString("memberName"));
                fine.setMemberCode(rs.getString("memberCode"));
                fine.setBookTitle(rs.getString("bookTitle"));
                list.add(fine);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy toàn bộ danh sách Fine", e);
            throw e;
        }
        return list;
    }

    /**
     * Tìm kiếm và lọc danh sách khoản phạt/vi phạm theo từ khóa và trạng thái (unpaid, paid, all).
     *
     * @param conn         Kết nối DB
     * @param keyword      Từ khóa tìm kiếm (Tên thành viên, mã số, tên sách, lý do)
     * @param statusFilter Lọc theo trạng thái ('unpaid', 'paid', 'all')
     * @return Danh sách Fine phù hợp
     * @throws SQLException nếu có lỗi DB
     */
    public List<Fine> searchAndFilterFines(Connection conn, String keyword, String statusFilter) throws SQLException {
        List<Fine> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT f.fineId, f.borrowRecordId, f.userId, f.amount, f.reason, f.status, f.createdAt, "
          + "       mp.fullName AS memberName, "
          + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
          + "       b.title AS bookTitle "
          + "FROM Fine f "
          + "JOIN MemberProfile mp ON f.userId = mp.userId "
          + "LEFT JOIN Student s ON f.userId = s.userId "
          + "LEFT JOIN Lecturer l ON f.userId = l.userId "
          + "LEFT JOIN BorrowRecord br ON f.borrowRecordId = br.borrowRecordId "
          + "LEFT JOIN Book b ON br.bookId = b.bookId "
          + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter.trim())) {
            sql.append(" AND f.status = ? ");
            params.add(statusFilter.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(mp.fullName) LIKE ? OR LOWER(s.studentCode) LIKE ? OR LOWER(l.lecturerCode) LIKE ? OR LOWER(b.title) LIKE ? OR LOWER(f.reason) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY f.createdAt DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
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
                    fine.setMemberName(rs.getString("memberName"));
                    fine.setMemberCode(rs.getString("memberCode"));
                    fine.setBookTitle(rs.getString("bookTitle"));
                    list.add(fine);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm & lọc danh sách Fine", e);
            throw e;
        }
        return list;
    }

    /**
     * Tính tổng số tiền phạt chưa thanh toán (unpaid) trên toàn hệ thống.
     *
     * @param conn Connection từ servlet
     * @return Tổng số tiền phạt chưa thanh toán
     * @throws SQLException nếu có lỗi truy vấn
     */
    public BigDecimal getTotalUnpaidFines(Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM Fine WHERE status = 'unpaid'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính tổng Fine unpaid toàn hệ thống", e);
            throw e;
        }
        return BigDecimal.ZERO;
    }

    // =========================================================================
    // OVERDUE PROCESSOR — PHẠT LŨY TIẾN THEO NGÀY
    // =========================================================================

    /**
     * Tìm khoản phạt chưa thanh toán (unpaid) liên kết với một phiếu mượn cụ thể.
     *
     * <p>Dùng cho Giai đoạn 2 của {@code OverdueProcessor}: kiểm tra xem phiếu mượn
     * đang quá hạn đã có bản ghi Fine chưa, và lấy số tiền phạt hiện tại để so sánh
     * với số tiền phạt mới tính theo số ngày trễ thực tế.</p>
     *
     * @param conn           Connection trong Transaction
     * @param borrowRecordId ID phiếu mượn cần tra cứu
     * @return Đối tượng Fine chưa thanh toán liên kết với phiếu mượn; {@code null} nếu không tìm thấy
     * @throws SQLException nếu có lỗi truy vấn
     */
    public Fine findUnpaidFineByBorrowRecordId(Connection conn, int borrowRecordId) throws SQLException {
        String sql = "SELECT fineId, borrowRecordId, userId, amount, reason, status, createdAt "
                   + "FROM   Fine "
                   + "WHERE  borrowRecordId = ? AND status = 'unpaid' "
                   + "ORDER BY createdAt DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowRecordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Fine fine = new Fine();
                    fine.setFineId(rs.getInt("fineId"));
                    fine.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    fine.setUserId(rs.getInt("userId"));
                    fine.setAmount(rs.getBigDecimal("amount"));
                    fine.setReason(rs.getString("reason"));
                    fine.setStatus(rs.getString("status"));
                    fine.setCreatedAt(rs.getTimestamp("createdAt"));
                    return fine;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tìm Fine unpaid cho borrowRecordId=" + borrowRecordId, e);
            throw e;
        }
        return null;
    }

    /**
     * Cập nhật số tiền phạt và lý do cho một khoản phạt chưa thanh toán.
     *
     * <p>Dùng cho Giai đoạn 2 của {@code OverdueProcessor}: cập nhật lũy tiến
     * tiền phạt theo số ngày trễ thực tế. Chỉ thực hiện UPDATE khi số tiền mới
     * lớn hơn số tiền hiện tại (tránh ghi thừa vào DB khi F5 nhiều lần trong ngày).</p>
     *
     * @param conn      Connection trong Transaction (đã setAutoCommit(false))
     * @param fineId    ID khoản phạt cần cập nhật
     * @param newAmount Số tiền phạt mới (đã tính theo số ngày trễ thực tế)
     * @param newReason Lý do mới (VD: "Trễ hạn 5 ngày")
     * @throws SQLException nếu có lỗi UPDATE
     */
    public void updateFineAmount(Connection conn, int fineId, BigDecimal newAmount, String newReason)
            throws SQLException {
        String sql = "UPDATE Fine SET amount = ?, reason = ? WHERE fineId = ? AND status = 'unpaid'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, newAmount);
            ps.setString(2, newReason);
            ps.setInt(3, fineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật số tiền phạt lũy tiến cho fineId=" + fineId, e);
            throw e;
        }
    }

    // =========================================================================
    // ADMIN DASHBOARD KPI METHOD
    // =========================================================================

    /**
     * Tổng tiền phạt đã thu (Payment status='completed') trong tháng hiện tại.
     * Dùng cho KPI card "Doanh thu Tiền phạt" trên Manager Dashboard.
     *
     * @param conn Connection đọc
     * @return Tổng tiền phạt đã thu trong tháng, 0 nếu chưa có
     * @throws SQLException nếu có lỗi truy vấn
     */
    public BigDecimal getTotalFineRevenueThisMonth(Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(SUM(p.paidAmount), 0) "
                   + "FROM Payment p "
                   + "WHERE p.status = 'completed' "
                   + "  AND EXTRACT(MONTH FROM p.paidAt) = EXTRACT(MONTH FROM NOW()) "
                   + "  AND EXTRACT(YEAR  FROM p.paidAt) = EXTRACT(YEAR  FROM NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính doanh thu tiền phạt tháng hiện tại", e);
            throw e;
        }
        return BigDecimal.ZERO;
    }

    // =========================================================================
    // PAYMENT GUARD HELPERS
    // =========================================================================

    /**
     * Lấy {@code borrowRecordId} liên kết với một khoản phạt.
     *
     * <p>Dùng để kiểm tra sách đã được trả vật lý chưa trước khi duyệt thanh toán fine.
     * Fine phát sinh từ quá hạn ({@code reason} chứa "Trễ hạn") sẽ có {@code borrowRecordId} hợp lệ.
     * Fine từ sự cố khác có thể không có {@code borrowRecordId}.</p>
     *
     * @param conn   Connection trong Transaction
     * @param fineId ID khoản phạt cần tra cứu
     * @return {@code borrowRecordId} nếu tìm thấy; {@code -1} nếu Fine không tồn tại
     *         hoặc cột {@code borrowRecordId} là NULL
     * @throws SQLException nếu có lỗi truy vấn
     */
    // EARS[Guard]: WHEN payment approval is triggered,
    // THE LMS System SHALL look up borrowRecordId to verify book return status [BUG-FIX]
    public int findBorrowRecordIdByFineId(Connection conn, int fineId) throws SQLException {
        String sql = "SELECT borrowRecordId FROM Fine WHERE fineId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int val = rs.getInt("borrowRecordId");
                    return rs.wasNull() ? -1 : val;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu borrowRecordId cho fineId=" + fineId, e);
            throw e;
        }
        return -1;
    }
}
