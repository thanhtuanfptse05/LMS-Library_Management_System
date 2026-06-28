package dto;

public class BookLocationSummaryDTO {
    private String location;
    private int totalCopies;
    private int availableCopies;
    private int issueCopies;

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getTotalCopies() {
        return totalCopies;
    }

    public void setTotalCopies(int totalCopies) {
        this.totalCopies = totalCopies;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }

    public int getIssueCopies() {
        return issueCopies;
    }

    public void setIssueCopies(int issueCopies) {
        this.issueCopies = issueCopies;
    }
}
