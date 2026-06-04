<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Admin --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column"
       style="width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant);
              overflow-y: auto; z-index: 60; padding: 0;">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/"
       class="text-decoration-none d-flex align-items-center gap-2 px-4"
       style="min-height: 64px; border-bottom: 1px solid var(--outline-variant);
              background: var(--surface-container-lowest);">
        <span class="material-symbols-outlined"
              style="color: var(--primary); font-size: 24px;
                     font-variation-settings: 'FILL' 1;">local_library</span>
        <div>
            <p class="fw-bold mb-0 text-primary-custom" style="font-size: 15px; line-height: 1.2;">Library Portal</p>
            <p class="text-on-surface-variant mb-0"
               style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">System Administration</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 py-3 d-flex flex-column gap-0" aria-label="Admin navigation">

        <!-- Overview -->
        <div class="px-3 mb-1">
            <p class="text-on-surface-variant fw-bold text-uppercase mb-1 px-2"
               style="font-size: 10px; letter-spacing: 0.15em; margin-top: 4px;">Overview</p>
            <a class="sidebar-link" id="nav-dashboard"
               href="${pageContext.request.contextPath}/admin/dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Dashboard</span>
            </a>
        </div>

        <!-- Users & Access -->
        <div class="px-3 mb-1">
            <p class="text-on-surface-variant fw-bold text-uppercase mb-1 px-2"
               style="font-size: 10px; letter-spacing: 0.15em; margin-top: 8px;">Users &amp; Access</p>
            <a class="sidebar-link" id="nav-user-management" href="${pageContext.request.contextPath}/admin/user-list.jsp">
                <span class="material-symbols-outlined">group</span>
                <span>User Management</span>
            </a>
            <a class="sidebar-link" id="nav-role-assignment" href="#">
                <span class="material-symbols-outlined">verified_user</span>
                <span>Role Assignment</span>
            </a>
            <a class="sidebar-link" id="nav-security" href="#">
                <span class="material-symbols-outlined">security</span>
                <span>Security</span>
            </a>
        </div>

        <!-- System Config -->
        <div class="px-3 mb-1">
            <p class="text-on-surface-variant fw-bold text-uppercase mb-1 px-2"
               style="font-size: 10px; letter-spacing: 0.15em; margin-top: 8px;">System Config</p>
            <a class="sidebar-link" id="nav-config-list"
               href="${pageContext.request.contextPath}/admin/config-list.jsp">
                <span class="material-symbols-outlined">settings</span>
                <span>Configurations</span>
            </a>
            <a class="sidebar-link sidebar-sublink" id="nav-config-edit"
               href="${pageContext.request.contextPath}/admin/config-edit.jsp"
               style="padding-left: 42px; font-size: 13px;">
                <span class="material-symbols-outlined" style="font-size: 17px;">tune</span>
                <span>Edit Parameter</span>
            </a>
        </div>

        <!-- Audit & Monitoring -->
        <div class="px-3 mb-1">
            <p class="text-on-surface-variant fw-bold text-uppercase mb-1 px-2"
               style="font-size: 10px; letter-spacing: 0.15em; margin-top: 8px;">Audit &amp; Monitoring</p>
            <a class="sidebar-link" id="nav-audit-logs"
               href="${pageContext.request.contextPath}/admin/audit-logs.jsp">
                <span class="material-symbols-outlined">receipt_long</span>
                <span>Audit Logs</span>
            </a>
            <a class="sidebar-link sidebar-sublink" id="nav-audit-detail"
               href="${pageContext.request.contextPath}/admin/audit-detail.jsp"
               style="padding-left: 42px; font-size: 13px;">
                <span class="material-symbols-outlined" style="font-size: 17px;">manage_search</span>
                <span>Log Detail</span>
            </a>
        </div>

        <!-- Account -->
        <div class="px-3 mb-1">
            <p class="text-on-surface-variant fw-bold text-uppercase mb-1 px-2"
               style="font-size: 10px; letter-spacing: 0.15em; margin-top: 8px;">Account</p>
            <a class="sidebar-link" id="nav-profile"
               href="${pageContext.request.contextPath}/admin/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>My Profile</span>
            </a>
        </div>

    </nav>

    <!-- ── Footer: System status ── -->
    <div style="border-top: 1px solid var(--outline-variant); padding: 14px 16px 16px;">
        <a class="sidebar-link mb-2" href="#">
            <span class="material-symbols-outlined">help</span>
            <span>Help Center</span>
        </a>
        <div class="p-3 rounded-3" style="background-color: var(--surface-container-high);">
            <p class="fw-bold mb-1 text-primary-custom" style="font-size: 11px;">System Status</p>
            <div class="d-flex align-items-center gap-2">
                <span class="animate-pulse rounded-circle d-inline-block"
                      style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Database Online</span>
            </div>
        </div>
    </div>

</aside>

<style>
    /* Sub-link: hidden by default, shown when parent section active */
    .sidebar-sublink {
        display: none !important;
        color: var(--on-surface-variant);
        opacity: 0.85;
    }
    .sidebar-sublink.show { display: flex !important; }
    .sidebar-sublink.active.show {
        background-color: rgba(255, 182, 144, 0.2);
        color: var(--primary);
        border-right-color: var(--primary);
    }
</style>

<script>
/* ── Admin Sidebar: auto active state based on URL ── */
(function () {
    var path = window.location.pathname;

    /* id → URL keyword to match */
    var navMap = {
        'nav-dashboard':       '/admin/dashboard',
        'nav-user-management': '/admin/user',
        'nav-role-assignment': '/admin/role',
        'nav-security':        '/admin/security',
        'nav-config-list':     'config-list',
        'nav-config-edit':     'config-edit',
        'nav-audit-logs':      'audit-logs',
        'nav-audit-detail':    'audit-detail',
        'nav-profile':         '/admin/profile'
    };

    /* Clear all */
    document.querySelectorAll('aside .sidebar-link').forEach(function (l) {
        l.classList.remove('active');
    });

    var matched = false;
    Object.keys(navMap).forEach(function (id) {
        var el = document.getElementById(id);
        if (!el) return;
        if (path.indexOf(navMap[id]) !== -1) {
            el.classList.add('active');
            matched = true;

            /* Reveal sub-links when a parent group page is active */
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
