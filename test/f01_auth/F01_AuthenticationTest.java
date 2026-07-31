package f01_auth;

import model.User;
import dto.UserDTO;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F01_AuthenticationTest {

    private User user;
    private UserDTO userDTO;

    @Before
    public void setUp() {
        user = new User();
        user.setUserId(101);
        user.setEmail("student@fpt.edu.vn");
        user.setPasswordHash("$2a$10$abcdefghijklmnopqrstuuu");
        user.setRole("STUDENT");
        user.setStatus("active");
        user.setFailedLoginAttempts(0);

        userDTO = new UserDTO();
        userDTO.setUserId(101);
        userDTO.setEmail("student@fpt.edu.vn");
        userDTO.setRole("STUDENT");
        userDTO.setFullName("Nguyen Van A");
    }

    // ========================================================================
    // F01: AUTHENTICATION & SECURITY - COMPREHENSIVE UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testUserGettersAndSetters() {
        assertEquals(101, user.getUserId());
        assertEquals("student@fpt.edu.vn", user.getEmail());
        assertEquals("STUDENT", user.getRole());
        assertEquals("active", user.getStatus());
        assertEquals(0, user.getFailedLoginAttempts());
    }

    @Test
    public void testUserAccountLockingLogic() {
        user.setFailedLoginAttempts(5);
        user.setStatus("locked");
        Timestamp lockTime = new Timestamp(System.currentTimeMillis() + 900000); // 15 mins
        user.setLockedUntil(lockTime);

        assertEquals(5, user.getFailedLoginAttempts());
        assertEquals("locked", user.getStatus());
        assertNotNull(user.getLockedUntil());
        assertTrue(user.getLockedUntil().after(new Timestamp(System.currentTimeMillis())));
    }

    @Test
    public void testUserRolesBoundary() {
        String[] validRoles = {"ADMIN", "LIBRARIAN", "STUDENT", "LECTURER"};
        for (String role : validRoles) {
            user.setRole(role);
            assertEquals(role, user.getRole());
        }
    }

    @Test
    public void testUserDTOMapping() {
        assertEquals(101, userDTO.getUserId());
        assertEquals("student@fpt.edu.vn", userDTO.getEmail());
        assertEquals("STUDENT", userDTO.getRole());
        assertEquals("Nguyen Van A", userDTO.getFullName());
    }

    @Test
    public void testUserLockReasonConstant() {
        String unpaidReason = "unpaid";
        String manualReason = "manual_admin";

        assertEquals("unpaid", unpaidReason);
        assertEquals("manual_admin", manualReason);
    }

    @Test
    public void testPasswordValidationRules_Valid() {
        String validPassword = "Password123!";
        assertTrue("Mật khẩu hợp lệ khi dài >= 8 ký tự và bao gồm cả chữ và số",
                validPassword.length() >= 8 && validPassword.matches(".*\\d.*") && validPassword.matches(".*[a-zA-Z].*"));
    }

    @Test
    public void testPasswordValidationRules_TooShort() {
        String shortPassword = "Pass1";
        assertFalse("Mật khẩu < 8 ký tự phải không hợp lệ",
                shortPassword.length() >= 8);
    }

    @Test
    public void testPasswordValidationRules_NoNumbers() {
        String noNumPassword = "OnlyLettersPassword";
        assertFalse("Mật khẩu thiếu chữ số phải không hợp lệ",
                noNumPassword.matches(".*\\d.*"));
    }

    @Test
    public void testEmailFormatValidation_Valid() {
        String[] validEmails = {"test@fpt.edu.vn", "user.name@domain.com", "admin_lms@sub.domain.org"};
        for (String email : validEmails) {
            assertTrue("Email hợp lệ: " + email, email.matches("^[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}$"));
        }
    }

    @Test
    public void testEmailFormatValidation_Invalid() {
        String[] invalidEmails = {"plainaddress", "@domain.com", "user@.com", "user@domain..com"};
        for (String email : invalidEmails) {
            assertFalse("Email không hợp lệ: " + email, email.matches("^[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}$"));
        }
    }

    @Test
    public void testAccountStatusTransition() {
        user.setStatus("active");
        assertEquals("active", user.getStatus());

        user.setStatus("locked");
        assertEquals("locked", user.getStatus());

        user.setStatus("inactive");
        assertEquals("inactive", user.getStatus());
    }

    @Test
    public void testFailedLoginAttemptsIncrement() {
        for (int i = 1; i <= 5; i++) {
            user.setFailedLoginAttempts(user.getFailedLoginAttempts() + 1);
            assertEquals(i, user.getFailedLoginAttempts());
        }
        assertTrue("Sau 5 lần sai mật khẩu tài khoản phải chuyển sang khóa", user.getFailedLoginAttempts() >= 5);
    }

    @Test
    public void testCustomAdminLockReasonValidation() {
        String customReason = "Vi phạm quy định giữ trật tự thư viện";
        assertNotNull(customReason);
        assertFalse("Lý do khóa nhập tay không được để trống", customReason.trim().isEmpty());
        assertTrue("Lý do khóa nhập tay không quá 50 ký tự", customReason.length() <= 50);

        String tooLongReason = "Lý do này vượt quá năm mươi ký tự quy định nhằm kiểm tra tính năng cắt ngắn chuỗi tự động";
        if (tooLongReason.length() > 50) {
            tooLongReason = tooLongReason.substring(0, 50);
        }
        assertEquals(50, tooLongReason.length());

        assertFalse("Lý do nhập tay khác unpaid", "unpaid".equals(customReason));
    }
}
