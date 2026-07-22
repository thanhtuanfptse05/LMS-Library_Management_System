package service;

import model.User;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class AuthServiceTest {

    private AuthService authService;

    @Before
    public void setUp() {
        authService = new AuthService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testVerifyPasswordSuccess() {
        String plain = "SecretPassword123";
        String hashed = BCrypt.hashpw(plain, BCrypt.gensalt());

        assertTrue("Mật khẩu khớp với hash BCrypt phải trả về true",
                authService.verifyPassword(plain, hashed));
    }

    @Test
    public void testVerifyPasswordWrongPassword() {
        String plain = "SecretPassword123";
        String hashed = BCrypt.hashpw(plain, BCrypt.gensalt());

        assertFalse("Mật khẩu sai phải trả về false",
                authService.verifyPassword("WrongPassword123", hashed));
    }

    @Test
    public void testIsAccountNotLockedForActiveUser() {
        User user = new User();
        user.setStatus("active");
        assertFalse("Tài khoản active không bị khóa", authService.isAccountLocked(user));
    }

    @Test
    public void testIsAccountLockedPermanentlyByAdmin() {
        User user = new User();
        user.setStatus("locked");
        user.setLockedUntil(null); // Khóa vĩnh viễn bởi Admin
        assertTrue("Tài khoản status=locked với lockedUntil=null bị khóa vĩnh viễn",
                authService.isAccountLocked(user));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testIsAccountLockedFutureTimestamp() {
        User user = new User();
        user.setStatus("locked");
        // Khóa đến 30 phút sau
        user.setLockedUntil(new Timestamp(System.currentTimeMillis() + 1800000));
        assertTrue("Tài khoản bị khóa đến tương lai", authService.isAccountLocked(user));
    }

    @Test
    public void testIsAccountLockedExpiredTimestamp() {
        User user = new User();
        user.setStatus("locked");
        // Thời hạn khóa đã trôi qua (10 giây trước)
        user.setLockedUntil(new Timestamp(System.currentTimeMillis() - 10000));
        assertFalse("Thời hạn khóa đã hết phải trả về false", authService.isAccountLocked(user));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testVerifyPasswordNullPlainOrHash() {
        String hashed = BCrypt.hashpw("Password123", BCrypt.gensalt());
        assertFalse("Mật khẩu plain null trả về false", authService.verifyPassword(null, hashed));
        assertFalse("Hash null trả về false", authService.verifyPassword("Password123", null));
    }

    @Test
    public void testVerifyPasswordInvalidHashPrefix() {
        // MD5 hoặc Plaintext hash không đúng định dạng $2a$
        assertFalse("Hash MD5 không hợp lệ trả về false",
                authService.verifyPassword("Password123", "5f4dcc3b5aa765d61d8327deb882cf99"));
    }

    @Test
    public void testIsAccountLockedNullUser() {
        assertFalse("User null không văng Exception và trả về false", authService.isAccountLocked(null));
    }
}
