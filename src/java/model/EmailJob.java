package model;

import java.util.Map;

/**
 * EmailJob — DTO lưu trữ thông tin của một yêu cầu gửi email trong hàng đợi.
 *
 * <p>DTO này hỗ trợ cả hai luồng:</p>
 * <ul>
 *   <li><strong>Passive Flow (Gửi hệ thống tự động):</strong> Sử dụng {@code tempName} để tra cứu template
 *   trong bảng {@code EmailTemplate} và tiến hành ráp các thẻ {@code placeholders}.</li>
 *   <li><strong>Active Flow (Gửi thông báo khẩn từ quản lý):</strong> {@code tempName} bằng null,
 *   nội dung tiêu đề và HTML body được truyền trực tiếp qua {@code directSubject} và {@code directBody}
 *   để bypass bước tra cứu template.</li>
 * </ul>
 */
public class EmailJob {
    private final String tempName;                  // null nếu gửi trực tiếp body HTML (Active flow)
    private final String recipientEmail;
    private final String recipientName;             // Tên người nhận (ví dụ để thay thế {{userName}})
    private final Map<String, String> placeholders; // Dữ liệu thay thế động (Passive flow)
    private final String directSubject;             // Tiêu đề trực tiếp (Active flow)
    private final String directBody;                // Nội dung HTML trực tiếp (Active flow)
    private int attemptCount;                       // Đếm số lần gửi (phục vụ retry)

    /**
     * Constructor phục vụ cho luồng gửi email tự động (Passive Notification).
     *
     * @param tempName       Tên định danh mẫu email (VD: 'OVERDUE_NOTICE')
     * @param recipientEmail Địa chỉ email người nhận
     * @param recipientName  Tên người nhận
     * @param placeholders   Bản đồ các tham số thay thế động
     */
    public EmailJob(String tempName, String recipientEmail, String recipientName, Map<String, String> placeholders) {
        this.tempName = tempName;
        this.recipientEmail = recipientEmail;
        this.recipientName = recipientName;
        this.placeholders = placeholders;
        this.directSubject = null;
        this.directBody = null;
        this.attemptCount = 0;
    }

    /**
     * Constructor phục vụ cho luồng gửi trực tiếp nội dung HTML (Active Notification).
     *
     * @param recipientEmail Địa chỉ email người nhận
     * @param subject       Tiêu đề email đã render
     * @param body          Nội dung HTML đã render hoàn chỉnh
     */
    public EmailJob(String recipientEmail, String subject, String body) {
        this.tempName = null;
        this.recipientEmail = recipientEmail;
        this.recipientName = "";
        this.placeholders = null;
        this.directSubject = subject;
        this.directBody = body;
        this.attemptCount = 0;
    }

    // =========================================================================
    // GETTERS & SETTERS
    // =========================================================================

    public String getTempName() {
        return tempName;
    }

    public String getRecipientEmail() {
        return recipientEmail;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public Map<String, String> getPlaceholders() {
        return placeholders;
    }

    public String getDirectSubject() {
        return directSubject;
    }

    public String getDirectBody() {
        return directBody;
    }

    public int getAttemptCount() {
        return attemptCount;
    }

    /**
     * Tăng số lần thử gửi lên 1 đơn vị.
     */
    public void incrementAttempt() {
        this.attemptCount++;
    }
}
