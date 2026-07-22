package service;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class DeskCirculationServiceTest {

    private DeskCirculationService service;

    @Before
    public void setUp() {
        service = new DeskCirculationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testServiceInstantiation() {
        assertNotNull("DeskCirculationService được khởi tạo thành công", service);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testCheckOutBoundaryInvalidLibrarianIdZero() throws Exception {
        service.processCheckOut(0, "STUDENT001", "BC-1001");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testCheckOutNullBarcode() throws Exception {
        service.processCheckOut(1, "STUDENT001", null);
    }

    @Test(expected = Exception.class)
    public void testCheckOutBlankBarcode() throws Exception {
        service.processCheckOut(1, "STUDENT001", "   ");
    }

    @Test(expected = Exception.class)
    public void testCheckInNullBarcode() throws Exception {
        service.processCheckIn(1, null, "good");
    }

    @Test(expected = Exception.class)
    public void testCheckInBlankBarcode() throws Exception {
        service.processCheckIn(1, "   ", "good");
    }
}
