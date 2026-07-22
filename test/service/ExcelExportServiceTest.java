package service;

import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class ExcelExportServiceTest {

    private ExcelExportService exportService;

    @Before
    public void setUp() {
        exportService = new ExcelExportService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testExportSystemReportEmptyData() throws Exception {
        Map<String, Object> data = new HashMap<>();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        exportService.exportSystemReportToExcel(data, out);
        byte[] bytes = out.toByteArray();

        assertNotNull(bytes);
        assertTrue("File Excel sinh ra phải lớn hơn 0 bytes", bytes.length > 0);
    }
}
