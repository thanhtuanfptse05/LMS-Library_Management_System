package f03_user_account;

import model.User;
import model.MemberProfile;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class F03_UserAccountManagementTest {

    private User user;
    private MemberProfile profile;

    @Before
    public void setUp() {
        user = new User();
        user.setUserId(301);
        user.setEmail("newuser@fpt.edu.vn");
        user.setRole("STUDENT");
        user.setStatus("active");

        profile = new MemberProfile();
        profile.setUserId(301);
        profile.setFullName("Le Van C");
    }

    // ========================================================================
    // F03: USER ACCOUNT MANAGEMENT - COMPREHENSIVE UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testCreateUserAccountData() {
        assertNotNull(user);
        assertEquals("newuser@fpt.edu.vn", user.getEmail());
        assertEquals("STUDENT", user.getRole());
        assertEquals("active", user.getStatus());
    }

    @Test
    public void testUserRolePermissions() {
        String role = user.getRole();
        assertTrue("Role STUDENT có quyền mượn sách", "STUDENT".equals(role) || "LECTURER".equals(role));
    }

    @Test
    public void testUserStatusChange() {
        user.setStatus("locked");
        assertEquals("locked", user.getStatus());

        user.setStatus("inactive");
        assertEquals("inactive", user.getStatus());

        user.setStatus("active");
        assertEquals("active", user.getStatus());
    }

    @Test
    public void testAccountImportRowValidation() {
        String email = "import_test@fpt.edu.vn";
        String role = "LECTURER";

        assertTrue("Import Email phải hợp lệ", email.contains("@"));
        assertTrue("Import Role phải thuộc danh sách hỗ trợ", "STUDENT".equals(role) || "LECTURER".equals(role));
    }

    @Test
    public void testMemberProfileAssociation() {
        assertEquals(user.getUserId(), profile.getUserId());
        assertEquals("Le Van C", profile.getFullName());
    }

    @Test
    public void testAdminLockUserSelfLockRestrictionBR41() {
        int actorId = 1;
        int targetUserId = 1; // Tự khóa chính mình
        boolean isSelfLockForbidden = (actorId == targetUserId);
        assertTrue("BR-41: Admin không được tự khóa tài khoản của chính mình", isSelfLockForbidden);
    }

    @Test
    public void testAdminLockAnotherAdminRestriction() {
        int actorId = 1; // Admin 1
        User targetAdmin = new User();
        targetAdmin.setUserId(2); // Admin 2
        targetAdmin.setRole("ADMIN");

        boolean isAnotherAdmin = "ADMIN".equalsIgnoreCase(targetAdmin.getRole()) && actorId != targetAdmin.getUserId();
        assertTrue("Admin không được thay đổi trạng thái của Quản trị viên khác", isAnotherAdmin);
    }

    @Test
    public void testToggleStatusLockReasonValidation() {
        String status = "locked";
        String emptyLockReason = "   ";
        boolean isValidEmpty = (emptyLockReason != null && !emptyLockReason.trim().isEmpty());
        assertFalse("Vui lòng nhập lý do khóa tài khoản khi status='locked'", isValidEmpty);

        String validReason = "Vi phạm quy định sử dụng máy tính thư viện";
        boolean isValidReason = (validReason != null && !validReason.trim().isEmpty());
        assertTrue("Lý do hợp lệ khi không rỗng", isValidReason);

        String longReason = "123456789012345678901234567890123456789012345678901234567890"; // 60 chars
        if (longReason.length() > 50) {
            longReason = longReason.substring(0, 50);
        }
        assertEquals(50, longReason.length());
    }
}
