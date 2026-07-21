package dto;

import java.sql.Timestamp;

import java.util.Map;
import java.util.List;
import java.util.ArrayList;

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

    public String getFriendlyOldValues() {
        return formatJsonToFriendly(this.oldValues);
    }

    public String getFriendlyNewValues() {
        return formatJsonToFriendly(this.newValues);
    }

    private String formatJsonToFriendly(String jsonStr) {
        if (jsonStr == null || jsonStr.trim().isEmpty()) {
            return "";
        }
        String trimmed = jsonStr.trim();
        if (!trimmed.startsWith("{") || !trimmed.endsWith("}")) {
            return jsonStr;
        }
        try {
            String content = trimmed.substring(1, trimmed.length() - 1).trim();
            if (content.isEmpty()) {
                return "";
            }
            List<String> entries = new ArrayList<>();
            // Regex cơ bản bắt "key":"value" hoặc "key":value
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\"([^\"]+)\"\\s*:\\s*(?:\"([^\"]*)\"|([^,}]+))");
            java.util.regex.Matcher matcher = pattern.matcher(content);
            while (matcher.find()) {
                String key = matcher.group(1);
                String val = matcher.group(2) != null ? matcher.group(2) : matcher.group(3);
                if (val != null) {
                    val = val.trim();
                }
                
                String friendlyKey = translateKey(key);
                String valStr;
                
                if (val == null || val.equals("null")) {
                    valStr = "—";
                } else {
                    // Loại bỏ phần thập phân .0 nếu là số
                    if (val.matches("\\d+\\.0")) {
                        val = val.substring(0, val.length() - 2);
                    }
                    valStr = translateValue(val);
                }
                
                entries.add(friendlyKey + ": " + valStr);
            }
            return String.join(", ", entries);
        } catch (Exception e) {
            return jsonStr;
        }
    }

    private String translateKey(String key) {
        if (key == null) return "";
        switch (key) {
            case "email": return "Email";
            case "role": return "Vai trò";
            case "code": return "Mã số";
            case "status": return "Trạng thái";
            case "fullName": return "Họ tên";
            case "phoneNumber": return "Số điện thoại";
            case "gender": return "Giới tính";
            case "dateOfBirth": return "Ngày sinh";
            case "major": return "Ngành học";
            case "enrollmentYear": return "Khóa học";
            case "department": return "Khoa/Phòng ban";
            case "configKey": return "Khóa cấu hình";
            case "configValue": return "Giá trị cấu hình";
            case "description": return "Mô tả";
            case "LOST_FINE_MULTIPLIER": return "Hệ số phạt mất sách";
            case "STUDENT_MAX_BORROW_DAYS": return "Hạn mượn tối đa Sinh viên";
            case "LECTURER_MAX_BORROW_DAYS": return "Hạn mượn tối đa Giảng viên";
            case "FINE_RATE_PER_DAY": return "Mức phạt quá hạn/ngày";
            case "RESERVATION_HOLD_DAYS": return "Hạn giữ đặt trước";
            case "MAX_EXTENSION_COUNT": return "Số lần gia hạn tối đa";
            default: return key;
        }
    }

    private String translateValue(String val) {
        if (val == null) return "—";
        switch (val) {
            case "active": return "Hoạt động";
            case "locked": return "Đã khóa";
            case "ADMIN": return "SysAdmin";
            case "STUDENT": return "Sinh viên";
            case "LECTURER": return "Giảng viên";
            case "LIBRARIAN": return "Thủ thư";
            case "MANAGER": return "Quản lý";
            case "male": case "Nam": return "Nam";
            case "female": case "Nữ": return "Nữ";
            default: return val;
        }
    }
}
