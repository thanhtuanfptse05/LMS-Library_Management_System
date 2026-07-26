package util;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import config.AiConfig;
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
    private static final int MAX_AI_QUERY_COUNT = 5;
    private static final int MIN_SEARCH_MATCH_SCORE = 55;
    private static final int MIN_AI_MATCH_SCORE = 65;
    private static final int REMOTE_COVER_CHECK_LIMIT = 300;
    private static final int MIN_IMAGE_SIZE_BYTES = 1000;
    private static final Duration HTTP_TIMEOUT = Duration.ofSeconds(15);

    // ── Regex patterns ──
    private static final Pattern THUMBNAIL_PATTERN =
            Pattern.compile("\"thumbnail\"\\s*:\\s*\"([^\"]+)\"");
    private static final Pattern TOTAL_ITEMS_ZERO =
            Pattern.compile("\"totalItems\"\\s*:\\s*0");
    private static final Pattern COVER_ID_PATTERN =
            Pattern.compile("\"cover_i\"\\s*:\\s*(\\d+)|\"covers\"\\s*:\\s*\\[\\s*(\\d+)");
    private static final Pattern GOOGLE_IMAGE_LINK_PATTERN =
            Pattern.compile("\"(?:thumbnail|smallThumbnail)\"\\s*:\\s*\"([^\"]+)\"");

    private final HttpClient httpClient;
    private final SupabaseStorageClient storageClient;
    private final boolean forceRefresh;

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
        this(false);
    }

    public BookCoverFetcher(boolean forceRefresh) {
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .connectTimeout(HTTP_TIMEOUT)
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();
        this.storageClient = new SupabaseStorageClient();
        this.forceRefresh = forceRefresh;
    }

    // ═════════════════════════════════════════════════════════════════
    // Entry Point
    // ═════════════════════════════════════════════════════════════════

    public static void main(String[] args) {
        new BookCoverFetcher(hasFlag(args, "--force")).run();
    }

    private static boolean hasFlag(String[] args, String flag) {
        if (args == null) {
            return false;
        }
        for (String arg : args) {
            if (flag.equalsIgnoreCase(arg)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Chạy toàn bộ luồng tải ảnh bìa:
     * Kết nối DB → Lấy sách chưa có ảnh → Tải & upload → Cập nhật DB → Báo cáo.
     */
    public void run() {
        printBanner();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(true);

            List<BookInfo> books = loadTargetBooks(conn);
            if (!forceRefresh && !books.isEmpty()) {
                books = filterBooksWithMissingRemoteCover(books);
            }
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
        cover = fetchFromOpenLibrarySearch(book, isbnVariants);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        cover = fetchFromGoogleBooksSearch(book, isbnVariants);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        cover = fetchByGeneratedQueries(book);
        if (cover != null) {
            return cover;
        }

        Thread.sleep(DELAY_BEFORE_FALLBACK_MS);
        return fetchByAiSuggestedQueries(book);
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

    private CoverCandidate fetchFromGoogleBooksSearch(BookInfo book, List<String> isbnVariants)
            throws IOException, InterruptedException {

        String query = "intitle:" + quoteQuery(book.title);
        if (book.author != null && !book.author.isBlank()) {
            query += " inauthor:" + quoteQuery(book.author);
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

        return selectGoogleCover(response.body(), book, isbnVariants, "Google Books Search", MIN_SEARCH_MATCH_SCORE);
    }

    private CoverCandidate fetchByGeneratedQueries(BookInfo book)
            throws IOException, InterruptedException {

        for (String query : buildFallbackQueries(book)) {
            CoverCandidate cover = fetchFromGoogleBooksQuery(query, book, "Google Books Query", MIN_SEARCH_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }

            cover = fetchFromOpenLibraryKeywordSearch(query, book, "Open Library Query", MIN_SEARCH_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }
        }
        return null;
    }

    private CoverCandidate fetchByAiSuggestedQueries(BookInfo book)
            throws IOException, InterruptedException {

        List<String> aiQueries = suggestQueriesWithGemini(book);
        if (aiQueries.isEmpty()) {
            return null;
        }

        System.out.print("[AI query fallback] ");
        for (String query : aiQueries) {
            CoverCandidate cover = fetchFromGoogleBooksQuery(query, book, "Google Books AI Query", MIN_AI_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }

            cover = fetchFromOpenLibraryKeywordSearch(query, book, "Open Library AI Query", MIN_AI_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }
        }
        return null;
    }

    private CoverCandidate fetchFromGoogleBooksQuery(String query, BookInfo book, String source, int minScore)
            throws IOException, InterruptedException {

        String url = GOOGLE_BOOKS_SEARCH_API + encodeQuery(query) + "&maxResults=10";
        HttpResponse<String> response = httpGet(url, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            if (response.statusCode() == 429) {
                System.out.print("[Google Query 429] ");
            }
            return null;
        }

        if (TOTAL_ITEMS_ZERO.matcher(response.body()).find()) {
            return null;
        }

        return selectGoogleCover(response.body(), book, isbnVariants(book.isbn), source, minScore);
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

    private CoverCandidate fetchFromOpenLibrarySearch(BookInfo book, List<String> isbnVariants)
            throws IOException, InterruptedException {

        List<String> titleQueries = new ArrayList<>();
        titleQueries.add(cleanTitle(book.title));
        String shortTitle = titleBeforeSubtitle(book.title);
        if (!shortTitle.equalsIgnoreCase(titleQueries.get(0))) {
            titleQueries.add(shortTitle);
        }

        for (String titleQuery : titleQueries) {
            CoverCandidate cover = fetchFromOpenLibrarySearch(titleQuery, book.author, true,
                    book, isbnVariants, MIN_SEARCH_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }

            cover = fetchFromOpenLibrarySearch(titleQuery, null, false,
                    book, isbnVariants, MIN_SEARCH_MATCH_SCORE);
            if (cover != null) {
                return cover;
            }
        }
        return null;
    }

    private CoverCandidate fetchFromOpenLibrarySearch(String title, String author, boolean includeAuthor,
            BookInfo book, List<String> isbnVariants, int minScore)
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

        return selectOpenLibraryCover(response.body(), book, isbnVariants, "Open Library Search", minScore);
    }

    private CoverCandidate fetchFromOpenLibraryKeywordSearch(String query, BookInfo book, String source, int minScore)
            throws IOException, InterruptedException {

        String url = OPEN_LIBRARY_SEARCH_API
                + "q=" + encodeQuery(query)
                + "&fields=cover_i,title,author_name,isbn"
                + "&limit=10";
        HttpResponse<String> response = httpGet(url, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            return null;
        }

        return selectOpenLibraryCover(response.body(), book, isbnVariants(book.isbn), source, minScore);
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

    private List<String> suggestQueriesWithGemini(BookInfo book)
            throws IOException, InterruptedException {

        String apiKey = AiConfig.resolveApiKey();
        if (apiKey == null || apiKey.isBlank() || "MISSING_API_KEY".equals(apiKey)) {
            return List.of();
        }

        JsonObject payload = new JsonObject();
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", buildAiQueryPrompt(book));

        JsonArray parts = new JsonArray();
        parts.add(textPart);
        JsonObject content = new JsonObject();
        content.add("parts", parts);
        JsonArray contents = new JsonArray();
        contents.add(content);
        payload.add("contents", contents);

        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.2);
        generationConfig.addProperty("maxOutputTokens", 160);
        payload.add("generationConfig", generationConfig);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(AiConfig.GEMINI_API_URL + apiKey))
                .timeout(HTTP_TIMEOUT)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(new Gson().toJson(payload)))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            return List.of();
        }
        return parseAiQueries(response.body());
    }

    private String buildAiQueryPrompt(BookInfo book) {
        return "Create up to " + MAX_AI_QUERY_COUNT + " concise search queries to find the real book cover. "
                + "Use only the title, subtitle, author, edition, ISBN, and publisher clues if obvious. "
                + "Do not invent a different book. Return raw JSON array of strings only.\n"
                + "Title: " + nullToEmpty(book.title) + "\n"
                + "Author: " + nullToEmpty(book.author) + "\n"
                + "ISBN: " + nullToEmpty(book.isbn);
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

    private String extractBestGoogleImageUrl(String json) {
        Matcher matcher = GOOGLE_IMAGE_LINK_PATTERN.matcher(json);
        String fallback = null;
        while (matcher.find()) {
            String candidate = matcher.group(1);
            if (candidate == null || candidate.isBlank()) {
                continue;
            }
            if (fallback == null) {
                fallback = candidate;
            }
            if (candidate.contains("zoom=1") || candidate.contains("zoom=2")) {
                return candidate;
            }
        }
        return fallback;
    }

    private CoverCandidate selectGoogleCover(String json, BookInfo book, List<String> isbnVariants,
            String source, int minScore) throws IOException, InterruptedException {

        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            JsonArray items = root.getAsJsonArray("items");
            if (items == null || items.isEmpty()) {
                return null;
            }

            int bestScore = -1;
            String bestImageUrl = null;
            for (JsonElement item : items) {
                JsonObject volumeInfo = item.getAsJsonObject().getAsJsonObject("volumeInfo");
                if (volumeInfo == null) {
                    continue;
                }

                String imageUrl = googleImageUrl(volumeInfo);
                if (imageUrl == null) {
                    continue;
                }

                String title = googleTitle(volumeInfo);
                String authors = joinJsonArray(volumeInfo.getAsJsonArray("authors"));
                List<String> candidateIsbns = googleIsbns(volumeInfo);
                int score = matchScore(book, isbnVariants, title, authors, candidateIsbns);
                if (score > bestScore) {
                    bestScore = score;
                    bestImageUrl = imageUrl;
                }
            }

            if (bestImageUrl == null || bestScore < minScore) {
                return null;
            }

            byte[] imageBytes = downloadImageBytes(improveThumbnailUrl(bestImageUrl));
            return imageBytes == null ? null : new CoverCandidate(imageBytes, source + " score=" + bestScore);
        } catch (RuntimeException e) {
            return null;
        }
    }

    private CoverCandidate selectOpenLibraryCover(String json, BookInfo book, List<String> isbnVariants,
            String source, int minScore) throws IOException, InterruptedException {

        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            JsonArray docs = root.getAsJsonArray("docs");
            if (docs == null || docs.isEmpty()) {
                return null;
            }

            int bestScore = -1;
            Long bestCoverId = null;
            for (JsonElement docElement : docs) {
                JsonObject doc = docElement.getAsJsonObject();
                if (!doc.has("cover_i")) {
                    continue;
                }

                String title = getJsonString(doc, "title");
                String authors = joinJsonArray(doc.getAsJsonArray("author_name"));
                List<String> candidateIsbns = jsonArrayToStrings(doc.getAsJsonArray("isbn"));
                int score = matchScore(book, isbnVariants, title, authors, candidateIsbns);
                if (score > bestScore) {
                    bestScore = score;
                    bestCoverId = doc.get("cover_i").getAsLong();
                }
            }

            if (bestCoverId == null || bestScore < minScore) {
                return null;
            }

            byte[] imageBytes = fetchFromOpenLibraryCoverId(bestCoverId);
            return imageBytes == null ? null : new CoverCandidate(imageBytes, source + " score=" + bestScore);
        } catch (RuntimeException e) {
            return null;
        }
    }

    private int matchScore(BookInfo book, List<String> targetIsbns, String candidateTitle,
            String candidateAuthors, List<String> candidateIsbns) {

        int score = 0;
        if (hasMatchingIsbn(targetIsbns, candidateIsbns)) {
            score += 90;
        }

        score += titleMatchScore(book.title, candidateTitle);
        score += authorMatchScore(book.author, candidateAuthors);
        return score;
    }

    private boolean hasMatchingIsbn(List<String> targetIsbns, List<String> candidateIsbns) {
        if (targetIsbns == null || candidateIsbns == null) {
            return false;
        }

        Set<String> normalizedTargets = new LinkedHashSet<>();
        for (String isbn : targetIsbns) {
            addQuery(normalizedTargets, normalizeIsbn(isbn));
        }

        for (String isbn : candidateIsbns) {
            if (normalizedTargets.contains(normalizeIsbn(isbn))) {
                return true;
            }
        }
        return false;
    }

    private int titleMatchScore(String expectedTitle, String candidateTitle) {
        String expected = normalizeText(cleanTitle(expectedTitle));
        String expectedShort = normalizeText(titleBeforeSubtitle(expectedTitle));
        String candidate = normalizeText(cleanTitle(candidateTitle));
        if (expected.isBlank() || candidate.isBlank()) {
            return 0;
        }

        int fullScore = textMatchScore(expected, candidate, 55, 45, 40);
        int shortScore = expectedShort.equals(expected)
                ? 0
                : textMatchScore(expectedShort, candidate, 45, 35, 30);
        return Math.max(fullScore, shortScore);
    }

    private int authorMatchScore(String expectedAuthor, String candidateAuthors) {
        String expected = normalizeText(expectedAuthor);
        String candidate = normalizeText(candidateAuthors);
        if (expected.isBlank() || candidate.isBlank()) {
            return 0;
        }
        return textMatchScore(expected, candidate, 25, 20, 18);
    }

    private int textMatchScore(String expected, String candidate, int exactScore, int containsScore, int overlapMax) {
        if (expected.equals(candidate)) {
            return exactScore;
        }
        if ((candidate.contains(expected) || expected.contains(candidate)) && Math.min(expected.length(), candidate.length()) >= 8) {
            return containsScore;
        }
        double overlap = tokenOverlap(expected, candidate);
        return overlap >= 0.5 ? (int) Math.round(overlap * overlapMax) : 0;
    }

    private double tokenOverlap(String expected, String candidate) {
        Set<String> expectedTokens = meaningfulTokens(expected);
        Set<String> candidateTokens = meaningfulTokens(candidate);
        if (expectedTokens.isEmpty() || candidateTokens.isEmpty()) {
            return 0;
        }

        int matched = 0;
        for (String token : expectedTokens) {
            if (candidateTokens.contains(token)) {
                matched++;
            }
        }
        return matched / (double) expectedTokens.size();
    }

    private Set<String> meaningfulTokens(String value) {
        Set<String> tokens = new LinkedHashSet<>();
        for (String token : normalizeText(value).split(" ")) {
            if (token.length() >= 3 && !isWeakToken(token)) {
                tokens.add(token);
            }
        }
        return tokens;
    }

    private boolean isWeakToken(String token) {
        return Set.of("the", "and", "for", "with", "book", "edition", "introduction").contains(token);
    }

    private String googleImageUrl(JsonObject volumeInfo) {
        JsonObject imageLinks = volumeInfo.getAsJsonObject("imageLinks");
        if (imageLinks == null) {
            return null;
        }
        String thumbnail = getJsonString(imageLinks, "thumbnail");
        if (thumbnail != null && !thumbnail.isBlank()) {
            return thumbnail;
        }
        return getJsonString(imageLinks, "smallThumbnail");
    }

    private String googleTitle(JsonObject volumeInfo) {
        String title = getJsonString(volumeInfo, "title");
        String subtitle = getJsonString(volumeInfo, "subtitle");
        if (subtitle == null || subtitle.isBlank()) {
            return title;
        }
        return nullToEmpty(title) + ": " + subtitle;
    }

    private List<String> googleIsbns(JsonObject volumeInfo) {
        List<String> values = new ArrayList<>();
        JsonArray identifiers = volumeInfo.getAsJsonArray("industryIdentifiers");
        if (identifiers == null) {
            return values;
        }

        for (JsonElement element : identifiers) {
            JsonObject identifier = element.getAsJsonObject();
            String value = getJsonString(identifier, "identifier");
            if (value != null) {
                values.add(value);
            }
        }
        return values;
    }

    private List<String> jsonArrayToStrings(JsonArray array) {
        List<String> values = new ArrayList<>();
        if (array == null) {
            return values;
        }
        for (JsonElement element : array) {
            if (!element.isJsonNull()) {
                values.add(element.getAsString());
            }
        }
        return values;
    }

    private String joinJsonArray(JsonArray array) {
        return String.join(" ", jsonArrayToStrings(array));
    }

    private String getJsonString(JsonObject object, String key) {
        if (object == null || !object.has(key) || object.get(key).isJsonNull()) {
            return null;
        }
        return object.get(key).getAsString();
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

    private List<String> buildFallbackQueries(BookInfo book) {
        Set<String> queries = new LinkedHashSet<>();
        String title = cleanTitle(book.title);
        String shortTitle = titleBeforeSubtitle(book.title);
        String author = normalizeAuthor(book.author);

        addQuery(queries, quoteQuery(title) + " " + author);
        addQuery(queries, quoteQuery(shortTitle) + " " + author);
        addQuery(queries, title + " " + author);
        addQuery(queries, shortTitle + " " + author);

        return new ArrayList<>(queries);
    }

    private void addQuery(Set<String> queries, String query) {
        String cleaned = query == null ? "" : query.replaceAll("\\s+", " ").trim();
        if (!cleaned.isBlank()) {
            queries.add(cleaned);
        }
    }

    private List<String> parseAiQueries(String jsonResponse) {
        try {
            JsonObject root = JsonParser.parseString(jsonResponse).getAsJsonObject();
            JsonArray candidates = root.getAsJsonArray("candidates");
            if (candidates == null || candidates.isEmpty()) {
                return List.of();
            }

            JsonObject content = candidates.get(0).getAsJsonObject().getAsJsonObject("content");
            JsonArray parts = content.getAsJsonArray("parts");
            if (parts == null || parts.isEmpty()) {
                return List.of();
            }

            String text = parts.get(0).getAsJsonObject().get("text").getAsString()
                    .replace("```json", "")
                    .replace("```", "")
                    .trim();
            JsonArray queryArray = JsonParser.parseString(text).getAsJsonArray();
            Set<String> queries = new LinkedHashSet<>();
            for (JsonElement element : queryArray) {
                if (queries.size() >= MAX_AI_QUERY_COUNT) {
                    break;
                }
                addQuery(queries, element.getAsString());
            }
            return new ArrayList<>(queries);
        } catch (RuntimeException e) {
            return List.of();
        }
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

    private String normalizeAuthor(String author) {
        if (author == null) {
            return "";
        }
        return author.replaceAll("\\s+", " ").trim();
    }

    private String normalizeText(String value) {
        if (value == null) {
            return "";
        }
        return value.toLowerCase()
                .replaceAll("[^\\p{IsAlphabetic}\\p{IsDigit}]+", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private String normalizeIsbn(String isbn) {
        return isbn == null ? "" : isbn.replaceAll("[^0-9Xx]", "").toUpperCase();
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
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
    private List<BookInfo> loadTargetBooks(Connection conn) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, imagePath FROM Book "
                + "WHERE status = 'available' ";
        if (!forceRefresh) {
            sql += "AND (imagePath IS NULL OR TRIM(imagePath) = '' OR imagePath NOT LIKE ? OR imagePath LIKE ?) ";
        }
        sql += "ORDER BY bookId";

        List<BookInfo> books = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = executeTargetBookQuery(ps)) {
            while (rs.next()) {
                books.add(new BookInfo(
                        rs.getInt("bookId"),
                        rs.getString("isbn"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("imagePath")));
            }
        }
        return books;
    }

    private ResultSet executeTargetBookQuery(PreparedStatement ps) throws SQLException {
        if (!forceRefresh) {
            ps.setString(1, validSharedCoverPattern());
            ps.setString(2, validSharedCoverPattern());
        }
        return ps.executeQuery();
    }

    private List<BookInfo> filterBooksWithMissingRemoteCover(List<BookInfo> books) {
        List<BookInfo> targets = new ArrayList<>();
        int checked = 0;
        for (BookInfo book : books) {
            if (!hasValidSharedCoverUrl(book.imagePath)) {
                targets.add(book);
                continue;
            }

            checked++;
            if (checked > REMOTE_COVER_CHECK_LIMIT) {
                continue;
            }

            if (!remoteCoverExists(book.imagePath)) {
                targets.add(book);
            }
        }
        return targets;
    }

    private boolean hasValidSharedCoverUrl(String imagePath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return false;
        }
        return imagePath.startsWith("https://") && imagePath.contains("/storage/v1/object/public/");
    }

    private boolean remoteCoverExists(String imagePath) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(imagePath))
                    .timeout(HTTP_TIMEOUT)
                    .method("HEAD", HttpRequest.BodyPublishers.noBody())
                    .build();
            HttpResponse<Void> response = httpClient.send(request, HttpResponse.BodyHandlers.discarding());
            if (response.statusCode() == 405) {
                return remoteCoverExistsByRangeGet(imagePath);
            }
            return response.statusCode() >= 200 && response.statusCode() < 300;
        } catch (IllegalArgumentException | IOException | InterruptedException e) {
            if (e instanceof InterruptedException) {
                Thread.currentThread().interrupt();
            }
            return false;
        }
    }

    private boolean remoteCoverExistsByRangeGet(String imagePath)
            throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(imagePath))
                .timeout(HTTP_TIMEOUT)
                .header("Range", "bytes=0-0")
                .GET()
                .build();
        HttpResponse<Void> response = httpClient.send(request, HttpResponse.BodyHandlers.discarding());
        return response.statusCode() >= 200 && response.statusCode() < 300;
    }

    private String validSharedCoverPattern() {
        if (storageClient.isConfigured()) {
            return storageClient.publicObjectBaseUrl() + "%";
        }
        return "https://%/storage/v1/object/public/%";
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
        final String imagePath;

        BookInfo(int bookId, String isbn, String title, String author, String imagePath) {
            this.bookId = bookId;
            this.isbn = isbn;
            this.title = title;
            this.author = author;
            this.imagePath = imagePath;
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
