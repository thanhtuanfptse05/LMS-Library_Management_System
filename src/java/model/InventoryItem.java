package model;

import java.sql.Timestamp;

public class InventoryItem {
    private int inventoryItemId;
    private int inventorySessionId;
    private int bookCopyId;
    private String barcode;
    private String bookTitle;
    private String expectedLocation;
    private String scannedLocation;
    private String result;
    private String anomalyType;
    private Integer scannedBy;
    private Timestamp scannedAt;
    private String resolution;
    private Integer resolvedBy;
    private Timestamp resolvedAt;

    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int value) { inventoryItemId = value; }
    public int getInventorySessionId() { return inventorySessionId; }
    public void setInventorySessionId(int value) { inventorySessionId = value; }
    public int getBookCopyId() { return bookCopyId; }
    public void setBookCopyId(int value) { bookCopyId = value; }
    public String getBarcode() { return barcode; }
    public void setBarcode(String value) { barcode = value; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String value) { bookTitle = value; }
    public String getExpectedLocation() { return expectedLocation; }
    public void setExpectedLocation(String value) { expectedLocation = value; }
    public String getScannedLocation() { return scannedLocation; }
    public void setScannedLocation(String value) { scannedLocation = value; }
    public String getResult() { return result; }
    public void setResult(String value) { result = value; }
    public String getAnomalyType() { return anomalyType; }
    public void setAnomalyType(String value) { anomalyType = value; }
    public Integer getScannedBy() { return scannedBy; }
    public void setScannedBy(Integer value) { scannedBy = value; }
    public Timestamp getScannedAt() { return scannedAt; }
    public void setScannedAt(Timestamp value) { scannedAt = value; }
    public String getResolution() { return resolution; }
    public void setResolution(String value) { resolution = value; }
    public Integer getResolvedBy() { return resolvedBy; }
    public void setResolvedBy(Integer value) { resolvedBy = value; }
    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp value) { resolvedAt = value; }
}
