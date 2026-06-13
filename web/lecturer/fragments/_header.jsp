<%-- Fragment: _header.jsp ΓÇö Fixed top navigation bar for Lecturer --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ HEADER ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ -->
<header class="fixed-top bg-white shadow-sm" style="height: 64px; border-bottom: 1px solid var(--outline-variant);">
    <div class="h-100 d-flex align-items-center justify-content-between px-4 header-layout">

        <!-- Left: Title + Nav -->
        <div class="d-flex align-items-center gap-4 text-nowrap">
            <h1 class="h5 fw-bold mb-0 text-primary-custom text-nowrap">T├ái nguy├¬n Hß╗ìc thuß║¡t</h1>
            <div class="d-none d-md-flex gap-4 ms-2 text-nowrap">
                <a href="${pageContext.request.contextPath}/lecturer/dashboard"
                   style="font-size: 13px; color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 2px; text-decoration: none; font-weight: 600;">Bß║úng ─æiß╗üu khiß╗ân</a>
                <a href="${pageContext.request.contextPath}/book-search.jsp"
                   style="font-size: 13px; color: var(--on-surface-variant); text-decoration: none; font-weight: 600;">Danh mß╗Ñc</a>
            </div>
        </div>

        <!-- Right: Search + Notifications + User -->
        <div class="d-flex align-items-center gap-3">
            <div class="d-none d-md-block header-search-wrapper">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">search</span>
                <input class="header-search-input" placeholder="T├¼m kiß║┐m s├ích, tß║íp ch├¡..." type="text" aria-label="T├¼m kiß║┐m danh mß╗Ñc th╞░ viß╗çn" />
            </div>
            <a href="${pageContext.request.contextPath}/notifications"
               class="btn p-2 rounded-circle border-0 position-relative" style="background: transparent;" aria-label="Th├┤ng b├ío">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <c:choose>
                    <c:when test="${not empty sessionScope.unreadNotificationCount and sessionScope.unreadNotificationCount > 0}">
                        <span id="headerUnreadBadge"
                              class="position-absolute top-0 start-100 translate-middle badge rounded-pill"
                              style="background-color: var(--primary); font-size: 10px; padding: 3px 6px; min-width: 18px;">
                            <c:choose>
                                <c:when test="${sessionScope.unreadNotificationCount > 99}">99+</c:when>
                                <c:otherwise>${sessionScope.unreadNotificationCount}</c:otherwise>
                            </c:choose>
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="notif-dot"></span>
                    </c:otherwise>
                </c:choose>
            </a>
            <a href="${pageContext.request.contextPath}/lecturer/profile" class="d-flex align-items-center gap-2 ps-3 text-decoration-none text-reset text-nowrap" style="border-left: 1px solid var(--outline-variant);" title="Xem Hß╗ô s╞í">
                <div class="avatar" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">GV</div>
                <div class="d-none d-sm-block text-start" style="max-width: 160px;">
                    <p class="mb-0 fw-bold lh-sm text-truncate" style="font-size: 13px;" title="<c:out value="${sessionScope.email}"/>">
                        <c:out value="${sessionScope.email}" default="Giß║úng vi├¬n"/>
                    </p>
                    <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                        <c:out value="${sessionScope.role}" default="LECTURER"/>
                    </p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn p-2 rounded-circle border-0 ms-1"
               style="background: transparent; color: var(--on-surface-variant);" title="─É─âng xuß║Ñt">
                <span class="material-symbols-outlined" style="font-size: 20px;">logout</span>
            </a>
        </div>
    </div>
</header>
