package f8.step2_service;

import config.AiConfig;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * AiConfigTest — Unit Tests cho AiConfig.
 * Kiểm tra xem API Key được đọc đúng từ System Property và fallback đúng cách.
 */
public class AiConfigTest {

    private String originalSystemProperty;

    @Before
    public void setUp() {
        // Lưu lại giá trị ban đầu để khôi phục sau khi test
        originalSystemProperty = System.getProperty("GEMINI_API_KEY");
    }

    @After
    public void tearDown() {
        // Khôi phục trạng thái ban đầu của system property
        if (originalSystemProperty != null) {
            System.setProperty("GEMINI_API_KEY", originalSystemProperty);
        } else {
            System.clearProperty("GEMINI_API_KEY");
        }
    }

    @Test
    public void testResolveApiKeyFromSystemProperty() {
        System.setProperty("GEMINI_API_KEY", "system_prop_test_key");
        String resolved = AiConfig.resolveApiKey();
        assertEquals("Đọc API Key từ System Property phải khớp", "system_prop_test_key", resolved);
    }

    @Test
    public void testResolveApiKeyDefaultFallback() {
        System.clearProperty("GEMINI_API_KEY");
        String envKey = System.getenv("GEMINI_API_KEY");
        String resolved = AiConfig.resolveApiKey();
        if (envKey != null && !envKey.trim().isEmpty()) {
            assertEquals("Nếu không có System Property nhưng có Env Var, phải đọc Env Var", envKey.trim(), resolved);
        } else {
            assertEquals("Nếu cả hai đều trống, phải trả về MISSING_API_KEY", "MISSING_API_KEY", resolved);
        }
    }
}
