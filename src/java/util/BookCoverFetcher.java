package util;

import config.AppConfig;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * BookCoverFetcher — Tool standalone tải ảnh bìa sách hàng loạt.
 *
 * <p>Luồng xử lý:
 * <ol>
 *   <li>Đọc danh sách sách từ DB (chỉ lấy sách chưa có imagePath)</li>
 *   <li>Tìm ảnh bìa qua Google Books API (ưu tiên) → Open Library Covers (fallback)</li>
 *   <li>Upload ảnh lên Supabase Storage bucket "book-covers"</li>
 *   <li>Cập nhật cột imagePath trong bảng Book thành URL public</li>
 * </ol>
 *
 * <p>Chạy: Run {@code main()} từ IDE (NetBeans) hoặc command line.</p>
 *
 * <p><strong>Yêu cầu biến môi trường (cho Supabase Storage):</strong></p>
 * <ul>
 *   <li>{@code SUPABASE_URL} — URL của project Supabase</li>
 *   <li>{@code SUPABASE_SERVICE_ROLE_KEY} — Service Role Key</li>
 *   <li>{@code SUPABASE_BOOK_COVER_BUCKET} — Tên bucket (mặc định: "book-covers")</li>
 * </ul>
 */
public class BookCoverFetcher {

    // ── API Endpoints ──
    private static final String GOOGLE_BOOKS_API =
            "https://www.googleapis.com/books/v1/volumes?q=isbn:";
    private static final String OPEN_LIBRARY_COVER =
            "https://covers.openlibrary.org/b/isbn/";

    // ── Cấu hình ──
    private static final int DELAY_BETWEEN_BOOKS_MS = 600;
    private static final int DELAY_BEFORE_FALLBACK_MS = 300;
    private static final int MAX_RETRIES = 2;
    private static final int MIN_IMAGE_SIZE_BYTES = 1000;
    private static final Duration HTTP_TIMEOUT = Duration.ofSeconds(15);

    // ── Regex patterns ──
    private static final Pattern THUMBNAIL_PATTERN =
            Pattern.compile("\"thumbnail\"\\s*:\\s*\"([^\"]+)\"");
    private static final Pattern TOTAL_ITEMS_ZERO =
            Pattern.compile("\"totalItems\"\\s*:\\s*0");

    private final HttpClient httpClient;
    private final SupabaseStorageClient storageClient;

    // ── Thống kê kết quả ──
    private int totalBooks;
    private int successGoogle;
    private int successOpenLib;
    private int notFoundCount;
    private int errorCount;
    private final List<String> notFoundList = new ArrayList<>();
    private final List<String> errorList = new ArrayList<>();

    public BookCoverFetcher() {
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .connectTimeout(HTTP_TIMEOUT)
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();
        this.storageClient = new SupabaseStorageClient();
    }

    // ═════════════════════════════════════════════════════════════════
    // Entry Point
    // ═════════════════════════════════════════════════════════════════

    public static void main(String[] args) {
        new BookCoverFetcher().run();
    }

    /**
     * Chạy toàn bộ luồng tải ảnh bìa:
     * Kết nối DB → Lấy sách chưa có ảnh → Tải & upload → Cập nhật DB → Báo cáo.
     */
    public void run() {
        printBanner();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(true);

            List<BookInfo> books = loadBooksWithoutCover(conn);
            totalBooks = books.size();

            if (totalBooks == 0) {
                System.out.println("[OK] Tất cả sách đã có ảnh bìa. Không cần xử lý.");
                return;
            }

            System.out.printf("[i] Cần tải ảnh cho %d cuốn sách%n", totalBooks);
            System.out.println(repeat('-', 62));
            System.out.println();

            for (int i = 0; i < books.size(); i++) {
                processBook(conn, books.get(i), i + 1);
            }

            printReport();

        } catch (SQLException e) {
            System.err.println("[X] Lỗi kết nối CSDL: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ═════════════════════════════════════════════════════════════════
    // Xử lý từng cuốn sách
    // ═════════════════════════════════════════════════════════════════

    private void processBook(Connection conn, BookInfo book, int index) {
        System.out.printf("  [%d/%d] %s (ISBN: %s)%n", index, totalBooks, book.title, book.isbn);

        String isbnClean = book.isbn.replace("-", "");

        try {
            // Bước 1: Thử Google Books API
            byte[] imageBytes = fetchFromGoogleBooks(isbnClean);
            String source = "Google Books";

            // Bước 2: Fallback sang Open Library
            if (imageBytes == null) {
                Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
                imageBytes = fetchFromOpenLibrary(isbnClean);
                source = "Open Library";
            }

            // Bước 3: Không tìm thấy ở cả hai nguồn
            if (imageBytes == null) {
                System.out.println("        -> [X] Không tìm thấy ảnh bìa");
                notFoundCount++;
                notFoundList.add(book.isbn + " | " + book.title);
                return;
            }

            // Bước 4: Upload ảnh và cập nhật DB
            String contentType = detectContentType(imageBytes);
            String extension = "image/png".equals(contentType) ? ".png" : ".jpg";
            String fileName = "cover_" + isbnClean + extension;

            String savedPath = uploadImage(fileName, imageBytes, contentType);
            updateBookImagePath(conn, book.bookId, savedPath);

            System.out.printf("        -> [OK] %s | %.1f KB | %s%n",
                    source, imageBytes.length / 1024.0, shortenPath(savedPath));

            if ("Google Books".equals(source)) {
                successGoogle++;
            } else {
                successOpenLib++;
            }

            // Rate limiting giữa các cuốn sách
            Thread.sleep(DELAY_BETWEEN_BOOKS_MS);

        } catch (Exception e) {
            System.out.println("        -> [X] Lỗi: " + e.getMessage());
            errorCount++;
            errorList.add(book.isbn + " | " + book.title + " -> " + e.getMessage());
        }
    }

    // ═════════════════════════════════════════════════════════════════
    // Tìm ảnh bìa từ API
    // ═════════════════════════════════════════════════════════════════

    /**
     * Tìm ảnh bìa từ Google Books API theo ISBN.
     *
     * @param isbnClean ISBN không có dấu gạch ngang
     * @return byte[] ảnh hoặc null nếu không tìm thấy
     */
    private byte[] fetchFromGoogleBooks(String isbnClean)
            throws IOException, InterruptedException {

        String url = GOOGLE_BOOKS_API + isbnClean;
        HttpResponse<String> response = httpGet(url, HttpResponse.BodyHandlers.ofString());

        // 429 = Rate Limited hoac bat ky loi nao khac -> tra null de fallback Open Library
        if (response.statusCode() != 200) {
            if (response.statusCode() == 429) {
                System.out.print("[Google 429 Rate Limit -> fallback OL] ");
            }
            return null;
        }

        String json = response.body();

        // Kiểm tra kết quả rỗng
        if (TOTAL_ITEMS_ZERO.matcher(json).find()) {
            return null;
        }

        // Trích xuất URL ảnh thumbnail
        String thumbnailUrl = extractThumbnailUrl(json);
        if (thumbnailUrl == null) {
            return null;
        }

        // Nâng cấp chất lượng ảnh
        thumbnailUrl = improveThumbnailUrl(thumbnailUrl);

        // Tải ảnh về
        return downloadImageBytes(thumbnailUrl);
    }

    /**
     * Tìm ảnh bìa từ Open Library Covers API theo ISBN.
     * Sử dụng kích thước "L" (Large) và {@code ?default=false} để nhận 404 khi không có ảnh.
     *
     * @param isbnClean ISBN không có dấu gạch ngang
     * @return byte[] ảnh hoặc null nếu không tìm thấy
     */
    private byte[] fetchFromOpenLibrary(String isbnClean)
            throws IOException, InterruptedException {

        String url = OPEN_LIBRARY_COVER + isbnClean + "-L.jpg?default=false";
        HttpResponse<byte[]> response = httpGet(url, HttpResponse.BodyHandlers.ofByteArray());

        if (response.statusCode() != 200) {
            return null;
        }

        byte[] body = response.body();
        return body.length >= MIN_IMAGE_SIZE_BYTES ? body : null;
    }

    // ═════════════════════════════════════════════════════════════════
    // Upload & Cập nhật DB
    // ═════════════════════════════════════════════════════════════════

    /**
     * Upload ảnh lên Supabase Storage hoặc lưu local (fallback).
     *
     * @return đường dẫn/URL đã lưu để ghi vào DB
     */
    private String uploadImage(String fileName, byte[] imageBytes, String contentType)
            throws IOException, InterruptedException {

        if (storageClient.isConfigured()) {
            return storageClient.uploadPublicObject(fileName, imageBytes, contentType);
        }

        // Fallback: lưu file local
        Path dir = Path.of(AppConfig.BOOK_IMAGE_DIRECTORY);
        Files.createDirectories(dir);
        Path destination = dir.resolve(fileName);
        Files.write(destination, imageBytes,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
        return fileName;
    }

    /**
     * Cập nhật cột imagePath trong bảng Book.
     * Sử dụng PreparedStatement để chống SQL Injection (SEC-03).
     */
    private void updateBookImagePath(Connection conn, int bookId, String imagePath)
            throws SQLException {

        String sql = "UPDATE Book SET imagePath = ?, updatedAt = NOW() WHERE bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imagePath);
            ps.setInt(2, bookId);
            ps.executeUpdate();
        }
    }

    // ═════════════════════════════════════════════════════════════════
    // HTTP Client Helpers
    // ═════════════════════════════════════════════════════════════════

    /**
     * Gửi HTTP GET request với cơ chế retry (tối đa {@value MAX_RETRIES} lần)
     * và exponential backoff khi gặp lỗi 429/5xx hoặc IOException.
     */
    private <T> HttpResponse<T> httpGet(String url, HttpResponse.BodyHandler<T> handler)
            throws IOException, InterruptedException {

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(HTTP_TIMEOUT)
                .header("User-Agent", "LMS-BookCoverFetcher/1.0")
                .GET()
                .build();

        IOException lastException = null;

        for (int attempt = 0; attempt <= MAX_RETRIES; attempt++) {
            try {
                HttpResponse<T> response = httpClient.send(request, handler);

                // Chi retry khi gap loi server 5xx, tra ve ngay voi 429 de caller xu ly
                if (response.statusCode() >= 500) {
                    Thread.sleep(1000L * (attempt + 1));
                    continue;
                }
                return response;

            } catch (IOException e) {
                lastException = e;
                if (attempt < MAX_RETRIES) {
                    Thread.sleep(1000L * (attempt + 1));
                }
            }
        }

        throw lastException != null
                ? lastException
                : new IOException("Đã vượt quá số lần thử lại cho: " + url);
    }

    // ═════════════════════════════════════════════════════════════════
    // Parsing & Image Helpers
    // ═════════════════════════════════════════════════════════════════

    /**
     * Trích xuất URL thumbnail từ JSON response của Google Books API.
     * Sử dụng regex thay vì JSON library để không thêm dependency.
     */
    private String extractThumbnailUrl(String json) {
        Matcher matcher = THUMBNAIL_PATTERN.matcher(json);
        return matcher.find() ? matcher.group(1) : null;
    }

    /**
     * Cải thiện URL thumbnail từ Google Books:
     * - Decode ký tự unicode escaped ({@code \u0026} → {@code &})
     * - Chuyển HTTP → HTTPS
     * - Tăng zoom 1 → 2 để lấy ảnh lớn hơn
     * - Loại bỏ hiệu ứng viền cuộn (edge=curl)
     */
    private String improveThumbnailUrl(String url) {
        url = url.replace("\\u0026", "&");
        url = url.replace("http://", "https://");
        url = url.replace("zoom=1", "zoom=2");
        url = url.replace("&edge=curl", "");
        return url;
    }

    /**
     * Tải ảnh từ URL về dưới dạng byte[].
     * Trả về null nếu ảnh quá nhỏ (có thể là placeholder).
     */
    private byte[] downloadImageBytes(String imageUrl)
            throws IOException, InterruptedException {

        HttpResponse<byte[]> response = httpGet(imageUrl, HttpResponse.BodyHandlers.ofByteArray());

        if (response.statusCode() != 200) {
            return null;
        }

        byte[] body = response.body();
        return body.length >= MIN_IMAGE_SIZE_BYTES ? body : null;
    }

    /**
     * Phát hiện Content-Type bằng magic bytes (file signature).
     * PNG bắt đầu bằng 0x89504E47, còn lại mặc định là JPEG.
     */
    private String detectContentType(byte[] imageBytes) {
        if (imageBytes.length >= 4
                && imageBytes[0] == (byte) 0x89
                && imageBytes[1] == (byte) 0x50
                && imageBytes[2] == (byte) 0x4E
                && imageBytes[3] == (byte) 0x47) {
            return "image/png";
        }
        return "image/jpeg";
    }

    // ═════════════════════════════════════════════════════════════════
    // Database Query
    // ═════════════════════════════════════════════════════════════════

    /**
     * Lấy danh sách tất cả sách chưa có ảnh bìa (imagePath IS NULL hoặc rỗng).
     * Chỉ lấy sách có trạng thái 'available'.
     */
    private List<BookInfo> loadBooksWithoutCover(Connection conn) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author FROM Book "
                + "WHERE (imagePath IS NULL OR imagePath = '') "
                + "AND status = 'available' "
                + "ORDER BY bookId";

        List<BookInfo> books = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(new BookInfo(
                        rs.getInt("bookId"),
                        rs.getString("isbn"),
                        rs.getString("title"),
                        rs.getString("author")));
            }
        }
        return books;
    }

    // ═════════════════════════════════════════════════════════════════
    // Console Output
    // ═════════════════════════════════════════════════════════════════

    private void printBanner() {
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        System.out.println();
        System.out.println("+==========================================================+");
        System.out.println("|     BOOK COVER FETCHER - LMS Library System              |");
        System.out.println("|     Tai anh bia sach hang loat tu Google Books & OL       |");
        System.out.println("+==========================================================+");
        System.out.println("  Thoi gian: " + timestamp);

        if (storageClient.isConfigured()) {
            System.out.println("  Storage:   Supabase Storage -> bucket 'book-covers'");
        } else {
            System.out.println("  Storage:   Local -> " + AppConfig.BOOK_IMAGE_DIRECTORY);
            System.out.println("  [!] Supabase Storage chua cau hinh: "
                    + storageClient.getConfigurationStatus());
        }
        System.out.println();
    }

    private void printReport() {
        int totalSuccess = successGoogle + successOpenLib;
        int totalProcessed = totalSuccess + notFoundCount + errorCount;

        System.out.println();
        System.out.println(repeat('=', 62));
        System.out.println("  BAO CAO KET QUA");
        System.out.println(repeat('=', 62));
        System.out.printf("  Tong sach can xu ly:      %d%n", totalBooks);
        System.out.printf("  [OK] Tai thanh cong:      %d%n", totalSuccess);
        System.out.printf("       +-- Google Books:    %d%n", successGoogle);
        System.out.printf("       +-- Open Library:    %d%n", successOpenLib);
        System.out.printf("  [X]  Khong tim thay:      %d%n", notFoundCount);
        System.out.printf("  [X]  Loi:                 %d%n", errorCount);

        if (!notFoundList.isEmpty()) {
            System.out.println();
            System.out.println("  -- Sach khong tim thay anh --");
            for (String item : notFoundList) {
                System.out.println("    * " + item);
            }
        }

        if (!errorList.isEmpty()) {
            System.out.println();
            System.out.println("  -- Sach bi loi --");
            for (String item : errorList) {
                System.out.println("    * " + item);
            }
        }

        System.out.println(repeat('=', 62));

        if (totalSuccess > 0) {
            System.out.println();
            System.out.printf("  >> Da cap nhat imagePath cho %d/%d sach thanh cong.%n",
                    totalSuccess, totalBooks);
        }
        System.out.println();
    }

    private static String shortenPath(String path) {
        if (path == null) {
            return "null";
        }
        if (path.length() <= 70) {
            return path;
        }
        return path.substring(0, 67) + "...";
    }

    private static String repeat(char c, int count) {
        return String.valueOf(c).repeat(count);
    }

    // ═════════════════════════════════════════════════════════════════
    // Data class
    // ═════════════════════════════════════════════════════════════════

    /**
     * DTO nội bộ chứa thông tin sách cần xử lý.
     */
    private static class BookInfo {
        final int bookId;
        final String isbn;
        final String title;
        final String author;

        BookInfo(int bookId, String isbn, String title, String author) {
            this.bookId = bookId;
            this.isbn = isbn;
            this.title = title;
            this.author = author;
        }
    }
}
