package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
import dao.BookDAO;
import dao.InventoryDAO;
import dao.MemberProfileDAO;
import dao.ReservationDAO;
import dao.UserDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BookCopy;
import model.BookCopyIncident;
import model.InventoryItem;
import model.InventorySession;
import model.MemberProfile;
import model.Reservation;
import model.User;
import util.DatabaseConnection;

public class InventoryReconciliationService {
    private static final Logger LOGGER = Logger.getLogger(InventoryReconciliationService.class.getName());

    private final InventoryDAO inventoryDAO;
    private final BookCopyDAO copyDAO;
    private final BookCopyIncidentDAO incidentDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditDAO;
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;

    public InventoryReconciliationService() {
        this(new InventoryDAO(), new BookCopyDAO(), new BookCopyIncidentDAO(), new BookDAO(),
                new AuditLogDAO(), new ReservationDAO(), new UserDAO(), new MemberProfileDAO());
    }

    public InventoryReconciliationService(InventoryDAO inventoryDAO, BookCopyDAO copyDAO,
            BookCopyIncidentDAO incidentDAO, BookDAO bookDAO, AuditLogDAO auditDAO) {
        this(inventoryDAO, copyDAO, incidentDAO, bookDAO, auditDAO,
                new ReservationDAO(), new UserDAO(), new MemberProfileDAO());
    }

    public InventoryReconciliationService(InventoryDAO inventoryDAO, BookCopyDAO copyDAO,
            BookCopyIncidentDAO incidentDAO, BookDAO bookDAO, AuditLogDAO auditDAO,
            ReservationDAO reservationDAO, UserDAO userDAO, MemberProfileDAO memberProfileDAO) {
        this.inventoryDAO = inventoryDAO; this.copyDAO = copyDAO; this.incidentDAO = incidentDAO;
        this.bookDAO = bookDAO; this.auditDAO = auditDAO;
        this.reservationDAO = reservationDAO; this.userDAO = userDAO;
        this.memberProfileDAO = memberProfileDAO;
    }

    public int create(String location, String note, int actorId) throws ValidationException, DatabaseException {
        validateLocation(location);
        if (note != null && note.length() > 1000) throw new ValidationException("Ghi chú không được vượt quá 1000 ký tự.");
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int id = inventoryDAO.insertSession(conn, location.trim(), note, actorId);
                auditDAO.insert(conn, actorId, "CREATE_INVENTORY_SESSION", "InventorySession", id, null,
                        "{\"location\":\"" + escape(location.trim()) + "\",\"status\":\"draft\"}");
                conn.commit(); return id;
            } catch (SQLException e) {
                conn.rollback();
                throw new DatabaseException("Không thể tạo phiên kiểm kê.", e);
            }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void start(int id, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventorySession session = requireSession(conn, id, "draft");
                if (inventoryDAO.hasRunningSession(conn, id)) {
                    throw new ValidationException("Đang có một phiên kiểm kê khác chưa hoàn tất hoặc hủy.");
                }
                int expected = inventoryDAO.createExpectedItems(conn, id, session.getLocation());
                inventoryDAO.updateSessionStatus(conn, id, "draft", "counting", actorId);
                auditDAO.insert(conn, actorId, "START_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"draft\"}",
                        "{\"status\":\"counting\",\"expectedCount\":" + expected + "}");
                conn.commit();
            } catch (ValidationException e) {
                conn.rollback();
                throw e;
            } catch (SQLException e) {
                conn.rollback();
                if ("23505".equals(e.getSQLState())) {
                    throw new ValidationException("Đang có một phiên kiểm kê khác chưa hoàn tất hoặc hủy.");
                }
                throw new DatabaseException("Không thể bắt đầu phiên kiểm kê.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void finishCounting(int id, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventorySession session = requireSession(conn, id, "counting");
                int scannedExpected = inventoryDAO.countScannedExpectedItems(conn, id);
                if (session.getExpectedCount() > 0 && scannedExpected == 0) {
                    throw new ValidationException("Chưa quét bản sao dự kiến nào. Không thể kết thúc kiểm đếm.");
                }
                int excluded = inventoryDAO.resolveCopiesOutsideCountingScope(conn, id, actorId);
                int missing = inventoryDAO.markMissing(conn, id);
                inventoryDAO.updateSessionStatus(conn, id, "counting", "reviewing", actorId);
                auditDAO.insert(conn, actorId, "REVIEW_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"counting\"}", "{\"status\":\"reviewing\",\"missingCount\":"
                        + missing + ",\"excludedCount\":" + excluded + "}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể kết thúc kiểm đếm."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void scan(int id, String barcode, int actorId) throws ValidationException, DatabaseException {
        if (barcode == null || barcode.isBlank()) throw new ValidationException("Mã vạch không được để trống.");
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventorySession session = requireSession(conn, id, "counting");
                BookCopy copy = copyDAO.findByBarcodeForUpdate(conn, barcode.trim());
                if (copy == null) throw new ValidationException("Mã vạch không tồn tại trên hệ thống.");
                if (inventoryDAO.isScannedInSession(conn, id, copy.getBookCopyId())) {
                    throw new ValidationException("Bản sao này đã được quét trong phiên kiểm kê.");
                }
                String anomalyType = classifyAnomalyType(copy);
                String result = anomalyType == null
                        ? (sameLocation(session.getLocation(), copy.getLocation()) ? "matched" : "misplaced")
                        : "unexpected";
                inventoryDAO.recordScan(conn, id, copy.getBookCopyId(), session.getLocation(), result,
                        anomalyType, actorId, copy.getLocation());
                auditDAO.insert(conn, actorId, "SCAN_INVENTORY_ITEM", "BookCopy", copy.getBookCopyId(),
                        null, "{\"sessionId\":" + id + ",\"result\":\"" + result
                                + "\",\"anomalyType\":"
                                + (anomalyType == null ? "null" : "\"" + anomalyType + "\"") + "}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể ghi nhận mã vạch."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void resolveMisplaced(int itemId, String resolutionMode, int actorId)
            throws ValidationException, DatabaseException {
        validateMisplacedResolutionMode(resolutionMode);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventoryItem item = inventoryDAO.findItem(conn, itemId, true);
                if (item == null || !"misplaced".equals(item.getResult()) || item.getResolvedAt() != null)
                    throw new ValidationException("Chênh lệch vị trí không còn khả dụng.");
                requireSession(conn, item.getInventorySessionId(), "reviewing");
                BookCopy copy = copyDAO.findByIdForUpdate(conn, item.getBookCopyId());
                validateResolvableMisplacedCopy(copy);
                validateSnapshotLocation(copy, item);
                if ("relocate_to_scanned".equals(resolutionMode)) {
                    copyDAO.updateLocation(conn, item.getBookCopyId(), item.getScannedLocation());
                    inventoryDAO.resolveItem(conn, itemId,
                            "Đã chuyển vị trí đăng ký sang nơi tìm thấy khi kiểm kê.", actorId);
                    auditDAO.insert(conn, actorId, "RELOCATE_MISPLACED_COPY", "BookCopy",
                            item.getBookCopyId(),
                            "{\"location\":\"" + escape(copy.getLocation()) + "\"}",
                            "{\"location\":\"" + escape(item.getScannedLocation()) + "\"}");
                } else {
                    inventoryDAO.resolveItem(conn, itemId,
                            "Thủ thư xác nhận đã đưa bản sao về vị trí đăng ký.", actorId);
                    auditDAO.insert(conn, actorId, "RETURN_MISPLACED_COPY_TO_EXPECTED_LOCATION",
                            "BookCopy", item.getBookCopyId(),
                            "{\"foundAt\":\"" + escape(item.getScannedLocation()) + "\"}",
                            "{\"location\":\"" + escape(item.getExpectedLocation()) + "\"}");
                }
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể xử lý sai vị trí."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void resolveMissing(int itemId, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            Reservation demotedReservation = null;
            String bookTitle = null;
            try {
                InventoryItem item = inventoryDAO.findItem(conn, itemId, true);
                if (item == null || !"missing".equals(item.getResult()) || item.getResolvedAt() != null)
                    throw new ValidationException("Bản sao thiếu không còn khả dụng.");
                requireSession(conn, item.getInventorySessionId(), "reviewing");
                BookCopy locatedCopy = copyDAO.findById(conn, item.getBookCopyId());
                if (locatedCopy == null) throw new ValidationException("Bản sao không tồn tại.");
                model.Book book = bookDAO.findByIdForUpdate(conn, locatedCopy.getBookId());
                if (book == null) throw new ValidationException("Đầu sách của bản sao không tồn tại.");
                bookTitle = book.getTitle();
                BookCopy copy = copyDAO.findByIdForUpdate(conn, item.getBookCopyId());
                if (copy == null || copy.isRemovedFromInventory()
                        || !"good".equals(copy.getCondition()) || !"available".equals(copy.getStatus()))
                    throw new ValidationException("Bản sao không còn đủ điều kiện để ghi nhận mất.");
                validateSnapshotLocation(copy, item);
                if (incidentDAO.findOpenByBookCopyId(conn, copy.getBookCopyId()) != null)
                    throw new ValidationException("Bản sao đã có sự cố đang chờ xử lý.");
                BookCopyIncident incident = new BookCopyIncident();
                incident.setBookCopyId(copy.getBookCopyId()); incident.setIncidentType("lost");
                incident.setDescription("Không tìm thấy trong phiên kiểm kê #" + item.getInventorySessionId());
                incident.setReportedBy(actorId);
                int incidentId = incidentDAO.insert(conn, incident);
                copyDAO.markUnavailable(conn, copy.getBookCopyId());
                if (ReservationCapacityPolicy.onPhysicalCopyUnavailable(book.getAvailableQuantity())
                        == ReservationCapacityPolicy.CapacityLossAction.DECREMENT_AVAILABLE) {
                    bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);
                } else {
                    demotedReservation = reservationDAO.findLatestReadyPickupForUpdate(conn, copy.getBookId());
                    if (demotedReservation != null) {
                        reservationDAO.demoteReadyPickupToFront(conn,
                                demotedReservation.getReservationId(), copy.getBookId());
                        auditDAO.insert(conn, actorId, "DEMOTE_RESERVATION_INVENTORY_SHORTAGE",
                                "Reservation", demotedReservation.getReservationId(),
                                "{\"status\":\"readypickup\"}",
                                "{\"status\":\"pending\",\"queuePosition\":1}");
                    }
                }
                inventoryDAO.resolveItem(conn, itemId, "Đã tạo sự cố mất #" + incidentId + ".", actorId);
                auditDAO.insert(conn, actorId, "CREATE_INCIDENT_FROM_INVENTORY", "BookCopyIncident",
                        incidentId, null, "{\"inventoryItemId\":" + itemId + "}");
                conn.commit();
                if (demotedReservation != null) {
                    notifyReservationDelayed(demotedReservation, bookTitle);
                }
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể ghi nhận bản sao mất."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void resolveUnexpected(int itemId, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventoryItem item = inventoryDAO.findItem(conn, itemId, true);
                if (item == null || !"unexpected".equals(item.getResult()) || item.getResolvedAt() != null) {
                    throw new ValidationException("Bản sao bất thường không còn khả dụng để xác minh.");
                }
                requireSession(conn, item.getInventorySessionId(), "reviewing");
                String resolution = unexpectedResolution(item.getAnomalyType());
                inventoryDAO.resolveItem(conn, itemId, resolution, actorId);
                auditDAO.insert(conn, actorId, "RESOLVE_UNEXPECTED_INVENTORY_ITEM", "InventoryItem",
                        itemId, null, "{\"anomalyType\":\"" + escape(item.getAnomalyType())
                                + "\",\"resolution\":\"" + escape(resolution) + "\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                rethrow(e, "Không thể xác minh bản sao bất thường.");
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
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

    public void complete(int id, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                requireSession(conn, id, "reviewing");
                if (inventoryDAO.countUnresolved(conn, id) > 0)
                    throw new ValidationException("Cần xử lý toàn bộ chênh lệch trước khi hoàn tất.");
                inventoryDAO.updateSessionStatus(conn, id, "reviewing", "completed", actorId);
                auditDAO.insert(conn, actorId, "COMPLETE_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"reviewing\"}", "{\"status\":\"completed\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể hoàn tất phiên kiểm kê."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void cancel(int id, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventorySession session = inventoryDAO.findSession(conn, id, true);
                if (session == null) throw new ValidationException("Phiên kiểm kê không tồn tại.");
                if ("completed".equals(session.getStatus()) || "cancelled".equals(session.getStatus()))
                    throw new ValidationException("Phiên kiểm kê đã kết thúc.");
                int resolvedDiscrepancies = inventoryDAO.countResolvedDiscrepancies(conn, id);
                validateCancellableSession(session, resolvedDiscrepancies);
                inventoryDAO.updateSessionStatus(conn, id, session.getStatus(), "cancelled", actorId);
                auditDAO.insert(conn, actorId, "CANCEL_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"" + session.getStatus() + "\"}", "{\"status\":\"cancelled\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể hủy phiên kiểm kê."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    private InventorySession requireSession(Connection conn, int id, String status) throws SQLException, ValidationException {
        InventorySession session = inventoryDAO.findSession(conn, id, true);
        if (session == null) throw new ValidationException("Phiên kiểm kê không tồn tại.");
        if (!status.equals(session.getStatus())) throw new ValidationException("Phiên kiểm kê không ở trạng thái phù hợp.");
        return session;
    }
    public void validateLocation(String location) throws ValidationException {
        if (location == null || location.isBlank()) throw new ValidationException("Vị trí kiểm kê không được để trống.");
        if (location.trim().length() > 255) throw new ValidationException("Vị trí kiểm kê không được vượt quá 255 ký tự.");
    }
    void validateMisplacedResolutionMode(String resolutionMode) throws ValidationException {
        if (!"return_to_expected".equals(resolutionMode)
                && !"relocate_to_scanned".equals(resolutionMode)) {
            throw new ValidationException("Cách xử lý sai vị trí không hợp lệ.");
        }
    }
    void validateResolvableMisplacedCopy(BookCopy copy) throws ValidationException {
        if (copy == null) {
            throw new ValidationException("Bản sao không còn tồn tại.");
        }
        if (copy.isRemovedFromInventory()) {
            throw new ValidationException("Không thể cập nhật vị trí vì bản sao đã bị thanh lý khỏi kho.");
        }
        if (!"available".equals(copy.getStatus())) {
            throw new ValidationException("Không thể cập nhật vị trí vì bản sao không còn ở trạng thái sẵn sàng.");
        }
        if (!"good".equals(copy.getCondition())) {
            throw new ValidationException("Không thể cập nhật vị trí vì bản sao không còn ở tình trạng tốt.");
        }
    }
    void validateCancellableSession(InventorySession session, int resolvedDiscrepancies)
            throws ValidationException {
        if ("reviewing".equals(session.getStatus()) && resolvedDiscrepancies > 0) {
            throw new ValidationException("Không thể hủy phiên vì đã có chênh lệch được xử lý. Hãy hoàn tất phiên kiểm kê.");
        }
        if (!"draft".equals(session.getStatus()) && !"counting".equals(session.getStatus())
                && !"reviewing".equals(session.getStatus())) {
            throw new ValidationException("Phiên kiểm kê không ở trạng thái có thể hủy.");
        }
    }
    void validateSnapshotLocation(BookCopy copy, InventoryItem item) throws ValidationException {
        if (!sameLocation(copy.getLocation(), item.getExpectedLocation())) {
            throw new ValidationException("Vị trí bản sao đã thay đổi sau khi lập snapshot. Hãy tải lại phiên kiểm kê.");
        }
    }
    String classifyAnomalyType(BookCopy copy) {
        if (copy.isRemovedFromInventory()) return "removed_copy_found";
        if ("lost".equals(copy.getCondition())) return "found_lost";
        if ("borrowed".equals(copy.getStatus())) return "borrowed_on_shelf";
        if ("damaged".equals(copy.getCondition())) return "damaged_on_shelf";
        if (!"available".equals(copy.getStatus()) || !"good".equals(copy.getCondition())) {
            return "unavailable_on_shelf";
        }
        return null;
    }
    String unexpectedResolution(String anomalyType) throws ValidationException {
        return switch (anomalyType == null ? "" : anomalyType) {
            case "damaged_on_shelf" -> "Đã đưa bản sao hỏng khỏi kệ để chuyển sang khu xử lý.";
            case "borrowed_on_shelf" -> "Đã chuyển bản sao đến quầy lưu thông để kiểm tra giao dịch mượn/trả.";
            case "found_lost" -> "Đã chuyển bản sao được tìm thấy đến quy trình xử lý hỏng/mất.";
            case "removed_copy_found" -> "Đã chuyển bản sao từng thanh lý đến quản lý để xác minh.";
            case "unavailable_on_shelf" -> "Đã đưa bản sao không khả dụng khỏi kệ để xác minh.";
            default -> throw new ValidationException("Loại bất thường kiểm kê không hợp lệ.");
        };
    }
    private boolean sameLocation(String first, String second) {
        return first != null && second != null && first.trim().equalsIgnoreCase(second.trim());
    }
    private void rethrow(Exception e, String message) throws ValidationException, DatabaseException {
        if (e instanceof ValidationException) throw (ValidationException) e;
        throw new DatabaseException(message, e);
    }
    private String escape(String value) { return value == null ? "" : value.replace("\\","\\\\").replace("\"","\\\""); }
}
