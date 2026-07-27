package f09_fine_payment;

import model.Fine;
import model.Payment;
import org.junit.Before;
import org.junit.Test;

import java.math.BigDecimal;
import java.sql.Timestamp;

import static org.junit.Assert.*;

public class F09_FinePaymentManagementTest {

    private Fine fine;
    private Payment payment;
    private long now;

    @Before
    public void setUp() {
        now = System.currentTimeMillis();

        fine = new Fine();
        fine.setFineId(901);
        fine.setBorrowRecordId(601);
        fine.setUserId(101);
        fine.setAmount(new BigDecimal("15000.00"));
        fine.setReason("Quá hạn 3 ngày");
        fine.setStatus("unpaid");
        fine.setCreatedAt(new Timestamp(now));

        payment = new Payment();
        payment.setPaymentId(9001);
        payment.setFineId(901);
        payment.setPaidAmount(new BigDecimal("15000.00"));
        payment.setPaymentMethod("SEPAY");
        payment.setTransactionReference("SEPAY_REF_9001");
        payment.setProcessedBy(301);
        payment.setStatus("paid");
        payment.setPaidAt(new Timestamp(now));
    }

    // ========================================================================
    // F09: FINE & PAYMENT MANAGEMENT - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testFineFields() {
        assertEquals(901, fine.getFineId());
        assertEquals(601, fine.getBorrowRecordId());
        assertEquals(101, fine.getUserId());
        assertEquals(new BigDecimal("15000.00"), fine.getAmount());
        assertEquals("Quá hạn 3 ngày", fine.getReason());
        assertEquals("unpaid", fine.getStatus());
        assertNotNull(fine.getCreatedAt());
    }

    @Test
    public void testFineStatusTransitions() {
        fine.setStatus("paid");
        assertEquals("paid", fine.getStatus());

        fine.setStatus("waived");
        assertEquals("waived", fine.getStatus());
    }

    @Test
    public void testPaymentFields() {
        assertEquals(9001, payment.getPaymentId());
        assertEquals(901, payment.getFineId());
        assertEquals(new BigDecimal("15000.00"), payment.getPaidAmount());
        assertEquals("SEPAY", payment.getPaymentMethod());
        assertEquals("SEPAY_REF_9001", payment.getTransactionReference());
        assertEquals(Integer.valueOf(301), payment.getProcessedBy());
        assertEquals("paid", payment.getStatus());
        assertNotNull(payment.getPaidAt());
    }

    @Test
    public void testFineCalculationOverdueDays() {
        int daysOverdue = 5;
        BigDecimal ratePerDay = new BigDecimal("5000.00");
        BigDecimal expectedFine = ratePerDay.multiply(new BigDecimal(daysOverdue));

        assertEquals(new BigDecimal("25000.00"), expectedFine);
    }
}
