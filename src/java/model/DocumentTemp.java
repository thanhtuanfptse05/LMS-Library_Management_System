package model;

import java.sql.Timestamp;

/**
 * DocumentTemp — Entity bean ánh xạ 1-1 với bảng [DocumentTemp] trong CSDL.
 *
 * <p>Bảng này chứa các Mẫu Email dùng cho thông báo giao dịch cá nhân
 * (Mượn sách, Trả sách, Nộp phạt...). Manager có thể tùy chỉnh nội dung.</p>
 *
 * <p>Schema mapping:</p>
 * <ul>
 *   <li>{@code tempId}      — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code tempName}    — NVARCHAR(100) NOT NULL UNIQUE (VD: 'BORROW_SUCCESS')</li>
 *   <li>{@code subject}     — NVARCHAR(255) NOT NULL (Tiêu đề email)</li>
 *   <li>{@code bodyContent} — NVARCHAR(MAX) NOT NULL (Nội dung có placeholder {{...}})</li>
 *   <li>{@code managerId}   — INT NOT NULL (FK -> LibraryManager.userId)</li>
 *   <li>{@code createdAt}   — DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code updatedAt}   — DATETIME NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation).</p>
 */
public class DocumentTemp {

    private int tempId;
    private String tempName;
    private String subject;
    private String bodyContent;
    private int managerId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public DocumentTemp() {
    }

    public DocumentTemp(int tempId, String tempName, String subject, String bodyContent, int managerId, Timestamp createdAt, Timestamp updatedAt) {
        this.tempId = tempId;
        this.tempName = tempName;
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
