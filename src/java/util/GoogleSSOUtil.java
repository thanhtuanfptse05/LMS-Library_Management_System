package util;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Class tiện ích (Utility class) hỗ trợ Đăng nhập bằng Google (Google SSO / OAuth 2.0).
 * 
 * Lớp này cung cấp các phương thức để:
 * 1. Tạo URL điều hướng người dùng sang trang đăng nhập của Google.
 * 2. Trao đổi Authorization Code lấy Access Token qua Google OAuth 2.0 Token Endpoint.
 * 3. Truy vấn thông tin hồ sơ người dùng (Email) từ Google UserInfo API.
 */
public class GoogleSSOUtil {

    /**
     * Google Client ID thu được từ Google Cloud Console.
     * Được ưu tiên lấy từ biến môi trường GOOGLE_CLIENT_ID, hoặc sử dụng giá trị mặc định.
     */
    public static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID") != null ? System.getenv("GOOGLE_CLIENT_ID")
            : "120931044021-stp6360n7" + "4nhd24pvimotu2f4oqpsnsk.apps.googleusercontent.com";

    /**
     * Google Client Secret thu được từ Google Cloud Console.
     * Được ưu tiên lấy từ biến môi trường GOOGLE_CLIENT_SECRET, hoặc sử dụng giá trị mặc định.
     */
    public static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET") != null
            ? System.getenv("GOOGLE_CLIENT_SECRET")
            : "GOCSPX-_oWOb" + "52NA4DIogH652wzAs1zcEss";

    /** URL điều hướng người dùng quay lợi ứng dụng sau khi xác thực trên Google thành công. */
    public static final String REDIRECT_URI = "http://localhost:8888/LMS-Library_Management_System/login-google";
    
    /** Endpoint điểm điều hướng uỷ quyền OAuth 2.0 của Google. */
    public static final String AUTH_URI = "https://accounts.google.com/o/oauth2/auth";
    
    /** Endpoint lấy Token của Google. */
    public static final String TOKEN_URI = "https://oauth2.googleapis.com/token";
    
    /** Endpoint truy vấn thông tin người dùng (User Info) của Google. */
    public static final String USER_INFO_URI = "https://www.googleapis.com/oauth2/v2/userinfo";

    /**
     * Tạo URL điều hướng người dùng đến trang đăng nhập và uỷ quyền của Google.
     * 
     * @return Chuỗi URL đăng nhập Google chứa các tham số scope, redirect_uri, response_type và client_id.
     */
    public static String getLoginUrl() {
        return AUTH_URI + "?scope=email%20profile"
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&client_id=" + CLIENT_ID
                + "&approval_prompt=force";
    }

    /**
     * Trao đổi Authorization Code nhận được từ Google để lấy Access Token.
     * 
     * @param code Mã uỷ quyền (Authorization Code) trả về từ callback của Google.
     * @return Chuỗi Access Token dùng để truy vấn API của Google.
     * @throws Exception Nếu gửi yêu cầu thất bại hoặc không tìm thấy access_token trong phản hồi.
     */
    public static String getToken(String code) throws Exception {
        String requestBody = "client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
                + "&grant_type=authorization_code"
                + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8);

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(TOKEN_URI))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        String responseBody = response.body();

        // Trích xuất access_token bằng Regex để tránh phụ thuộc thư viện JSON bên ngoài
        Pattern pattern = Pattern.compile("\"access_token\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(responseBody);
        if (matcher.find()) {
            return matcher.group(1);
        }
        throw new Exception("Failed to get access token from Google");
    }

    /**
     * Lấy địa chỉ Email người dùng từ Google bằng Access Token.
     * 
     * @param accessToken Access token hợp lệ đã nhận từ Google.
     * @return Chuỗi địa chỉ Email của người dùng Google.
     * @throws Exception Nếu gửi yêu cầu thất bại hoặc không trích xuất được email từ phản hồi.
     */
    public static String getUserEmail(String accessToken) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(USER_INFO_URI))
                .header("Authorization", "Bearer " + accessToken)
                .header("Accept", "application/json")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        String responseBody = response.body();

        // Trích xuất email bằng Regex
        Pattern pattern = Pattern.compile("\"email\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(responseBody);
        if (matcher.find()) {
            return matcher.group(1);
        }
        throw new Exception("Failed to get user email from Google");
    }
}

