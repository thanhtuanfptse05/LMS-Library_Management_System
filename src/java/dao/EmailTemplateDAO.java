package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.EmailTemplate;
import util.DatabaseConnection;

/**
 * EmailTemplateDAO — Data Access Object cho bảng [EmailTemplate].
 *
 * <p>Bảng EmailTemplate lưu trữ 6 Mẫu Email Hệ Thống dùng cho tiến trình ngầm
 * Async Email Sender gửi thông báo tự động bị động (Passive Notification).</p>
 *
 * <p>Quy tắc vận hành:</p>
 * <ul>
 *   <li>Mẫu chỉ được tạo bởi seed SQL khi deploy — DAO KHÔNG có insert().</li>
 *   <li>Manager được phép UPDATE subject và bodyContent.</li>
 *   <li>Manager KHÔNG ĐƯỢC PHÉP xóa mẫu — DAO KHÔNG có delete().</li>
 * </ul>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement}.</li>
 *   <li>ENG-01: try-with-resources cho mọi tài nguyên JDBC.</li>
 *   <li>ARCH-01: JDBC thuần, không ORM.</li>
 * </ul>
 */
public class EmailTemplateDAO {

    private static final Logger LOGGER = Logger.getLogger(EmailTemplateDAO.class.getName());

    // =========================================================================
    // SELECT
    // =========================================================================

    /**
     * Lấy toàn bộ danh sách mẫu Email hệ thống.
     * Dùng cho trang quản lý Passive templates của Manager.
     *
     * @return Danh sách EmailTemplate, danh sách rỗng nếu không có dữ liệu
     */
    public List<EmailTemplate> getAll() {
        String sql = "SELECT templateId, tempName, description, subject, bodyContent, updatedBy, updatedAt "
                + "FROM EmailTemplate ORDER BY tempName ASC";

        List<EmailTemplate> list = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[EmailTemplateDAO] Lỗi khi lấy danh sách mẫu email hệ thống", e);
        }
        return list;
    }

    /**
     * Tìm mẫu Email theo tên định danh (tempName).
     * Hàm này được gọi bởi tiến trình ngầm EmailWorker để lấy template trước khi gửi.
     *
     * @param tempName Tên định danh mẫu (VD: 'OVERDUE_NOTICE', 'RESERVATION_READY')
     * @return EmailTemplate nếu tìm thấy, null nếu không tồn tại
     */
    public EmailTemplate findByTempName(String tempName) {
        String sql = "SELECT templateId, tempName, description, subject, bodyContent, updatedBy, updatedAt "
                + "FROM EmailTemplate WHERE tempName = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tempName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[EmailTemplateDAO] Lỗi khi tìm mẫu email theo tempName=" + tempName, e);
        }
        return null;
    }

    /**
     * Tìm mẫu Email theo ID.
     *
     * @param templateId ID mẫu cần tìm
     * @return EmailTemplate nếu tìm thấy, null nếu không tồn tại
     */
    public EmailTemplate findById(int templateId) {
        String sql = "SELECT templateId, tempName, description, subject, bodyContent, updatedBy, updatedAt "
                + "FROM EmailTemplate WHERE templateId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, templateId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[EmailTemplateDAO] Lỗi khi tìm mẫu email theo id=" + templateId, e);
        }
        return null;
    }

    // =========================================================================
    // UPDATE (không có INSERT, DELETE — mẫu hệ thống chỉ do seed SQL tạo)
    // =========================================================================

    /**
     * Cập nhật nội dung mẫu Email hệ thống.
     * Chỉ cho phép thay đổi: subject, bodyContent.
     * Tự động ghi nhận updatedBy và updatedAt.
     *
     * @param templateId  ID mẫu cần cập nhật
     * @param subject     Tiêu đề email mới
     * @param bodyContent Nội dung HTML mới
     * @param updatedBy   userId của người thực hiện cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean update(int templateId, String subject, String bodyContent, int updatedBy) {
        String sql = "UPDATE EmailTemplate SET subject = ?, bodyContent = ?, updatedBy = ?, updatedAt = NOW() "
                + "WHERE templateId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, subject);
            ps.setString(2, bodyContent);
            ps.setInt(3, updatedBy);
            ps.setInt(4, templateId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[EmailTemplateDAO] Lỗi khi cập nhật mẫu email id=" + templateId, e);
        }
        return false;
    }

    // =========================================================================
    // Private helper
    // =========================================================================

    /**
     * Ánh xạ một dòng ResultSet thành đối tượng EmailTemplate.
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng EmailTemplate đã populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu
     */
    private EmailTemplate mapResultSet(ResultSet rs) throws SQLException {
        EmailTemplate et = new EmailTemplate();
        et.setTemplateId(rs.getInt("templateId"));
        et.setTempName(rs.getString("tempName"));
        et.setDescription(rs.getString("description"));
        et.setSubject(rs.getString("subject"));
        et.setBodyContent(rs.getString("bodyContent"));
        int ub = rs.getInt("updatedBy");
        et.setUpdatedBy(rs.wasNull() ? null : ub);
        et.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return et;
    }
}
