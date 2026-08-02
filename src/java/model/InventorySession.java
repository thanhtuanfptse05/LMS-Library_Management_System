package model;

import java.sql.Timestamp;

public class InventorySession {
    private int inventorySessionId;
    private String location;
    private String status;
    private int createdBy;
    private String createdByName;
    private Timestamp createdAt;
    private Integer startedBy;
    private String startedByName;
    private Timestamp startedAt;
    private Integer completedBy;
    private Timestamp completedAt;
    private Integer cancelledBy;
    private Timestamp cancelledAt;
    private String note;
    private int expectedCount;
    private int matchedCount;
    private int discrepancyCount;
    private int unresolvedCount;

    public int getInventorySessionId() { return inventorySessionId; }
    public void setInventorySessionId(int value) { inventorySessionId = value; }
    public String getLocation() { return location; }
    public void setLocation(String value) { location = value; }
    public String getStatus() { return status; }
    public void setStatus(String value) { status = value; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int value) { createdBy = value; }
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String value) { createdByName = value; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp value) { createdAt = value; }
    public Integer getStartedBy() { return startedBy; }
    public void setStartedBy(Integer value) { startedBy = value; }
    public String getStartedByName() { return startedByName; }
    public void setStartedByName(String value) { startedByName = value; }
    public Timestamp getStartedAt() { return startedAt; }
    public void setStartedAt(Timestamp value) { startedAt = value; }
    public Integer getCompletedBy() { return completedBy; }
    public void setCompletedBy(Integer value) { completedBy = value; }
    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp value) { completedAt = value; }
    public Integer getCancelledBy() { return cancelledBy; }
    public void setCancelledBy(Integer value) { cancelledBy = value; }
    public Timestamp getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(Timestamp value) { cancelledAt = value; }
    public String getNote() { return note; }
    public void setNote(String value) { note = value; }
    public int getExpectedCount() { return expectedCount; }
    public void setExpectedCount(int value) { expectedCount = value; }
    public int getMatchedCount() { return matchedCount; }
    public void setMatchedCount(int value) { matchedCount = value; }
    public int getDiscrepancyCount() { return discrepancyCount; }
    public void setDiscrepancyCount(int value) { discrepancyCount = value; }
    public int getUnresolvedCount() { return unresolvedCount; }
    public void setUnresolvedCount(int value) { unresolvedCount = value; }
}
