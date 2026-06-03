<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Admin --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column gap-4 p-4"
       style="width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <div>
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Library Portal</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">System Administration</p>
    </div>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Dashboard</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">group</span><span>User Management</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">verified_user</span><span>Role Assignment</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">security</span><span>Security</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">receipt_long</span><span>Audit Logs</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">settings</span><span>Configurations</span>
        </a>
    </div>

    <!-- Footer: System status + Help -->
    <div class="mt-auto d-flex flex-column gap-2" style="border-top: 1px solid var(--outline-variant); padding-top: 1rem;">
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">help</span><span>Help Center</span>
        </a>
        <!-- System Status -->
        <div class="p-3 rounded-3" style="background-color: var(--surface-container-high);">
            <p class="fw-bold mb-1 text-primary-custom" style="font-size: 11px;">System Status</p>
            <div class="d-flex align-items-center gap-1">
                <span class="animate-pulse rounded-circle d-inline-block" style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Database Online</span>
            </div>
        </div>
    </div>
</aside>
