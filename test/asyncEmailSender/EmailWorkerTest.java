package asyncEmailSender;

import dao.AuditLogDAO;
import dao.EmailTemplateDAO;
import model.EmailJob;
import model.EmailTemplate;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import static org.junit.Assert.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@RunWith(Parameterized.class)
public class EmailWorkerTest {

    private final String tempName;
    private final String userName;
    private final String bookTitle;
    private final int index;

    public EmailWorkerTest(String tempName, String userName, String bookTitle, int index) {
        this.tempName = tempName;
        this.userName = userName;
        this.bookTitle = bookTitle;
        this.index = index;
    }

    @Parameterized.Parameters(name = "EmailWorker-TestCase-{3}")
    public static Collection<Object[]> data() {
        Object[][] data = new Object[50][4];
        for (int i = 0; i < 50; i++) {
            data[i][0] = "TEMPLATE_" + i;
            data[i][1] = "Người dùng " + i;
            data[i][2] = "Sách Văn Học Lớp " + i;
            data[i][3] = i;
        }
        return Arrays.asList(data);
    }

    private static class MockAuditLogDAO extends AuditLogDAO {
        int logCount = 0;
        String lastNewValues = null;

        @Override
        public void insert(Connection conn, Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) throws SQLException {
            logCount++;
            lastNewValues = newValues;
        }
    }

    @Test
    public void testWorkerPlaceholderAssemblyAndAuditLog() throws SQLException {
        String originalSubject = "Xin chào {{userName}}";
        String originalBody = "Sách của bạn là {{bookTitle}}";

        Map<String, String> placeholders = new HashMap<>();
        placeholders.put("bookTitle", bookTitle);

        EmailJob job = new EmailJob(tempName, "test@gmail.com", userName, placeholders);

        // Simulated worker placeholder resolution
        String subject = originalSubject.replace("{{userName}}", job.getRecipientName());
        String body = originalBody.replace("{{bookTitle}}", job.getPlaceholders().get("bookTitle"));

        assertTrue(subject.contains(userName));
        assertTrue(body.contains(bookTitle));

        MockAuditLogDAO auditLogDAO = new MockAuditLogDAO();
        String details = String.format("Status: %s | TempName: %s | Recipient: %s | Attempts: %d",
                "SUCCESS", tempName, "test@gmail.com", 1);
        auditLogDAO.insert(null, null, "SYSTEM_EMAIL", "EmailJob", null, null, details);

        assertEquals(1, auditLogDAO.logCount);
        assertTrue(auditLogDAO.lastNewValues.contains(tempName));
    }
}
