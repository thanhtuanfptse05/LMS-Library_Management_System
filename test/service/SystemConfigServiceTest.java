package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class SystemConfigServiceTest {

    private SystemConfigService configService;

    @Before
    public void setUp() {
        configService = new SystemConfigService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValuePositiveIntSuccess() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "14");
    }

    @Test
    public void testValidateValueNonNegativeIntSuccess() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "2");
    }

    @Test
    public void testValidateValueNonNegativeDecimalSuccess() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "5000.50");
    }

    @Test
    public void testValidateValueStringSuccess() throws ValidationException {
        configService.validateValue("SEPAY_BANK_CODE", "MBBANK");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateValuePositiveIntBoundaryOne() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "1");
    }

    @Test
    public void testValidateValueNonNegativeIntBoundaryZero() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "0");
    }

    @Test
    public void testValidateValueNonNegativeDecimalBoundaryZero() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "0.0");
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateValueNullThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", null);
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueBlankThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValuePositiveIntZeroThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "0");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValuePositiveIntNegativeThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "-10");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueNonNegativeIntNegativeThrowsException() throws ValidationException {
        configService.validateValue("MAX_EXTENSION_COUNT", "-1");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueNonNegativeDecimalNegativeThrowsException() throws ValidationException {
        configService.validateValue("FINE_RATE_PER_DAY", "-100.0");
    }

    @Test(expected = ValidationException.class)
    public void testValidateValueInvalidNumberFormatThrowsException() throws ValidationException {
        configService.validateValue("STUDENT_MAX_BORROW_DAYS", "not_a_number");
    }
}
