<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Admin --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
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
        <a class="sidebar-link" id="nav-dashboard" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>

        <!-- Người dùng & Phân quyền -->
        <p class="sidebar-section-label">Người dùng &amp; Phân quyền</p>
        <a class="sidebar-link" id="nav-user-management" href="${pageContext.request.contextPath}/admin/user">
            <span class="material-symbols-outlined">group</span>
            <span>Quản lý Người dùng</span>
        </a>
        <a class="sidebar-link" id="nav-role-assignment" href="#">
            <span class="material-symbols-outlined">verified_user</span>
            <span>Phân quyền</span>
        </a>
        <a class="sidebar-link" id="nav-security" href="#">
            <span class="material-symbols-outlined">security</span>
            <span>Bảo mật</span>
        </a>

        <!-- Cấu hình Hệ thống -->
        <p class="sidebar-section-label">Cấu hình Hệ thống</p>
        <a class="sidebar-link" id="nav-config-list" href="${pageContext.request.contextPath}/admin/system-config">
            <span class="material-symbols-outlined">settings</span>
            <span>Cấu hình</span>
        </a>
        <a class="sidebar-link sidebar-sublink" id="nav-config-edit" href="#"
           style="padding-left: 38px; font-size: 13px;">
            <span class="material-symbols-outlined" style="font-size: 17px;">tune</span>
            <span>Chỉnh sửa Tham số</span>
        </a>

        <!-- Kiểm toán & Giám sát -->
        <p class="sidebar-section-label">Kiểm toán &amp; Giám sát</p>
        <a class="sidebar-link" id="nav-audit-logs" href="#">
            <span class="material-symbols-outlined">receipt_long</span>
            <span>Nhật ký Kiểm toán</span>
        </a>
        <a class="sidebar-link sidebar-sublink" id="nav-audit-detail" href="#"
           style="padding-left: 38px; font-size: 13px;">
            <span class="material-symbols-outlined" style="font-size: 17px;">manage_search</span>
            <span>Chi tiết nhật ký</span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link" id="nav-profile" href="${pageContext.request.contextPath}/admin/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>

    </nav>

    <!-- ── Footer: Trạng thái hệ thống ── -->
    <div class="px-3 pb-3">
        <a class="sidebar-link mb-2" href="#">
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

<style>
    /* Admin sidebar sub-links */
    .sidebar-sublink {
        display: none !important;
        opacity: 0.85;
    }
    .sidebar-sublink.show { display: flex !important; }
</style>

<script>
/* Admin Sidebar: auto active state dựa theo URL */
(function () {
    var path = window.location.pathname;
    var navMap = {
        'nav-dashboard':       '/admin/dashboard',
        'nav-user-management': '/admin/user',
        'nav-role-assignment': '/admin/role',
        'nav-security':        '/admin/security',
        'nav-config-list':     '/admin/system-config',
        'nav-config-edit':     'config-edit',
        'nav-audit-logs':      'audit-logs',
        'nav-audit-detail':    'audit-detail',
        'nav-profile':         '/admin/profile'
    };

    document.querySelectorAll('aside .sidebar-link').forEach(function(l) { l.classList.remove('active'); });

    var matched = false;
    Object.keys(navMap).forEach(function(id) {
        var el = document.getElementById(id);
        if (!el) return;
        if (path.indexOf(navMap[id]) !== -1) {
            el.classList.add('active');
            matched = true;
            if (id === 'nav-config-list' || id === 'nav-config-edit') {
                var sub = document.getElementById('nav-config-edit');
                if (sub) sub.classList.add('show');
            }
            if (id === 'nav-audit-logs' || id === 'nav-audit-detail') {
                var subA = document.getElementById('nav-audit-detail');
                if (subA) subA.classList.add('show');
            }
        }
    });

    if (!matched) {
        var dash = document.getElementById('nav-dashboard');
        if (dash) dash.classList.add('active');
    }
})();
</script>
