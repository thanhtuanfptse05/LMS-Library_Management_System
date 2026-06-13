<%-- Fragment: _sidebar.jsp ΓÇö Left sidebar navigation --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ΓöÇΓöÇΓöÇ SIDEBAR ΓöÇΓöÇΓöÇ -->
<aside class="d-none d-lg-flex flex-column bg-surface-container-low gap-4 p-4"
       style="width: 280px; flex-shrink: 0; border-right: 1px solid var(--outline-variant); overflow-y: auto;">

    <!-- Library Access -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">Truy cß║¡p Th╞░ viß╗çn</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/dashboard">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">home</span>
                <span>Trang chß╗º</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/loans">
                <span class="material-symbols-outlined">book</span>
                <span>S├ích t├┤i m╞░ß╗ún</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/reservations">
                <span class="material-symbols-outlined">bookmark</span>
                <span>─Éß║╖t tr╞░ß╗¢c</span>
            </a>
            <a class="sidebar-link"
               href="#">
                <span class="material-symbols-outlined">payments</span>
                <span>Lß╗ïch sß╗¡ nß╗Öp phß║ít</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/notifications">
                 <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">campaign</span>
                 <span>Bß║úng tin</span>
                 <c:if test="${not empty sessionScope.unreadNotificationCount and sessionScope.unreadNotificationCount > 0}">
                     <span class="ms-auto badge rounded-pill"
                           style="background-color: var(--primary); color: white; font-size: 10px; padding: 2px 7px; min-width: 20px; text-align: center;">
                         <c:choose>
                             <c:when test="${sessionScope.unreadNotificationCount > 99}">99+</c:when>
                             <c:otherwise>${sessionScope.unreadNotificationCount}</c:otherwise>
                         </c:choose>
                     </span>
                 </c:if>
            </a>
        </div>
    </div>

    <!-- Account -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">T├ái khoß║ún</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>Hß╗ô s╞í cß╗ºa t├┤i</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/forgot-password">
                <span class="material-symbols-outlined">security</span>
                <span>C├ái ─æß║╖t Bß║úo mß║¡t</span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">contact_support</span>
                <span>Trung t├óm Trß╗ú gi├║p</span>
            </a>
        </div>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(249, 115, 22, 0.1); border: 1px solid rgba(249, 115, 22, 0.2);">
        <p class="fw-bold text-primary-custom mb-1 small">Cß║ºn hß╗ù trß╗ú?</p>
        <p class="text-on-surface-variant mb-3" style="font-size: 11px;">
            Li├¬n hß╗ç thß╗º th╞░ ─æß╗â ─æ╞░ß╗úc trß╗ú gi├║p nghi├¬n cß╗⌐u hoß║╖c b├ío c├ío sß╗▒ cß╗æ.
        </p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3">
            B├ío c├ío sß╗▒ cß╗æ
        </a>
    </div>
</aside>
