package service;

import dao.FineDAO;
import dao.PaymentDAO;
import exception.ValidationException;
import java.math.BigDecimal;
import java.util.Set;

/**
 * PaymentService — Lớp Service xử lý logic nghiệp vụ Quản lý Thanh toán và Tiền phạt (FR-F6-07).
 */
public class PaymentService {

    private final PaymentDAO paymentDAO;
    private final FineDAO fineDAO;

    public PaymentService() {
        this(new PaymentDAO(), new FineDAO());
    }

    public PaymentService(PaymentDAO paymentDAO, FineDAO fineDAO) {
        this.paymentDAO = paymentDAO;
        this.fineDAO = fineDAO;
    }

    /**
     * Validate thông tin đơn thanh toán trước khi xử lý.
     */
    public void validatePayment(BigDecimal amount, String paymentMethod) throws ValidationException {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Số tiền thanh toán phải lớn hơn 0.");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new ValidationException("Phương thức thanh toán không được để trống.");
        }

        Set<String> validMethods = Set.of("CASH", "SEPAY", "VNPAY", "BANK_TRANSFER");
        if (!validMethods.contains(paymentMethod.trim().toUpperCase())) {
            throw new ValidationException("Phương thức thanh toán không được hỗ trợ: " + paymentMethod);
        }
    }

    /**
     * Tính tiền phạt đền bù hỏng hoặc mất sách (Giá trị sách * 1.5, fallback 500,000 VND).
     */
    public BigDecimal calculateCompensationFine(BigDecimal bookPrice) {
        BigDecimal basePrice = (bookPrice == null || bookPrice.compareTo(BigDecimal.ZERO) <= 0)
                ? new BigDecimal("500000")
                : bookPrice;
        return basePrice.multiply(new BigDecimal("1.5"));
    }

    /**
     * Tính tiền phạt trả trễ dựa trên số ngày quá hạn và mức phạt mỗi ngày.
     */
    public BigDecimal calculateOverdueFine(long overdueDays, BigDecimal finePerDay) {
        if (overdueDays <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal rate = (finePerDay == null || finePerDay.compareTo(BigDecimal.ZERO) <= 0)
                ? new BigDecimal("5000")
                : finePerDay;
        return rate.multiply(new BigDecimal(overdueDays));
    }
}
