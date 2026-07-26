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
    public void testExtractObjectNameFromOwnBucketUrl() {
        String publicUrl = "https://xyz.supabase.co/storage/v1/object/public/book-covers/sample-cover.jpg";
        assertEquals("Phải tách được tên tệp từ URL public của bucket đang cấu hình",
                "sample-cover.jpg", configuredClient.extractObjectName(publicUrl));
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

    @Test
    public void testExtractObjectNameStripsQueryString() {
        String publicUrl = "https://xyz.supabase.co/storage/v1/object/public/book-covers/cover.png?width=200";
        assertEquals("cover.png", configuredClient.extractObjectName(publicUrl));
    }

    @Test
    public void testExtractObjectNameRoundTripsPublicObjectUrl() {
        String fileName = "3f2504e0-4f89-11d3-9a0c-0305e82c3301.jpg";
        assertEquals(fileName, configuredClient.extractObjectName(configuredClient.publicObjectUrl(fileName)));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testExtractObjectNameRejectsForeignUrl() {
        assertNull("Ảnh bìa từ nguồn ngoài không thuộc bucket nên không được phép xóa",
                configuredClient.extractObjectName("https://books.google.com/covers/abc.jpg"));
    }

    @Test
    public void testExtractObjectNameRejectsOtherBucketUrl() {
        assertNull("URL thuộc bucket khác không được nhận nhầm là object của bucket đang cấu hình",
                configuredClient.extractObjectName(
                        "https://xyz.supabase.co/storage/v1/object/public/avatars/cover.jpg"));
    }

    @Test
    public void testExtractObjectNameOnUnconfiguredClientReturnsNull() {
        assertNull(unconfiguredClient.extractObjectName(
                "https://xyz.supabase.co/storage/v1/object/public/book-covers/cover.jpg"));
    }

    @Test
    public void testExtractObjectNameNullInput() {
        assertNull(configuredClient.extractObjectName(null));
    }

    @Test(expected = IllegalStateException.class)
    public void testDeleteObjectUnconfiguredThrowsException() throws Exception {
        unconfiguredClient.deleteObject("sample.jpg");
    }

    @Test(expected = IllegalStateException.class)
    public void testPublicObjectUrlUnconfiguredThrowsException() {
        unconfiguredClient.publicObjectUrl("sample.jpg");
    }

    @Test(expected = IllegalStateException.class)
    public void testUploadPublicObjectUnconfiguredThrowsException() throws Exception {
        unconfiguredClient.uploadPublicObject("sample.jpg", new byte[0], "image/jpeg");
    }
}
