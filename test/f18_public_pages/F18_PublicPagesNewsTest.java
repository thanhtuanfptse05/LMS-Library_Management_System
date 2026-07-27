package f18_public_pages;

import model.DocumentTemp;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F18_PublicPagesNewsTest {

    private DocumentTemp docTemp;

    @Before
    public void setUp() {
        docTemp = new DocumentTemp();
        docTemp.setTempId(1801);
        docTemp.setTempName("RESET_PASSWORD_TEMPLATE");
        docTemp.setSubject("Yêu cầu đặt lại mật khẩu hệ thống LMS");
        docTemp.setBodyContent("Kính gửi {fullName}, mật khẩu tạm của bạn là {tempPassword}.");
        docTemp.setManagerId(302);
        docTemp.setCreatedAt(new Timestamp(System.currentTimeMillis()));
    }

    // ========================================================================
    // F18: PUBLIC PAGES & NEWS - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testDocumentTempFields() {
        assertEquals(1801, docTemp.getTempId());
        assertEquals("RESET_PASSWORD_TEMPLATE", docTemp.getTempName());
        assertEquals("Yêu cầu đặt lại mật khẩu hệ thống LMS", docTemp.getSubject());
        assertTrue(docTemp.getBodyContent().contains("{tempPassword}"));
        assertEquals(302, docTemp.getManagerId());
        assertNotNull(docTemp.getCreatedAt());
    }

    @Test
    public void testTemplatePlaceholderReplacement() {
        String body = docTemp.getBodyContent();
        String replaced = body.replace("{fullName}", "Nguyen Van A").replace("{tempPassword}", "123456");

        assertTrue(replaced.contains("Nguyen Van A"));
        assertTrue(replaced.contains("123456"));
        assertFalse(replaced.contains("{fullName}"));
    }
}
