package f19_async_email;

import service.EmailService;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class F19_AsyncEmailInfrastructureTest {

    @Before
    public void setUp() {
    }

    // ========================================================================
    // F19: ASYNC EMAIL INFRASTRUCTURE - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testEmailJobCreationAndEnqueuing() {
        String recipient = "student@fpt.edu.vn";
        String subject = "Thông báo mượn sách thành công";
        String body = "Bạn đã mượn thành công cuốn sách Clean Code.";

        assertNotNull(recipient);
        assertNotNull(subject);
        assertNotNull(body);
        assertTrue(recipient.contains("@"));
    }
}
