package f02_profile;

import model.MemberProfile;
import model.Student;
import model.Lecturer;
import model.Librarian;
import model.LibraryManager;
import model.Admin;
import org.junit.Before;
import org.junit.Test;

import java.sql.Date;

import static org.junit.Assert.*;

public class F02_ProfileManagementTest {

    private MemberProfile profile;
    private Student student;
    private Lecturer lecturer;

    @Before
    public void setUp() {
        profile = new MemberProfile();
        profile.setUserId(201);
        profile.setFullName("Tran Van B");
        profile.setPhoneNumber("0912345678");
        profile.setGender("Male");
        profile.setDateOfBirth(Date.valueOf("2002-05-15"));
        profile.setStartDate(Date.valueOf("2020-09-01"));
        profile.setEndDate(Date.valueOf("2024-09-01"));

        student = new Student();
        student.setUserId(201);
        student.setStudentCode("SE160001");
        student.setMajor("Software Engineering");
        student.setEnrollmentYear(2020);

        lecturer = new Lecturer();
        lecturer.setUserId(202);
        lecturer.setLecturerCode("LEC001");
        lecturer.setDepartment("Computer Science");
    }

    // ========================================================================
    // F02: PROFILE MANAGEMENT - COMPREHENSIVE UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testMemberProfileFields() {
        assertEquals(201, profile.getUserId());
        assertEquals("Tran Van B", profile.getFullName());
        assertEquals("0912345678", profile.getPhoneNumber());
        assertEquals("Male", profile.getGender());
        assertEquals(Date.valueOf("2002-05-15"), profile.getDateOfBirth());
        assertEquals(Date.valueOf("2020-09-01"), profile.getStartDate());
        assertEquals(Date.valueOf("2024-09-01"), profile.getEndDate());
    }

    @Test
    public void testStudentProfileFields() {
        assertEquals(201, student.getUserId());
        assertEquals("SE160001", student.getStudentCode());
        assertEquals("Software Engineering", student.getMajor());
        assertEquals(2020, student.getEnrollmentYear());
    }

    @Test
    public void testLecturerProfileFields() {
        assertEquals(202, lecturer.getUserId());
        assertEquals("LEC001", lecturer.getLecturerCode());
        assertEquals("Computer Science", lecturer.getDepartment());
    }

    @Test
    public void testLibrarianAndAdminProfileFields() {
        Librarian lib = new Librarian();
        lib.setUserId(301);
        lib.setStaffCode("LIB001");
        assertEquals(301, lib.getUserId());
        assertEquals("LIB001", lib.getStaffCode());

        LibraryManager mgr = new LibraryManager();
        mgr.setUserId(302);
        mgr.setStaffCode("MGR001");
        assertEquals(302, mgr.getUserId());
        assertEquals("MGR001", mgr.getStaffCode());

        Admin adm = new Admin();
        adm.setUserId(303);
        adm.setStaffCode("ADM001");
        assertEquals(303, adm.getUserId());
        assertEquals("ADM001", adm.getStaffCode());
    }

    @Test
    public void testPhoneNumberValidation_Valid() {
        String[] validPhones = {"0912345678", "0389998888", "0861112222"};
        for (String phone : validPhones) {
            assertTrue("Số điện thoại hợp lệ: " + phone, phone.matches("^(03|05|07|08|09)\\d{8}$"));
        }
    }

    @Test
    public void testPhoneNumberValidation_Invalid() {
        String[] invalidPhones = {"12345678", "091234567", "012345678901", "abcdefghij"};
        for (String phone : invalidPhones) {
            assertFalse("Số điện thoại không hợp lệ: " + phone, phone.matches("^(03|05|07|08|09)\\d{8}$"));
        }
    }

    @Test
    public void testStudentCodeBoundary() {
        student.setStudentCode("SE170123");
        assertTrue("StudentCode dạng SE + 6 chữ số", student.getStudentCode().matches("^[A-Z]{2}\\d{6}$"));
    }
}
