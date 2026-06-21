import dao.SystemConfigDAO;
import util.DatabaseConnection;
import java.sql.Connection;

public class CheckConfig {
    public static void main(String[] args) throws Exception {
        SystemConfigDAO dao = new SystemConfigDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            System.out.println("SEPAY_ACCOUNT_NUMBER: " + dao.getValue(conn, "SEPAY_ACCOUNT_NUMBER", "NOT_FOUND"));
            System.out.println("SEPAY_BANK_CODE: " + dao.getValue(conn, "SEPAY_BANK_CODE", "NOT_FOUND"));
            System.out.println("SEPAY_ACCOUNT_NAME: " + dao.getValue(conn, "SEPAY_ACCOUNT_NAME", "NOT_FOUND"));
        }
    }
}
