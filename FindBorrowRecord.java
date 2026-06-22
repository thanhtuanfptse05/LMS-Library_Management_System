import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FindBorrowRecord {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        try (Connection conn = DriverManager.getConnection(url, "postgres.wukwrfwdrbstyoqissjz", "6wUw)Q6S/)LFeSE")) {
            System.out.println("--- FINDING BORROW RECORD ---");
            try (PreparedStatement ps = conn.prepareStatement("SELECT borrowRecordId, userId FROM BorrowRecord LIMIT 5")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    System.out.println("BorrowRecord ID: " + rs.getInt(1) + " | User ID: " + rs.getInt(2));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
