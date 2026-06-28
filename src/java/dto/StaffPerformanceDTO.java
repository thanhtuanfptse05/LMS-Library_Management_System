package dto;

/**
 * StaffPerformanceDTO — DTO chứa số liệu hiệu suất hàng tháng của từng Thủ thư.
 *
 * <p>Dùng để truyền dữ liệu từ StaffPerformanceDAO lên Controller và View JSP.</p>
 */
public class StaffPerformanceDTO {

    private int userId;
    private String fullName;
    private String initials;   // 2 ký tự đầu viết tắt (VD: "NH")
    private String staffCode;  // Mã nhân viên
    private int issueCount;    // Số phiếu mượn đã cấp trong tháng
    private int returnCount;   // Số phiếu đã trả trong tháng
    private long fineCollected; // Tổng tiền phạt đã thu (VND)
    private int month;
    private int year;

    public StaffPerformanceDTO() {}

    public StaffPerformanceDTO(int userId, String fullName, String staffCode,
                               int issueCount, int returnCount, long fineCollected,
                               int month, int year) {
        this.userId = userId;
        this.fullName = fullName;
        this.staffCode = staffCode;
        this.issueCount = issueCount;
        this.returnCount = returnCount;
        this.fineCollected = fineCollected;
        this.month = month;
        this.year = year;
        this.initials = buildInitials(fullName);
    }

    /**
     * Tạo 2 ký tự viết tắt từ họ tên đầy đủ.
     * VD: "Nguyễn Văn Hùng" → "NH" (lấy chữ cái đầu của từ đầu và từ cuối).
     */
    private static String buildInitials(String fullName) {
        if (fullName == null || fullName.isBlank()) return "??";
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        }
        return (parts[0].charAt(0) + "" + parts[parts.length - 1].charAt(0)).toUpperCase();
    }

    /**
     * Định dạng số tiền phạt thành chuỗi hiển thị (VD: 540.000đ).
     */
    public String getFineCollectedFormatted() {
        if (fineCollected <= 0) return "0đ";
        // Định dạng thủ công: thêm dấu chấm phân cách hàng nghìn
        String raw = String.valueOf(fineCollected);
        StringBuilder sb = new StringBuilder();
        int start = raw.length() % 3;
        if (start > 0) sb.append(raw, 0, start);
        for (int i = start; i < raw.length(); i += 3) {
            if (sb.length() > 0) sb.append('.');
            sb.append(raw, i, i + 3);
        }
        return sb + "đ";
    }

    // ─── Getters & Setters ────────────────────────────────────────────────────

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) {
        this.fullName = fullName;
        this.initials = buildInitials(fullName);
    }

    public String getInitials() { return initials; }
    public void setInitials(String initials) { this.initials = initials; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }

    public int getIssueCount() { return issueCount; }
    public void setIssueCount(int issueCount) { this.issueCount = issueCount; }

    public int getReturnCount() { return returnCount; }
    public void setReturnCount(int returnCount) { this.returnCount = returnCount; }

    public long getFineCollected() { return fineCollected; }
    public void setFineCollected(long fineCollected) { this.fineCollected = fineCollected; }

    public int getMonth() { return month; }
    public void setMonth(int month) { this.month = month; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
}
