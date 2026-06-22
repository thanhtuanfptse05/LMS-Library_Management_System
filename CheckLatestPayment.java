import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckLatestPayment {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        try (Connection conn = DriverManager.getConnection(url, "postgres.wukwrfwdrbstyoqissjz", "6wUw)Q6S/)LFeSE")) {
            System.out.println("--- LATEST PAYMENTS ---");
            try (PreparedStatement ps = conn.prepareStatement("SELECT paymentId, fineId, paidAmount, status, paidAt FROM Payment ORDER BY paymentId DESC LIMIT 3")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    System.out.println("Payment ID: " + rs.getInt("paymentId") + " | Amount: " + rs.getDouble("paidAmount") + " | Status: " + rs.getString("status"));
                }
            }

            System.out.println("\n--- LATEST AUDIT LOGS ---");
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM AuditLogs ORDER BY timestamp DESC LIMIT 3")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    System.out.println("Log ID: " + rs.getInt("auditLogId") + " | Action: " + rs.getString("actionType") + " | EntityId: " + rs.getString("entityId") + " | Time: " + rs.getTimestamp("timestamp"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
