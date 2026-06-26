package asyncEmailSender;

import model.EmailJob;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import static org.junit.Assert.*;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;

@RunWith(Parameterized.class)
public class EmailJobTest {

    private final String email;
    private final String subject;
    private final String body;
    private final int index;

    public EmailJobTest(String email, String subject, String body, int index) {
        this.email = email;
        this.subject = subject;
        this.body = body;
        this.index = index;
    }

    @Parameterized.Parameters(name = "EmailJob-TestCase-{3}")
    public static Collection<Object[]> data() {
        Object[][] data = new Object[50][4];
        for (int i = 0; i < 50; i++) {
            data[i][0] = "recipient" + i + "@example.com";
            data[i][1] = "Subject " + i;
            data[i][2] = "Nội dung html " + i;
            data[i][3] = i;
        }
        return Arrays.asList(data);
    }

    @Test
    public void testEmailJobProperties() {
        EmailJob job = new EmailJob(email, subject, body);
        assertEquals(email, job.getRecipientEmail());
        assertEquals(subject, job.getDirectSubject());
        assertEquals(body, job.getDirectBody());
        assertNull(job.getTempName());
        assertEquals(0, job.getAttemptCount());

        job.incrementAttempt();
        assertEquals(1, job.getAttemptCount());
    }

    @Test
    public void testEmailJobTemplateConstructor() {
        String tempName = "TEMP_" + index;
        String recipientName = "User " + index;
        EmailJob job = new EmailJob(tempName, email, recipientName, new HashMap<>());

        assertEquals(tempName, job.getTempName());
        assertEquals(email, job.getRecipientEmail());
        assertEquals(recipientName, job.getRecipientName());
        assertNotNull(job.getPlaceholders());
        assertNull(job.getDirectSubject());
        assertNull(job.getDirectBody());
    }
}
