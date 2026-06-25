package dto;

import java.sql.Timestamp;

/**
 * DTO mở rộng chứa tất cả trường AuditLog + userEmail từ LEFT JOIN "User".
 * Dùng cho hiển thị danh sách nhật ký kiểm toán.
 */
public class AuditLogDTO {

    private int auditLogId;
    private Integer userId;
    private String actionType;
    private String entityName;
    private Integer entityId;
    private String oldValues;
    private String newValues;
    private Timestamp timestamp;
    private String userEmail;

    public AuditLogDTO() {
    }

    public int getAuditLogId() {
        return auditLogId;
    }

    public void setAuditLogId(int auditLogId) {
        this.auditLogId = auditLogId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public Integer getEntityId() {
        return entityId;
    }

    public void setEntityId(Integer entityId) {
        this.entityId = entityId;
    }

    public String getOldValues() {
        return oldValues;
    }

    public void setOldValues(String oldValues) {
        this.oldValues = oldValues;
    }

    public String getNewValues() {
        return newValues;
    }

    public void setNewValues(String newValues) {
        this.newValues = newValues;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
}
