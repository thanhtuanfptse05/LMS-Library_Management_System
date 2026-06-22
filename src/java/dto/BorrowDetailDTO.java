package dto;

import java.sql.Timestamp;

public class BorrowDetailDTO {
    private String memberCode; // StudentCode or LecturerCode
    private String fullName;
    private String bookTitle;
    private String barcode;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp returnedAt;
    private String status;

    public BorrowDetailDTO() {}

    public String getMemberCode() { return memberCode; }
    public void setMemberCode(String memberCode) { this.memberCode = memberCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public Timestamp getReturnedAt() { return returnedAt; }
    public void setReturnedAt(Timestamp returnedAt) { this.returnedAt = returnedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
