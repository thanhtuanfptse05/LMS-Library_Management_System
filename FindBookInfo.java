import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FindBookInfo {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        try (Connection conn = DriverManager.getConnection(url, "postgres.wukwrfwdrbstyoqissjz", "6wUw)Q6S/)LFeSE")) {
            System.out.println("--- FINDING BOOK COPY ---");
            try (PreparedStatement ps = conn.prepareStatement("SELECT bookCopyId, bookId FROM BookCopy LIMIT 1")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("BookCopy ID: " + rs.getInt(1) + " | Book ID: " + rs.getInt(2));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
