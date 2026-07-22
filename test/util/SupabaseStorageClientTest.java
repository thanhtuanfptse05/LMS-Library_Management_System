package util;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class SupabaseStorageClientTest {

    private SupabaseStorageClient configuredClient;
    private SupabaseStorageClient unconfiguredClient;

    @Before
    public void setUp() {
        configuredClient = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                "https://xyz.supabase.co",
                "test-service-role-key-123456",
                "book-covers"
        );
        unconfiguredClient = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                null,
                null,
                null
        );
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testIsConfiguredTrue() {
        assertTrue("Client có cấu hình hợp lệ phải trả về true", configuredClient.isConfigured());
    }

    @Test
    public void testIsConfiguredFalse() {
        assertFalse("Client thiếu cấu hình phải trả về false", unconfiguredClient.isConfigured());
    }

    @Test
    public void testPublicObjectUrlGeneration() {
        String fileName = "sample-cover.jpg";
        String expectedUrl = "https://xyz.supabase.co/storage/v1/object/public/book-covers/sample-cover.jpg";
        assertEquals(expectedUrl, configuredClient.publicObjectUrl(fileName));
    }

    @Test
    public void testGetConfigurationStatus() {
        String status = configuredClient.getConfigurationStatus();
        assertNotNull(status);
        assertTrue(status.contains("supabaseUrl=present"));
        assertTrue(status.contains("serviceRoleKey=present"));
        assertTrue(status.contains("bucket=book-covers"));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testUrlNormalizationWithTrailingSlashes() {
        SupabaseStorageClient clientWithSlashes = new SupabaseStorageClient(
                java.net.http.HttpClient.newHttpClient(),
                "https://xyz.supabase.co/rest/v1/",
                "key",
                "covers"
        );
        assertEquals("https://xyz.supabase.co/storage/v1/object/public/covers/test.png", clientWithSlashes.publicObjectUrl("test.png"));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = IllegalStateException.class)
    public void testPublicObjectUrlUnconfiguredThrowsException() {
        unconfiguredClient.publicObjectUrl("sample.jpg");
    }

    @Test(expected = IllegalStateException.class)
    public void testUploadPublicObjectUnconfiguredThrowsException() throws Exception {
        unconfiguredClient.uploadPublicObject("sample.jpg", new byte[0], "image/jpeg");
    }
}
