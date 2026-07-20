package service;

import dao.AuditLogDAO;
import dao.TagDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import model.Tag;
import util.DatabaseConnection;

public class TagService {

    private final TagDAO tagDAO;
    private final AuditLogDAO auditLogDAO;

    public TagService() {
        this(new TagDAO(), new AuditLogDAO());
    }

    public TagService(TagDAO tagDAO, AuditLogDAO auditLogDAO) {
        this.tagDAO = tagDAO;
        this.auditLogDAO = auditLogDAO;
    }

    public int create(Tag tag, int actorId) throws ValidationException, DatabaseException {
        validate(tag);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if (tagDAO.existsByName(conn, tag.getName(), null)) {
                    throw new ValidationException("Tên tag sách đã tồn tại.");
                }
                int tagId = tagDAO.insert(conn, tag, actorId);
                auditLogDAO.insert(conn, actorId, "CREATE_TAG", "Tag", tagId, null, toAuditValue(tag));
                conn.commit();
                return tagId;
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể tạo tag sách.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void update(Tag tag, int actorId) throws ValidationException, DatabaseException {
        validate(tag);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Tag oldTag = tagDAO.findById(conn, tag.getTagId());
                if (oldTag == null) {
                    throw new ValidationException("Tag sách không tồn tại.");
                }
                if (tagDAO.existsByName(conn, tag.getName(), tag.getTagId())) {
                    throw new ValidationException("Tên tag sách đã tồn tại.");
                }
                tagDAO.update(conn, tag, actorId);
                auditLogDAO.insert(conn, actorId, "UPDATE_TAG", "Tag", tag.getTagId(),
                        toAuditValue(oldTag), toAuditValue(tag));
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật tag sách.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validate(Tag tag) throws ValidationException {
        if (tag.getName() == null || tag.getName().isBlank()) {
            throw new ValidationException("Tên tag sách không được để trống.");
        }
        if (tag.getName().length() > 100) {
            throw new ValidationException("Tên tag sách không được vượt quá 100 ký tự.");
        }
        if (!"active".equals(tag.getStatus()) && !"hidden".equals(tag.getStatus())) {
            throw new ValidationException("Trạng thái tag sách không hợp lệ.");
        }
    }

    private String toAuditValue(Tag tag) {
        return "{\"name\":\"" + escape(tag.getName()) + "\",\"status\":\"" + escape(tag.getStatus()) + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
