package util;

import org.junit.Test;
import static org.junit.Assert.*;

public class GoogleSSOUtilTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testGetLoginUrlContainsOAuthParams() {
        String url = GoogleSSOUtil.getLoginUrl();
        assertNotNull("Google Login URL không được null", url);
        assertTrue("URL phải chứa endpoint OAuth của Google", url.startsWith(GoogleSSOUtil.AUTH_URI));
        assertTrue("URL phải chứa scope email profile", url.contains("scope=email%20profile"));
        assertTrue("URL phải chứa response_type=code", url.contains("response_type=code"));
    }

    @Test
    public void testConstantsNotNull() {
        assertNotNull("CLIENT_ID không được null", GoogleSSOUtil.CLIENT_ID);
        assertNotNull("CLIENT_SECRET không được null", GoogleSSOUtil.CLIENT_SECRET);
        assertNotNull("REDIRECT_URI không được null", GoogleSSOUtil.REDIRECT_URI);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testGetTokenInvalidCodeThrowsException() throws Exception {
        // Code không hợp lệ gửi tới Google OAuth endpoint sẽ bị ném Exception
        GoogleSSOUtil.getToken("invalid_dummy_code_12345");
    }

    @Test(expected = Exception.class)
    public void testGetUserEmailInvalidAccessTokenThrowsException() throws Exception {
        // Access token không hợp lệ gửi tới Google userinfo endpoint sẽ bị ném Exception
        GoogleSSOUtil.getUserEmail("invalid_dummy_access_token_12345");
    }
}
