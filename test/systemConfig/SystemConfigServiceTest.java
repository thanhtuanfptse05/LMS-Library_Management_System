package systemConfig;

import exception.ValidationException;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import service.SystemConfigService;

public class SystemConfigServiceTest {

    private SystemConfigService service;

    @BeforeEach
    public void setUp() {
        service = new SystemConfigService();
    }

    @Test
    public void testValidatePositiveIntSuccess() {
        Assertions.assertDoesNotThrow(() -> {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "14");
        });
    }

    @Test
    public void testValidatePositiveIntFailureZero() {
        ValidationException ex = Assertions.assertThrows(ValidationException.class, () -> {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "0");
        });
        Assertions.assertEquals("Giá trị phải là số nguyên dương.", ex.getMessage());
    }

    @Test
    public void testValidatePositiveIntFailureString() {
        ValidationException ex = Assertions.assertThrows(ValidationException.class, () -> {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "abc");
        });
        Assertions.assertEquals("Định dạng dữ liệu không hợp lệ. Vui lòng kiểm tra lại.", ex.getMessage());
    }

    @Test
    public void testValidateNonNegativeIntSuccess() {
        Assertions.assertDoesNotThrow(() -> {
            service.validateValue("MAX_EXTENSION_COUNT", "0");
        });
    }

    @Test
    public void testValidateNonNegativeIntFailure() {
        ValidationException ex = Assertions.assertThrows(ValidationException.class, () -> {
            service.validateValue("MAX_EXTENSION_COUNT", "-1");
        });
        Assertions.assertEquals("Giá trị phải là số nguyên không âm.", ex.getMessage());
    }

    @Test
    public void testValidateNonNegativeDecimalSuccess() {
        Assertions.assertDoesNotThrow(() -> {
            service.validateValue("FINE_RATE_PER_DAY", "0.0");
        });
        Assertions.assertDoesNotThrow(() -> {
            service.validateValue("FINE_RATE_PER_DAY", "1500.5");
        });
    }

    @Test
    public void testValidateNonNegativeDecimalFailure() {
        ValidationException ex = Assertions.assertThrows(ValidationException.class, () -> {
            service.validateValue("FINE_RATE_PER_DAY", "-1000");
        });
        Assertions.assertEquals("Giá trị phải là số thực không âm.", ex.getMessage());
    }

    @Test
    public void testValidateStringSuccess() {
        Assertions.assertDoesNotThrow(() -> {
            service.validateValue("SEPAY_API_KEY", "any_string_123");
        });
    }

    @Test
    public void testValidateEmptyValue() {
        ValidationException ex = Assertions.assertThrows(ValidationException.class, () -> {
            service.validateValue("STUDENT_MAX_BORROW_DAYS", "");
        });
        Assertions.assertEquals("Giá trị không được để trống.", ex.getMessage());
    }
}
