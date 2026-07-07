<%-- Fragment: _header.jsp — Fixed top navigation bar for Student --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="lms-header header-layout">

    <!-- Left: Logo + Search -->
    <div class="d-flex align-items-center gap-3 flex-grow-1 overflow-hidden me-3">
        <a href="${pageContext.request.contextPath}/"
           class="fw-bold text-decoration-none text-primary-custom d-none d-md-block text-nowrap"
           style="font-size: 15px; white-space: nowrap;">
            <span class="material-symbols-outlined me-1" style="font-size: 18px; font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">local_library</span>
            LMS Thư viện
        </a>

        <div class="d-none d-md-block header-search-wrapper">
            <span class="material-symbols-outlined">search</span>
            <input class="header-search-input"
                   placeholder="Tìm kiếm sách, tạp chí, tài liệu..."
                   type="text"
                   aria-label="Tìm kiếm danh mục thư viện"
                   id="globalSearchInput" />
        </div>
    </div>

    <!-- Center Nav (desktop only) -->
    <nav class="d-none d-lg-flex align-items-center gap-1 flex-shrink-0 me-2">
        <a class="px-3 py-1 rounded-pill fw-semibold text-decoration-none text-primary-custom"
           style="font-size: 13px; background: rgba(157,67,0,0.08);"
           href="${pageContext.request.contextPath}/student/dashboard">Bảng điều khiển</a>
        <a class="px-3 py-1 rounded-pill fw-semibold text-decoration-none text-on-surface-variant"
           style="font-size: 13px; transition: background 0.2s ease;"
           onmouseover="this.style.background='var(--surface-container-high)'"
           onmouseout="this.style.background=''"
           href="${pageContext.request.contextPath}/book-search">Danh mục</a>
        <a class="px-3 py-1 rounded-pill fw-semibold text-decoration-none text-on-surface-variant"
           style="font-size: 13px; transition: background 0.2s ease;"
           onmouseover="this.style.background='var(--surface-container-high)'"
           onmouseout="this.style.background=''"
           href="${pageContext.request.contextPath}/#contact">Hỗ trợ</a>
    </nav>

    <!-- Right: Notifications + User -->
    <div class="d-flex align-items-center gap-2 flex-shrink-0">
        <!-- Notification bell -->
        <jsp:include page="/components/notification-bell" />

        <button class="header-icon-btn" aria-label="Trợ giúp" title="Trung tâm Trợ giúp">
            <span class="material-symbols-outlined">help</span>
        </button>

        <div style="width: 1px; height: 24px; background: var(--outline-variant);"></div>

        <!-- User info -->
        <a href="${pageContext.request.contextPath}/student/profile"
           class="d-flex align-items-center gap-2 text-decoration-none"
           title="Xem Hồ sơ">
            <div class="header-avatar" title="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}">
                <c:choose>
                    <c:when test="${not empty sessionScope.fullName}">
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.fullName,0,2))}" />
                    </c:when>
                    <c:when test="${not empty sessionScope.email}">
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.email,0,2))}" />
                    </c:when>
                    <c:otherwise>SV</c:otherwise>
                </c:choose>
            </div>
            <div class="d-none d-sm-block" style="max-width: 140px;">
                <p class="mb-0 fw-bold text-truncate" style="font-size: 13px; color: var(--on-surface);">
                    <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}" default="Sinh viên"/>
                </p>
                <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                    <c:out value="${sessionScope.role}" default="SINH VIÊN"/>
                </p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/logout"
           class="header-icon-btn"
           title="Đăng xuất">
            <span class="material-symbols-outlined">logout</span>
        </a>
    </div>

</header>
