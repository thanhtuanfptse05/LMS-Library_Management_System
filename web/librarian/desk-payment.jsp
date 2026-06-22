<%-- desk-payment.jsp — Trang Thu Tiền Phạt (Cash Payment) tại quầy thủ thư --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body>

    <%-- ════ SIDEBAR ════ --%>
    <jsp:include page="fragments/_sidebar.jsp" />

    <%-- ════ BODY WRAPPER ════ --%>
    <div class="d-flex main-wrapper overflow-hidden">

        <%-- ════ MAIN CONTENT ════ --%>
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <%-- ════ HEADER ════ --%>
            <jsp:include page="fragments/_header.jsp" />

            <%-- ════ CONTENT ════ --%>
            <div class="container-fluid px-4 py-4">

            <%-- Breadcrumb --%>
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/librarian/dashboard"
                           class="text-primary-custom text-decoration-none">Bảng điều khiển</a>
                    </li>
                    <li class="breadcrumb-item active text-on-surface-variant" aria-current="page">Thu tiền phạt</li>
                </ol>
            </nav>

            <%-- Page Title --%>
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="rounded-3 d-flex align-items-center justify-content-center"
                     style="width:48px;height:48px;background-color:rgba(16,185,129,0.1);">
                    <span class="material-symbols-outlined" style="font-size:24px;color:#059669;">payments</span>
                </div>
                <div>
                    <h2 class="fw-bold mb-0" style="font-size:20px;color:var(--on-surface);">Duyệt Thanh Toán Tiền Mặt</h2>
                    <p class="mb-0 small text-on-surface-variant">Xác nhận thu tiền và gỡ khóa tài khoản độc giả (BR-25)</p>
                </div>
            </div>

            <%-- ════ FLASH MESSAGES ════ --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert d-flex align-items-center gap-2 mb-4 rounded-3"
                     style="background-color:#d1fae5;border:1px solid #a7f3d0;color:#065f46;" role="alert">
                    <span class="material-symbols-outlined" style="font-size:20px;color:#10b981;">check_circle</span>
                    <div><c:out value="${sessionScope.successMessage}"/></div>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert d-flex align-items-center gap-2 mb-4 rounded-3"
                     style="background-color:#fee2e2;border:1px solid #fca5a5;color:#991b1b;" role="alert">
                    <span class="material-symbols-outlined" style="font-size:20px;color:#ef4444;">error</span>
                    <div><c:out value="${sessionScope.errorMessage}"/></div>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <%-- ════ LAYOUT 2 CỘT: Form + Hướng dẫn ════ --%>
            <div class="row g-4 justify-content-center">

                <%-- Cột Form --%>
                <div class="col-12 col-md-7 col-lg-5">
                    <div class="raised-card p-4">

                        <h3 class="fw-bold mb-1" style="font-size:16px;color:var(--on-surface);">
                            Thông tin Thanh Toán
                        </h3>
                        <p class="small text-on-surface-variant mb-4">
                            Nhập mã phiếu phạt và mã người dùng để duyệt thanh toán tiền mặt.
                        </p>

                        <form id="formCashPayment"
                              action="${pageContext.request.contextPath}/librarian/cash-payment"
                              method="POST" novalidate>

                            <%-- Mã phiếu thanh toán --%>
                            <div class="mb-3">
                                <label for="paymentId" class="form-label fw-bold small text-on-surface-variant">
                                    Mã Phiếu Thanh Toán (Payment ID)
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"
                                          style="background:var(--surface-container-low);border-color:var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size:18px;color:var(--on-surface-variant);">receipt_long</span>
                                    </span>
                                    <input type="number"
                                           id="paymentId"
                                           name="paymentId"
                                           class="form-control"
                                           placeholder="Ví dụ: 501"
                                           min="1"
                                           required
                                           autofocus
                                           style="border-color:var(--outline-variant);">
                                </div>
                                <div class="form-text text-on-surface-variant">
                                    Mã số phiếu thanh toán được in trên phiếu thu của độc giả.
                                </div>
                            </div>

                            <%-- Mã số độc giả --%>
                            <div class="mb-4">
                                <label for="memberCode" class="form-label fw-bold small text-on-surface-variant">
                                    Mã Số Độc Giả (Student/Lecturer Code)
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"
                                          style="background:var(--surface-container-low);border-color:var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size:18px;color:var(--on-surface-variant);">person</span>
                                    </span>
                                    <input type="text"
                                           id="memberCode"
                                           name="memberCode"
                                           class="form-control"
                                           placeholder="Ví dụ: SE170123"
                                           required
                                           style="border-color:var(--outline-variant);">
                                </div>
                                <div class="form-text text-on-surface-variant">
                                    Mã số thẻ sinh viên hoặc giảng viên của độc giả đang đứng tại quầy.
                                </div>
                            </div>

                            <%-- Xác nhận thu tiền --%>
                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox"
                                           id="confirmReceived" required
                                           style="accent-color:var(--primary);">
                                    <label class="form-check-label small fw-bold text-on-surface-variant"
                                           for="confirmReceived">
                                        Tôi xác nhận đã nhận đủ số tiền mặt từ độc giả.
                                    </label>
                                </div>
                            </div>

                            <%-- Nút submit --%>
                            <div class="d-flex gap-2">
                                <button type="submit"
                                        id="btnPayment"
                                        class="btn flex-grow-1 rounded-3 fw-bold py-2"
                                        style="background-color:#059669;color:white;border:none;transition:all 0.2s ease;"
                                        disabled>
                                    <span class="material-symbols-outlined me-1" style="font-size:18px;vertical-align:middle;">task_alt</span>
                                    Duyệt Thanh Toán
                                </button>
                                <a href="${pageContext.request.contextPath}/librarian/dashboard"
                                   class="btn rounded-3 fw-bold py-2"
                                   style="background:var(--surface-container-high);color:var(--on-surface-variant);">
                                    Hủy
                                </a>
                            </div>

                        </form>
                    </div>
                </div>

                <%-- Cột Hướng dẫn nghiệp vụ --%>
                <div class="col-12 col-md-5 col-lg-4">

                    <%-- Quy trình --%>
                    <div class="raised-card p-4 mb-3">
                        <p class="fw-bold small text-on-surface-variant text-uppercase mb-3"
                           style="letter-spacing:0.1em;">
                            Quy trình Thu Tiền
                        </p>

                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex gap-3 align-items-start">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width:28px;height:28px;background:rgba(157,67,0,0.1);color:var(--primary);font-size:12px;flex-shrink:0;">1</div>
                                <div>
                                    <p class="fw-bold mb-0 small">Tra cứu phiếu phạt</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size:12px;">Lấy Payment ID từ hệ thống hoặc phiếu in của độc giả.</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3 align-items-start">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width:28px;height:28px;background:rgba(157,67,0,0.1);color:var(--primary);font-size:12px;flex-shrink:0;">2</div>
                                <div>
                                    <p class="fw-bold mb-0 small">Thu tiền mặt</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size:12px;">Nhận đủ số tiền đền bù từ độc giả, kiểm đếm kỹ.</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3 align-items-start">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width:28px;height:28px;background:rgba(157,67,0,0.1);color:var(--primary);font-size:12px;flex-shrink:0;">3</div>
                                <div>
                                    <p class="fw-bold mb-0 small">Duyệt trên hệ thống</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size:12px;">Nhập thông tin và nhấn "Duyệt Thanh Toán" để cập nhật.</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3 align-items-start">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width:28px;height:28px;background-color:#d1fae5;color:#059669;font-size:12px;flex-shrink:0;">✓</div>
                                <div>
                                    <p class="fw-bold mb-0 small">Tự động mở khóa tài khoản</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size:12px;">Hệ thống tự kiểm tra và mở khóa nếu không còn khoản nợ nào (BR-25).</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Cảnh báo BR-25 --%>
                    <div class="rounded-3 p-3 small"
                         style="background-color:#fff7ed;border:1px solid #fed7aa;">
                        <p class="fw-bold mb-1" style="color:#c2410c;">
                            <span class="material-symbols-outlined" style="font-size:15px;vertical-align:middle;">info</span>
                            Lưu ý BR-25 (Mở khóa an toàn)
                        </p>
                        <p class="mb-0" style="color:#9a3412;line-height:1.7;">
                            Tài khoản <strong>chỉ được mở khóa</strong> khi <em>không còn</em>
                            bất kỳ lý do khóa nào khác (bao gồm vi phạm bảo mật,
                            cấm bởi quản trị viên...). Thanh toán một khoản không đảm bảo
                            tài khoản được mở khóa ngay lập tức.
                        </p>
                    </div>

                    <%-- Shortcuts --%>
                    <div class="d-flex gap-2 mt-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/librarian/checkout"
                           class="btn btn-sm rounded-3 fw-bold text-decoration-none"
                           style="background:var(--surface-container-low);color:var(--on-surface-variant);border:1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined me-1" style="font-size:14px;vertical-align:middle;">published_with_changes</span>
                            Giao Sách
                        </a>
                        <a href="${pageContext.request.contextPath}/librarian/checkin"
                           class="btn btn-sm rounded-3 fw-bold text-decoration-none"
                           style="background:var(--surface-container-low);color:var(--on-surface-variant);border:1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined me-1" style="font-size:14px;vertical-align:middle;">assignment_return</span>
                            Nhận Sách
                        </a>
                    </div>

                </div>
            </div>

            </div>
        </main>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Nút Duyệt chỉ enable khi tick xác nhận đã thu tiền
        const confirmCheckbox = document.getElementById('confirmReceived');
        const btnPayment = document.getElementById('btnPayment');

        confirmCheckbox.addEventListener('change', function () {
            btnPayment.disabled = !this.checked;
            if (this.checked) {
                btnPayment.style.opacity = '1';
                btnPayment.style.cursor = 'pointer';
            } else {
                btnPayment.style.opacity = '0.5';
                btnPayment.style.cursor = 'not-allowed';
            }
        });
        // Trạng thái ban đầu
        btnPayment.style.opacity = '0.5';
        btnPayment.style.cursor = 'not-allowed';
    </script>
</body>
</html>
