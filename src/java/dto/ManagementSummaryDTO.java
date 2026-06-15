package dto;

public class ManagementSummaryDTO {

    private int totalCount;
    private int activeCount;
    private int hiddenCount;
    private int unusedCount;

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getActiveCount() {
        return activeCount;
    }

    public void setActiveCount(int activeCount) {
        this.activeCount = activeCount;
    }

    public int getHiddenCount() {
        return hiddenCount;
    }

    public void setHiddenCount(int hiddenCount) {
        this.hiddenCount = hiddenCount;
    }

    public int getUnusedCount() {
        return unusedCount;
    }

    public void setUnusedCount(int unusedCount) {
        this.unusedCount = unusedCount;
    }
}
