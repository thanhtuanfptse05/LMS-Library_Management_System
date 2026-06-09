package model;

import java.sql.Timestamp;

/**
 * BorrowRecord — Entity bean ánh xạ 1-1 với bảng [BorrowRecord] trong CSDL.
 *
 * <p>Bảng {@code BorrowRecord} lưu toàn bộ lịch sử giao dịch mượn/trả sách.
 * Mỗi bản ghi được tạo tại thời điểm giao sách (Check-out) và được cập nhật
 * khi trả sách (Check-in). Trạng thái ({@code status}) theo dõi vòng đời:
 * 'borrowed' → 'returned' (bình thường) hoặc 'borrowed' → 'overdue' / 'lost'.</p>
 *
 * <p>Schema mapping (database/LMS_Library_Management_System.sql):</p>
 * <ul>
 *   <li>{@code borrowRecordId} — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code userId}         — INT NOT NULL, FK → [User](userId)</li>
 *   <li>{@code bookCopyId}     — INT NOT NULL, FK → BookCopy(bookCopyId)</li>
 *   <li>{@code bookId}         — INT NOT NULL, FK → Book(bookId)</li>
 *   <li>{@code startDate}      — DATETIME NOT NULL DEFAULT GETDATE()</li>
 *   <li>{@code endDate}        — DATETIME NOT NULL (hạn trả sách)</li>
 *   <li>{@code returnedAt}     — DATETIME NULL (thời điểm trả thực tế)</li>
 *   <li>{@code status}         — NVARCHAR(50) DEFAULT 'borrowed'
 *                                ('borrowed' | 'returned' | 'overdue' | 'lost')</li>
 *   <li>{@code extensionCount} — INT DEFAULT 0 (số lần gia hạn)</li>
 *   <li>{@code createdBy}      — INT NULL, FK → [User](userId) (librarianId)</li>
 *   <li>{@code createdAt}      — DATETIME NOT NULL DEFAULT GETDATE()</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation),
 * ENG-02 (PascalCase class name, camelCase fields khớp với cột DB).</p>
 *
 * <p>Traceability: SPEC.md §5 — Data Model, FR-F6-03, FR-F6-04, FR-F6-05.</p>
 */
public class BorrowRecord {

    private int borrowRecordId;
    private int userId;
    private int bookCopyId;
    private int bookId;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp returnedAt;
    private String status;
    private int extensionCount;
    private Integer createdBy;  // NULL-able — librarianId, null nếu tự mượn online
    private Timestamp createdAt;

    /**
     * Constructor không tham số — yêu cầu bởi Java Bean convention.
     */
    public BorrowRecord() {
    }

    /**
     * Constructor đầy đủ tham số cho trường hợp khởi tạo nhanh từ ResultSet.
     *
     * @param borrowRecordId ID tự tăng của bản ghi mượn
     * @param userId         ID người mượn sách
     * @param bookCopyId     ID bản sao sách được mượn
     * @param bookId         ID đầu sách được mượn
     * @param startDate      Ngày bắt đầu mượn
     * @param endDate        Hạn trả sách
     * @param returnedAt     Thời điểm trả thực tế (null nếu chưa trả)
     * @param status         Trạng thái bản ghi
     * @param extensionCount Số lần gia hạn đã thực hiện
     * @param createdBy      ID thủ thư tạo phiếu mượn (null nếu tự mượn online)
     * @param createdAt      Thời điểm tạo bản ghi
     */
    public BorrowRecord(int borrowRecordId, int userId, int bookCopyId, int bookId,
                        Timestamp startDate, Timestamp endDate, Timestamp returnedAt,
                        String status, int extensionCount, Integer createdBy, Timestamp createdAt) {
        this.borrowRecordId = borrowRecordId;
        this.userId = userId;
        this.bookCopyId = bookCopyId;
        this.bookId = bookId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.returnedAt = returnedAt;
        this.status = status;
        this.extensionCount = extensionCount;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getBorrowRecordId() {
        return borrowRecordId;
    }

    public void setBorrowRecordId(int borrowRecordId) {
        this.borrowRecordId = borrowRecordId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookCopyId() {
        return bookCopyId;
    }

    public void setBookCopyId(int bookCopyId) {
        this.bookCopyId = bookCopyId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Timestamp getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(Timestamp returnedAt) {
        this.returnedAt = returnedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getExtensionCount() {
        return extensionCount;
    }

    public void setExtensionCount(int extensionCount) {
        this.extensionCount = extensionCount;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
