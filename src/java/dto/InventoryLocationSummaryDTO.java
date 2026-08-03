package dto;

public class InventoryLocationSummaryDTO {
    private int managedCopies;
    private int borrowedCopies;
    private int issueCopies;
    private int expectedOnShelfCopies;

    public int getManagedCopies() { return managedCopies; }
    public void setManagedCopies(int value) { managedCopies = value; }
    public int getBorrowedCopies() { return borrowedCopies; }
    public void setBorrowedCopies(int value) { borrowedCopies = value; }
    public int getIssueCopies() { return issueCopies; }
    public void setIssueCopies(int value) { issueCopies = value; }
    public int getExpectedOnShelfCopies() { return expectedOnShelfCopies; }
    public void setExpectedOnShelfCopies(int value) { expectedOnShelfCopies = value; }
}
