package f06_desk_circ;

import dto.BorrowingManagementDTO;
import model.EmailJob;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class LibrarianBorrowingsManagementTest {

    private BorrowingManagementDTO dto;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        dto = new BorrowingManagementDTO();
        dto.setBorrowRecordId(101);
        dto.setUserId(201);
        dto.setUserFullName("Nguyen Van A");
        dto.setUserCode("SE170001");
        dto.setUserEmail("nguyenvana@gmail.com");
        dto.setUserRole("student");
        dto.setBookId(301);
        dto.setBookTitle("Lap trinh Java Servlet Web");
        dto.setIsbn("978-3-16-148410-0");
        dto.setBookCopyId(401);
        dto.setBarcode("BC10001");
        dto.setStartDate(new Timestamp(now));
        dto.setEndDate(new Timestamp(now + 14L * 86400000L));
        dto.setStatus("borrowed");
    }

    @Test
    public void testBorrowingManagementDTOGettersAndSetters() {
        assertEquals(101, dto.getBorrowRecordId());
        assertEquals(201, dto.getUserId());
        assertEquals("Nguyen Van A", dto.getUserFullName());
        assertEquals("SE170001", dto.getUserCode());
        assertEquals("nguyenvana@gmail.com", dto.getUserEmail());
        assertEquals("student", dto.getUserRole());
        assertEquals(301, dto.getBookId());
        assertEquals("Lap trinh Java Servlet Web", dto.getBookTitle());
        assertEquals("978-3-16-148410-0", dto.getIsbn());
        assertEquals(401, dto.getBookCopyId());
        assertEquals("BC10001", dto.getBarcode());
        assertEquals("borrowed", dto.getStatus());
        assertNull(dto.getReturnedAt());
    }

    @Test
    public void testRecallNoticeEmailJobCreation() {
        Map<String, String> placeholders = new HashMap<>();
        placeholders.put("userName", dto.getUserFullName());
        placeholders.put("bookTitle", dto.getBookTitle());
        placeholders.put("barcode", dto.getBarcode());
        placeholders.put("recallReason", "Yeu cau phuc vu nguyen cuu khoa hoc");

        EmailJob job = new EmailJob("RECALL_NOTICE", dto.getUserEmail(), dto.getUserFullName(), placeholders);

        assertEquals("RECALL_NOTICE", job.getTempName());
        assertEquals("nguyenvana@gmail.com", job.getRecipientEmail());
        assertEquals("Nguyen Van A", job.getRecipientName());
        assertNotNull(job.getPlaceholders());
        assertEquals("BC10001", job.getPlaceholders().get("barcode"));
        assertEquals("Yeu cau phuc vu nguyen cuu khoa hoc", job.getPlaceholders().get("recallReason"));
    }

    @Test
    public void testStatusValidationForRecall() {
        // Chi cho phep truyen status 'borrowed' hoac 'overdue' khi thu hoi
        assertTrue("borrowed".equalsIgnoreCase(dto.getStatus()) || "overdue".equalsIgnoreCase(dto.getStatus()));

        dto.setStatus("returned");
        assertFalse("borrowed".equalsIgnoreCase(dto.getStatus()) || "overdue".equalsIgnoreCase(dto.getStatus()));
    }
}
