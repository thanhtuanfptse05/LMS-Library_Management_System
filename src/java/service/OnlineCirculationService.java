package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.DocumentTempDAO;
import dao.FineDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BookCopy;
import model.BorrowRecord;
import model.DocumentTemp;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;

/**
 * OnlineCirculationService — Xử lý nghiệp vụ đặt trước & gia hạn trực tuyến (F5).
 */
public class OnlineCirculationService {

    private static final Logger LOGGER = Logger.getLogger(OnlineCirculationService.class.getName());

    private final BookDAO bookDAO;
    private final BookCopyDAO bookCopyDAO;
    private final ReservationDAO reservationDAO;
    private final BorrowRecordDAO borrowRecordDAO;
    private final SystemConfigDAO systemConfigDAO;
    private final AuditLogDAO auditLogDAO;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;
    private final DocumentTempDAO documentTempDAO;
    private final FineDAO fineDAO;

    public OnlineCirculationService() {
        this(new BookDAO(), new BookCopyDAO(), new ReservationDAO(), new BorrowRecordDAO(),
             new SystemConfigDAO(), new AuditLogDAO(), new UserDAO(),
             new MemberProfileDAO(), new DocumentTempDAO(), new FineDAO());
    }

    public OnlineCirculationService(BookDAO bookDAO, BookCopyDAO bookCopyDAO, ReservationDAO reservationDAO,
                                   BorrowRecordDAO borrowRecordDAO, SystemConfigDAO systemConfigDAO,
                                   AuditLogDAO auditLogDAO, UserDAO userDAO,
                                   MemberProfileDAO memberProfileDAO, DocumentTempDAO documentTempDAO, FineDAO fineDAO) {
        this.bookDAO = bookDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.reservationDAO = reservationDAO;
        this.borrowRecordDAO = borrowRecordDAO;
        this.systemConfigDAO = systemConfigDAO;
        this.auditLogDAO = auditLogDAO;
        this.userDAO = userDAO;
        this.memberProfileDAO = memberProfileDAO;
        this.documentTempDAO = documentTempDAO;
        this.fineDAO = fineDAO;
    }


    /**
     * Đặt trước sách trực tuyến (UC09)
     */
    public int reserveBook(int userId, int bookId, String role) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra tài khoản
                User user = userDAO.findByUserId(userId);
                if (user == null) {
                    throw new ValidationException("Tài khoản người dùng không tồn tại.");
                }
                if (!"active".equals(user.getStatus())) {
                    throw new ValidationException("Tài khoản của bạn hiện đang bị khóa hoặc ngưng hoạt động.");
                }

                // 1.1. Kiểm tra nợ phạt
                if (fineDAO.hasUnpaidFines(conn, userId)) {
                    throw new ValidationException("Tài khoản đang nợ phạt, không thể đặt trước sách cho đến khi thanh toán xong.");
                }

                // 2. Check BR-35: Đang mượn sách này không?
                if (borrowRecordDAO.hasActiveBorrowRecord(conn, userId, bookId)) {
                    throw new ValidationException("Bạn đang mượn cuốn sách này, không thể đặt trước.");
                }

                // 3. Kiểm tra xem đã đặt trước cuốn này chưa
                if (reservationDAO.hasActiveReservation(conn, userId, bookId)) {
                    throw new ValidationException("Bạn đã đặt trước cuốn sách này rồi.");
                }

                // 4. Check Limit (BR-05)
                String configKey = "student".equalsIgnoreCase(role) ? "STUDENT_MAX_BORROW_LIMIT" : "LECTURER_MAX_BORROW_LIMIT";
                int defaultLimit = "student".equalsIgnoreCase(role) ? 5 : 10;
                int maxLimit = systemConfigDAO.getIntValue(conn, configKey, defaultLimit);

                int borrows = borrowRecordDAO.countActiveBorrowsByUser(conn, userId);
                int reservations = reservationDAO.countActiveReservationsByUser(conn, userId);

                if (borrows + reservations >= maxLimit) {
                    throw new ValidationException("Bạn đã đạt giới hạn tối đa mượn và đặt trước sách (" + maxLimit + " cuốn).");
                }

                // 5. Lock sách bằng SELECT FOR UPDATE
                Book book = bookDAO.findByIdForUpdate(conn, bookId);
                if (book == null) {
                    throw new ValidationException("Đầu sách không tồn tại.");
                }
                if (!"available".equals(book.getStatus())) {
                    throw new ValidationException("Sách này hiện không khả dụng để đặt trước.");
                }
                if (!bookCopyDAO.hasActiveAvailableCopy(conn, bookId) && book.getAvailableQuantity() > 0) {
                    throw new ValidationException("Không tìm thấy bản sao sách khả dụng thực tế để đặt trước.");
                }

                int reservationId;
                boolean isReady = false;
                Integer copyId = null;
                String nextUserEmail = null;
                String nextUserFullName = null;

                // 6. Xử lý tồn kho & vị trí hàng đợi
                if (book.getAvailableQuantity() > 0) {
                    // Chỉ giảm availableQuantity để "giữ chỗ", bookCopyId sẽ được gán bởi Thủ thư khi Check-out (F6)
                    bookDAO.updateQuantities(conn, bookId, 0, -1);
                    reservationId = reservationDAO.insertOnlineReservation(conn, userId, bookId, 0, null);
                    auditLogDAO.insert(conn, userId, "RESERVE_READY", "Reservation", reservationId, null,
                            "{\"bookId\":" + bookId + ",\"queuePosition\":0}");
                    isReady = true;

                    nextUserEmail = user.getEmail();
                    MemberProfile profile = memberProfileDAO.findByUserId(userId);
                    nextUserFullName = (profile != null) ? profile.getFullName() : user.getEmail();
                } else {
                    // Hết sách khả dụng -> đưa vào hàng chờ
                    reservationId = insertIntoPendingQueue(conn, userId, bookId);
                }

                conn.commit();

                // Gửi email thông báo nếu sách có sẵn
                if (isReady && nextUserEmail != null) {
                    int holdDays = systemConfigDAO.getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                    java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                    String deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);
                    sendReadyPickupEmail(nextUserEmail, nextUserFullName, book.getTitle(), deadlineStr);
                }

                return reservationId;

            } catch (ValidationException | SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    // ignore
                }
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể đặt trước sách do lỗi hệ thống.", e);
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    // ignore
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    /**
     * Hủy đơn đặt trước trực tuyến (UC10)
     */
    public void cancelReservation(int userId, int reservationId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra tài khoản
                User user = userDAO.findByUserId(userId);
                if (user == null) {
                    throw new ValidationException("Tài khoản người dùng không tồn tại.");
                }
                if (!"active".equals(user.getStatus())) {
                    throw new ValidationException("Tài khoản của bạn hiện đang bị khóa hoặc ngưng hoạt động.");
                }

                // 2. Kiểm tra đơn đặt trước
                Reservation res = reservationDAO.findReservationById(conn, reservationId);
                if (res == null) {
                    throw new ValidationException("Đơn đặt trước không tồn tại.");
                }
                if (res.getUserId() != userId) {
                    throw new ValidationException("Bạn không sở hữu đơn đặt trước này.");
                }
                if (!"pending".equals(res.getStatus()) && !"readypickup".equals(res.getStatus())) {
                    throw new ValidationException("Đơn đặt trước không còn ở trạng thái hoạt động để hủy.");
                }

                // 3. Thực hiện hủy
                reservationDAO.cancelReservation(conn, reservationId, userId);
                auditLogDAO.insert(conn, userId, "CANCEL_RESERVATION", "Reservation", reservationId,
                        "{\"status\":\"" + res.getStatus() + "\"}", "{\"status\":\"cancelled\"}");

                String nextUserEmail = null;
                String nextUserFullName = null;
                String bookTitle = null;
                String deadlineStr = null;

                // 4. Cascade logic nếu hủy một đơn đã có sẵn sách (queuePosition = 0)
                if (res.getQueuePosition() != null && res.getQueuePosition() == 0) {
                    Integer copyId = res.getBookCopyId();
                    
                    if (copyId != null) {
                        // Tìm người kế tiếp (queuePosition = 1)
                        Reservation nextRes = reservationDAO.findNextInQueue(conn, res.getBookId());
                        if (nextRes != null) {
                            // Đôn người kế tiếp lên nhận sách, lấy holdDays từ cấu hình động
                            int holdDays = systemConfigDAO.getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                            reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), copyId, holdDays);
                            // Dịch hàng đợi
                            reservationDAO.decrementQueuePositions(conn, res.getBookId());
                            
                            // Lấy thông tin gửi email thông báo
                            User nextUser = userDAO.findByUserId(nextRes.getUserId());
                            if (nextUser != null) {
                                nextUserEmail = nextUser.getEmail();
                                MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                                nextUserFullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();
                                Book b = bookDAO.findById(conn, res.getBookId());
                                bookTitle = (b != null) ? b.getTitle() : "Sách đã đặt";
                                
                                java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                                deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);
                            }
                        } else {
                            // Không có ai chờ -> trả bản sao về available, tăng availableQuantity của Book
                            bookCopyDAO.updateStatusToAvailable(conn, copyId);
                            bookDAO.updateQuantities(conn, res.getBookId(), 0, 1);
                        }
                    } else {
                        // Đơn đặt trước online chưa được lấy (bookCopyId == NULL)
                        // Tăng Book.availableQuantity + 1 (hoàn trả "chỗ đã giữ")
                        bookDAO.updateQuantities(conn, res.getBookId(), 0, 1);
                        
                        Reservation nextRes = reservationDAO.findNextInQueue(conn, res.getBookId());
                        if (nextRes != null) {
                            // Đôn người kế tiếp lên nhận sách (bookCopyId = null)
                            int holdDays = systemConfigDAO.getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                            reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), null, holdDays);
                            // Dịch hàng đợi
                            reservationDAO.decrementQueuePositions(conn, res.getBookId());
                            
                            User nextUser = userDAO.findByUserId(nextRes.getUserId());
                            if (nextUser != null) {
                                nextUserEmail = nextUser.getEmail();
                                MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                                nextUserFullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();
                                Book b = bookDAO.findById(conn, res.getBookId());
                                bookTitle = (b != null) ? b.getTitle() : "Sách đã đặt";
                                
                                java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                                deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);
                            }
                        }
                    }
                } else if (res.getQueuePosition() != null && res.getQueuePosition() > 0) {
                    // Nếu hủy một đơn đang nằm trong hàng chờ (queuePosition > 0)
                    // Dịch hàng đợi phía sau của cuốn sách đó
                    reservationDAO.shiftQueuePositions(conn, res.getBookId(), res.getQueuePosition());
                }

                conn.commit();

                // Gửi email thông báo cho người kế tiếp ngoài transaction
                if (nextUserEmail != null && bookTitle != null) {
                    sendReadyPickupEmail(nextUserEmail, nextUserFullName, bookTitle, deadlineStr);
                }

            } catch (ValidationException | SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    // ignore
                }
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể hủy đơn đặt trước do lỗi hệ thống.", e);
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    // ignore
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    /**
     * Hủy đơn đặt trước bởi Thủ thư
     */
    public void cancelReservationByLibrarian(int librarianId, int reservationId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra đơn đặt trước
                Reservation res = reservationDAO.findReservationById(conn, reservationId);
                if (res == null) {
                    throw new ValidationException("Đơn đặt trước không tồn tại.");
                }
                if (!"pending".equals(res.getStatus()) && !"readypickup".equals(res.getStatus())) {
                    throw new ValidationException("Đơn đặt trước không còn ở trạng thái hoạt động để hủy.");
                }

                // 2. Thực hiện hủy
                reservationDAO.cancelReservation(conn, reservationId, res.getUserId());
                auditLogDAO.insert(conn, librarianId, "CANCEL_RESERVATION_BY_LIBRARIAN", "Reservation", reservationId,
                        "{\"status\":\"" + res.getStatus() + "\",\"userId\":" + res.getUserId() + "}", "{\"status\":\"cancelled\"}");

                String nextUserEmail = null;
                String nextUserFullName = null;
                String bookTitle = null;
                String deadlineStr = null;

                // 3. Cascade logic nếu hủy một đơn đã có sẵn sách (queuePosition = 0)
                if (res.getQueuePosition() != null && res.getQueuePosition() == 0) {
                    Integer copyId = res.getBookCopyId();
                    
                    if (copyId != null) {
                        // Tìm người kế tiếp (queuePosition = 1)
                        Reservation nextRes = reservationDAO.findNextInQueue(conn, res.getBookId());
                        if (nextRes != null) {
                            // Đôn người kế tiếp lên nhận sách, lấy holdDays từ cấu hình động
                            int holdDays = systemConfigDAO.getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                            reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), copyId, holdDays);
                            // Dịch hàng đợi
                            reservationDAO.decrementQueuePositions(conn, res.getBookId());
                            
                            // Lấy thông tin gửi email thông báo
                            User nextUser = userDAO.findByUserId(nextRes.getUserId());
                            if (nextUser != null) {
                                nextUserEmail = nextUser.getEmail();
                                MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                                nextUserFullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();
                                Book b = bookDAO.findById(conn, res.getBookId());
                                bookTitle = (b != null) ? b.getTitle() : "Sách đã đặt";
                                
                                java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                                deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);
                            }
                        } else {
                            // Không có ai chờ -> trả bản sao về available, tăng availableQuantity của Book
                            bookCopyDAO.updateStatusToAvailable(conn, copyId);
                            bookDAO.updateQuantities(conn, res.getBookId(), 0, 1);
                        }
                    } else {
                        // Đơn đặt trước online chưa được lấy (bookCopyId == NULL)
                        // Tăng Book.availableQuantity + 1 (hoàn trả "chỗ đã giữ")
                        bookDAO.updateQuantities(conn, res.getBookId(), 0, 1);
                        
                        Reservation nextRes = reservationDAO.findNextInQueue(conn, res.getBookId());
                        if (nextRes != null) {
                            // Đôn người kế tiếp lên nhận sách (bookCopyId = null)
                            int holdDays = systemConfigDAO.getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
                            reservationDAO.updateToReadyPickup(conn, nextRes.getReservationId(), null, holdDays);
                            // Dịch hàng đợi
                            reservationDAO.decrementQueuePositions(conn, res.getBookId());
                            
                            User nextUser = userDAO.findByUserId(nextRes.getUserId());
                            if (nextUser != null) {
                                nextUserEmail = nextUser.getEmail();
                                MemberProfile profile = memberProfileDAO.findByUserId(nextRes.getUserId());
                                nextUserFullName = (profile != null) ? profile.getFullName() : nextUser.getEmail();
                                Book b = bookDAO.findById(conn, res.getBookId());
                                bookTitle = (b != null) ? b.getTitle() : "Sách đã đặt";
                                
                                java.sql.Timestamp deadline = new java.sql.Timestamp(System.currentTimeMillis() + holdDays * 24L * 60 * 60 * 1000);
                                deadlineStr = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline);
                            }
                        }
                    }
                } else if (res.getQueuePosition() != null && res.getQueuePosition() > 0) {
                    // Nếu hủy một đơn đang nằm trong hàng chờ (queuePosition > 0)
                    // Dịch hàng đợi phía sau của cuốn sách đó
                    reservationDAO.shiftQueuePositions(conn, res.getBookId(), res.getQueuePosition());
                }

                conn.commit();

                // Gửi email thông báo cho người kế tiếp ngoài transaction
                if (nextUserEmail != null && bookTitle != null) {
                    sendReadyPickupEmail(nextUserEmail, nextUserFullName, bookTitle, deadlineStr);
                }

            } catch (ValidationException | SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    // ignore
                }
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể hủy đơn đặt trước do lỗi hệ thống.", e);
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    // ignore
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    /**
     * Gia hạn sách trực tuyến (UC11)
     */
    public void renewBook(int userId, int borrowRecordId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra tài khoản
                User user = userDAO.findByUserId(userId);
                if (user == null) {
                    throw new ValidationException("Tài khoản người dùng không tồn tại.");
                }
                if (!"active".equals(user.getStatus())) {
                    throw new ValidationException("Tài khoản của bạn hiện đang bị khóa hoặc ngưng hoạt động.");
                }

                // 1.1. Kiểm tra nợ phạt
                if (fineDAO.hasUnpaidFines(conn, userId)) {
                    throw new ValidationException("Tài khoản đang nợ phạt, không thể gia hạn sách cho đến khi thanh toán xong.");
                }

                // 2. Kiểm tra bản ghi mượn
                BorrowRecord br = borrowRecordDAO.findBorrowRecordById(conn, borrowRecordId);
                if (br == null) {
                    throw new ValidationException("Bản ghi mượn sách không tồn tại.");
                }
                if (br.getUserId() != userId) {
                    throw new ValidationException("Bạn không sở hữu bản ghi mượn sách này.");
                }
                if (!"borrowed".equals(br.getStatus())) {
                    throw new ValidationException("Sách này không còn ở trạng thái đang mượn.");
                }

                // 2.1. Kiểm tra trạng thái Đầu sách cha (Book)
                Book parentBook = bookDAO.findById(conn, br.getBookId());
                if (parentBook == null || !"available".equals(parentBook.getStatus())) {
                    throw new ValidationException("Đầu sách này hiện đang bị ngưng lưu thông/phục vụ, không thể gia hạn.");
                }

                // 3. Kiểm tra ngưỡng thời gian (RENEW_THRESHOLD_PERCENT)
                int thresholdPercent = systemConfigDAO.getIntValue(conn, "RENEW_THRESHOLD_PERCENT", 50);
                long startDay = br.getStartDate().getTime() / (24L * 60 * 60 * 1000);
                long endDay = br.getEndDate().getTime() / (24L * 60 * 60 * 1000);
                long nowDay = System.currentTimeMillis() / (24L * 60 * 60 * 1000);

                long totalDays = endDay - startDay;
                long elapsedDays = nowDay - startDay;

                if (totalDays > 0) {
                    double percentPassed = (double) elapsedDays / totalDays * 100;
                    if (percentPassed < thresholdPercent) {
                        throw new ValidationException("Bạn chỉ được gia hạn khi đã sử dụng ít nhất " + thresholdPercent + "% thời hạn mượn sách.");
                    }
                }

                // 4. Kiểm tra số lần gia hạn (MAX_EXTENSION_COUNT)
                int maxExtensions = systemConfigDAO.getIntValue(conn, "MAX_EXTENSION_COUNT", 3);
                if (br.getExtensionCount() >= maxExtensions) {
                    throw new ValidationException("Bạn đã vượt quá số lần gia hạn cho phép cho cuốn sách này (" + maxExtensions + " lần).");
                }

                // 5. Kiểm tra hàng chờ (Không ai đặt trước cuốn này)
                if (reservationDAO.hasQueuedReservation(conn, br.getBookId())) {
                    throw new ValidationException("Sách này đang có độc giả khác xếp hàng chờ đặt trước, không thể gia hạn.");
                }

                // 6. Thực hiện gia hạn
                int renewDays = systemConfigDAO.getIntValue(conn, "RENEW_DURATION_DAYS", 14);
                borrowRecordDAO.incrementExtension(conn, borrowRecordId, renewDays);

                Timestamp oldEnd = br.getEndDate();
                Timestamp newEnd = new Timestamp(oldEnd.getTime() + renewDays * 24L * 60 * 60 * 1000);

                auditLogDAO.insert(conn, userId, "RENEW_BOOK", "BorrowRecord", borrowRecordId,
                        "{\"endDate\":\"" + oldEnd + "\",\"extensions\":" + br.getExtensionCount() + "}",
                        "{\"endDate\":\"" + newEnd + "\",\"extensions\":" + (br.getExtensionCount() + 1) + "}");

                conn.commit();

                // Gửi email xác nhận gia hạn thành công (Passive flow)
                try {
                    String email = user.getEmail();
                    MemberProfile profile = memberProfileDAO.findByUserId(userId);
                    String fullName = (profile != null) ? profile.getFullName() : user.getEmail();
                    Book book = bookDAO.findById(conn, br.getBookId());
                    String bookTitle = (book != null) ? book.getTitle() : "Sách đã gia hạn";
                    
                    java.util.Map<String, String> placeholders = new java.util.HashMap<>();
                    placeholders.put("bookTitle", bookTitle);
                    placeholders.put("newDueDate", new java.text.SimpleDateFormat("dd/MM/yyyy").format(newEnd));
                    placeholders.put("extensionCount", String.valueOf(br.getExtensionCount() + 1));
                    placeholders.put("maxExtension", String.valueOf(maxExtensions));
                    
                    model.EmailJob job = new model.EmailJob("RENEWAL_CONFIRMATION", email, fullName, placeholders);
                    EmailService.enqueue(job);
                } catch (Exception ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi kích hoạt gửi email xác nhận gia hạn.", ex);
                }

            } catch (ValidationException | SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    // ignore
                }
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể gia hạn sách do lỗi hệ thống.", e);
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    // ignore
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================

    private int insertIntoPendingQueue(Connection conn, int userId, int bookId) throws SQLException {
        // Dùng INSERT...SELECT atomic để tránh TOCTOU race condition khi 2 user đặt cùng lúc.
        // Không tách thành 2 bước (getMaxQueue rồi insert) vì khi sách hết và cả 2 transaction
        // đã qua lock Book, chúng có thể cùng đọc được MAX = N rồi cùng insert queuePosition = N+1.
        int resId = reservationDAO.insertIntoPendingQueueAtomic(conn, userId, bookId);

        // Đọc lại queuePosition thực tế đã được ghi để ghi AuditLog chính xác
        auditLogDAO.insert(conn, userId, "RESERVE_PENDING", "Reservation", resId, null,
                "{\"bookId\":" + bookId + ",\"atomicQueue\":true}");
        return resId;
    }

    private void sendReadyPickupEmail(String email, String fullName, String bookTitle, String pickupDeadline) {
        try {
            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("bookTitle", bookTitle);
            placeholders.put("pickupDeadline", pickupDeadline);
            
            model.EmailJob job = new model.EmailJob("RESERVATION_READY", email, fullName, placeholders);
            EmailService.enqueue(job);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kích hoạt gửi email thông báo sách sẵn sàng.", e);
        }
    }
}
