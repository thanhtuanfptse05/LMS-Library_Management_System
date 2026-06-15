package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
import dao.BookDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import model.BookCopy;
import model.BookCopyIncident;
import util.DatabaseConnection;

public class BookCopyIncidentService {

    private final BookCopyIncidentDAO incidentDAO;
    private final BookCopyDAO bookCopyDAO;
    private final BookDAO bookDAO;
    private final AuditLogDAO auditLogDAO;

    public BookCopyIncidentService() {
        this(new BookCopyIncidentDAO(), new BookCopyDAO(), new BookDAO(), new AuditLogDAO());
    }

    public BookCopyIncidentService(BookCopyIncidentDAO incidentDAO, BookCopyDAO bookCopyDAO,
            BookDAO bookDAO, AuditLogDAO auditLogDAO) {
        this.incidentDAO = incidentDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.bookDAO = bookDAO;
        this.auditLogDAO = auditLogDAO;
    }

    public int report(String barcode, String incidentType, String description, int actorId)
            throws ValidationException, DatabaseException {
        validateReport(barcode, incidentType, description);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
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
                bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);
                auditLogDAO.insert(conn, actorId, "CREATE_BOOK_COPY_INCIDENT", "BookCopyIncident",
                        incidentId, null, toAuditValue(incident, "pending"));
                auditLogDAO.insert(conn, actorId, "SUSPEND_BOOK_COPY", "BookCopy", copy.getBookCopyId(),
                        copyAuditValue(copy, "available"), copyAuditValue(copy, "unavailable"));
                conn.commit();
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

    private void executeIncidentAction(int incidentId, int actorId, String action, String resolution)
            throws ValidationException, DatabaseException {
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
                        bookCopyDAO.resolveCondition(conn, copy.getBookCopyId(), incident.getIncidentType());
                        incidentDAO.finish(conn, incidentId, "resolved", resolution, actorId);
                        auditLogDAO.insert(conn, actorId, "RESOLVE_BOOK_COPY_INCIDENT",
                                "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                                toAuditValue(incident, "resolved"));
                        auditLogDAO.insert(conn, actorId, "UPDATE_BOOK_COPY_CONDITION", "BookCopy",
                                copy.getBookCopyId(), copyAuditValue(copy, "unavailable"),
                                "{\"condition\":\"" + incident.getIncidentType()
                                + "\",\"status\":\"unavailable\"}");
                    } else {
                        bookCopyDAO.restoreAvailable(conn, copy.getBookCopyId());
                        bookDAO.updateQuantities(conn, copy.getBookId(), 0, 1);
                        incidentDAO.finish(conn, incidentId, "rejected", resolution, actorId);
                        auditLogDAO.insert(conn, actorId, "REJECT_BOOK_COPY_INCIDENT",
                                "BookCopyIncident", incidentId, toAuditValue(incident, incident.getStatus()),
                                toAuditValue(incident, "rejected"));
                        auditLogDAO.insert(conn, actorId, "RESTORE_BOOK_COPY", "BookCopy",
                                copy.getBookCopyId(), copyAuditValue(copy, "unavailable"),
                                copyAuditValue(copy, "available"));
                    }
                }
                conn.commit();
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
    }

    private void validateReportableCopy(BookCopy copy) throws ValidationException {
        if (copy == null) {
            throw new ValidationException("Không tìm thấy bản sao theo mã vạch.");
        }
        if (!"good".equals(copy.getCondition())) {
            throw new ValidationException("Bản sao đã được kết luận hỏng hoặc mất.");
        }
        if ("borrowed".equals(copy.getStatus()) || "reserved".equals(copy.getStatus())) {
            throw new ValidationException("Không thể ghi nhận sự cố cho bản sao đang mượn hoặc đã đặt trước.");
        }
        if (!"available".equals(copy.getStatus())) {
            throw new ValidationException("Bản sao đang ngừng lưu thông hoặc chờ xử lý sự cố.");
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
