package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Book {

    private int bookId;
    private String isbn;
    private String title;
    private String author;
    private String publisher;
    private Integer publicationYear;
    private BigDecimal price;
    private String imagePath;
    private int totalQuantity;
    private int availableQuantity;
    private int activeReservationCount;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<Category> categories = new ArrayList<>();
    private List<Tag> tags = new ArrayList<>();

    public Book() {
    }

    public boolean hasCategory(int categoryId) {
        return categories.stream().anyMatch(category -> category.getCategoryId() == categoryId);
    }

    public boolean hasTag(int tagId) {
        return tags.stream().anyMatch(tag -> tag.getTagId() == tagId);
    }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
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
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }
    public int getAvailableQuantity() { return availableQuantity; }
    public void setAvailableQuantity(int availableQuantity) { this.availableQuantity = availableQuantity; }
    public int getActiveReservationCount() { return activeReservationCount; }
    public void setActiveReservationCount(int activeReservationCount) { this.activeReservationCount = activeReservationCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public List<Category> getCategories() { return categories; }
    public void setCategories(List<Category> categories) { this.categories = categories; }
    public List<Tag> getTags() { return tags; }
    public void setTags(List<Tag> tags) { this.tags = tags; }
}
