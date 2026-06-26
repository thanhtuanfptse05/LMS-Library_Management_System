package asyncEmailSender;

import model.EmailJob;
import service.EmailService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import static org.junit.Assert.*;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;

@RunWith(Parameterized.class)
public class EmailServiceTest {

    private final String email;
    private final String tempName;
    private final int index;

    public EmailServiceTest(String email, String tempName, int index) {
        this.email = email;
        this.tempName = tempName;
        this.index = index;
    }

    @Parameterized.Parameters(name = "EmailService-TestCase-{2}")
    public static Collection<Object[]> data() {
        Object[][] data = new Object[50][3];
        for (int i = 0; i < 50; i++) {
            // Mix valid and invalid virtual emails
            if (i % 5 == 0) {
                data[i][0] = "user" + i + "@lms.com"; // will be skipped
            } else {
                data[i][0] = "user" + i + "@gmail.com"; // will be enqueued
            }
            data[i][1] = "RESET_PASSWORD";
            data[i][2] = i;
        }
        return Arrays.asList(data);
    }

    @Test
    public void testEnqueueAndQueueState() throws InterruptedException {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob(tempName, email, "User " + index, new HashMap<>());
        EmailService.enqueue(job);

        if (email.endsWith("@lms.com")) {
            assertEquals("Virtual email should not increase queue size", initialSize, EmailService.getQueueSize());
        } else {
            assertEquals("Valid email should increase queue size by 1", initialSize + 1, EmailService.getQueueSize());
            // Consume it to keep queue size low and avoid overflows
            EmailJob taken = EmailService.take();
            assertNotNull(taken);
            assertEquals(email, taken.getRecipientEmail());
        }
    }
}
