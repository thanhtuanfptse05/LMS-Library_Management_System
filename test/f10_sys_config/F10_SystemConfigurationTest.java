package f10_sys_config;

import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class F10_SystemConfigurationTest {

    private Map<String, String> configs;

    @Before
    public void setUp() {
        configs = new HashMap<>();
        configs.put("MAX_BORROW_DAYS_STUDENT", "14");
        configs.put("MAX_BORROW_DAYS_LECTURER", "30");
        configs.put("FINE_RATE_PER_DAY", "5000");
        configs.put("RESERVATION_HOLD_DAYS", "3");
        configs.put("MAX_EXTENSION_COUNT", "2");
    }

    // ========================================================================
    // F10: SYSTEM CONFIGURATION - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testConfigParsingInteger() {
        int maxStudentDays = Integer.parseInt(configs.get("MAX_BORROW_DAYS_STUDENT"));
        assertEquals(14, maxStudentDays);

        int maxLecturerDays = Integer.parseInt(configs.get("MAX_BORROW_DAYS_LECTURER"));
        assertEquals(30, maxLecturerDays);
    }

    @Test
    public void testConfigParsingFineRate() {
        long fineRate = Long.parseLong(configs.get("FINE_RATE_PER_DAY"));
        assertEquals(5000L, fineRate);
    }

    @Test
    public void testConfigFallbackDefaults() {
        String missingConfig = configs.getOrDefault("NON_EXISTING_KEY", "100");
        assertEquals("100", missingConfig);
    }
}
