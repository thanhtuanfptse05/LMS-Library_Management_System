import dao.SystemConfigDAO;
import util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.OutputStream;

public class SimulateWebhook {
    public static void main(String[] args) throws Exception {
        SystemConfigDAO configDAO = new SystemConfigDAO();
        String apiKey = "";
        int paymentId = -1;
        try (Connection conn = DatabaseConnection.getConnection()) {
            apiKey = configDAO.getValue(conn, "SEPAY_API_KEY", "");
            
            try (PreparedStatement ps = conn.prepareStatement("SELECT paymentId FROM Payment WHERE status = 'pending' ORDER BY paymentId DESC LIMIT 1")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        paymentId = rs.getInt("paymentId");
                    }
                }
            }
        }
        
        if (paymentId == -1) {
            System.out.println("No pending payment found.");
            return;
        }
        
        System.out.println("Simulating webhook for paymentId: " + paymentId);
        
        String jsonPayload = "{"
            + "\"id\": 99999,"
            + "\"gateway\": \"MBBank\","
            + "\"transactionDate\": \"2026-06-21 00:00:00\","
            + "\"accountNumber\": \"8816861222\","
            + "\"code\": \"LMSPF" + paymentId + "\","
            + "\"content\": \"LMSPF" + paymentId + "\","
            + "\"transferType\": \"in\","
            + "\"transferAmount\": 10000,"
            + "\"accumulated\": 100000,"
            + "\"channel\": \"MB\","
            + "\"referenceCode\": \"SIMULATED123\""
            + "}";
            
        URL url = new URL("https://lms-library-management-system-8ty7.onrender.com/api/sepay-webhook");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
        con.setRequestProperty("Authorization", "Apikey " + apiKey);
        con.setDoOutput(true);
        
        try(OutputStream os = con.getOutputStream()) {
            byte[] input = jsonPayload.getBytes("utf-8");
            os.write(input, 0, input.length);			
        }
        
        int code = con.getResponseCode();
        System.out.println("Response Code: " + code);
        try (java.io.BufferedReader in = new java.io.BufferedReader(
                new java.io.InputStreamReader(con.getErrorStream() != null ? con.getErrorStream() : con.getInputStream()))) {
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            System.out.println("Response Body: " + response.toString());
        }
    }
}
