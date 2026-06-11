package model;

import java.sql.Timestamp;

/**
 * Notification — Entity bean ánh xạ 1-1 với bảng [Notification] trong CSDL.
 *
 * <p>Schema mapping:</p>
 * <ul>
 *   <li>{@code notificationId} — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code title}          — NVARCHAR(500) NOT NULL</li>
 *   <li>{@code content}        — NVARCHAR(MAX) NULL</li>
 *   <li>{@code createdBy}      — INT NOT NULL (FK -> User.userId)</li>
 *   <li>{@code createdAt}      — DATETIME NOT NULL DEFAULT GETDATE()</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation).</p>
 */
public class Notification {

    private int notificationId;
    private String title;
    private String content;
    private int createdBy;
    private Timestamp createdAt;

    // Trường mở rộng để hiển thị tên người tạo trên UI (JOIN từ MemberProfile)
    private String createdByName;

    public Notification() {
    }

    public Notification(int notificationId, String title, String content, int createdBy, Timestamp createdAt) {
        this.notificationId = notificationId;
        this.title = title;
        this.content = content;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}
