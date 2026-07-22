package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ReservationExpirationProcessorTest {

    private ReservationExpirationProcessor processor;

    @Before
    public void setUp() {
        processor = new ReservationExpirationProcessor();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testProcessorInstantiation() {
        assertNotNull("Processor instance phải được khởi tạo thành công", processor);
    }

    @Test
    public void testProcessExpirationExecution() {
        // Thực thi tiến trình quét quá hạn giữ chỗ (kết quả trả về ProcessResult không null)
        ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();
        assertNotNull(result);
        assertTrue(result.cancelledCount >= 0);
        assertTrue(result.promotedCount >= 0);
    }
}
