package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.MemberProfileDAO;
import dao.PaymentDAO;
import dao.ReservationDAO;
import dao.SystemConfigDAO;
import dao.UserDAO;
import dao.UserLockReasonDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BookCopy;
import model.BookCopyIncident;
import model.BorrowRecord;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;

public class BookCopyIncidentService {

    private static final Logger LOGGER = Logger.getLogger(BookCopyIncidentService.class.getName());

    private final BookCopyIncidentDAO incidentDAO;
    private final BookCopyDAO bookCopyDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;
    private final FineDAO fineDAO;
    private final PaymentDAO paymentDAO;
    private final UserLockReasonDAO userLockReasonDAO;
    private final BorrowRecordDAO borrowRecordDAO;
    private final SystemConfigDAO systemConfigDAO;

    /** Mức phạt mặc định cho sách chưa nhập giá: 500,000 VND */
    private static final BigDecimal DEFAULT_BOOK_PRICE = BigDecimal.valueOf(500_000);

    public BookCopyIncidentService() {
        this(new BookCopyIncidentDAO(), new BookCopyDAO(), new BookDAO(), new AuditLogDAO(),
                new ReservationDAO(), new UserDAO(), new MemberProfileDAO(),
                new FineDAO(), new PaymentDAO(), new UserLockReasonDAO(),
                new BorrowRecordDAO(), new SystemConfigDAO());
    }

    public BookCopyIncidentService(BookCopyIncidentDAO incidentDAO, BookCopyDAO bookCopyDAO,
            BookDAO bookDAO, AuditLogDAO auditLogDAO) {
        this(incidentDAO, bookCopyDAO, bookDAO, auditLogDAO,
                new ReservationDAO(), new UserDAO(), new MemberProfileDAO(),
                new FineDAO(), new PaymentDAO(), new UserLockReasonDAO(),
                new BorrowRecordDAO(), new SystemConfigDAO());
    }

    public BookCopyIncidentService(BookCopyIncidentDAO incidentDAO, BookCopyDAO bookCopyDAO,
            BookDAO bookDAO, AuditLogDAO auditLogDAO, ReservationDAO reservationDAO,
            UserDAO userDAO, MemberProfileDAO memberProfileDAO) {
        this(incidentDAO, bookCopyDAO, bookDAO, auditLogDAO, reservationDAO, userDAO,
                memberProfileDAO, new FineDAO(), new PaymentDAO(), new UserLockReasonDAO(),
                new BorrowRecordDAO(), new SystemConfigDAO());
    }

    public BookCopyIncidentService(BookCopyIncidentDAO incidentDAO, BookCopyDAO bookCopyDAO,
            BookDAO bookDAO, AuditLogDAO auditLogDAO, ReservationDAO reservationDAO,
            UserDAO userDAO, MemberProfileDAO memberProfileDAO,
            FineDAO fineDAO, PaymentDAO paymentDAO, UserLockReasonDAO userLockReasonDAO,
            BorrowRecordDAO borrowRecordDAO, SystemConfigDAO systemConfigDAO) {
        this.incidentDAO = incidentDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
        this.reservationDAO = reservationDAO;
        this.userDAO = userDAO;
        this.memberProfileDAO = memberProfileDAO;
        this.fineDAO = fineDAO;
        this.paymentDAO = paymentDAO;
        this.userLockReasonDAO = userLockReasonDAO;
        this.borrowRecordDAO = borrowRecordDAO;
        this.systemConfigDAO = systemConfigDAO;
    }

    public int report(String barcode, String incidentType, String description, int actorId)
            throws ValidationException, DatabaseException {
        validateReport(barcode, incidentType, description);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            Reservation demotedReservation = null;
            String bookTitle = null;
            try {
                BookCopy locatedCopy = bookCopyDAO.findByBarcode(conn, barcode);
                if (locatedCopy == null) {
                    throw new ValidationException("Không tìm thấy bản sao theo mã vạch.");
                }
                Book book = bookDAO.findByIdForUpdate(conn, locatedCopy.getBookId());
                if (book == null) {
                    throw new ValidationException("Đầu sách của bản sao không tồn tại.");
                }
                bookTitle = book.getTitle();

                BookCopy copy = bookCopyDAO.findByBarcodeForUpdate(conn, barcode);
                validateReportableCopy(copy);
                if (incidentDAO.findOpenByBookCopyId(conn, copy.getBookCopyId()) != null) {
                    throw new ValidationException("Bản sao đã có sự cố đang chờ xử lý.");
                }
                BookCopyIncident incident = new BookCopyIncident();
                incident.setBookCopyId(copy.getBookCopyId());
                incident.setIncidentType(incidentType);
                incident.setDescription(description);
                incident.setReportedBy(actorId);
                int incidentId = incidentDAO.insert(conn, incident);
                bookCopyDAO.markUnavailable(conn, copy.getBookCopyId());
                if (ReservationCapacityPolicy.onPhysicalCopyUnavailable(book.getAvailableQuantity())
                        == ReservationCapacityPolicy.CapacityLossAction.DECREMENT_AVAILABLE) {
                    bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);
                } else {
                    demotedReservation = reservationDAO.findLatestReadyPickupForUpdate(conn, copy.getBookId());
                    if (demotedReservation != null) {
                        reservationDAO.demoteReadyPickupToFront(conn,
                                demotedReservation.getReservationId(), copy.getBookId());
                        auditLogDAO.insert(conn, actorId, "DEMOTE_RESERVATION_CAPACITY_SHORTAGE",
                                "Reservation", demotedReservation.getReservationId(),
                                "{\"status\":\"readypickup\",\"queuePosition\":0}",
                                "{\"status\":\"pending\",\"queuePosition\":1,\"reason\":\"book_copy_incident\"}");
                    }
                }
                auditLogDAO.insert(conn, actorId, "CREATE_BOOK_COPY_INCIDENT", "BookCopyIncident",
                        incidentId, null, toAuditValue(incident, "pending"));
                auditLogDAO.insert(conn, actorId, "SUSPEND_BOOK_COPY", "BookCopy", copy.getBookCopyId(),
                        copyAuditValue(copy, "available"), copyAuditValue(copy, "unavailable"));
                conn.commit();
                if (demotedReservation != null) {
                    notifyReservationDelayed(demotedReservation, bookTitle);
                }
                return incidentId;
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể ghi nhận sự cố và đồng bộ tồn kho.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void startInvestigating(int incidentId, int actorId) throws ValidationException, DatabaseException {
        executeIncidentAction(incidentId, actorId, "investigate", null);
    }

    public void resolve(int incidentId, String resolution, int actorId)
            throws ValidationException, DatabaseException {
        validateResolution(resolution);
        executeIncidentAction(incidentId, actorId, "resolve", resolution);
    }

    public void reject(int incidentId, String resolution, int actorId)
            throws ValidationException, DatabaseException {
        validateResolution(resolution);
        executeIncidentAction(incidentId, actorId, "reject", resolution);
    }

    public void restoreAfterRepair(int incidentId, String repairNote, int actorId)
            throws ValidationException, DatabaseException {
        validateRepairNote(repairNote);
        if (incidentId <= 0) {
            throw new ValidationException("Sự cố không hợp lệ.");
        }
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCopyIncident incident = incidentDAO.findByIdForUpdate(conn, incidentId);
                if (incident == null) {
                    throw new ValidationException("Sự cố không tồn tại.");
                }
                if (!"resolved".equals(incident.getStatus()) || !"damaged".equals(incident.getIncidentType())) {
                    throw new ValidationException("Chỉ có thể khôi phục bản sao hỏng đã được xử lý.");
                }
                BookCopy copy = bookCopyDAO.findByIdForUpdate(conn, incident.getBookCopyId());
                if (copy == null) {
                    throw new ValidationException("Bản sao của sự cố không còn tồn tại.");
                }
                if (!"damaged".equals(copy.getCondition()) || !"unavailable".equals(copy.getStatus())) {
                    throw new ValidationException("Bản sao không ở trạng thái hỏng cần khôi phục.");
                }
                if (copy.isRemovedFromInventory()) {
                    throw new ValidationException("Bản sao đã bị loại khỏi kho nên không thể khôi phục lưu thông.");
                }
                Book parentBook = bookDAO.findByIdForUpdate(conn, copy.getBookId());
                if (parentBook != null && "unavailable".equals(parentBook.getStatus())) {
                    throw new ValidationException("Đầu sách của bản sao này hiện đang ngưng phục vụ (unavailable). Không thể khôi phục bản sao về trạng thái sẵn sàng.");
                }

                bookCopyDAO.restoreAfterRepair(conn, copy.getBookCopyId());
                Reservation promotedReservation = allocateRestoredCapacity(conn, copy.getBookId());
                String trimmedNote = repairNote.trim();
                incidentDAO.appendResolutionNote(conn, incidentId, "Khôi phục lưu thông: " + trimmedNote);
                auditLogDAO.insert(conn, actorId, "RESTORE_REPAIRED_BOOK_COPY", "BookCopy",
                        copy.getBookCopyId(), copyAuditValue(copy, "unavailable"),
                        "{\"barcode\":\"" + escape(copy.getBarcode())
                        + "\",\"condition\":\"good\",\"status\":\"available\",\"note\":\""
                        + escape(trimmedNote) + "\"}");
                auditLogDAO.insert(conn, actorId, "UPDATE_BOOK_COPY_INCIDENT_RESOLUTION",
                        "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                        "{\"restoreNote\":\"" + escape(trimmedNote) + "\"}");
                conn.commit();
                if (promotedReservation != null) {
                    notifyReservationReady(promotedReservation,
                            parentBook != null ? parentBook.getTitle() : copy.getBookTitle());
                }
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể khôi phục bản sao sau sửa chữa.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void removeDamagedCopyFromInventory(int incidentId, String removalNote, int actorId)
            throws ValidationException, DatabaseException {
        validateRemovalNote(removalNote);
        if (incidentId <= 0) {
            throw new ValidationException("Sự cố không hợp lệ.");
        }
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCopyIncident incident = incidentDAO.findByIdForUpdate(conn, incidentId);
                if (incident == null) {
                    throw new ValidationException("Sự cố không tồn tại.");
                }
                if (!"resolved".equals(incident.getStatus()) || !"damaged".equals(incident.getIncidentType())) {
                    throw new ValidationException("Chỉ có thể loại khỏi kho bản sao hỏng đã được xử lý.");
                }
                BookCopy copy = bookCopyDAO.findByIdForUpdate(conn, incident.getBookCopyId());
                if (copy == null) {
                    throw new ValidationException("Bản sao của sự cố không còn tồn tại.");
                }
                if (!"damaged".equals(copy.getCondition()) || !"unavailable".equals(copy.getStatus())) {
                    throw new ValidationException("Bản sao không ở trạng thái hỏng cần loại khỏi kho.");
                }
                if (copy.isRemovedFromInventory()) {
                    throw new ValidationException("Bản sao đã được loại khỏi kho trước đó.");
                }

                bookCopyDAO.markRemovedFromInventory(conn, copy.getBookCopyId(), actorId);
                bookDAO.updateQuantities(conn, copy.getBookId(), -1, 0);
                String trimmedNote = removalNote.trim();
                incidentDAO.appendResolutionNote(conn, incidentId, "Loại khỏi kho: " + trimmedNote);
                auditLogDAO.insert(conn, actorId, "REMOVE_DAMAGED_BOOK_COPY_FROM_INVENTORY",
                        "BookCopy", copy.getBookCopyId(),
                        copyAuditValue(copy, "unavailable"),
                        "{\"barcode\":\"" + escape(copy.getBarcode())
                        + "\",\"condition\":\"damaged\",\"status\":\"unavailable\","
                        + "\"removedFromInventory\":true,\"note\":\"" + escape(trimmedNote) + "\"}");
                auditLogDAO.insert(conn, actorId, "UPDATE_BOOK_COPY_INCIDENT_RESOLUTION",
                        "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                        "{\"removalNote\":\"" + escape(trimmedNote) + "\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể loại bản sao hỏng khỏi kho.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validateReport(String barcode, String incidentType, String description)
            throws ValidationException {
        if (barcode == null || barcode.isBlank()) {
            throw new ValidationException("Mã vạch không được để trống.");
        }
        if (barcode.length() > 50) {
            throw new ValidationException("Mã vạch không được vượt quá 50 ký tự.");
        }
        if (!"damaged".equals(incidentType) && !"lost".equals(incidentType)) {
            throw new ValidationException("Loại sự cố không hợp lệ.");
        }
        if (description == null || description.isBlank()) {
            throw new ValidationException("Mô tả hiện trạng không được để trống.");
        }
        if (description.length() > 1000) {
            throw new ValidationException("Mô tả hiện trạng không được vượt quá 1000 ký tự.");
        }
    }

    public void validateResolution(String resolution) throws ValidationException {
        if (resolution == null || resolution.isBlank()) {
            throw new ValidationException("Kết luận xử lý không được để trống.");
        }
        if (resolution.length() > 1000) {
            throw new ValidationException("Kết luận xử lý không được vượt quá 1000 ký tự.");
        }
    }

    public void validateRepairNote(String repairNote) throws ValidationException {
        if (repairNote == null || repairNote.isBlank()) {
            throw new ValidationException("Ghi chú sửa chữa không được để trống.");
        }
        if (repairNote.length() > 1000) {
            throw new ValidationException("Ghi chú sửa chữa không được vượt quá 1000 ký tự.");
        }
    }

    public void validateRemovalNote(String removalNote) throws ValidationException {
        if (removalNote == null || removalNote.isBlank()) {
            throw new ValidationException("Ghi chú loại khỏi kho không được để trống.");
        }
        if (removalNote.length() > 1000) {
            throw new ValidationException("Ghi chú loại khỏi kho không được vượt quá 1000 ký tự.");
        }
    }

    private void executeIncidentAction(int incidentId, int actorId, String action, String resolution)
            throws ValidationException, DatabaseException {
        if (incidentId <= 0) {
            throw new ValidationException("Sự cố không hợp lệ.");
        }

        // Thông tin phạt đền bù để gửi email bất đồng bộ sau commit (FR-007)
        BigDecimal compensationFineAmount = null;
        int compensationUserId = 0;
        int compensationBookId = 0;
        String compensationCondition = null;

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            Reservation promotedReservation = null;
            String promotedBookTitle = null;
            try {
                BookCopyIncident incident = incidentDAO.findByIdForUpdate(conn, incidentId);
                if (incident == null) {
                    throw new ValidationException("Sự cố không tồn tại.");
                }
                if (!"pending".equals(incident.getStatus()) && !"investigating".equals(incident.getStatus())) {
                    throw new ValidationException("Sự cố đã được kết luận.");
                }
                if ("investigate".equals(action)) {
                    if (!"pending".equals(incident.getStatus())) {
                        throw new ValidationException("Sự cố đã được chuyển sang xác minh.");
                    }
                    incidentDAO.startInvestigating(conn, incidentId);
                    auditLogDAO.insert(conn, actorId, "INVESTIGATE_BOOK_COPY_INCIDENT",
                            "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                            toAuditValue(incident, "investigating"));
                } else {
                    BookCopy copy = bookCopyDAO.findByIdForUpdate(conn, incident.getBookCopyId());
                    if (copy == null) {
                        throw new ValidationException("Bản sao của sự cố không còn tồn tại.");
                    }
                    if ("resolve".equals(action)) {
                        // F6 check-in incidents: condition đã được set đúng ('damaged'/'lost')
                        // bởi updateStatusToUnavailable() → chỉ cần set condition với thủ công incidents
                        if (incident.getBorrowRecordId() == null) {
                            // Sự cố thủ công: condition vẫn là 'good' → cần update
                            bookCopyDAO.resolveCondition(conn, copy.getBookCopyId(), incident.getIncidentType());
                        }
                        // Else: sự cố từ check-in F6 — condition đã là 'damaged'/'lost', không cần update
                        boolean removedAsLost = "lost".equals(incident.getIncidentType());
                        if (removedAsLost) {
                            bookCopyDAO.markRemovedFromInventory(conn, copy.getBookCopyId(), actorId);
                            bookDAO.updateQuantities(conn, copy.getBookId(), -1, 0);
                        }
                        incidentDAO.finish(conn, incidentId, "resolved", resolution, actorId);
                        auditLogDAO.insert(conn, actorId, "RESOLVE_BOOK_COPY_INCIDENT",
                                "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                                toAuditValue(incident, "resolved"));
                        auditLogDAO.insert(conn, actorId, "UPDATE_BOOK_COPY_CONDITION", "BookCopy",
                                copy.getBookCopyId(), copyAuditValue(copy, "unavailable"),
                                "{\"condition\":\"" + incident.getIncidentType()
                                + "\",\"status\":\"unavailable\",\"removedFromInventory\":"
                                + removedAsLost + "}");

                        // ============================================================
                        // T009: Tạo Fine đền bù + khóa tài khoản khi resolve incident
                        // có liên kết borrowRecordId (sự cố từ Check-in F6)
                        // ============================================================
                        if (incident.getBorrowRecordId() != null) {
                            BorrowRecord br = borrowRecordDAO.findById(conn, incident.getBorrowRecordId());
                            if (br != null) {
                                int userId = br.getUserId();
                                int bookId = br.getBookId();

                                // Tính tiền phạt đền bù
                                BigDecimal fineAmount = calculateCompensationAmount(conn, bookId,
                                        incident.getIncidentType());
                                String fineReason = "damaged".equals(incident.getIncidentType())
                                        ? "Sách bị hỏng — đền bù theo giá trị sách"
                                        : "Sách bị mất — đền bù theo giá trị sách";
                                int fineId = fineDAO.insertCompensationFine(conn, br.getBorrowRecordId(),
                                        userId, fineAmount, fineReason);

                                // Tạo Payment pending
                                paymentDAO.insertPayment(conn, fineId, fineAmount, "pending");

                                // Insert UserLockReason('unpaid') nếu chưa có
                                if (!userLockReasonDAO.hasReason(conn, userId, "unpaid")) {
                                    userLockReasonDAO.insertLockReason(conn, userId, "unpaid");
                                }

                                // Khóa tài khoản
                                userDAO.updateStatusToLocked(conn, userId);

                                // T013: Ghi Audit Log kèm borrowRecordId
                                auditLogDAO.insert(conn, actorId, "CREATE_COMPENSATION_FINE_FROM_INCIDENT",
                                        "Fine", fineId, null,
                                        "{\"borrowRecordId\":" + br.getBorrowRecordId()
                                        + ",\"userId\":" + userId + ",\"amount\":" + fineAmount
                                        + ",\"incidentId\":" + incidentId
                                        + ",\"incidentType\":\"" + escape(incident.getIncidentType()) + "\"}");

                                LOGGER.log(Level.INFO,
                                        "F13 Resolve: Tạo phạt đền bù — incidentId={0}, fineId={1}, userId={2}, amount={3}",
                                        new Object[]{incidentId, fineId, userId, fineAmount});

                                // Lưu thông tin để gửi email sau commit (T010)
                                compensationFineAmount = fineAmount;
                                compensationUserId = userId;
                                compensationBookId = bookId;
                                compensationCondition = incident.getIncidentType();
                            }
                        }

                    } else {
                        // ============================================================
                        // T011: Reject — khôi phục BookCopy, không đụng Fine/Lock
                        // ============================================================
                        Book parentBook = bookDAO.findByIdForUpdate(conn, copy.getBookId());
                        if (parentBook != null && "available".equals(parentBook.getStatus())) {
                            if (incident.getBorrowRecordId() != null
                                    && "damaged".equals(incident.getIncidentType())) {
                                // Sự cố từ F6: condition đã là 'damaged' → dùng restoreAfterRepair
                                bookCopyDAO.restoreAfterRepair(conn, copy.getBookCopyId());
                            } else if (incident.getBorrowRecordId() == null) {
                                // Sự cố thủ công: condition vẫn là 'good'
                                bookCopyDAO.restoreAvailable(conn, copy.getBookCopyId());
                            }
                            // lost từ F6: không thể khôi phục về available — để nguyên unavailable
                            promotedReservation = allocateRestoredCapacity(conn, copy.getBookId());
                            promotedBookTitle = parentBook.getTitle();
                        }
                        incidentDAO.finish(conn, incidentId, "rejected", resolution, actorId);

                        // T013: Audit log kèm borrowRecordId nếu có
                        String rejectNewValues = toAuditValue(incident, "rejected");
                        if (incident.getBorrowRecordId() != null) {
                            rejectNewValues = rejectNewValues.replace("}", ",\"borrowRecordId\":"
                                    + incident.getBorrowRecordId() + "}");
                        }
                        auditLogDAO.insert(conn, actorId, "REJECT_BOOK_COPY_INCIDENT",
                                "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                                rejectNewValues);
                        auditLogDAO.insert(conn, actorId, "RESTORE_BOOK_COPY", "BookCopy",
                                copy.getBookCopyId(), copyAuditValue(copy, "unavailable"),
                                copyAuditValue(copy, "available"));
                    }
                }
                conn.commit();
                if (promotedReservation != null) {
                    notifyReservationReady(promotedReservation, promotedBookTitle);
                }
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật sự cố và đồng bộ tồn kho.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }

        // T010: Gửi email thông báo phạt đền bù bất đồng bộ SAU commit (FR-007)
        if (compensationFineAmount != null && compensationUserId > 0) {
            triggerIncidentFineEmailAsync(compensationUserId, compensationBookId,
                    compensationCondition, compensationFineAmount);
        }
    }

    // =========================================================================
    // PRIVATE HELPER METHODS
    // =========================================================================

    /**
     * Tính số tiền phạt đền bù cho sách hỏng hoặc mất.
     * Công thức: damaged = price × 1.5; lost = price × 2.0.
     * Nếu price chưa nhập → dùng DEFAULT_BOOK_PRICE.
     */
    private BigDecimal calculateCompensationAmount(Connection conn, int bookId, String incidentType)
            throws SQLException {
        BigDecimal defaultFine = DEFAULT_BOOK_PRICE;
        double damagedMultiplier = 1.5;
        double lostMultiplier = 2.0;

        try {
            String defPriceStr = systemConfigDAO.getValue(conn, "DEFAULT_BOOK_PRICE", null);
            if (defPriceStr != null) defaultFine = new BigDecimal(defPriceStr);

            String damMultStr = systemConfigDAO.getValue(conn, "DAMAGED_FINE_MULTIPLIER", null);
            if (damMultStr != null) damagedMultiplier = Double.parseDouble(damMultStr);

            String lostMultStr = systemConfigDAO.getValue(conn, "LOST_FINE_MULTIPLIER", null);
            if (lostMultStr != null) lostMultiplier = Double.parseDouble(lostMultStr);
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "[FINE CALC] Không đọc được cấu hình phạt đền bù — dùng mặc định", ex);
        }

        Book book = bookDAO.findById(conn, bookId);
        if (book == null || book.getPrice() == null) {
            LOGGER.log(Level.WARNING,
                    "[FINE CALC] Không tìm thấy giá sách cho bookId={0} — dùng mặc định {1}",
                    new Object[]{bookId, defaultFine});
            return defaultFine;
        }

        double multiplier = "lost".equals(incidentType) ? lostMultiplier : damagedMultiplier;
        return book.getPrice().multiply(BigDecimal.valueOf(multiplier));
    }

    /**
     * Gửi email thông báo phạt đền bù sự cố — bất đồng bộ, NGOÀI transaction (FR-007).
     */
    private void triggerIncidentFineEmailAsync(int userId, int bookId, String condition, BigDecimal fineAmount) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            User user = userDAO.findByUserId(userId);
            if (user == null) return;

            MemberProfile profile = memberProfileDAO.findByUserId(userId);
            String fullName = (profile != null) ? profile.getFullName() : user.getEmail();

            Book book = bookDAO.findById(conn, bookId);
            String bookTitle = (book != null) ? book.getTitle() : "Sách thư viện";

            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("bookTitle", bookTitle);
            placeholders.put("incidentType", "damaged".equals(condition) ? "Hỏng sách" : "Mất sách");
            placeholders.put("fineAmount", String.format("%,.0f VND", fineAmount.doubleValue()));

            model.EmailJob job = new model.EmailJob("INCIDENT_FINE_NOTICE", user.getEmail(), fullName, placeholders);
            EmailService.enqueue(job);

            LOGGER.log(Level.INFO, "[ASYNC] Đã enqueue email INCIDENT_FINE_NOTICE cho userId={0}", userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kích hoạt gửi email thông báo phạt sự cố.", e);
        }
    }

    private void validateReportableCopy(BookCopy copy) throws ValidationException {
        if (copy == null) {
            throw new ValidationException("Không tìm thấy bản sao theo mã vạch.");
        }
        if (!"good".equals(copy.getCondition())) {
            throw new ValidationException("Bản sao đã được kết luận hỏng hoặc mất.");
        }
        if ("borrowed".equals(copy.getStatus())) {
            throw new ValidationException("Không thể ghi nhận sự cố cho bản sao đang mượn.");
        }
        if (!"available".equals(copy.getStatus())) {
            throw new ValidationException("Bản sao đang ngừng lưu thông hoặc chờ xử lý sự cố.");
        }
    }

    private Reservation allocateRestoredCapacity(Connection conn, int bookId) throws SQLException {
        Reservation next = reservationDAO.findNextInQueue(conn, bookId);
        if (next != null) {
            int holdDays = new SystemConfigDAO().getIntValue(conn, "RESERVATION_HOLD_DAYS", 3);
            reservationDAO.updateToReadyPickupWithoutCopy(conn, next.getReservationId(), holdDays);
            reservationDAO.decrementQueuePositions(conn, bookId);
            return next;
        }
        bookDAO.updateQuantities(conn, bookId, 0, 1);
        return null;
    }

    private void notifyReservationDelayed(Reservation reservation, String bookTitle) {
        try {
            User user = userDAO.findByUserId(reservation.getUserId());
            if (user == null || user.getEmail() == null) {
                return;
            }
            MemberProfile profile = memberProfileDAO.findByUserId(reservation.getUserId());
            String fullName = profile != null ? profile.getFullName() : user.getEmail();
            EmailService.sendReservationDelayedEmail(user.getEmail(), fullName, bookTitle);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể gửi thông báo lùi reservationId="
                    + reservation.getReservationId(), e);
        }
    }

    private void notifyReservationReady(Reservation reservation, String bookTitle) {
        try {
            User user = userDAO.findByUserId(reservation.getUserId());
            if (user == null || user.getEmail() == null) {
                return;
            }
            MemberProfile profile = memberProfileDAO.findByUserId(reservation.getUserId());
            String fullName = profile != null ? profile.getFullName() : user.getEmail();
            int holdDays = new SystemConfigDAO().getIntValue("RESERVATION_HOLD_DAYS", 3);
            java.sql.Timestamp deadline = new java.sql.Timestamp(
                    System.currentTimeMillis() + (long) holdDays * 24 * 60 * 60 * 1000);
            java.util.Map<String, String> placeholders = new java.util.HashMap<>();
            placeholders.put("bookTitle", bookTitle != null ? bookTitle : "Sách đã đặt");
            placeholders.put("pickupDeadline",
                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(deadline));
            EmailService.enqueue(new model.EmailJob("RESERVATION_READY", user.getEmail(), fullName, placeholders));
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể gửi thông báo sẵn sàng cho reservationId="
                    + reservation.getReservationId(), e);
        }
    }

    private String toAuditValue(BookCopyIncident incident, String status) {
        return "{\"bookCopyId\":" + incident.getBookCopyId() + ",\"incidentType\":\""
                + escape(incident.getIncidentType()) + "\",\"status\":\"" + status + "\"}";
    }

    private String copyAuditValue(BookCopy copy, String status) {
        return "{\"barcode\":\"" + escape(copy.getBarcode()) + "\",\"condition\":\""
                + escape(copy.getCondition()) + "\",\"status\":\"" + status + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
