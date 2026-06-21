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
        this(HttpClient.newHttpClient(), AppConfig.SUPABASE_URL,
                AppConfig.SUPABASE_SERVICE_ROLE_KEY, AppConfig.SUPABASE_BOOK_COVER_BUCKET);
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
                .POST(HttpRequest.BodyPublishers.ofByteArray(bytes))
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Không thể upload ảnh lên Supabase Storage. Mã lỗi "
                    + response.statusCode() + ": " + response.body());
        }
        return supabaseUrl + "/storage/v1/object/public/" + bucket + "/" + fileName;
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
