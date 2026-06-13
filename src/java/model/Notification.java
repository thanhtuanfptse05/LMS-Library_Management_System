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
 *   <li>{@code type}           — NVARCHAR(50) NOT NULL DEFAULT 'general'</li>
 *   <li>{@code isPinned}       — BIT NOT NULL DEFAULT 0</li>
 *   <li>{@code createdBy}      — INT NOT NULL (FK -> User.userId)</li>
 *   <li>{@code createdAt}      — DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code updatedAt}      — DATETIME NULL</li>
 * </ul>
 *
 * <p>Trường mở rộng (không ánh xạ trực tiếp vào DB column):</p>
 * <ul>
 *   <li>{@code createdByName} — Tên người tạo, JOIN từ MemberProfile</li>
 *   <li>{@code isRead}        — Trạng thái đã đọc của người dùng hiện tại (từ UserNotificationStatus)</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation).</p>
 */
public class Notification {

    // ── Các cột trong bảng Notification ──────────────────────────
    private int notificationId;
    private String title;
    private String content;
    /** Loại thông báo: general | urgent | policy | event */
    private String type;
    /** true = ghim lên đầu danh sách */
    private boolean isPinned;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ── Trường mở rộng (UI helper, không lưu trực tiếp vào DB) ──
    /** Tên đầy đủ của người tạo (JOIN từ MemberProfile) */
    private String createdByName;
    /** Trạng thái đã đọc của người dùng đang đăng nhập (từ UserNotificationStatus) */
    private boolean isRead;

    public Notification() {
    }

    public Notification(int notificationId, String title, String content,
                        String type, boolean isPinned, int createdBy, Timestamp createdAt) {
        this.notificationId = notificationId;
        this.title = title;
        this.content = content;
        this.type = type;
        this.isPinned = isPinned;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isPinned() {
        return isPinned;
    }

    public void setPinned(boolean isPinned) {
        this.isPinned = isPinned;
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

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
}
