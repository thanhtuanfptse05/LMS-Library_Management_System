<%-- Fragment: _header.jsp — Fixed top navigation bar for Librarian --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="currentRolePath" value="${fn:toLowerCase(sessionScope.role)}" />
<!-- ════════════════ HEADER ════════════════ -->
<header class="fixed-top bg-white shadow-sm" style="height: 64px; border-bottom: 1px solid var(--outline-variant);">
    <div class="h-100 d-flex align-items-center justify-content-between px-4 header-layout">

        <!-- Left: Title -->
        <div class="d-flex align-items-center gap-4 text-nowrap">
            <h1 class="h5 fw-bold mb-0 text-primary-custom text-nowrap">Hoạt động Thủ thư</h1>
        </div>

        <!-- Right: Search + Notifications + User -->
        <div class="d-flex align-items-center gap-3">
            <div class="d-none d-md-block header-search-wrapper">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">search</span>
                <input class="header-search-input" placeholder="Tìm kiếm thành viên hoặc sách..." type="text" aria-label="Tìm kiếm thành viên hoặc sách" />
            </div>
            <button class="btn p-2 rounded-circle border-0 position-relative" style="background: transparent;" aria-label="Thông báo">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <span class="notif-dot"></span>
            </button>
            <a href="${pageContext.request.contextPath}/${currentRolePath}/profile" class="d-flex align-items-center gap-2 ps-3 text-decoration-none text-reset text-nowrap" style="border-left: 1px solid var(--outline-variant);" title="Xem hồ sơ">
                <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">TT</div>
                <div class="d-none d-sm-block text-start" style="max-width: 160px;">
                    <p class="mb-0 fw-bold lh-sm text-truncate" style="font-size: 13px;" title="<c:out value="${sessionScope.email}"/>">
                        <c:out value="${sessionScope.email}" default="Thủ thư"/>
                    </p>
                    <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                        <c:out value="${sessionScope.role}" default="THỦ THƯ"/>
                    </p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn p-2 rounded-circle border-0 ms-1"
               style="background: transparent; color: var(--on-surface-variant);" title="Đăng xuất">
                <span class="material-symbols-outlined" style="font-size: 20px;">logout</span>
            </a>
        </div>
    </div>
</header>
