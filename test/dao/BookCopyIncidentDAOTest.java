package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.BookCopy;
import model.BookCopyIncident;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import util.DatabaseConnection;

public class BookCopyIncidentDAOTest {

    @Test
    public void reportThenResolveSynchronizesCopyAndAvailableQuantity() throws Exception {
        BookCopyDAO copyDAO = new BookCopyDAO();
        BookCopyIncidentDAO incidentDAO = new BookCopyIncidentDAO();
        BookDAO bookDAO = new BookDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCopy copy = createCopy(conn, copyDAO);
                int availableBefore = findAvailableQuantity(conn, copy.getBookId());
                bookDAO.updateQuantities(conn, copy.getBookId(), 1, 1);
                int incidentId = incidentDAO.insert(conn, incident(copy.getBookCopyId()));
                copyDAO.markUnavailable(conn, copy.getBookCopyId());
                bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);

                BookCopy pendingCopy = copyDAO.findById(conn, copy.getBookCopyId());
                assertEquals("good", pendingCopy.getCondition());
                assertEquals("unavailable", pendingCopy.getStatus());
                assertEquals(availableBefore, findAvailableQuantity(conn, copy.getBookId()));

                copyDAO.resolveCondition(conn, copy.getBookCopyId(), "damaged");
                incidentDAO.finish(conn, incidentId, "resolved", "Xác nhận hỏng sau kiểm tra.", findUserId());

                BookCopy resolvedCopy = copyDAO.findById(conn, copy.getBookCopyId());
                assertEquals("damaged", resolvedCopy.getCondition());
                assertEquals("unavailable", resolvedCopy.getStatus());
                assertEquals("resolved", incidentDAO.findById(conn, incidentId).getStatus());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void insertPreventsTwoOpenIncidentsForSameCopy() throws Exception {
        BookCopyDAO copyDAO = new BookCopyDAO();
        BookCopyIncidentDAO incidentDAO = new BookCopyIncidentDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookCopy copy = createCopy(conn, copyDAO);
                BookCopyIncident first = incident(copy.getBookCopyId());
                int incidentId = incidentDAO.insert(conn, first);
                BookCopyIncident saved = incidentDAO.findById(conn, incidentId);
                assertNotNull(saved);
                assertEquals("pending", saved.getStatus());
                try {
                    incidentDAO.insert(conn, incident(copy.getBookCopyId()));
                    fail("Expected unique open incident constraint");
                } catch (SQLException expected) {
                    assertTrue(expected.getMessage() != null);
                }
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    private BookCopy createCopy(Connection conn, BookCopyDAO copyDAO) throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookId(findBookId(conn));
        copy.setBarcode("BC-INCIDENT-TEST-" + System.nanoTime());
        copy.setLocation("Kho kiểm thử · Kệ sự cố");
        copy.setBookCopyId(copyDAO.insert(conn, copy));
        return copy;
    }

    private BookCopyIncident incident(int bookCopyId) throws Exception {
        BookCopyIncident incident = new BookCopyIncident();
        incident.setBookCopyId(bookCopyId);
        incident.setIncidentType("damaged");
        incident.setDescription("Kiểm thử ràng buộc sự cố đang mở.");
        incident.setReportedBy(findUserId());
        return incident;
    }

    private int findBookId(Connection conn) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("SELECT bookId FROM Book ORDER BY bookId LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            return rs.getInt(1);
        }
    }

    private int findAvailableQuantity(Connection conn, int bookId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT availableQuantity FROM Book WHERE bookId = ?")) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                return rs.getInt(1);
            }
        }
    }

    private int findUserId() throws Exception {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT userId FROM \"User\" ORDER BY userId LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            return rs.getInt(1);
        }
    }
}
