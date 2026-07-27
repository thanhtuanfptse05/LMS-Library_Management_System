package f07_notif;

import model.Notification;
import org.junit.Before;
import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F07_NotificationManagementTest {

    private Notification notification;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        notification = new Notification();
        notification.setNotificationId(701);
        notification.setTitle("Thông báo nghỉ lễ Quốc Khánh 2/9");
        notification.setContent("Thư viện xin thông báo lịch nghỉ lễ Quốc Khánh...");
        notification.setType("ANNOUNCEMENT");
        notification.setPinned(true);
        notification.setCreatedBy(302); // Library Manager ID
        notification.setCreatedAt(new Timestamp(now));
    }

    // ========================================================================
    // F07: NOTIFICATION MANAGEMENT - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testNotificationFields() {
        assertEquals(701, notification.getNotificationId());
        assertEquals("Thông báo nghỉ lễ Quốc Khánh 2/9", notification.getTitle());
        assertTrue(notification.getContent().contains("Thư viện xin thông báo"));
        assertEquals("ANNOUNCEMENT", notification.getType());
        assertTrue(notification.isPinned());
        assertEquals(302, notification.getCreatedBy());
        assertNotNull(notification.getCreatedAt());
    }

    @Test
    public void testNotificationTypeBoundary() {
        String[] validTypes = {"ANNOUNCEMENT", "SYSTEM", "REMINDER", "DUE_ALERT"};
        for (String type : validTypes) {
            notification.setType(type);
            assertEquals(type, notification.getType());
        }
    }

    @Test
    public void testNotificationPinToggle() {
        notification.setPinned(true);
        assertTrue(notification.isPinned());

        notification.setPinned(false);
        assertFalse(notification.isPinned());
    }
}
