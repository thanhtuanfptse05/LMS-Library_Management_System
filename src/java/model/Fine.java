package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Fine — Thực thể đại diện cho bảng [Fine].
 */
public class Fine {
    private int fineId;
    private int borrowRecordId;
    private int userId;
    private BigDecimal amount;
    private String reason;
    private String status;
    private Timestamp createdAt;

    // Các trường bổ sung (JOIN từ bảng Payment) để phục vụ Dashboard
    private Integer paymentId;
    private String paymentStatus;

    // Trường bổ sung (JOIN từ BorrowRecord + Book) để hiển thị tên sách trên giao diện phạt
    private String bookTitle;

    private String memberName;
    private String memberCode;

    // Getters and Setters
    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public String getMemberCode() {
        return memberCode;
    }

    public void setMemberCode(String memberCode) {
        this.memberCode = memberCode;
    }

    public int getFineId() {
        return fineId;
    }

    public void setFineId(int fineId) {
        this.fineId = fineId;
    }

    public int getBorrowRecordId() {
        return borrowRecordId;
    }

    public void setBorrowRecordId(int borrowRecordId) {
        this.borrowRecordId = borrowRecordId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }
}
