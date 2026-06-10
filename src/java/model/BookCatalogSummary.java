package model;

public class BookCatalogSummary {

    private int totalBooks;
    private int totalCopies;
    private int availableCopies;
    private int booksWithoutCopies;

    public int getTotalBooks() { return totalBooks; }
    public void setTotalBooks(int totalBooks) { this.totalBooks = totalBooks; }
    public int getTotalCopies() { return totalCopies; }
    public void setTotalCopies(int totalCopies) { this.totalCopies = totalCopies; }
    public int getAvailableCopies() { return availableCopies; }
    public void setAvailableCopies(int availableCopies) { this.availableCopies = availableCopies; }
    public int getBooksWithoutCopies() { return booksWithoutCopies; }
    public void setBooksWithoutCopies(int booksWithoutCopies) { this.booksWithoutCopies = booksWithoutCopies; }
}
