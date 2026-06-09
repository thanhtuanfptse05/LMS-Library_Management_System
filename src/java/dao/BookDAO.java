package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Book;

/**
 * BookDAO — Data Access Object cho bảng [Book].
 *
 * <p>Bảng {@code Book} lưu thông tin đầu sách và quản lý số lượng kho
 * qua 2 cột: {@code totalQuantity} (tổng bản sao vật lý) và
 * {@code availableQuantity} (bản sao sẵn sàng cho mượn).
 * Hai cột này PHẢI được cập nhật đồng bộ trong các luồng Check-in F6.</p>
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
 * <p>Traceability: Mapping với Activity Diagram F6 — FR-F6-04 (Node 6.17 — totalQuantity),
 * FR-F6-06 (Node 9.22 — availableQuantity), PLAN.md §3.</p>
 */
public class BookDAO {

    private static final Logger LOGGER = Logger.getLogger(BookDAO.class.getName());

    /**
     * Tra cứu đầu sách theo ID, bao gồm giá gốc phục vụ tính phạt đền bù.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04) để lấy
     * {@code price} của sách nhằm tính toán số tiền phạt đền bù.
     * Hàm này cũng cần thiết để kiểm tra {@code totalQuantity} trước khi trừ.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần tra cứu
     * @return Đối tượng {@code Book} nếu tìm thấy; {@code null} nếu không tồn tại
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN damaged/lost check-in occurs,
    // THE LMS System SHALL query Book to get price for fine calculation [FR-F6-04]
    public Book findById(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, publisher, publicationYear, "
                   + "       price, totalQuantity, availableQuantity, [status], "
                   + "       createdAt, updatedAt "
                   + "FROM   [Book] "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu Book theo bookId=" + bookId, e);
            throw e;
        }

        return null;
    }

    /**
     * Giảm {@code totalQuantity} đi 1 khi một bản sao bị hỏng hoặc mất.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04 — Node 6.17)
     * để loại bỏ vĩnh viễn bản sao đó khỏi tổng tài sản thư viện (BR-24).
     * Thao tác này KHÔNG thay đổi {@code availableQuantity} vì bản sao đó
     * đang ở trạng thái 'borrowed' (không tính vào available) và sẽ chuyển
     * sang 'unavailable' (vẫn không tính vào available).</p>
     *
     * <p>Dùng {@code CASE WHEN} để đảm bảo {@code totalQuantity} không bao giờ
     * âm — bảo vệ tính nhất quán dữ liệu kho ngay cả khi có lỗi logic.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit. Việc commit/rollback
     * được kiểm soát hoàn toàn bởi {@code DeskCirculationService}.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần giảm tổng số lượng
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.BookCopyDAO#updateStatusToUnavailable(Connection, int, String)
     */
    // EARS[Event-driven]: WHEN Check-in condition IN ('damaged', 'lost'),
    // THE LMS System SHALL UPDATE Book.totalQuantity = totalQuantity - 1
    // WHERE bookId = ? [Node 6.17, FR-F6-04, BR-24]
    public void decrementTotalQuantity(Connection conn, int bookId) throws SQLException {
        // CASE WHEN: Đảm bảo totalQuantity không âm (floor = 0)
        String sql = "UPDATE [Book] "
                   + "SET    totalQuantity = CASE WHEN totalQuantity > 0 "
                   + "                           THEN totalQuantity - 1 "
                   + "                           ELSE 0 END, "
                   + "       updatedAt     = GETDATE() "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi giảm totalQuantity cho bookId=" + bookId, e);
            throw e;
        }
    }

    /**
     * Tăng {@code availableQuantity} lên 1 khi sách được trả nguyên vẹn và không có ai chờ.
     *
     * <p>Được gọi trong nhánh "Queue Empty" của luồng Check-in sách tốt
     * (FR-F6-06 — Node 9.22) khi {@code ReservationDAO.findNextInQueue()}
     * trả về {@code null}. Đồng thời, {@code BookCopyDAO.updateStatusToAvailable()}
     * phải được gọi trong cùng Transaction để cập nhật trạng thái bản sao.
     * Hai thao tác này PHẢI xảy ra cùng nhau để đảm bảo tính nhất quán giữa
     * số đếm kho và trạng thái bản sao vật lý.</p>
     *
     * <p>Dùng {@code CASE WHEN} để đảm bảo {@code availableQuantity} không vượt
     * quá {@code totalQuantity} — bảo vệ tính nhất quán nghiệp vụ kho.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận
     * {@code Connection} từ tham số và KHÔNG tự commit.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần tăng số lượng khả dụng
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.BookCopyDAO#updateStatusToAvailable(Connection, int)
     */
    // EARS[Condition-driven]: WHERE queue is empty after good return,
    // THE LMS System SHALL UPDATE Book.availableQuantity = availableQuantity + 1
    // WHERE bookId = ? [Node 9.22, FR-F6-06]
    public void incrementAvailableQuantity(Connection conn, int bookId) throws SQLException {
        // CASE WHEN: Đảm bảo availableQuantity không vượt totalQuantity
        String sql = "UPDATE [Book] "
                   + "SET    availableQuantity = CASE "
                   + "           WHEN availableQuantity < totalQuantity "
                   + "           THEN availableQuantity + 1 "
                   + "           ELSE availableQuantity END, "
                   + "       updatedAt         = GETDATE() "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tăng availableQuantity cho bookId=" + bookId, e);
            throw e;
        }
    }

    // ========================
    // PRIVATE HELPER METHODS
    // ========================

    /**
     * Ánh xạ một hàng của {@code ResultSet} sang đối tượng {@code Book}.
     *
     * <p>Xử lý an toàn cột {@code price} và {@code publicationYear}
     * có thể là NULL trong schema.</p>
     *
     * @param rs {@code ResultSet} đang trỏ đến hàng cần ánh xạ
     * @return Đối tượng {@code Book} đã được điền đầy đủ dữ liệu
     * @throws SQLException nếu tên cột không tồn tại hoặc có lỗi đọc dữ liệu
     */
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("bookId"));
        book.setIsbn(rs.getString("isbn"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPublisher(rs.getString("publisher"));

        // publicationYear là NULL-able
        int rawYear = rs.getInt("publicationYear");
        book.setPublicationYear(rs.wasNull() ? null : rawYear);

        // price là NULL-able — dùng getBigDecimal để tránh sai số tiền tệ
        BigDecimal price = rs.getBigDecimal("price");
        book.setPrice(price); // BigDecimal trả về null trực tiếp khi DB NULL

        book.setTotalQuantity(rs.getInt("totalQuantity"));
        book.setAvailableQuantity(rs.getInt("availableQuantity"));
        book.setStatus(rs.getString("status"));
        book.setCreatedAt(rs.getTimestamp("createdAt"));
        book.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return book;
    }
}
