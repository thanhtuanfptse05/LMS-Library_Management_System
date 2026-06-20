package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * DatabaseConnection — Utility class cung cấp kết nối JDBC tới SQL Server.
 *
 * <p>Tuân thủ: ARCH-01 (JDBC thuần, không ORM), ENG-01 (try-with-resources),
 * SEC-01 (không hardcode secret trong production).</p>
 *
 * <p>Lưu ý: Thông tin kết nối hiện tại dùng cho môi trường phát triển.
 * Trong production, các giá trị này PHẢI được nạp từ biến môi trường
 * hoặc file cấu hình bên ngoài source code.</p>
 */
public class DatabaseConnection {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());

    private static final String DRIVER = "org.postgresql.Driver";
    private static final String URL = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0";
    private static final String USER = "postgres.wukwrfwdrbstyoqissjz";
    private static final String PASSWORD = "6wUw)Q6S/)LFeSE";

    private static DataSource dataSource;

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "PostgreSQL JDBC Driver not found. "
                    + "Ensure postgresql-42.7.x.jar is in WEB-INF/lib.", e);
        }

        try {
            InitialContext ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/LMSDB");
            LOGGER.info("Da khoi tao JNDI DataSource jdbc/LMSDB thanh cong.");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Khong the lookup JNDI DataSource (co the dang chay ngoai Tomcat). Se fallback ve DriverManager: " + e.getMessage());
        }
    }

    /**
     * Lấy một kết nối JDBC mới tới SQL Server.
     *
     * <p>Caller có trách nhiệm đóng Connection bằng try-with-resources
     * hoặc khối finally để tránh connection leak (ENG-01).</p>
     *
     * @return Connection tới database LMS_Library_Management_System
     * @throws SQLException nếu không thể thiết lập kết nối
     */
    public static Connection testConnection = null;

    public static Connection getConnection() throws SQLException {
        if (testConnection != null) {
            return testConnection;
        }
        if (dataSource != null) {
            try {
                return dataSource.getConnection();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Loi khi lay ket noi tu DataSource JNDI. Fallback ve DriverManager...", e);
            }
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private DatabaseConnection() {
        // Ngăn khởi tạo instance — utility class chỉ dùng static method
    }
}
