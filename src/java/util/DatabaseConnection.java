package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

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

    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;"
            + "databaseName=LMS_Library_Management_System;"
            + "encrypt=true;"
            + "trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "SQL Server JDBC Driver not found. "
                    + "Ensure sqljdbc42.jar is in WEB-INF/lib.", e);
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
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private DatabaseConnection() {
        // Ngăn khởi tạo instance — utility class chỉ dùng static method
    }
}
