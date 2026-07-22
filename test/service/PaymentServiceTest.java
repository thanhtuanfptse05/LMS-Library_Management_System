package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import static org.junit.Assert.*;

public class PaymentServiceTest {

    private PaymentService paymentService;

    @Before
    public void setUp() {
        paymentService = new PaymentService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidatePaymentSuccess() throws ValidationException {
        paymentService.validatePayment(new BigDecimal("50000"), "Cash");
        paymentService.validatePayment(new BigDecimal("100000"), "SePay");
        paymentService.validatePayment(new BigDecimal("200000"), "VNPAY");
    }

    @Test
    public void testCalculateCompensationFine() {
        BigDecimal bookPrice = new BigDecimal("200000");
        BigDecimal result = paymentService.calculateCompensationFine(bookPrice);
        assertEquals(new BigDecimal("300000.0"), result);
    }

    @Test
    public void testCalculateOverdueFine() {
        BigDecimal fine = paymentService.calculateOverdueFine(5, new BigDecimal("5000"));
        assertEquals(new BigDecimal("25000"), fine);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testCalculateCompensationFineFallbackPrice() {
        BigDecimal resultNull = paymentService.calculateCompensationFine(null);
        assertEquals(new BigDecimal("750000.0"), resultNull);

        BigDecimal resultZero = paymentService.calculateCompensationFine(BigDecimal.ZERO);
        assertEquals(new BigDecimal("750000.0"), resultZero);
    }

    @Test
    public void testCalculateOverdueFineZeroDays() {
        BigDecimal fine = paymentService.calculateOverdueFine(0, new BigDecimal("5000"));
        assertEquals(BigDecimal.ZERO, fine);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidatePaymentZeroAmountThrowsException() throws ValidationException {
        paymentService.validatePayment(BigDecimal.ZERO, "Cash");
    }

    @Test(expected = ValidationException.class)
    public void testValidatePaymentNegativeAmountThrowsException() throws ValidationException {
        paymentService.validatePayment(new BigDecimal("-10000"), "Cash");
    }

    @Test(expected = ValidationException.class)
    public void testValidatePaymentInvalidMethodThrowsException() throws ValidationException {
        paymentService.validatePayment(new BigDecimal("50000"), "BITCOIN");
    }
}
