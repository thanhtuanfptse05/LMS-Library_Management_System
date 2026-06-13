package model;

import java.util.List;

/**
 * BookSummaryDTO — Data Transfer Object gọn nhẹ để truyền dữ liệu cho AI.
 * Chỉ chứa các trường cần thiết để build prompt: ID, categories, và tags.
 */
public class BookSummaryDTO {
    private int bookId;
    private List<String> categories;
    private List<String> tags;

    public BookSummaryDTO() {
    }

    public BookSummaryDTO(int bookId, List<String> categories, List<String> tags) {
        this.bookId = bookId;
        this.categories = categories;
        this.tags = tags;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    @Override
    public String toString() {
        return "bookId=" + bookId + 
               " | categories: " + (categories != null ? String.join(", ", categories) : "") + 
               " | tags: " + (tags != null ? String.join(", ", tags) : "");
    }
}
