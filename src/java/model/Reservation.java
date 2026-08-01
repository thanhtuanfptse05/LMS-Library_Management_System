package model;

import java.sql.Timestamp;

/**
 * Reservation — Entity bean ánh xạ 1-1 với bảng [Reservation] trong CSDL.
 *
 * <p>Bảng {@code Reservation} lưu thông tin các đơn đặt trước sách của người dùng.
 * Một Reservation có thể ở trạng thái: 'pending' (đang chờ), 'readypickup' (sẵn sàng nhận),
 * 'fulfilled' (đã nhận) hoặc 'cancelled' (đã hủy).
 * Thứ tự ưu tiên trong hàng chờ được xác định bởi {@code queuePosition}:
 * giá trị {@code 0} nghĩa là đang sẵn sàng nhận sách,
 * giá trị {@code 1} nghĩa là người tiếp theo trong danh sách chờ.</p>
 *
 * <p>Schema mapping (database/LMS_Library_Management_System.sql):</p>
 * <ul>
 *   <li>{@code reservationId} — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code userId}        — INT NOT NULL, FK → [User](userId)</li>
 *   <li>{@code bookId}        — INT NOT NULL, FK → Book(bookId)</li>
 *   <li>{@code bookCopyId}    — INT NULL, FK → BookCopy(bookCopyId); chỉ gán khi checkout/fulfilled</li>
 *   <li>{@code status}        — NVARCHAR(50) DEFAULT 'pending'
 *                               ('pending' | 'readypickup' | 'fulfilled' | 'cancelled')</li>
 *   <li>{@code queuePosition} — INT NULL (0 = sẵn sàng nhận, 1 = kế tiếp, ...;
 *                               NULL khi fulfilled/cancelled)</li>
 *   <li>{@code startDate}     — DATETIME NULL DEFAULT GETDATE()</li>
 *   <li>{@code endDate}       — DATETIME NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation),
 * ENG-02 (PascalCase class name, camelCase fields khớp với cột DB).</p>
 *
 * <p>Traceability: SPEC.md §5 — Data Model, FR-F6-02, FR-F6-03, FR-F6-06.</p>
 */
public class Reservation {

    private int reservationId;
    private int userId;
    private int bookId;
    private Integer bookCopyId;  // NULL ở pending/readypickup; gán barcode khi checkout
    private String status;
    private Integer queuePosition; // NULL-able theo schema
    private Timestamp startDate;
    private Timestamp endDate;

    /**
     * Constructor không tham số — yêu cầu bởi Java Bean convention.
     */
    public Reservation() {
    }

    /**
     * Constructor đầy đủ tham số cho trường hợp khởi tạo nhanh từ ResultSet.
     *
     * @param reservationId ID tự tăng của đơn đặt trước
     * @param userId        ID người dùng đặt trước
     * @param bookId        ID sách được đặt trước
     * @param bookCopyId    ID bản sao sách cụ thể (null nếu chưa gán)
     * @param status        Trạng thái đơn đặt trước
     * @param queuePosition Vị trí trong hàng đợi (null nếu chưa xếp hàng)
     * @param startDate     Thời điểm tạo đơn đặt trước
     * @param endDate       Thời điểm hết hạn đơn đặt trước
     */
    public Reservation(int reservationId, int userId, int bookId, Integer bookCopyId,
                       String status, Integer queuePosition,
                       Timestamp startDate, Timestamp endDate) {
        this.reservationId = reservationId;
        this.userId = userId;
        this.bookId = bookId;
        this.bookCopyId = bookCopyId;
        this.status = status;
        this.queuePosition = queuePosition;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Integer getBookCopyId() {
        return bookCopyId;
    }

    public void setBookCopyId(Integer bookCopyId) {
        this.bookCopyId = bookCopyId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getQueuePosition() {
        return queuePosition;
    }

    public void setQueuePosition(Integer queuePosition) {
        this.queuePosition = queuePosition;
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

    // Helper fields for view layer
    private Book book;
    private BookCopy bookCopy;
    private String memberName;
    private String memberCode;
    private String bookTitle;

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
    public BookCopy getBookCopy() { return bookCopy; }
    public void setBookCopy(BookCopy bookCopy) { this.bookCopy = bookCopy; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getMemberCode() { return memberCode; }
    public void setMemberCode(String memberCode) { this.memberCode = memberCode; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
}
