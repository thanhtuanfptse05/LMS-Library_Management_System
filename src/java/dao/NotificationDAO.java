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
 * NotificationDAO ΓÇö Data Access Object cho bß║úng [Notification] v├á [UserNotificationStatus].
 *
 * <p>Tu├ón thß╗º nghi├¬m ngß║╖t:</p>
 * <ul>
 *   <li>SEC-03: 100% c├óu SQL d├╣ng {@code PreparedStatement} vß╗¢i tham sß╗æ {@code ?}.</li>
 *   <li>ENG-01: Mß╗ìi t├ái nguy├¬n JDBC ─æ├│ng an to├án bß║▒ng try-with-resources.</li>
 *   <li>ARCH-01: JDBC thuß║ºn ΓÇö kh├┤ng ORM, kh├┤ng Spring JDBC.</li>
 *   <li>ARCH-02: Ghi AuditLog cho mß╗ìi thao t├íc INSERT/UPDATE/DELETE.</li>
 * </ul>
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
    // SELECT ΓÇö Truy vß║Ñn danh s├ích th├┤ng b├ío
    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ

    /**
     * Lß║Ñy to├án bß╗Ö danh s├ích th├┤ng b├ío (ghim l├¬n ─æß║ºu, mß╗¢i nhß║Ñt tr╞░ß╗¢c).
     * D├╣ng ─æß╗â hiß╗ân thß╗ï trang quß║ún l├╜ cho Manager (kh├┤ng cß║ºn read-status).
     *
     * @return Danh s├ích Notification, danh s├ích rß╗ùng nß║┐u kh├┤ng c├│ dß╗» liß╗çu
     */
    public List<Notification> getAll() {
        String sql = "SELECT n.notificationId, n.title, n.content, n.type, n.isPinned, "
                + "n.createdBy, n.createdAt, n.updatedAt, "
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
     * Lß║Ñy danh s├ích th├┤ng b├ío c├│ ph├ón trang v├á lß╗ìc tß╗½ kh├│a (d├ánh cho trang Manager).
     *
     * @param keyword   Tß╗½ kh├│a t├¼m kiß║┐m (theo title), null hoß║╖c rß╗ùng = lß║Ñy tß║Ñt cß║ú
     * @param typeFilter Lß╗ìc theo loß║íi ('general', 'urgent', 'policy', 'event'), null = tß║Ñt cß║ú
     * @param page      Sß╗æ trang (1-indexed)
     * @param pageSize  Sß╗æ bß║ún ghi mß╗ùi trang
     * @return Danh s├ích Notification tr├¬n trang ─æ├│
     */
    public List<Notification> getAllPaged(String keyword, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT n.notificationId, n.title, n.content, n.type, n.isPinned, "
                + "n.createdBy, n.createdAt, n.updatedAt, "
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
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

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
     * ─Éß║┐m tß╗òng sß╗æ th├┤ng b├ío khß╗¢p vß╗¢i ─æiß╗üu kiß╗çn lß╗ìc (d├╣ng ─æß╗â t├¡nh sß╗æ trang).
     *
     * @param keyword    Tß╗½ kh├│a t├¼m kiß║┐m
     * @param typeFilter Lß╗ìc theo loß║íi
     * @return Tß╗òng sß╗æ bß║ún ghi
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
     * Lß║Ñy danh s├ích th├┤ng b├ío k├¿m trß║íng th├íi ─æ├ú ─æß╗ìc/ch╞░a ─æß╗ìc cho mß╗Öt ng╞░ß╗¥i d├╣ng cß╗Ñ thß╗â.
     * Ghim l├¬n ─æß║ºu, ch╞░a ─æß╗ìc tr╞░ß╗¢c, mß╗¢i nhß║Ñt tr╞░ß╗¢c.
     *
     * @param userId   ID ng╞░ß╗¥i d├╣ng hiß╗çn ─æang ─æ─âng nhß║¡p
     * @param keyword  Tß╗½ kh├│a t├¼m kiß║┐m theo title (null = tß║Ñt cß║ú)
     * @param typeFilter Lß╗ìc theo type (null = tß║Ñt cß║ú)
     * @param page     Sß╗æ trang (1-indexed)
     * @param pageSize Sß╗æ bß║ún ghi mß╗ùi trang
     * @return Danh s├ích Notification ─æ├ú ─æ╞░ß╗úc ─æ├ính dß║Ñu isRead
     */
    public List<Notification> getAllForUser(int userId, String keyword, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT n.notificationId, n.title, n.content, n.type, n.isPinned, "
                + "n.createdBy, n.createdAt, n.updatedAt, "
                + "mp.fullName AS createdByName, "
                + "CASE WHEN uns.userId IS NOT NULL THEN 1 ELSE 0 END AS isRead "
                + "FROM Notification n "
                + "LEFT JOIN MemberProfile mp ON n.createdBy = mp.userId "
                + "LEFT JOIN UserNotificationStatus uns "
                + "    ON uns.notificationId = n.notificationId AND uns.userId = ? "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
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
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

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
     * ─Éß║┐m sß╗æ th├┤ng b├ío ch╞░a ─æß╗ìc cß╗ºa mß╗Öt ng╞░ß╗¥i d├╣ng (d├╣ng ─æß╗â hiß╗ân thß╗ï badge).
     *
     * @param userId ID ng╞░ß╗¥i d├╣ng
     * @return Sß╗æ l╞░ß╗úng th├┤ng b├ío ch╞░a ─æß╗ìc
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
     * T├¼m mß╗Öt th├┤ng b├ío theo ID (kh├┤ng cß║ºn trß║íng th├íi ─æß╗ìc).
     *
     * @param notificationId ID th├┤ng b├ío cß║ºn t├¼m
     * @return Notification nß║┐u t├¼m thß║Ñy, null nß║┐u kh├┤ng tß╗ôn tß║íi
     */
    public Notification findById(int notificationId) {
        String sql = "SELECT n.notificationId, n.title, n.content, n.type, n.isPinned, "
                + "n.createdBy, n.createdAt, n.updatedAt, "
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
     * ─Éß║┐m tß╗òng sß╗æ th├┤ng b├ío trong hß╗ç thß╗æng.
     *
     * @return Tß╗òng sß╗æ bß║ún ghi trong bß║úng Notification
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

    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
    // INSERT / UPDATE / DELETE ΓÇö Thay ─æß╗òi dß╗» liß╗çu
    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ

    /**
     * Th├¬m mß╗Öt th├┤ng b├ío mß╗¢i v├áo hß╗ç thß╗æng.
     * H├ám trß║ú vß╗ü ID ─æ╞░ß╗úc sinh tß╗▒ ─æß╗Öng sau khi INSERT th├ánh c├┤ng.
     *
     * @param notification ─Éß╗æi t╞░ß╗úng Notification cß║ºn l╞░u (notificationId sß║╜ bß╗ï bß╗Å qua)
     * @return ID tß╗▒ ─æß╗Öng t─âng vß╗½a ─æ╞░ß╗úc tß║ío, -1 nß║┐u thß║Ñt bß║íi
     */
    public int insert(Notification notification) {
        String sql = "INSERT INTO Notification (title, content, type, isPinned, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, notification.getTitle());
            ps.setString(2, notification.getContent());
            ps.setString(3, notification.getType() != null ? notification.getType() : "general");
            ps.setBoolean(4, notification.isPinned());
            ps.setInt(5, notification.getCreatedBy());

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
     * Cß║¡p nhß║¡t nß╗Öi dung th├┤ng b├ío (title, content, type, isPinned).
     *
     * @param notification ─Éß╗æi t╞░ß╗úng Notification vß╗¢i notificationId ─æ├ú ─æ╞░ß╗úc set
     * @return true nß║┐u cß║¡p nhß║¡t th├ánh c├┤ng, false nß║┐u thß║Ñt bß║íi
     */
    public boolean update(Notification notification) {
        String sql = "UPDATE Notification SET title = ?, content = ?, type = ?, isPinned = ?, "
                + "updatedAt = GETDATE() WHERE notificationId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, notification.getTitle());
            ps.setString(2, notification.getContent());
            ps.setString(3, notification.getType() != null ? notification.getType() : "general");
            ps.setBoolean(4, notification.isPinned());
            ps.setInt(5, notification.getNotificationId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating notification id=" + notification.getNotificationId(), e);
        }
        return false;
    }

    /**
     * X├│a th├┤ng b├ío theo ID.
     * Notification l├á nß╗Öi dung quß║úng b├í, kh├┤ng phß║úi giao dß╗ïch cß╗æt l├╡i ΓÇö hard-delete ─æ╞░ß╗úc chß║Ñp nhß║¡n (DATA-01 ngoß║íi lß╗ç).
     *
     * @param notificationId ID th├┤ng b├ío cß║ºn x├│a
     * @return true nß║┐u x├│a th├ánh c├┤ng, false nß║┐u thß║Ñt bß║íi
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

    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
    // READ STATUS ΓÇö Trß║íng th├íi ─æ├ú ─æß╗ìc (bß║úng UserNotificationStatus)
    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ

    /**
     * ─É├ính dß║Ñu mß╗Öt th├┤ng b├ío l├á ─æ├ú ─æß╗ìc cho ng╞░ß╗¥i d├╣ng cß╗Ñ thß╗â.
     * Sß╗¡ dß╗Ñng MERGE / INSERT nß║┐u ch╞░a tß╗ôn tß║íi, bß╗Å qua nß║┐u ─æ├ú ─æß╗ìc.
     *
     * @param userId         ID ng╞░ß╗¥i d├╣ng
     * @param notificationId ID th├┤ng b├ío ─æ├ú ─æß╗ìc
     */
    public void markAsRead(int userId, int notificationId) {
        String sql = "IF NOT EXISTS ("
                + "  SELECT 1 FROM UserNotificationStatus WHERE userId = ? AND notificationId = ?"
                + ") "
                + "INSERT INTO UserNotificationStatus (userId, notificationId, readAt) VALUES (?, ?, GETDATE())";

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
     * ─É├ính dß║Ñu Tß║ñT Cß║ó th├┤ng b├ío l├á ─æ├ú ─æß╗ìc cho ng╞░ß╗¥i d├╣ng.
     *
     * @param userId ID ng╞░ß╗¥i d├╣ng
     */
    public void markAllAsRead(int userId) {
        String sql = "INSERT INTO UserNotificationStatus (userId, notificationId, readAt) "
                + "SELECT ?, n.notificationId, GETDATE() FROM Notification n "
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

    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
    // AUDIT LOG ΓÇö Ghi nhß║¡t k├╜ thao t├íc (ARCH-02)
    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ

    /**
     * Ghi Audit Log v├áo bß║úng AuditLogs (ARCH-02).
     *
     * @param userId     ID ng╞░ß╗¥i thß╗▒c hiß╗çn h├ánh ─æß╗Öng
     * @param actionType Loß║íi h├ánh ─æß╗Öng (VD: 'CREATE_NOTIFICATION', 'UPDATE_NOTIFICATION')
     * @param entityName T├¬n bß║úng chß╗ïu t├íc ─æß╗Öng
     * @param entityId   ID bß║ún ghi chß╗ïu t├íc ─æß╗Öng (c├│ thß╗â null)
     * @param oldValues  Gi├í trß╗ï c┼⌐ (c├│ thß╗â null)
     * @param newValues  Gi├í trß╗ï mß╗¢i (c├│ thß╗â null)
     */
    public void insertAuditLog(Integer userId, String actionType, String entityName,
                               Integer entityId, String oldValues, String newValues) {
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

    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
    // MAPPING ΓÇö ├ünh xß║í ResultSet th├ánh ─æß╗æi t╞░ß╗úng
    // ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ

    /**
     * ├ünh xß║í mß╗Öt d├▓ng ResultSet th├ánh ─æß╗æi t╞░ß╗úng Notification (kh├┤ng bao gß╗ôm isRead).
     *
     * @param rs ResultSet ─æang trß╗Å tß╗¢i d├▓ng dß╗» liß╗çu hß╗úp lß╗ç
     * @return ─Éß╗æi t╞░ß╗úng Notification ─æ├ú populate ─æß║ºy ─æß╗º
     * @throws SQLException nß║┐u c├│ lß╗ùi ─æß╗ìc dß╗» liß╗çu
     */
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notificationId"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        n.setType(rs.getString("type"));
        n.setPinned(rs.getBoolean("isPinned"));
        n.setCreatedBy(rs.getInt("createdBy"));
        n.setCreatedAt(rs.getTimestamp("createdAt"));
        n.setUpdatedAt(rs.getTimestamp("updatedAt"));
        n.setCreatedByName(rs.getString("createdByName"));
        return n;
    }
}
