package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
import dao.BookDAO;
import dao.InventoryDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import model.BookCopy;
import model.BookCopyIncident;
import model.InventoryItem;
import model.InventorySession;
import util.DatabaseConnection;

public class InventoryReconciliationService {
    private final InventoryDAO inventoryDAO;
    private final BookCopyDAO copyDAO;
    private final BookCopyIncidentDAO incidentDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditDAO;

    public InventoryReconciliationService() {
        this(new InventoryDAO(), new BookCopyDAO(), new BookCopyIncidentDAO(), new BookDAO(), new AuditLogDAO());
    }

    public InventoryReconciliationService(InventoryDAO inventoryDAO, BookCopyDAO copyDAO,
            BookCopyIncidentDAO incidentDAO, BookDAO bookDAO, AuditLogDAO auditDAO) {
        this.inventoryDAO = inventoryDAO; this.copyDAO = copyDAO; this.incidentDAO = incidentDAO;
        this.bookDAO = bookDAO; this.auditDAO = auditDAO;
    }

    public int create(String location, String note, int actorId) throws ValidationException, DatabaseException {
        validateLocation(location);
        if (note != null && note.length() > 1000) throw new ValidationException("Ghi chú không được vượt quá 1000 ký tự.");
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int id = inventoryDAO.insertSession(conn, location.trim(), note, actorId);
                int expected = inventoryDAO.createExpectedItems(conn, id, location.trim());
                auditDAO.insert(conn, actorId, "CREATE_INVENTORY_SESSION", "InventorySession", id, null,
                        "{\"location\":\"" + escape(location.trim()) + "\",\"expectedCount\":" + expected + "}");
                conn.commit(); return id;
            } catch (SQLException e) { conn.rollback(); throw new DatabaseException("Không thể tạo phiên kiểm kê.", e); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void start(int id, int actorId) throws ValidationException, DatabaseException {
        changeStatus(id, "draft", "counting", actorId, "START_INVENTORY_SESSION");
    }

    public void finishCounting(int id, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                requireSession(conn, id, "counting");
                int missing = inventoryDAO.markMissing(conn, id);
                inventoryDAO.updateSessionStatus(conn, id, "counting", "reviewing", actorId);
                auditDAO.insert(conn, actorId, "REVIEW_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"counting\"}", "{\"status\":\"reviewing\",\"missingCount\":" + missing + "}");
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
                if (!"available".equals(copy.getStatus()) || !"good".equals(copy.getCondition())
                        || copy.isRemovedFromInventory()) {
                    throw new ValidationException("Bản sao này không thuộc phạm vi kiểm kê vì không đang sẵn sàng trong kho.");
                }
                String result = session.getLocation().equals(copy.getLocation()) ? "matched" : "misplaced";
                inventoryDAO.recordScan(conn, id, copy.getBookCopyId(), session.getLocation(), result,
                        actorId, copy.getLocation());
                auditDAO.insert(conn, actorId, "SCAN_INVENTORY_ITEM", "BookCopy", copy.getBookCopyId(),
                        null, "{\"sessionId\":" + id + ",\"result\":\"" + result + "\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể ghi nhận mã vạch."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void resolveMisplaced(int itemId, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventoryItem item = inventoryDAO.findItem(conn, itemId, true);
                if (item == null || !"misplaced".equals(item.getResult()) || item.getResolvedAt() != null)
                    throw new ValidationException("Chênh lệch vị trí không còn khả dụng.");
                requireSession(conn, item.getInventorySessionId(), "reviewing");
                BookCopy copy = copyDAO.findByIdForUpdate(conn, item.getBookCopyId());
                copyDAO.updateLocation(conn, item.getBookCopyId(), item.getScannedLocation());
                inventoryDAO.resolveItem(conn, itemId, "Đã cập nhật vị trí theo kết quả kiểm kê.", actorId);
                auditDAO.insert(conn, actorId, "RESOLVE_MISPLACED_COPY", "BookCopy", item.getBookCopyId(),
                        "{\"location\":\"" + escape(copy.getLocation()) + "\"}",
                        "{\"location\":\"" + escape(item.getScannedLocation()) + "\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể xử lý sai vị trí."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    public void resolveMissing(int itemId, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                InventoryItem item = inventoryDAO.findItem(conn, itemId, true);
                if (item == null || !"missing".equals(item.getResult()) || item.getResolvedAt() != null)
                    throw new ValidationException("Bản sao thiếu không còn khả dụng.");
                requireSession(conn, item.getInventorySessionId(), "reviewing");
                BookCopy copy = copyDAO.findByIdForUpdate(conn, item.getBookCopyId());
                if (copy == null || !"good".equals(copy.getCondition()) || !"available".equals(copy.getStatus()))
                    throw new ValidationException("Bản sao không còn đủ điều kiện để ghi nhận mất.");
                if (incidentDAO.findOpenByBookCopyId(conn, copy.getBookCopyId()) != null)
                    throw new ValidationException("Bản sao đã có sự cố đang chờ xử lý.");
                BookCopyIncident incident = new BookCopyIncident();
                incident.setBookCopyId(copy.getBookCopyId()); incident.setIncidentType("lost");
                incident.setDescription("Không tìm thấy trong phiên kiểm kê #" + item.getInventorySessionId());
                incident.setReportedBy(actorId);
                int incidentId = incidentDAO.insert(conn, incident);
                copyDAO.markUnavailable(conn, copy.getBookCopyId());
                bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);
                inventoryDAO.resolveItem(conn, itemId, "Đã tạo sự cố mất #" + incidentId + ".", actorId);
                auditDAO.insert(conn, actorId, "CREATE_INCIDENT_FROM_INVENTORY", "BookCopyIncident",
                        incidentId, null, "{\"inventoryItemId\":" + itemId + "}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể ghi nhận bản sao mất."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
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
                inventoryDAO.updateSessionStatus(conn, id, session.getStatus(), "cancelled", actorId);
                auditDAO.insert(conn, actorId, "CANCEL_INVENTORY_SESSION", "InventorySession", id,
                        "{\"status\":\"" + session.getStatus() + "\"}", "{\"status\":\"cancelled\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể hủy phiên kiểm kê."); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e); }
    }

    private void changeStatus(int id, String from, String to, int actorId, String action)
            throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                requireSession(conn, id, from); inventoryDAO.updateSessionStatus(conn, id, from, to, actorId);
                auditDAO.insert(conn, actorId, action, "InventorySession", id,
                        "{\"status\":\"" + from + "\"}", "{\"status\":\"" + to + "\"}");
                conn.commit();
            } catch (ValidationException | SQLException e) { conn.rollback(); rethrow(e, "Không thể cập nhật phiên kiểm kê."); }
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
        if (location.length() > 255) throw new ValidationException("Vị trí kiểm kê không được vượt quá 255 ký tự.");
    }
    private void rethrow(Exception e, String message) throws ValidationException, DatabaseException {
        if (e instanceof ValidationException) throw (ValidationException) e;
        throw new DatabaseException(message, e);
    }
    private String escape(String value) { return value == null ? "" : value.replace("\\","\\\\").replace("\"","\\\""); }
}
