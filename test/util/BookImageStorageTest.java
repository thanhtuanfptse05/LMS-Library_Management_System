package util;

import exception.ValidationException;
import jakarta.servlet.http.Part;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collection;
import java.util.Collections;
import javax.imageio.ImageIO;
import org.junit.Test;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class BookImageStorageTest {

    @Test
    public void saveStoresValidPngImage() throws Exception {
        Path directory = Files.createTempDirectory("book-image-test");
        BookImageStorage storage = new BookImageStorage(directory);
        ByteArrayOutputStream content = new ByteArrayOutputStream();
        ImageIO.write(new BufferedImage(10, 10, BufferedImage.TYPE_INT_RGB), "png", content);

        String fileName = storage.save(new TestPart(
                "imageFile", "cover.png", "image/png", content.toByteArray()));

        assertTrue(fileName.endsWith(".png"));
        assertTrue(Files.isRegularFile(storage.resolve(fileName)));
        storage.deleteQuietly(fileName);
    }

    @Test
    public void saveRejectsNonImageFile() throws Exception {
        Path directory = Files.createTempDirectory("book-image-test");
        BookImageStorage storage = new BookImageStorage(directory);
        Part part = new TestPart("imageFile", "cover.txt", "text/plain", "not an image".getBytes());

        try {
            storage.save(part);
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("JPG hoặc PNG"));
        }
    }

    @Test
    public void resolveRejectsUnsafeFileName() throws Exception {
        BookImageStorage storage = new BookImageStorage(Files.createTempDirectory("book-image-test"));
        try {
            storage.resolve("../secret.png");
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            assertFalse(e.getMessage().isBlank());
        }
    }

    private static class TestPart implements Part {

        private final String name;
        private final String submittedFileName;
        private final String contentType;
        private final byte[] content;

        TestPart(String name, String submittedFileName, String contentType, byte[] content) {
            this.name = name;
            this.submittedFileName = submittedFileName;
            this.contentType = contentType;
            this.content = content;
        }

        @Override public InputStream getInputStream() { return new ByteArrayInputStream(content); }
        @Override public String getContentType() { return contentType; }
        @Override public String getName() { return name; }
        @Override public String getSubmittedFileName() { return submittedFileName; }
        @Override public long getSize() { return content.length; }
        @Override public void write(String fileName) { }
        @Override public void delete() { }
        @Override public String getHeader(String name) { return null; }
        @Override public Collection<String> getHeaders(String name) { return Collections.emptyList(); }
        @Override public Collection<String> getHeaderNames() { return Collections.emptyList(); }
    }
}
