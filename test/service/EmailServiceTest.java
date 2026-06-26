package service;

import model.EmailJob;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import java.util.HashMap;
import java.util.Map;

public class EmailServiceTest {

    @Test
    public void testEnqueueValidJob() {
        Map<String, String> placeholders = new HashMap<>();
        placeholders.put("bookTitle", "Kỹ nghệ phần mềm");
        
        EmailJob job = new EmailJob("RESERVATION_READY", "test-recipient@gmail.com", "Nguyễn Văn Test", placeholders);
        
        int initialSize = EmailService.getQueueSize();
        EmailService.enqueue(job);
        
        assertEquals(initialSize + 1, EmailService.getQueueSize());
        
        // Cleanup by taking the job (package-private take)
        try {
            EmailJob takenJob = EmailService.take();
            assertEquals("RESERVATION_READY", takenJob.getTempName());
            assertEquals("test-recipient@gmail.com", takenJob.getRecipientEmail());
        } catch (InterruptedException e) {
            // ignore
        }
    }

    @Test
    public void testEnqueueSkipsVirtualEmail() {
        Map<String, String> placeholders = new HashMap<>();
        EmailJob job = new EmailJob("RESET_PASSWORD", "virtual-user@lms.com", "User Ảo", placeholders);
        
        int initialSize = EmailService.getQueueSize();
        EmailService.enqueue(job);
        
        // Should ignore @lms.com virtual emails
        assertEquals(initialSize, EmailService.getQueueSize());
    }

    @Test
    public void testQueueOverflowDropBehavior() {
        Map<String, String> placeholders = new HashMap<>();
        
        // Enqueue up to capacity (500)
        int currentSize = EmailService.getQueueSize();
        int fillCount = 500 - currentSize;
        
        for (int i = 0; i < fillCount; i++) {
            EmailService.enqueue(new EmailJob("RESET_PASSWORD", "user" + i + "@gmail.com", "User", placeholders));
        }
        
        assertEquals(500, EmailService.getQueueSize());
        
        // Enqueue one more - should be dropped and not raise exception
        EmailService.enqueue(new EmailJob("RESET_PASSWORD", "overflow@gmail.com", "Overflow", placeholders));
        assertEquals(500, EmailService.getQueueSize());
        
        // Clean up some items
        for (int i = 0; i < 500; i++) {
            try {
                EmailService.take();
            } catch (InterruptedException e) {
                break;
            }
        }
    }
}
