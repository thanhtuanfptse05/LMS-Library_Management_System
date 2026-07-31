<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    @keyframes rotation {
        from { transform: rotate(0deg); }
        to   { transform: rotate(360deg); }
    }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                <%-- Alert Messages --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined"
                              style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">check_circle</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined"
                              style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">error</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <%-- Section Header --%>
                <div class="page-header d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">
                            Sức khỏe Cơ sở dữ liệu
                        </h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">schedule</span>
                            Kiểm tra lần cuối: Vừa xong
                        </p>
                    </div>
                </div>

                <%-- Fragment: KPI Stats Grid --%>
                <jsp:include page="fragments/_admin-kpi-stats.jsp" />

                <%-- Main Split Layout --%>
                <div class="row g-4">

                    <%-- Fragment: LEFT 2/3 — User Accounts + Config + Maintenance --%>
                    <jsp:include page="fragments/_admin-left-panel.jsp" />

                    <%-- Fragment: RIGHT 1/3 — Security Audit Feed --%>
                    <jsp:include page="fragments/_admin-audit-feed.jsp" />

                </div>

            </div>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <%-- Form ẩn để thay đổi trạng thái nhanh từ Dashboard --%>
    <form id="quickToggleForm" action="${pageContext.request.contextPath}/admin/user/update"
          method="POST" style="display:none;">
        <input type="hidden" name="action" value="toggleStatus">
        <input type="hidden" name="userId" id="quickUserId">
        <input type="hidden" name="status" id="quickStatus">
        <input type="hidden" name="lockReason" id="quickLockReason">
    </form>

    <jsp:include page="fragments/_user_lock_modal.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hover effect on card header buttons
        document.querySelectorAll('.card-header-row a, .card-header-row button').forEach(function(el) {
            el.addEventListener('mouseenter', function() { this.style.transform = 'translateY(-1px)'; });
            el.addEventListener('mouseleave', function() { this.style.transform = ''; });
        });

        // Trigger Reservation Expiration AJAX (F5)
        const btnTrigger = document.getElementById('btn-trigger-expiration');
        const maintenanceMsg = document.getElementById('maintenance-msg');

        if (btnTrigger) {
            btnTrigger.addEventListener('click', function() {
                btnTrigger.disabled = true;
                btnTrigger.innerHTML = '<span class="material-symbols-outlined spin" style="font-size: 20px; animation: rotation 2s infinite linear;">sync</span> Đang xử lý...';
                maintenanceMsg.className = 'mt-3 p-3 rounded-2';

                fetch('${pageContext.request.contextPath}/admin/trigger-reservation-expiration', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                })
                .then(response => {
                    if (response.status === 403) throw new Error('Bạn không có quyền thực hiện hành động này.');
                    if (!response.ok) throw new Error('Lỗi hệ thống khi dọn dẹp.');
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        maintenanceMsg.classList.remove('d-none');
                        maintenanceMsg.classList.add('alert', 'alert-success');
                        maintenanceMsg.innerText = data.message;
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        throw new Error(data.message || 'Lỗi không xác định.');
                    }
                })
                .catch(err => {
                    maintenanceMsg.classList.remove('d-none');
                    maintenanceMsg.classList.add('alert', 'alert-danger');
                    maintenanceMsg.innerText = err.message;
                    btnTrigger.disabled = false;
                    btnTrigger.innerHTML = '<span class="material-symbols-outlined" style="font-size: 20px;">cleaning_services</span> Dọn dẹp Đặt trước Quá hạn (F5)';
                });
            });
        }

        // Trigger Overdue Processor AJAX (F9)
        const btnTriggerOverdue = document.getElementById('btn-trigger-overdue');

        if (btnTriggerOverdue) {
            btnTriggerOverdue.addEventListener('click', function() {
                btnTriggerOverdue.disabled = true;
                btnTriggerOverdue.innerHTML = '<span class="material-symbols-outlined spin" style="font-size: 20px; animation: rotation 2s infinite linear;">sync</span> Đang xử lý...';
                maintenanceMsg.className = 'mt-3 p-3 rounded-2';

                fetch('${pageContext.request.contextPath}/admin/trigger-overdue', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                })
                .then(response => {
                    if (response.status === 403) throw new Error('Bạn không có quyền thực hiện hành động này.');
                    if (!response.ok) throw new Error('Lỗi hệ thống khi quét quá hạn.');
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        maintenanceMsg.classList.remove('d-none');
                        maintenanceMsg.classList.add('alert', 'alert-success');
                        maintenanceMsg.innerText = data.message;
                        setTimeout(() => window.location.reload(), 2000);
                    } else {
                        throw new Error(data.message || 'Lỗi không xác định.');
                    }
                })
                .catch(err => {
                    maintenanceMsg.classList.remove('d-none');
                    maintenanceMsg.classList.add('alert', 'alert-danger');
                    maintenanceMsg.innerText = err.message;
                    btnTriggerOverdue.disabled = false;
                    btnTriggerOverdue.innerHTML = '<span class="material-symbols-outlined" style="font-size: 20px;">alarm_on</span> Quét Phạt & Khóa Quá Hạn (F9)';
                });
            });
        }

        // Xử lý Khóa/Mở khóa tài khoản nhanh từ Dashboard
        function quickLock(userId, fullName, email) {
            document.getElementById('lockModalUserId').value = userId;
            var userText = fullName ? fullName + ' (' + email + ')' : (email || 'ID: ' + userId);
            document.getElementById('lockModalUserText').textContent = userText;
            document.getElementById('lockModalReason').value = '';
            var charCount = document.getElementById('lockReasonCharCount');
            if (charCount) charCount.textContent = '0/50';
            var lockModal = new bootstrap.Modal(document.getElementById('lockUserModal'));
            lockModal.show();
        }

        function quickUnlock(userId) {
            if (confirm('Bạn có chắc chắn muốn mở khóa tài khoản này?')) {
                document.getElementById('quickUserId').value = userId;
                document.getElementById('quickStatus').value = 'active';
                document.getElementById('quickLockReason').value = '';
                document.getElementById('quickToggleForm').submit();
            }
        }
    </script>
</body>
</html>