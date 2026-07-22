package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class InventoryReconciliationServiceTest {

    private InventoryReconciliationService inventoryService;

    @Before
    public void setUp() {
        inventoryService = new InventoryReconciliationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateLocationValid() throws ValidationException {
        inventoryService.validateLocation("Kệ Sách A1 - Tầng 2");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateLocationBoundary255() throws ValidationException {
        inventoryService.validateLocation("L".repeat(255));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateLocationNull() throws ValidationException {
        inventoryService.validateLocation(null);
    }

    @Test(expected = ValidationException.class)
    public void testValidateLocationBlank() throws ValidationException {
        inventoryService.validateLocation("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateLocationExceeds255() throws ValidationException {
        inventoryService.validateLocation("L".repeat(256));
    }

    @Test(expected = ValidationException.class)
    public void testScanNullBarcode() throws Exception {
        inventoryService.scan(1, null, 1);
    }

    @Test(expected = ValidationException.class)
    public void testScanBlankBarcode() throws Exception {
        inventoryService.scan(1, "   ", 1);
    }
}
