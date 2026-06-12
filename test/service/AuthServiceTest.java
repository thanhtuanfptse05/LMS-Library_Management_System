package service;

import dao.UserDAO;
import model.User;
import java.sql.Timestamp;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;
import static org.junit.Assert.*;

/**
 * AuthServiceTest — Unit Tests cho AuthService sử dụng JUnit 4.
 *
 * <p>Sử dụng kỹ thuật Subclass Stubbing để giả lập UserDAO, giúp kiểm thử
 * độc lập cô lập (Isolated Unit Test) mà không cần kết nối tới cơ sở dữ liệu thật.</p>
 */
public class AuthServiceTest {

    private AuthService authService;
    private MockUserDAO mockUserDAO;
    private User testUser;

    @Before
    public void setUp() {
        // Tạo User mẫu để test
        testUser = new User();
        testUser.setUserId(99);
        testUser.setEmail("test@lms.com");
        // Hash mật khẩu "password123"
        String testHash = BCrypt.hashpw("password123", BCrypt.gensalt(10));
        testUser.setPasswordHash(testHash);
        testUser.setStatus("active");
        testUser.setRole("student");
        testUser.setFailedLoginAttempts(0);
        testUser.setLockedUntil(null);

        // Khởi tạo Mock DAO và Inject vào AuthService
        mockUserDAO = new MockUserDAO(testUser);
        authService = new AuthService(mockUserDAO);
    }

    /**
     * Test verifyPassword khi nhập đúng mật khẩu.
     */
    @Test
    public void testVerifyPasswordCorrect() {
        boolean result = authService.verifyPassword("password123", testUser.getPasswordHash());
        assertTrue("Mật khẩu đúng phải xác thực thành công", result);
    }

    /**
     * Test verifyPassword khi nhập sai mật khẩu.
     */
    @Test
    public void testVerifyPasswordWrong() {
        boolean result = authService.verifyPassword("wrongpassword", testUser.getPasswordHash());
        assertFalse("Mật khẩu sai phải xác thực thất bại", result);
    }

    /**
     * Test isAccountLocked khi tài khoản không bị khóa (status = active).
     */
    @Test
    public void testIsAccountLockedFalse() {
        boolean result = authService.isAccountLocked(testUser);
        assertFalse("Tài khoản active không được tính là bị khóa", result);
    }

    /**
     * Test isAccountLocked khi tài khoản bị khóa và thời hạn khóa ở tương lai.
     */
    @Test
    public void testIsAccountLockedTrueFuture() {
        testUser.setStatus("locked");
        // Khóa đến 10 phút sau
        Timestamp futureTime = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000);
        testUser.setLockedUntil(futureTime);

        boolean result = authService.isAccountLocked(testUser);
        assertTrue("Tài khoản bị khóa và thời hạn khóa chưa hết phải trả về true", result);
    }

    /**
     * Test isAccountLocked khi tài khoản bị khóa nhưng thời hạn khóa đã qua.
     */
    @Test
    public void testIsAccountLockedFalseExpired() {
        testUser.setStatus("locked");
        // Thời hạn khóa cách đây 10 phút
        Timestamp pastTime = new Timestamp(System.currentTimeMillis() - 10 * 60 * 1000);
        testUser.setLockedUntil(pastTime);

        boolean result = authService.isAccountLocked(testUser);
        assertFalse("Tài khoản đã hết thời hạn khóa phải trả về false", result);
    }

    /**
     * Test isAccountLocked khi tài khoản bị khóa bởi admin (lockedUntil = null).
     */
    @Test
    public void testIsAccountLockedAdmin() {
        testUser.setStatus("locked");
        testUser.setLockedUntil(null);
        testUser.setLockReason("adminban");

        boolean result = authService.isAccountLocked(testUser);
        assertTrue("Tài khoản bị khóa bởi admin (lockedUntil = null) phải trả về true", result);
    }

    /**
     * Test handleFailedLogin bình thường (chưa đạt ngưỡng 5 lần).
     */
    @Test
    public void testHandleFailedLoginNormal() {
        testUser.setFailedLoginAttempts(2);

        int attempts = authService.handleFailedLogin(testUser);
        
        assertEquals("Số lần đăng nhập sai phải tăng lên 3", 3, attempts);
        assertEquals("Số lần sai trong đối tượng phải là 3", 3, testUser.getFailedLoginAttempts());
        assertEquals("Phải gọi UserDAO để lưu số lần sai là 3 vào DB", 3, mockUserDAO.updateAttemptsCalledWith);
        assertFalse("Tài khoản không được bị khóa", mockUserDAO.lockAccountCalled);
    }

    /**
     * Test handleFailedLogin khi đạt ngưỡng 5 lần sai liên tiếp -> Tự động khóa tài khoản.
     */
    @Test
    public void testHandleFailedLoginThreshold() {
        testUser.setFailedLoginAttempts(4);

        int attempts = authService.handleFailedLogin(testUser);

        assertEquals("Khi bị khóa, hàm phải trả về 5", 5, attempts);
        assertTrue("Hàm lockAccount của UserDAO phải được gọi", mockUserDAO.lockAccountCalled);
        assertEquals("Trạng thái User phải chuyển sang locked", "locked", testUser.getStatus());
        assertEquals("Số lần sai phải được reset về 0 trong thực thể", 0, testUser.getFailedLoginAttempts());
    }

    /**
     * Test generateRandomPassword có độ dài chính xác là 8.
     */
    @Test
    public void testGenerateRandomPasswordLength() {
        String pwd = authService.generateRandomPassword();
        assertNotNull("Mật khẩu sinh ra không được null", pwd);
        assertEquals("Độ dài mật khẩu sinh ra phải bằng 8", 8, pwd.length());
    }

    /**
     * Test resetPassword cho email tồn tại.
     */
    @Test
    public void testResetPasswordSuccess() {
        String rawPassword = authService.resetPassword("test@lms.com");

        assertNotNull("Mật khẩu sinh ra để gửi mail không được null", rawPassword);
        assertEquals("Mật khẩu ngẫu nhiên phải có độ dài là 8", 8, rawPassword.length());
        assertNotNull("Hàm cập nhật mật khẩu mã hóa trong CSDL phải được gọi", mockUserDAO.updatePasswordHashCalledWith);
        assertTrue("Mật khẩu hash mới lưu vào DB phải khớp với mật khẩu raw trả về", 
                BCrypt.checkpw(rawPassword, mockUserDAO.updatePasswordHashCalledWith));
    }

    /**
     * Test resetPassword cho email không tồn tại.
     */
    @Test
    public void testResetPasswordNotFound() {
        String rawPassword = authService.resetPassword("nonexistent@lms.com");
        assertNull("Reset email không tồn tại phải trả về null", rawPassword);
        assertNull("Không được gọi hàm lưu CSDL", mockUserDAO.updatePasswordHashCalledWith);
    }

    /**
     * Mock class kế thừa UserDAO để giả lập dữ liệu tĩnh không chạm tới DB.
     */
    private static class MockUserDAO extends UserDAO {
        private User testUser;
        private boolean lockAccountCalled = false;
        private int updateAttemptsCalledWith = -1;
        private String updatePasswordHashCalledWith = null;

        public MockUserDAO(User testUser) {
            this.testUser = testUser;
        }

        @Override
        public User findByEmail(String email) {
            if (testUser != null && testUser.getEmail().equals(email)) {
                return testUser;
            }
            return null;
        }

        @Override
        public void updateFailedAttempts(int userId, int attempts) {
            this.updateAttemptsCalledWith = attempts;
            if (testUser != null && testUser.getUserId() == userId) {
                testUser.setFailedLoginAttempts(attempts);
            }
        }

        @Override
        public void lockAccount(int userId) {
            this.lockAccountCalled = true;
            if (testUser != null && testUser.getUserId() == userId) {
                testUser.setStatus("locked");
                testUser.setFailedLoginAttempts(0);
            }
        }

        @Override
        public void updatePasswordHash(int userId, String newHash) {
            this.updatePasswordHashCalledWith = newHash;
            if (testUser != null && testUser.getUserId() == userId) {
                testUser.setPasswordHash(newHash);
            }
        }
    }
}
