import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;

public class TestDBException {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.wukwrfwdrbstyoqissjz";
        String pass = "6wUw)Q6S/)LFeSE";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println("Connected to Supabase.");

            int paymentId = 5; // A hypothetical paymentId
            
            // Try getPaymentStatus
            String currentStatus = getPaymentStatus(conn, paymentId);
            System.out.println("getPaymentStatus: " + currentStatus);
            if (currentStatus == null) {
                System.out.println("Payment not found, trying with an existing one if possible...");
                paymentId = getFirstPendingPayment(conn);
                if (paymentId == -1) {
                    System.out.println("No pending payments found to test with. Inserting a mock payment...");
                    paymentId = insertMockPayment(conn);
                }
                System.out.println("Testing with paymentId: " + paymentId);
            }

            conn.setAutoCommit(false);
            try {
                int fineId = findFineIdByPaymentId(conn, paymentId);
                System.out.println("findFineIdByPaymentId: " + fineId);

                updatePaymentOnlineSuccess(conn, paymentId, "SIM123", "BankTransfer", new BigDecimal("10000"));
                System.out.println("updatePaymentOnlineSuccess: OK");

                updateStatusToPaid(conn, fineId);
                System.out.println("updateStatusToPaid: OK");

                insertAuditLog(conn, null, "SEPAY_WEBHOOK_PAYMENT", "Payment", paymentId, "{\"status\":\"pending\"}", "{\"status\":\"completed\"}");
                System.out.println("insertAuditLog: OK");

                conn.rollback();
                System.out.println("All operations succeeded (rolled back at the end).");
            } catch (Exception e) {
                conn.rollback();
                System.err.println("Exception inside transaction block:");
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.err.println("Connection error:");
            e.printStackTrace();
        }
    }

    private static String getPaymentStatus(Connection conn, int paymentId) throws SQLException {
        String sql = "SELECT status FROM Payment WHERE paymentId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("status");
            }
        }
        return null;
    }

    private static int getFirstPendingPayment(Connection conn) throws SQLException {
        String sql = "SELECT paymentId FROM Payment WHERE status = 'pending' LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    private static int insertMockPayment(Connection conn) throws SQLException {
        int userId = -1;
        try (PreparedStatement ps = conn.prepareStatement("SELECT userId FROM \"User\" LIMIT 1"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) userId = rs.getInt(1);
        }
        
        int bookId = -1;
        try (PreparedStatement ps = conn.prepareStatement("SELECT bookId FROM Book LIMIT 1"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) bookId = rs.getInt(1);
        }

        int bookCopyId = -1;
        try (PreparedStatement ps = conn.prepareStatement("SELECT bookCopyId FROM BookCopy LIMIT 1"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) bookCopyId = rs.getInt(1);
        }

        try (PreparedStatement ps = conn.prepareStatement("INSERT INTO BorrowRecord (userId, bookCopyId, bookId, endDate) VALUES (?, ?, ?, NOW()) RETURNING borrowRecordId")) {
            ps.setInt(1, userId);
            ps.setInt(2, bookCopyId);
            ps.setInt(3, bookId);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); int brId = rs.getInt(1); 
                try (PreparedStatement ps2 = conn.prepareStatement("INSERT INTO Fine (borrowRecordId, userId, amount) VALUES (?, ?, 10000) RETURNING fineId")) {
                    ps2.setInt(1, brId);
                    ps2.setInt(2, userId);
                    try (ResultSet rs2 = ps2.executeQuery()) { rs2.next(); int fineId = rs2.getInt(1);
                        try (PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Payment (fineId, paidAmount, status) VALUES (?, 10000, 'pending') RETURNING paymentId")) {
                            ps3.setInt(1, fineId);
                            try (ResultSet rs3 = ps3.executeQuery()) { rs3.next(); return rs3.getInt(1); }
                        }
                    }
                }
            }
        }
    }

    private static int findFineIdByPaymentId(Connection conn, int paymentId) throws SQLException {
        String sql = "SELECT fineId FROM Payment WHERE paymentId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("fineId");
            }
        }
        return -1;
    }

    private static void updatePaymentOnlineSuccess(Connection conn, int paymentId, String transactionRef, String method, BigDecimal paidAmount) throws SQLException {
        String sql = "UPDATE Payment SET status = 'completed', transactionReference = ?, paymentMethod = ?, paidAmount = ?, paidAt = NOW() WHERE paymentId = ? AND status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, transactionRef);
            ps.setString(2, method);
            ps.setBigDecimal(3, paidAmount);
            ps.setInt(4, paymentId);
            ps.executeUpdate();
        }
    }

    private static void updateStatusToPaid(Connection conn, int fineId) throws SQLException {
        String sql = "UPDATE Fine SET status = 'paid' WHERE fineId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            ps.executeUpdate();
        }
    }

    private static void insertAuditLog(Connection conn, Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) throws SQLException {
        String sql = "INSERT INTO AuditLogs (userId, actionType, entityName, entityId, oldValues, newValues, timestamp) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId == null) ps.setNull(1, java.sql.Types.INTEGER);
            else ps.setInt(1, userId);
            ps.setString(2, actionType);
            ps.setString(3, entityName);
            if (entityId == null) ps.setNull(4, java.sql.Types.INTEGER);
            else ps.setInt(4, entityId);
            ps.setString(5, oldValues);
            ps.setString(6, newValues);
            ps.executeUpdate();
        }
    }
}
