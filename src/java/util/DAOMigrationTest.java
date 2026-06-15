package util;

import dao.*;
import model.*;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class DAOMigrationTest {
    private static final Logger LOGGER = Logger.getLogger(DAOMigrationTest.class.getName());
    private static final String SNAPSHOT_FILE = "snapshot_after.json";

    public static void main(String[] args) {
        System.out.println("=== BAT DAU SNAPSHOT TEST ===");
        Map<String, Object> results = new LinkedHashMap<>();

        // Test Connection
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("connection", "SUCCESS: Connected to database.");
            System.out.println("Ket noi database thanh cong.");
        } catch (Exception e) {
            results.put("connection", "FAILED: " + e.getMessage());
            System.out.println("Ket noi database that bai: " + e.getMessage());
            e.printStackTrace(); // In ra stack trace chi tiet de debug
        }

        // Run DAO Tests
        runTests(results);

        // Write to file
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        try (FileWriter writer = new FileWriter(SNAPSHOT_FILE)) {
            gson.toJson(results, writer);
            System.out.println("Da ghi ket qua snapshot vao file: " + SNAPSHOT_FILE);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Khong the ghi file snapshot", e);
        }
        System.out.println("=== KET THUC SNAPSHOT TEST ===");
    }

    private static void runTests(Map<String, Object> results) {
        // Nhóm C
        // 1. AdminDAO
        try {
            results.put("AdminDAO.findByUserId", new AdminDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("AdminDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // 2. LibraryManagerDAO
        try {
            results.put("LibraryManagerDAO.findByUserId", new LibraryManagerDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("LibraryManagerDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // 3. LibrarianDAO
        try {
            results.put("LibrarianDAO.findByUserId", new LibrarianDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("LibrarianDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // 4. LecturerDAO
        try {
            results.put("LecturerDAO.findByUserId", new LecturerDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("LecturerDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // 5. StudentDAO
        try {
            results.put("StudentDAO.findByUserId", new StudentDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("StudentDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // Nhóm B
        // 6. AuditLogDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                new AuditLogDAO().insert(conn, null, "TEST_MIGRATION", "TestEntity", 1, "old", "new");
                results.put("AuditLogDAO.insert", "SUCCESS");
            } finally {
                conn.rollback();
            }
        } catch (Exception e) {
            results.put("AuditLogDAO.insert", "ERROR: " + e.getMessage());
        }

        // 7. UserLockReasonDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("UserLockReasonDAO.countLockReasonsByUserId", new UserLockReasonDAO().countLockReasonsByUserId(conn, 1));
        } catch (Exception e) {
            results.put("UserLockReasonDAO.countLockReasonsByUserId", "ERROR: " + e.getMessage());
        }

        // 8. MemberProfileDAO
        try {
            results.put("MemberProfileDAO.findByUserId", new MemberProfileDAO().findByUserId(1) != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("MemberProfileDAO.findByUserId", "ERROR: " + e.getMessage());
        }

        // 9. UserLookupDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("UserLookupDAO.findUserIdByMemberCode", new UserLookupDAO().findUserIdByMemberCode(conn, "TEST_CODE") != null ? "EXISTS_OR_NULL" : "NULL");
        } catch (Exception e) {
            results.put("UserLookupDAO.findUserIdByMemberCode", "ERROR: " + e.getMessage());
        }

        // 10. BorrowRecordDAO
        try {
            results.put("BorrowRecordDAO.countUserBorrowHistory", new BorrowRecordDAO().countUserBorrowHistory(1));
        } catch (Exception e) {
            results.put("BorrowRecordDAO.countUserBorrowHistory", "ERROR: " + e.getMessage());
        }

        // 11. DocumentTempDAO
        try {
            results.put("DocumentTempDAO.getAll", new DocumentTempDAO().getAll().size() + " records");
        } catch (Exception e) {
            results.put("DocumentTempDAO.getAll", "ERROR: " + e.getMessage());
        }

        // 12. CategoryDAO
        try {
            results.put("CategoryDAO.findAll", new CategoryDAO().findAll().size() + " records");
        } catch (Exception e) {
            results.put("CategoryDAO.findAll", "ERROR: " + e.getMessage());
        }

        // 13. TagDAO
        try {
            results.put("TagDAO.findAll", new TagDAO().findAll().size() + " records");
        } catch (Exception e) {
            results.put("TagDAO.findAll", "ERROR: " + e.getMessage());
        }

        // 14. FineDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("FineDAO.findUnpaidFinesByUserId", new FineDAO().findUnpaidFinesByUserId(conn, 1).size() + " records");
        } catch (Exception e) {
            results.put("FineDAO.findUnpaidFinesByUserId", "ERROR: " + e.getMessage());
        }

        // 15. PaymentDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("PaymentDAO.findFineIdByPaymentId", new PaymentDAO().findFineIdByPaymentId(conn, 1));
        } catch (Exception e) {
            results.put("PaymentDAO.findFineIdByPaymentId", "ERROR: " + e.getMessage());
        }

        // Nhóm A
        // 16. BookDAO
        try {
            results.put("BookDAO.findAllForSelection", new BookDAO().findAllForSelection().size() + " records");
        } catch (Exception e) {
            results.put("BookDAO.findAllForSelection", "ERROR: " + e.getMessage());
        }

        // 17. BookCopyDAO
        try {
            results.put("BookCopyDAO.findLocations", new BookCopyDAO().findLocations().size() + " locations");
        } catch (Exception e) {
            results.put("BookCopyDAO.findLocations", "ERROR: " + e.getMessage());
        }

        // 18. BookImportDAO
        try {
            results.put("BookImportDAO.search", new BookImportDAO().search("", "", 0, 5).size() + " records");
        } catch (Exception e) {
            results.put("BookImportDAO.search", "ERROR: " + e.getMessage());
        }

        // 19. NotificationDAO
        try {
            results.put("NotificationDAO.count", new NotificationDAO().count());
        } catch (Exception e) {
            results.put("NotificationDAO.count", "ERROR: " + e.getMessage());
        }

        // 20. UserDAO
        try {
            results.put("UserDAO.countAllUsers", new UserDAO().countAllUsers("", "ALL", "ALL"));
        } catch (Exception e) {
            results.put("UserDAO.countAllUsers", "ERROR: " + e.getMessage());
        }

        // 21. ReservationDAO
        try (Connection conn = DatabaseConnection.getConnection()) {
            results.put("ReservationDAO.findReadyPickupByUserId", new ReservationDAO().findReadyPickupByUserId(conn, 1).size() + " records");
        } catch (Exception e) {
            results.put("ReservationDAO.findReadyPickupByUserId", "ERROR: " + e.getMessage());
        }

        // 22. InventoryDAO
        try {
            results.put("InventoryDAO.findSessions", new InventoryDAO().findSessions().size() + " sessions");
        } catch (Exception e) {
            results.put("InventoryDAO.findSessions", "ERROR: " + e.getMessage());
        }

        // 23. BookCopyIncidentDAO
        try {
            results.put("BookCopyIncidentDAO.search", new BookCopyIncidentDAO().search("", "", "", 0, 5).size() + " records");
        } catch (Exception e) {
            results.put("BookCopyIncidentDAO.search", "ERROR: " + e.getMessage());
        }
    }
}
