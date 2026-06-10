package model;

public class BookCopySummary {

    private int totalCopies;
    private int availableCopies;
    private int borrowedCopies;
    private int incidentCopies;

    public int getTotalCopies() { return totalCopies; }
    public void setTotalCopies(int totalCopies) { this.totalCopies = totalCopies; }
    public int getAvailableCopies() { return availableCopies; }
    public void setAvailableCopies(int availableCopies) { this.availableCopies = availableCopies; }
    public int getBorrowedCopies() { return borrowedCopies; }
    public void setBorrowedCopies(int borrowedCopies) { this.borrowedCopies = borrowedCopies; }
    public int getIncidentCopies() { return incidentCopies; }
    public void setIncidentCopies(int incidentCopies) { this.incidentCopies = incidentCopies; }
}
