package dao;

import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class PaymentDAOTest {

    private PaymentDAO paymentDAO;

    @Before
    public void setUp() {
        paymentDAO = new PaymentDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindFineIdByPaymentIdWithMockConn() throws Exception {
        Map<String, Object> paymentData = new HashMap<>();
        paymentData.put("fineId", 5);

        Connection mockConn = MockJdbc.createMockConnection(paymentData, 0);
        int fineId = paymentDAO.findFineIdByPaymentId(mockConn, 10);
        assertEquals(5, fineId);
    }

    @Test
    public void testUpdateStatusToCompletedWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        paymentDAO.updateStatusToCompleted(mockConn, 10, 1);
    }
}
