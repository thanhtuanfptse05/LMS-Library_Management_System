package dao;

import dto.StaffPerformanceDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * StaffPerformanceDAO — Truy xuất dữ liệu thống kê hiệu suất Thủ thư theo tháng.
 *
 * <p>Tuân thủ SEC-03: sử dụng PreparedStatement cho mọi truy vấn.</p>
 */
public class StaffPerformanceDAO {

    private static final Logger LOGGER = Logger.getLogger(StaffPerformanceDAO.class.getName());

    /**
     * Lấy danh sách hiệu suất Thủ thư trong một tháng/năm cụ thể.
     *
     * <p>JOIN qua: Librarian → MemberProfile (fullName) → BorrowRecord (issueCount, returnCount)
     * → Payment (fineCollected). Kết quả sắp xếp theo số phiếu cấp giảm dần.</p>
     *
     * @param month Tháng cần thống kê (1–12)
     * @param year  Năm cần thống kê
     * @param limit Giới hạn số bản ghi trả về (0 = không giới hạn)
     * @return Danh sách StaffPerformanceDTO, rỗng nếu chưa có dữ liệu
     */
    public List<StaffPerformanceDTO> getStaffPerformance(int month, int year, int limit) {
        // Truy vấn số phiếu MỢN cấp bởi từng thủ thư (createdBy) trong tháng
        // Truy vấn số phiếu TRẢ: BorrowRecord có returnedAt trong tháng, createdBy = thủ thư
        // Truy vấn tiền phạt ĐÃ THU: Payment status='completed', processedBy = thủ thư, paidAt trong tháng
        String sql =
            "SELECT " +
            "    lib.userId, " +
            "    mp.fullName, " +
            "    lib.staffCode, " +
            "    COALESCE(issue.cnt, 0)   AS issueCount, " +
            "    COALESCE(ret.cnt, 0)     AS returnCount, " +
            "    COALESCE(fine.total, 0)  AS fineCollected " +
            "FROM Librarian lib " +
            "JOIN MemberProfile mp ON lib.userId = mp.userId " +
            // --- Số phiếu cấp: BorrowRecord.createdBy trong tháng ---
            "LEFT JOIN ( " +
            "    SELECT createdBy AS uid, COUNT(*) AS cnt " +
            "    FROM BorrowRecord " +
            "    WHERE EXTRACT(MONTH FROM startDate) = ? " +
            "      AND EXTRACT(YEAR  FROM startDate) = ? " +
            "    GROUP BY createdBy " +
            ") issue ON issue.uid = lib.userId " +
            // --- Số phiếu trả: returnedAt trong tháng, createdBy = thủ thư ---
            "LEFT JOIN ( " +
            "    SELECT createdBy AS uid, COUNT(*) AS cnt " +
            "    FROM BorrowRecord " +
            "    WHERE returnedAt IS NOT NULL " +
            "      AND EXTRACT(MONTH FROM returnedAt) = ? " +
            "      AND EXTRACT(YEAR  FROM returnedAt) = ? " +
            "    GROUP BY createdBy " +
            ") ret ON ret.uid = lib.userId " +
            // --- Tiền phạt đã thu: Payment.processedBy trong tháng ---
            "LEFT JOIN ( " +
            "    SELECT processedBy AS uid, SUM(paidAmount) AS total " +
            "    FROM Payment " +
            "    WHERE status = 'completed' " +
            "      AND EXTRACT(MONTH FROM paidAt) = ? " +
            "      AND EXTRACT(YEAR  FROM paidAt) = ? " +
            "    GROUP BY processedBy " +
            ") fine ON fine.uid = lib.userId " +
            "ORDER BY issueCount DESC, returnCount DESC " +
            (limit > 0 ? "LIMIT " + limit : "");

        List<StaffPerformanceDTO> result = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, month);
            ps.setInt(4, year);
            ps.setInt(5, month);
            ps.setInt(6, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffPerformanceDTO dto = new StaffPerformanceDTO();
                    dto.setUserId(rs.getInt("userId"));
                    dto.setFullName(rs.getString("fullName"));
                    dto.setStaffCode(rs.getString("staffCode"));
                    dto.setIssueCount(rs.getInt("issueCount"));
                    dto.setReturnCount(rs.getInt("returnCount"));
                    dto.setFineCollected(rs.getLong("fineCollected"));
                    dto.setMonth(month);
                    dto.setYear(year);
                    result.add(dto);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi lấy hiệu suất nhân viên tháng=" + month + "/năm=" + year, e);
        }
        return result;
    }

    /**
     * Tính tổng toàn hệ thống trong tháng: tổng phiếu cấp, tổng phiếu trả, tổng tiền thu.
     *
     * @param month Tháng (1–12)
     * @param year  Năm
     * @return mảng long[3] = {totalIssues, totalReturns, totalFineCollected}
     */
    public long[] getMonthTotals(int month, int year) {
        long totalIssues = 0, totalReturns = 0, totalFine = 0;

        // Tổng phiếu mượn trong tháng
        String sqlIssue = "SELECT COUNT(*) FROM BorrowRecord " +
                          "WHERE EXTRACT(MONTH FROM startDate) = ? AND EXTRACT(YEAR FROM startDate) = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlIssue)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalIssues = rs.getLong(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng phiếu mượn tháng", e);
        }

        // Tổng phiếu trả trong tháng
        String sqlReturn = "SELECT COUNT(*) FROM BorrowRecord " +
                           "WHERE returnedAt IS NOT NULL " +
                           "  AND EXTRACT(MONTH FROM returnedAt) = ? AND EXTRACT(YEAR FROM returnedAt) = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlReturn)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalReturns = rs.getLong(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng phiếu trả tháng", e);
        }

        // Tổng tiền phạt đã thu trong tháng
        String sqlFine = "SELECT COALESCE(SUM(paidAmount), 0) FROM Payment " +
                         "WHERE status = 'completed' " +
                         "  AND EXTRACT(MONTH FROM paidAt) = ? AND EXTRACT(YEAR FROM paidAt) = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlFine)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalFine = rs.getLong(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tổng hợp tiền phạt thu tháng", e);
        }

        return new long[]{totalIssues, totalReturns, totalFine};
    }
}
