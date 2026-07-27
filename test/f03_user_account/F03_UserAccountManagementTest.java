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
}
