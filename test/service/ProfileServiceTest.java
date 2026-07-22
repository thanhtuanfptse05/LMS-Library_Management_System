package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ProfileServiceTest {

    private ProfileService profileService;

    @Before
    public void setUp() {
        profileService = new ProfileService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("ProfileService instance được tạo thành công", profileService);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testUpdateUserInfoNullNameThrowsException() throws Exception {
        profileService.updateUserInfo(1, null, "0912345678", "Nam", "2000-01-01");
    }

    @Test(expected = Exception.class)
    public void testUpdateUserInfoBlankNameThrowsException() throws Exception {
        profileService.updateUserInfo(1, "   ", "0912345678", "Nam", "2000-01-01");
    }

    @Test(expected = Exception.class)
    public void testUpdateUserInfoInvalidDateFormatThrowsException() throws Exception {
        profileService.updateUserInfo(1, "Nguyễn Văn A", "0912345678", "Nam", "01/01/2000");
    }

    @Test(expected = Exception.class)
    public void testChangePasswordMismatchConfirmPasswordThrowsException() throws Exception {
        profileService.changePassword(1, "OldPw123!", "NewPw123!", "MismatchPw123!");
    }

    @Test(expected = Exception.class)
    public void testChangePasswordWeakPasswordPolicyThrowsException() throws Exception {
        // Mật khẩu yếu (không có ký tự đặc biệt / quá ngắn)
        profileService.changePassword(1, "OldPw123!", "weakpass", "weakpass");
    }
}
