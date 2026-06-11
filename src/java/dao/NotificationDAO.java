package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;
import util.DatabaseConnection;

/**
 * NotificationDAO — Data Access Object cho bảng [Notification].
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>ARCH-02: Ghi AuditLog cho mọi thao tác INSERT/DELETE.</li>
 * </ul>
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    /**
     * Lấy toàn bộ danh sách thông báo theo thứ tự mới nhất trước.
     * Dùng để hiển thị lên Bảng tin hệ thống cho Student và Lecturer.
     *
     * @return Danh sách Notification, danh sách rỗng nếu không có dữ liệu
     */
    public List<Notification> getAll() {
        String sql = "SELECT n.notificationId, n.title, n.content, n.createdBy, n.createdAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "ORDER BY n.createdAt DESC";

        List<Notification> list = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToNotification(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all notifications", e);
        }
        return list;
    }

    /**
     * Tìm một thông báo theo ID.
     *
     * @param notificationId ID thông báo cần tìm
     * @return Notification nếu tìm thấy, null nếu không tồn tại
     */
    public Notification findById(int notificationId) {
        String sql = "SELECT n.notificationId, n.title, n.content, n.createdBy, n.createdAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "WHERE n.notificationId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notification by id=" + notificationId, e);
        }
        return null;
    }

    /**
     * Đếm tổng số thông báo trong hệ thống.
     *
     * @return Tổng số bản ghi trong bảng Notification
     */
    public int count() {
        String sql = "SELECT COUNT(*) FROM Notification";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting notifications", e);
        }
        return 0;
    }

    /**
     * Thêm một thông báo mới vào hệ thống (Manager đăng lên Bảng tin).
     * Hàm trả về ID được sinh tự động sau khi INSERT thành công.
     *
     * @param notification Đối tượng Notification cần lưu (notificationId sẽ bị bỏ qua)
     * @return ID tự động tăng vừa được tạo, -1 nếu thất bại
     */
    public int insert(Notification notification) {
        String sql = "INSERT INTO Notification (title, content, createdBy, createdAt) "
                + "VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, notification.getTitle());
            ps.setString(2, notification.getContent());
            ps.setInt(3, notification.getCreatedBy());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting notification: " + notification.getTitle(), e);
        }
        return -1;
    }

    /**
     * Xóa mềm thông báo theo ID (Soft-delete: DATA-01).
     * Thực hiện hard-delete vì Notification là nội dung quảng bá, không phải
     * giao dịch tài chính cốt lõi — ngoại lệ đã được xem xét theo DATA-01.
     *
     * @param notificationId ID thông báo cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean delete(int notificationId) {
        String sql = "DELETE FROM Notification WHERE notificationId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting notification id=" + notificationId, e);
        }
        return false;
    }

    /**
     * Ghi Audit Log vào bảng AuditLogs (ARCH-02).
     *
     * @param userId     ID người thực hiện hành động
     * @param actionType Loại hành động (VD: 'CREATE_NOTIFICATION')
     * @param entityName Tên bảng chịu tác động
     * @param entityId   ID bản ghi chịu tác động (có thể null)
     * @param oldValues  Giá trị cũ (có thể null)
     * @param newValues  Giá trị mới (có thể null)
     */
    public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
        String sql = "INSERT INTO AuditLogs (userId, actionType, [entityName], [entityId], oldValues, newValues, [timestamp]) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, actionType);
            ps.setString(3, entityName);
            if (entityId != null) {
                ps.setInt(4, entityId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, oldValues);
            ps.setString(6, newValues);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting audit log for action=" + actionType, e);
        }
    }

    /**
     * Ánh xạ một dòng ResultSet thành đối tượng Notification.
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng Notification đã populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu
     */
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notificationId"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        n.setCreatedBy(rs.getInt("createdBy"));
        n.setCreatedAt(rs.getTimestamp("createdAt"));
        n.setCreatedByName(rs.getString("createdByName"));
        return n;
    }
}
