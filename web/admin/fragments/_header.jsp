<%-- Fragment: _header.jsp — Fixed top navigation bar for Admin --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="fixed-top bg-white shadow-sm" style="height: 64px; border-bottom: 1px solid var(--outline-variant);">
    <div class="h-100 d-flex align-items-center justify-content-between px-4" style="margin-left: 256px;">

        <!-- Left: Title + Nav -->
        <div class="d-flex align-items-center gap-4">
            <h1 class="h5 fw-bold mb-0 text-primary-custom">System Admin Dashboard</h1>
            <div class="d-none d-md-flex gap-4 ms-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   style="font-size: 13px; color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 2px; text-decoration: none; font-weight: 600;">Live Overview</a>
                <a href="#" style="font-size: 13px; color: var(--on-surface-variant); text-decoration: none; font-weight: 600;">Archive Search</a>
            </div>
        </div>

        <!-- Right: Search + Notifications + User -->
        <div class="d-flex align-items-center gap-3">
            <div class="d-none d-md-block header-search-wrapper">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">search</span>
                <input class="header-search-input" placeholder="Search system logs..." type="text" aria-label="Search system logs" />
            </div>
            <button class="btn p-2 rounded-circle border-0 position-relative" style="background: transparent;" aria-label="Notifications">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <span class="notif-dot"></span>
            </button>
            <div class="d-flex align-items-center gap-2 ps-3" style="border-left: 1px solid var(--outline-variant);">
                <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container); font-size: 12px; font-weight: 700;">
                    AD
                </div>
                <div class="d-none d-sm-block">
                    <p class="mb-0 fw-bold lh-sm" style="font-size: 13px;">
                        <c:out value="${sessionScope.email}" default="Admin"/>
                    </p>
                    <p class="mb-0 text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.1em;">
                        <c:out value="${sessionScope.role}" default="ADMIN"/>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="btn p-2 rounded-circle border-0 ms-1"
                   style="background: transparent; color: var(--on-surface-variant);"
                   title="Sign out">
                    <span class="material-symbols-outlined" style="font-size: 20px;">logout</span>
                </a>
            </div>
        </div>
    </div>
</header>
