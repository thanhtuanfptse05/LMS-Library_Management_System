package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * BorrowRecordDAO — Data Access Object cho bảng BorrowRecord.
 * 
 * Tuân thủ SEC-03: Sử dụng PreparedStatement cho mọi truy vấn.
 */
public class BorrowRecordDAO {

    private static final Logger LOGGER = Logger.getLogger(BorrowRecordDAO.class.getName());

    /**
     * Đếm tổng số lượt mượn sách của một người dùng.
     * Sử dụng để xác định người dùng có đạt ngưỡng kích hoạt AI Recommendation không (BR-26).
     * 
     * @param userId ID người dùng
     * @return Tổng số lượt mượn
     */
    public int countUserBorrowHistory(int userId) {
        String sql = "SELECT COUNT(*) AS total FROM BorrowRecord WHERE userId = ?";
        int count = 0;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm lịch sử mượn sách của userId=" + userId, e);
        }
        
        return count;
    }
}
