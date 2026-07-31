package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DocumentTemp;
import util.DatabaseConnection;

/**
 * DocumentTempDAO — Data Access Object cho bảng [DocumentTemp].
 *
 * <p>Bảng DocumentTemp hoạt động như bảng cấu hình hệ thống (System Config).
 * Lưu trữ 6 Mẫu Email hệ thống dùng cho tiến trình ngầm Async Email Sender
 * gửi thông báo tự động bị động (Passive Notification) tới độc giả.</p>
 *
 * <p>Quy tắc vận hành:</p>
 * <ul>
 *   <li>Admin được phép UPDATE subject và bodyContent.</li>
 *   <li>Admin KHÔNG ĐƯỢC PHÉP xóa các mẫu trong {@link #PROTECTED_TEMPLATES}.</li>
 *   <li>Phương thức {@link #delete(int)} sẽ trả về {@code false} ngay lập tức
 *       nếu tempName thuộc danh sách bảo vệ.</li>
 * </ul>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement}.</li>
 *   <li>ENG-01: try-with-resources cho mọi tài nguyên JDBC.</li>
 *   <li>ARCH-01: JDBC thuần, không ORM.</li>
 * </ul>
 */
public class DocumentTempDAO {

    private static final Logger LOGGER = Logger.getLogger(DocumentTempDAO.class.getName());

    /**
     * Danh sách tempName hệ thống — KHÔNG ĐƯỢC PHÉP XÓA.
     * Đây là các mẫu email cốt lõi được seed sẵn khi deploy hệ thống.
     */
    public static final Set<String> PROTECTED_TEMPLATES = Set.of(
            "RESET_PASSWORD",
            "RESERVATION_READY",
            "RENEWAL_CONFIRMATION",
            "OVERDUE_NOTICE",
            "INCIDENT_FINE_NOTICE",
            "PAYMENT_CONFIRMATION"
    );

    // =========================================================================
    // SELECT
    // =========================================================================

    /**
     * Lấy toàn bộ danh sách mẫu Email. Dùng cho trang quản lý của Admin.
     *
     * @return Danh sách DocumentTemp, danh sách rỗng nếu không có dữ liệu
     */
    public List<DocumentTemp> getAll() {
        String sql = "SELECT tempId, tempName, description, subject, bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp ORDER BY tempName ASC";

        List<DocumentTemp> list = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToDocumentTemp(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all document templates", e);
        }
        return list;
    }

    /**
     * Tìm mẫu Email theo tên định danh (tempName).
     * Hàm này được gọi bởi tiến trình ngầm Async Email Sender để lấy template.
     *
     * @param tempName Tên định danh mẫu (VD: 'OVERDUE_NOTICE', 'RESERVATION_READY')
     * @return DocumentTemp nếu tìm thấy, null nếu không tồn tại
     */
    public DocumentTemp findByTempName(String tempName) {
        String sql = "SELECT tempId, tempName, description, subject, bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp WHERE tempName = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tempName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDocumentTemp(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding document template by name=" + tempName, e);
        }
        return null;
    }

    /**
     * Tìm mẫu Email theo ID.
     *
     * @param tempId ID mẫu cần tìm
     * @return DocumentTemp nếu tìm thấy, null nếu không tồn tại
     */
    public DocumentTemp findById(int tempId) {
        String sql = "SELECT tempId, tempName, description, subject, bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp WHERE tempId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tempId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDocumentTemp(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding document template by id=" + tempId, e);
        }
        return null;
    }

    // =========================================================================
    // INSERT
    // =========================================================================

    /**
     * Thêm mẫu Email mới vào CSDL (Chỉ dùng khi khởi tạo bổ sung, không phải seed hệ thống).
     *
     * @param dt Đối tượng DocumentTemp cần lưu (tempId sẽ bị bỏ qua)
     * @return ID tự động tăng vừa được tạo, -1 nếu thất bại
     */
    public int insert(DocumentTemp dt) {
        String sql = "INSERT INTO DocumentTemp (tempName, description, subject, bodyContent, managerId, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, dt.getTempName());
            ps.setString(2, dt.getDescription());
            ps.setString(3, dt.getSubject());
            ps.setString(4, dt.getBodyContent());
            ps.setInt(5, dt.getManagerId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting document template: " + dt.getTempName(), e);
        }
        return -1;
    }

    // =========================================================================
    // UPDATE
    // =========================================================================

    /**
     * Cập nhật nội dung mẫu Email. Chỉ Admin mới được thực hiện.
     * Cập nhật được phép: subject, bodyContent, updatedAt.
     * Không được phép thay đổi: tempName, description (do đây là metadata hệ thống).
     *
     * @param dt Đối tượng DocumentTemp chứa dữ liệu mới (tempId dùng để định vị bản ghi)
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean update(DocumentTemp dt) {
        String sql = "UPDATE DocumentTemp SET subject = ?, bodyContent = ?, updatedAt = NOW() "
                + "WHERE tempId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dt.getSubject());
            ps.setString(2, dt.getBodyContent());
            ps.setInt(3, dt.getTempId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating document template id=" + dt.getTempId(), e);
        }
        return false;
    }

    // =========================================================================
    // DELETE (có bảo vệ mẫu hệ thống)
    // =========================================================================

    /**
     * Xóa mẫu Email. Chỉ Admin mới được thực hiện.
     *
     * <p><strong>Bảo vệ hệ thống:</strong> Phương thức này sẽ TỪ CHỐI (trả về false)
     * nếu mẫu có tempName thuộc {@link #PROTECTED_TEMPLATES}.
     * Controller phải gọi {@link #isProtected(int)} trước để hiển thị thông báo lỗi phù hợp.</p>
     *
     * @param tempId ID của mẫu Email cần xóa
     * @return true nếu xóa thành công, false nếu thất bại hoặc là mẫu hệ thống
     */
    public boolean delete(int tempId) {
        // Kiểm tra bảo vệ: không xóa mẫu hệ thống
        DocumentTemp existing = findById(tempId);
        if (existing == null) {
            return false;
        }
        if (PROTECTED_TEMPLATES.contains(existing.getTempName())) {
            LOGGER.log(Level.WARNING, "[PROTECTED] Từ chối xóa mẫu email hệ thống: {0}", existing.getTempName());
            return false;
        }

        String sql = "DELETE FROM DocumentTemp WHERE tempId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tempId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting document template id=" + tempId, e);
        }
        return false;
    }

    /**
     * Kiểm tra xem một mẫu Email có thuộc danh sách được bảo vệ không.
     * Controller nên gọi hàm này trước khi gọi {@link #delete(int)} để hiển thị
     * thông báo lỗi phù hợp cho người dùng.
     *
     * @param tempId ID mẫu cần kiểm tra
     * @return true nếu là mẫu hệ thống (không được xóa), false nếu có thể xóa
     */
    public boolean isProtected(int tempId) {
        DocumentTemp dt = findById(tempId);
        return dt != null && PROTECTED_TEMPLATES.contains(dt.getTempName());
    }

    // =========================================================================
    // Private helper
    // =========================================================================

    /**
     * Ánh xạ một dòng ResultSet thành đối tượng DocumentTemp.
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng DocumentTemp đã populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu
     */
    private DocumentTemp mapResultSetToDocumentTemp(ResultSet rs) throws SQLException {
        DocumentTemp dt = new DocumentTemp();
        dt.setTempId(rs.getInt("tempId"));
        dt.setTempName(rs.getString("tempName"));
        dt.setDescription(rs.getString("description"));
        dt.setSubject(rs.getString("subject"));
        dt.setBodyContent(rs.getString("bodyContent"));
        dt.setManagerId(rs.getInt("managerId"));
        dt.setCreatedAt(rs.getTimestamp("createdAt"));
        dt.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return dt;
    }
}
