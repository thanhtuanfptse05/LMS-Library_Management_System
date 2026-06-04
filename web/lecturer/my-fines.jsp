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
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5">
                
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4 gap-3">
                    <div>
                        <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Lecturer Fines & Billing</h2>
                        <p class="font-body-md text-on-surface-variant mb-0">Track and settle institutional or departmental library penalties.</p>
                    </div>
                </div>

                <!-- KPI Stats Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="raised-card p-4 border border-outline-variant d-flex align-items-center gap-3">
                            <div class="d-flex align-items-center justify-content-center rounded-3 bg-danger-subtle text-danger" style="width: 56px; height: 56px;">
                                <span class="material-symbols-outlined fs-2">gavel</span>
                            </div>
                            <div>
                                <span class="font-label-md text-on-surface-variant text-uppercase">Unpaid Balance</span>
                                <h3 class="mb-0 fw-bold text-danger mt-1">$45.00</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="raised-card p-4 border border-outline-variant d-flex align-items-center gap-3">
                            <div class="d-flex align-items-center justify-content-center rounded-3 bg-success-subtle text-success" style="width: 56px; height: 56px;">
                                <span class="material-symbols-outlined fs-2">verified</span>
                            </div>
                            <div>
                                <span class="font-label-md text-on-surface-variant text-uppercase">Total Settled</span>
                                <h3 class="mb-0 fw-bold text-success mt-1">$120.00</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="raised-card p-4 border border-outline-variant d-flex align-items-center gap-3">
                            <div class="d-flex align-items-center justify-content-center rounded-3 bg-info-subtle text-primary" style="width: 56px; height: 56px;">
                                <span class="material-symbols-outlined fs-2">receipt</span>
                            </div>
                            <div>
                                <span class="font-label-md text-on-surface-variant text-uppercase">Receipts Issued</span>
                                <h3 class="mb-0 fw-bold text-primary-custom mt-1">2 Receipts</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Tabs -->
                <div class="raised-card p-4 border border-outline-variant">
                    <ul class="nav nav-pills mb-4 gap-2" id="fineTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active rounded-pill fw-bold" id="unpaid-tab" data-bs-toggle="pill" data-bs-target="#unpaid-content" type="button" role="tab" aria-controls="unpaid-content" aria-selected="true">
                                Active Unpaid Fines (2)
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link rounded-pill fw-bold" id="history-tab" data-bs-toggle="pill" data-bs-target="#history-content" type="button" role="tab" aria-controls="history-content" aria-selected="false">
                                Payment History
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="fineTabsContent">
                        <!-- TAB 1: UNPAID FINES -->
                        <div class="tab-pane fade show active" id="unpaid-content" role="tabpanel" aria-labelledby="unpaid-tab">
                            <form action="${pageContext.request.contextPath}/student/payment-checkout.jsp" method="POST" id="checkoutForm">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead>
                                            <tr style="background-color: var(--surface-container-low);">
                                                <th style="width: 50px;" class="ps-3">
                                                    <input type="checkbox" id="selectAllFines" class="form-check-input" />
                                                </th>
                                                <th>Violation Details</th>
                                                <th>Issue Date</th>
                                                <th>Days Overdue</th>
                                                <th class="text-end">Fine Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Fine Item 1 -->
                                            <tr>
                                                <td class="ps-3">
                                                    <input type="checkbox" name="selectedFines" value="FINE-8761" data-amount="30.00" class="form-check-input fine-checkbox" />
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="d-flex align-items-center justify-content-center rounded bg-light" style="width: 40px; height: 50px;">
                                                            <span class="material-symbols-outlined text-muted">menu_book</span>
                                                        </div>
                                                        <div>
                                                            <p class="mb-0 fw-bold">Quantum Mechanics: Concepts and Applications</p>
                                                            <small class="text-muted">Barcode: LMS-BK-22891 • Damaged Pages (Spilled liquid)</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Apr 14, 2026</td>
                                                <td><span class="badge badge-overdue">60 Days</span></td>
                                                <td class="text-end fw-bold text-danger">$30.00</td>
                                            </tr>
                                            <!-- Fine Item 2 -->
                                            <tr>
                                                <td class="ps-3">
                                                    <input type="checkbox" name="selectedFines" value="FINE-8802" data-amount="15.00" class="form-check-input fine-checkbox" />
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="d-flex align-items-center justify-content-center rounded bg-light" style="width: 40px; height: 50px;">
                                                            <span class="material-symbols-outlined text-muted">menu_book</span>
                                                        </div>
                                                        <div>
                                                            <p class="mb-0 fw-bold">Thermodynamics and Statistical Mechanics</p>
                                                            <small class="text-muted">Barcode: LMS-BK-49210 • Overdue Return Penalty</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>May 29, 2026</td>
                                                <td><span class="badge badge-due-soon">6 Days</span></td>
                                                <td class="text-end fw-bold text-danger">$15.00</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Checkout Action Bar -->
                                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mt-4 pt-3 border-top gap-3">
                                    <div>
                                        <p class="mb-0 text-muted">Selected Fines: <span id="selectedCount" class="fw-bold text-dark">0</span></p>
                                        <h4 class="mb-0 mt-1">Total to Pay: <span id="totalAmountDisplay" class="fw-bold text-primary-custom">$0.00</span></h4>
                                    </div>
                                    <button type="submit" id="checkoutBtn" class="btn btn-primary-custom px-4 py-2.5 rounded-pill fw-bold d-flex align-items-center gap-2" disabled>
                                        <span class="material-symbols-outlined">shopping_cart_checkout</span>
                                        Proceed to Checkout
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- TAB 2: PAID HISTORY -->
                        <div class="tab-pane fade" id="history-content" role="tabpanel" aria-labelledby="history-tab">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr style="background-color: var(--surface-container-low);">
                                            <th class="ps-3">Receipt ID</th>
                                            <th>Date Paid</th>
                                            <th>Payment Method</th>
                                            <th>Fines Cleared</th>
                                            <th class="text-end">Amount Paid</th>
                                            <th class="text-center">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="ps-3 fw-bold">REC-2026-0089</td>
                                            <td>Feb 22, 2026</td>
                                            <td>
                                                <span class="d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 18px;">qr_code_2</span>
                                                    VNPAY Gateway
                                                </span>
                                            </td>
                                            <td>Late return - Advanced Fluid Dynamics</td>
                                            <td class="text-end fw-bold text-success">$20.00</td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1">Print PDF</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ps-3 fw-bold">REC-2025-9981</td>
                                            <td>Dec 10, 2025</td>
                                            <td>
                                                <span class="d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined text-secondary" style="font-size: 18px;">payments</span>
                                                    Cash Counter
                                                </span>
                                            </td>
                                            <td>Lost book - Laser Physics Handbook</td>
                                            <td class="text-end fw-bold text-success">$100.00</td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1">Print PDF</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
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
        // Fine Checkout Logic
        const selectAllCheckbox = document.getElementById('selectAllFines');
        const checkboxes = document.querySelectorAll('.fine-checkbox');
        const selectedCount = document.getElementById('selectedCount');
        const totalAmountDisplay = document.getElementById('totalAmountDisplay');
        const checkoutBtn = document.getElementById('checkoutBtn');

        function updateTotals() {
            let total = 0;
            let count = 0;

            checkboxes.forEach(cb => {
                if (cb.checked) {
                    total += parseFloat(cb.getAttribute('data-amount'));
                    count++;
                }
            });

            selectedCount.textContent = count;
            totalAmountDisplay.textContent = `$${total.toFixed(2)}`;
            checkoutBtn.disabled = count === 0;
        }

        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function() {
                checkboxes.forEach(cb => {
                    cb.checked = this.checked;
                });
                updateTotals();
            });
        }

        checkboxes.forEach(cb => {
            cb.addEventListener('change', function() {
                if (!this.checked) {
                    selectAllCheckbox.checked = false;
                } else {
                    const allChecked = Array.from(checkboxes).every(c => c.checked);
                    selectAllCheckbox.checked = allChecked;
                }
                updateTotals();
            });
        });
    </script>
</body>
</html>
