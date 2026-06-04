<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Lecturer --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column gap-4 p-4"
       style="width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Library Portal</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">Academic Staff Access</p>
    </a>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.15em;">My Workspace</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Dashboard</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">library_books</span><span>My Loans</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">bookmark</span><span>Saved Lists</span>
        </a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/lecturer/notifications.jsp">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">notifications</span>
            <span>Notifications</span>
            <span style="margin-left: auto; min-width: 18px; height: 18px; border-radius: 999px;
                         background-color: var(--tertiary, #006398); color: #fff;
                         font-size: 10px; font-weight: 700;
                         display: inline-flex; align-items: center; justify-content: center; padding: 0 5px;">4</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Course Resources</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">menu_book</span><span>Course Books</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">article</span><span>Reading Lists</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">science</span><span>Research Materials</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Library</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-search.jsp">
            <span class="material-symbols-outlined">search</span><span>Search Catalog</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/profile">
            <span class="material-symbols-outlined">manage_accounts</span><span>My Profile</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span><span>Help</span>
        </a>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(0, 99, 152, 0.08); border: 1px solid rgba(0, 99, 152, 0.2);">
        <p class="fw-bold mb-1" style="color: var(--tertiary); font-size: 11px;">Research Support</p>
        <p class="text-on-surface-variant mb-2" style="font-size: 11px;">
            Need a specific journal or database? Contact our research librarian.
        </p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn w-100 btn-sm text-decoration-none d-block text-center rounded-3 fw-bold"
           style="background-color: var(--tertiary); color: white;">
            Contact Librarian
        </a>
    </div>
</aside>
