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

import model.Reservation;

/**
 * ReservationDAO — Data Access Object cho bảng [Reservation].
 *
 * <p>Bảng {@code Reservation} quản lý hàng đợi đặt trước sách của người dùng.
 * Một đơn đặt trước có thể ở các trạng thái: 'pending' (đang chờ),
 * 'readypickup' (sẵn sàng nhận), 'fulfilled' (đã nhận), 'cancelled' (hủy).
 * Thứ tự ưu tiên được xác định bởi {@code queuePosition}:
 * {@code 0} = đang được phục vụ, {@code 1} = người kế tiếp trong hàng chờ.</p>
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
 * <p>Traceability: Mapping với Activity Diagram F6 — FR-F6-02, FR-F6-03, FR-F6-06,
 * PLAN.md §3 (Luồng Check-in Sách Nguyên Vẹn).</p>
 */
public class ReservationDAO {

    private static final Logger LOGGER = Logger.getLogger(ReservationDAO.class.getName());

    /**
     * Tìm người dùng đang chờ tiếp theo trong hàng đợi đặt trước của một cuốn sách.
     *
     * <p>Được gọi trong luồng Check-in sách nguyên vẹn (Condition = 'good') tại
     * {@code DeskCirculationService.processCheckIn()}, ngay sau khi cập nhật
     * {@code BorrowRecord} và {@code BookCopy} thành công.
     * Nếu hàm trả về kết quả khác {@code null}, tầng Service sẽ:
     * <ol>
     *   <li>UPDATE {@code Reservation} của bản ghi tìm được:
     *       {@code queuePosition = 0}, {@code status = 'readypickup'},
     *       {@code bookCopyId = } (bản sao vừa trả về).</li>
     *   <li>Gửi email thông báo bất đồng bộ cho người dùng đó.</li>
     * </ol>
     * Nếu hàm trả về {@code null} (không có người chờ), tầng Service sẽ
     * UPDATE {@code Book.availableQuantity + 1} và {@code BookCopy.status = 'available'}.</p>
     *
     * <p><strong>Chiến lược Concurrency (SPEC §4 — NFR):</strong>
     * Câu SQL sử dụng {@code WITH (UPDLOCK, ROWLOCK)} hint để đặt Update Lock
     * trên row được chọn ngay trong lần đọc, ngăn chặn race condition khi 2 sách
     * được trả cùng lúc có thể gán cho cùng 1 người đang chờ.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận {@code Connection}
     * từ tham số và KHÔNG tự commit. Việc commit/rollback được kiểm soát hoàn toàn
     * bởi {@code DeskCirculationService} để đảm bảo tính nguyên tử của toàn bộ
     * luồng Check-in (PLAN.md §3 — Atomic Block).</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID cuốn sách cần tìm người chờ tiếp theo
     * @return Đối tượng {@code Reservation} của người đang chờ tiếp theo
     *         (có {@code queuePosition = 1} và {@code status = 'pending'});
     *         trả về {@code null} nếu không có ai trong hàng chờ
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.ReservationDAO#updateToReadyPickup(Connection, int, int)
     */
    // EARS[Condition-driven]: WHILE Check-in condition = 'good',
    // THE LMS System SHALL find Reservation WHERE bookId = ? AND queuePosition = 1 AND status = 'pending'
    // to evaluate queue-push condition [FR-F6-06, PLAN.md §3]
    public Reservation findNextInQueue(Connection conn, int bookId) throws SQLException {
        // UPDLOCK: Giữ Update Lock trên row ngay khi đọc để ngăn race condition
        // (2 sách trả cùng lúc không thể cùng đọc được 1 bản ghi chờ — SPEC §4)
        // ROWLOCK: Chỉ lock ở mức row, không lock toàn bộ page để tối ưu concurrency
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, "
                   + "       status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  bookId        = ? "
                   + "  AND  queuePosition = 1 "
                   + "  AND  status      = 'pending' "
                   + "FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tìm người chờ tiếp theo trong hàng đợi cho bookId=" + bookId, e);
            throw e;
        }

        return null;
    }

    /**
     * Cập nhật trạng thái Reservation thành 'readypickup' — đẩy người chờ tiếp theo lên nhận sách.
     *
     * <p>Được gọi ngay sau {@link #findNextInQueue(Connection, int)} trả về kết quả
     * khác {@code null} trong luồng Check-in sách nguyên vẹn (FR-F6-06).
     * Hàm này thực hiện đồng thời 3 thay đổi trên cùng một bản ghi Reservation:
     * <ul>
     *   <li>{@code queuePosition} = 0 (chuyển từ "chờ kế tiếp" sang "đang được phục vụ")</li>
     *   <li>{@code status} = 'readypickup' (người dùng có thể đến nhận)</li>
     *   <li>{@code bookCopyId} = ID bản sao sách vừa được trả về (gán cụ thể)</li>
     * </ul></p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận {@code Connection}
     * từ tham số và KHÔNG tự commit. Việc commit/rollback được kiểm soát hoàn toàn
     * bởi {@code DeskCirculationService}.</p>
     *
     * @param conn          {@code Connection} được quản lý bởi tầng Service
     *                      (đã {@code setAutoCommit(false)})
     * @param reservationId ID bản ghi Reservation cần cập nhật
     * @param bookCopyId    ID bản sao sách được gán cho người chờ này
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.ReservationDAO#findNextInQueue(Connection, int)
     */
    // EARS[Event-driven]: WHEN next-in-queue Reservation is found,
    // THE LMS System SHALL UPDATE Reservation SET queuePosition=0, status='readypickup', bookCopyId=?
    // WHERE reservationId = ? [FR-F6-06]
    public void updateToReadyPickup(Connection conn, int reservationId, Integer bookCopyId) throws SQLException {
        // Mặc định sử dụng 3 ngày nếu không truyền cấu hình holdDays
        updateToReadyPickup(conn, reservationId, bookCopyId, 3);
    }

    /**
     * Cập nhật trạng thái của đơn đặt trước thành 'readypickup' (sẵn sàng nhận tại quầy).
     *
     * <p>Thiết lập queuePosition = 0, gán bookCopyId được cấp phát và set endDate quá hạn nhận sách
     * theo cấu hình số ngày giữ sách động.</p>
     *
     * @param conn          {@code Connection} trong Transaction
     * @param reservationId ID của đơn đặt trước cần cập nhật
     * @param bookCopyId    ID bản sao sách vật lý được cấp phát cho đơn đặt trước (có thể là null)
     * @param holdDays      Số ngày giữ sách cấu hình động
     * @throws SQLException nếu có lỗi SQL
     */
    public void updateToReadyPickup(Connection conn, int reservationId, Integer bookCopyId, int holdDays) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    queuePosition = 0, "
                   + "       status        = 'readypickup', "
                   + "       bookCopyId    = ?, "
                   + "       endDate       = NOW() + CAST(? || ' days' AS INTERVAL) "
                   + "WHERE  reservationId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (bookCopyId != null) {
                ps.setInt(1, bookCopyId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setInt(2, holdDays);
            ps.setInt(3, reservationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật Reservation thành 'readypickup' cho reservationId="
                    + reservationId, e);
            throw e;
        }
    }

    /**
     * Cập nhật trạng thái Reservation thành 'fulfilled' — đánh dấu đơn đặt trước đã hoàn tất.
     *
     * <p>Được gọi trong luồng Check-out (giao sách) — FR-F6-03 — sau khi
     * INSERT {@code BorrowRecord} thành công. Một Reservation với
     * {@code queuePosition = 0} và {@code status = 'readypickup'} (hoặc
     * một Reservation vừa được tạo mới tại quầy với {@code queuePosition = 0})
     * được chuyển sang 'fulfilled' để đóng vòng đời của đơn đặt trước.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận {@code Connection}
     * từ tham số và KHÔNG tự commit. Việc commit/rollback được kiểm soát hoàn toàn
     * bởi {@code DeskCirculationService}.</p>
     *
     * @param conn          {@code Connection} được quản lý bởi tầng Service
     *                      (đã {@code setAutoCommit(false)})
     * @param reservationId ID bản ghi Reservation cần đánh dấu hoàn tất
     * @param bookCopyId    ID bản sao sách được gán để hoàn tất đặt trước
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN BorrowRecord is inserted successfully,
    // THE LMS System SHALL UPDATE Reservation.status = 'fulfilled'
    // WHERE reservationId = ? [FR-F6-03]
    public void updateStatusToFulfilled(Connection conn, int reservationId, int bookCopyId) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    status = 'fulfilled', "
                   + "       bookCopyId = ? "
                   + "WHERE  reservationId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            ps.setInt(2, reservationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi cập nhật Reservation thành 'fulfilled' cho reservationId="
                    + reservationId, e);
            throw e;
        }
    }

    /**
     * Tạo mới một Reservation tại quầy (mượn trực tiếp, không có đơn đặt trước sẵn).
     *
     * <p>Được gọi trong kịch bản mượn trực tiếp (Walk-in) tại quầy — FR-F6-02 —
     * khi độc giả không có đơn đặt trước và hàng đợi đang trống.
     * Hệ thống tự động tạo một Reservation với {@code queuePosition = 0}
     * để chuẩn hóa luồng cấp phát sách (CONTEXT.md §2 — Domain Knowledge).
     * Sau đó tầng Service sẽ tiếp tục gọi INSERT {@code BorrowRecord}
     * và UPDATE {@code Reservation} thành 'fulfilled' trong cùng Transaction.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận {@code Connection}
     * từ tham số và KHÔNG tự commit. Việc commit/rollback được kiểm soát hoàn toàn
     * bởi {@code DeskCirculationService}.</p>
     *
     * @param conn       {@code Connection} được quản lý bởi tầng Service
     *                   (đã {@code setAutoCommit(false)})
     * @param userId     ID người dùng mượn trực tiếp
     * @param bookId     ID cuốn sách được mượn
     * @param bookCopyId ID bản sao sách cụ thể đang giao
     * @return ID của bản ghi Reservation vừa được tạo (GENERATED KEY)
     * @throws SQLException nếu có lỗi thực thi câu lệnh INSERT,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Condition-driven]: WHERE walk-in borrow AND queue is empty,
    // THE LMS System SHALL INSERT Reservation WITH queuePosition=0
    // to normalize the allocation flow [FR-F6-02, CONTEXT.md §2]
    public int insertWalkIn(Connection conn, int userId, int bookId, int bookCopyId)
            throws SQLException {
        String sql = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition) "
                   + "VALUES (?, ?, ?, 'pending', 0)";

        try (PreparedStatement ps = conn.prepareStatement(sql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, bookCopyId);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tạo Reservation walk-in cho userId=" + userId
                    + ", bookId=" + bookId, e);
            throw e;
        }

        throw new SQLException("Tạo Reservation walk-in thất bại: không lấy được generated key.");
    }

    /**
     * Kiểm tra xem một cuốn sách có người nào đang đứng trong hàng chờ không.
     *
     * <p>Được gọi trong kịch bản mượn trực tiếp (FR-F6-02) để kiểm tra điều kiện
     * BR-23: nếu đang có người chờ ({@code queuePosition > 0} và {@code status = 'pending'}),
     * hệ thống phải từ chối giao dịch walk-in để bảo vệ quyền ưu tiên của người
     * đã đặt trước.</p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm này nhận {@code Connection}
     * từ tham số để đảm bảo việc kiểm tra xảy ra trong cùng Transaction với thao tác
     * INSERT tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID cuốn sách cần kiểm tra hàng chờ
     * @return {@code true} nếu có ít nhất 1 người đang chờ ({@code queuePosition > 0});
     *         {@code false} nếu hàng chờ trống
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Condition-driven]: WHERE walk-in borrow request arrives,
    // THE LMS System SHALL check IF any Reservation exists WITH queuePosition > 0
    // to enforce BR-23 [FR-F6-02]
    public boolean hasQueuedReservation(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) "
                   + "FROM   Reservation "
                   + "WHERE  bookId        = ? "
                   + "  AND  queuePosition > 0 "
                   + "  AND  status      = 'pending'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi kiểm tra hàng chờ đặt trước cho bookId=" + bookId, e);
            throw e;
        }

        return false;
    }

    /**
     * Tìm Reservation hợp lệ của một người dùng cụ thể đang sẵn sàng nhận sách.
     *
     * <p>Được gọi tại Decision Node 7.8 trong luồng Check-out để phân nhánh:
     * người dùng đã có đơn đặt trước ({@code queuePosition = 0, status = 'readypickup'})
     * hay chưa (walk-in / mượn trực tiếp)?</p>
     *
     * <p>Logic phân nhánh của tầng Service sau khi gọi hàm này:
     * <ul>
     *   <li>Kết quả {@code != null}: Người dùng đã có Reservation hợp lệ.
     *       Tiến thẳng vào Node 11.13 (Execute Check-out Transaction).</li>
     *   <li>Kết quả {@code == null}: Walk-in — kiểm tra hàng chờ người khác
     *       qua {@link #hasQueuedReservation(Connection, int)} trước khi
     *       tạo Reservation tại chỗ qua {@link #insertWalkIn(Connection, int, int, int)}.</li>
     * </ul></p>
     *
     * <p><strong>Lưu ý Transaction (TRANS-01):</strong> Hàm nhận {@code Connection}
     * từ tham số để đảm bảo việc đọc nằm trong cùng Transaction với các thao tác
     * ghi tiếp theo, tránh TOCTOU race condition.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param userId ID người dùng cần kiểm tra đơn đặt trước
     * @param bookId ID cuốn sách đang xử lý Check-out
     * @return Đối tượng {@code Reservation} nếu người dùng có đơn đặt trước
     *         hợp lệ ({@code queuePosition = 0, status = 'readypickup'});
     *         {@code null} nếu không tìm thấy (walk-in scenario)
     * @throws SQLException nếu có lỗi thực thi truy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     *
     * @see dao.ReservationDAO#insertWalkIn(Connection, int, int, int)
     * @see dao.ReservationDAO#hasQueuedReservation(Connection, int)
     */
    // EARS[Condition-driven]: WHERE Check-out request arrives,
    // THE LMS System SHALL find Reservation WHERE userId=? AND bookId=?
    //   AND queuePosition=0 AND status='readypickup'
    // to route pre-reservation vs walk-in flow [Node 7.8, FR-F6-02]
    public Reservation findReadyPickupByUserAndBook(Connection conn, int userId, int bookId)
            throws SQLException {
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, "
                   + "       status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  userId        = ? "
                   + "  AND  bookId        = ? "
                   + "  AND  queuePosition = 0 "
                   + "  AND  status      = 'readypickup'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tìm Reservation 'readypickup' cho userId=" + userId
                    + ", bookId=" + bookId, e);
            throw e;
        }

        return null;
    }

    /**
     * Tìm danh sách các đơn đặt trước sẵn sàng nhận (status = 'readypickup') của một người dùng.
     *
     * @param conn   Connection trong Transaction
     * @param userId ID người dùng cần tra cứu
     * @return Danh sách các đơn đặt trước ở trạng thái 'readypickup'
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Reservation> findReadyPickupByUserId(Connection conn, int userId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.reservationId, r.userId, r.bookId, r.bookCopyId, "
                   + "       r.status, r.queuePosition, r.startDate, r.endDate, "
                   + "       b.title AS bookTitle "
                   + "FROM   Reservation r "
                   + "JOIN   Book b ON r.bookId = b.bookId "
                   + "WHERE  r.userId   = ? "
                   + "  AND  r.status = 'readypickup' "
                   + "ORDER BY r.startDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservationId"));
                    r.setUserId(rs.getInt("userId"));
                    r.setBookId(rs.getInt("bookId"));
                    int rawBookCopyId = rs.getInt("bookCopyId");
                    r.setBookCopyId(rs.wasNull() ? null : rawBookCopyId);
                    r.setStatus(rs.getString("status"));
                    int rawQueuePosition = rs.getInt("queuePosition");
                    r.setQueuePosition(rs.wasNull() ? null : rawQueuePosition);
                    r.setStartDate(rs.getTimestamp("startDate"));
                    r.setEndDate(rs.getTimestamp("endDate"));
                    r.setBookTitle(rs.getString("bookTitle"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm danh sách ready pickup cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Tạo mới một đơn đặt trước trực tuyến (có gán bản sao).
     */
    public int insertOnlineReservation(Connection conn, int userId, int bookId, int queuePosition, Integer bookCopyId) throws SQLException {
        String sql = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate) "
                   + "VALUES (?, ?, ?, ?, ?, NOW(), ?)";
        String status = (queuePosition == 0) ? "readypickup" : "pending";
        Timestamp endTs = null;
        if (queuePosition == 0) {
            // Hạn nhận sách mặc định là 3 ngày
            endTs = new Timestamp(System.currentTimeMillis() + 3L * 24 * 60 * 60 * 1000);
        }

        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            if (bookCopyId != null) {
                ps.setInt(3, bookCopyId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, status);
            ps.setInt(5, queuePosition);
            if (endTs != null) {
                ps.setTimestamp(6, endTs);
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }

            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo Reservation online cho userId=" + userId + ", bookId=" + bookId, e);
            throw e;
        }
        throw new SQLException("Tạo Reservation online thất bại: không lấy được generated key.");
    }

    /**
     * Tạo mới một đơn đặt trước trực tuyến (không gán bản sao).
     */
    public int insertOnlineReservation(Connection conn, int userId, int bookId, int queuePosition) throws SQLException {
        return insertOnlineReservation(conn, userId, bookId, queuePosition, null);
    }


    /**
     * Đếm số đơn đặt trước đang hoạt động (pending hoặc readypickup) của một người dùng.
     */
    public int countActiveReservationsByUser(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reservation WHERE userId = ? AND status IN ('pending', 'readypickup')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số đơn đặt trước hoạt động của userId=" + userId, e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy danh sách đơn đặt trước đang hoạt động (pending hoặc readypickup) của một người dùng.
     */
    public List<Reservation> findActiveReservationsByUserId(Connection conn, int userId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, "
                   + "       status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  userId   = ? "
                   + "  AND  status IN ('pending', 'readypickup') "
                   + "ORDER BY startDate DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm danh sách đặt trước hoạt động cho userId=" + userId, e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy thông tin đơn đặt trước bằng ID.
     */
    public Reservation findReservationById(Connection conn, int reservationId) throws SQLException {
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, "
                   + "       status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  reservationId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm Reservation bằng ID=" + reservationId, e);
            throw e;
        }
        return null;
    }

    /**
     * Hủy đơn đặt trước.
     */
    public void cancelReservation(Connection conn, int reservationId, int userId) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    status = 'cancelled', "
                   + "       queuePosition = NULL, "
                   + "       endDate = NOW() "
                   + "WHERE  reservationId = ? AND userId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi hủy Reservation cho reservationId=" + reservationId + ", userId=" + userId, e);
            throw e;
        }
    }

    // ========================
    // PRIVATE HELPER METHODS
    // ========================

    /**
     * Ánh xạ một hàng của {@code ResultSet} sang đối tượng {@code Reservation}.
     *
     * <p>Hàm tiện ích nội bộ, được tái sử dụng bởi các hàm SELECT trong cùng DAO.
     * Xử lý an toàn cột {@code bookCopyId} có thể là NULL trong DB
     * (dùng {@code rs.getObject} thay vì {@code rs.getInt} để tránh trả về 0
     * khi giá trị DB là NULL).</p>
     *
     * @param rs {@code ResultSet} đang trỏ đến hàng cần ánh xạ
     * @return Đối tượng {@code Reservation} đã được điền đầy đủ dữ liệu
     * @throws SQLException nếu tên cột không tồn tại hoặc có lỗi đọc dữ liệu
     */
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setReservationId(rs.getInt("reservationId"));
        r.setUserId(rs.getInt("userId"));
        r.setBookId(rs.getInt("bookId"));

        // bookCopyId là NULL-able trong schema — dùng getObject để phân biệt NULL vs 0
        int rawBookCopyId = rs.getInt("bookCopyId");
        r.setBookCopyId(rs.wasNull() ? null : rawBookCopyId);

        r.setStatus(rs.getString("status"));

        // queuePosition là NULL-able trong schema
        int rawQueuePosition = rs.getInt("queuePosition");
        r.setQueuePosition(rs.wasNull() ? null : rawQueuePosition);

        r.setStartDate(rs.getTimestamp("startDate"));
        r.setEndDate(rs.getTimestamp("endDate"));
        return r;
    }

    /**
     * Dịch chuyển các vị trí tiếp sau trong hàng đợi của cùng một cuốn sách.
     *
     * <p>Được gọi khi một đơn đặt trước ở vị trí 1 được chuyển thành vị trí 0 (readypickup)
     * (FR-F6-06). Các độc giả xếp hàng phía sau ở vị trí 2, 3... sẽ được đẩy lên vị trí 1, 2...</p>
     *
     * @param conn   {@code Connection} trong Transaction
     * @param bookId ID cuốn sách cần dịch chuyển hàng đợi
     * @throws SQLException nếu có lỗi thực thi câu lệnh SQL
     */
    public void decrementQueuePositions(Connection conn, int bookId) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    queuePosition = queuePosition - 1 "
                   + "WHERE  bookId        = ? "
                   + "  AND  queuePosition > 1 "
                   + "  AND  status      = 'pending'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            int rowsAffected = ps.executeUpdate();
            LOGGER.log(Level.INFO, "Đã dịch chuyển hàng đợi cho bookId={0}, số bản ghi cập nhật={1}",
                    new Object[]{bookId, rowsAffected});
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi dịch chuyển hàng đợi cho bookId=" + bookId, e);
            throw e;
        }
    }

    /**
     * Tìm các đơn đặt trước ở trạng thái 'readypickup' và đã quá hạn nhận sách (endDate < NOW()).
     *
     * @param conn {@code Connection} tương tác DB
     * @return danh sách các Reservation quá hạn nhận sách
     * @throws SQLException nếu có lỗi truy vấn SQL
     */
    public List<Reservation> findExpiredReservations(Connection conn) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  status = 'readypickup' "
                   + "  AND  endDate < NOW()";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Reservation quá hạn", e);
            throw e;
        }
        return list;
    }

    /**
     * Lấy đơn đặt trước theo ID và áp dụng khóa độc quyền FOR UPDATE để tránh race condition.
     *
     * @param conn          {@code Connection} trong Transaction
     * @param reservationId ID đơn đặt trước cần khóa
     * @return Reservation tương ứng hoặc null nếu không thấy
     * @throws SQLException nếu có lỗi SQL
     */
    public Reservation findReservationByIdForUpdate(Connection conn, int reservationId) throws SQLException {
        String sql = "SELECT reservationId, userId, bookId, bookCopyId, status, queuePosition, startDate, endDate "
                   + "FROM   Reservation "
                   + "WHERE  reservationId = ? "
                   + "FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm Reservation bằng ID và khóa dòng FOR UPDATE cho ID=" + reservationId, e);
            throw e;
        }
        return null;
    }

    /**
     * Cập nhật trạng thái đơn đặt trước thành 'cancelled', giải phóng queuePosition và gán endDate = NOW().
     *
     * @param conn          {@code Connection} trong Transaction
     * @param reservationId ID đơn đặt trước cần cập nhật
     * @throws SQLException nếu có lỗi SQL
     */
    public void updateStatusToCancelled(Connection conn, int reservationId) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    status        = 'cancelled', "
                   + "       queuePosition = NULL, "
                   + "       endDate       = NOW() "
                   + "WHERE  reservationId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.executeUpdate();
            LOGGER.log(Level.INFO, "Đã cập nhật Reservation ID={0} sang 'cancelled' và xóa queuePosition", reservationId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật Reservation sang 'cancelled' cho ID=" + reservationId, e);
            throw e;
        }
    }

    /**
     * Dọn dẹp tự động các đơn đặt trước đã quá hạn nhận sách (Ready Pickup Expiration).
     *
     * <p>Được gọi ở đầu mỗi giao dịch tại Service để quét và hủy các Reservation quá hạn nhận sách
     * (quá {@code endDate} mà status vẫn là 'readypickup'). 
     * Hệ thống sẽ:
     * <ol>
     *   <li>Chuyển trạng thái Reservation thành 'cancelled'.</li>
     *   <li>Giải phóng BookCopy tương ứng thành 'available'.</li>
     *   <li>Tăng Book.availableQuantity lên 1 đơn vị.</li>
     * </ol></p>
     *
     * @param conn {@code Connection} trong Transaction
     * @throws SQLException nếu có lỗi thực thi SQL
     */
    public void cancelExpiredReservations(Connection conn) throws SQLException {
        // Tìm các Reservation quá hạn
        String selectSql = "SELECT reservationId, bookCopyId, bookId "
                         + "FROM   Reservation "
                         + "WHERE  status = 'readypickup' "
                         + "  AND  endDate  < NOW() "
                         + "FOR UPDATE";

        String updateResSql = "UPDATE Reservation "
                            + "SET    status = 'cancelled' "
                            + "WHERE  reservationId = ?";

        String updateCopySql = "UPDATE BookCopy "
                             + "SET    status = 'available' "
                             + "WHERE  bookCopyId = ?";

        String updateBookSql = "UPDATE Book "
                             + "SET    availableQuantity = availableQuantity + 1 "
                             + "WHERE  bookId = ?";

        try (PreparedStatement psSelect = conn.prepareStatement(selectSql);
             PreparedStatement psUpdateRes = conn.prepareStatement(updateResSql);
             PreparedStatement psUpdateCopy = conn.prepareStatement(updateCopySql);
             PreparedStatement psUpdateBook = conn.prepareStatement(updateBookSql)) {

            try (ResultSet rs = psSelect.executeQuery()) {
                while (rs.next()) {
                    int reservationId = rs.getInt("reservationId");
                    int bookCopyId = rs.getInt("bookCopyId");
                    boolean hasCopy = !rs.wasNull();
                    int bookId = rs.getInt("bookId");

                    // 1. Cập nhật Reservation sang cancelled
                    psUpdateRes.setInt(1, reservationId);
                    psUpdateRes.executeUpdate();

                    if (hasCopy) {
                        // 2. Cập nhật BookCopy sang available
                        psUpdateCopy.setInt(1, bookCopyId);
                        psUpdateCopy.executeUpdate();

                        // 3. Tăng availableQuantity của Book
                        psUpdateBook.setInt(1, bookId);
                        psUpdateBook.executeUpdate();

                        LOGGER.log(Level.INFO, 
                            "[READY PICKUP EXPIRATION] Đã hủy đơn đặt trước quá hạn #{0}, "
                            + "giải phóng bản sao #{1} của đầu sách #{2}", 
                            new Object[]{reservationId, bookCopyId, bookId});
                    } else {
                        LOGGER.log(Level.INFO, 
                            "[READY PICKUP EXPIRATION] Đã hủy đơn đặt trước quá hạn #{0} (chưa được gán bản sao)", 
                            new Object[]{reservationId});
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tự động dọn dẹp đặt trước quá hạn nhận sách", e);
            throw e;
        }
    }

    /**
     * Kiểm tra xem người dùng đã có đơn đặt trước đang hoạt động (pending/readypickup) cho cuốn sách này chưa.
     */
    public boolean hasActiveReservation(Connection conn, int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reservation WHERE userId = ? AND bookId = ? AND status IN ('pending', 'readypickup')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra đặt trước trùng lặp cho userId=" + userId + ", bookId=" + bookId, e);
            throw e;
        }
        return false;
    }

    /**
     * Dịch chuyển các vị trí tiếp sau trong hàng đợi của cùng một cuốn sách khi một đơn hàng chờ bị hủy.
     */
    public void shiftQueuePositions(Connection conn, int bookId, int queuePosition) throws SQLException {
        String sql = "UPDATE Reservation "
                   + "SET    queuePosition = queuePosition - 1 "
                   + "WHERE  bookId        = ? "
                   + "  AND  queuePosition > ? "
                   + "  AND  status      = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.setInt(2, queuePosition);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi dịch chuyển vị trí hàng đợi cho bookId=" + bookId + ", queuePosition=" + queuePosition, e);
            throw e;
        }
    }

    /**
     * Lấy vị trí hàng chờ lớn nhất hiện tại của một cuốn sách.
     *
     * @deprecated Không sử dụng hàm này độc lập do nguy cơ TOCTOU race condition.
     *             Dùng {@link #insertIntoPendingQueueAtomic(Connection, int, int)} thay thế.
     */
    @Deprecated
    public int getMaxQueuePosition(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(queuePosition), 0) FROM Reservation WHERE bookId = ? AND status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy max queuePosition cho bookId=" + bookId, e);
            throw e;
        }
        return 0;
    }

    /**
     * Thêm người dùng vào hàng chờ đặt trước theo cách ATOMIC — không có TOCTOU race condition.
     *
     * <p>Thay vì 2 bước riêng biệt (đọc MAX rồi INSERT có thể bị race condition chen vào),
     * hàm này dùng {@code INSERT ... SELECT} để tính toán và ghi {@code queuePosition}
     * trong một câu SQL duy nhất, được bảo vệ bởi PostgreSQL row-level lock.
     * Kết hợp với {@code SELECT Book FOR UPDATE} trong Service, toàn bộ luồng đặt chờ
     * được bảo vệ tuyệt đối: 2 Transaction không thể gán cùng {@code queuePosition}.</p>
     *
     * <p><strong>Tại sao an toàn:</strong> {@code FOR UPDATE} trên bảng {@code Book}
     * (được gọi trước trong Service) buộc các Transaction serialize với nhau.
     * Khi Transaction A giữ lock, B bị block. Khi A commit và B tiếp tục,
     * B sẽ tính lại MAX từ dữ liệu đã được A ghi — đảm bảo không bao giờ trùng.</p>
     *
     * @param conn   {@code Connection} đã {@code setAutoCommit(false)}, đang trong Transaction
     * @param userId ID người dùng cần xếp hàng chờ
     * @param bookId ID cuốn sách muốn đặt trước
     * @return ID của Reservation vừa được tạo (GENERATED KEY)
     * @throws SQLException nếu có lỗi SQL, cho phép Service rollback
     */
    public int insertIntoPendingQueueAtomic(Connection conn, int userId, int bookId) throws SQLException {
        // INSERT ... SELECT: tính MAX(queuePosition) và INSERT trong 1 câu SQL không thể bị race
        String sql = "INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate) "
                   + "SELECT ?, ?, NULL, 'pending', "
                   + "       COALESCE(MAX(r2.queuePosition), 0) + 1, "
                   + "       NOW(), NULL "
                   + "FROM   Reservation r2 "
                   + "WHERE  r2.bookId = ? AND r2.status = 'pending'";

        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, bookId);
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi thêm vào hàng chờ đặt trước (atomic) cho userId=" + userId
                    + ", bookId=" + bookId, e);
            throw e;
        }
        throw new SQLException("Thêm vào hàng chờ atomic thất bại: không lấy được generated key.");
    }

    /**
     * Đếm số yêu cầu đặt trước sách đang ở trạng thái 'pending'.
     */
    public int countPendingReservations(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reservation WHERE status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm số đơn đặt trước pending", e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy danh sách các yêu cầu đặt trước đang ở trạng thái 'pending' kèm thông tin độc giả và sách.
     */
    public List<Reservation> findPendingReservations(Connection conn, int limit) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.reservationId, r.userId, r.bookId, r.bookCopyId, r.status, r.queuePosition, r.startDate, r.endDate, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM Reservation r "
                   + "JOIN MemberProfile mp ON r.userId = mp.userId "
                   + "JOIN Book b ON r.bookId = b.bookId "
                   + "LEFT JOIN Student s ON r.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON r.userId = l.userId "
                   + "WHERE r.status = 'pending' "
                   + "ORDER BY r.startDate DESC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservationId"));
                    r.setUserId(rs.getInt("userId"));
                    r.setBookId(rs.getInt("bookId"));
                    
                    int rawBookCopyId = rs.getInt("bookCopyId");
                    r.setBookCopyId(rs.wasNull() ? null : rawBookCopyId);
                    
                    r.setStatus(rs.getString("status"));
                    
                    int rawQueuePosition = rs.getInt("queuePosition");
                    r.setQueuePosition(rs.wasNull() ? null : rawQueuePosition);
                    
                    r.setStartDate(rs.getTimestamp("startDate"));
                    r.setEndDate(rs.getTimestamp("endDate"));
                    r.setMemberName(rs.getString("memberName"));
                    r.setMemberCode(rs.getString("memberCode"));
                    r.setBookTitle(rs.getString("bookTitle"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách đặt trước pending", e);
            throw e;
        }
        return list;
    }

    // =========================================================================
    // LIBRARIAN DASHBOARD — READY PICKUP LIST
    // =========================================================================

    /**
     * Lấy danh sách đặt trước đã sẵn sàng để lấy sách (status='readypickup')
     * cho Librarian Dashboard, kèm tên thành viên, mã thành viên, tên sách.
     *
     * @param conn  Kết nối DB
     * @param limit Giới hạn số bản ghi
     * @return Danh sách Reservation chờ lấy sách
     * @throws SQLException nếu có lỗi DB
     */
    public List<Reservation> findReadyPickupReservations(Connection conn, int limit) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.reservationId, r.userId, r.bookId, r.bookCopyId, r.status, r.queuePosition, r.startDate, r.endDate, "
                   + "       mp.fullName AS memberName, "
                   + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
                   + "       b.title AS bookTitle "
                   + "FROM Reservation r "
                   + "JOIN MemberProfile mp ON r.userId = mp.userId "
                   + "JOIN Book b ON r.bookId = b.bookId "
                   + "LEFT JOIN Student s ON r.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON r.userId = l.userId "
                   + "WHERE r.status = 'readypickup' "
                   + "ORDER BY r.endDate ASC "
                   + "LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservationId"));
                    r.setUserId(rs.getInt("userId"));
                    r.setBookId(rs.getInt("bookId"));
                    int rawBookCopyId = rs.getInt("bookCopyId");
                    r.setBookCopyId(rs.wasNull() ? null : rawBookCopyId);
                    r.setStatus(rs.getString("status"));
                    int rawQueuePosition = rs.getInt("queuePosition");
                    r.setQueuePosition(rs.wasNull() ? null : rawQueuePosition);
                    r.setStartDate(rs.getTimestamp("startDate"));
                    r.setEndDate(rs.getTimestamp("endDate"));
                    r.setMemberName(rs.getString("memberName"));
                    r.setMemberCode(rs.getString("memberCode"));
                    r.setBookTitle(rs.getString("bookTitle"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Reservation sẵn sàng lấy sách", e);
            throw e;
        }
        return list;
    }

    /**
     * Tra cứu danh sách hàng chờ đặt trước cho Thủ thư với bộ lọc từ khóa, trạng thái và phân trang.
     *
     * @param conn    Kết nối CSDL
     * @param keyword Từ khóa tìm kiếm (tên độc giả, mã độc giả, tên sách, ISBN)
     * @param status  Trạng thái ('all', 'pending', 'readypickup', 'fulfilled', 'cancelled')
     * @param offset  Vị trí bắt đầu bản ghi
     * @param limit   Số bản ghi trên 1 trang
     * @return Danh sách các đơn Reservation thỏa mãn điều kiện
     * @throws SQLException nếu có lỗi truy vấn SQL
     */
    public List<Reservation> findReservationQueueForLibrarian(Connection conn, String keyword, String status, int offset, int limit) throws SQLException {
        return findReservationQueueForLibrarian(conn, keyword, status, "queuePosition", "ASC", offset, limit);
    }

    public List<Reservation> findReservationQueueForLibrarian(Connection conn, String keyword, String status, String sortBy, String sortOrder, int offset, int limit) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.reservationId, r.userId, r.bookId, r.bookCopyId, r.status, r.queuePosition, r.startDate, r.endDate, "
          + "       mp.fullName AS memberName, "
          + "       COALESCE(s.studentCode, l.lecturerCode) AS memberCode, "
          + "       b.title AS bookTitle "
          + "FROM Reservation r "
          + "JOIN MemberProfile mp ON r.userId = mp.userId "
          + "JOIN Book b ON r.bookId = b.bookId "
          + "LEFT JOIN Student s ON r.userId = s.userId "
          + "LEFT JOIN Lecturer l ON r.userId = l.userId "
          + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND r.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (mp.fullName ILIKE ? OR s.studentCode ILIKE ? OR l.lecturerCode ILIKE ? OR b.title ILIKE ? OR b.isbn ILIKE ?) ");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        String orderCol;
        if ("startDate".equalsIgnoreCase(sortBy) || "date".equalsIgnoreCase(sortBy)) {
            orderCol = "r.startDate";
        } else if ("endDate".equalsIgnoreCase(sortBy) || "expire".equalsIgnoreCase(sortBy)) {
            orderCol = "r.endDate";
        } else if ("bookTitle".equalsIgnoreCase(sortBy) || "title".equalsIgnoreCase(sortBy)) {
            orderCol = "b.title";
        } else if ("memberName".equalsIgnoreCase(sortBy) || "name".equalsIgnoreCase(sortBy)) {
            orderCol = "mp.fullName";
        } else if ("reservationId".equalsIgnoreCase(sortBy) || "id".equalsIgnoreCase(sortBy)) {
            orderCol = "r.reservationId";
        } else {
            orderCol = "CASE WHEN r.queuePosition IS NULL THEN 99999 ELSE r.queuePosition END";
        }

        String orderDir = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
        sql.append(" ORDER BY ").append(orderCol).append(" ").append(orderDir).append(", r.reservationId DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservationId"));
                    r.setUserId(rs.getInt("userId"));
                    r.setBookId(rs.getInt("bookId"));
                    int rawBookCopyId = rs.getInt("bookCopyId");
                    r.setBookCopyId(rs.wasNull() ? null : rawBookCopyId);
                    r.setStatus(rs.getString("status"));
                    int rawQueuePos = rs.getInt("queuePosition");
                    r.setQueuePosition(rs.wasNull() ? null : rawQueuePos);
                    r.setStartDate(rs.getTimestamp("startDate"));
                    r.setEndDate(rs.getTimestamp("endDate"));
                    r.setMemberName(rs.getString("memberName"));
                    r.setMemberCode(rs.getString("memberCode"));
                    r.setBookTitle(rs.getString("bookTitle"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi truy vấn danh sách hàng chờ đặt trước cho Thủ thư", e);
            throw e;
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi hàng chờ đặt trước thỏa mãn bộ lọc cho Thủ thư (dùng cho phân trang).
     */
    public int countReservationQueueForLibrarian(Connection conn, String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) "
          + "FROM Reservation r "
          + "JOIN MemberProfile mp ON r.userId = mp.userId "
          + "JOIN Book b ON r.bookId = b.bookId "
          + "LEFT JOIN Student s ON r.userId = s.userId "
          + "LEFT JOIN Lecturer l ON r.userId = l.userId "
          + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND r.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (mp.fullName ILIKE ? OR s.studentCode ILIKE ? OR l.lecturerCode ILIKE ? OR b.title ILIKE ? OR b.isbn ILIKE ?) ");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
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
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số bản ghi hàng chờ đặt trước cho Thủ thư", e);
            throw e;
        }
        return 0;
    }

    /**
     * Lấy vị trí hàng chờ pending cao nhất hiện tại của một cuốn sách (dùng cho validation reorder).
     */
    public int getMaxPendingQueuePositionForBook(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(queuePosition), 0) FROM Reservation WHERE bookId = ? AND status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy MAX queuePosition (pending) cho bookId=" + bookId, e);
            throw e;
        }
        return 0;
    }

    /**
     * Thay đổi vị trí hàng chờ (reorder queue position) của một đơn đặt trước đang ở trạng thái 'pending'.
     *
     * @param conn          Kết nối CSDL trong cùng Transaction
     * @param bookId        ID cuốn sách
     * @param reservationId ID đơn đặt trước cần đổi vị trí
     * @param oldPos        Vị trí hàng chờ cũ
     * @param newPos        Vị trí hàng chờ mới
     * @throws SQLException nếu có lỗi SQL
     */
    public void reorderQueuePosition(Connection conn, int bookId, int reservationId, int oldPos, int newPos) throws SQLException {
        if (oldPos == newPos) {
            return;
        }

        if (newPos < oldPos) {
            // Case 1: Đôn lên (Move Up) — các đơn từ newPos đến (oldPos - 1) sẽ +1 vị trí
            String shiftSql = "UPDATE Reservation "
                            + "SET    queuePosition = queuePosition + 1 "
                            + "WHERE  bookId        = ? "
                            + "  AND  queuePosition >= ? "
                            + "  AND  queuePosition < ? "
                            + "  AND  status        = 'pending'";
            try (PreparedStatement psShift = conn.prepareStatement(shiftSql)) {
                psShift.setInt(1, bookId);
                psShift.setInt(2, newPos);
                psShift.setInt(3, oldPos);
                psShift.executeUpdate();
            }
        } else {
            // Case 2: Đẩy xuống (Move Down) — các đơn từ (oldPos + 1) đến newPos sẽ -1 vị trí
            String shiftSql = "UPDATE Reservation "
                            + "SET    queuePosition = queuePosition - 1 "
                            + "WHERE  bookId        = ? "
                            + "  AND  queuePosition > ? "
                            + "  AND  queuePosition <= ? "
                            + "  AND  status        = 'pending'";
            try (PreparedStatement psShift = conn.prepareStatement(shiftSql)) {
                psShift.setInt(1, bookId);
                psShift.setInt(2, oldPos);
                psShift.setInt(3, newPos);
                psShift.executeUpdate();
            }
        }

        // Cập nhật vị trí mới cho đơn đặt trước mục tiêu
        String updateTargetSql = "UPDATE Reservation "
                               + "SET    queuePosition = ? "
                               + "WHERE  reservationId = ? "
                               + "  AND  status        = 'pending'";
        try (PreparedStatement psTarget = conn.prepareStatement(updateTargetSql)) {
            psTarget.setInt(1, newPos);
            psTarget.setInt(2, reservationId);
            int rows = psTarget.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Cập nhật vị trí mới cho đơn đặt trước #" + reservationId + " thất bại (đơn không ở trạng thái pending).");
            }
        }

        LOGGER.log(Level.INFO, "Đã thay đổi vị trí hàng chờ cho Reservation #{0} từ {1} sang {2} (bookId={3})",
                new Object[]{reservationId, oldPos, newPos, bookId});
    }
}
