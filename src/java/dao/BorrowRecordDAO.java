package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.BorrowRecord;

/**
 * BorrowRecordDAO — Data Access Object cho bảng [BorrowRecord].
 *
 * <p>Bảng {@code BorrowRecord} lưu toàn bộ lịch sử giao dịch mượn/trả sách.
 * Mỗi bản ghi được tạo tại thời điểm giao sách (Check-out) và được cập nhật
 * khi trả sách (Check-in). Đây là bảng trung tâm của module Desk Circulation.</p>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.
 *       Không sử dụng phép cộng chuỗi (String Concatenation) để tạo SQL.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC (PreparedStatement, ResultSet)
 *       được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>TRANS-01: Mọi hàm nhận {@code Connection} từ tham số để hỗ trợ
 *       Atomic Transaction được kiểm soát từ tầng Service. Hàm KHÔNG tự commit.</li>
 * </ul>
 *
 * <p>Traceability: Mapping với Activity Diagram F6 — FR-F6-03 (Check-out),
 * FR-F6-04, FR-F6-05 (Check-in), PLAN.md §3.</p>
 */
public class BorrowRecordDAO {

    private static final Logger LOGGER = Logger.getLogger(BorrowRecordDAO.class.getName());

    /**
     * Tạo mới một bản ghi mượn sách trong hệ thống.
     *
     * <p>Được gọi là bước đầu tiên trong Atomic Transaction của luồng Check-out
     * (Node 11.13 — FR-F6-03), sau khi đã xác minh người dùng hợp lệ và
     * Reservation đã ở trạng thái 'readypickup' (hoặc vừa được tạo walk-in).
     * Sau khi INSERT thành công, tầng Service tiếp tục:
     * <ol>
     *   <li>UPDATE {@code Reservation.status} = 'fulfilled'</li>
     *   <li>UPDATE {@code BookCopy.status} = 'borrowed'</li>
     * </ol>
     * Ba bước này PHẢI trong cùng một DB Transaction (CONTEXT.md §4 — Data Integrity).</p>
     *
     * <p>Hạn trả sách ({@code endDate}) được tính từ tầng Service dựa trên
     * cấu hình {@code SystemConfigurations.borrowDurationDays}.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit. Việc commit/rollback
     * được kiểm soát hoàn toàn bởi {@code DeskCirculationService}.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param userId     ID người dùng mượn sách
     * @param bookCopyId ID bản sao sách được mượn
     * @param bookId     ID đầu sách được mượn
     * @param createdBy  ID thủ thư thực hiện thao tác giao sách
     * @param endDate    Hạn trả sách (tính bởi Service từ cấu hình hệ thống)
     * @return ID của bản ghi BorrowRecord vừa được tạo (GENERATED KEY)
     * @throws SQLException nếu có lỗi thực thi câu lệnh INSERT,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.ReservationDAO#updateStatusToFulfilled(Connection, int)
     * @see dao.BookCopyDAO#updateStatusToBorrowed(Connection, int)
     */
    // EARS[Event-driven]: WHEN Reservation is validated (status='readypickup'),
    // THE LMS System SHALL INSERT BorrowRecord
    // with status='borrowed', extensionCount=0 [Node 11.13, FR-F6-03]
    public int insert(Connection conn, int userId, int bookCopyId, int bookId,
                      int createdBy, Timestamp endDate) throws SQLException {
        String sql = "INSERT INTO [BorrowRecord] "
                   + "    (userId, bookCopyId, bookId, startDate, endDate, "
                   + "     [status], extensionCount, createdBy) "
                   + "VALUES (?, ?, ?, GETDATE(), ?, 'borrowed', 0, ?)";

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
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi INSERT BorrowRecord cho userId=" + userId
                    + ", bookCopyId=" + bookCopyId, e);
            throw e;
        }

        throw new SQLException(
                "INSERT BorrowRecord thất bại: không lấy được generated key. "
                + "userId=" + userId + ", bookCopyId=" + bookCopyId);
    }

    /**
     * Tra cứu bản ghi mượn đang active (status='borrowed') theo mã bản sao.
     *
     * <p>Được gọi trong luồng Check-in (Node 4.15) để xác định BorrowRecord
     * cần cập nhật khi nhận trả sách. Hàm tìm bản ghi duy nhất đang ở trạng
     * thái 'borrowed' cho {@code bookCopyId} được quét.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm nhận {@code Connection}
     * từ tham số để đảm bảo việc đọc xảy ra trong cùng Transaction với thao tác
     * UPDATE tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách đang được trả
     * @return ID của bản ghi BorrowRecord đang active; {@code -1} nếu không tìm thấy
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Librarian scans barcode for check-in,
    // THE LMS System SHALL find active BorrowRecord WHERE bookCopyId=? AND status='borrowed'
    // [FR-F6-05]
    public int findActiveBorrowRecordId(Connection conn, int bookCopyId) throws SQLException {
        String sql = "SELECT borrowRecordId "
                   + "FROM   [BorrowRecord] "
                   + "WHERE  bookCopyId = ? "
                   + "  AND  [status]   = 'borrowed'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("borrowRecordId");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tìm BorrowRecord active cho bookCopyId=" + bookCopyId, e);
            throw e;
        }

        return -1;
    }

    /**
     * Cập nhật trạng thái BorrowRecord thành 'returned' khi nhận sách trả nguyên vẹn.
     *
     * <p>Được gọi trong luồng Check-in sách tốt (FR-F6-05 — Node 6.18) để đánh dấu
     * giao dịch mượn đã hoàn tất. Đồng thời ghi nhận thời điểm trả thực tế
     * ({@code returnedAt = GETDATE()}) để phục vụ báo cáo và kiểm tra trễ hạn.</p>
     *
     * @param conn           {@code Connection} được quản lý bởi tầng Service
     *                       (đã {@code setAutoCommit(false)})
     * @param borrowRecordId ID bản ghi mượn cần cập nhật
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Check-in condition = 'good',
    // THE LMS System SHALL UPDATE BorrowRecord status='returned', returnedAt=GETDATE()
    // WHERE borrowRecordId = ? [Node 6.18, FR-F6-05]
    public void updateStatusToReturned(Connection conn, int borrowRecordId) throws SQLException {
        String sql = "UPDATE [BorrowRecord] "
                   + "SET    [status]    = 'returned', "
                   + "       returnedAt  = GETDATE() "
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
        String sql = "UPDATE [BorrowRecord] "
                   + "SET    [status]    = ?, "
                   + "       returnedAt  = GETDATE() "
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
     * <p>Khác biệt so với {@link #findActiveBorrowRecordId(Connection, int)}:
     * hàm này trả về toàn bộ đối tượng {@code BorrowRecord} (bao gồm
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
                   + "       startDate, endDate, returnedAt, [status], "
                   + "       extensionCount, createdBy, createdAt "
                   + "FROM   [BorrowRecord] "
                   + "WHERE  bookCopyId = ? "
                   + "  AND  [status]   = 'borrowed'";

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
}
