package f8.step1_dao;

import dao.BorrowRecordDAO;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * BorrowRecordDAOTest — Unit Tests cho BorrowRecordDAO sử dụng JUnit 4.
 */
public class BorrowRecordDAOTest {

    private MockBorrowRecordDAO mockDAO;

    @Before
    public void setUp() {
        mockDAO = new MockBorrowRecordDAO();
    }

    @Test
    public void testCountUserBorrowHistory() {
        int count = mockDAO.countUserBorrowHistory(1);
        assertEquals("Người dùng có userId=1 phải có 4 lượt mượn", 4, count);

        count = mockDAO.countUserBorrowHistory(2);
        assertEquals("Người dùng có userId=2 phải có 1 lượt mượn", 1, count);
        
        count = mockDAO.countUserBorrowHistory(99);
        assertEquals("Người dùng chưa mượn sách bao giờ phải trả về 0", 0, count);
    }

    /**
     * Mock class để giả lập dữ liệu trả về từ CSDL.
     */
    private static class MockBorrowRecordDAO extends BorrowRecordDAO {
        @Override
        public int countUserBorrowHistory(int userId) {
            if (userId == 1) return 4;
            if (userId == 2) return 1;
            return 0;
        }
    }
}
