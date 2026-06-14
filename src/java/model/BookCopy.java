package model;

import java.sql.Timestamp;

/**
 * BookCopy — Entity bean ánh xạ 1-1 với bảng [BookCopy] trong CSDL.
 *
 * <p>Bảng {@code BookCopy} lưu thông tin từng bản sao vật lý của một đầu sách.
 * Mỗi bản sao có một {@code barcode} duy nhất dùng để quét tại quầy thư viện.
 * Trạng thái ({@code status}) phản ánh tình trạng luân chuyển hiện tại,
 * còn tình trạng vật lý ({@code condition}) phản ánh mức độ hư hỏng.</p>
 *
 * <p>Schema mapping (database/LMS_Library_Management_System.sql):</p>
 * <ul>
 *   <li>{@code bookCopyId} — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code bookId}     — INT NOT NULL, FK → Book(bookId)</li>
 *   <li>{@code location}   — NVARCHAR(255) NULL (vị trí kệ sách)</li>
 *   <li>{@code condition}  — NVARCHAR(100) DEFAULT 'good' ('good' | 'damaged' | 'lost')</li>
 *   <li>{@code status}     — NVARCHAR(50) DEFAULT 'available'
 *                            ('available' | 'unavailable' | 'borrowed' | 'reserved')</li>
 *   <li>{@code barcode}    — NVARCHAR(50) NOT NULL UNIQUE</li>
 *   <li>{@code createdAt}  — DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code updatedAt}  — DATETIME NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation),
 * ENG-02 (PascalCase class name, camelCase fields khớp với cột DB).</p>
 *
 * <p>Traceability: SPEC.md §5 — Data Model, FR-F6-03, FR-F6-04, FR-F6-05, FR-F6-06.</p>
 */
public class BookCopy {

    private int bookCopyId;
    private int bookId;
    private String location;
    private String condition;
    private String status;
    private String barcode;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    /**
     * Constructor không tham số — yêu cầu bởi Java Bean convention.
     */
    public BookCopy() {
    }

    /**
     * Constructor đầy đủ tham số cho trường hợp khởi tạo nhanh từ ResultSet.
     *
     * @param bookCopyId ID tự tăng của bản sao sách
     * @param bookId     ID đầu sách mà bản sao này thuộc về
     * @param location   Vị trí kệ sách lưu trữ
     * @param condition  Tình trạng vật lý ('good', 'damaged', 'lost')
     * @param status     Trạng thái luân chuyển ('available', 'unavailable', 'borrowed', 'reserved')
     * @param barcode    Mã vạch duy nhất để quét tại quầy
     * @param createdAt  Thời điểm tạo bản ghi
     * @param updatedAt  Thời điểm cập nhật gần nhất (null nếu chưa cập nhật)
     */
    public BookCopy(int bookCopyId, int bookId, String location, String condition,
                    String status, String barcode, Timestamp createdAt, Timestamp updatedAt) {
        this.bookCopyId = bookCopyId;
        this.bookId = bookId;
        this.location = location;
        this.condition = condition;
        this.status = status;
        this.barcode = barcode;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getBookCopyId() { return bookCopyId; }
    public void setBookCopyId(int bookCopyId) { this.bookCopyId = bookCopyId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
