<%-- Fragment: _sidebar.jsp — Left sidebar navigation --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<!-- ─── SIDEBAR ─── -->
<aside class="d-none d-lg-flex flex-column bg-surface-container-low gap-4 p-4"
       style="width: 256px; flex-shrink: 0; border-right: 1px solid var(--outline-variant); overflow-y: auto;">

    <!-- Library Access -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">Library Access</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link active"
               href="${pageContext.request.contextPath}/student/dashboard">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">home</span>
                <span><fmt:message key="nav.home" /></span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/loans">
                <span class="material-symbols-outlined">book</span>
                <span><fmt:message key="student.loans_title" /></span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/reservations">
                <span class="material-symbols-outlined">bookmark</span>
                <span><fmt:message key="student.reservations_title" /></span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/fines">
                <span class="material-symbols-outlined">payments</span>
                <span><fmt:message key="student.fines_title" /></span>
            </a>
        </div>
    </div>

    <!-- Account -->
    <div>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-3"
           style="font-size: 10px; letter-spacing: 0.2em;">Account</p>
        <div class="d-flex flex-column gap-1">
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/student/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span><fmt:message key="student.profile_title" /></span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/forgot-password">
                <span class="material-symbols-outlined">security</span>
                <span><fmt:message key="student.security_title" /></span>
            </a>
            <a class="sidebar-link"
               href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">contact_support</span>
                <span><fmt:message key="student.help_title" /></span>
            </a>
        </div>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(249, 115, 22, 0.1); border: 1px solid rgba(249, 115, 22, 0.2);">
        <p class="fw-bold text-primary-custom mb-1 small"><fmt:message key="student.need_assistance" /></p>
        <p class="text-on-surface-variant mb-3" style="font-size: 11px;">
            <fmt:message key="student.contact_librarians" />
        </p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3">
            <fmt:message key="student.report_issue" />
        </a>
    </div>
</aside>
