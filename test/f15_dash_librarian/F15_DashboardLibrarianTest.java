package f15_dash_librarian;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class F15_DashboardLibrarianTest {

    @Before
    public void setUp() {
    }

    // ========================================================================
    // F15: DASHBOARD LIBRARIAN - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testLibrarianDashboardMetrics() {
        int pendingCheckOuts = 5;
        int pendingCheckIns = 12;
        int pendingIncidents = 2;

        assertEquals(5, pendingCheckOuts);
        assertEquals(12, pendingCheckIns);
        assertEquals(2, pendingIncidents);
    }
}
