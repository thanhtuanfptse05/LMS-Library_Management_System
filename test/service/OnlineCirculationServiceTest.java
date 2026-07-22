package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class OnlineCirculationServiceTest {

    private OnlineCirculationService service;

    @Before
    public void setUp() {
        service = new OnlineCirculationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("OnlineCirculationService được khởi tạo thành công", service);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testReserveBookBoundaryUserIdZero() throws Exception {
        service.reserveBook(0, 1, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testReserveBookBoundaryBookIdZero() throws Exception {
        service.reserveBook(1, 0, "STUDENT");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testReserveBookNegativeUserId() throws Exception {
        service.reserveBook(-1, 1, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testReserveBookNegativeBookId() throws Exception {
        service.reserveBook(1, -5, "STUDENT");
    }

    @Test(expected = Exception.class)
    public void testRenewBookInvalidRecordId() throws Exception {
        service.renewBook(-1, 1);
    }
}
