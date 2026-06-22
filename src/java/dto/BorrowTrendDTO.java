package dto;

public class BorrowTrendDTO {
    private String periodLabel; // VD: "2026-06-22", "06/2026", "2026"
    private int totalBorrowed;
    private int totalReturnedOnTime;
    private int totalOverdue;

    public BorrowTrendDTO() {}

    public BorrowTrendDTO(String periodLabel, int totalBorrowed, int totalReturnedOnTime, int totalOverdue) {
        this.periodLabel = periodLabel;
        this.totalBorrowed = totalBorrowed;
        this.totalReturnedOnTime = totalReturnedOnTime;
        this.totalOverdue = totalOverdue;
    }

    public String getPeriodLabel() { return periodLabel; }
    public void setPeriodLabel(String periodLabel) { this.periodLabel = periodLabel; }
    
    public int getTotalBorrowed() { return totalBorrowed; }
    public void setTotalBorrowed(int totalBorrowed) { this.totalBorrowed = totalBorrowed; }

    public int getTotalReturnedOnTime() { return totalReturnedOnTime; }
    public void setTotalReturnedOnTime(int totalReturnedOnTime) { this.totalReturnedOnTime = totalReturnedOnTime; }

    public int getTotalOverdue() { return totalOverdue; }
    public void setTotalOverdue(int totalOverdue) { this.totalOverdue = totalOverdue; }
}
