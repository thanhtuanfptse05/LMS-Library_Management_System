package service;

import dao.AuditLogDAO;
import dao.UserLockReasonDAO;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UserExpirationProcessor — Xử lý tự động khóa tài khoản sinh viên sau 4 năm (khi hết thời hạn đào tạo).
 *
 * <p>ĐIỀU KIỆN KHÓA BẮT BUỘC:</p>
 * <ul>
 *   <li>Tài khoản là sinh viên (role = 'STUDENT') đang ở trạng thái status = 'active'.</li>
 *   <li>Ngày kết thúc đào tạo MemberProfile.endDate < CURRENT_DATE.</li>
 *   <li>KHÔNG còn nợ phạt chưa thanh toán (Fine.status = 'unpaid'). Nếu còn nợ phạt, KHÔNG KHÓA để sinh viên tiếp tục nộp phạt VietQR/SePay.</li>
 *   <li>KHÔNG còn sách mượn chưa trả (BorrowRecord.status IN ('borrowed', 'overdue')). Nếu còn giữ sách, KHÔNG KHÓA để thu hồi sách tại quầy.</li>
 * </ul>
 *
 * <p>Khi đủ điều kiện khóa: Tự động khóa tài khoản, hủy các đơn đặt trước (Reservation) còn tồn đọng, ghi UserLockReason và AuditLogs.</p>
 */
public class UserExpirationProcessor {
    private static final Logger LOGGER = Logger.getLogger(UserExpirationProcessor.class.getName());

    /** Cooldown tối thiểu giữa các lần chạy processExpiration() (milliseconds). */
    private static final long COOLDOWN_MS = 60_000L;

    /** Thời điểm chạy thành công gần nhất — dùng để throttle. */
    private static volatile long lastRunTimestamp = 0;

    /** Lock object để tránh nhiều thread chạy đồng thời. */
    private static final Object RUN_LOCK = new Object();

    private final UserLockReasonDAO userLockReasonDAO = new UserLockReasonDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    public ProcessResult processExpiration() {
        ProcessResult result = new ProcessResult();

        long now = System.currentTimeMillis();
        if (now - lastRunTimestamp < COOLDOWN_MS) {
            return result;
        }

        synchronized (RUN_LOCK) {
            if (System.currentTimeMillis() - lastRunTimestamp < COOLDOWN_MS) {
                return result;
            }

            try {
                result = doProcessExpiration();
            } finally {
                lastRunTimestamp = System.currentTimeMillis();
            }
        }

        return result;
    }

    private ProcessResult doProcessExpiration() {
        ProcessResult result = new ProcessResult();

        // 1. Quét tìm tài khoản Sinh viên (STUDENT) có endDate < CURRENT_DATE
        // Kiểm tra an toàn: KHÔNG nợ phạt ('unpaid') VÀ KHÔNG nợ sách mượn chưa trả ('borrowed', 'overdue')
        List<ExpiredUser> expiredUsers = new ArrayList<>();
        String sqlFind = "SELECT u.userId, u.email, u.role, p.endDate "
                + "FROM \"User\" u "
                + "JOIN MemberProfile p ON u.userId = p.userId "
                + "WHERE u.status = 'active' AND UPPER(u.role) = 'STUDENT' AND p.endDate IS NOT NULL AND p.endDate < CURRENT_DATE "
                + "AND NOT EXISTS (SELECT 1 FROM Fine f WHERE f.userId = u.userId AND f.status = 'unpaid') "
                + "AND NOT EXISTS (SELECT 1 FROM BorrowRecord br WHERE br.userId = u.userId AND br.status IN ('borrowed', 'overdue') AND br.returnedAt IS NULL)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlFind);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ExpiredUser eu = new ExpiredUser();
                eu.userId = rs.getInt("userId");
                eu.email = rs.getString("email");
                eu.role = rs.getString("role");
                eu.endDate = rs.getDate("endDate");
                expiredUsers.add(eu);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserExpirationProcessor] Lỗi khi quét tài khoản sinh viên quá hạn endDate", e);
            return result;
        }

        if (expiredUsers.isEmpty()) {
            return result;
        }

        LOGGER.log(Level.INFO, "[UserExpirationProcessor] Tìm thấy {0} tài khoản sinh viên đủ điều kiện tự động khóa (đã hết 4 năm, không nợ phạt, không nợ sách).", expiredUsers.size());

        // 2. Xử lý từng tài khoản trong DB Transaction độc lập
        String lockSql = "UPDATE \"User\" SET status = 'locked' WHERE userId = ? AND status = 'active'";
        String cancelResSql = "UPDATE Reservation SET status = 'cancelled', queuePosition = NULL, bookCopyId = NULL WHERE userId = ? AND status IN ('pending', 'readypickup')";

        for (ExpiredUser eu : expiredUsers) {
            Connection conn = null;
            try {
                conn = DatabaseConnection.getConnection();
                conn.setAutoCommit(false);

                int updatedRows;
                try (PreparedStatement psLock = conn.prepareStatement(lockSql)) {
                    psLock.setInt(1, eu.userId);
                    updatedRows = psLock.executeUpdate();
                }

                if (updatedRows > 0) {
                    // Hủy các đơn đặt trước còn tồn đọng của tài khoản này
                    try (PreparedStatement psCancelRes = conn.prepareStatement(cancelResSql)) {
                        psCancelRes.setInt(1, eu.userId);
                        psCancelRes.executeUpdate();
                    }

                    String lockReasonText = "Tài khoản sinh viên đã hết thời hạn 4 năm đào tạo (Hạn dùng: " + eu.endDate + ")";
                    userLockReasonDAO.insertLockReason(conn, eu.userId, lockReasonText);

                    String oldVal = String.format("{\"status\":\"active\",\"endDate\":\"%s\"}", eu.endDate);
                    String newVal = String.format("{\"status\":\"locked\",\"lockReason\":\"%s\"}", lockReasonText);
                    auditLogDAO.insert(conn, null, "AUTO_LOCK_EXPIRED_STUDENT_ACCOUNT", "User", eu.userId, oldVal, newVal);

                    conn.commit();
                    result.lockedCount++;
                    LOGGER.log(Level.INFO, "[UserExpirationProcessor] Đã tự động khóa tài khoản sinh viên hết thời hạn 4 năm — userId={0}, email={1}",
                            new Object[]{eu.userId, eu.email});
                } else {
                    conn.rollback();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[UserExpirationProcessor] Lỗi SQL khi tự động khóa sinh viên userId=" + eu.userId, e);
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ignored) {
                    }
                }
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException ignored) {
                    }
                }
            }
        }

        return result;
    }

    private static class ExpiredUser {
        int userId;
        String email;
        String role;
        java.sql.Date endDate;
    }

    public static class ProcessResult {
        public int lockedCount = 0;
    }
}
