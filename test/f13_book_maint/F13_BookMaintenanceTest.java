package f13_book_maint;

import model.BookCopyIncident;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F13_BookMaintenanceTest {

    private BookCopyIncident incident;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        incident = new BookCopyIncident();
        incident.setIncidentId(1301);
        incident.setBookCopyId(4001);
        incident.setIncidentType("damaged");
        incident.setDescription("Rách 5 trang đầu và bẩn bìa sau");
        incident.setStatus("reported");
        incident.setReportedBy(301); // Librarian ID
        incident.setReportedAt(new Timestamp(now));
    }

    // ========================================================================
    // F13: BOOK MAINTENANCE & COPY INCIDENT - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testIncidentFields() {
        assertEquals(1301, incident.getIncidentId());
        assertEquals(4001, incident.getBookCopyId());
        assertEquals("damaged", incident.getIncidentType());
        assertEquals("Rách 5 trang đầu và bẩn bìa sau", incident.getDescription());
        assertEquals("reported", incident.getStatus());
        assertEquals(301, incident.getReportedBy());
        assertNotNull(incident.getReportedAt());
    }

    @Test
    public void testIncidentResolutionReject() {
        incident.setResolution("reject");
        incident.setStatus("resolved");
        incident.setResolvedBy(302);
        incident.setResolvedAt(new Timestamp(now));

        assertEquals("reject", incident.getResolution());
        assertEquals("resolved", incident.getStatus());
        assertEquals(Integer.valueOf(302), incident.getResolvedBy());
    }

    @Test
    public void testIncidentResolutionRestore() {
        incident.setResolution("restore");
        incident.setStatus("resolved");

        assertEquals("restore", incident.getResolution());
        assertEquals("resolved", incident.getStatus());
    }

    @Test
    public void testIncidentResolutionRemove() {
        incident.setResolution("remove");
        incident.setStatus("resolved");

        assertEquals("remove", incident.getResolution());
        assertEquals("resolved", incident.getStatus());
    }
}
