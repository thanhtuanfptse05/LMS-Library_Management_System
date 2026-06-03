<%-- Fragment: _header.jsp — Fixed top navigation bar for Library Manager --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="fixed-top bg-white shadow-sm" style="height: 64px; border-bottom: 1px solid var(--outline-variant);">
    <div class="h-100 d-flex align-items-center justify-content-between px-4" style="margin-left: 256px;">

        <!-- Left: Title -->
        <div class="d-flex align-items-center gap-4">
            <h1 class="h5 fw-bold mb-0 text-primary-custom">Library Manager</h1>
            <div class="d-none d-md-flex gap-4 ms-2">
                <a href="${pageContext.request.contextPath}/manager/dashboard"
                   style="font-size: 13px; color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 2px; text-decoration: none; font-weight: 600;">Overview</a>
                <a href="#" style="font-size: 13px; color: var(--on-surface-variant); text-decoration: none; font-weight: 600;">Reports</a>
                <a href="#" style="font-size: 13px; color: var(--on-surface-variant); text-decoration: none; font-weight: 600;">Announcements</a>
            </div>
        </div>

        <!-- Right: Search + Notifications + User -->
        <div class="d-flex align-items-center gap-3">
            <div class="d-none d-md-block header-search-wrapper">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">search</span>
                <input class="header-search-input" placeholder="Search reports, staff..." type="text" aria-label="Search reports or staff" />
            </div>
            <button class="btn p-2 rounded-circle border-0 position-relative" style="background: transparent;" aria-label="Notifications">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <span class="notif-dot"></span>
            </button>
            <a href="${pageContext.request.contextPath}/manager/profile" class="d-flex align-items-center gap-2 ps-3 text-decoration-none text-reset" style="border-left: 1px solid var(--outline-variant);" title="View Profile">
                <div class="avatar" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed-variant);">MG</div>
                <div class="d-none d-sm-block">
                    <p class="mb-0 fw-bold lh-sm" style="font-size: 13px;">
                        <c:out value="${sessionScope.email}" default="Manager"/>
                    </p>
                    <p class="mb-0 text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.1em;">
                        <c:out value="${sessionScope.role}" default="MANAGER"/>
                    </p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn p-2 rounded-circle border-0 ms-1"
               style="background: transparent; color: var(--on-surface-variant);" title="Sign out">
                <span class="material-symbols-outlined" style="font-size: 20px;">logout</span>
            </a>
        </div>
    </div>
</header>
