package dao;

import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.sql.Connection;
import static org.junit.Assert.*;

public class FineDAOTest {

    private FineDAO fineDAO;

    @Before
    public void setUp() {
        fineDAO = new FineDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testInsertCompensationFineWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        fineDAO.insertCompensationFine(mockConn, 101, 1, new BigDecimal("150000.00"), "Phạt hỏng sách");
        assertNotNull(fineDAO);
    }

    @Test
    public void testUpdateStatusToPaidWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        fineDAO.updateStatusToPaid(mockConn, 5);
    }
}
