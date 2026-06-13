package model;

import java.sql.Timestamp;

/**
 * Notification ΓÇö Entity bean ├ính xß║í 1-1 vß╗¢i bß║úng [Notification] trong CSDL.
 *
 * <p>Schema mapping:</p>
 * <ul>
 *   <li>{@code notificationId} ΓÇö INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code title}          ΓÇö NVARCHAR(500) NOT NULL</li>
 *   <li>{@code content}        ΓÇö NVARCHAR(MAX) NULL</li>
 *   <li>{@code type}           ΓÇö NVARCHAR(50) NOT NULL DEFAULT 'general'</li>
 *   <li>{@code isPinned}       ΓÇö BIT NOT NULL DEFAULT 0</li>
 *   <li>{@code createdBy}      ΓÇö INT NOT NULL (FK -> User.userId)</li>
 *   <li>{@code createdAt}      ΓÇö DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code updatedAt}      ΓÇö DATETIME NULL</li>
 * </ul>
 *
 * <p>Tr╞░ß╗¥ng mß╗ƒ rß╗Öng (kh├┤ng ├ính xß║í trß╗▒c tiß║┐p v├áo DB column):</p>
 * <ul>
 *   <li>{@code createdByName} ΓÇö T├¬n ng╞░ß╗¥i tß║ío, JOIN tß╗½ MemberProfile</li>
 *   <li>{@code isRead}        ΓÇö Trß║íng th├íi ─æ├ú ─æß╗ìc cß╗ºa ng╞░ß╗¥i d├╣ng hiß╗çn tß║íi (tß╗½ UserNotificationStatus)</li>
 * </ul>
 *
 * <p>Tu├ón thß╗º: ARCH-01 (Java Bean thuß║ºn, kh├┤ng ORM annotation).</p>
 */
public class Notification {

    // ΓöÇΓöÇ C├íc cß╗Öt trong bß║úng Notification ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    private int notificationId;
    private String title;
    private String content;
    /** Loß║íi th├┤ng b├ío: general | urgent | policy | event */
    private String type;
    /** true = ghim l├¬n ─æß║ºu danh s├ích */
    private boolean isPinned;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ΓöÇΓöÇ Tr╞░ß╗¥ng mß╗ƒ rß╗Öng (UI helper, kh├┤ng l╞░u trß╗▒c tiß║┐p v├áo DB) ΓöÇΓöÇ
    /** T├¬n ─æß║ºy ─æß╗º cß╗ºa ng╞░ß╗¥i tß║ío (JOIN tß╗½ MemberProfile) */
    private String createdByName;
    /** Trß║íng th├íi ─æ├ú ─æß╗ìc cß╗ºa ng╞░ß╗¥i d├╣ng ─æang ─æ─âng nhß║¡p (tß╗½ UserNotificationStatus) */
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
