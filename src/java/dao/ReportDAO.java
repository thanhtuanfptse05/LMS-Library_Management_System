package dao;

import dto.BorrowTrendDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseConnection;

public class ReportDAO {
    
    /**
     * Lấy thống kê lượt mượn sách, nhóm theo thời gian (Ngày/Tháng/Năm)
     */
    public List<BorrowTrendDTO> getBorrowTrends(String startDateStr, String endDateStr, String groupBy) throws Exception {
        List<BorrowTrendDTO> list = new ArrayList<>();
        
        // Xác định định dạng thời gian cho PostgreSQL to_char
        String dateFormat = "YYYY-MM-DD";
        if ("month".equalsIgnoreCase(groupBy)) {
            dateFormat = "YYYY-MM";
        } else if ("year".equalsIgnoreCase(groupBy)) {
            dateFormat = "YYYY";
        }

        String sql = "SELECT to_char(startDate, ?) AS periodLabel, " +
                     "COUNT(*) AS totalBorrowed, " +
                     "SUM(CASE WHEN returnedAt IS NOT NULL AND returnedAt <= endDate THEN 1 ELSE 0 END) AS totalReturnedOnTime, " +
                     "SUM(CASE WHEN status = 'overdue' OR (returnedAt IS NULL AND CURRENT_TIMESTAMP > endDate) THEN 1 ELSE 0 END) AS totalOverdue " +
                     "FROM BorrowRecord " +
                     "WHERE startDate >= CAST(? AS TIMESTAMP) AND startDate <= CAST(? AS TIMESTAMP) " +
                     "GROUP BY to_char(startDate, ?) " +
                     "ORDER BY periodLabel ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, dateFormat);
            ps.setString(2, startDateStr + " 00:00:00");
            ps.setString(3, endDateStr + " 23:59:59");
            ps.setString(4, dateFormat);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowTrendDTO dto = new BorrowTrendDTO();
                    dto.setPeriodLabel(rs.getString("periodLabel"));
                    dto.setTotalBorrowed(rs.getInt("totalBorrowed"));
                    dto.setTotalReturnedOnTime(rs.getInt("totalReturnedOnTime"));
                    dto.setTotalOverdue(rs.getInt("totalOverdue"));
                    list.add(dto);
                }
            }
        }
        return list;
    }
}
