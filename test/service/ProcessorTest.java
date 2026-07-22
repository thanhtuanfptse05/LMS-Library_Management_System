package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ProcessorTest {

    private OverdueProcessor overdueProcessor;

    @Before
    public void setUp() {
        overdueProcessor = new OverdueProcessor();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testProcessorInstantiation() {
        assertNotNull("OverdueProcessor được khởi tạo thành công", overdueProcessor);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testProcessOverdueOffline() {
        // Trong môi trường offline (không có DB connection), processOverdue bắt SQLException và trả về result 0
        OverdueProcessor.OverdueResult result = overdueProcessor.processOverdue();
        assertNotNull(result);
        assertEquals(0, result.processedRecords);
        assertEquals(0, result.lockedUsers);
        assertEquals(0, result.emailsSent);
    }
}
