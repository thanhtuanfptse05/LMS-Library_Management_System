package util;

import config.AppConfig;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class SupabaseStorageClient {

    private final HttpClient httpClient;
    private final String supabaseUrl;
    private final String serviceRoleKey;
    private final String bucket;

    public SupabaseStorageClient() {
        this(HttpClient.newBuilder().version(HttpClient.Version.HTTP_1_1).build(), AppConfig.getSupabaseUrl(),
                AppConfig.getSupabaseServiceRoleKey(), AppConfig.getSupabaseBookCoverBucket());
    }

    SupabaseStorageClient(HttpClient httpClient, String supabaseUrl, String serviceRoleKey, String bucket) {
        this.httpClient = httpClient;
        this.supabaseUrl = normalizeBaseUrl(supabaseUrl);
        this.serviceRoleKey = trimToNull(serviceRoleKey);
        this.bucket = trimToNull(bucket);
    }

    public boolean isConfigured() {
        return supabaseUrl != null && serviceRoleKey != null && bucket != null;
    }

    public String getConfigurationStatus() {
        return "supabaseUrl=" + (supabaseUrl == null ? "missing" : "present")
                + ", serviceRoleKey=" + (serviceRoleKey == null ? "missing" : "present")
                + ", bucket=" + (bucket == null ? "missing" : bucket);
    }

    public String uploadPublicObject(String fileName, byte[] bytes, String contentType)
            throws IOException, InterruptedException {
        if (!isConfigured()) {
            throw new IllegalStateException("Supabase Storage chưa được cấu hình.");
        }
        String objectUrl = supabaseUrl + "/storage/v1/object/" + bucket + "/" + fileName;
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(objectUrl))
                .header("Authorization", "Bearer " + serviceRoleKey)
                .header("apikey", serviceRoleKey)
                .header("Content-Type", contentType)
                .header("Cache-Control", "public, max-age=31536000")
                .header("x-upsert", "true")
                .POST(HttpRequest.BodyPublishers.ofByteArray(bytes))
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            if (response.statusCode() == 400 && response.body() != null && response.body().contains("\"Duplicate\"")) {
                return publicObjectUrl(fileName);
            }
            throw new IOException("Không thể upload ảnh lên Supabase Storage. Mã lỗi "
                    + response.statusCode() + ": " + response.body());
        }
        return publicObjectUrl(fileName);
    }

    /**
     * Xóa một object khỏi bucket ảnh bìa.
     *
     * @param fileName tên tệp trong bucket (không kèm đường dẫn public)
     * @return true nếu object đã được xóa hoặc vốn không tồn tại (404)
     * @throws IOException nếu Supabase trả về mã lỗi khác
     */
    public boolean deleteObject(String fileName) throws IOException, InterruptedException {
        if (!isConfigured()) {
            throw new IllegalStateException("Supabase Storage chưa được cấu hình.");
        }
        if (fileName == null || fileName.isBlank()) {
            return false;
        }
        String objectUrl = supabaseUrl + "/storage/v1/object/" + bucket + "/" + fileName;
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(objectUrl))
                .header("Authorization", "Bearer " + serviceRoleKey)
                .header("apikey", serviceRoleKey)
                .DELETE()
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() == 404) {
            return true;
        }
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Không thể xóa ảnh trên Supabase Storage. Mã lỗi "
                    + response.statusCode() + ": " + response.body());
        }
        return true;
    }

    /**
     * Tách tên tệp từ một URL public của chính bucket này.
     *
     * @return tên tệp, hoặc null nếu URL không thuộc bucket đang cấu hình
     */
    public String extractObjectName(String publicUrl) {
        if (publicUrl == null || !isConfigured()) {
            return null;
        }
        String prefix = publicObjectBaseUrl();
        if (!publicUrl.startsWith(prefix)) {
            return null;
        }
        String fileName = publicUrl.substring(prefix.length());
        int queryIndex = fileName.indexOf('?');
        if (queryIndex >= 0) {
            fileName = fileName.substring(0, queryIndex);
        }
        return fileName.isBlank() ? null : fileName;
    }

    public String publicObjectUrl(String fileName) {
        if (!isConfigured()) {
            throw new IllegalStateException("Supabase Storage chưa được cấu hình.");
        }
        return publicObjectBaseUrl() + fileName;
    }

    public String publicObjectBaseUrl() {
        if (!isConfigured()) {
            throw new IllegalStateException("Supabase Storage chưa được cấu hình.");
        }
        return supabaseUrl + "/storage/v1/object/public/" + bucket + "/";
    }

    private String normalizeBaseUrl(String value) {
        String normalized = trimToNull(value);
        if (normalized == null) {
            return null;
        }
        while (normalized.endsWith("/")) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }
        if (normalized.endsWith("/rest/v1")) {
            normalized = normalized.substring(0, normalized.length() - "/rest/v1".length());
        }
        return normalized;
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
