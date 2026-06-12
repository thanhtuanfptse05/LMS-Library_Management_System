package dto;

public class InventorySummaryDTO {
    private int totalSessions;
    private int activeSessions;
    private int reviewingSessions;
    private int unresolvedItems;

    public int getTotalSessions() { return totalSessions; }
    public void setTotalSessions(int value) { totalSessions = value; }
    public int getActiveSessions() { return activeSessions; }
    public void setActiveSessions(int value) { activeSessions = value; }
    public int getReviewingSessions() { return reviewingSessions; }
    public void setReviewingSessions(int value) { reviewingSessions = value; }
    public int getUnresolvedItems() { return unresolvedItems; }
    public void setUnresolvedItems(int value) { unresolvedItems = value; }
}
