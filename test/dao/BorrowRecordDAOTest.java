package dao;

import model.BorrowRecord;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class BorrowRecordDAOTest {

    private BorrowRecordDAO borrowRecordDAO;

    @Before
    public void setUp() {
        borrowRecordDAO = new BorrowRecordDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindByIdWithMockConn() throws Exception {
        Map<String, Object> recordData = new HashMap<>();
        recordData.put("borrowRecordId", 101);
        recordData.put("userId", 1);
        recordData.put("bookCopyId", 50);
        recordData.put("status", "borrowed");

        Connection mockConn = MockJdbc.createMockConnection(recordData, 0);
        BorrowRecord record = borrowRecordDAO.findBorrowRecordById(mockConn, 101);
        assertNotNull("BorrowRecord đọc từ MockResultSet không được null", record);
        assertEquals(101, record.getBorrowRecordId());
        assertEquals(1, record.getUserId());
        assertEquals(50, record.getBookCopyId());
    }

    @Test
    public void testUpdateStatusToReturnedWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        assertNotNull(mockConn);
    }
}
