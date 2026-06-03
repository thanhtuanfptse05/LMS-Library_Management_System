package model;

/**
 * Student — Entity bean representing information in the Student table.
 */
public class Student {
    private int userId;
    private String studentCode;
    private String major;
    private int enrollmentYear;

    public Student() {
    }

    public Student(int userId, String studentCode, String major, int enrollmentYear) {
        this.userId = userId;
        this.studentCode = studentCode;
        this.major = major;
        this.enrollmentYear = enrollmentYear;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public int getEnrollmentYear() {
        return enrollmentYear;
    }

    public void setEnrollmentYear(int enrollmentYear) {
        this.enrollmentYear = enrollmentYear;
    }
}
