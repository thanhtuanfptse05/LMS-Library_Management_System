package service;

import dao.MemberProfileDAO;
import dao.UserDAO;
import java.sql.SQLException;
import model.MemberProfile;
import model.User;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;
import static org.junit.Assert.*;

public class ProfileServiceTest {

    private ProfileService profileService;
    private MockUserDAO mockUserDAO;
    private MockMemberProfileDAO mockProfileDAO;

    @Before
    public void setUp() {
        mockUserDAO = new MockUserDAO();
        mockProfileDAO = new MockMemberProfileDAO();
        profileService = new ProfileService(mockProfileDAO, mockUserDAO);
    }

    @Test
    public void testUpdateUserInfo_Success() throws Exception {
        profileService.updateUserInfo(1, "Nguyễn Văn A", "0912345678", "Nam", "2000-01-01");
        
        assertTrue("Hàm upsert phải được gọi", mockProfileDAO.upsertCalled);
        assertNotNull(mockProfileDAO.upsertedProfile);
        assertEquals("Nguyễn Văn A", mockProfileDAO.upsertedProfile.getFullName());
        assertEquals("0912345678", mockProfileDAO.upsertedProfile.getPhoneNumber());
        assertEquals("Nam", mockProfileDAO.upsertedProfile.getGender());
        assertEquals("2000-01-01", mockProfileDAO.upsertedProfile.getDateOfBirth().toString());
    }

    @Test
    public void testUpdateUserInfo_Fail_EmptyFullName() {
        try {
            profileService.updateUserInfo(1, "", "0912345678", "Nam", "2000-01-01");
            fail("Phải throw Exception do rỗng họ tên");
        } catch (Exception e) {
            assertEquals("Họ và tên không được để trống.", e.getMessage());
            assertFalse(mockProfileDAO.upsertCalled);
        }
    }

    @Test
    public void testUpdateUserInfo_Fail_InvalidDate() {
        try {
            profileService.updateUserInfo(1, "Nguyễn Văn A", "0912345678", "Nam", "2000-13-01");
            fail("Phải throw Exception do sai định dạng ngày");
        } catch (Exception e) {
            assertEquals("Ngày sinh không đúng định dạng YYYY-MM-DD.", e.getMessage());
            assertFalse(mockProfileDAO.upsertCalled);
        }
    }

    @Test
    public void testChangePassword_Success() throws Exception {
        User u = new User();
        u.setUserId(1);
        u.setPasswordHash(BCrypt.hashpw("Old@12345", BCrypt.gensalt(10)));
        mockUserDAO.dbUser = u;

        profileService.changePassword(1, "Old@12345", "New@12345", "New@12345");
        
        assertTrue("Phải gọi hàm update mật khẩu", mockUserDAO.updatePwCalled);
        assertTrue("Audit Log phải được ghi", mockUserDAO.auditLogCalled);
    }

    @Test
    public void testChangePassword_Fail_MismatchConfirm() {
        try {
            profileService.changePassword(1, "Old@12345", "New@12345", "New@123456");
            fail("Phải throw Exception do confirm không khớp");
        } catch (Exception e) {
            assertEquals("Xác nhận mật khẩu mới không khớp.", e.getMessage());
        }
    }

    @Test
    public void testChangePassword_Fail_WeakPolicy() {
        try {
            // Thiếu ký tự đặc biệt
            profileService.changePassword(1, "Old@12345", "New12345", "New12345");
            fail("Phải throw Exception do mật khẩu yếu");
        } catch (Exception e) {
            assertTrue(e.getMessage().contains("Mật khẩu mới phải từ 8 ký tự trở lên"));
        }
    }

    @Test
    public void testChangePassword_Fail_WrongOldPassword() {
        User u = new User();
        u.setUserId(1);
        u.setPasswordHash(BCrypt.hashpw("Old@12345", BCrypt.gensalt(10)));
        mockUserDAO.dbUser = u;

        try {
            profileService.changePassword(1, "Wrong@123", "New@12345", "New@12345");
            fail("Phải throw Exception do mật khẩu hiện tại sai");
        } catch (Exception e) {
            assertEquals("Mật khẩu hiện tại không chính xác.", e.getMessage());
        }
    }

    // ==========================================
    // MOCK CLASSES
    // ==========================================

    private static class MockUserDAO extends UserDAO {
        boolean updatePwCalled = false;
        boolean auditLogCalled = false;
        User dbUser = null;

        @Override
        public User findByUserId(int userId) {
            return dbUser;
        }

        @Override
        public void updatePasswordHash(int userId, String hash) {
            updatePwCalled = true;
        }

        @Override
        public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
            auditLogCalled = true;
        }
    }

    private static class MockMemberProfileDAO extends MemberProfileDAO {
        boolean upsertCalled = false;
        MemberProfile upsertedProfile = null;

        @Override
        public MemberProfile findByUserId(int userId) {
            return null; // giả lập chưa có profile (sẽ tạo mới)
        }

        @Override
        public boolean upsertProfile(MemberProfile profile) {
            upsertCalled = true;
            upsertedProfile = profile;
            return true;
        }
    }
}
