import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestGemini {
    public static void main(String[] args) {
        String dbUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String apiKey = "";
        try (Connection conn = DriverManager.getConnection(dbUrl, "postgres.wukwrfwdrbstyoqissjz", "6wUw)Q6S/)LFeSE")) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT configValue FROM SystemConfigurations WHERE configKey = 'GEMINI_CHATBOT_API_KEY'")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    apiKey = rs.getString(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        if (apiKey == null || apiKey.isEmpty()) {
            System.out.println("API Key not found in DB.");
            return;
        }

        System.out.println("Got API Key: " + apiKey.substring(0, 5) + "...");

        String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;
        String payload = "{\"contents\":[{\"parts\":[{\"text\":\"Hello\"}]}]}";

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int statusCode = conn.getResponseCode();
            System.out.println("HTTP Status (1.5-flash): " + statusCode);
            if (statusCode != HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        System.out.println("Error: " + line);
                    }
                }
            } else {
                 System.out.println("Success with 1.5-flash");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Test with 3.5-flash as configured in code
        String apiUrl35 = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=" + apiKey;
        try {
            URL url = new URL(apiUrl35);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int statusCode = conn.getResponseCode();
            System.out.println("HTTP Status (3.5-flash): " + statusCode);
            if (statusCode != HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        System.out.println("Error 3.5: " + line);
                    }
                }
            } else {
                 System.out.println("Success with 3.5-flash");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
