<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Librarian --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column gap-4 p-4"
       style="width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <div>
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Library Portal</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">Circulation Desk</p>
    </div>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.15em;">Circulation</p>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/librarian/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Dashboard</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">published_with_changes</span><span>Issue / Return</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">bookmark_add</span><span>Reservations</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">payments</span><span>Fines Collection</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Catalog</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">book</span><span>Book Records</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">group</span><span>Member Directory</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">inventory</span><span>Inventory</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Account</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">manage_accounts</span><span>My Profile</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span><span>Help</span>
        </a>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(249, 115, 22, 0.08); border: 1px solid rgba(249, 115, 22, 0.2);">
        <p class="fw-bold text-primary-custom mb-1 small">Overdue Alert</p>
        <p class="text-on-surface-variant mb-2" style="font-size: 11px;">
            3 loans are critically overdue. Send penalty notices.
        </p>
        <a href="#" class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3">
            Send Notices
        </a>
    </div>
</aside>
