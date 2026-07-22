package service;

import model.EmailJob;
import org.junit.Test;
import static org.junit.Assert.*;

public class EmailServiceTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testEnqueueValidGmail() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("testuser@gmail.com", "Mã OTP Xóa Mật Khẩu", "Nội dung OTP: 123456");
        EmailService.enqueue(job);
        assertEquals(initialSize + 1, EmailService.getQueueSize());
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testEnqueueUppercaseGmail() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("TESTUSER@GMAIL.COM", "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals(initialSize + 1, EmailService.getQueueSize());
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test
    public void testEnqueueNullJob() {
        int initialSize = EmailService.getQueueSize();
        EmailService.enqueue(null);
        assertEquals("Enqueue job null không thay đổi kích thước queue", initialSize, EmailService.getQueueSize());
    }

    @Test
    public void testEnqueueNonGmailIgnored() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob("testuser@yahoo.com", "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals("Bỏ qua email không phải @gmail.com", initialSize, EmailService.getQueueSize());
    }

    @Test
    public void testEnqueueNullRecipientEmailIgnored() {
        int initialSize = EmailService.getQueueSize();
        EmailJob job = new EmailJob(null, "Tiêu đề", "Nội dung");
        EmailService.enqueue(job);
        assertEquals("Bỏ qua job có email null", initialSize, EmailService.getQueueSize());
    }
}
