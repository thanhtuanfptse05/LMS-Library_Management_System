package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.BookCopy;
import model.InventorySession;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import util.DatabaseConnection;

public class InventoryDAOTest {

    @Test
    public void createScanAndFinishCountingTracksResults() throws Exception {
        InventoryDAO inventoryDAO = new InventoryDAO();
        BookCopyDAO copyDAO = new BookCopyDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String location = "Kho kiểm kê " + System.nanoTime();
                BookCopy first = createCopy(conn, copyDAO, location);
                createCopy(conn, copyDAO, location);
                int actorId = findUserId(conn);
                int sessionId = inventoryDAO.insertSession(conn, location, "Kiểm thử", actorId);
                assertEquals(2, inventoryDAO.createExpectedItems(conn, sessionId, location));
                inventoryDAO.updateSessionStatus(conn, sessionId, "draft", "counting", actorId);
                inventoryDAO.recordScan(conn, sessionId, first.getBookCopyId(), location,
                        "matched", actorId, location);
                assertEquals(1, inventoryDAO.markMissing(conn, sessionId));
                inventoryDAO.updateSessionStatus(conn, sessionId, "counting", "reviewing", actorId);

                InventorySession saved = inventoryDAO.findSession(conn, sessionId, false);
                assertNotNull(saved);
                assertEquals("reviewing", saved.getStatus());
                assertEquals(2, saved.getExpectedCount());
                assertEquals(1, saved.getMatchedCount());
                assertEquals(1, saved.getDiscrepancyCount());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    private BookCopy createCopy(Connection conn, BookCopyDAO dao, String location) throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookId(findBookId(conn));
        copy.setBarcode("BC-INVENTORY-" + System.nanoTime());
        copy.setLocation(location);
        copy.setBookCopyId(dao.insert(conn, copy));
        return copy;
    }

    private int findBookId(Connection conn) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("SELECT bookId FROM Book ORDER BY bookId LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            return rs.getInt(1);
        }
    }

    private int findUserId(Connection conn) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("SELECT userId FROM \"User\" ORDER BY userId LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            return rs.getInt(1);
        }
    }
}
