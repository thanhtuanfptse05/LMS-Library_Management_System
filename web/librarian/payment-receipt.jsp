<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">
        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto d-flex flex-column" style="background-color: #f7f9fb; margin-left: 256px;">
            <div class="container-xl px-4 py-5 flex-grow-1">
                
                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Xử lý thanh toán tiền mặt</h2>
                    <p class="font-body-md text-on-surface-variant">Thu tiền mặt tại quầy thư viện để xóa khoản phạt của sinh viên hoặc giảng viên.</p>
                </div>

                <div class="row g-4">
                    <!-- Left: Fine Selector & Cash Input (8 cols) -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card p-4 border border-outline-variant bg-white">
                            
                            <!-- Search & Select Member -->
                            <div class="mb-4">
                                <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">1. Trạng thái tài khoản thành viên</label>
                                <div class="p-3 border rounded-3 bg-light" style="border-color: var(--outline-variant) !important;">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 40px; height: 40px;">
                                                JV
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Jordan Vance</p>
                                                <small class="text-muted">Sinh viên • ID: 230014 • j.vance@uni.edu</small>
                                            </div>
                                        </div>
                                        <span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3 py-1.5">HOẠT ĐỘNG</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Fine Item Selection -->
                            <div class="mb-4">
                                <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">2. Chọn khoản phạt cần thanh toán</label>
                                <div class="table-responsive border rounded-3" style="border-color: var(--outline-variant) !important;">
                                    <table class="table align-middle mb-0">
                                        <thead style="background-color: var(--surface-container-low);">
                                            <tr>
                                                <th style="width: 50px;" class="ps-3">
                                                    <input type="checkbox" id="selectAllFines" class="form-check-input" checked />
                                                </th>
                                                <th>Chi tiết vi phạm</th>
                                                <th class="text-end pe-3">Số tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="ps-3">
                                                    <input type="checkbox" name="selectedFines" value="1" data-amount="12.00" class="form-check-input fine-checkbox" checked />
                                                </td>
                                                <td>
                                                    <p class="mb-0 fw-bold">Introduction to Algorithms (4th Edition)</p>
                                                    <small class="text-muted">Mã vạch: LMS-BK-10293 • Trả trễ</small>
                                                </td>
                                                <td class="text-end fw-bold text-danger pe-3">$12.00</td>
                                            </tr>
                                            <tr>
                                                <td class="ps-3">
                                                    <input type="checkbox" name="selectedFines" value="2" data-amount="12.00" class="form-check-input fine-checkbox" checked />
                                                </td>
                                                <td>
                                                    <p class="mb-0 fw-bold">Design Patterns: Object-Oriented Software</p>
                                                    <small class="text-muted">Mã vạch: LMS-BK-00892 • Hư hỏng bìa sách</small>
                                                </td>
                                                <td class="text-end fw-bold text-danger pe-3">$12.00</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Counter Calculations (4 cols) -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card p-4 border border-outline-variant bg-white h-100 d-flex flex-column">
                            <div class="d-flex align-items-center gap-2 mb-4">
                                <span class="material-symbols-outlined text-primary fs-4">calculate</span>
                                <h4 class="mb-0 fw-bold" style="font-size: 20px;">Tính toán tiền mặt</h4>
                            </div>

                            <form action="${pageContext.request.contextPath}/librarian/fine-list.jsp" method="POST" class="d-flex flex-column flex-grow-1">
                                <!-- Cash Details -->
                                <div class="d-flex flex-column gap-3 mb-4 flex-grow-1">
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span class="text-muted">Tổng tiền phạt cần thu</span>
                                        <span class="fw-bold text-dark" id="totalDueDisplay">$24.00</span>
                                    </div>

                                    <div>
                                        <label class="form-label font-label-md text-on-surface-variant text-uppercase">Tiền mặt nhận</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-outline-variant">$</span>
                                            <input type="number" step="0.01" id="cashReceived" class="form-control py-2.5 border-outline-variant" placeholder="0.00" value="30.00" required />
                                        </div>
                                    </div>

                                    <div class="p-3 rounded-3 bg-info-subtle border border-info d-flex justify-content-between align-items-center mt-2">
                                        <span class="fw-bold text-primary-custom" style="font-size: 14px;">Tiền thừa:</span>
                                        <span class="fw-bold text-primary-custom fs-4" id="changeDueDisplay">$6.00</span>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex flex-column gap-2 mt-auto">
                                    <button type="submit" class="btn btn-primary-custom w-100 py-3 rounded-pill fw-bold d-flex align-items-center justify-content-center gap-2">
                                        <span class="material-symbols-outlined">print</span>
                                        Xác nhận thanh toán & In biên lai
                                    </button>
                                    <a href="${pageContext.request.contextPath}/librarian/fine-list.jsp" class="btn btn-outline-secondary w-100 py-2.5 rounded-pill fw-bold text-center text-decoration-none">
                                        Hủy
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const checkboxes = document.querySelectorAll('.fine-checkbox');
        const selectAllCheckbox = document.getElementById('selectAllFines');
        const totalDueDisplay = document.getElementById('totalDueDisplay');
        const cashReceivedInput = document.getElementById('cashReceived');
        const changeDueDisplay = document.getElementById('changeDueDisplay');

        let totalDue = 24.00;

        function calculateChange() {
            const cash = parseFloat(cashReceivedInput.value) || 0;
            const change = cash - totalDue;
            changeDueDisplay.textContent = change >= 0 ? `$${change.toFixed(2)}` : '$0.00';
        }

        function updateTotals() {
            let total = 0;
            checkboxes.forEach(cb => {
                if (cb.checked) {
                    total += parseFloat(cb.getAttribute('data-amount'));
                }
            });
            totalDue = total;
            totalDueDisplay.textContent = `$${total.toFixed(2)}`;
            calculateChange();
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

        cashReceivedInput.addEventListener('input', calculateChange);
    </script>
</body>
</html>
