<%-- desk-checkout.jsp — Trang Giao Sách (Check-out) tại quầy thủ thư --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<style>
    /* ════ STYLE HỖ TRỢ MÁY QUÉT BARCODE ════ */
    .btn-scan-active {
        background-color: #d97706 !important; /* Cam đậm */
        border-color: #d97706 !important;
        color: white !important;
        animation: scan-pulse-animation 1.5s infinite ease-in-out;
    }
    @keyframes scan-pulse-animation {
        0% { opacity: 1; }
        50% { opacity: 0.6; }
        100% { opacity: 1; }
    }
    @keyframes rotation {
        from { transform: rotate(0deg); }
        to { transform: rotate(359deg); }
    }
    .rotating-icon {
        display: inline-block;
        animation: rotation 2s infinite linear;
    }
</style>
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
                    <li class="breadcrumb-item active text-on-surface-variant" aria-current="page">Giao sách</li>
                </ol>
            </nav>

            <%-- Page Title --%>
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="rounded-3 d-flex align-items-center justify-content-center"
                     style="width:48px;height:48px;background-color:rgba(157,67,0,0.1);">
                    <span class="material-symbols-outlined text-primary-custom" style="font-size:24px;">published_with_changes</span>
                </div>
                <div>
                    <h2 class="fw-bold mb-0" style="font-size:20px;color:var(--on-surface);">Giao Sách cho Độc giả</h2>
                    <p class="mb-0 small text-on-surface-variant">Xác nhận giao sách và tạo bản ghi mượn mới</p>
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

            <%-- ════ FORM CARD ════ --%>
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6">
                    <div class="raised-card p-4">

                        <h3 class="fw-bold mb-1" style="font-size:16px;color:var(--on-surface);">
                            Thông tin Giao Sách
                        </h3>
                        <p class="small text-on-surface-variant mb-4">
                            Nhập mã người dùng và quét mã vạch bản sao sách cần giao.
                        </p>

                        <form id="formCheckOut"
                              action="${pageContext.request.contextPath}/librarian/checkout"
                              method="POST" novalidate>

                            <%-- Mã số độc giả --%>
                            <div class="mb-3">
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
                                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-1 btn-scan" onclick="toggleScanner('memberCode', this)" style="border-color:var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size:18px;">barcode_scanner</span>
                                        <span>Quét</span>
                                    </button>
                                </div>
                                <div class="form-text text-on-surface-variant">
                                    Nhập mã số thẻ sinh viên hoặc giảng viên của độc giả mượn sách.
                                </div>
                            </div>

                            <%-- Mã vạch sách --%>
                            <div class="mb-4">
                                <label for="barcode" class="form-label fw-bold small text-on-surface-variant">
                                    Mã Vạch Bản Sao (Barcode)
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"
                                          style="background:var(--surface-container-low);border-color:var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size:18px;color:var(--on-surface-variant);">barcode_scanner</span>
                                    </span>
                                    <input type="text"
                                           id="barcode"
                                           name="barcode"
                                           class="form-control"
                                           placeholder="Quét hoặc nhập mã vạch..."
                                           maxlength="100"
                                           required
                                           autofocus
                                           style="border-color:var(--outline-variant);">
                                    <button type="button" class="btn btn-outline-primary d-flex align-items-center gap-1 btn-scan" onclick="toggleScanner('barcode', this)" style="border-color:var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size:18px;">barcode_scanner</span>
                                        <span>Quét</span>
                                    </button>
                                </div>
                                <div class="form-text text-on-surface-variant">
                                    Đặt con trỏ vào ô này và quét barcode bằng súng đọc mã vạch.
                                </div>
                            </div>

                            <%-- Lưu ý nghiệp vụ --%>
                            <div class="rounded-3 p-3 mb-4 small"
                                 style="background-color:rgba(157,67,0,0.06);border:1px solid rgba(157,67,0,0.15);">
                                <p class="fw-bold text-primary-custom mb-1">
                                    <span class="material-symbols-outlined" style="font-size:15px;vertical-align:middle;">info</span>
                                    Lưu ý trước khi giao sách
                                </p>
                                <ul class="mb-0 ps-3 text-on-surface-variant" style="line-height:1.8;">
                                    <li>Kiểm tra người dùng không có khoản nợ phạt chưa thanh toán.</li>
                                    <li>Bản sao sách phải ở trạng thái <strong>Sẵn có</strong> hoặc <strong>Đã đặt trước</strong> cho người dùng này.</li>
                                    <li>Hạn mượn mặc định là <strong>14 ngày</strong> kể từ hôm nay.</li>
                                </ul>
                            </div>

                            <%-- Nút submit --%>
                            <div class="d-flex gap-2">
                                <button type="submit"
                                        id="btnCheckOut"
                                        class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                    <span class="material-symbols-outlined me-1" style="font-size:18px;vertical-align:middle;">check_circle</span>
                                    Xác Nhận Giao Sách
                                </button>
                                <a href="${pageContext.request.contextPath}/librarian/dashboard"
                                   class="btn rounded-3 fw-bold py-2"
                                   style="background:var(--surface-container-high);color:var(--on-surface-variant);">
                                    Hủy
                                </a>
                            </div>

                        </form>
                    </div>

                    <%-- Shortcuts --%>
                    <div class="d-flex gap-2 mt-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/librarian/checkin"
                           class="btn btn-sm rounded-3 fw-bold text-decoration-none"
                           style="background:var(--surface-container-low);color:var(--on-surface-variant);border:1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined me-1" style="font-size:14px;vertical-align:middle;">assignment_return</span>
                            Nhận Sách
                        </a>
                        <a href="${pageContext.request.contextPath}/librarian/cash-payment"
                           class="btn btn-sm rounded-3 fw-bold text-decoration-none"
                           style="background:var(--surface-container-low);color:var(--on-surface-variant);border:1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined me-1" style="font-size:14px;vertical-align:middle;">payments</span>
                            Thu Tiền Phạt
                        </a>
                    </div>
                </div>
            </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tự động focus vào ô barcode sau khi submit thành công
        document.addEventListener('DOMContentLoaded', function () {
            const barcodeInput = document.getElementById('barcode');
            if (barcodeInput) barcodeInput.focus();
        });

        // ════ QUẢN LÝ MÁY QUÉT BARCODE BẰNG ĐIỆN THOẠI ════
        let activeScanInputId = null;
        let activeScanButtonEl = null;
        let originalBtnHtml = '';

        function toggleScanner(inputId, buttonEl) {
            if (activeScanInputId === inputId) {
                resetScanner();
            } else {
                if (activeScanInputId) {
                    resetScanner();
                }
                activeScanInputId = inputId;
                activeScanButtonEl = buttonEl;
                originalBtnHtml = buttonEl.innerHTML;

                buttonEl.classList.add('btn-scan-active');
                buttonEl.innerHTML = `
                    <span class="material-symbols-outlined rotating-icon" style="font-size:16px; vertical-align:middle;">sync</span>
                    <span>Đang quét...</span>
                `;

                const inputEl = document.getElementById(inputId);
                if (inputEl) {
                    inputEl.value = '';
                    inputEl.focus();
                }
            }
        }

        function resetScanner() {
            if (activeScanButtonEl) {
                activeScanButtonEl.classList.remove('btn-scan-active');
                activeScanButtonEl.innerHTML = originalBtnHtml;
            }
            activeScanInputId = null;
            activeScanButtonEl = null;
            originalBtnHtml = '';
        }

        // Đăng ký sự kiện keydown toàn cục để bắt Enter và chặn submit
        document.addEventListener('keydown', function(e) {
            if (activeScanInputId) {
                const target = e.target;
                if (target && target.id === activeScanInputId) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        e.stopPropagation();
                        resetScanner();
                    } else if (e.key === 'Escape') {
                        e.preventDefault();
                        resetScanner();
                    }
                }
            }
        }, true); // Sử dụng capture để chặn sự kiện sớm nhất
    </script>
</body>
</html>