package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BorrowRecord;
import util.DatabaseConnection;

/**
 * BorrowRecordDAO — Data Access Object cho bảng BorrowRecord.
 *
 * <p>Tuân thủ SEC-03: Sử dụng PreparedStatement cho mọi truy vấn.</p>
 *
 * <p>Traceability: SPEC.md §5 — Data Model, FR-F6-03, FR-F6-04, FR-F6-05, BR-26.</p>
 */
public class BorrowRecordDAO {

    private static final Logger LOGGER = Logger.getLogger(BorrowRecordDAO.class.getName());

    public int insert(Connection conn, int userId, int bookCopyId, int bookId,
                      int createdBy, Timestamp endDate) throws SQLException {
        String sql = "INSERT INTO BorrowRecord "
                   + "    (userId, bookCopyId, bookId, startDate, endDate, "
                   + "     status, extensionCount, createdBy) "
                   + "VALUES (?, ?, ?, NOW(), ?, 'borrowed', 0, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookCopyId);
            ps.setInt(3, bookId);
            ps.setTimestamp(4, endDate);
            ps.setInt(5, createdBy);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting BorrowRecord", e);
            throw e;
        }
        return -1;
    }

    /**
     * Đếm số lượng sách đang giữ chưa trả (status IN 'borrowed','overdue') của một độc giả.
     * Dùng để kiểm tra hạn mức mượn tối đa (BR-21 / Max Quota).
     */
    public int countActiveBorrowsByUserId(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND status IN ('borrowed', 'overdue') AND returnedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số sách đang mượn của userId=" + userId, e);
            throw e;
        }
        return 0;
    }

    // =========================================================================
    // F8 BOOK DISCOVERY / AI RECOMMENDATION METHODS (từ nhánh dev)
    // =========================================================================

    /**
     * Đếm tổng số lượt mượn sách của một người dùng.
     * Sử dụng để xác định người dùng có đạt ngưỡng kích hoạt AI Recommendation không (BR-26).
     *
     * @param userId ID người dùng
     * @return Tổng số lượt mượn
     */
    public int countUserBorrowHistory(int userId) {
        String sql = "SELECT COUNT(*) AS total FROM BorrowRecord WHERE userId = ?";
        int count = 0;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm lịch sử mượn sách của userId=" + userId, e);
        }

        return count;
    }

    // =========================================================================
    // F6 DESK CIRCULATION METHODS (từ nhánh Thai)
    // =========================================================================

    /**
     * Cập nhật trạng thái BorrowRecord thành 'returned' khi sách được trả bình thường.
     *
     * <p>Được gọi trong luồng Check-in sách nguyên vẹn (FR-F6-04 — Node 6.14).
     * Đồng thời ghi nhận thời điểm trả thực tế vào {@code returnedAt}.</p>
     *
     * @param conn           {@code Connection} được quản lý bởi tầng Service
     *                       (đã {@code setAutoCommit(false)})
     * @param borrowRecordId ID bản ghi mượn cần cập nhật
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Librarian confirms Check-in (condition='good'),
    // THE LMS System SHALL UPDATE BorrowRecord status='returned', returnedAt=GETDATE()
    // WHERE borrowRecordId = ? [Node 6.14, FR-F6-04]
    public void updateStatusToReturned(Connection conn, int borrowRecordId)
            throws SQLException {
        String sql = "UPDATE BorrowRecord "
                   + "SET    status      = 'returned', "
                   + "       returnedAt  = NOW() "
                   + "WHERE  borrowRecordId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowRecordId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BorrowRecord thành 'returned' cho borrowRecordId="
                    + borrowRecordId, e);
            throw e;
        }
    }

    /**
     * Cập nhật trạng thái BorrowRecord khi sách bị hỏng hoặc mất.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04 — Node 6.17).
     * Trạng thái được set tương ứng: 'damaged' nếu condition='damaged',
     * 'lost' nếu condition='lost'. Đồng thời ghi nhận thời điểm trả thực tế.</p>
     *
     * @param conn           {@code Connection} được quản lý bởi tầng Service
     *                       (đã {@code setAutoCommit(false)})
     * @param borrowRecordId ID bản ghi mượn cần cập nhật
     * @param newStatus      Trạng thái mới ('damaged' hoặc 'lost' — khớp với condition)
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Check-in condition IN ('damaged', 'lost'),
    // THE LMS System SHALL UPDATE BorrowRecord status=? (damaged/lost), returnedAt=GETDATE()
    // WHERE borrowRecordId = ? [Node 6.17, FR-F6-04]
    public void updateStatusToDamagedOrLost(Connection conn, int borrowRecordId, String newStatus)
            throws SQLException {
        String sql = "UPDATE BorrowRecord "
                   + "SET    status      = ?, "
                   + "       returnedAt  = NOW() "
                   + "WHERE  borrowRecordId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, borrowRecordId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BorrowRecord thành '" + newStatus
                    + "' cho borrowRecordId=" + borrowRecordId, e);
            throw e;
        }
    }

    /**
     * Tra cứu đầy đủ bản ghi mượn đang active (status='borrowed' hoặc 'overdue') theo mã bản sao.
     *
     * <p>Hàm này trả về toàn bộ đối tượng {@code BorrowRecord} (bao gồm
     * {@code userId} và {@code bookId}) để tầng Service có thể truy cập các
     * trường này mà không cần thực hiện truy vấn bổ sung.</p>
     *
     * <p>Được gọi trong luồng Check-in (FR-F6-04, FR-F6-05) để lấy
     * {@code userId} (nhập lý do khóa, INSERT Fine)
     * và {@code bookId} (kiểm tra hàng chờ, cập nhật số lượng kho) từ
     * một truy vấn duy nhất thay vì 3 truy vấn riêng biệt.</p>
     *
     * <p><strong>Lưu ý:</strong> Hàm này xét cả trạng thái {@code 'overdue'}
     * vì tiến trình nền {@code OverdueProcessor} có thể đã đổi status từ
     * {@code 'borrowed'} sang {@code 'overdue'} trước khi Thủ thư xử lý Check-in
     * tại quầy. Điều kiện {@code returnedAt IS NULL} đảm bảo chỉ lấy phiếu
     * mượn chưa trả.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách đang được trả
     * @return Đối tượng {@code BorrowRecord} đang active (status 'borrowed' hoặc 'overdue');
     *         {@code null} nếu không tìm thấy bản ghi active nào
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Librarian scans barcode for check-in,
    // THE LMS System SHALL find full active BorrowRecord WHERE bookCopyId=? AND status IN ('borrowed','overdue')
    // to retrieve userId and bookId for subsequent operations [FR-F6-04, FR-F6-05]
    public BorrowRecord findActiveBorrowRecord(Connection conn, int bookCopyId)
            throws SQLException {
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  bookCopyId = ? "
                   + "  AND  status     IN ('borrowed', 'overdue')"
                   + "  AND  returnedAt IS NULL";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));

                    // createdBy là NULL-able
                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                    record.setCreatedAt(rs.getTimestamp("createdAt"));
                    return record;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu BorrowRecord active (full) cho bookCopyId=" + bookCopyId, e);
            throw e;
        }

        return null;
    }

    /**
     * Lấy danh sách các BorrowRecord đang active (status IN 'borrowed','overdue') của một người dùng.
     *
     * <p>Bao gồm cả sách quá hạn chưa trả vì OverdueProcessor có thể đã cập nhật status
     * từ 'borrowed' sang 'overdue' trong khi độc giả vẫn đang giữ sách.</p>
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @return Danh sách các bản ghi mượn đang active (chưa trả)
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<BorrowRecord> findActiveBorrowRecordsByUserId(Connection conn, int userId) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.borrowRecordId, br.userId, br.bookCopyId, br.bookId, "
                   + "       br.startDate, br.endDate, br.returnedAt, br.status, "
                   + "       br.extensionCount, br.createdBy, br.createdAt, "
                   + "       b.title AS bookTitle "
                   + "FROM   BorrowRecord br "
                   + "JOIN   Book b ON br.bookId = b.bookId "
                   + "WHERE  br.userId     = ? "
                   + "  AND  br.status     IN ('borrowed', 'overdue') "
                   + "  AND  br.returnedAt IS NULL "
                   + "ORDER BY br.startDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));

                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                    record.setCreatedAt(rs.getTimestamp("createdAt"));
                    record.setBookTitle(rs.getString("bookTitle"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách BorrowRecord active cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Đếm số sách đang giữ chưa trả (status IN 'borrowed','overdue') của một người dùng.
     */
    public int countActiveBorrowsByUser(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND status IN ('borrowed', 'overdue') AND returnedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số sách đang mượn của userId=" + userId, e);
            throw e;
        }
        return 0;
    }

    /**
     * Kiểm tra xem người dùng có đang giữ cuốn sách này hay không (chưa trả, dù đúng hạn hay quá hạn).
     */
    public boolean hasActiveBorrowRecord(Connection conn, int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND bookId = ? AND status IN ('borrowed', 'overdue') AND returnedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra sách đang mượn của userId=" + userId + ", bookId=" + bookId, e);
            throw e;
        }
        return false;
    }

    /**
     * Tìm BorrowRecord bằng ID (alias cho findBorrowRecordById).
     */
    public BorrowRecord findById(Connection conn, int borrowRecordId) throws SQLException {
        return findBorrowRecordById(conn, borrowRecordId);
    }

    /**
     * Tìm BorrowRecord bằng ID.
     */
    public BorrowRecord findBorrowRecordById(Connection conn, int borrowRecordId) throws SQLException {
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  borrowRecordId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowRecordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));

                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                    record.setCreatedAt(rs.getTimestamp("createdAt"));
                    return record;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm BorrowRecord bằng ID=" + borrowRecordId, e);
            throw e;
        }
        return null;
    }

    /**
     * Tăng số lần gia hạn và cộng thêm số ngày gia hạn vào endDate.
     */
    public void incrementExtension(Connection conn, int borrowRecordId, int extraDays) throws SQLException {
        String sql = "UPDATE BorrowRecord "
                   + "SET    extensionCount = extensionCount + 1, "
                   + "       endDate = endDate + (? * INTERVAL '1 day') "
                   + "WHERE  borrowRecordId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, extraDays);
            ps.setInt(2, borrowRecordId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi gia hạn BorrowRecord ID=" + borrowRecordId, e);
            throw e;
        }
    }

    /**
     * Đếm số sách sắp đến hạn trả trong {@code withinDays} ngày tới.
     * Dùng cho Dashboard stats card "Sắp đến hạn".
     *
     * @param conn       Connection đọc
     * @param userId     ID người dùng
     * @param withinDays Số ngày tới cần kiểm tra (VD: 3 = trong 3 ngày tới)
     * @return Số sách sắp đến hạn
     * @throws SQLException nếu có lỗi truy vấn
     */
    public int countDueSoonByUser(Connection conn, int userId, int withinDays) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord "
                   + "WHERE userId = ? AND status = 'borrowed' "
                   + "AND endDate BETWEEN NOW() AND NOW() + CAST(? || ' days' AS INTERVAL)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, String.valueOf(withinDays));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm sách sắp đến hạn của userId=" + userId, e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy toàn bộ danh sách BorrowRecord (cả active và đã trả/mất/hỏng) của một người dùng.
     * Sắp xếp theo ngày mượn giảm dần (mới nhất lên đầu).
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @return Danh sách toàn bộ các bản ghi mượn
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<BorrowRecord> findAllBorrowRecordsByUserId(Connection conn, int userId) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  userId   = ? "
                   + "ORDER BY startDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));

                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                    record.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy toàn bộ danh sách BorrowRecord cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy danh sách các BorrowRecord gần đây nhất của một người dùng, có giới hạn số lượng.
     * Sắp xếp theo ngày mượn giảm dần (mới nhất lên đầu).
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @param limit  Số lượng bản ghi tối đa cần lấy
     * @return Danh sách các bản ghi mượn gần đây
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<BorrowRecord> findRecentBorrowRecordsByUserId(Connection conn, int userId, int limit) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  userId   = ? "
                   + "ORDER BY startDate DESC "
                   + "LIMIT ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));

                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                    record.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách BorrowRecord gần đây cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Đếm số sách được mượn hôm nay.
     */
    public int countIssuedToday(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE startDate >= date_trunc('day', now())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số sách mượn hôm nay", e);
            throw e;
        }
        return 0;
    }

    /**
     * Đếm số sách được trả hôm nay.
     */
    public int countReturnedToday(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE returnedAt >= date_trunc('day', now())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số sách trả hôm nay", e);
            throw e;
        }
        return 0;
    }

    /**
     * Đếm số khoản mượn quá hạn trong toàn hệ thống.
     */
    public int countOverdueAll(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord br "
                   + "WHERE (br.status = 'overdue' OR (br.status = 'borrowed' AND br.endDate < NOW())) "
                   + "  AND br.returnedAt IS NULL "
                   + "  AND NOT EXISTS (SELECT 1 FROM Fine f WHERE f.borrowRecordId = br.borrowRecordId AND f.status = 'paid')";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số khoản mượn quá hạn toàn hệ thống", e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy danh sách các khoản mượn đang hoạt động (đang giữ chưa trả) kèm thông tin độc giả và tiêu đề sách.
     */
    public List<BorrowRecord> findActiveLoans(Connection conn, int limit) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.borrowRecordId, br.userId, br.bookCopyId, br.bookId, br.startDate, br.endDate, br.returnedAt, br.status, br.extensionCount, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM BorrowRecord br "
                   + "JOIN MemberProfile mp ON br.userId = mp.userId "
                   + "JOIN Book b ON br.bookId = b.bookId "
                   + "LEFT JOIN Student s ON br.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON br.userId = l.userId "
                   + "WHERE br.status IN ('borrowed', 'overdue') AND br.returnedAt IS NULL "
                   + "ORDER BY br.startDate DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));
                    record.setMemberName(rs.getString("memberName"));
                    record.setMemberCode(rs.getString("memberCode"));
                    record.setBookTitle(rs.getString("bookTitle"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách khoản mượn hoạt động", e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy danh sách các giao dịch mượn sách do một thủ thư cụ thể xử lý
     * (WHERE createdBy = librarianId). Bao gồm cả đang mượn ('borrowed') và
     * đã trả gần đây ('returned'). Dùng cho Librarian Dashboard cá nhân.
     *
     * @param conn        Kết nối DB
     * @param librarianId ID thủ thư cần tra cứu (session userId)
     * @param limit       Giới hạn số bản ghi
     * @return Danh sách BorrowRecord kèm thông tin hiển thị
     * @throws SQLException nếu có lỗi DB
     */
    public List<BorrowRecord> findLoansByLibrarian(Connection conn, int librarianId, int limit) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.borrowRecordId, br.userId, br.bookCopyId, br.bookId, br.startDate, br.endDate, br.returnedAt, br.status, br.extensionCount, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM BorrowRecord br "
                   + "JOIN MemberProfile mp ON br.userId = mp.userId "
                   + "JOIN Book b ON br.bookId = b.bookId "
                   + "LEFT JOIN Student s ON br.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON br.userId = l.userId "
                   + "WHERE br.createdBy = ? "
                   + "  AND br.status IN ('borrowed', 'returned') "
                   + "ORDER BY br.startDate DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, librarianId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));
                    record.setMemberName(rs.getString("memberName"));
                    record.setMemberCode(rs.getString("memberCode"));
                    record.setBookTitle(rs.getString("bookTitle"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách giao dịch của thủ thư librarianId=" + librarianId, e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy danh sách giao dịch mượn/trả sách gần đây trên TOÀN HỆ THỐNG kèm thông tin Thủ thư xử lý.
     * Dùng cho Librarian Dashboard tổng quan.
     *
     * @param conn  Kết nối DB
     * @param limit Giới hạn số bản ghi
     * @return Danh sách BorrowRecord kèm memberName, memberCode, bookTitle, staffName, staffCode
     * @throws SQLException nếu có lỗi DB
     */
    public List<BorrowRecord> findAllRecentLoans(Connection conn, int limit) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.borrowRecordId, br.userId, br.bookCopyId, br.bookId, br.startDate, br.endDate, br.returnedAt, br.status, br.extensionCount, br.createdBy, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle, "
                   + "       staff_mp.fullName AS staffName, "
                   + "       lib.staffCode AS staffCode "
                   + "FROM BorrowRecord br "
                   + "JOIN MemberProfile mp ON br.userId = mp.userId "
                   + "JOIN Book b ON br.bookId = b.bookId "
                   + "LEFT JOIN Student s ON br.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON br.userId = l.userId "
                   + "LEFT JOIN MemberProfile staff_mp ON br.createdBy = staff_mp.userId "
                   + "LEFT JOIN Librarian lib ON br.createdBy = lib.userId "
                   + "WHERE br.status IN ('borrowed', 'returned', 'overdue') "
                   + "ORDER BY br.startDate DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));
                    int rawCreatedBy = rs.getInt("createdBy");
                    record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);
                    record.setMemberName(rs.getString("memberName"));
                    record.setMemberCode(rs.getString("memberCode"));
                    record.setBookTitle(rs.getString("bookTitle"));
                    record.setStaffName(rs.getString("staffName"));
                    record.setStaffCode(rs.getString("staffCode"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách giao dịch mượn/trả toàn hệ thống", e);
            throw e;
        }
        return list;
    }

    /**
     * Tìm kiếm các bản ghi mượn quá hạn (trạng thái 'borrowed' và endDate < NOW()).
     * Dùng cho tiến trình quét quá hạn tự động.
     *
     * @param conn Kết nối DB từ transaction
     * @return Danh sách các bản ghi mượn quá hạn
     * @throws SQLException nếu có lỗi DB
     */
    public List<BorrowRecord> findOverdueRecords(Connection conn) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, "
                   + "       returnedAt, status, extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  status = 'borrowed' AND endDate < NOW() AND returnedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                record.setUserId(rs.getInt("userId"));
                record.setBookCopyId(rs.getInt("bookCopyId"));
                record.setBookId(rs.getInt("bookId"));
                record.setStartDate(rs.getTimestamp("startDate"));
                record.setEndDate(rs.getTimestamp("endDate"));
                record.setReturnedAt(rs.getTimestamp("returnedAt"));
                record.setStatus(rs.getString("status"));
                record.setExtensionCount(rs.getInt("extensionCount"));
                
                int rawCreatedBy = rs.getInt("createdBy");
                record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);
                
                record.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(record);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách BorrowRecord quá hạn", e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy danh sách các phiếu mượn đang quá hạn chưa trả (status='overdue', returnedAt IS NULL).
     *
     * <p>Dùng cho Giai đoạn 2 của {@code OverdueProcessor}: cập nhật lũy tiến
     * tiền phạt theo số ngày trễ thực tế. Khác với {@link #findOverdueRecords(Connection)}
     * chỉ tìm đơn mượn {@code 'borrowed'} mới phát hiện, phương thức này trả về
     * các đơn mượn đã chuyển sang {@code 'overdue'} từ trước nhưng vẫn chưa trả sách.</p>
     *
     * @param conn Kết nối DB từ transaction
     * @return Danh sách các bản ghi mượn đang quá hạn chưa trả
     * @throws SQLException nếu có lỗi DB
     */
    public List<BorrowRecord> findActiveOverdueLoans(Connection conn) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, "
                   + "       returnedAt, status, extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  status = 'overdue' AND returnedAt IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                record.setUserId(rs.getInt("userId"));
                record.setBookCopyId(rs.getInt("bookCopyId"));
                record.setBookId(rs.getInt("bookId"));
                record.setStartDate(rs.getTimestamp("startDate"));
                record.setEndDate(rs.getTimestamp("endDate"));
                record.setReturnedAt(rs.getTimestamp("returnedAt"));
                record.setStatus(rs.getString("status"));
                record.setExtensionCount(rs.getInt("extensionCount"));

                int rawCreatedBy = rs.getInt("createdBy");
                record.setCreatedBy(rs.wasNull() ? null : rawCreatedBy);

                record.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(record);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách BorrowRecord đang quá hạn chưa trả", e);
            throw e;
        }
        return list;
    }

    // =========================================================================
    // ADMIN DASHBOARD KPI METHODS
    // =========================================================================

    /**
     * Đếm tổng số lượt mượn trong tháng hiện tại (KPI card 1 của Manager Dashboard).
     */
    public int countThisMonth(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord "
                   + "WHERE EXTRACT(MONTH FROM startDate) = EXTRACT(MONTH FROM NOW()) "
                   + "  AND EXTRACT(YEAR  FROM startDate) = EXTRACT(YEAR  FROM NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng mượn tháng hiện tại", e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy xu hướng số lượt mượn trong N tháng gần nhất (cho biểu đồ cột).
     *
     * @param conn   Connection đọc
     * @param months Số tháng cần lấy (VD: 8)
     * @return Danh sách int[3] = {year, month, count}, sắp xếp theo thứ tự thời gian tăng dần
     */
    public java.util.List<int[]> getMonthlyTrend(Connection conn, int months) throws SQLException {
        // Khởi tạo danh sách mặc định có đủ 'months' tháng với số lượng = 0
        java.util.List<int[]> result = new java.util.ArrayList<>();
        java.time.LocalDate current = java.time.LocalDate.now().withDayOfMonth(1);
        java.time.LocalDate startMonth = current.minusMonths(months - 1);
        for (int i = 0; i < months; i++) {
            java.time.LocalDate d = startMonth.plusMonths(i);
            result.add(new int[]{d.getYear(), d.getMonthValue(), 0});
        }

        String sql = "SELECT EXTRACT(YEAR FROM startDate)  AS yr, "
                   + "       EXTRACT(MONTH FROM startDate) AS mo, "
                   + "       COUNT(*) AS cnt "
                   + "FROM BorrowRecord "
                   + "WHERE startDate >= date_trunc('month', NOW()) - (? - 1) * INTERVAL '1 month' "
                   + "GROUP BY yr, mo";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, months);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int yr = rs.getInt("yr");
                    int mo = rs.getInt("mo");
                    int cnt = rs.getInt("cnt");
                    // Ghi đè số lượng vào tháng tương ứng
                    for (int[] row : result) {
                        if (row[0] == yr && row[1] == mo) {
                            row[2] = cnt;
                            break;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy xu hướng mượn theo tháng", e);
            throw e;
        }
        return result;
    }

    /**
     * Tính tỷ lệ trễ hạn (%) trên toàn bộ lịch sử giao dịch.
     *
     * <p>Bao gồm các trường hợp:</p>
     * <ul>
     *   <li>Đang trễ hạn: status='overdue' HOẶC (status='borrowed' AND endDate &lt; NOW())</li>
     *   <li>Đã trả muộn: returnedAt IS NOT NULL AND returnedAt &gt; endDate</li>
     * </ul>
     *
     * @param conn Connection đọc
     * @return Tỷ lệ phần trăm (0.0 – 100.0), 0 nếu không có dữ liệu
     */
    public double getOverdueRate(Connection conn) throws SQLException {
        String sql = "SELECT "
                   + "    COUNT(*) FILTER ("
                   + "        WHERE status = 'overdue' "
                   + "           OR (status = 'borrowed' AND endDate < NOW()) "
                   + "           OR (returnedAt IS NOT NULL AND returnedAt > endDate)"
                   + "    ) AS overdue, "
                   + "    COUNT(*) AS total "
                   + "FROM BorrowRecord";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int total = rs.getInt("total");
                if (total == 0) return 0.0;
                return rs.getInt("overdue") * 100.0 / total;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính tỷ lệ trễ hạn", e);
            throw e;
        }
        return 0.0;
    }

    // =========================================================================
    // LIBRARIAN DASHBOARD — OVERDUE DETAIL LIST
    // =========================================================================

    /**
     * Lấy danh sách khoản mượn quá hạn cho Librarian Dashboard (có JOIN memberName, memberCode, bookTitle).
     *
     * @param conn  Kết nối DB
     * @param limit Giới hạn số bản ghi
     * @return Danh sách BorrowRecord quá hạn kèm thông tin hiển thị
     * @throws SQLException nếu có lỗi DB
     */
    public List<BorrowRecord> findOverdueLoans(Connection conn, int limit) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.borrowRecordId, br.userId, br.bookCopyId, br.bookId, br.startDate, br.endDate, "
                   + "       br.returnedAt, br.status, br.extensionCount, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM BorrowRecord br "
                   + "JOIN MemberProfile mp ON br.userId = mp.userId "
                   + "JOIN Book b ON br.bookId = b.bookId "
                   + "LEFT JOIN Student s ON br.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON br.userId = l.userId "
                   + "WHERE (br.status = 'overdue' OR (br.status = 'borrowed' AND br.endDate < NOW())) "
                   + "  AND br.returnedAt IS NULL "
                   + "  AND NOT EXISTS (SELECT 1 FROM Fine f WHERE f.borrowRecordId = br.borrowRecordId AND f.status = 'paid') "
                   + "ORDER BY br.endDate ASC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    record.setUserId(rs.getInt("userId"));
                    record.setBookCopyId(rs.getInt("bookCopyId"));
                    record.setBookId(rs.getInt("bookId"));
                    record.setStartDate(rs.getTimestamp("startDate"));
                    record.setEndDate(rs.getTimestamp("endDate"));
                    record.setReturnedAt(rs.getTimestamp("returnedAt"));
                    record.setStatus(rs.getString("status"));
                    record.setExtensionCount(rs.getInt("extensionCount"));
                    record.setMemberName(rs.getString("memberName"));
                    record.setMemberCode(rs.getString("memberCode"));
                    record.setBookTitle(rs.getString("bookTitle"));
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách khoản mượn quá hạn cho dashboard", e);
            throw e;
        }
        return list;
    }

    // =========================================================================
    // LIBRARIAN BORROWINGS MANAGEMENT — SEARCH & PAGINATION (feat-borrowingsManagement)
    // =========================================================================

    /**
     * Tìm kiếm và phân trang danh sách lượt mượn sách cho màn hình Quản lý Đang mượn (Thủ thư).
     *
     * @param conn           Connection CSDL
     * @param userKeyword    Từ khóa tên hoặc mã độc giả (SV/GV)
     * @param barcodeKeyword Từ khóa mã vạch bản sao
     * @param status         Trạng thái mượn ('borrowed', 'overdue', 'returned', 'recalled' hoặc 'all')
     * @param fromDate       Từ ngày mượn (Timestamp hoặc null)
     * @param toDate         Đến ngày mượn (Timestamp hoặc null)
     * @param offset         Vị trí bắt đầu
     * @param limit          Số bản ghi tối đa / trang
     * @return Danh sách DTO BorrowingManagementDTO
     * @throws SQLException nếu có lỗi SQL
     */
    public List<dto.BorrowingManagementDTO> searchBorrowingsPaginated(
            Connection conn, String userKeyword, String barcodeKeyword,
            String status, Timestamp fromDate, Timestamp toDate,
            int offset, int limit) throws SQLException {
        return searchBorrowingsPaginated(conn, userKeyword, barcodeKeyword, status, fromDate, toDate, "startDate", "DESC", offset, limit);
    }

    public List<dto.BorrowingManagementDTO> searchBorrowingsPaginated(
            Connection conn, String userKeyword, String barcodeKeyword,
            String status, Timestamp fromDate, Timestamp toDate,
            String sortBy, String sortOrder,
            int offset, int limit) throws SQLException {

        List<dto.BorrowingManagementDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT br.borrowRecordId, br.userId, mp.fullName AS userFullName, ")
           .append("       COALESCE(st.studentCode, lec.lecturerCode, u.email) AS userCode, ")
           .append("       u.email AS userEmail, u.role AS userRole, ")
           .append("       b.bookId, b.title AS bookTitle, b.isbn, ")
           .append("       bc.bookCopyId, bc.barcode, ")
           .append("       br.startDate, br.endDate, br.returnedAt, br.status ")
           .append("FROM BorrowRecord br ")
           .append("JOIN \"User\" u ON br.userId = u.userId ")
           .append("JOIN MemberProfile mp ON u.userId = mp.userId ")
           .append("JOIN Book b ON br.bookId = b.bookId ")
           .append("JOIN BookCopy bc ON br.bookCopyId = bc.bookCopyId ")
           .append("LEFT JOIN Student st ON u.userId = st.userId ")
           .append("LEFT JOIN Lecturer lec ON u.userId = lec.userId ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (userKeyword != null && !userKeyword.trim().isEmpty()) {
            sql.append("AND (mp.fullName ILIKE ? OR st.studentCode ILIKE ? OR lec.lecturerCode ILIKE ? OR u.email ILIKE ?) ");
            String kw = "%" + userKeyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (barcodeKeyword != null && !barcodeKeyword.trim().isEmpty()) {
            sql.append("AND bc.barcode ILIKE ? ");
            params.add("%" + barcodeKeyword.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status.trim())) {
            String cleanStatus = status.trim().toLowerCase();
            if ("borrowed".equals(cleanStatus)) {
                sql.append("AND br.status IN ('borrowed', 'overdue') AND br.returnedAt IS NULL ");
            } else if ("overdue".equals(cleanStatus)) {
                sql.append("AND br.status = 'overdue' AND br.returnedAt IS NULL ");
            } else {
                sql.append("AND br.status = ? ");
                params.add(cleanStatus);
            }
        }

        if (fromDate != null) {
            sql.append("AND br.startDate >= ? ");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append("AND br.startDate <= ? ");
            params.add(toDate);
        }

        String orderCol;
        if ("endDate".equalsIgnoreCase(sortBy) || "duedate".equalsIgnoreCase(sortBy)) {
            orderCol = "br.endDate";
        } else if ("bookTitle".equalsIgnoreCase(sortBy) || "title".equalsIgnoreCase(sortBy)) {
            orderCol = "b.title";
        } else if ("userFullName".equalsIgnoreCase(sortBy) || "name".equalsIgnoreCase(sortBy)) {
            orderCol = "mp.fullName";
        } else if ("barcode".equalsIgnoreCase(sortBy)) {
            orderCol = "bc.barcode";
        } else if ("borrowRecordId".equalsIgnoreCase(sortBy) || "id".equalsIgnoreCase(sortBy)) {
            orderCol = "br.borrowRecordId";
        } else {
            orderCol = "br.startDate";
        }

        String orderDir = "ASC".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
        sql.append("ORDER BY ").append(orderCol).append(" ").append(orderDir).append(", br.borrowRecordId DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dto.BorrowingManagementDTO dto = new dto.BorrowingManagementDTO();
                    dto.setBorrowRecordId(rs.getInt("borrowRecordId"));
                    dto.setUserId(rs.getInt("userId"));
                    dto.setUserFullName(rs.getString("userFullName"));
                    dto.setUserCode(rs.getString("userCode"));
                    dto.setUserEmail(rs.getString("userEmail"));
                    dto.setUserRole(rs.getString("userRole"));
                    dto.setBookId(rs.getInt("bookId"));
                    dto.setBookTitle(rs.getString("bookTitle"));
                    dto.setIsbn(rs.getString("isbn"));
                    dto.setBookCopyId(rs.getInt("bookCopyId"));
                    dto.setBarcode(rs.getString("barcode"));
                    dto.setStartDate(rs.getTimestamp("startDate"));
                    dto.setEndDate(rs.getTimestamp("endDate"));
                    dto.setReturnedAt(rs.getTimestamp("returnedAt"));
                    dto.setStatus(rs.getString("status"));
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm phân trang mượn sách cho thủ thư", e);
            throw e;
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi mượn sách khớp với điều kiện tìm kiếm.
     */
    public int countSearchBorrowings(
            Connection conn, String userKeyword, String barcodeKeyword,
            String status, Timestamp fromDate, Timestamp toDate) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
           .append("FROM BorrowRecord br ")
           .append("JOIN \"User\" u ON br.userId = u.userId ")
           .append("JOIN MemberProfile mp ON u.userId = mp.userId ")
           .append("JOIN Book b ON br.bookId = b.bookId ")
           .append("JOIN BookCopy bc ON br.bookCopyId = bc.bookCopyId ")
           .append("LEFT JOIN Student st ON u.userId = st.userId ")
           .append("LEFT JOIN Lecturer lec ON u.userId = lec.userId ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (userKeyword != null && !userKeyword.trim().isEmpty()) {
            sql.append("AND (mp.fullName ILIKE ? OR st.studentCode ILIKE ? OR lec.lecturerCode ILIKE ? OR u.email ILIKE ?) ");
            String kw = "%" + userKeyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (barcodeKeyword != null && !barcodeKeyword.trim().isEmpty()) {
            sql.append("AND bc.barcode ILIKE ? ");
            params.add("%" + barcodeKeyword.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status.trim())) {
            String cleanStatus = status.trim().toLowerCase();
            if ("borrowed".equals(cleanStatus)) {
                sql.append("AND br.status IN ('borrowed', 'overdue') AND br.returnedAt IS NULL ");
            } else if ("overdue".equals(cleanStatus)) {
                sql.append("AND br.status = 'overdue' AND br.returnedAt IS NULL ");
            } else {
                sql.append("AND br.status = ? ");
                params.add(cleanStatus);
            }
        }

        if (fromDate != null) {
            sql.append("AND br.startDate >= ? ");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append("AND br.startDate <= ? ");
            params.add(toDate);
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số mượn sách cho thủ thư", e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy {@code status} của một phiếu mượn theo ID.
     *
     * <p>Dùng cho guard check trong luồng duyệt thanh toán fine:
     * chặn thanh toán nếu sách chưa được trả vật lý.
     * Trạng thái hợp lệ để được phép thanh toán: {@code returned}, {@code lost}, {@code damaged}.</p>
     *
     * @param conn           Connection trong Transaction
     * @param borrowRecordId ID phiếu mượn cần tra cứu
     * @return Chuỗi status hiện tại; {@code null} nếu không tìm thấy bản ghi
     * @throws SQLException nếu có lỗi truy vấn
     */
    // EARS[Guard]: WHEN payment approval is triggered,
    // THE LMS System SHALL verify BorrowRecord.status is 'returned'|'lost'|'damaged' [BUG-FIX]
    public String findStatusById(Connection conn, int borrowRecordId) throws SQLException {
        String sql = "SELECT status FROM BorrowRecord WHERE borrowRecordId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowRecordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("status");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi lấy status BorrowRecord id=" + borrowRecordId, e);
            throw e;
        }
        return null;
    }
}
