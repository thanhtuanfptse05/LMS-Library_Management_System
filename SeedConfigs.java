import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class SeedConfigs {
    public static void main(String[] args) {
        String dbUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";
        
        String sqlFilePath = "database/supabase/seeds/04_system_configs_and_templates.sql";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Reading seed file: " + sqlFilePath);
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(sqlFilePath), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    // Ignore comments and empty lines
                    if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                        continue;
                    }
                    sb.append(line).append(" ");
                }
            }
            
            // Split queries by semicolon (simple splitter, works for this seed file)
            String[] queries = sb.toString().split(";");
            int count = 0;
            for (String query : queries) {
                if (query.trim().isEmpty()) {
                    continue;
                }
                stmt.execute(query.trim());
                count++;
            }
            System.out.println("Executed " + count + " SQL statements from seed file successfully.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
