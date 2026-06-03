package model;

public class Admin {
    private int userId;
    private String staffCode;

    public Admin() {}

    public Admin(int userId, String staffCode) {
        this.userId = userId;
        this.staffCode = staffCode;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }
}
