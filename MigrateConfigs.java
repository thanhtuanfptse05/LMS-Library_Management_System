import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class MigrateConfigs {
    public static void main(String[] args) {
        String dbUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, user, pass)) {
            conn.setAutoCommit(false);
            try {
                // Update groups
                String sql1 = "UPDATE SystemConfigurations SET configGroup = 'library' WHERE configGroup IN ('library', 'fine')";
                String sql2 = "UPDATE SystemConfigurations SET configGroup = 'system' WHERE configGroup IN ('system', 'sepay', 'notification')";
                
                try (PreparedStatement ps1 = conn.prepareStatement(sql1);
                     PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                     
                    int rows1 = ps1.executeUpdate();
                    int rows2 = ps2.executeUpdate();
                    
                    System.out.println("Migrated " + rows1 + " rows to 'library' group.");
                    System.out.println("Migrated " + rows2 + " rows to 'system' group.");
                }
                
                // Ensure SEPAY_QR_URL is initialized if not present
                String sql3 = "INSERT INTO SystemConfigurations (configKey, configValue, description, configGroup) " +
                              "VALUES ('SEPAY_QR_URL', '', 'URL ảnh QR chuyển khoản SePay (để trống nếu chưa có)', 'system') " +
                              "ON CONFLICT (configKey) DO UPDATE SET configGroup = 'system'";
                try (PreparedStatement ps3 = conn.prepareStatement(sql3)) {
                    ps3.executeUpdate();
                    System.out.println("Ensured SEPAY_QR_URL config exists in 'system' group.");
                }

                conn.commit();
                System.out.println("Migration completed successfully.");
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
