package service;

import dao.AuditLogDAO;
import dao.DocumentTempDAO;
import dao.NotificationDAO;
import exception.ValidationException;
import model.DocumentTemp;
import model.Notification;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * NotificationService — Lớp Service xử lý logic nghiệp vụ Quản lý Thông báo và Mẫu email (FR-44, FR-52).
 */
public class NotificationService {

    private final NotificationDAO notificationDAO;
    private final DocumentTempDAO documentTempDAO;
    private final AuditLogDAO auditLogDAO;

    public NotificationService() {
        this(new NotificationDAO(), new DocumentTempDAO(), new AuditLogDAO());
    }

    public NotificationService(NotificationDAO notificationDAO, DocumentTempDAO documentTempDAO, AuditLogDAO auditLogDAO) {
        this.notificationDAO = notificationDAO;
        this.documentTempDAO = documentTempDAO;
        this.auditLogDAO = auditLogDAO;
    }

    /**
     * Validate thông tin thông báo trước khi tạo hoặc cập nhật (FR-44).
     */
    public void validateNotification(String title, String content, String type) throws ValidationException {
        if (title == null || title.trim().isEmpty()) {
            throw new ValidationException("Tiêu đề thông báo không được để trống.");
        }
        if (title.trim().length() > 255) {
            throw new ValidationException("Tiêu đề thông báo không được vượt quá 255 ký tự.");
        }
        if (content != null && content.length() > 10000) {
            throw new ValidationException("Nội dung thông báo không được vượt quá 10,000 ký tự.");
        }
        if (type == null || type.trim().isEmpty()) {
            throw new ValidationException("Loại thông báo không được để trống.");
        }

        Set<String> validTypes = Set.of("general", "urgent", "policy", "event", "news", "announcement", "maintenance");
        if (!validTypes.contains(type.trim().toLowerCase())) {
            throw new ValidationException("Loại thông báo không hợp lệ: " + type);
        }
    }

    /**
     * Validate mẫu văn bản email và kiểm tra các placeholders bắt buộc (FR-52).
     */
    public void validateDocumentTemplate(String tempName, String subject, String bodyContent) throws ValidationException {
        if (subject == null || subject.trim().isEmpty()) {
            throw new ValidationException("Tiêu đề mẫu email không được để trống.");
        }
        if (subject.trim().length() > 255) {
            throw new ValidationException("Tiêu đề mẫu email không được vượt quá 255 ký tự.");
        }
        if (bodyContent == null || bodyContent.trim().isEmpty()) {
            throw new ValidationException("Nội dung mẫu email không được để trống.");
        }
        if (bodyContent.length() > 50000) {
            throw new ValidationException("Nội dung mẫu email không được vượt quá 50,000 ký tự.");
        }

        if (tempName != null) {
            List<String> missingPlaceholders = checkRequiredPlaceholders(tempName, bodyContent);
            if (!missingPlaceholders.isEmpty()) {
                throw new ValidationException("Template thiếu biến bắt buộc: " + String.join(", ", missingPlaceholders));
            }
        }
    }

    /**
     * Kiểm tra danh sách các placeholders bắt buộc theo loại mẫu email (FR-52).
     */
    public List<String> checkRequiredPlaceholders(String tempName, String bodyContent) {
        List<String> missing = new ArrayList<>();
        if (bodyContent == null) return missing;

        switch (tempName.toUpperCase()) {
            case "RESET_PASSWORD":
                if (!bodyContent.contains("{{tempPassword}}") && !bodyContent.contains("{{code}}")) missing.add("{{tempPassword}}");
                if (!bodyContent.contains("{{userName}}") && !bodyContent.contains("{{studentName}}")) missing.add("{{userName}}");
                break;
            case "OVERDUE_NOTICE":
                if (!bodyContent.contains("{{bookTitle}}")) missing.add("{{bookTitle}}");
                if (!bodyContent.contains("{{dueDate}}") && !bodyContent.contains("{{overdueDays}}")) missing.add("{{dueDate}}");
                break;
            case "RESERVATION_READY":
                if (!bodyContent.contains("{{bookTitle}}")) missing.add("{{bookTitle}}");
                break;
            default:
                break;
        }
        return missing;
    }
}
