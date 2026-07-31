<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Admin --%>
<!-- ════════════════ DESKTOP SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column lms-sidebar sidebar-layout">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Quản trị Hệ thống</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Admin navigation">

        <!-- Tổng quan -->
        <p class="sidebar-section-label">Tổng quan</p>
        <a class="sidebar-link nav-dash-link" id="nav-dashboard" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link nav-analytics-link" id="nav-analytics" href="${pageContext.request.contextPath}/admin/analytics">
            <span class="material-symbols-outlined">analytics</span>
            <span>Phân tích &amp; Thống kê</span>
        </a>

        <!-- Người dùng -->
        <p class="sidebar-section-label">Người dùng</p>
        <a class="sidebar-link nav-user-link" id="nav-user-management" href="${pageContext.request.contextPath}/admin/user">
            <span class="material-symbols-outlined">group</span>
            <span>Quản lý Người dùng</span>
        </a>

        <!-- Quản lý Thư viện -->
        <p class="sidebar-section-label">Quản lý Thư viện</p>
        <a class="sidebar-link nav-config-link" id="nav-config-list" href="${pageContext.request.contextPath}/admin/system-config">
            <span class="material-symbols-outlined">settings</span>
            <span>Cấu hình Hệ thống</span>
        </a>
        <a class="sidebar-link nav-payment-link" id="nav-payment-config" href="${pageContext.request.contextPath}/admin/payment-config">
            <span class="material-symbols-outlined">payments</span>
            <span>Cấu hình Thanh toán</span>
        </a>
        <a class="sidebar-link nav-notif-link" id="nav-notifications" href="${pageContext.request.contextPath}/admin/notifications">
            <span class="material-symbols-outlined">campaign</span>
            <span>Quản lý Thông báo</span>
        </a>
        <a class="sidebar-link nav-email-link" id="nav-email-templates" href="${pageContext.request.contextPath}/admin/email-templates">
            <span class="material-symbols-outlined">mail</span>
            <span>Quản lý Mẫu Email</span>
        </a>

        <!-- Báo cáo & Giám sát -->
        <p class="sidebar-section-label">Báo cáo &amp; Giám sát</p>
        <a class="sidebar-link nav-report-link" id="nav-reports" href="${pageContext.request.contextPath}/admin/reports/dashboard">
            <span class="material-symbols-outlined">summarize</span>
            <span>Báo cáo Hệ thống</span>
        </a>
        <a class="sidebar-link nav-staff-link" id="nav-staff-performance" href="${pageContext.request.contextPath}/admin/staff-performance">
            <span class="material-symbols-outlined">trending_up</span>
            <span>Hiệu suất Nhân viên</span>
        </a>
        <a class="sidebar-link nav-audit-link" id="nav-audit-logs" href="${pageContext.request.contextPath}/admin/audit-log">
            <span class="material-symbols-outlined">receipt_long</span>
            <span>Nhật ký Kiểm toán</span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link nav-profile-link" id="nav-profile" href="${pageContext.request.contextPath}/admin/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>

    </nav>

    <!-- ── Footer: Trạng thái hệ thống ── -->
    <div class="px-3 pb-3">
        <a class="sidebar-link mb-2" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">help</span>
            <span>Trung tâm Trợ giúp</span>
        </a>
        <div class="sidebar-status-card">
            <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">monitor_heart</span>
                Trạng thái Hệ thống
            </p>
            <div class="d-flex align-items-center gap-2">
                <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                      style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Cơ sở dữ liệu hoạt động</span>
            </div>
        </div>
    </div>

</aside>

<!-- ════════════════ MOBILE OFFCANVAS SIDEBAR ════════════════ -->
<div class="offcanvas offcanvas-start lms-sidebar d-lg-none" tabindex="-1" id="adminSidebarOffcanvas" aria-labelledby="adminSidebarOffcanvasLabel" style="width: 280px;">
    <div class="offcanvas-header sidebar-brand border-bottom py-3">
        <div class="d-flex align-items-center gap-2">
            <div class="sidebar-brand-icon">
                <span class="material-symbols-outlined">local_library</span>
            </div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-name m-0">LMS Thư viện</p>
                <p class="sidebar-brand-role m-0">Quản trị Hệ thống</p>
            </div>
        </div>
        <button type="button" class="btn-close text-reset ms-auto" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
    </div>
    <div class="offcanvas-body p-0 d-flex flex-column">
        <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Admin mobile navigation">

            <p class="sidebar-section-label">Tổng quan</p>
            <a class="sidebar-link nav-dash-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Bảng điều khiển</span>
            </a>
            <a class="sidebar-link nav-analytics-link" href="${pageContext.request.contextPath}/admin/analytics">
                <span class="material-symbols-outlined">analytics</span>
                <span>Phân tích &amp; Thống kê</span>
            </a>

            <p class="sidebar-section-label">Người dùng</p>
            <a class="sidebar-link nav-user-link" href="${pageContext.request.contextPath}/admin/user">
                <span class="material-symbols-outlined">group</span>
                <span>Quản lý Người dùng</span>
            </a>

            <p class="sidebar-section-label">Quản lý Thư viện</p>
            <a class="sidebar-link nav-config-link" href="${pageContext.request.contextPath}/admin/system-config">
                <span class="material-symbols-outlined">settings</span>
                <span>Cấu hình Hệ thống</span>
            </a>
            <a class="sidebar-link nav-payment-link" href="${pageContext.request.contextPath}/admin/payment-config">
                <span class="material-symbols-outlined">payments</span>
                <span>Cấu hình Thanh toán</span>
            </a>
            <a class="sidebar-link nav-notif-link" href="${pageContext.request.contextPath}/admin/notifications">
                <span class="material-symbols-outlined">campaign</span>
                <span>Quản lý Thông báo</span>
            </a>
            <a class="sidebar-link nav-email-link" href="${pageContext.request.contextPath}/admin/email-templates">
                <span class="material-symbols-outlined">mail</span>
                <span>Quản lý Mẫu Email</span>
            </a>

            <p class="sidebar-section-label">Báo cáo &amp; Giám sát</p>
            <a class="sidebar-link nav-report-link" href="${pageContext.request.contextPath}/admin/reports/dashboard">
                <span class="material-symbols-outlined">summarize</span>
                <span>Báo cáo Hệ thống</span>
            </a>
            <a class="sidebar-link nav-staff-link" href="${pageContext.request.contextPath}/admin/staff-performance">
                <span class="material-symbols-outlined">trending_up</span>
                <span>Hiệu suất Nhân viên</span>
            </a>
            <a class="sidebar-link nav-audit-link" href="${pageContext.request.contextPath}/admin/audit-log">
                <span class="material-symbols-outlined">receipt_long</span>
                <span>Nhật ký Kiểm toán</span>
            </a>

            <p class="sidebar-section-label">Tài khoản</p>
            <a class="sidebar-link nav-profile-link" href="${pageContext.request.contextPath}/admin/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>Hồ sơ của tôi</span>
            </a>

        </nav>

        <div class="px-3 pb-3">
            <a class="sidebar-link mb-2" href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">help</span>
                <span>Trung tâm Trợ giúp</span>
            </a>
            <div class="sidebar-status-card">
                <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">monitor_heart</span>
                    Trạng thái Hệ thống
                </p>
                <div class="d-flex align-items-center gap-2">
                    <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                          style="width: 8px; height: 8px; background: #10b981;"></span>
                    <span style="font-size: 12px; color: var(--on-surface-variant);">Cơ sở dữ liệu hoạt động</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/* Admin Sidebar: auto active state dựa theo URL */
(function () {
    var path = window.location.pathname;
    document.querySelectorAll('.sidebar-link').forEach(function(l) { l.classList.remove('active'); });

    function setActive(selector) {
        document.querySelectorAll(selector).forEach(function(el) { el.classList.add('active'); });
    }

    if (path.indexOf('/admin/user') !== -1) {
        setActive('.nav-user-link');
    } else if (path.indexOf('/admin/system-config') !== -1) {
        setActive('.nav-config-link');
    } else if (path.indexOf('/admin/payment-config') !== -1) {
        setActive('.nav-payment-link');
    } else if (path.indexOf('/admin/notifications') !== -1) {
        setActive('.nav-notif-link');
    } else if (path.indexOf('/admin/email-templates') !== -1) {
        setActive('.nav-email-link');
    } else if (path.indexOf('/admin/reports') !== -1) {
        setActive('.nav-report-link');
    } else if (path.indexOf('/admin/staff-performance') !== -1) {
        setActive('.nav-staff-link');
    } else if (path.indexOf('/admin/audit-log') !== -1) {
        setActive('.nav-audit-link');
    } else if (path.indexOf('/admin/profile') !== -1) {
        setActive('.nav-profile-link');
    } else if (path.indexOf('/admin/analytics') !== -1) {
        setActive('.nav-analytics-link');
    } else {
        setActive('.nav-dash-link');
    }
})();
</script>
