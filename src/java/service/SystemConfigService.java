package service;

import config.SystemConfigCache;
import dao.AuditLogDAO;
import dao.SystemConfigDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletContext;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import model.SystemConfiguration;
import util.DatabaseConnection;

public class SystemConfigService {

    private final SystemConfigDAO dao;
    private final AuditLogDAO auditLogDAO;

    public SystemConfigService() {
        this.dao = new SystemConfigDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    private static final Map<String, String> KEY_TYPES = Map.ofEntries(
            Map.entry("STUDENT_MAX_BORROW_DAYS", "POSITIVE_INT"),
            Map.entry("LECTURER_MAX_BORROW_DAYS", "POSITIVE_INT"),
            Map.entry("STUDENT_MAX_BORROW_LIMIT", "POSITIVE_INT"),
            Map.entry("LECTURER_MAX_BORROW_LIMIT", "POSITIVE_INT"),
            Map.entry("MAX_EXTENSION_COUNT", "NON_NEGATIVE_INT"),
            Map.entry("RENEW_DURATION_DAYS", "POSITIVE_INT"),
            Map.entry("RESERVATION_HOLD_DAYS", "POSITIVE_INT"),
            Map.entry("RENEW_THRESHOLD_PERCENT", "POSITIVE_INT"),
            Map.entry("FINE_RATE_PER_DAY", "NON_NEGATIVE_DECIMAL"),
            Map.entry("LOST_FINE_MULTIPLIER", "NON_NEGATIVE_DECIMAL"),
            Map.entry("DAMAGED_FINE_MULTIPLIER", "NON_NEGATIVE_DECIMAL"),
            Map.entry("DEFAULT_BOOK_PRICE", "NON_NEGATIVE_DECIMAL"),
            Map.entry("EMAIL_OTP_EXPIRE_MINUTES", "POSITIVE_INT"),
            Map.entry("EMAIL_OVERDUE_NOTICE_DAYS", "POSITIVE_INT"),
            Map.entry("MAX_IMPORT_ROWS", "POSITIVE_INT"),
            Map.entry("IMPORT_EXPIRE_DAYS", "POSITIVE_INT"),
            Map.entry("SEPAY_API_KEY", "STRING"),
            Map.entry("SEPAY_ACCOUNT_NUMBER", "STRING"),
            Map.entry("SEPAY_BANK_CODE", "STRING"),
            Map.entry("SEPAY_ACCOUNT_NAME", "STRING"),
            Map.entry("SEPAY_QR_URL", "STRING"),
            Map.entry("GEMINI_API_KEY", "STRING"),
            Map.entry("GEMINI_RECOMMEN_API_KEY", "STRING"),
            Map.entry("GEMINI_CHATBOT_API_KEY", "STRING")
    );

    public List<SystemConfiguration> getAll(String groupFilter, String actorRole) throws DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("MANAGER".equals(actorRole)) {
                return dao.findByGroup(conn, "library");
            } else { // ADMIN
                if (groupFilter != null && !groupFilter.trim().isEmpty() && !"all".equals(groupFilter)) {
                    return dao.findByGroup(conn, groupFilter);
                } else {
                    return dao.findAll(conn);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi khi lấy danh sách cấu hình", e);
        }
    }

    public void create(SystemConfiguration config, int actorId, String actorRole, ServletContext ctx) throws ValidationException, DatabaseException {
        if (!KEY_TYPES.containsKey(config.getConfigKey())) {
            throw new ValidationException("Khóa cấu hình không tồn tại trong danh sách cho phép (whitelist).");
        }

        validateValue(config.getConfigKey(), config.getConfigValue());

        if ("MANAGER".equals(actorRole) && !"library".equals(config.getConfigGroup())) {
            throw new ValidationException("Bạn chỉ có quyền thêm cấu hình nhóm library.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            SystemConfiguration current = dao.findByKey(conn, config.getConfigKey());
            if (current != null) {
                throw new ValidationException("Khóa cấu hình đã tồn tại trong CSDL.");
            }

            config.setUpdatedBy(actorId);
            dao.insert(conn, config);

            String newJson = buildJson(config.getConfigKey(), config.getConfigValue());
            auditLogDAO.insert(conn, actorId, "CREATE_SYSTEM_CONFIG", "SystemConfigurations", null, null, newJson);

            conn.commit();
            
            SystemConfigCache.reload(ctx);

        } catch (ValidationException e) {
            rollbackQuietly(conn);
            throw e;
        } catch (Exception e) {
            rollbackQuietly(conn);
            throw new DatabaseException("Lỗi hệ thống khi thêm cấu hình", e);
        } finally {
            closeQuietly(conn);
        }
    }

    public void update(String key, String newValue, int actorId, String actorRole, ServletContext ctx) throws ValidationException, DatabaseException {
        if (!KEY_TYPES.containsKey(key)) {
            throw new ValidationException("Khóa cấu hình không tồn tại hoặc không được phép sửa.");
        }

        validateValue(key, newValue);

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            SystemConfiguration current = dao.findByKey(conn, key);
            if (current == null) {
                throw new ValidationException("Khóa cấu hình không tồn tại trong CSDL.");
            }

            if ("MANAGER".equals(actorRole) && !"library".equals(current.getConfigGroup()) && !key.startsWith("SEPAY_")) {
                throw new ValidationException("Bạn không có quyền chỉnh sửa nhóm cấu hình này.");
            }

            String oldJson = buildJson(key, current.getConfigValue());
            String newJson = buildJson(key, newValue);

            dao.update(conn, key, newValue, actorId);
            auditLogDAO.insert(conn, actorId, "UPDATE_SYSTEM_CONFIG", "SystemConfigurations", null, oldJson, newJson);

            conn.commit();
            
            // Reload cache
            SystemConfigCache.reload(ctx);

        } catch (ValidationException e) {
            rollbackQuietly(conn);
            throw e;
        } catch (Exception e) {
            rollbackQuietly(conn);
            throw new DatabaseException("Lỗi hệ thống khi cập nhật cấu hình", e);
        } finally {
            closeQuietly(conn);
        }
    }

    public void delete(String key, int actorId, String actorRole, ServletContext ctx) throws ValidationException, DatabaseException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            SystemConfiguration current = dao.findByKey(conn, key);
            if (current == null) {
                throw new ValidationException("Khóa cấu hình không tồn tại trong CSDL.");
            }

            if ("MANAGER".equals(actorRole) && !"library".equals(current.getConfigGroup())) {
                throw new ValidationException("Bạn không có quyền xóa nhóm cấu hình này.");
            }

            String oldJson = buildJson(key, current.getConfigValue());

            dao.delete(conn, key);
            auditLogDAO.insert(conn, actorId, "DELETE_SYSTEM_CONFIG", "SystemConfigurations", null, oldJson, null);

            conn.commit();
            
            SystemConfigCache.reload(ctx);

        } catch (ValidationException e) {
            rollbackQuietly(conn);
            throw e;
        } catch (Exception e) {
            rollbackQuietly(conn);
            throw new DatabaseException("Lỗi hệ thống khi xóa cấu hình", e);
        } finally {
            closeQuietly(conn);
        }
    }

    public void validateValue(String key, String value) throws ValidationException {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("Giá trị không được để trống.");
        }
        String type = KEY_TYPES.get(key);
        if (type == null) return; // Allow bypass for non-whitelisted keys if any, though update/create will block it.
        try {
            switch (type) {
                case "POSITIVE_INT":
                    int pi = Integer.parseInt(value);
                    if (pi <= 0) throw new ValidationException("Giá trị phải là số nguyên dương.");
                    break;
                case "NON_NEGATIVE_INT":
                    int nni = Integer.parseInt(value);
                    if (nni < 0) throw new ValidationException("Giá trị phải là số nguyên không âm.");
                    break;
                case "NON_NEGATIVE_DECIMAL":
                    double nnd = Double.parseDouble(value);
                    if (nnd < 0.0) throw new ValidationException("Giá trị phải là số thực không âm.");
                    break;
                case "STRING":
                    // anything goes
                    break;
                default:
                    throw new ValidationException("Kiểu dữ liệu cấu hình không hợp lệ.");
            }
        } catch (NumberFormatException e) {
            throw new ValidationException("Định dạng dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
        }
    }

    private String buildJson(String key, String value) {
        if (value == null) {
            return String.format("{\"%s\":null}", key);
        }
        // Escape quotes to produce valid JSON
        String escaped = value.replace("\"", "\\\"");
        return String.format("{\"%s\":\"%s\"}", key, escaped);
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}
