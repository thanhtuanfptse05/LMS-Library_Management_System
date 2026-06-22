import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class SetKey {
    public static void main(String[] args) {
        String dbUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";
        String sql = "INSERT INTO SystemConfigurations (configKey, configValue, description, configGroup) " +
                     "VALUES " +
                     "('GEMINI_API_KEY', 'AIzaSyBaBm-zMgaXksZ3pqGvscm57WMdPkZf_hU', 'Google Gemini Global API Key', 'API'), " +
                     "('GEMINI_CHATBOT_API_KEY', 'AIzaSyBaBm-zMgaXksZ3pqGvscm57WMdPkZf_hU', 'Google Gemini Chatbot API Key', 'API') " +
                     "ON CONFLICT (configKey) " +
                     "DO UPDATE SET configValue = EXCLUDED.configValue, updatedAt = CURRENT_TIMESTAMP;";
        try (Connection conn = DriverManager.getConnection(dbUrl, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            int rows = ps.executeUpdate();
            System.out.println("Key inserted successfully. Rows affected: " + rows);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
