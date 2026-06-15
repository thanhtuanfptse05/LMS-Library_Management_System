package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UserLookupDAO — DAO chuyên trách việc tra cứu và ánh xạ mã độc giả (studentCode/lecturerCode) sang userId.
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng PreparedStatement với tham số ?.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC được đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>TRANS-01: Nhận Connection từ tham số để tham gia cùng Transaction của Service.</li>
 * </ul>
 */
public class UserLookupDAO {

    private static final Logger LOGGER = Logger.getLogger(UserLookupDAO.class.getName());

    /**
     * Ánh xạ mã định danh độc giả (studentCode hoặc lecturerCode) sang userId.
     *
     * @param conn       Connection được truyền từ Service
     * @param memberCode Mã số sinh viên (studentCode) hoặc mã giảng viên (lecturerCode)
     * @return userId dạng Integer nếu tìm thấy, hoặc null nếu không tồn tại
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Integer findUserIdByMemberCode(Connection conn, String memberCode) throws SQLException {
        if (memberCode == null || memberCode.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT u.userId "
                   + "FROM   \"User\" u "
                   + "LEFT JOIN Student s ON u.userId = s.userId "
                   + "LEFT JOIN Lecturer l ON u.userId = l.userId "
                   + "WHERE  s.studentCode = ? "
                   + "   OR  l.lecturerCode = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, memberCode.trim());
            ps.setString(2, memberCode.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("userId");
                    return rs.wasNull() ? null : id;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tra cứu userId từ memberCode=" + memberCode, e);
            throw e;
        }
        return null;
    }
}
