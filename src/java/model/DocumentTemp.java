package model;

import java.sql.Timestamp;

/**
 * DocumentTemp — Entity bean ánh xạ 1-1 với bảng [DocumentTemp] trong CSDL.
 *
 * <p>Bảng này hoạt động như một bảng cấu hình hệ thống (System Config Table).
 * Chứa 6 mẫu Email hệ thống dùng cho thông báo giao dịch bị động (Passive Notification):
 * Khôi phục mật khẩu, Sách đặt trước sẵn sàng, Gia hạn thành công,
 * Cảnh báo quá hạn, Phạt sự cố, Xác nhận thanh toán.</p>
 *
 * <p>Quy tắc vận hành:</p>
 * <ul>
 *   <li>Admin được phép chỉnh sửa {@code subject} và {@code bodyContent}.</li>
 *   <li>Admin KHÔNG ĐƯỢC PHÉP xóa các mẫu có tempName là hệ thống.</li>
 *   <li>Nội dung hỗ trợ placeholder dạng {{key}} để inject dữ liệu động.</li>
 * </ul>
 *
 * <p>Schema mapping:</p>
 * <ul>
 *   <li>{@code tempId}      — INT IDENTITY PRIMARY KEY</li>
 *   <li>{@code tempName}    — VARCHAR(100) NOT NULL UNIQUE (VD: 'OVERDUE_NOTICE')</li>
 *   <li>{@code description} — VARCHAR(500) NULL (Mô tả mục đích mẫu)</li>
 *   <li>{@code subject}     — VARCHAR(255) NOT NULL (Tiêu đề email)</li>
 *   <li>{@code bodyContent} — TEXT NOT NULL (Nội dung HTML có placeholder {{...}})</li>
 *   <li>{@code managerId}   — INT NOT NULL (FK -> "User".userId)</li>
 *   <li>{@code createdAt}   — TIMESTAMP NOT NULL DEFAULT NOW()</li>
 *   <li>{@code updatedAt}   — TIMESTAMP NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation).</p>
 */
public class DocumentTemp {

    private int tempId;
    private String tempName;
    private String description;
    private String subject;
    private String bodyContent;
    private int managerId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public DocumentTemp() {
    }

    public DocumentTemp(int tempId, String tempName, String description,
                        String subject, String bodyContent,
                        int managerId, Timestamp createdAt, Timestamp updatedAt) {
        this.tempId = tempId;
        this.tempName = tempName;
        this.description = description;
        this.subject = subject;
        this.bodyContent = bodyContent;
        this.managerId = managerId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getTempId() {
        return tempId;
    }

    public void setTempId(int tempId) {
        this.tempId = tempId;
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

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
