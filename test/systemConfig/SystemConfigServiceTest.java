package systemConfig;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import service.SystemConfigService;

public class SystemConfigServiceTest {

    private SystemConfigService service;

    @Before
    public void setUp() {
        service = new SystemConfigService();
    }

    @Test
    public void testValidatePositiveIntSuccess() {
        try {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "14");
        } catch (ValidationException ex) {
            fail("Should not throw exception");
        }
    }

    @Test
    public void testValidatePositiveIntFailureZero() {
        try {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "0");
            fail("Expected ValidationException");
        } catch (ValidationException ex) {
            assertEquals("Giá trị phải là số nguyên dương.", ex.getMessage());
        }
    }

    @Test
    public void testValidatePositiveIntFailureString() {
        try {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "abc");
            fail("Expected ValidationException");
        } catch (ValidationException ex) {
            assertEquals("Định dạng dữ liệu không hợp lệ. Vui lòng kiểm tra lại.", ex.getMessage());
        }
    }

    @Test
    public void testValidateNonNegativeIntSuccess() {
        try {
            service.validateValue("MAX_EXTENSION_COUNT", "0");
        } catch (ValidationException ex) {
            fail("Should not throw exception");
        }
    }

    @Test
    public void testValidateNonNegativeIntFailure() {
        try {
            service.validateValue("MAX_EXTENSION_COUNT", "-1");
            fail("Expected ValidationException");
        } catch (ValidationException ex) {
            assertEquals("Giá trị phải là số nguyên không âm.", ex.getMessage());
        }
    }

    @Test
    public void testValidateNonNegativeDecimalSuccess() {
        try {
            service.validateValue("FINE_RATE_PER_DAY", "0.0");
            service.validateValue("FINE_RATE_PER_DAY", "1500.5");
        } catch (ValidationException ex) {
            fail("Should not throw exception");
        }
    }

    @Test
    public void testValidateNonNegativeDecimalFailure() {
        try {
            service.validateValue("FINE_RATE_PER_DAY", "-1000");
            fail("Expected ValidationException");
        } catch (ValidationException ex) {
            assertEquals("Giá trị phải là số thực không âm.", ex.getMessage());
        }
    }

    @Test
    public void testValidateStringSuccess() {
        try {
            service.validateValue("SEPAY_API_KEY", "any_string_123");
        } catch (ValidationException ex) {
            fail("Should not throw exception");
        }
    }

    @Test
    public void testValidateEmptyValue() {
        try {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "");
            fail("Expected ValidationException");
        } catch (ValidationException ex) {
            assertEquals("Giá trị không được để trống.", ex.getMessage());
        }
    }
}
