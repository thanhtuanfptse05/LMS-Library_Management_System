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

    private static final String DRIVER = "org.postgresql.Driver";
    private static final String URL = "jdbc:postgresql://db.ujqgffruabfuqhtsybus.supabase.co:5432/postgres?sslmode=require";
    private static final String USER = "postgres";
    private static final String PASSWORD = "6wUw)Q6S/)LFeSE";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "PostgreSQL JDBC Driver not found. "
                    + "Ensure postgresql-42.7.x.jar is in WEB-INF/lib.", e);
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
