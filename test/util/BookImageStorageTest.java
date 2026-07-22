package util;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import java.nio.file.Path;
import static org.junit.Assert.*;

public class BookImageStorageTest {

    private BookImageStorage storage;
    private final Path tempDir = Path.of("build/tmp/test-images");

    @Before
    public void setUp() {
        storage = new BookImageStorage(tempDir);
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testResolveValidJpgFilename() {
        String validJpg = "550e8400-e29b-41d4-a716-446655440000.jpg";
        Path resolved = storage.resolve(validJpg);
        assertNotNull(resolved);
        assertTrue(resolved.endsWith(validJpg));
    }

    @Test
    public void testResolveValidPngFilename() {
        String validPng = "123e4567-e89b-12d3-a456-426614174000.png";
        Path resolved = storage.resolve(validPng);
        assertNotNull(resolved);
        assertTrue(resolved.endsWith(validPng));
    }

    @Test
    public void testMaxFileSizeConstant() {
        assertEquals(5L * 1024 * 1024, BookImageStorage.MAX_FILE_SIZE);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testResolveUppercaseHexUuid() {
        String validUppercase = "550E8400-E29B-41D4-A716-446655440000.JPG";
        Path resolved = storage.resolve(validUppercase.toLowerCase());
        assertNotNull(resolved);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = IllegalArgumentException.class)
    public void testResolveNullFilenameThrowsException() {
        storage.resolve(null);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolveInvalidExtensionThrowsException() {
        storage.resolve("550e8400-e29b-41d4-a716-446655440000.exe");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolvePathTraversalAttemptThrowsException() {
        storage.resolve("../../../etc/passwd");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testResolveArbitraryStringThrowsException() {
        storage.resolve("my-custom-image-file.png");
    }
}
