package model;

import java.sql.Timestamp;

public class BookCopyIncident {

    private int incidentId;
    private int bookCopyId;
    private String barcode;
    private String bookTitle;
    private String incidentType;
    private String description;
    private String status;
    private String resolution;
    private int reportedBy;
    private String reportedByName;
    private Timestamp reportedAt;
    private Integer resolvedBy;
    private String resolvedByName;
    private Timestamp resolvedAt;
    private boolean removedFromInventory;
    private Timestamp removedFromInventoryAt;
    private Integer removedFromInventoryBy;
    private String removedFromInventoryByName;
    private Integer borrowRecordId;

    public int getIncidentId() { return incidentId; }
    public void setIncidentId(int incidentId) { this.incidentId = incidentId; }
    public int getBookCopyId() { return bookCopyId; }
    public void setBookCopyId(int bookCopyId) { this.bookCopyId = bookCopyId; }
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getIncidentType() { return incidentType; }
    public void setIncidentType(String incidentType) { this.incidentType = incidentType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }
    public int getReportedBy() { return reportedBy; }
    public void setReportedBy(int reportedBy) { this.reportedBy = reportedBy; }
    public String getReportedByName() { return reportedByName; }
    public void setReportedByName(String reportedByName) { this.reportedByName = reportedByName; }
    public Timestamp getReportedAt() { return reportedAt; }
    public void setReportedAt(Timestamp reportedAt) { this.reportedAt = reportedAt; }
    public Integer getResolvedBy() { return resolvedBy; }
    public void setResolvedBy(Integer resolvedBy) { this.resolvedBy = resolvedBy; }
    public String getResolvedByName() { return resolvedByName; }
    public void setResolvedByName(String resolvedByName) { this.resolvedByName = resolvedByName; }
    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }
    public boolean isRemovedFromInventory() { return removedFromInventory; }
    public void setRemovedFromInventory(boolean removedFromInventory) { this.removedFromInventory = removedFromInventory; }
    public Timestamp getRemovedFromInventoryAt() { return removedFromInventoryAt; }
    public void setRemovedFromInventoryAt(Timestamp removedFromInventoryAt) { this.removedFromInventoryAt = removedFromInventoryAt; }
    public Integer getRemovedFromInventoryBy() { return removedFromInventoryBy; }
    public void setRemovedFromInventoryBy(Integer removedFromInventoryBy) { this.removedFromInventoryBy = removedFromInventoryBy; }
    public String getRemovedFromInventoryByName() { return removedFromInventoryByName; }
    public void setRemovedFromInventoryByName(String removedFromInventoryByName) { this.removedFromInventoryByName = removedFromInventoryByName; }
    public Integer getBorrowRecordId() { return borrowRecordId; }
    public void setBorrowRecordId(Integer borrowRecordId) { this.borrowRecordId = borrowRecordId; }
}
