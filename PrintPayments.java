import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PrintPayments {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "SELECT paymentId, fineId, paidAmount, paymentMethod, transactionReference, status FROM Payment";
            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    System.out.println(rs.getInt(1) + "\t" + rs.getInt(2) + "\t" + rs.getBigDecimal(3) + "\t" + rs.getString(4) + "\t" + rs.getString(5) + "\t" + rs.getString(6));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
