<%-- Fragment: _header.jsp — Fixed top navigation bar --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="fixed-top bg-white shadow-sm" style="height: 64px; border-bottom: 1px solid var(--outline-variant);">
    <div class="container-xl h-100 d-flex align-items-center justify-content-between px-4">

        <!-- Left: Logo + Search -->
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/"
               class="fs-5 fw-bold text-decoration-none text-primary-custom">
                LMS University Library
            </a>
            <div class="d-none d-md-block header-search-wrapper">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">search</span>
                <input class="header-search-input"
                       placeholder="Search books, journals, or resources..."
                       type="text"
                       aria-label="Search library catalog" />
            </div>
        </div>

        <!-- Center Nav (desktop only) -->
        <nav class="d-none d-lg-flex align-items-center gap-4">
            <a class="text-primary-custom fw-semibold text-decoration-none border-bottom border-2 border-primary-custom pb-1"
               href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a>
            <a class="text-on-surface-variant text-decoration-none fw-semibold small"
               href="${pageContext.request.contextPath}/book-search.jsp">Catalog</a>
            <a class="text-on-surface-variant text-decoration-none fw-semibold small"
               href="${pageContext.request.contextPath}/#services">Services</a>
            <a class="text-on-surface-variant text-decoration-none fw-semibold small"
               href="${pageContext.request.contextPath}/#policies">Policies</a>
            <a class="text-on-surface-variant text-decoration-none fw-semibold small"
               href="${pageContext.request.contextPath}/#contact">Support</a>
        </nav>

        <!-- Right: Notifications + User -->
        <div class="d-flex align-items-center gap-3">
            <button class="btn p-2 rounded-circle border-0 position-relative"
                    style="background: transparent;"
                    aria-label="Notifications"
                    title="Notifications">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <span class="notif-dot"></span>
            </button>
            <button class="btn p-2 rounded-circle border-0"
                    style="background: transparent;"
                    aria-label="Help"
                    title="Help Center">
                <span class="material-symbols-outlined text-on-surface-variant">help</span>
            </button>
            <!-- User avatar + info from session -->
            <div class="d-flex align-items-center gap-2 ps-3"
                 style="border-left: 1px solid var(--outline-variant);">
                <span class="material-symbols-outlined text-primary-custom"
                      style="font-size: 36px; font-variation-settings: 'FILL' 1;">account_circle</span>
                <div class="d-none d-sm-block">
                    <p class="mb-0 fw-bold lh-sm" style="font-size: 14px;">
                        <c:out value="${sessionScope.email}" default="Student"/>
                    </p>
                    <p class="mb-0 text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.1em;">
                        <c:out value="${sessionScope.role}" default="STUDENT"/>
                    </p>
                </div>
                <!-- Logout -->
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
