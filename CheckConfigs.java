import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckConfigs {
    public static void main(String[] args) {
        String dbUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";
        String sql = "SELECT configkey, configvalue, configgroup FROM SystemConfigurations";
        try (Connection conn = DriverManager.getConnection(dbUrl, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while(rs.next()) {
                System.out.println(rs.getString(1) + " | " + rs.getString(2) + " | " + rs.getString(3));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
