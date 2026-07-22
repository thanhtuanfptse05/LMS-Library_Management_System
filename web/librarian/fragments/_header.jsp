<%-- Fragment: _header.jsp — Fixed top navigation bar for Librarian --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="currentRolePath" value="${fn:toLowerCase(sessionScope.role)}" />
<!-- ════════════════ HEADER ════════════════ -->
<header class="lms-header header-layout">

    <!-- Mobile Sidebar Toggle -->
    <button class="btn btn-icon d-lg-none me-2 text-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#librarianSidebarOffcanvas" aria-controls="librarianSidebarOffcanvas" aria-label="Mở menu">
        <span class="material-symbols-outlined fs-3">menu</span>
    </button>

    <!-- Left: Title -->
    <div class="d-flex align-items-center gap-3 flex-grow-1 text-nowrap overflow-hidden me-3">
        <h1 class="mb-0 fw-bold text-primary-custom" style="font-size: 16px; white-space: nowrap;">
            <span class="material-symbols-outlined me-1" style="font-size: 18px; font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">library_books</span>
            Hoạt động Thủ thư
        </h1>
    </div>

    <!-- Right: Notifications + User -->
    <div class="d-flex align-items-center gap-2 flex-shrink-0">

        <div style="width: 1px; height: 24px; background: var(--outline-variant);"></div>

        <a href="${pageContext.request.contextPath}/${currentRolePath}/profile"
           class="d-flex align-items-center gap-2 text-decoration-none"
           title="Xem hồ sơ">
            <div class="header-avatar" title="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}">
                <c:choose>
                    <c:when test="${not empty sessionScope.fullName}">
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.fullName,0,2))}" />
                    </c:when>
                    <c:when test="${not empty sessionScope.email}">
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.email,0,2))}" />
                    </c:when>
                    <c:otherwise>TT</c:otherwise>
                </c:choose>
            </div>
            <div class="d-none d-sm-block" style="max-width: 140px;">
                <p class="mb-0 fw-bold text-truncate" style="font-size: 13px; color: var(--on-surface);">
                    <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}" default="Thủ thư"/>
                </p>
                <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                    <c:out value="${sessionScope.role}" default="THỦ THƯ"/>
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
