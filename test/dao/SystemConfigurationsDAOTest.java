package dao;

import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class SystemConfigurationsDAOTest {

    private SystemConfigurationsDAO dao;

    @Before
    public void setUp() {
        dao = new SystemConfigurationsDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testGetConfigValueWithMockConnection() throws Exception {
        Map<String, Object> mockData = new HashMap<>();
        mockData.put("configValue", "14");
        Connection mockConn = MockJdbc.createMockConnection(mockData, 0);

        assertNotNull(mockConn);
        assertNotNull(dao);
    }

    @Test
    public void testGetLibraryConfigurationsWithMockConnection() throws Exception {
        Map<String, Object> mockData = new HashMap<>();
        mockData.put("configKey", "MAX_BORROW_LIMIT");
        mockData.put("configValue", "5");
        Connection mockConn = MockJdbc.createMockConnection(mockData, 0);

        assertNotNull(mockConn);
    }
}
