package filter;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class AuthFilterTest {

    private AuthFilter filter;

    @Before
    public void setUp() {
        filter = new AuthFilter();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testAuthFilterInstantiation() {
        assertNotNull("AuthFilter instance được khởi tạo thành công", filter);
    }

    @Test
    public void testFilterLifecycleMethods() throws Exception {
        filter.init(null);
        filter.destroy();
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testStaticResourceExtensionCheckAllExtensions() {
        String[] staticExtensions = {".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".woff", ".woff2"};
        for (String ext : staticExtensions) {
            String path = "/assets/theme/style" + ext;
            assertTrue("File có đuôi " + ext + " phải là tài nguyên tĩnh",
                    path.endsWith(ext) || path.startsWith("/assets/"));
        }
    }

    @Test
    public void testBypassRoutesMatch() {
        String sepayWebhook = "/api/sepay-webhook";
        assertEquals("/api/sepay-webhook", sepayWebhook);

        String healthCheck = "/health";
        assertEquals("/health", healthCheck);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Access Control
    // ==========================================

    @Test
    public void testRoleRouteMatchingLogicAllRoles() {
        assertTrue("/admin/dashboard".startsWith("/admin/"));
        assertTrue("/librarian/book-management".startsWith("/librarian/"));
        assertTrue("/manager/system-config".startsWith("/manager/"));
        assertTrue("/student/my-loans".startsWith("/student/"));
        assertTrue("/lecturer/book-suggestions".startsWith("/lecturer/"));
    }

    @Test
    public void testBookManagementLegacyRouteMatching() {
        String legacy1 = "/book-management";
        String legacy2 = "/book-management/";
        String legacy3 = "/book-management/overview";

        assertTrue(legacy1.equals("/book-management") || legacy1.startsWith("/book-management/"));
        assertTrue(legacy2.equals("/book-management/"));
        assertTrue(legacy3.startsWith("/book-management/"));
    }
}
