<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">
        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto d-flex flex-column" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5 flex-grow-1">
                
                <!-- Page Title -->
                <div class="mb-4">
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Secure Checkout</h2>
                    <p class="font-body-md text-on-surface-variant">Review your invoice itemization and select your payment method.</p>
                </div>

                <div class="row g-4">
                    <!-- Left: Invoice Details (8 cols) -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card p-4 border border-outline-variant bg-white">
                            <div class="d-flex align-items-center gap-2 mb-4">
                                <span class="material-symbols-outlined text-primary fs-4">receipt_long</span>
                                <h4 class="mb-0 fw-bold" style="font-size: 20px;">Invoice Summary</h4>
                            </div>

                            <div class="table-responsive mb-4">
                                <table class="table align-middle">
                                    <thead>
                                        <tr style="background-color: var(--surface-container-low);">
                                            <th class="ps-3">Violation Details</th>
                                            <th>Date Issued</th>
                                            <th class="text-end pe-3">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Selected Fine 1 -->
                                        <tr>
                                            <td class="ps-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="d-flex align-items-center justify-content-center rounded bg-light" style="width: 40px; height: 50px;">
                                                        <span class="material-symbols-outlined text-muted">menu_book</span>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-bold">Introduction to Algorithms (4th Edition)</p>
                                                        <small class="text-muted">Barcode: LMS-BK-10293 • Late Return Penalty</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>May 20, 2026</td>
                                            <td class="text-end fw-bold text-danger pe-3">$12.00</td>
                                        </tr>
                                        <!-- Selected Fine 2 -->
                                        <tr>
                                            <td class="ps-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="d-flex align-items-center justify-content-center rounded bg-light" style="width: 40px; height: 50px;">
                                                        <span class="material-symbols-outlined text-muted">menu_book</span>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-bold">Design Patterns: Elements of Reusable Object-Oriented Software</p>
                                                        <small class="text-muted">Barcode: LMS-BK-00892 • Damaged Book Cover</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>Jun 02, 2026</td>
                                            <td class="text-end fw-bold text-danger pe-3">$12.00</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="row justify-content-end">
                                <div class="col-12 col-md-6">
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span class="text-muted">Fines Subtotal</span>
                                        <span class="fw-bold text-dark">$24.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span class="text-muted">Processing Fee (Gateway)</span>
                                        <span class="fw-bold text-dark">$0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between py-2 mt-2">
                                        <span class="fw-bold text-dark fs-5">Total Amount Due</span>
                                        <span class="fw-bold text-primary-custom fs-5">$24.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Payment Method (4 cols) -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card p-4 border border-outline-variant bg-white h-100 d-flex flex-column">
                            <div class="d-flex align-items-center gap-2 mb-4">
                                <span class="material-symbols-outlined text-primary fs-4">payment</span>
                                <h4 class="mb-0 fw-bold" style="font-size: 20px;">Payment Method</h4>
                            </div>

                            <!-- Payment Gateways Options -->
                            <div class="d-flex flex-column gap-3 mb-4 flex-grow-1">
                                <!-- VNPAY -->
                                <label class="border rounded-3 p-3 d-flex align-items-center justify-content-between cursor-pointer" style="border-color: var(--outline-variant) !important; background-color: var(--surface-container-low);">
                                    <div class="d-flex align-items-center gap-3">
                                        <input type="radio" name="paymentGateway" value="vnpay" class="form-check-input" checked />
                                        <div>
                                            <p class="mb-0 fw-bold">VNPAY Portal</p>
                                            <small class="text-muted">QR Code, E-Banking, Credit Card</small>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-primary-custom fs-2">qr_code_2</span>
                                </label>

                                <!-- Local Bank Card -->
                                <label class="border rounded-3 p-3 d-flex align-items-center justify-content-between cursor-pointer" style="border-color: var(--outline-variant) !important;">
                                    <div class="d-flex align-items-center gap-3">
                                        <input type="radio" name="paymentGateway" value="bank" class="form-check-input" />
                                        <div>
                                            <p class="mb-0 fw-bold">Local ATM Card</p>
                                            <small class="text-muted">Domestic Bank Accounts</small>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-secondary fs-2">account_balance</span>
                                </label>

                                <!-- International Card -->
                                <label class="border rounded-3 p-3 d-flex align-items-center justify-content-between cursor-pointer" style="border-color: var(--outline-variant) !important;">
                                    <div class="d-flex align-items-center gap-3">
                                        <input type="radio" name="paymentGateway" value="intl" class="form-check-input" />
                                        <div>
                                            <p class="mb-0 fw-bold">International Cards</p>
                                            <small class="text-muted">Visa, Mastercard, JCB</small>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-secondary fs-2">credit_card</span>
                                </label>
                            </div>

                            <!-- Form redirects to checkout responses -->
                            <div class="d-flex flex-column gap-2 mt-auto">
                                <button type="button" onclick="simulatedCheckout('success')" class="btn btn-primary-custom w-100 py-3 rounded-pill fw-bold d-flex align-items-center justify-content-center gap-2">
                                    <span class="material-symbols-outlined">shield</span>
                                    Pay Securely with VNPAY
                                </button>
                                <button type="button" onclick="simulatedCheckout('cancel')" class="btn btn-outline-secondary w-100 py-2.5 rounded-pill fw-bold">
                                    Cancel Payment
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function simulatedCheckout(status) {
            if (status === 'success') {
                window.location.href = '${pageContext.request.contextPath}/student/payment-success.jsp';
            } else {
                window.location.href = '${pageContext.request.contextPath}/student/payment-cancel.jsp';
            }
        }
    </script>
</body>
</html>
