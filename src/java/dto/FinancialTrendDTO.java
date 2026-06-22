package dto;

public class FinancialTrendDTO {
    private String periodLabel; // VD: "2026-06-22", "06/2026", "2026"
    private double totalPaid;
    private double totalUnpaid;

    public FinancialTrendDTO() {}

    public FinancialTrendDTO(String periodLabel, double totalPaid, double totalUnpaid) {
        this.periodLabel = periodLabel;
        this.totalPaid = totalPaid;
        this.totalUnpaid = totalUnpaid;
    }

    public String getPeriodLabel() { return periodLabel; }
    public void setPeriodLabel(String periodLabel) { this.periodLabel = periodLabel; }

    public double getTotalPaid() { return totalPaid; }
    public void setTotalPaid(double totalPaid) { this.totalPaid = totalPaid; }

    public double getTotalUnpaid() { return totalUnpaid; }
    public void setTotalUnpaid(double totalUnpaid) { this.totalUnpaid = totalUnpaid; }
}
