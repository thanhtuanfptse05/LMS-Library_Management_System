package service;

import dao.AuditLogDAO;
import dao.CategoryDAO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import model.Category;
import util.DatabaseConnection;

public class CategoryService {

    private final CategoryDAO categoryDAO;
    private final AuditLogDAO auditLogDAO;

    public CategoryService() {
        this(new CategoryDAO(), new AuditLogDAO());
    }

    public CategoryService(CategoryDAO categoryDAO, AuditLogDAO auditLogDAO) {
        this.categoryDAO = categoryDAO;
        this.auditLogDAO = auditLogDAO;
    }

    public int create(Category category, int actorId) throws ValidationException, DatabaseException {
        validate(category);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if (categoryDAO.existsByName(conn, category.getName(), null)) {
                    throw new ValidationException("Tên thể loại đã tồn tại.");
                }
                int categoryId = categoryDAO.insert(conn, category, actorId);
                auditLogDAO.insert(conn, actorId, "CREATE_CATEGORY", "Category", categoryId,
                        null, toAuditValue(category));
                conn.commit();
                return categoryId;
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể tạo thể loại.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void update(Category category, int actorId) throws ValidationException, DatabaseException {
        validate(category);
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Category oldCategory = categoryDAO.findById(conn, category.getCategoryId());
                if (oldCategory == null) {
                    throw new ValidationException("Thể loại không tồn tại.");
                }
                if (categoryDAO.existsByName(conn, category.getName(), category.getCategoryId())) {
                    throw new ValidationException("Tên thể loại đã tồn tại.");
                }
                categoryDAO.update(conn, category, actorId);
                auditLogDAO.insert(conn, actorId, "UPDATE_CATEGORY", "Category", category.getCategoryId(),
                        toAuditValue(oldCategory), toAuditValue(category));
                conn.commit();
            } catch (ValidationException | SQLException e) {
                conn.rollback();
                if (e instanceof ValidationException) {
                    throw (ValidationException) e;
                }
                throw new DatabaseException("Không thể cập nhật thể loại.", e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Không thể kết nối cơ sở dữ liệu.", e);
        }
    }

    public void validate(Category category) throws ValidationException {
        if (category.getName() == null || category.getName().isBlank()) {
            throw new ValidationException("Tên thể loại không được để trống.");
        }
        if (category.getName().length() > 255) {
            throw new ValidationException("Tên thể loại không được vượt quá 255 ký tự.");
        }
        if (!"active".equals(category.getStatus()) && !"hidden".equals(category.getStatus())) {
            throw new ValidationException("Trạng thái thể loại không hợp lệ.");
        }
    }

    private String toAuditValue(Category category) {
        return "{\"name\":\"" + escape(category.getName()) + "\",\"description\":\""
                + escape(category.getDescription()) + "\",\"status\":\"" + escape(category.getStatus()) + "\"}";
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
