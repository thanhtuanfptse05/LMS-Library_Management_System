package model;

import java.io.Serializable;

/**
 * ChatMessage — Thực thể đại diện cho một tin nhắn trong hội thoại Chatbot.
 * Hỗ trợ lưu trữ trong HttpSession để quản lý lịch sử trò chuyện.
 */
public class ChatMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    private String role; // 'user' hoặc 'model'
    private String content; // Nội dung văn bản tin nhắn
    private long timestamp; // Thời gian tin nhắn được gửi (milliseconds)

    public ChatMessage() {
        this.timestamp = System.currentTimeMillis();
    }

    public ChatMessage(String role, String content) {
        this.role = role;
        this.content = content;
        this.timestamp = System.currentTimeMillis();
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "ChatMessage{" +
                "role='" + role + '\'' +
                ", content='" + content + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }
}
