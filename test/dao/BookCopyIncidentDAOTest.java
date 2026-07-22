package dao;

import java.sql.Connection;
import model.BookCopyIncident;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class BookCopyIncidentDAOTest {

    private BookCopyIncidentDAO incidentDAO;

    @Before
    public void setUp() {
        incidentDAO = new BookCopyIncidentDAO();
    }

    @Test
    public void testInsertResolvedFromCheckInReturnsGeneratedId() throws Exception {
        BookCopyIncident incident = new BookCopyIncident();
        incident.setBookCopyId(10);
        incident.setIncidentType("damaged");
        incident.setDescription("Phát hiện khi trả sách - Mã mượn: BR-99");
        incident.setReportedBy(7);

        Connection conn = MockJdbc.createMockConnection(null, 1);

        int incidentId = incidentDAO.insertResolvedFromCheckIn(conn, incident,
                "Thủ thư xác nhận sách hỏng khi nhận trả sách tại quầy.", 7);

        assertEquals(5, incidentId);
    }
}
