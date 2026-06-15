package dto;

public class BookCopyIncidentSummaryDTO {

    private int pendingCount;
    private int investigatingCount;
    private int resolvedThisMonthCount;

    public int getPendingCount() { return pendingCount; }
    public void setPendingCount(int pendingCount) { this.pendingCount = pendingCount; }
    public int getInvestigatingCount() { return investigatingCount; }
    public void setInvestigatingCount(int investigatingCount) { this.investigatingCount = investigatingCount; }
    public int getResolvedThisMonthCount() { return resolvedThisMonthCount; }
    public void setResolvedThisMonthCount(int resolvedThisMonthCount) {
        this.resolvedThisMonthCount = resolvedThisMonthCount;
    }
}
