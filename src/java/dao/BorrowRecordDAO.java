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
     * Tra cứu đầy đủ bản ghi mượn đang active (status='borrowed') theo mã bản sao.
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
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách đang được trả
     * @return Đối tượng {@code BorrowRecord} đang active;
     *         {@code null} nếu không tìm thấy bản ghi 'borrowed'
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Librarian scans barcode for check-in,
    // THE LMS System SHALL find full active BorrowRecord WHERE bookCopyId=? AND status='borrowed'
    // to retrieve userId and bookId for subsequent operations [FR-F6-04, FR-F6-05]
    public BorrowRecord findActiveBorrowRecord(Connection conn, int bookCopyId)
            throws SQLException {
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  bookCopyId = ? "
                   + "  AND  status     = 'borrowed'";

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
     * Lấy danh sách các BorrowRecord đang active ('borrowed') của một người dùng.
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @return Danh sách các bản ghi mượn đang active
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<BorrowRecord> findActiveBorrowRecordsByUserId(Connection conn, int userId) throws SQLException {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT borrowRecordId, userId, bookCopyId, bookId, "
                   + "       startDate, endDate, returnedAt, status, "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   BorrowRecord "
                   + "WHERE  userId   = ? "
                   + "  AND  status   = 'borrowed' "
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
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách BorrowRecord active cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Đếm số sách đang mượn (status = 'borrowed') của một người dùng.
     */
    public int countActiveBorrowsByUser(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND status = 'borrowed'";
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
     * Kiểm tra xem người dùng có đang mượn cuốn sách này hay không.
     */
    public boolean hasActiveBorrowRecord(Connection conn, int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE userId = ? AND bookId = ? AND status = 'borrowed'";
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
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE status = 'borrowed' AND endDate < now()";
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
     * Lấy danh sách các khoản mượn đang hoạt động kèm thông tin độc giả và tiêu đề sách.
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
                   + "WHERE br.status = 'borrowed' "
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
                   + "WHERE  status = 'borrowed' AND endDate < NOW()";
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
}


