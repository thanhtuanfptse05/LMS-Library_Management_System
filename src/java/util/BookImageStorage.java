package util;

import config.AppConfig;
import exception.ValidationException;
import jakarta.servlet.http.Part;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

public class BookImageStorage {

    public static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final int MAX_IMAGE_DIMENSION = 6000;
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of("image/jpeg", "image/png");
    private static final Logger LOGGER = Logger.getLogger(BookImageStorage.class.getName());
    private final Path storageDirectory;
    private final SupabaseStorageClient supabaseStorageClient;

    public BookImageStorage() {
        this(Path.of(AppConfig.BOOK_IMAGE_DIRECTORY), new SupabaseStorageClient());
    }

    public BookImageStorage(Path storageDirectory) {
        this(storageDirectory, new SupabaseStorageClient());
    }

    BookImageStorage(Path storageDirectory, SupabaseStorageClient supabaseStorageClient) {
        this.storageDirectory = storageDirectory.toAbsolutePath().normalize();
        this.supabaseStorageClient = supabaseStorageClient;
    }

    public String save(Part imagePart) throws IOException, ValidationException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }
        if (imagePart.getSize() > MAX_FILE_SIZE) {
            throw new ValidationException("Ảnh bìa không được vượt quá 5 MB.");
        }
        if (!ALLOWED_CONTENT_TYPES.contains(imagePart.getContentType())) {
            throw new ValidationException("Ảnh bìa chỉ chấp nhận định dạng JPG hoặc PNG.");
        }
        byte[] imageBytes;
        try (InputStream input = imagePart.getInputStream()) {
            imageBytes = input.readAllBytes();
        }
        try (InputStream input = new ByteArrayInputStream(imageBytes)) {
            BufferedImage image = ImageIO.read(input);
            if (image == null || image.getWidth() < 1 || image.getHeight() < 1) {
                throw new ValidationException("Tệp ảnh bìa không hợp lệ.");
            }
            if (image.getWidth() > MAX_IMAGE_DIMENSION || image.getHeight() > MAX_IMAGE_DIMENSION) {
                throw new ValidationException("Kích thước ảnh bìa không được vượt quá 6000 x 6000 pixel.");
            }
        }

        String extension = "image/png".equals(imagePart.getContentType()) ? ".png" : ".jpg";
        String fileName = UUID.randomUUID() + extension;
        if (supabaseStorageClient.isConfigured()) {
            try {
                String publicUrl = supabaseStorageClient.uploadPublicObject(
                        fileName, imageBytes, imagePart.getContentType());
                LOGGER.log(Level.INFO, "Đã upload ảnh bìa lên Supabase Storage: {0}", fileName);
                return publicUrl;
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new IOException("Upload ảnh bìa bị gián đoạn.", e);
            }
        }

        LOGGER.log(Level.WARNING, "Supabase Storage chưa được cấu hình, lưu ảnh bìa local. {0}",
                supabaseStorageClient.getConfigurationStatus());
        Files.createDirectories(storageDirectory);
        Path destination = resolve(fileName);
        try (InputStream input = new ByteArrayInputStream(imageBytes)) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            Files.deleteIfExists(destination);
            throw e;
        }
        return fileName;
    }

    public Path resolve(String fileName) {
        if (fileName == null || !fileName.matches("[a-fA-F0-9-]+\\.(jpg|png)")) {
            throw new IllegalArgumentException("Tên tệp ảnh không hợp lệ.");
        }
        Path resolved = storageDirectory.resolve(fileName).normalize();
        if (!resolved.startsWith(storageDirectory)) {
            throw new IllegalArgumentException("Đường dẫn ảnh không hợp lệ.");
        }
        return resolved;
    }

    public void deleteQuietly(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            return;
        }
        if (fileName.startsWith("http://") || fileName.startsWith("https://")) {
            return;
        }
        try {
            Files.deleteIfExists(resolve(fileName));
        } catch (IOException | IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Không thể xóa tệp ảnh bìa cũ: " + fileName, e);
        }
    }
}
