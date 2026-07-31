package model;

import java.sql.Timestamp;

/**
 * EmailTemplate — Entity bean ánh xạ 1-1 với bảng [EmailTemplate] trong CSDL.
 *
 * <p>Bảng này lưu trữ 6 Mẫu Email Hệ Thống dùng cho tiến trình ngầm
 * Async Email Sender gửi thông báo tự động bị động (Passive Notification):
 * Khôi phục mật khẩu, Sách đặt trước sẵn sàng, Gia hạn thành công,
 * Cảnh báo quá hạn, Phạt sự cố, Xác nhận thanh toán.</p>
 *
 * <p>Quy tắc vận hành:</p>
 * <ul>
 *   <li>Mẫu được tạo bởi seed SQL khi deploy — không có createdAt.</li>
 *   <li>Admin được phép chỉnh sửa {@code subject} và {@code bodyContent}.</li>
 *   <li>Admin KHÔNG ĐƯỢC PHÉP tạo hoặc xóa mẫu (DAO không có insert/delete).</li>
 *   <li>Nội dung hỗ trợ placeholder dạng {{key}} để inject dữ liệu động.</li>
 * </ul>
 *
 * <p>Schema mapping:</p>
 * <ul>
 *   <li>{@code templateId} — INT IDENTITY PRIMARY KEY</li>
 *   <li>{@code tempName}   — VARCHAR(100) NOT NULL UNIQUE (VD: 'OVERDUE_NOTICE')</li>
 *   <li>{@code description}— VARCHAR(500) NULL (Mô tả mục đích mẫu)</li>
 *   <li>{@code subject}    — VARCHAR(255) NOT NULL (Tiêu đề email)</li>
 *   <li>{@code bodyContent}— TEXT NOT NULL (Nội dung HTML có placeholder {{...}})</li>
 *   <li>{@code updatedBy}  — INT NULL (FK → "User".userId — ai cập nhật gần nhất)</li>
 *   <li>{@code updatedAt}  — TIMESTAMP NULL (thời điểm cập nhật gần nhất)</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation).</p>
 */
public class EmailTemplate {

    private int templateId;
    private String tempName;
    private String description;
    private String subject;
    private String bodyContent;
    private Integer updatedBy;
    private Timestamp updatedAt;

    public EmailTemplate() {
    }

    public EmailTemplate(int templateId, String tempName, String description,
                         String subject, String bodyContent,
                         Integer updatedBy, Timestamp updatedAt) {
        this.templateId = templateId;
        this.tempName = tempName;
        this.description = description;
        this.subject = subject;
        this.bodyContent = bodyContent;
        this.updatedBy = updatedBy;
        this.updatedAt = updatedAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getTempName() {
        return tempName;
    }

    public void setTempName(String tempName) {
        this.tempName = tempName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getBodyContent() {
        return bodyContent;
    }

    public void setBodyContent(String bodyContent) {
        this.bodyContent = bodyContent;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
