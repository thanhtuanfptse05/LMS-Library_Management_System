<%-- Fragment: _header.jsp — Fixed top navigation bar for Admin --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="lms-header header-layout">

    <!-- Mobile Sidebar Toggle -->
    <button class="btn btn-icon d-lg-none me-2 text-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebarOffcanvas" aria-controls="adminSidebarOffcanvas" aria-label="Mở menu">
        <span class="material-symbols-outlined fs-3">menu</span>
    </button>

    <!-- Left: Title + Breadcrumb -->
    <div class="d-flex align-items-center gap-3 flex-grow-1 text-nowrap overflow-hidden me-3">
        <div>
            <h1 class="mb-0 fw-bold text-primary-custom" style="font-size: 16px; white-space: nowrap;">
                <span class="material-symbols-outlined me-1" style="font-size: 18px; font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">admin_panel_settings</span>
                Quản trị viên
            </h1>
        </div>
        <div class="d-none d-lg-flex gap-1 align-items-center">
            <span style="width: 1px; height: 20px; background: var(--outline-variant); display: inline-block;"></span>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="px-3 py-1 rounded-pill text-decoration-none fw-semibold"
               style="font-size: 13px; color: var(--primary); background: rgba(157,67,0,0.08);">
                Tổng quan trực tiếp
            </a>
        </div>
    </div>

    <!-- Right: Actions + User -->
    <div class="d-flex align-items-center gap-2 flex-shrink-0">

        <a href="${pageContext.request.contextPath}/admin/profile"
           class="d-flex align-items-center gap-2 text-decoration-none"
           title="Xem Hồ sơ">
            <div class="header-avatar" title="${sessionScope.fullName}">
                <c:choose>
                    <c:when test="${not empty sessionScope.fullName}">
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.fullName,0,1))}" />
                    </c:when>
                    <c:otherwise>QT</c:otherwise>
                </c:choose>
            </div>
            <div class="d-none d-sm-block" style="max-width: 140px;">
                <p class="mb-0 fw-bold text-truncate" style="font-size: 13px; color: var(--on-surface);">
                    <c:out value="${sessionScope.fullName}" default="Admin"/>
                </p>
                <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                    <c:out value="${sessionScope.role}" default="ADMIN"/>
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
