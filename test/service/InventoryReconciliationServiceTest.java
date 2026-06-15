package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class InventoryReconciliationServiceTest {
    private InventoryReconciliationService service;

    @Before
    public void setUp() {
        service = new InventoryReconciliationService(null, null, null, null, null);
    }

    @Test
    public void validateLocationAcceptsValidLocation() throws Exception {
        service.validateLocation("Kho A · Kệ A12");
        assertTrue(true);
    }

    @Test
    public void validateLocationRejectsBlankLocation() throws Exception {
        try {
            service.validateLocation(" ");
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không được để trống"));
        }
    }
}
