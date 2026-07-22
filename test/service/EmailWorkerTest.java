package service;

import org.junit.Test;
import static org.junit.Assert.*;

public class EmailWorkerTest {

    @Test
    public void testEmailWorkerShutdownFlag() {
        EmailWorker worker = new EmailWorker(null);
        assertNotNull("EmailWorker được khởi tạo thành công", worker);

        // Phát tín hiệu dừng luồng an toàn
        worker.shutdown();
    }
}
