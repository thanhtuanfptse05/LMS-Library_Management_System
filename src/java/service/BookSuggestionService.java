package service;

import dao.AuditLogDAO;
import dao.BookSuggestionDAO;
import dao.SuggestionVoteDAO;
import dao.SystemConfigurationsDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import model.BookSuggestion;
import util.DatabaseConnection;

public class BookSuggestionService {

    private final BookSuggestionDAO bookSuggestionDAO;
    private final SuggestionVoteDAO suggestionVoteDAO;
    private final AuditLogDAO auditLogDAO;
    private final SystemConfigurationsDAO systemConfigurationsDAO;

    public BookSuggestionService() {
        this.bookSuggestionDAO = new BookSuggestionDAO();
        this.suggestionVoteDAO = new SuggestionVoteDAO();
        this.auditLogDAO = new AuditLogDAO();
        this.systemConfigurationsDAO = new SystemConfigurationsDAO();
    }

    public int create(BookSuggestion suggestion, int actorId, boolean confirmSimilar) throws ValidationException, DatabaseException {
        validate(suggestion);
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Kiểm tra giới hạn số đề xuất pending
                String limitStr = systemConfigurationsDAO.getConfigValue("MAX_SUGGESTION_PER_LECTURER");
                int maxLimit = 10; // default fallback
                if (limitStr != null) {
                    try {
                        maxLimit = Integer.parseInt(limitStr);
                    } catch (NumberFormatException e) {
                        // ignore and use default
                    }
                }
                
                int pendingCount = bookSuggestionDAO.countPendingByLecturer(conn, actorId);
                if (pendingCount >= maxLimit) {
                    throw new ValidationException("Đã đạt giới hạn đề xuất (đang chờ duyệt).");
                }

                // 2. Kiểm tra trùng tiêu đề tương tự
                if (!confirmSimilar && bookSuggestionDAO.existsSimilarTitle(conn, suggestion.getTitle())) {
                    throw new ValidationException("SIMILAR_TITLE_WARNING");
                }

                // 3. Thực hiện insert đề xuất (voteCount khởi tạo = 1)
                suggestion.setCreatedBy(actorId);
                int suggestionId = bookSuggestionDAO.insert(conn, suggestion);

                // 4. Tự động ghi nhận vote của người tạo
                suggestionVoteDAO.insert(conn, suggestionId, actorId);

                // 5. Ghi Audit Log
                auditLogDAO.insert(conn, actorId, "CREATE_SUGGESTION", "BookSuggestion", suggestionId,
                        null, toAuditValue(suggestion));

                conn.commit();
                return suggestionId;
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể gửi đề xuất sách.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void update(BookSuggestion suggestion, int actorId) throws ValidationException, DatabaseException {
        validate(suggestion);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookSuggestion oldSuggestion = bookSuggestionDAO.findById(conn, suggestion.getSuggestionId());
                if (oldSuggestion == null) {
                    throw new ValidationException("Đề xuất không tồn tại.");
                }
                if (oldSuggestion.getCreatedBy() != actorId) {
                    throw new ValidationException("Bạn không có quyền sửa đề xuất này.");
                }
                if (!"pending".equals(oldSuggestion.getStatus()) || oldSuggestion.getVoteCount() != 1) {
                    throw new ValidationException("Chỉ cho phép sửa đề xuất ở trạng thái pending và chưa có người khác vote.");
                }

                bookSuggestionDAO.update(conn, suggestion);
                
                auditLogDAO.insert(conn, actorId, "UPDATE_SUGGESTION", "BookSuggestion", suggestion.getSuggestionId(),
                        toAuditValue(oldSuggestion), toAuditValue(suggestion));
                
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật đề xuất sách.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void delete(int suggestionId, int actorId) throws ValidationException, DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookSuggestion oldSuggestion = bookSuggestionDAO.findById(conn, suggestionId);
                if (oldSuggestion == null) {
                    throw new ValidationException("Đề xuất không tồn tại.");
                }
                if (oldSuggestion.getCreatedBy() != actorId) {
                    throw new ValidationException("Bạn không có quyền xóa đề xuất này.");
                }
                if (!"pending".equals(oldSuggestion.getStatus()) || oldSuggestion.getVoteCount() != 1) {
                    throw new ValidationException("Chỉ cho phép xóa đề xuất ở trạng thái pending và chưa có người khác vote.");
                }

                // Xóa cứng: SuggestionVote sẽ tự cascade delete do khóa ngoại ON DELETE CASCADE
                bookSuggestionDAO.delete(conn, suggestionId);
                
                auditLogDAO.insert(conn, actorId, "DELETE_SUGGESTION", "BookSuggestion", suggestionId,
                        toAuditValue(oldSuggestion), null);
                
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể xóa đề xuất sách.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void updateStatus(int suggestionId, String status, String librarianNote, int actorId) throws ValidationException, DatabaseException {
        if (status == null || (!"pending".equals(status) && !"acknowledged".equals(status) && !"rejected".equals(status))) {
            throw new ValidationException("Trạng thái duyệt không hợp lệ.");
        }
        if (librarianNote != null && librarianNote.length() > 1000) {
            throw new ValidationException("Ghi chú thủ thư không được vượt quá 1000 ký tự.");
        }
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookSuggestion oldSuggestion = bookSuggestionDAO.findById(conn, suggestionId);
                if (oldSuggestion == null) {
                    throw new ValidationException("Đề xuất không tồn tại.");
                }
                
                bookSuggestionDAO.updateStatus(conn, suggestionId, status, librarianNote, actorId);
                
                String oldValJson = "{\"status\":\"" + oldSuggestion.getStatus() + "\"}";
                String newValJson = "{\"status\":\"" + status + "\",\"librarianNote\":\"" + (librarianNote == null ? "" : escape(librarianNote)) + "\"}";
                
                auditLogDAO.insert(conn, actorId, "APPROVE_SUGGESTION", "BookSuggestion", suggestionId,
                        oldValJson, newValJson);
                
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật trạng thái đề xuất.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validate(BookSuggestion suggestion) throws ValidationException {
        if (suggestion.getTitle() == null || suggestion.getTitle().isBlank()) {
            throw new ValidationException("Tiêu đề sách không được để trống.");
        }
        if (suggestion.getTitle().length() > 255) {
            throw new ValidationException("Tiêu đề sách không được vượt quá 255 ký tự.");
        }
        if (suggestion.getAuthor() == null || suggestion.getAuthor().isBlank()) {
            throw new ValidationException("Tác giả không được để trống.");
        }
        if (suggestion.getAuthor().length() > 255) {
            throw new ValidationException("Tên tác giả không được vượt quá 255 ký tự.");
        }
        if (suggestion.getPublisher() != null && suggestion.getPublisher().length() > 255) {
            throw new ValidationException("Nhà xuất bản không được vượt quá 255 ký tự.");
        }
        if (suggestion.getIsbn() != null && !suggestion.getIsbn().isEmpty()) {
            String isbn = suggestion.getIsbn().trim();
            if (isbn.length() < 10 || isbn.length() > 13) {
                throw new ValidationException("Mã ISBN phải dài từ 10 đến 13 ký tự.");
            }
        }
        if (suggestion.getReason() == null || suggestion.getReason().isBlank()) {
            throw new ValidationException("Lý do đề xuất không được để trống.");
        }
        if (suggestion.getReason().length() > 1000) {
            throw new ValidationException("Lý do đề xuất không được vượt quá 1000 ký tự.");
        }
    }

    private String toAuditValue(BookSuggestion s) {
        return "{\"title\":\"" + escape(s.getTitle()) 
                + "\",\"author\":\"" + escape(s.getAuthor()) 
                + "\",\"publisher\":\"" + escape(s.getPublisher()) 
                + "\",\"isbn\":\"" + escape(s.getIsbn()) 
                + "\",\"reason\":\"" + escape(s.getReason()) 
                + "\",\"status\":\"" + escape(s.getStatus()) + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
