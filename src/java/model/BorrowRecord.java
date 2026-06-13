package model;

import java.sql.Timestamp;

public class BorrowRecord {
    private int borrowRecordId;
    private int userId;
    private int bookCopyId;
    private int bookId;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp returnedAt;
    private String status;
    private int extensionCount;
    private Integer createdBy;
    private Timestamp createdAt;

    public BorrowRecord() {
    }

    public int getBorrowRecordId() { return borrowRecordId; }
    public void setBorrowRecordId(int borrowRecordId) { this.borrowRecordId = borrowRecordId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookCopyId() { return bookCopyId; }
    public void setBookCopyId(int bookCopyId) { this.bookCopyId = bookCopyId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public Timestamp getReturnedAt() { return returnedAt; }
    public void setReturnedAt(Timestamp returnedAt) { this.returnedAt = returnedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getExtensionCount() { return extensionCount; }
    public void setExtensionCount(int extensionCount) { this.extensionCount = extensionCount; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
