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
            Map.entry("GEMINI_CHATBOT_API_KEY", "STRING")
    );

    /** Danh sách nhóm Manager được phép xem và sửa */
    private static final java.util.Set<String> MANAGER_GROUPS = java.util.Set.of("library", "fine");

    public List<SystemConfiguration> getAll(String groupFilter, String actorRole) throws DatabaseException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("MANAGER".equals(actorRole)) {
                // Manager được xem nhóm library (chính sách mượn) và fine (tiền phạt)
                List<SystemConfiguration> result = new java.util.ArrayList<>();
                result.addAll(dao.findByGroup(conn, "library"));
                result.addAll(dao.findByGroup(conn, "fine"));
                return result;
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

            // Manager chỉ được sửa các nhóm thuộc MANAGER_GROUPS
            if ("MANAGER".equals(actorRole) && !MANAGER_GROUPS.contains(current.getConfigGroup())) {
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

    /**
     * Tạo mới một cấu hình. Chỉ Admin mới được gọi.
     */
    public void create(String key, String value, String group, String description,
                       int actorId, ServletContext ctx) throws ValidationException, DatabaseException {
        // Validate key format: chỉ chấp nhận chữ hoa, số, gạch dưới
        if (key == null || !key.matches("[A-Z0-9_]+")) {
            throw new ValidationException("Mã cấu hình chỉ được chứa chữ in hoa, số và gạch dưới (ví dụ: MY_CONFIG_KEY).");
        }
        if (key.length() > 100) {
            throw new ValidationException("Mã cấu hình không được vượt quá 100 ký tự.");
        }
        if (group == null || group.trim().isEmpty()) {
            throw new ValidationException("Nhóm cấu hình không được để trống.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            if (dao.exists(conn, key)) {
                throw new ValidationException("Mã cấu hình '" + key + "' đã tồn tại trong hệ thống.");
            }

            dao.insert(conn, key, value, group.trim(), description, actorId);
            auditLogDAO.insert(conn, actorId, "CREATE_SYSTEM_CONFIG", "SystemConfigurations", null,
                    null, buildJson(key, value));

            conn.commit();
            SystemConfigCache.reload(ctx);

        } catch (ValidationException e) {
            rollbackQuietly(conn);
            throw e;
        } catch (Exception e) {
            rollbackQuietly(conn);
            throw new DatabaseException("Lỗi hệ thống khi tạo cấu hình mới", e);
        } finally {
            closeQuietly(conn);
        }
    }

    /**
     * Xóa cấu hình. Chỉ Admin được gọi. Cấu hình cứng (có trong KEY_TYPES) không được xóa.
     */
    public void delete(String key, int actorId, ServletContext ctx) throws ValidationException, DatabaseException {
        if (KEY_TYPES.containsKey(key)) {
            throw new ValidationException("Cấu hình '" + key + "' là cấu hình hệ thống cố định, không được phép xóa.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            SystemConfiguration current = dao.findByKey(conn, key);
            if (current == null) {
                throw new ValidationException("Không tìm thấy cấu hình cần xóa.");
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

    /**
     * Kiểm tra một key có phải config cứng không (không được xóa).
     * Dùng ở JSP để ẩn/hiện nút Xóa.
     */
    public boolean isHardConfig(String key) {
        return KEY_TYPES.containsKey(key);
    }

    public void validateValue(String key, String value) throws ValidationException {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("Giá trị không được để trống.");
        }
        String type = KEY_TYPES.get(key);
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
