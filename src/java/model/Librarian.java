package model;

public class Librarian {
    private int userId;
    private String staffCode;

    public Librarian() {}

    public Librarian(int userId, String staffCode) {
        this.userId = userId;
        this.staffCode = staffCode;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }
}
