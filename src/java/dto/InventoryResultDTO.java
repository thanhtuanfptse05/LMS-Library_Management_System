package dto;

import java.sql.Timestamp;

public class InventoryResultDTO {
    private int sessionId;
    private String location;
    private Timestamp completedAt;
    private int totalMatched;
    private int totalMissing;
    private int totalMisplaced;

    public InventoryResultDTO() {}

    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }

    public int getTotalMatched() { return totalMatched; }
    public void setTotalMatched(int totalMatched) { this.totalMatched = totalMatched; }

    public int getTotalMissing() { return totalMissing; }
    public void setTotalMissing(int totalMissing) { this.totalMissing = totalMissing; }

    public int getTotalMisplaced() { return totalMisplaced; }
    public void setTotalMisplaced(int totalMisplaced) { this.totalMisplaced = totalMisplaced; }
}
