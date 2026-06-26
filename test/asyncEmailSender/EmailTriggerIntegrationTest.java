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
import java.util.Map;

@RunWith(Parameterized.class)
public class EmailTriggerIntegrationTest {

    private final String tempName;
    private final String email;
    private final int index;

    public EmailTriggerIntegrationTest(String tempName, String email, int index) {
        this.tempName = tempName;
        this.email = email;
        this.index = index;
    }

    @Parameterized.Parameters(name = "EmailTrigger-TestCase-{2}")
    public static Collection<Object[]> data() {
        Object[][] data = new Object[50][3];
        String[] templates = {"CHECKOUT_CONFIRMATION", "PAYMENT_CONFIRMATION", "RESERVATION_READY", "OVERDUE_NOTICE", "RENEWAL_CONFIRMATION"};
        for (int i = 0; i < 50; i++) {
            data[i][0] = templates[i % templates.length];
            data[i][1] = "trigger" + i + "@gmail.com";
            data[i][2] = i;
        }
        return Arrays.asList(data);
    }

    @Test
    public void testEmailTriggerPushToQueue() throws InterruptedException {
        int initialSize = EmailService.getQueueSize();
        
        Map<String, String> placeholders = new HashMap<>();
        placeholders.put("triggerIndex", String.valueOf(index));
        
        EmailJob job = new EmailJob(tempName, email, "Trigger User " + index, placeholders);
        EmailService.enqueue(job);
        
        assertEquals(initialSize + 1, EmailService.getQueueSize());
        
        EmailJob taken = EmailService.take();
        assertNotNull(taken);
        assertEquals(tempName, taken.getTempName());
        assertEquals(email, taken.getRecipientEmail());
        assertEquals(String.valueOf(index), taken.getPlaceholders().get("triggerIndex"));
    }
}
