<%-- desk-checkin.jsp — Trang Nhận Sách (Check-in) tại quầy thủ thư --%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body>

    <%-- ════ SIDEBAR ════ --%>
    <jsp:include page="fragments/_sidebar.jsp" />

    <%-- ════ MAIN WRAPPER ════ --%>
    <div class="main-content-layout d-flex flex-column">

        <%-- ════ HEADER ════ --%>
        <jsp:include page="fragments/_header.jsp" />

        <%-- ════ CONTENT ════ --%>
        <main class="main-wrapper container-fluid px-4 py-4">

            <%-- Breadcrumb --%>
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/librarian/dashboard"
                           class="text-primary-custom text-decoration-none">Bảng điều khiển</a>
                    </li>
                    <li class="breadcrumb-item active text-on-surface-variant" aria-current="page">Nhận sách</li>
                </ol>
            </nav>

            <%-- Page Title --%>
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="rounded-3 d-flex align-items-center justify-content-center"
                     style="width:48px;height:48px;background-color:rgba(0,99,152,0.1);">
                    <span class="material-symbols-outlined" style="font-size:24px;color:var(--tertiary);">assignment_return</span>
                </div>
                <div>
                    <h2 class="fw-bold mb-0" style="font-size:20px;color:var(--on-surface);">Nhận Sách Trả từ Độc giả</h2>
                    <p class="mb-0 small text-on-surface-variant">Xác nhận tình trạng vật lý và cập nhật trạng thái kho</p>
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
                            Thông tin Nhận Sách
                        </h3>
                        <p class="small text-on-surface-variant mb-4">
                            Quét mã vạch và ghi nhận tình trạng vật lý của bản sao sách được trả.
                        </p>

                        <form id="formCheckIn"
                              action="${pageContext.request.contextPath}/librarian/checkin"
                              method="POST" novalidate>

                            <%-- Mã vạch sách --%>
                            <div class="mb-3">
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
                                </div>
                                <div class="form-text text-on-surface-variant">
                                    Đặt con trỏ vào ô này và quét barcode từ sách được trả.
                                </div>
                            </div>

                            <%-- Tình trạng vật lý --%>
                            <div class="mb-4">
                                <label class="form-label fw-bold small text-on-surface-variant">
                                    Tình Trạng Vật Lý Khi Trả
                                    <span class="text-danger">*</span>
                                </label>

                                <%-- Condition Cards --%>
                                <div class="d-flex flex-column gap-2">

                                    <%-- Tốt --%>
                                    <label for="conditionGood"
                                           class="condition-card d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer"
                                           style="border:2px solid var(--outline-variant);cursor:pointer;transition:all 0.15s ease;">
                                        <input type="radio"
                                               id="conditionGood"
                                               name="condition"
                                               value="good"
                                               class="form-check-input mt-0"
                                               checked
                                               style="width:18px;height:18px;accent-color:var(--primary);">
                                        <div class="rounded-2 d-flex align-items-center justify-content-center"
                                             style="width:36px;height:36px;background:#d1fae5;flex-shrink:0;">
                                            <span class="material-symbols-outlined" style="font-size:18px;color:#059669;">check_circle</span>
                                        </div>
                                        <div>
                                            <p class="fw-bold mb-0 small">Tốt (Bình thường)</p>
                                            <p class="text-on-surface-variant mb-0" style="font-size:12px;">Sách còn nguyên vẹn, không có hư hỏng đáng kể.</p>
                                        </div>
                                    </label>

                                    <%-- Hỏng --%>
                                    <label for="conditionDamaged"
                                           class="condition-card d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer"
                                           style="border:2px solid var(--outline-variant);cursor:pointer;transition:all 0.15s ease;">
                                        <input type="radio"
                                               id="conditionDamaged"
                                               name="condition"
                                               value="damaged"
                                               class="form-check-input mt-0"
                                               style="width:18px;height:18px;accent-color:var(--primary);">
                                        <div class="rounded-2 d-flex align-items-center justify-content-center"
                                             style="width:36px;height:36px;background:#fef3c7;flex-shrink:0;">
                                            <span class="material-symbols-outlined" style="font-size:18px;color:#d97706;">warning</span>
                                        </div>
                                        <div>
                                            <p class="fw-bold mb-0 small">Hỏng (Bị hư hại)</p>
                                            <p class="text-on-surface-variant mb-0" style="font-size:12px;">Sách bị rách, ố, ướt... Độc giả phải đền bù 150% giá sách.</p>
                                        </div>
                                    </label>

                                    <%-- Mất --%>
                                    <label for="conditionLost"
                                           class="condition-card d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer"
                                           style="border:2px solid var(--outline-variant);cursor:pointer;transition:all 0.15s ease;">
                                        <input type="radio"
                                               id="conditionLost"
                                               name="condition"
                                               value="lost"
                                               class="form-check-input mt-0"
                                               style="width:18px;height:18px;accent-color:var(--primary);">
                                        <div class="rounded-2 d-flex align-items-center justify-content-center"
                                             style="width:36px;height:36px;background:#fee2e2;flex-shrink:0;">
                                            <span class="material-symbols-outlined" style="font-size:18px;color:#ef4444;">report</span>
                                        </div>
                                        <div>
                                            <p class="fw-bold mb-0 small">Mất (Không có sách)</p>
                                            <p class="text-on-surface-variant mb-0" style="font-size:12px;">Sách bị mất hoàn toàn. Độc giả phải đền bù 200% giá sách.</p>
                                        </div>
                                    </label>

                                </div>
                            </div>

                            <%-- Cảnh báo khi chọn Hỏng/Mất --%>
                            <div id="warningDamagedLost" class="rounded-3 p-3 mb-4 small d-none"
                                 style="background-color:#fff7ed;border:1px solid #fed7aa;">
                                <p class="fw-bold mb-1" style="color:#c2410c;">
                                    <span class="material-symbols-outlined" style="font-size:15px;vertical-align:middle;">gpp_maybe</span>
                                    Hành động sẽ kích hoạt tự động
                                </p>
                                <ul class="mb-0 ps-3" style="color:#9a3412;line-height:1.8;">
                                    <li>Tạo khoản phạt đền bù và ghi nhận vào hệ thống.</li>
                                    <li>Tài khoản độc giả sẽ bị <strong>khóa tạm thời</strong> cho đến khi thanh toán.</li>
                                    <li>Số lượng kho sách sẽ giảm 1 đơn vị.</li>
                                </ul>
                            </div>

                            <%-- Nút submit --%>
                            <div class="d-flex gap-2">
                                <button type="submit"
                                        id="btnCheckIn"
                                        class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                    <span class="material-symbols-outlined me-1" style="font-size:18px;vertical-align:middle;">task_alt</span>
                                    Xác Nhận Nhận Sách
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
                        <a href="${pageContext.request.contextPath}/librarian/checkout"
                           class="btn btn-sm rounded-3 fw-bold text-decoration-none"
                           style="background:var(--surface-container-low);color:var(--on-surface-variant);border:1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined me-1" style="font-size:14px;vertical-align:middle;">published_with_changes</span>
                            Giao Sách
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

        </main>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hiển thị cảnh báo khi chọn Hỏng hoặc Mất
        const radios = document.querySelectorAll('input[name="condition"]');
        const warning = document.getElementById('warningDamagedLost');
        const cards = document.querySelectorAll('.condition-card');

        function updateUI() {
            const selected = document.querySelector('input[name="condition"]:checked');
            const val = selected ? selected.value : 'good';

            // Hiện/ẩn cảnh báo
            if (val === 'damaged' || val === 'lost') {
                warning.classList.remove('d-none');
            } else {
                warning.classList.add('d-none');
            }

            // Highlight card đang chọn
            cards.forEach(card => {
                const radio = card.querySelector('input[type="radio"]');
                if (radio && radio.checked) {
                    card.style.borderColor = 'var(--primary)';
                    card.style.backgroundColor = 'rgba(157,67,0,0.04)';
                } else {
                    card.style.borderColor = 'var(--outline-variant)';
                    card.style.backgroundColor = '';
                }
            });
        }

        radios.forEach(r => r.addEventListener('change', updateUI));
        document.addEventListener('DOMContentLoaded', updateUI);
    </script>
</body>
</html>
