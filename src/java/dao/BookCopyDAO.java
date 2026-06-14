package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.BookCopy;

/**
 * BookCopyDAO — Data Access Object cho bảng [BookCopy].
 *
 * <p>Bảng {@code BookCopy} lưu thông tin từng bản sao vật lý của đầu sách.
 * Mỗi bản sao được định danh bằng {@code barcode} duy nhất dùng để quét
 * tại quầy thư viện trong các thao tác Check-out (giao sách) và Check-in
 * (nhận trả sách).</p>
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
 * FR-F6-04, FR-F6-05, FR-F6-06 (Check-in), PLAN.md §3.</p>
 */
public class BookCopyDAO {

    private static final Logger LOGGER = Logger.getLogger(BookCopyDAO.class.getName());

    /**
     * Tra cứu bản sao sách theo mã vạch (barcode).
     *
     * <p>Được gọi là bước đầu tiên trong cả luồng Check-out (Node 5.5) và
     * Check-in (Node 4.15) để xác định BookCopy cụ thể mà Thủ thư đang thao tác.
     * Nếu hàm trả về {@code null}, tầng Service ném {@code IllegalStateException}
     * với thông báo "Mã vạch không hợp lệ" (SPEC §6 — Error Handling).</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm nhận {@code Connection}
     * từ tham số để đảm bảo việc đọc BookCopy xảy ra trong cùng Transaction
     * với các thao tác ghi tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn    {@code Connection} được quản lý bởi tầng Service
     *                (đã {@code setAutoCommit(false)})
     * @param barcode Mã vạch cần tra cứu (nhập từ scanner)
     * @return Đối tượng {@code BookCopy} nếu tìm thấy; {@code null} nếu không tồn tại
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Librarian scans barcode,
    // THE LMS System SHALL query BookCopy WHERE barcode = ?
    // to validate physical copy existence [Node 5.5, FR-F6-03]
    public BookCopy findByBarcode(Connection conn, String barcode) throws SQLException {
        String sql = "SELECT bookCopyId, bookId, [location], condition, "
                   + "       [status], barcode, createdAt, updatedAt "
                   + "FROM   [BookCopy] "
                   + "WHERE  barcode = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, barcode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBookCopy(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu BookCopy theo barcode=" + barcode, e);
            throw e;
        }

        return null;
    }

    /**
     * Cập nhật trạng thái bản sao sách thành 'borrowed' khi giao sách.
     *
     * <p>Được gọi là bước cuối trong Atomic Transaction của luồng Check-out
     * (Node 11.13 — FR-F6-03), sau khi INSERT {@code BorrowRecord}
     * và UPDATE {@code Reservation} thành 'fulfilled' đã thành công.
     * Ba thao tác này PHẢI xảy ra trong cùng một DB Transaction để đảm bảo
     * tính nhất quán giữa bản ghi mượn và trạng thái kho.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách cần cập nhật trạng thái
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.BorrowRecordDAO#insert(Connection, int, int, int, int, Timestamp)
     * @see dao.ReservationDAO#updateStatusToFulfilled(Connection, int)
     */
    // EARS[Event-driven]: WHEN BorrowRecord is inserted AND Reservation is fulfilled,
    // THE LMS System SHALL UPDATE BookCopy.status = 'borrowed'
    // WHERE bookCopyId = ? [Node 11.13, FR-F6-03]
    public void updateStatusToBorrowed(Connection conn, int bookCopyId) throws SQLException {
        String sql = "UPDATE [BookCopy] "
                   + "SET    [status]   = 'borrowed', "
                   + "       updatedAt  = GETDATE() "
                   + "WHERE  bookCopyId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BookCopy thành 'borrowed' cho bookCopyId=" + bookCopyId, e);
            throw e;
        }
    }

    /**
     * Cập nhật trạng thái và tình trạng vật lý của bản sao sách khi nhận trả.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04) để ghi nhận
     * bản sao đã bị loại khỏi kho (status = 'unavailable') và cập nhật
     * tình trạng vật lý thực tế ('damaged' hoặc 'lost').</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách cần cập nhật
     * @param condition  Tình trạng vật lý mới ('damaged' hoặc 'lost')
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Check-in condition IN ('damaged', 'lost'),
    // THE LMS System SHALL UPDATE BookCopy status='unavailable', condition=?
    // WHERE bookCopyId = ? [FR-F6-04]
    public void updateStatusToUnavailable(Connection conn, int bookCopyId, String condition)
            throws SQLException {
        String sql = "UPDATE [BookCopy] "
                   + "SET    [status]   = 'unavailable', "
                   + "       condition  = ?, "
                   + "       updatedAt  = GETDATE() "
                   + "WHERE  bookCopyId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition);
            ps.setInt(2, bookCopyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BookCopy thành 'unavailable' cho bookCopyId=" + bookCopyId, e);
            throw e;
        }
    }

    /**
     * Cập nhật trạng thái bản sao sách thành 'available' khi không có người chờ.
     *
     * <p>Được gọi trong nhánh "Queue Empty" của luồng Check-in sách tốt (FR-F6-06)
     * khi {@code ReservationDAO.findNextInQueue()} trả về {@code null}.
     * Đồng thời phải cập nhật {@code Book.availableQuantity + 1} trong cùng
     * Transaction (xem {@code BookDAO.incrementAvailableQuantity}).</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách cần trả lại kho
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Condition-driven]: WHERE queue is empty after good return,
    // THE LMS System SHALL UPDATE BookCopy.status = 'available'
    // WHERE bookCopyId = ? [Node 9.22, FR-F6-06]
    public void updateStatusToAvailable(Connection conn, int bookCopyId) throws SQLException {
        String sql = "UPDATE [BookCopy] "
                   + "SET    [status]   = 'available', "
                   + "       condition  = 'good', "
                   + "       updatedAt  = GETDATE() "
                   + "WHERE  bookCopyId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BookCopy thành 'available' cho bookCopyId=" + bookCopyId, e);
            throw e;
        }
    }

    /**
     * Cập nhật trạng thái bản sao sách thành 'reserved' khi đẩy hàng chờ.
     *
     * <p>Được gọi trong nhánh "Has Queue" của luồng Check-in sách tốt (FR-F6-06)
     * khi tìm thấy người chờ tiếp theo. Bản sao được giữ cho người chờ đó
     * và không trở lại kho chung.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param bookCopyId ID bản sao sách cần đặt về 'reserved'
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Condition-driven]: WHERE next-in-queue found after good return,
    // THE LMS System SHALL UPDATE BookCopy.status = 'reserved'
    // WHERE bookCopyId = ? [Node 9.21, FR-F6-06]
    public void updateStatusToReserved(Connection conn, int bookCopyId) throws SQLException {
        String sql = "UPDATE [BookCopy] "
                   + "SET    [status]   = 'reserved', "
                   + "       updatedAt  = GETDATE() "
                   + "WHERE  bookCopyId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật BookCopy thành 'reserved' cho bookCopyId=" + bookCopyId, e);
            throw e;
        }
    }

    // ========================
    // PRIVATE HELPER METHODS
    // ========================

    /**
     * Ánh xạ một hàng của {@code ResultSet} sang đối tượng {@code BookCopy}.
     *
     * @param rs {@code ResultSet} đang trỏ đến hàng cần ánh xạ
     * @return Đối tượng {@code BookCopy} đã được điền đầy đủ dữ liệu
     * @throws SQLException nếu tên cột không tồn tại hoặc có lỗi đọc dữ liệu
     */
    private BookCopy mapResultSetToBookCopy(ResultSet rs) throws SQLException {
        BookCopy bc = new BookCopy();
        bc.setBookCopyId(rs.getInt("bookCopyId"));
        bc.setBookId(rs.getInt("bookId"));
        bc.setLocation(rs.getString("location"));
        bc.setCondition(rs.getString("condition"));
        bc.setStatus(rs.getString("status"));
        bc.setBarcode(rs.getString("barcode"));
        bc.setCreatedAt(rs.getTimestamp("createdAt"));
        bc.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return bc;
    }
}
