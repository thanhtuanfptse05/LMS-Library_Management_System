<%-- desk-dashboard.jsp — Bảng điều khiển nghiệp vụ tại quầy của thủ thư (F6) --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<style>
    .status-badge {
        font-weight: 600;
        padding: 0.25rem 0.75rem;
        border-radius: 50rem;
        font-size: 0.75rem;
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
    }
    .status-active { background-color: #d1fae5; color: #065f46; }
    .status-locked { background-color: #fee2e2; color: #991b1b; }
    .list-section-header {
        border-bottom: 2px solid var(--outline-variant);
        padding-bottom: 0.5rem;
        margin-bottom: 1rem;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 700;
        color: var(--on-surface-variant);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .profile-card {
        background: linear-gradient(135deg, var(--surface-container-low) 0%, var(--surface-container-high) 100%);
        border: 1px solid var(--outline-variant);
    }
    /* CSS cho trang đã được loại bỏ style barcode scanner */
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
                            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="text-primary-custom text-decoration-none">Bảng điều khiển</a>
                        </li>
                        <li class="breadcrumb-item active text-on-surface-variant" aria-current="page">Quầy lưu thông</li>
                    </ol>
                </nav>

                <%-- Page Title --%>
                <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center"
                             style="width:48px;height:48px;background-color:rgba(157,67,0,0.1);">
                            <span class="material-symbols-outlined text-primary-custom" style="font-size:24px;">room_service</span>
                        </div>
                        <div>
                            <h2 class="fw-bold mb-0" style="font-size:20px;color:var(--on-surface);">Quầy Lưu Thông Trung Tâm</h2>
                            <p class="mb-0 small text-on-surface-variant">Tra cứu độc giả, mượn sách, nhận sách trả và duyệt thanh toán tiền mặt</p>
                        </div>
                    </div>
                </div>

                <%-- ════ FLASH MESSAGES ════ --%>
                <c:if test="${not empty requestScope.successMessage}">
                    <div class="alert alert-success d-flex align-items-center gap-2 mb-4 rounded-3" role="alert">
                        <span class="material-symbols-outlined" style="font-size:20px;">check_circle</span>
                        <div><c:out value="${requestScope.successMessage}" /></div>
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 mb-4 rounded-3" role="alert">
                        <span class="material-symbols-outlined" style="font-size:20px;">error</span>
                        <div><c:out value="${requestScope.errorMessage}" /></div>
                    </div>
                </c:if>

                <%-- ════ SEARCH AREA ════ --%>
                <div class="raised-card p-4 mb-4">
                    <form action="${pageContext.request.contextPath}/librarian/desk-dashboard" method="GET" class="row g-3 align-items-end">
                        <div class="col-12 col-md-8 col-lg-6">
                            <label for="memberCodeSearch" class="form-label fw-bold small text-on-surface-variant">
                                Mã Số Độc Giả (Student/Lecturer Code)
                            </label>
                            <div class="input-group">
                                <span class="input-group-text" style="background:var(--surface-container-low);border-color:var(--outline-variant);">
                                    <span class="material-symbols-outlined" style="font-size:18px;">search</span>
                                </span>
                                <input type="text" id="memberCodeSearch" name="memberCode" class="form-control"
                                       placeholder="Ví dụ: SE170123, GD12345..."
                                       value="${fn:escapeXml(requestScope.memberCode)}"
                                       required autofocus
                                       style="border-color:var(--outline-variant); border-top-right-radius: 0.375rem; border-bottom-right-radius: 0.375rem;">
                            </div>
                        </div>
                        <div class="col-12 col-md-4 col-lg-3">
                            <button type="submit" class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">
                                Tra Cứu Độc Giả
                            </button>
                        </div>
                    </form>
                </div>

                <%-- ════ MAIN DASHBOARD CONTENT (CHỈ HIỆN KHI ĐÃ TÌM KIẾM) ════ --%>
                <c:if test="${not empty requestScope.searchedUser}">
                    <div class="row g-4">

                        <%-- Fragment: Thẻ thông tin hồ sơ + Stats --%>
                        <jsp:include page="fragments/_desk-member-info.jsp" />

                        <%-- Fragment: 4 danh sách giao dịch --%>
                        <jsp:include page="fragments/_desk-transaction-lists.jsp" />

                        <%-- Fragment: 4 form thao tác nghiệp vụ --%>
                        <jsp:include page="fragments/_desk-action-forms.jsp" />

                    </div>
                </c:if>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tự động xóa khoảng trắng khỏi các ô nhập mã độc giả và barcode
        document.addEventListener('DOMContentLoaded', function () {
            const autoTrimInputs = ['memberCodeSearch', 'checkoutBarcode', 'checkinBarcode', 'reserveBookIdOrIsbn'];
            autoTrimInputs.forEach(id => {
                const inputEl = document.getElementById(id);
                if (inputEl) {
                    const cleanInput = function () {
                        inputEl.value = inputEl.value.replace(/\s+/g, '');
                    };
                    inputEl.addEventListener('input', cleanInput);
                    inputEl.addEventListener('change', cleanInput);
                    inputEl.addEventListener('blur', cleanInput);
                }
            });
        });

        // JS helpers để tự điền nhanh barcode khi click hành động ở danh sách
        function showActionForm(type) {
            // Ẩn tất cả các form
            ['Checkout', 'Checkin', 'Payment', 'Reserve'].forEach(t => {
                const f = document.getElementById('actionForm' + t);
                if (f) f.style.display = 'none';
            });

            // Clear targetBookId khi hiện form
            const targetBookIdInput = document.getElementById('checkoutTargetBookId');
            if (targetBookIdInput) targetBookIdInput.value = '';

            // Hiển thị form mong muốn
            const formId = 'actionForm' + type.charAt(0).toUpperCase() + type.slice(1);
            const targetForm = document.getElementById(formId);
            if (targetForm) {
                targetForm.style.display = 'block';
                targetForm.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

        function hideActionForm(type) {
            const formId = 'actionForm' + type.charAt(0).toUpperCase() + type.slice(1);
            const targetForm = document.getElementById(formId);
            if (targetForm) targetForm.style.display = 'none';
        }

        function fillCheckout(barcode, bookId) {
            showActionForm('checkout');
            const coInput = document.getElementById('checkoutBarcode');
            if (coInput) { coInput.value = barcode; coInput.focus(); }
            const targetBookIdInput = document.getElementById('checkoutTargetBookId');
            if (targetBookIdInput) targetBookIdInput.value = bookId || '';
        }

        function fillCheckin(barcode) {
            showActionForm('checkin');
            const ciInput = document.getElementById('checkinBarcode');
            if (ciInput) { ciInput.value = barcode; ciInput.focus(); }
        }
    </script>
</body>
</html>