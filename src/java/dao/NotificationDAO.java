package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;
import util.DatabaseConnection;

/**
 * NotificationDAO — Data Access Object cho bảng [Notification] và [UserNotificationStatus].
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement} với tham số {@code ?}.</li>
 *   <li>ENG-01: Mọi tài nguyên JDBC đóng an toàn bằng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuần — không ORM, không Spring JDBC.</li>
 *   <li>ARCH-02: Ghi AuditLog cho mọi thao tác INSERT/UPDATE/DELETE.</li>
 * </ul>
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    // ═══════════════════════════════════════════════════════════
    // SELECT — Truy vấn danh sách thông báo
    // ═══════════════════════════════════════════════════════════

    /**
     * Lấy toàn bộ danh sách thông báo (ghim lên đầu, mới nhất trước).
     * Dùng để hiển thị trang quản lý cho Manager (không cần read-status).
     *
     * @return Danh sách Notification, danh sách rỗng nếu không có dữ liệu
     */
    public List<Notification> getAll() {
        String sql = "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "ORDER BY n.isPinned DESC, n.createdAt DESC";

        List<Notification> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all notifications", e);
        }
        return list;
    }

    /**
     * Lấy danh sách thông báo có phân trang và lọc từ khóa (dành cho trang Manager).
     *
     * @param keyword   Từ khóa tìm kiếm (theo title), null hoặc rỗng = lấy tất cả
     * @param typeFilter Lọc theo loại ('general', 'urgent', 'policy', 'event'), null = tất cả
     * @param page      Số trang (1-indexed)
     * @param pageSize  Số bản ghi mỗi trang
     * @return Danh sách Notification trên trang đó
     */
    public List<Notification> getAllPaged(String keyword, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND n.title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND n.type = ? ");
            params.add(typeFilter.trim());
        }
        sql.append("ORDER BY n.isPinned DESC, n.createdAt DESC ")
           .append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Notification> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching paged notifications", e);
        }
        return list;
    }

    /**
     * Đếm tổng số thông báo khớp với điều kiện lọc (dùng để tính số trang).
     *
     * @param keyword    Từ khóa tìm kiếm
     * @param typeFilter Lọc theo loại
     * @return Tổng số bản ghi
     */
    public int countFiltered(String keyword, String typeFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Notification WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND type = ? ");
            params.add(typeFilter.trim());
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting filtered notifications", e);
        }
        return 0;
    }

    /**
     * Lấy danh sách thông báo kèm trạng thái đã đọc/chưa đọc cho một người dùng cụ thể.
     * Ghim lên đầu, chưa đọc trước, mới nhất trước.
     *
     * @param userId   ID người dùng hiện đang đăng nhập
     * @param keyword  Từ khóa tìm kiếm theo title (null = tất cả)
     * @param typeFilter Lọc theo type (null = tất cả)
     * @param page     Số trang (1-indexed)
     * @param pageSize Số bản ghi mỗi trang
     * @return Danh sách Notification đã được đánh dấu isRead
     */
    public List<Notification> getAllForUser(int userId, String keyword, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName, "
                + "CASE WHEN uns.userId IS NOT NULL THEN 1 ELSE 0 END AS isRead "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "LEFT JOIN UserNotificationStatus uns "
                + "    ON uns.notificationId = n.notificationId AND uns.userId = ? "
                + "WHERE (n.targetRole = 'ALL' OR n.targetRole = (SELECT UPPER(role) FROM \"User\" WHERE userId = ?)) ");

        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(userId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND n.title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND n.type = ? ");
            params.add(typeFilter.trim());
        }
        sql.append("ORDER BY n.isPinned DESC, isRead ASC, n.createdAt DESC ")
           .append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Notification> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = mapRow(rs);
                    n.setRead(rs.getInt("isRead") == 1);
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching notifications for userId=" + userId, e);
        }
        return list;
    }

    /**
     * Đếm số thông báo chưa đọc của một người dùng (dùng để hiển thị badge).
     *
     * @param userId ID người dùng
     * @return Số lượng thông báo chưa đọc
     */
    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM Notification n "
                + "WHERE NOT EXISTS ("
                + "  SELECT 1 FROM UserNotificationStatus uns "
                + "  WHERE uns.notificationId = n.notificationId AND uns.userId = ?"
                + ")";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unread notifications for userId=" + userId, e);
        }
        return 0;
    }

    /**
     * Tìm một thông báo theo ID (không cần trạng thái đọc).
     *
     * @param notificationId ID thông báo cần tìm
     * @return Notification nếu tìm thấy, null nếu không tồn tại
     */
    public Notification findById(int notificationId) {
        String sql = "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "WHERE n.notificationId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
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

    // ═══════════════════════════════════════════════════════════
    // INSERT / UPDATE / DELETE — Thay đổi dữ liệu
    // ═══════════════════════════════════════════════════════════

    /**
     * Thêm một thông báo mới vào hệ thống.
     * Hàm trả về ID được sinh tự động sau khi INSERT thành công.
     *
     * @param notification Đối tượng Notification cần lưu (notificationId sẽ bị bỏ qua)
     * @return ID tự động tăng vừa được tạo, -1 nếu thất bại
     */
    public int insert(Notification notification) {
        String sql = "INSERT INTO Notification (title, content, type, targetRole, isPinned, thumbnailUrl, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, notification.getTitle());
            ps.setString(2, notification.getContent());
            ps.setString(3, notification.getType() != null ? notification.getType() : "general");
            ps.setString(4, notification.getTargetRole() != null ? notification.getTargetRole() : "ALL");
            ps.setBoolean(5, notification.isPinned());
            String thumb = notification.getThumbnailUrl();
            if (thumb != null && !thumb.trim().isEmpty()) {
                ps.setString(6, thumb.trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            ps.setInt(7, notification.getCreatedBy());

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
     * Cập nhật nội dung thông báo (title, content, type, isPinned).
     *
     * @param notification Đối tượng Notification với notificationId đã được set
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean update(Notification notification) {
        String sql = "UPDATE Notification SET title = ?, content = ?, type = ?, targetRole = ?, isPinned = ?, "
                + "thumbnailUrl = ?, updatedAt = NOW() WHERE notificationId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, notification.getTitle());
            ps.setString(2, notification.getContent());
            ps.setString(3, notification.getType() != null ? notification.getType() : "general");
            ps.setString(4, notification.getTargetRole() != null ? notification.getTargetRole() : "ALL");
            ps.setBoolean(5, notification.isPinned());
            String thumb = notification.getThumbnailUrl();
            if (thumb != null && !thumb.trim().isEmpty()) {
                ps.setString(6, thumb.trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            ps.setInt(7, notification.getNotificationId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating notification id=" + notification.getNotificationId(), e);
        }
        return false;
    }

    /**
     * Xóa thông báo theo ID.
     * Notification là nội dung quảng bá, không phải giao dịch cốt lõi — hard-delete được chấp nhận (DATA-01 ngoại lệ).
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

    // ═══════════════════════════════════════════════════════════
    // READ STATUS — Trạng thái đã đọc (bảng UserNotificationStatus)
    // ═══════════════════════════════════════════════════════════

    /**
     * Đánh dấu một thông báo là đã đọc cho người dùng cụ thể.
     * Sử dụng MERGE / INSERT nếu chưa tồn tại, bỏ qua nếu đã đọc.
     *
     * @param userId         ID người dùng
     * @param notificationId ID thông báo đã đọc
     */
    public void markAsRead(int userId, int notificationId) {
        String sql = "INSERT INTO UserNotificationStatus (userId, notificationId, readAt) "
                + "SELECT ?, ?, NOW() WHERE NOT EXISTS ("
                + "  SELECT 1 FROM UserNotificationStatus WHERE userId = ? AND notificationId = ?"
                + ")";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, notificationId);
            ps.setInt(3, userId);
            ps.setInt(4, notificationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: userId=" + userId + " notifId=" + notificationId, e);
        }
    }

    /**
     * Đánh dấu TẤT CẢ thông báo là đã đọc cho người dùng.
     *
     * @param userId ID người dùng
     */
    public void markAllAsRead(int userId) {
        String sql = "INSERT INTO UserNotificationStatus (userId, notificationId, readAt) "
                + "SELECT ?, n.notificationId, NOW() FROM Notification n "
                + "WHERE NOT EXISTS ("
                + "  SELECT 1 FROM UserNotificationStatus uns "
                + "  WHERE uns.userId = ? AND uns.notificationId = n.notificationId"
                + ")";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking all notifications as read for userId=" + userId, e);
        }
    }

    // ═══════════════════════════════════════════════════════════
    // AUDIT LOG — Ghi nhật ký thao tác (ARCH-02)
    // ═══════════════════════════════════════════════════════════

    /**
     * Ghi Audit Log vào bảng AuditLogs (ARCH-02).
     *
     * @param userId     ID người thực hiện hành động
     * @param actionType Loại hành động (VD: 'CREATE_NOTIFICATION', 'UPDATE_NOTIFICATION')
     * @param entityName Tên bảng chịu tác động
     * @param entityId   ID bản ghi chịu tác động (có thể null)
     * @param oldValues  Giá trị cũ (có thể null)
     * @param newValues  Giá trị mới (có thể null)
     */
    public void insertAuditLog(Integer userId, String actionType, String entityName,
                               Integer entityId, String oldValues, String newValues) {
        String sql = "INSERT INTO AuditLogs (userId, actionType, entityName, entityId, oldValues, newValues, timestamp) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

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

    // ═══════════════════════════════════════════════════════════
    // PUBLIC NEWS — Truy vấn tin tức công khai (type: general/event)
    // ═══════════════════════════════════════════════════════════

    /**
     * Lấy tin tức công khai có phân trang — chỉ lấy type IN ('general','event').
     *
     * @param typeFilter null = tất cả, "general" hoặc "event" = lọc theo tab
     * @param page       Số trang (1-indexed)
     * @param pageSize   Số bản ghi mỗi trang
     * @return Danh sách Notification công khai
     */
    public List<Notification> getPublicNewsPaged(String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "WHERE n.type IN ('general','event') ");

        List<Object> params = new ArrayList<>();
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND n.type = ? ");
            params.add(typeFilter.trim());
        }
        sql.append("ORDER BY n.isPinned DESC, n.createdAt DESC "
                + "LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Notification> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching public news paged", e);
        }
        return list;
    }

    /**
     * Đếm tổng tin tức công khai (type IN 'general','event') — dùng để tính số trang.
     *
     * @param typeFilter null = tất cả, "general" hoặc "event" = lọc theo tab
     * @return Tổng số bản ghi
     */
    public int countPublicNews(String typeFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Notification WHERE type IN ('general','event') ");
        List<Object> params = new ArrayList<>();
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND type = ? ");
            params.add(typeFilter.trim());
        }
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting public news", e);
        }
        return 0;
    }

    /**
     * Lấy N tin tức mới nhất (type IN 'general','event') cho trang chủ.
     *
     * @param limit Số bản ghi tối đa cần lấy
     * @return Danh sách Notification mới nhất
     */
    public List<Notification> getRecentNews(int limit) {
        String sql = "SELECT n.notificationId, n.title, n.content, n.type, n.targetRole, n.isPinned, "
                + "n.thumbnailUrl, n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "WHERE n.type IN ('general','event') "
                + "ORDER BY n.createdAt DESC "
                + "LIMIT ?";

        List<Notification> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent news", e);
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // MAPPING — Ánh xạ ResultSet thành đối tượng
    // ═══════════════════════════════════════════════════════════

    /**
     * Ánh xạ một dòng ResultSet thành đối tượng Notification (không bao gồm isRead).
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng Notification đã populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu
     */
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notificationId"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        n.setType(rs.getString("type"));
        n.setTargetRole(rs.getString("targetRole"));
        n.setPinned(rs.getBoolean("isPinned"));
        n.setThumbnailUrl(rs.getString("thumbnailUrl"));
        n.setCreatedBy(rs.getInt("createdBy"));
        n.setCreatedAt(rs.getTimestamp("createdAt"));
        n.setUpdatedAt(rs.getTimestamp("updatedAt"));
        n.setCreatedByName(rs.getString("createdByName"));
        return n;
    }
}
