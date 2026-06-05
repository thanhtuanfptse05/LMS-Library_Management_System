<%-- Fragment: _sidebar.jsp — Left sidebar navigation --%>
<!-- ─── SIDEBAR ─── -->
<aside class="d-none d-lg-flex flex-column bg-surface-container-low gap-4 p-4"
       style="width: 256px; flex-shrink: 0; border-right: 1px solid var(--outline-variant); overflow-y: auto;">

    <!-- Library Access -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">Truy cập Thư viện</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/dashboard">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">home</span>
                <span>Trang chủ</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/loans">
                <span class="material-symbols-outlined">book</span>
                <span>Sách tôi mượn</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/reservations">
                <span class="material-symbols-outlined">bookmark</span>
                <span>Đặt trước</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/my-fines.jsp">
                <span class="material-symbols-outlined">payments</span>
                <span>Lịch sử nộp phạt</span>
            </a>
            <a class="sidebar-link active"
               href="${pageContext.request.contextPath}/student/notifications.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">notifications</span>
                <span>Thông báo</span>
                <span style="margin-left: auto; min-width: 18px; height: 18px; border-radius: 999px;
                             background-color: var(--primary); color: #fff;
                             font-size: 10px; font-weight: 700;
                             display: inline-flex; align-items: center; justify-content: center; padding: 0 5px;">3</span>
            </a>
        </div>
    </div>

    <!-- Account -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">Tài khoản</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>Hồ sơ của tôi</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/forgot-password">
                <span class="material-symbols-outlined">security</span>
                <span>Cài đặt Bảo mật</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">contact_support</span>
                <span>Trung tâm Trợ giúp</span>
            </a>
        </div>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(249, 115, 22, 0.1); border: 1px solid rgba(249, 115, 22, 0.2);">
        <p class="fw-bold text-primary-custom mb-1 small">Cần hỗ trợ?</p>
        <p class="text-on-surface-variant mb-3" style="font-size: 11px;">
            Liên hệ thủ thư để được trợ giúp nghiên cứu hoặc báo cáo sự cố.
        </p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3">
            Báo cáo sự cố
        </a>
    </div>
</aside>
