package dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BookImportRowDTO {

    private String sheetName;
    private int rowNumber;
    private String isbn;
    private String title;
    private String author;
    private String publisher;
    private Integer publicationYear;
    private BigDecimal price;
    private List<String> categories = new ArrayList<>();
    private List<String> tags = new ArrayList<>();
    private String barcode;
    private String location;
    /** Dòng sheet Books có ISBN đã tồn tại trong CSDL nên sẽ được bỏ qua khi import. */
    private boolean existingBook;

    public String getSheetName() { return sheetName; }
    public void setSheetName(String sheetName) { this.sheetName = sheetName; }
    public int getRowNumber() { return rowNumber; }
    public void setRowNumber(int rowNumber) { this.rowNumber = rowNumber; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public Integer getPublicationYear() { return publicationYear; }
    public void setPublicationYear(Integer publicationYear) { this.publicationYear = publicationYear; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public List<String> getCategories() { return categories; }
    public void setCategories(List<String> categories) { this.categories = categories; }
    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public boolean isExistingBook() { return existingBook; }
    public void setExistingBook(boolean existingBook) { this.existingBook = existingBook; }
}
