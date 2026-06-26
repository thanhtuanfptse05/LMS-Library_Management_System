package util;

import config.AppConfig;
import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
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
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
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
    private static final String GOOGLE_BOOKS_SEARCH_API =
            "https://www.googleapis.com/books/v1/volumes?q=";
    private static final String OPEN_LIBRARY_COVER =
            "https://covers.openlibrary.org/b/isbn/";
    private static final String OPEN_LIBRARY_COVER_ID =
            "https://covers.openlibrary.org/b/id/";
    private static final String OPEN_LIBRARY_ISBN_API =
            "https://openlibrary.org/isbn/";
    private static final String OPEN_LIBRARY_SEARCH_API =
            "https://openlibrary.org/search.json?";

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
    private static final Pattern COVER_ID_PATTERN =
            Pattern.compile("\"cover_i\"\\s*:\\s*(\\d+)|\"covers\"\\s*:\\s*\\[\\s*(\\d+)");

    private final HttpClient httpClient;
    private final SupabaseStorageClient storageClient;

    // ── Thống kê kết quả ──
    private int totalBooks;
    private int successGoogle;
    private int successOpenLib;
    private int successOpenLibSearch;
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
            CoverCandidate cover = findCover(book, isbnClean);

            if (cover == null) {
                System.out.println("        -> [X] Không tìm thấy ảnh bìa");
                notFoundCount++;
                notFoundList.add(book.isbn + " | " + book.title);
                return;
            }

            String contentType = detectContentType(cover.imageBytes);
            String extension = "image/png".equals(contentType) ? ".png" : ".jpg";
            String fileName = "cover_" + isbnClean + extension;

            String savedPath = uploadImage(fileName, cover.imageBytes, contentType);
            updateBookImagePath(conn, book.bookId, savedPath);

            System.out.printf("        -> [OK] %s | %.1f KB | %s%n",
                    cover.source, cover.imageBytes.length / 1024.0, shortenPath(savedPath));

            if (cover.source.startsWith("Google")) {
                successGoogle++;
            } else if (cover.source.contains("Search")) {
                successOpenLibSearch++;
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

    private CoverCandidate findCover(BookInfo book, String isbnClean)
            throws IOException, InterruptedException {

        List<String> isbnVariants = isbnVariants(isbnClean);

        CoverCandidate cover = fetchGoogleByIsbnVariants(isbnVariants);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        cover = fetchOpenLibraryByIsbnVariants(isbnVariants);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        cover = fetchFromOpenLibrarySearch(book.title, book.author);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        return fetchFromGoogleBooksSearch(book.title, book.author);
    }

    private CoverCandidate fetchGoogleByIsbnVariants(List<String> isbnVariants)
            throws IOException, InterruptedException {

        for (String isbn : isbnVariants) {
            byte[] imageBytes = fetchFromGoogleBooks(isbn);
            if (imageBytes != null) {
                return new CoverCandidate(imageBytes, "Google Books");
            }
        }
        return null;
    }

    private CoverCandidate fetchOpenLibraryByIsbnVariants(List<String> isbnVariants)
            throws IOException, InterruptedException {

        for (String isbn : isbnVariants) {
            byte[] imageBytes = fetchFromOpenLibrary(isbn);
            if (imageBytes != null) {
                return new CoverCandidate(imageBytes, "Open Library ISBN");
            }

            imageBytes = fetchFromOpenLibraryIsbnRecord(isbn);
            if (imageBytes != null) {
                return new CoverCandidate(imageBytes, "Open Library Cover ID");
            }
        }
        return null;
    }

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

    private CoverCandidate fetchFromGoogleBooksSearch(String title, String author)
            throws IOException, InterruptedException {

        String query = "intitle:" + quoteQuery(title);
        if (author != null && !author.isBlank()) {
            query += " inauthor:" + quoteQuery(author);
        }
        String url = GOOGLE_BOOKS_SEARCH_API + encodeQuery(query) + "&maxResults=5";
        HttpResponse<String> response = httpGet(url, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            if (response.statusCode() == 429) {
                System.out.print("[Google Search 429] ");
            }
            return null;
        }

        if (TOTAL_ITEMS_ZERO.matcher(response.body()).find()) {
            return null;
        }

        String thumbnailUrl = extractThumbnailUrl(response.body());
        if (thumbnailUrl == null) {
            return null;
        }
        byte[] imageBytes = downloadImageBytes(improveThumbnailUrl(thumbnailUrl));
        return imageBytes == null ? null : new CoverCandidate(imageBytes, "Google Books Search");
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

    private byte[] fetchFromOpenLibraryIsbnRecord(String isbnClean)
            throws IOException, InterruptedException {

        String url = OPEN_LIBRARY_ISBN_API + isbnClean + ".json";
        HttpResponse<String> response = httpGet(url, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            return null;
        }

        Long coverId = extractCoverId(response.body());
        return coverId == null ? null : fetchFromOpenLibraryCoverId(coverId);
    }

    private CoverCandidate fetchFromOpenLibrarySearch(String title, String author)
            throws IOException, InterruptedException {

        List<String> titleQueries = new ArrayList<>();
        titleQueries.add(cleanTitle(title));
        String shortTitle = titleBeforeSubtitle(title);
        if (!shortTitle.equalsIgnoreCase(titleQueries.get(0))) {
            titleQueries.add(shortTitle);
        }

        for (String titleQuery : titleQueries) {
            CoverCandidate cover = fetchFromOpenLibrarySearch(titleQuery, author, true);
            if (cover != null) {
                return cover;
            }

            cover = fetchFromOpenLibrarySearch(titleQuery, null, false);
            if (cover != null) {
                return cover;
            }
        }
        return null;
    }

    private CoverCandidate fetchFromOpenLibrarySearch(String title, String author, boolean includeAuthor)
            throws IOException, InterruptedException {

        StringBuilder url = new StringBuilder(OPEN_LIBRARY_SEARCH_API)
                .append("title=").append(encodeQuery(title))
                .append("&fields=cover_i,title,author_name,isbn")
                .append("&limit=10");
        if (includeAuthor && author != null && !author.isBlank()) {
            url.append("&author=").append(encodeQuery(author));
        }

        HttpResponse<String> response = httpGet(url.toString(), HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            return null;
        }

        Long coverId = extractCoverId(response.body());
        if (coverId == null) {
            return null;
        }
        byte[] imageBytes = fetchFromOpenLibraryCoverId(coverId);
        return imageBytes == null ? null : new CoverCandidate(imageBytes, "Open Library Search");
    }

    private byte[] fetchFromOpenLibraryCoverId(long coverId)
            throws IOException, InterruptedException {

        for (String size : List.of("L", "M")) {
            String url = OPEN_LIBRARY_COVER_ID + coverId + "-" + size + ".jpg?default=false";
            HttpResponse<byte[]> response = httpGet(url, HttpResponse.BodyHandlers.ofByteArray());
            if (response.statusCode() == 200 && response.body().length >= MIN_IMAGE_SIZE_BYTES) {
                return response.body();
            }
        }
        return null;
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

    private Long extractCoverId(String json) {
        Matcher matcher = COVER_ID_PATTERN.matcher(json);
        while (matcher.find()) {
            String value = matcher.group(1) != null ? matcher.group(1) : matcher.group(2);
            if (value != null) {
                return Long.valueOf(value);
            }
        }
        return null;
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

    private List<String> isbnVariants(String isbn) {
        String digits = isbn == null ? "" : isbn.replaceAll("[^0-9Xx]", "").toUpperCase();
        Set<String> variants = new LinkedHashSet<>();
        if (!digits.isBlank()) {
            variants.add(digits);
        }
        String isbn10 = toIsbn10(digits);
        if (isbn10 != null) {
            variants.add(isbn10);
        }
        String isbn13 = toIsbn13(digits);
        if (isbn13 != null) {
            variants.add(isbn13);
        }
        return new ArrayList<>(variants);
    }

    private String toIsbn10(String isbn) {
        if (isbn == null || isbn.length() != 13 || !isbn.startsWith("978")) {
            return null;
        }
        String core = isbn.substring(3, 12);
        int sum = 0;
        for (int i = 0; i < 9; i++) {
            sum += (10 - i) * Character.digit(core.charAt(i), 10);
        }
        int check = 11 - (sum % 11);
        char checkChar = check == 10 ? 'X' : (check == 11 ? '0' : (char) ('0' + check));
        return core + checkChar;
    }

    private String toIsbn13(String isbn) {
        if (isbn == null || isbn.length() != 10) {
            return null;
        }
        String core = "978" + isbn.substring(0, 9);
        int sum = 0;
        for (int i = 0; i < core.length(); i++) {
            sum += Character.digit(core.charAt(i), 10) * (i % 2 == 0 ? 1 : 3);
        }
        int check = (10 - (sum % 10)) % 10;
        return core + check;
    }

    private String cleanTitle(String title) {
        if (title == null) {
            return "";
        }
        return title.replaceAll("(?i)\\s*\\([^)]*edition[^)]*\\)", "")
                .replaceAll("(?i)\\s*\\d+(st|nd|rd|th)\\s+edition\\s*", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private String titleBeforeSubtitle(String title) {
        String cleaned = cleanTitle(title);
        int colonIndex = cleaned.indexOf(':');
        return colonIndex > 0 ? cleaned.substring(0, colonIndex).trim() : cleaned;
    }

    private String quoteQuery(String value) {
        String cleaned = cleanTitle(value);
        return cleaned.contains(" ") ? "\"" + cleaned + "\"" : cleaned;
    }

    private String encodeQuery(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
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
        System.out.println("|     Tai anh bia sach tu Google Books & Open Library        |");
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
        int totalSuccess = successGoogle + successOpenLib + successOpenLibSearch;
        int totalProcessed = totalSuccess + notFoundCount + errorCount;

        System.out.println();
        System.out.println(repeat('=', 62));
        System.out.println("  BAO CAO KET QUA");
        System.out.println(repeat('=', 62));
        System.out.printf("  Tong sach can xu ly:      %d%n", totalBooks);
        System.out.printf("  [OK] Tai thanh cong:      %d%n", totalSuccess);
        System.out.printf("       +-- Google Books:    %d%n", successGoogle);
        System.out.printf("       +-- OpenLib ISBN:    %d%n", successOpenLib);
        System.out.printf("       +-- OpenLib Search:  %d%n", successOpenLibSearch);
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

    private static class CoverCandidate {
        final byte[] imageBytes;
        final String source;

        CoverCandidate(byte[] imageBytes, String source) {
            this.imageBytes = imageBytes;
            this.source = source;
        }
    }
}
