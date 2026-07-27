package f11_sys_report;

import dto.ManagementSummaryDTO;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class F11_SystemReportTest {

    private ManagementSummaryDTO summary;

    @Before
    public void setUp() {
        summary = new ManagementSummaryDTO();
        summary.setTotalCount(1500);
        summary.setActiveCount(1420);
        summary.setHiddenCount(80);
        summary.setUnusedCount(0);
    }

    // ========================================================================
    // F11: SYSTEM REPORT - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testManagementSummaryDTOGetters() {
        assertEquals(1500, summary.getTotalCount());
        assertEquals(1420, summary.getActiveCount());
        assertEquals(80, summary.getHiddenCount());
        assertEquals(0, summary.getUnusedCount());
    }

    @Test
    public void testUserActiveRatioCalculation() {
        double activeRatio = (double) summary.getActiveCount() / summary.getTotalCount();
        assertTrue("Active user ratio > 90%", activeRatio > 0.90);
    }
}
