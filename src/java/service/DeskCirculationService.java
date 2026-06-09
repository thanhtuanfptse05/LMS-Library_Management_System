package service;

import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.PaymentDAO;
import dao.ReservationDAO;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import model.Book;
import model.BookCopy;
import model.BorrowRecord;
import model.Reservation;
import util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DeskCirculationService — Dịch vụ nghiệp vụ điều phối 3 luồng giao dịch vật lý tại quầy.
 *
 * <p>Lớp này là tầng Service trung tâm của Module F6 (Desk Circulation Operations).
 * Nó điều phối toàn bộ logic nghiệp vụ cho 3 luồng độc lập:
 * <ol>
 *   <li><strong>Check-out (Giao sách):</strong> {@link #processCheckOut(int, int, String)}</li>
 *   <li><strong>Check-in (Nhận sách):</strong> {@link #processCheckIn(int, String, String)}</li>
 *   <li><strong>Cash Payment (Thanh toán tiền mặt):</strong> {@link #approveCashPayment(int, int, int)}</li>
 * </ol></p>
 *
 * <p><strong>Nguyên tắc Transaction (CONTEXT.md §4 — Data Integrity):</strong>
 * Mọi thao tác ghi (Write) PHẢI đặt trong DB Transaction kiểm soát ở tầng này:
 * {@code conn.setAutoCommit(false)} ở đầu mỗi luồng,
 * {@code conn.commit()} khi toàn bộ thành công,
 * {@code conn.rollback()} khi có bất kỳ lỗi nào.</p>
 *
 * <p><strong>Phân loại ngoại lệ:</strong>
 * <ul>
 *   <li>{@code IllegalStateException}: Lỗi nghiệp vụ có thể hiển thị cho người dùng
 *       (ví dụ: BR-22 nợ phạt, BR-23 hàng chờ, barcode không hợp lệ).</li>
 *   <li>{@code SQLException}: Lỗi hạ tầng DB — ném thẳng lên Controller để log
 *       và hiển thị thông báo lỗi hệ thống.</li>
 * </ul></p>
 *
 * <p>Tuân thủ: ARCH-01 (JDBC thuần), SEC-03 (PreparedStatement qua DAO),
 * TRANS-01 (Connection truyền xuống DAO), ENG-03 (Email bất đồng bộ).</p>
 *
 * <p>Traceability: PLAN.md §2 (Components), ActivityDiagramF6.txt.</p>
 */
public class DeskCirculationService {

    private static final Logger LOGGER = Logger.getLogger(DeskCirculationService.class.getName());

    /** Số ngày mượn mặc định — nên đọc từ SystemConfigurations trong phiên bản sau */
    private static final int DEFAULT_BORROW_DAYS = 14;

    // =========================================================================
    // DAO Dependencies
    // =========================================================================

    private final UserLockReasonDAO userLockReasonDAO;
    private final ReservationDAO    reservationDAO;
    private final BookCopyDAO       bookCopyDAO;
    private final BorrowRecordDAO   borrowRecordDAO;
    private final BookDAO           bookDAO;
    private final FineDAO           fineDAO;
    private final UserDAO           userDAO;
    private final PaymentDAO        paymentDAO;

    /**
     * Constructor mặc định — khởi tạo tất cả DAO dependencies.
     *
     * <p>Dùng trong môi trường production khi Controller tạo Service.</p>
     */
    public DeskCirculationService() {
        this.userLockReasonDAO = new UserLockReasonDAO();
        this.reservationDAO    = new ReservationDAO();
        this.bookCopyDAO       = new BookCopyDAO();
        this.borrowRecordDAO   = new BorrowRecordDAO();
        this.bookDAO           = new BookDAO();
        this.fineDAO           = new FineDAO();
        this.userDAO           = new UserDAO();
        this.paymentDAO        = new PaymentDAO();
    }

    /**
     * Constructor phục vụ mục đích Testing (Dependency Injection).
     *
     * <p>Cho phép JUnit inject mock DAOs để kiểm thử logic Service
     * mà không cần kết nối DB thực.</p>
     *
     * @param userLockReasonDAO DAO kiểm tra lý do khóa tài khoản
     * @param reservationDAO    DAO quản lý hàng đợi đặt trước
     * @param bookCopyDAO       DAO quản lý bản sao sách
     * @param borrowRecordDAO   DAO quản lý bản ghi mượn
     */
    DeskCirculationService(UserLockReasonDAO userLockReasonDAO, ReservationDAO reservationDAO,
                           BookCopyDAO bookCopyDAO, BorrowRecordDAO borrowRecordDAO,
                           BookDAO bookDAO, FineDAO fineDAO, UserDAO userDAO,
                           PaymentDAO paymentDAO) {
        this.userLockReasonDAO = userLockReasonDAO;
        this.reservationDAO    = reservationDAO;
        this.bookCopyDAO       = bookCopyDAO;
        this.borrowRecordDAO   = borrowRecordDAO;
        this.bookDAO           = bookDAO;
        this.fineDAO           = fineDAO;
        this.userDAO           = userDAO;
        this.paymentDAO        = paymentDAO;
    }

    // =========================================================================
    // LUỒNG A: GIAO SÁCH (CHECK-OUT)
    // =========================================================================

    /**
     * Thực thi toàn bộ luồng giao sách (Check-out) trong một DB Transaction nguyên tử.
     *
     * <p>Luồng này bao gồm các bước xác thực và ghi dữ liệu theo Activity Diagram F6
     * Nhánh A (Node 4.4 → 12.14):</p>
     *
     * <p><strong>Bước 1 — Xác thực nợ phạt (BR-22, Node 6.6):</strong>
     * Kiểm tra bảng {@code UserLockReason} có bản ghi {@code reason = 'unpaid'}
     * cho {@code userId} không. Nếu có → ném {@code IllegalStateException}
     * với thông báo tiếng Việt để Controller hiển thị cho Thủ thư.</p>
     *
     * <p><strong>Bước 2 — Xác thực barcode (SPEC §6):</strong>
     * Tra cứu {@code BookCopy} theo barcode. Nếu không tìm thấy →
     * ném {@code IllegalStateException}.</p>
     *
     * <p><strong>Bước 3 — Phân nhánh Reservation (Node 7.8):</strong>
     * <ul>
     *   <li>Nhánh Pre-reservation: Tìm {@code Reservation} của user có
     *       {@code queuePosition=0, status='readypickup'} cho {@code bookId} này.
     *       Nếu tìm thấy → sử dụng Reservation đó.</li>
     *   <li>Nhánh Walk-in (Node 8.9): Không có Reservation sẵn →
     *       kiểm tra hàng chờ người khác. Nếu có người chờ ({@code queuePosition > 0}) →
     *       ném {@code IllegalStateException} (BR-23).
     *       Nếu hàng chờ trống → tự động INSERT Reservation walk-in.</li>
     * </ul></p>
     *
     * <p><strong>Bước 4 — Atomic Transaction (Node 11.13):</strong>
     * Trong một DB Transaction duy nhất ({@code setAutoCommit(false)}):
     * <ol>
     *   <li>INSERT {@code BorrowRecord} (status='borrowed', extensionCount=0)</li>
     *   <li>UPDATE {@code Reservation.status} = 'fulfilled'</li>
     *   <li>UPDATE {@code BookCopy.status} = 'borrowed'</li>
     * </ol>
     * → Commit nếu thành công, Rollback nếu bất kỳ bước nào thất bại.</p>
     *
     * <p><strong>Bước 5 — Email bất đồng bộ (Node 12.14, ENG-03):</strong>
     * Trigger email thông báo mượn sách NGOÀI Transaction để không làm chậm
     * luồng chính. Email gửi thất bại không ảnh hưởng đến Transaction đã commit.</p>
     *
     * @param librarianId ID Thủ thư đang thực hiện thao tác (ghi vào {@code createdBy})
     * @param userId      ID người dùng mượn sách
     * @param barcode     Mã vạch của bản sao sách (nhập từ barcode scanner)
     * @throws IllegalStateException nếu vi phạm quy tắc nghiệp vụ:
     *                               BR-22 (tài khoản nợ phạt),
     *                               BR-23 (mượn trực tiếp khi có người đặt trước),
     *                               hoặc barcode không hợp lệ (SPEC §6)
     * @throws SQLException          nếu có lỗi hạ tầng DB (không kết nối được,
     *                               ràng buộc DB bị vi phạm, v.v.)
     */
    // EARS[Event-driven]: WHEN Librarian submits Check-out form (userId + barcode),
    // THE LMS System SHALL validate user status, evaluate queue, THEN execute
    // atomic INSERT BorrowRecord + UPDATE Reservation + UPDATE BookCopy [FR-F6-01~03]
    public void processCheckOut(int librarianId, int userId, String barcode)
            throws IllegalStateException, SQLException {

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // BẮT ĐẦU TRANSACTION

            // ----------------------------------------------------------------
            // [Node 6.6 / FR-F6-01] BƯỚC 1: Xác thực nợ phạt — BR-22
            // Kiểm tra UserLockReason trước khi làm bất cứ điều gì khác.
            // ----------------------------------------------------------------
            // EARS[Condition-driven]: WHERE Check-out starts,
            // THE LMS System SHALL FAIL FAST if reason='unpaid' exists [BR-22]
            if (userLockReasonDAO.hasUnpaidReason(conn, userId)) {
                throw new IllegalStateException(
                        "Tài khoản đang nợ phạt, không thể mượn sách cho đến khi thanh toán xong.");
            }

            // ----------------------------------------------------------------
            // [Node 5.5 / SPEC §6] BƯỚC 2: Xác thực barcode — lấy BookCopy
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN barcode is scanned,
            // THE LMS System SHALL validate BookCopy existence [Node 5.5]
            BookCopy bookCopy = bookCopyDAO.findByBarcode(conn, barcode);
            if (bookCopy == null) {
                throw new IllegalStateException(
                        "Mã vạch '" + barcode + "' không hợp lệ hoặc không tồn tại trong hệ thống.");
            }

            int bookCopyId = bookCopy.getBookCopyId();
            int bookId     = bookCopy.getBookId();

            // ----------------------------------------------------------------
            // [Node 7.8 / FR-F6-02] BƯỚC 3: Phân nhánh Reservation
            // ----------------------------------------------------------------
            // EARS[Condition-driven]: WHERE user is valid,
            // THE LMS System SHALL route to pre-reservation OR walk-in flow [Node 7.8]
            Reservation reservation = reservationDAO.findReadyPickupByUserAndBook(
                    conn, userId, bookId);

            if (reservation == null) {
                // Nhánh Walk-in: người dùng KHÔNG có đơn đặt trước sẵn sàng
                // ---------------------------------------------------------------
                // [Node 8.9 / FR-F6-02] Kiểm tra hàng chờ của người khác — BR-23
                // EARS[Condition-driven]: WHERE no pre-reservation found,
                // THE LMS System SHALL check queue for other pending users [Node 8.9]
                if (reservationDAO.hasQueuedReservation(conn, bookId)) {
                    throw new IllegalStateException(
                            "Sách này đã được người khác đặt trước trong hàng đợi. "
                            + "Không thể mượn trực tiếp tại quầy.");
                }

                // [Node 10.12 / FR-F6-02] Hàng chờ rỗng — tạo Reservation walk-in
                // EARS[Event-driven]: WHERE queue is empty,
                // THE LMS System SHALL INSERT walk-in Reservation (queuePosition=0) [Node 10.12]
                int newReservationId = reservationDAO.insertWalkIn(
                        conn, userId, bookId, bookCopyId);
                reservation = new Reservation();
                reservation.setReservationId(newReservationId);
                reservation.setUserId(userId);
                reservation.setBookId(bookId);
                reservation.setBookCopyId(bookCopyId);
            }

            // ----------------------------------------------------------------
            // [Node 11.13 / FR-F6-03] BƯỚC 4: Thực thi Atomic Transaction
            // Thứ tự: INSERT BorrowRecord → UPDATE Reservation → UPDATE BookCopy
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN Reservation is confirmed,
            // THE LMS System SHALL execute atomic write: BorrowRecord + Reservation + BookCopy
            // [Node 11.13, FR-F6-03]

            // 4a. Tính hạn trả sách
            Timestamp endDate = calculateEndDate(DEFAULT_BORROW_DAYS);

            // 4b. INSERT BorrowRecord
            borrowRecordDAO.insert(conn, userId, bookCopyId, bookId, librarianId, endDate);

            // 4c. UPDATE Reservation → 'fulfilled'
            reservationDAO.updateStatusToFulfilled(conn, reservation.getReservationId());

            // 4d. UPDATE BookCopy → 'borrowed'
            bookCopyDAO.updateStatusToBorrowed(conn, bookCopyId);

            // ----------------------------------------------------------------
            // COMMIT: Toàn bộ 3 bước ghi thành công
            // ----------------------------------------------------------------
            conn.commit();
            LOGGER.log(Level.INFO,
                    "Check-out thành công: userId={0}, bookCopyId={1}, barcode={2}",
                    new Object[]{userId, bookCopyId, barcode});

            // ----------------------------------------------------------------
            // [Node 12.14 / PLAN.md §4] BƯỚC 5: Trigger Email BẤT ĐỒNG BỘ
            // Gọi NGOÀI Transaction — email lỗi không rollback nghiệp vụ đã commit.
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN Transaction commits,
            // THE LMS System SHALL trigger async email notification [Node 12.14]
            triggerCheckOutEmailAsync(userId, bookId, endDate);

        } catch (IllegalStateException e) {
            // Lỗi nghiệp vụ — rollback nếu connection đã mở, ném lên Controller
            rollbackQuietly(conn, "processCheckOut[BusinessRule]", userId);
            throw e;

        } catch (SQLException e) {
            // Lỗi DB — rollback và ném lên Controller để log lỗi hệ thống
            rollbackQuietly(conn, "processCheckOut[SQL]", userId);
            LOGGER.log(Level.SEVERE,
                    "Lỗi SQL trong processCheckOut: userId=" + userId + ", barcode=" + barcode, e);
            throw e;

        } finally {
            // ENG-01: Đảm bảo Connection luôn được đóng — tránh connection leak
            closeConnectionQuietly(conn, "processCheckOut", userId);
        }
    }

    // =========================================================================
    // LUỒNG B: NHẬN SÁCH (CHECK-IN)
    // =========================================================================

    /**
     * Thực thi toàn bộ luồng nhận sách (Check-in) trong một DB Transaction nguyên tử.
     *
     * <p>Luồng này rẽ nhánh theo tình trạng vật lý ({@code condition}) của bản sao
     * sách theo Activity Diagram F6 Nhánh B (Node 4.15 → 12.24):</p>
     *
     * <p><strong>Bước 1 — Xác thực barcode:</strong>
     * Tra cứu {@code BookCopy} theo barcode. Nếu không tìm thấy hoặc không ở
     * trạng thái 'borrowed' → ném {@code IllegalStateException}.</p>
     *
     * <p><strong>Bước 2 — Xác thực condition:</strong>
     * {@code condition} phải thuộc {'good', 'damaged', 'lost'}.
     * Giá trị không hợp lệ → ném {@code IllegalStateException}.</p>
     *
     * <p><strong>Nhánh A — condition IN ('damaged', 'lost') [FR-F6-04, BR-24]:</strong>
     * Trong một DB Transaction duy nhất:
     * <ol>
     *   <li>UPDATE {@code BorrowRecord.status} = condition, {@code returnedAt} = NOW</li>
     *   <li>UPDATE {@code BookCopy.status} = 'unavailable', {@code condition} = condition</li>
     *   <li>UPDATE {@code Book.totalQuantity} - 1 (loại khỏi tổng tài sản)</li>
     *   <li>INSERT {@code Fine} với số tiền đền bù (tính từ giá sách × hệ số)</li>
     *   <li>INSERT {@code UserLockReason(reason='unpaid')}</li>
     *   <li>UPDATE {@code [User].status} = 'locked'</li>
     * </ol></p>
     *
     * <p><strong>Nhánh B — condition == 'good' [FR-F6-05, FR-F6-06]:</strong>
     * Trong một DB Transaction duy nhất:
     * <ol>
     *   <li>UPDATE {@code BorrowRecord.status} = 'returned', {@code returnedAt} = NOW</li>
     *   <li>UPDATE {@code BookCopy.condition} = 'good'</li>
     *   <li>Tìm người chờ tiếp theo ({@code queuePosition=1, status='pending'}):
     *     <ul>
     *       <li>Có người chờ: UPDATE {@code Reservation} (queuePosition=0, readypickup, bookCopyId)
     *           + UPDATE {@code BookCopy.status} = 'reserved' + Email async</li>
     *       <li>Không có: UPDATE {@code Book.availableQuantity} + 1
     *           + UPDATE {@code BookCopy.status} = 'available'</li>
     *     </ul>
     *   </li>
     * </ol></p>
     *
     * @param librarianId ID Thủ thư đang thực hiện thao tác (để ghi Audit Log sau)
     * @param barcode     Mã vạch của bản sao sách cần nhận trả
     * @param condition   Tình trạng vật lý khi trả ('good', 'damaged', 'lost')
     * @throws IllegalStateException nếu barcode không hợp lệ, sách không ở trạng thái
     *                               'borrowed', condition không hợp lệ, hoặc không tìm
     *                               thấy BorrowRecord active
     * @throws SQLException          nếu có lỗi hạ tầng DB
     */
    // EARS[Event-driven]: WHEN Librarian submits Check-in form (barcode + condition),
    // THE LMS System SHALL evaluate condition THEN execute atomic transaction
    // covering BorrowRecord + BookCopy + Book + (Fine + UserLockReason + User)
    // [FR-F6-04, FR-F6-05, FR-F6-06]
    public void processCheckIn(int librarianId, String barcode, String condition)
            throws IllegalStateException, SQLException {

        // Xác thực condition trước khi mở connection — fail fast, không tốn tài nguyên DB
        if (!"good".equals(condition) && !"damaged".equals(condition) && !"lost".equals(condition)) {
            throw new IllegalStateException(
                    "Tình trạng sách không hợp lệ: '" + condition + "'. "
                    + "Chỉ chấp nhận: 'good', 'damaged', 'lost'.");
        }

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // BẮT ĐẦU TRANSACTION

            // ----------------------------------------------------------------
            // [Node 4.15] BƯỚC 1: Xác thực barcode và trạng thái BookCopy
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN Librarian scans barcode for check-in,
            // THE LMS System SHALL validate BookCopy existence and status [Node 4.15]
            BookCopy bookCopy = bookCopyDAO.findByBarcode(conn, barcode);
            if (bookCopy == null) {
                throw new IllegalStateException(
                        "Mã vạch '" + barcode + "' không hợp lệ hoặc không tồn tại trong hệ thống.");
            }
            if (!"borrowed".equals(bookCopy.getStatus())) {
                throw new IllegalStateException(
                        "Bản sao sách (barcode: " + barcode + ") không ở trạng thái 'borrowed'. "
                        + "Trạng thái hiện tại: '" + bookCopy.getStatus() + "'.");
            }

            int bookCopyId = bookCopy.getBookCopyId();

            // ----------------------------------------------------------------
            // BƯỚC 2: Lấy BorrowRecord active để có userId và bookId
            // Một truy vấn duy nhất — tránh multiple round-trips tới DB.
            // ----------------------------------------------------------------
            BorrowRecord activeBorrowRecord = borrowRecordDAO.findActiveBorrowRecord(conn, bookCopyId);
            if (activeBorrowRecord == null) {
                throw new IllegalStateException(
                        "Không tìm thấy bản ghi mượn đang active cho barcode: " + barcode
                        + ". Dữ liệu có thể không nhất quán — vui lòng liên hệ quản trị viên.");
            }

            int borrowRecordId = activeBorrowRecord.getBorrowRecordId();
            int userId         = activeBorrowRecord.getUserId();
            int bookId         = activeBorrowRecord.getBookId();

            // ----------------------------------------------------------------
            // [Node 5.16] BƯỚC 3: Rẽ nhánh theo condition
            // ----------------------------------------------------------------
            if ("damaged".equals(condition) || "lost".equals(condition)) {
                processCheckInDamagedOrLost(conn, borrowRecordId, bookCopyId, bookId,
                                            userId, condition);
            } else {
                // condition == "good"
                processCheckInGood(conn, borrowRecordId, bookCopyId, bookId);
            }

            // ----------------------------------------------------------------
            // COMMIT: Toàn bộ thao tác ghi trong nhánh đã thành công
            // ----------------------------------------------------------------
            conn.commit();
            LOGGER.log(Level.INFO,
                    "Check-in thành công: barcode={0}, condition={1}, borrowRecordId={2}",
                    new Object[]{barcode, condition, borrowRecordId});

        } catch (IllegalStateException e) {
            rollbackQuietly(conn, "processCheckIn[BusinessRule]", 0);
            throw e;

        } catch (SQLException e) {
            rollbackQuietly(conn, "processCheckIn[SQL]", 0);
            LOGGER.log(Level.SEVERE,
                    "Lỗi SQL trong processCheckIn: barcode=" + barcode
                    + ", condition=" + condition, e);
            throw e;

        } finally {
            closeConnectionQuietly(conn, "processCheckIn");
        }
    }

    /**
     * Xử lý nhánh Check-in sách hỏng / mất — thực thi BR-24 (6 bước ghi).
     *
     * <p>Tất cả 6 bước được thực thi trong cùng Transaction mở bởi
     * {@link #processCheckIn(int, String, String)}. Hàm này không commit.</p>
     *
     * <p><strong>Công thức tính phạt đền bù:</strong>
     * {@code amount = Book.price × 1.5} nếu price != null;
     * nếu price null (chưa nhập) thì dùng giá trị mặc định 500,000 VND.
     * Team có thể điều chỉnh hệ số tại đây sau khi thống nhất nghiệp vụ.</p>
     *
     * @param conn           Connection trong Transaction
     * @param borrowRecordId ID bản ghi mượn đang active
     * @param bookCopyId     ID bản sao sách bị hỏng/mất
     * @param bookId         ID đầu sách để trừ totalQuantity
     * @param userId         ID người dùng bị phạt và bị khóa
     * @param condition      'damaged' hoặc 'lost'
     * @throws SQLException nếu bất kỳ bước nào thất bại (Service sẽ rollback)
     */
    // EARS[Condition-driven]: WHERE condition IN ('damaged', 'lost'),
    // THE LMS System SHALL execute 6-step atomic write: BorrowRecord + BookCopy +
    // Book.totalQuantity + Fine + UserLockReason + User.status [Node 6.17, FR-F6-04, BR-24]
    private void processCheckInDamagedOrLost(Connection conn, int borrowRecordId,
                                             int bookCopyId, int bookId,
                                             int userId, String condition) throws SQLException {
        // Bước 1: UPDATE BorrowRecord → trạng thái tương ứng condition
        borrowRecordDAO.updateStatusToDamagedOrLost(conn, borrowRecordId, condition);

        // Bước 2: UPDATE BookCopy → 'unavailable' và ghi nhận condition vật lý
        bookCopyDAO.updateStatusToUnavailable(conn, bookCopyId, condition);

        // Bước 3: UPDATE Book.totalQuantity - 1 (BR-24 — loại khỏi tổng tài sản)
        bookDAO.decrementTotalQuantity(conn, bookId);

        // Bước 4: Tính tiền phạt đền bù và INSERT Fine
        // EARS[Event-driven]: WHEN copy is damaged/lost,
        // THE LMS System SHALL INSERT Fine (status='unpaid') [Node 6.17, BR-24]
        BigDecimal fineAmount = calculateCompensationAmount(conn, bookId, condition);
        String fineReason = "damaged".equals(condition)
                ? "Sách bị hỏng — đền bù theo giá trị sách"
                : "Sách bị mất — đền bù theo giá trị sách";
        fineDAO.insertCompensationFine(conn, borrowRecordId, userId, fineAmount, fineReason);

        // Bước 5: INSERT UserLockReason (reason='unpaid') — đánh dấu nợ phạt
        // EARS[Event-driven]: WHEN Fine is inserted,
        // THE LMS System SHALL INSERT UserLockReason (reason='unpaid') [Node 6.17, BR-24]
        userLockReasonDAO.insertUnpaidReason(conn, userId);

        // Bước 6: UPDATE [User].status = 'locked' — chặn mượn sách mới
        // EARS[Event-driven]: WHEN UserLockReason is inserted,
        // THE LMS System SHALL UPDATE [User].status = 'locked' [Node 6.17, BR-24]
        userDAO.updateStatusToLocked(conn, userId);

        LOGGER.log(Level.WARNING,
                "Check-in [BR-24]: Sách {0} — userId={1} bị khóa, bookId={2} trừ totalQuantity",
                new Object[]{condition, userId, bookId});
    }

    /**
     * Xử lý nhánh Check-in sách tốt — cập nhật kho và đẩy hàng chờ nếu có.
     *
     * <p>Tất cả các bước được thực thi trong cùng Transaction mở bởi
     * {@link #processCheckIn(int, String, String)}. Hàm này không commit.</p>
     *
     * @param conn           Connection trong Transaction
     * @param borrowRecordId ID bản ghi mượn đang active
     * @param bookCopyId     ID bản sao sách vừa được trả
     * @param bookId         ID đầu sách để kiểm tra hàng chờ và cập nhật availableQuantity
     * @throws SQLException nếu bất kỳ bước nào thất bại (Service sẽ rollback)
     */
    // EARS[Condition-driven]: WHERE condition = 'good',
    // THE LMS System SHALL update BorrowRecord + BookCopy, THEN route to queue check
    // [Node 6.18 → 7.19 → 8.20, FR-F6-05, FR-F6-06]
    private void processCheckInGood(Connection conn, int borrowRecordId,
                                    int bookCopyId, int bookId) throws SQLException {
        // Bước 1: UPDATE BorrowRecord → 'returned'
        // EARS[Event-driven]: WHEN condition='good',
        // THE LMS System SHALL UPDATE BorrowRecord status='returned', returnedAt=NOW [Node 6.18]
        borrowRecordDAO.updateStatusToReturned(conn, borrowRecordId);

        // Bước 2: UPDATE BookCopy.condition = 'good' (ghi nhận tình trạng vật lý OK)
        // Trạng thái (status) sẽ được cập nhật ở bước 4a hoặc 4b tùy theo hàng chờ
        bookCopyDAO.updateStatusToAvailable(conn, bookCopyId); // tạm set 'available', sẽ override nếu có queue

        // Bước 3: Kiểm tra hàng chờ — tìm người kế tiếp (queuePosition=1, status='pending')
        // EARS[State-driven]: WHILE BorrowRecord updated, THE LMS System SHALL
        // find next-in-queue Reservation WHERE bookId=?, queuePosition=1 [Node 7.19, FR-F6-06]
        Reservation nextInQueue = reservationDAO.findNextInQueue(conn, bookId);

        if (nextInQueue != null) {
            // ----------------------------------------------------------------
            // [Node 9.21] Có người chờ — đẩy Reservation lên readypickup
            // ----------------------------------------------------------------
            // EARS[Condition-driven]: WHERE next-in-queue exists,
            // THE LMS System SHALL UPDATE Reservation(queuePosition=0, readypickup, bookCopyId)
            // AND UPDATE BookCopy.status = 'reserved' [Node 9.21, FR-F6-06]
            reservationDAO.updateToReadyPickup(conn, nextInQueue.getReservationId(), bookCopyId);
            bookCopyDAO.updateStatusToReserved(conn, bookCopyId);

            // Email bất đồng bộ — NGOÀI Transaction (sẽ gọi sau commit ở processCheckIn)
            // Lưu thông tin để trigger sau commit
            final int waitingUserId = nextInQueue.getUserId();
            final int waitingBookId = bookId;
            triggerQueueNotificationEmailAsync(waitingUserId, waitingBookId);

            LOGGER.log(Level.INFO,
                    "Check-in [Good+Queue]: bookCopyId={0} gán cho userId={1} (readypickup)",
                    new Object[]{bookCopyId, nextInQueue.getUserId()});
        } else {
            // ----------------------------------------------------------------
            // [Node 9.22] Hàng chờ trống — trả sách về kho chung
            // BookCopy đã được set 'available' ở Bước 2
            // Chỉ cần cập nhật thêm Book.availableQuantity + 1
            // ----------------------------------------------------------------
            // EARS[Condition-driven]: WHERE queue is empty,
            // THE LMS System SHALL UPDATE Book.availableQuantity + 1 [Node 9.22, FR-F6-06]
            bookDAO.incrementAvailableQuantity(conn, bookId);

            LOGGER.log(Level.INFO,
                    "Check-in [Good+NoQueue]: bookCopyId={0} trả về kho (available), bookId={1} +1",
                    new Object[]{bookCopyId, bookId});
        }
    }

    // =========================================================================
    // LUỒNG C: THANH TOÁN TIỀN MẶT (CASH PAYMENT)
    // =========================================================================

    /**
     * Duyệt thanh toán tiền phạt bằng tiền mặt — thực thi BR-25 (Auto-unlock an toàn).
     *
     * <p>Luồng này được kích hoạt khi Thủ thư xác nhận đã nhận đủ tiền mặt từ
     * người dùng và nhấn nút "Duyệt Thanh Toán" trên giao diện (FR-F6-07, FR-F6-08).</p>
     *
     * <p><strong>5 bước trong Atomic Transaction (Node 5.25 → 7.28):</strong>
     * <ol>
     *   <li><strong>Xác thực Payment:</strong> Tra cứu {@code fineId} từ {@code paymentId}.
     *       Nếu không tìm thấy → ném {@code IllegalStateException}.</li>
     *   <li><strong>UPDATE Payment.status = 'completed'</strong> — Node 5.25a</li>
     *   <li><strong>UPDATE Fine.status = 'paid'</strong> — Node 5.25b</li>
     *   <li><strong>DELETE UserLockReason WHERE userId=? AND reason='unpaid'</strong>
     *       — Node 6.27 (xóa đúng lý do, không xóa lý do khác)</li>
     *   <li><strong>Auto-unlock gate — BR-25 (Node 7.28):</strong>
     *       COUNT tổng số lý do khóa còn lại của userId.
     *       <ul>
     *         <li>{@code COUNT == 0} → UPDATE {@code [User].status = 'active'}
     *             (mọi lý do đã được giải quyết)</li>
     *         <li>{@code COUNT > 0} → KHÔNG mở khóa (còn 'adminban' hoặc 'securitybreach')</li>
     *       </ul>
     *   </li>
     * </ol></p>
     *
     * <p><strong>Tại sao COUNT đủ an toàn cho BR-25?</strong><br>
     * {@code countLockReasonsByUserId} đếm <em>toàn bộ</em> bản ghi trong
     * {@code UserLockReason} (không lọc theo reason). Sau khi xóa 'unpaid',
     * nếu còn 'adminban' hoặc 'securitybreach', COUNT > 0 → tài khoản tiếp tục bị khóa.
     * Không cần logic đặc biệt kiểm tra từng loại reason — COUNT đã đủ điều kiện an toàn.</p>
     *
     * @param librarianId ID Thủ thư đang duyệt thanh toán (ghi Audit Log)
     * @param paymentId   ID phiếu thanh toán cần duyệt
     * @param userId      ID người dùng đang thanh toán (để DELETE UserLockReason)
     * @throws IllegalStateException nếu {@code paymentId} không tồn tại trong hệ thống
     * @throws SQLException          nếu có lỗi hạ tầng DB trong bất kỳ bước nào
     */
    // EARS[Event-driven]: WHEN Librarian approves cash payment (paymentId + userId),
    // THE LMS System SHALL execute atomic: UPDATE Payment + UPDATE Fine +
    // DELETE UserLockReason + [COND] UPDATE User.status='active' [FR-F6-07, FR-F6-08, BR-25]
    public void approveCashPayment(int librarianId, int paymentId, int userId)
            throws IllegalStateException, SQLException {

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // BẮT ĐẦU TRANSACTION

            // ----------------------------------------------------------------
            // [Node 5.25 - Bước 1] Xác thực Payment — lấy fineId liên kết
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN approval starts,
            // THE LMS System SHALL validate paymentId existence and retrieve fineId [FR-F6-07]
            int fineId = paymentDAO.findFineIdByPaymentId(conn, paymentId);
            if (fineId == -1) {
                throw new IllegalStateException(
                        "Phiếu thanh toán #" + paymentId + " không tồn tại trong hệ thống.");
            }

            // ----------------------------------------------------------------
            // [Node 5.25a - Bước 2] UPDATE Payment.status = 'completed'
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN fineId is retrieved,
            // THE LMS System SHALL UPDATE Payment.status = 'completed' [Node 5.25a, FR-F6-07]
            paymentDAO.updateStatusToCompleted(conn, paymentId);

            // ----------------------------------------------------------------
            // [Node 5.25b - Bước 3] UPDATE Fine.status = 'paid'
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN Payment is completed,
            // THE LMS System SHALL UPDATE Fine.status = 'paid' [Node 5.25b, FR-F6-07]
            fineDAO.updateStatusToPaid(conn, fineId);

            // ----------------------------------------------------------------
            // [Node 6.27 - Bước 4] DELETE UserLockReason WHERE reason='unpaid'
            // Xóa ĐÚNG lý do 'unpaid', KHÔNG ảnh hưởng các lý do khác
            // ('adminban', 'securitybreach') — BR-25
            // ----------------------------------------------------------------
            // EARS[Event-driven]: WHEN Fine is paid,
            // THE LMS System SHALL DELETE UserLockReason WHERE userId=? AND reason='unpaid'
            // [Node 6.27, FR-F6-08, BR-25]
            userLockReasonDAO.deleteUnpaidReasonByUserId(conn, userId);

            // ----------------------------------------------------------------
            // [Node 7.28 - Bước 5] Auto-unlock gate — BR-25
            // COUNT tổng số lý do khóa còn lại (bao gồm MỌI reason)
            // CHỈ mở khóa khi COUNT == 0 (không còn bất kỳ lý do nào)
            // ----------------------------------------------------------------
            // EARS[Condition-driven]: WHERE UserLockReason deleted,
            // THE LMS System SHALL COUNT remaining lock reasons.
            // IF COUNT == 0 THEN UPDATE [User].status='active' [Node 7.28, FR-F6-08, BR-25]
            // ELSE keep 'locked' (other reasons still exist)
            int remainingReasons = userLockReasonDAO.countLockReasonsByUserId(conn, userId);

            if (remainingReasons == 0) {
                // Mọi lý do khóa đã được giải quyết — mở khóa tài khoản
                userDAO.updateStatusToActive(conn, userId);
                LOGGER.log(Level.INFO,
                        "Cash Payment [BR-25 Auto-unlock]: userId={0} đã thanh toán xong, "
                        + "tài khoản được kích hoạt trở lại (paymentId={1})",
                        new Object[]{userId, paymentId});
            } else {
                // Còn lý do khóa khác — giữ nguyên trạng thái 'locked'
                LOGGER.log(Level.INFO,
                        "Cash Payment [BR-25 Keep-locked]: userId={0} thanh toán xong nhưng "
                        + "còn {1} lý do khóa khác — tài khoản vẫn bị khóa (paymentId={2})",
                        new Object[]{userId, remainingReasons, paymentId});
            }

            // ----------------------------------------------------------------
            // COMMIT: Toàn bộ 5 bước thành công
            // ----------------------------------------------------------------
            conn.commit();
            LOGGER.log(Level.INFO,
                    "Duyệt thanh toán thành công: paymentId={0}, fineId={1}, userId={2}, "
                    + "librarianId={3}",
                    new Object[]{paymentId, fineId, userId, librarianId});

        } catch (IllegalStateException e) {
            rollbackQuietly(conn, "approveCashPayment[BusinessRule]", userId);
            throw e;

        } catch (SQLException e) {
            rollbackQuietly(conn, "approveCashPayment[SQL]", userId);
            LOGGER.log(Level.SEVERE,
                    "Lỗi SQL trong approveCashPayment: paymentId=" + paymentId
                    + ", userId=" + userId, e);
            throw e;

        } finally {
            closeConnectionQuietly(conn, "approveCashPayment", userId);
        }
    }

    // =========================================================================
    // PRIVATE HELPER METHODS
    // =========================================================================


    /**
     * Tính thời điểm hết hạn mượn sách dựa trên số ngày mượn.
     *
     * <p>Dùng {@code java.util.Calendar} thay vì cộng millisecond trực tiếp
     * để tránh lỗi DST (Daylight Saving Time) trong timezone.</p>
     *
     * @param borrowDays Số ngày mượn (thường = 14 từ cấu hình hệ thống)
     * @return {@code Timestamp} của thời điểm hết hạn (startDate + borrowDays)
     */
    private Timestamp calculateEndDate(int borrowDays) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, borrowDays);
        return new Timestamp(cal.getTimeInMillis());
    }

    /**
     * Trigger email thông báo mượn sách thành công — chạy bất đồng bộ.
     *
     * <p>Gọi NGOÀI Transaction sau khi {@code conn.commit()} thành công.
     * Email gửi thất bại KHÔNG rollback nghiệp vụ (ENG-03 — Async I/O).
     * Chi tiết email template sẽ được bổ sung khi tích hợp EmailService
     * đầy đủ ở sprint tiếp theo.</p>
     *
     * @param userId  ID người dùng nhận email
     * @param bookId  ID sách vừa mượn (để lấy tiêu đề sách)
     * @param endDate Hạn trả sách kèm trong nội dung email
     */
    private void triggerCheckOutEmailAsync(int userId, int bookId, Timestamp endDate) {
        // TODO Sprint 3: Tích hợp EmailService.sendAsyncCheckOutConfirmation(userId, bookId, endDate)
        // Email template: "Bạn đã mượn sách thành công. Hạn trả: {endDate}."
        // Chạy trong EmailService.EXECUTOR (thread pool) theo pattern đã có.
        LOGGER.log(Level.INFO,
                "[ASYNC] Sẽ gửi email xác nhận mượn sách cho userId={0}, bookId={1}",
                new Object[]{userId, bookId});
    }

    /**
     * Trigger email thông báo sách sẵn sàng cho người đang chờ trong hàng — bất đồng bộ.
     *
     * <p>Gọi ngay sau {@code conn.commit()} thành công trong luồng Check-in sách tốt
     * khi tìm thấy người chờ tiếp theo (Node 9.21). Email gửi thất bại KHÔNG
     * rollback nghiệp vụ đã commit (ENG-03).
     * Chi tiết template sẽ thiết kế khi tích hợp EmailService đầy đủ ở sprint sau.</p>
     *
     * @param waitingUserId ID người dùng đang chờ (nhận email thông báo)
     * @param bookId        ID sách vừa sẵn sàng
     */
    private void triggerQueueNotificationEmailAsync(int waitingUserId, int bookId) {
        // TODO Sprint 3: Tích hợp EmailService.sendAsyncPickupReadyNotification(waitingUserId, bookId)
        // Email template: "Sách bạn đặt trước đã sẵn sàng. Vui lòng đến nhận trong vòng 3 ngày."
        // Chạy trong EmailService.EXECUTOR (thread pool) theo pattern đã có (PLAN.md §4).
        LOGGER.log(Level.INFO,
                "[ASYNC] Sẽ gửi email thông báo sách sẵn sàng cho userId={0}, bookId={1}",
                new Object[]{waitingUserId, bookId});
    }

    /**
     * Tính số tiền phạt đền bù cho trường hợp sách hỏng hoặc mất.
     *
     * <p>Công thức hiện tại:
     * <ul>
     *   <li>{@code 'damaged'}: {@code Book.price × 1.5} (150% giá gốc)</li>
     *   <li>{@code 'lost'}:    {@code Book.price × 2.0} (200% giá gốc)</li>
     *   <li>Nếu {@code price} chưa nhập (null): dùng mặc định 500,000 VND
     *       — team có thể điều chỉnh giá trị mặc định này sau khi thống nhất nghiệp vụ.</li>
     * </ul></p>
     *
     * <p>Được gọi trong cùng Transaction — bookId đã xác định rõ ràng từ BorrowRecord.</p>
     *
     * @param conn      Connection trong Transaction
     * @param bookId    ID đầu sách cần tra cứu giá
     * @param condition 'damaged' hoặc 'lost'
     * @return Số tiền phạt tính được (không null, không âm)
     * @throws SQLException nếu không thể tra cứu thông tin sách
     */
    private BigDecimal calculateCompensationAmount(Connection conn, int bookId, String condition)
            throws SQLException {
        // Mức phạt mặc định khi chưa nhập giá sách: 500,000 VND
        final BigDecimal DEFAULT_FINE = BigDecimal.valueOf(500_000);
        final double DAMAGED_MULTIPLIER = 1.5;
        final double LOST_MULTIPLIER    = 2.0;

        Book book = bookDAO.findById(conn, bookId);
        if (book == null || book.getPrice() == null) {
            LOGGER.log(Level.WARNING,
                    "[FINE CALC] Không tìm thấy giá sách cho bookId={0} — dùng mầc định {1}",
                    new Object[]{bookId, DEFAULT_FINE});
            return DEFAULT_FINE;
        }

        double multiplier = "lost".equals(condition) ? LOST_MULTIPLIER : DAMAGED_MULTIPLIER;
        return book.getPrice().multiply(BigDecimal.valueOf(multiplier));
    }

    /**
     * Thực hiện rollback an toàn mà không ném thêm ngoại lệ.
     *
     * <p>Pattern "rollback quietly" đảm bảo lỗi rollback (nếu có) không
     * che khuất exception gốc đang được xử lý trong catch block.</p>
     *
     * @param conn    Connection cần rollback (có thể null nếu chưa mở được)
     * @param context Tên context để log (ví dụ: "processCheckOut[SQL]")
     * @param userId  ID người dùng để hỗ trợ trace log
     */
    private void rollbackQuietly(Connection conn, String context, int userId) {
        if (conn != null) {
            try {
                conn.rollback();
                LOGGER.log(Level.WARNING,
                        "[ROLLBACK] {0}: Đã rollback transaction cho userId={1}",
                        new Object[]{context, userId});
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE,
                        "[ROLLBACK FAILED] " + context + ": Không thể rollback transaction"
                        + " cho userId=" + userId, rollbackEx);
            }
        }
    }

    /**
     * Đóng Connection an toàn mà không ném thêm ngoại lệ.
     *
     * <p>Được gọi trong {@code finally} block để đảm bảo Connection luôn
     * được trả lại (ENG-01 — tránh connection leak), bất kể luồng thành công
     * hay thất bại.</p>
     *
     * @param conn    Connection cần đóng (có thể null)
     * @param context Tên context để log
     * @param userId  ID người dùng để hỗ trợ trace log
     */
    private void closeConnectionQuietly(Connection conn, String context, int userId) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException closeEx) {
                LOGGER.log(Level.SEVERE,
                        "[CLOSE FAILED] " + context + ": Không thể đóng Connection"
                        + " cho userId=" + userId, closeEx);
            }
        }
    }

    /**
     * Đóng Connection an toàn khi không có userId (dùng trong processCheckIn).
     *
     * @param conn    Connection cần đóng (có thể null)
     * @param context Tên context để log
     */
    private void closeConnectionQuietly(Connection conn, String context) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException closeEx) {
                LOGGER.log(Level.SEVERE,
                        "[CLOSE FAILED] " + context + ": Không thể đóng Connection", closeEx);
            }
        }
    }
}
