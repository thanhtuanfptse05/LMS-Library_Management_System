<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

<jsp:include page="fragments/_sidebar.jsp" />

<!-- ════════════════ BODY WRAPPER ════════════════ -->
<div class="d-flex main-wrapper overflow-hidden">

    <!-- ════════════════ MAIN CONTENT ════════════════ -->
    <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">
        
        <jsp:include page="fragments/_header.jsp" />

        <div class="container-xl px-4 py-5">

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb" style="font-size: 14px;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard" class="text-decoration-none" style="color: var(--primary);">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Lịch sử nộp phạt</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="fw-bold mb-1" style="color: var(--on-surface);">Tiền phạt & Thanh toán</h1>
                    <p class="mb-0" style="color: var(--on-surface-variant);">Theo dõi các khoản phạt phát sinh và thanh toán trực tuyến qua mã QR ngân hàng.</p>
                </div>
            </div>

            <!-- Error Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="lms-alert lms-alert-error mb-4">
                    <span class="material-symbols-outlined">error</span>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <!-- ═══ Stat Card: Tổng nợ phạt ═══ -->
            <c:if test="${unpaidCount > 0}">
                <div class="mb-4 fade-in-up">
                    <div class="stat-card" style="--card-accent: var(--error); border-left: 4px solid var(--error);">
                        <div class="d-flex align-items-center gap-3">
                            <div class="stat-icon" style="background: var(--error-container); color: var(--error);">
                                <span class="material-symbols-outlined">account_balance_wallet</span>
                            </div>
                            <div class="flex-grow-1">
                                <p class="stat-label mb-1">Tổng tiền phạt chưa thanh toán</p>
                                <p class="stat-value mb-0" style="color: var(--error);">
                                    <fmt:formatNumber value="${totalUnpaid}" type="number" groupingUsed="true"/> đ
                                </p>
                            </div>
                            <div class="text-end">
                                <span class="badge-pill badge-error">
                                    <span class="material-symbols-outlined" style="font-size: 14px;">warning</span>
                                    ${unpaidCount} khoản chưa thanh toán
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- ═══ Bảng danh sách phạt ═══ -->
            <div class="raised-card overflow-hidden fade-in-up fade-in-up-1">
                <div class="card-header-row">
                    <div>
                        <h2 class="card-title">
                            <span class="material-symbols-outlined me-2" style="font-size: 20px; color: var(--primary);">receipt_long</span>
                            Danh sách các khoản phạt
                        </h2>
                        <p class="card-subtitle">Hiển thị tất cả các khoản phạt theo thời gian phát sinh.</p>
                    </div>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty fines}">
                            <!-- Empty State -->
                            <div class="text-center py-5">
                                <span class="material-symbols-outlined d-block mb-3" style="font-size: 64px; color: var(--outline-variant);">sentiment_satisfied</span>
                                <h5 class="fw-bold" style="color: var(--on-surface-variant);">Không có khoản phạt nào</h5>
                                <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-4">Bạn không có khoản phạt nào phát sinh. Hãy tiếp tục trả sách đúng hạn nhé!</p>
                                <a href="${pageContext.request.contextPath}/book-search" class="btn btn-primary-custom fw-bold px-4 rounded-3">
                                    <span class="material-symbols-outlined me-1" style="font-size: 18px;">search</span>
                                    Tìm kiếm sách
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table-lms">
                                    <thead>
                                        <tr>
                                            <th style="padding-left: 20px;">Mã phạt</th>
                                            <th>Sách liên quan</th>
                                            <th>Lý do phạt</th>
                                            <th>Ngày phát sinh</th>
                                            <th class="text-end">Số tiền</th>
                                            <th class="text-center">Trạng thái</th>
                                            <th class="text-center" style="padding-right: 20px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="fine" items="${fines}">
                                            <tr>
                                                <td style="padding-left: 20px;">
                                                    <span class="fw-bold" style="color: var(--on-surface);">#${fine.fineId}</span>
                                                </td>
                                                <td>
                                                    <span class="fw-semibold" style="color: var(--on-surface);"><c:out value="${fine.bookTitle}"/></span>
                                                </td>
                                                <td>
                                                    <span style="color: var(--on-surface-variant); font-size: 13px;"><c:out value="${fine.reason}"/></span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${fine.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td class="text-end">
                                                    <span class="fw-bold" style="color: var(--error);">
                                                        <fmt:formatNumber value="${fine.amount}" type="number" groupingUsed="true"/> đ
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${fine.status == 'paid'}">
                                                            <span class="badge-pill badge-success">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">check_circle</span>
                                                                Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-pill badge-error">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">pending</span>
                                                                Chưa thanh toán
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center" style="padding-right: 20px;">
                                                    <c:if test="${fine.status == 'unpaid' && fine.paymentId != null}">
                                                        <button type="button"
                                                                class="btn btn-primary-custom btn-sm fw-bold px-3 rounded-3 lms-btn-qr"
                                                                data-payment-id="${fine.paymentId}"
                                                                data-fine-amount="${fine.amount}"
                                                                data-fine-reason="${fine.reason}"
                                                                data-book-title="${fine.bookTitle}"
                                                                onclick="openQrModal(this)">
                                                            <span class="material-symbols-outlined me-1" style="font-size: 16px;">qr_code_2</span>
                                                            Thanh toán QR
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${fine.status == 'paid'}">
                                                        <span style="color: var(--success); font-size: 13px;">
                                                            <span class="material-symbols-outlined" style="font-size: 16px;">verified</span>
                                                        </span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><!-- /.container-xl -->

        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div><!-- /.d-flex.main-wrapper -->

<!-- ═══════════════════════════════════════════════════ -->
<!-- MODAL THANH TOÁN QR VIETQR / SEPAY                -->
<!-- ═══════════════════════════════════════════════════ -->
<div class="modal fade" id="qrPaymentModal" tabindex="-1" aria-labelledby="qrPaymentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 460px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-xl); overflow: hidden;">

            <!-- Modal Header -->
            <div class="modal-header border-0 px-4 pt-4 pb-2" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, #fff8f6 100%);">
                <div>
                    <h5 class="modal-title fw-bold" id="qrPaymentModalLabel" style="color: var(--on-surface);">
                        <span class="material-symbols-outlined me-2" style="font-size: 22px; color: var(--primary); vertical-align: middle;">qr_code_2</span>
                        Thanh toán chuyển khoản
                    </h5>
                    <p class="mb-0 mt-1" style="font-size: 13px; color: var(--on-surface-variant);">Quét mã QR bên dưới bằng ứng dụng ngân hàng của bạn</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <!-- Modal Body -->
            <div class="modal-body px-4 py-3">

                <!-- QR Code Image -->
                <div class="text-center mb-3">
                    <div class="d-inline-block p-3 rounded-4" style="background: white; border: 2px solid var(--primary-container); box-shadow: 0 12px 32px rgba(11, 87, 208, 0.15); position: relative; overflow: hidden;">
                        <!-- Premium Glow Effect -->
                        <div style="position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: conic-gradient(from 0deg, transparent, rgba(11, 87, 208, 0.2), transparent 40%); animation: rotateGlow 4s linear infinite; z-index: 0;"></div>
                        
                        <div style="position: relative; z-index: 1; background: white; padding: 8px; border-radius: 14px; box-shadow: inset 0 0 0 1px rgba(0,0,0,0.05);">
                            <img id="qrCodeImage" src="" alt="Mã QR thanh toán"
                                 style="width: 220px; height: 220px; border-radius: var(--radius-md); transition: opacity 0.3s;"
                                 onerror="this.style.opacity='0'; document.getElementById('qrError').classList.remove('d-none'); document.getElementById('qrError').classList.add('d-flex');">
                            <div id="qrError" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.95); border-radius: var(--radius-md);" class="d-none flex-column align-items-center justify-content-center">
                                <span class="material-symbols-outlined mb-2" style="font-size: 32px; color: var(--error);">broken_image</span>
                                <span class="text-muted fw-medium" style="font-size: 14px;">Không thể tải mã QR</span>
                            </div>
                        </div>
                    </div>
                </div>
                <style>
                    @keyframes rotateGlow {
                        100% { transform: rotate(1turn); }
                    }
                </style>


                <!-- Thông tin chuyển khoản -->
                <div class="rounded-4 p-3 mb-3" style="background: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                    <p class="fw-bold mb-2" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: var(--on-surface-variant);">
                        <span class="material-symbols-outlined me-1" style="font-size: 14px;">info</span>
                        Thông tin chuyển khoản
                    </p>
                    <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 13.5px;">
                        <span style="color: var(--on-surface-variant);">Ngân hàng</span>
                        <span class="fw-bold" style="color: var(--on-surface);">${sepayBankCode}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 13.5px;">
                        <span style="color: var(--on-surface-variant);">Số tài khoản</span>
                        <span class="fw-bold" style="color: var(--on-surface);">
                            ${sepayAccountNumber}
                            <button class="btn-icon ms-1" onclick="copyToClipboard('${sepayAccountNumber}')" title="Sao chép">
                                <span class="material-symbols-outlined" style="font-size: 15px;">content_copy</span>
                            </button>
                        </span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 13.5px;">
                        <span style="color: var(--on-surface-variant);">Chủ tài khoản</span>
                        <span class="fw-bold" style="color: var(--on-surface);">${sepayAccountName}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 13.5px;">
                        <span style="color: var(--on-surface-variant);">Số tiền</span>
                        <span class="fw-bold" style="color: var(--error); font-size: 16px;" id="modalAmount">—</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center" style="font-size: 13.5px;">
                        <span style="color: var(--on-surface-variant);">Nội dung CK</span>
                        <span class="fw-bold" style="color: var(--primary);" id="modalTransferContent">—</span>
                        <button class="btn-icon ms-1" id="btnCopyContent" onclick="copyTransferContent()" title="Sao chép">
                            <span class="material-symbols-outlined" style="font-size: 15px;">content_copy</span>
                        </button>
                    </div>
                </div>

                <!-- Cảnh báo nội dung chuyển khoản -->
                <div class="rounded-3 p-3 mb-3 d-flex align-items-start gap-2" style="background: var(--warning-container); border: 1px solid rgba(217,119,6,0.25);">
                    <span class="material-symbols-outlined flex-shrink-0" style="font-size: 18px; color: var(--warning);">warning</span>
                    <p class="mb-0" style="font-size: 12.5px; color: #92400e; line-height: 1.5;">
                        <strong>Quan trọng:</strong> Vui lòng nhập chính xác nội dung chuyển khoản ở trên. Nếu sai nội dung, hệ thống không thể tự động xác nhận thanh toán.
                    </p>
                </div>

                <!-- Trạng thái chờ thanh toán -->
                <div id="pollingStatus" class="text-center py-2">
                    <div class="d-flex align-items-center justify-content-center gap-2">
                        <div class="spinner-border spinner-border-sm" role="status" style="color: var(--primary); width: 16px; height: 16px; border-width: 2px;">
                            <span class="visually-hidden">Đang chờ...</span>
                        </div>
                        <span style="font-size: 13px; color: var(--on-surface-variant);">Đang chờ xác nhận thanh toán...</span>
                    </div>
                </div>

                <!-- Trạng thái thành công (ẩn mặc định) -->
                <div id="paymentSuccess" class="text-center py-3" style="display: none;">
                    <div class="mb-2">
                        <span class="material-symbols-outlined" style="font-size: 52px; color: var(--success);">check_circle</span>
                    </div>
                    <h5 class="fw-bold mb-1" style="color: var(--success);">Thanh toán thành công!</h5>
                    <p style="font-size: 13px; color: var(--on-surface-variant);" class="mb-0">Khoản phạt đã được thanh toán. Trang sẽ tự động tải lại...</p>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="modal-footer border-0 px-4 pb-4 pt-0">
                <button type="button" class="btn btn-secondary-custom w-100 rounded-3 fw-bold" data-bs-dismiss="modal">
                    Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ═══════════════════════════════════════════════════
   FINES PAGE — VietQR Modal & AJAX Polling
═══════════════════════════════════════════════════ */
var pollingInterval = null;
var qrModal = null;

function openQrModal(btn) {
    var paymentId = btn.getAttribute('data-payment-id');
    var amount = btn.getAttribute('data-fine-amount');
    var reason = btn.getAttribute('data-fine-reason');
    var bookTitle = btn.getAttribute('data-book-title');

    /* Sinh URL VietQR động từ SePay */
    var acc = '${sepayAccountNumber}';
    var bank = '${sepayBankCode}';
    var transferContent = 'LMSPF' + paymentId;
    var qrUrl = 'https://qr.sepay.vn/img?acc=' + acc
              + '&bank=' + bank
              + '&amount=' + Math.round(amount)
              + '&des=' + encodeURIComponent(transferContent)
              + '&template=compact';

    /* Cập nhật Modal */
    document.getElementById('qrCodeImage').src = qrUrl;
    document.getElementById('qrCodeImage').style.opacity = '1';
    document.getElementById('qrError').classList.remove('d-flex');
    document.getElementById('qrError').classList.add('d-none');

    document.getElementById('modalAmount').textContent =
        Number(amount).toLocaleString('vi-VN') + ' đ';
    document.getElementById('modalTransferContent').textContent = transferContent;

    /* Reset trạng thái */
    document.getElementById('pollingStatus').style.display = 'block';
    document.getElementById('paymentSuccess').style.display = 'none';

    /* Mở Modal */
    var modalEl = document.getElementById('qrPaymentModal');
    qrModal = new bootstrap.Modal(modalEl);
    qrModal.show();

    /* Bắt đầu AJAX Polling mỗi 3 giây */
    startPolling(paymentId);

    /* Dừng polling khi đóng modal */
    modalEl.addEventListener('hidden.bs.modal', function handler() {
        stopPolling();
        modalEl.removeEventListener('hidden.bs.modal', handler);
    });
}

function startPolling(paymentId) {
    stopPolling();
    pollingInterval = setInterval(function() {
        fetch('${pageContext.request.contextPath}/api/payment-status?paymentId=' + paymentId)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.status === 'completed') {
                    stopPolling();
                    showPaymentSuccess();
                }
            })
            .catch(function(err) {
                console.warn('Polling error:', err);
            });
    }, 3000);
}

function stopPolling() {
    if (pollingInterval) {
        clearInterval(pollingInterval);
        pollingInterval = null;
    }
}

function showPaymentSuccess() {
    document.getElementById('pollingStatus').style.display = 'none';
    document.getElementById('paymentSuccess').style.display = 'block';

    /* Tự động tải lại trang sau 2.5 giây */
    setTimeout(function() {
        if (qrModal) qrModal.hide();
        window.location.reload();
    }, 2500);
}

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        showCopyToast('Đã sao chép!');
    });
}

function copyTransferContent() {
    var content = document.getElementById('modalTransferContent').textContent;
    navigator.clipboard.writeText(content).then(function() {
        showCopyToast('Đã sao chép nội dung chuyển khoản!');
    });
}

function showCopyToast(msg) {
    /* Tạo toast notification nhỏ */
    var toast = document.createElement('div');
    toast.textContent = msg;
    toast.style.cssText = 'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);'
        + 'background:var(--inverse-surface);color:var(--inverse-on-surface);'
        + 'padding:8px 20px;border-radius:999px;font-size:13px;font-weight:600;'
        + 'z-index:9999;box-shadow:var(--shadow-lg);animation:fadeInUp 0.3s ease;';
    document.body.appendChild(toast);
    setTimeout(function() { toast.remove(); }, 2000);
}
</script>

</body>
</html>
