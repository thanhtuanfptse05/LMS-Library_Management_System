package model;

public class Lecturer {
    private int userId;
    private String lecturerCode;
    private String department;

    public Lecturer() {}

    public Lecturer(int userId, String lecturerCode, String department) {
        this.userId = userId;
        this.lecturerCode = lecturerCode;
        this.department = department;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getLecturerCode() { return lecturerCode; }
    public void setLecturerCode(String lecturerCode) { this.lecturerCode = lecturerCode; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}
