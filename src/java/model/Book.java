package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Book — Entity bean ánh xạ 1-1 với bảng [Book] trong CSDL.
 *
 * <p>Bảng {@code Book} lưu thông tin đầu sách (title, author, ISBN...).
 * Số lượng kho được theo dõi qua 2 cột: {@code totalQuantity} (tổng bản sao
 * vật lý đang tồn tại) và {@code availableQuantity} (bản sao sẵn sàng cho mượn).
 * Khi sách hỏng/mất (BR-24), {@code totalQuantity} giảm 1 và bản sao bị loại
 * khỏi kho hoàn toàn.</p>
 *
 * <p>Schema mapping (database/LMS_Library_Management_System.sql):</p>
 * <ul>
 *   <li>{@code bookId}            — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code isbn}              — NVARCHAR(20) NOT NULL UNIQUE</li>
 *   <li>{@code title}             — NVARCHAR(500) NOT NULL</li>
 *   <li>{@code author}            — NVARCHAR(500) NULL</li>
 *   <li>{@code publisher}         — NVARCHAR(255) NULL</li>
 *   <li>{@code publicationYear}   — INT NULL</li>
 *   <li>{@code price}             — DECIMAL(18,2) NULL (giá gốc để tính phạt đền bù)</li>
 *   <li>{@code totalQuantity}     — INT NOT NULL DEFAULT 0</li>
 *   <li>{@code availableQuantity} — INT NOT NULL DEFAULT 0</li>
 *   <li>{@code status}            — NVARCHAR(50) DEFAULT 'available' ('available'|'unavailable')</li>
 *   <li>{@code createdAt}         — DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code updatedAt}         — DATETIME NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation),
 * ENG-02 (PascalCase class name, camelCase fields khớp với cột DB).</p>
 *
 * <p>Traceability: SPEC.md §5 — Data Model, FR-F6-04 (totalQuantity),
 * FR-F6-06 (availableQuantity).</p>
 */
public class Book {

    private int bookId;
    private String isbn;
    private String title;
    private String author;
    private String publisher;
    private Integer publicationYear;
    private BigDecimal price;     // NULL-able — dùng BigDecimal để tránh sai số tiền tệ
    private int totalQuantity;
    private int availableQuantity;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    /**
     * Constructor không tham số — yêu cầu bởi Java Bean convention.
     */
    public Book() {
    }

    /**
     * Constructor đầy đủ tham số cho trường hợp khởi tạo nhanh từ ResultSet.
     *
     * @param bookId            ID tự tăng của đầu sách
     * @param isbn              Mã ISBN duy nhất
     * @param title             Tiêu đề sách
     * @param author            Tên tác giả
     * @param publisher         Nhà xuất bản
     * @param publicationYear   Năm xuất bản (null nếu không có)
     * @param price             Giá gốc (dùng để tính phạt đền bù; null nếu chưa nhập)
     * @param totalQuantity     Tổng số bản sao vật lý đang tồn tại trong hệ thống
     * @param availableQuantity Số bản sao sẵn sàng cho mượn
     * @param status            Trạng thái đầu sách ('available' | 'unavailable')
     * @param createdAt         Thời điểm tạo bản ghi
     * @param updatedAt         Thời điểm cập nhật gần nhất (null nếu chưa cập nhật)
     */
    public Book(int bookId, String isbn, String title, String author, String publisher,
                Integer publicationYear, BigDecimal price, int totalQuantity,
                int availableQuantity, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.bookId            = bookId;
        this.isbn              = isbn;
        this.title             = title;
        this.author            = author;
        this.publisher         = publisher;
        this.publicationYear   = publicationYear;
        this.price             = price;
        this.totalQuantity     = totalQuantity;
        this.availableQuantity = availableQuantity;
        this.status            = status;
        this.createdAt         = createdAt;
        this.updatedAt         = updatedAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Integer getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(Integer publicationYear) {
        this.publicationYear = publicationYear;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
