import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class InsertFines {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        try (Connection conn = DriverManager.getConnection(url, "postgres.wukwrfwdrbstyoqissjz", "6wUw)Q6S/)LFeSE")) {
            System.out.println("--- INSERTING FINES FOR USER 93 ---");
            String sql = "INSERT INTO \"Fine\" (\"userId\", \"borrowRecordId\", \"amount\", \"reason\", \"status\", \"createdAt\") VALUES (?, NULL, ?, ?, 'pending', NOW())";
            
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                // Fine 1
                ps.setInt(1, 93);
                ps.setDouble(2, 12000);
                ps.setString(3, "Tr? sách quá h?n 2 ngày (Test SePay 1)");
                ps.executeUpdate();
                ResultSet rs1 = ps.getGeneratedKeys();
                if(rs1.next()) System.out.println("Inserted Fine ID: " + rs1.getInt(1));

                // Fine 2
                ps.setInt(1, 93);
                ps.setDouble(2, 25000);
                ps.setString(3, "Làm rách trang sách (Test SePay 2)");
                ps.executeUpdate();
                ResultSet rs2 = ps.getGeneratedKeys();
                if(rs2.next()) System.out.println("Inserted Fine ID: " + rs2.getInt(1));
            }
            System.out.println("DONE!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
