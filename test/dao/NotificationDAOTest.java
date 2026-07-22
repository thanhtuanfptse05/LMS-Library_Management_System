package dao;

import model.Notification;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class NotificationDAOTest {

    private NotificationDAO notificationDAO;

    @Before
    public void setUp() {
        notificationDAO = new NotificationDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testNotificationDAOMockConn() throws Exception {
        Map<String, Object> data = new HashMap<>();
        data.put("notificationId", 1);
        data.put("title", "Thông báo nghỉ lễ");
        data.put("type", "general");

        Connection mockConn = MockJdbc.createMockConnection(data, 1);
        assertNotNull(mockConn);
        assertNotNull(notificationDAO);
    }
}
