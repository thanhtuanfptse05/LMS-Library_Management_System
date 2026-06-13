package model;

import java.sql.Timestamp;

public class BookCopy {
    private int bookCopyId;
    private int bookId;
    private String location;
    private String condition;
    private String status;
    private String barcode;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public BookCopy() {
    }

    public int getBookCopyId() { return bookCopyId; }
    public void setBookCopyId(int bookCopyId) { this.bookCopyId = bookCopyId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
