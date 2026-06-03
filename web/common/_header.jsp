<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- TopNavBar -->
<header class="bg-white shadow-sm sticky-top transition-all" id="main-header">
    <!-- Top Row: Branding, Hours, Auth -->
    <div class="border-bottom border-outline-variant py-2 bg-light">
        <div class="container-xl d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <!-- Hours & Operational Status -->
            <div class="d-flex align-items-center gap-2 text-secondary-custom small">
                <span class="material-symbols-outlined text-primary-custom fs-6">schedule</span>
                <span>Today's Hours: <strong class="text-dark">08:00 AM - 08:00 PM</strong></span>
                <span class="badge bg-success text-white px-2 py-0.5 rounded-pill" style="font-size: 10px;">Open Now</span>
            </div>
            
            <!-- Auth / Personalization Area -->
            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'ADMIN'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LIBRARIAN'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'MANAGER'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'STUDENT'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LECTURER'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/lecturer/dashboard" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:otherwise>
                        </c:choose>
                        <span class="small text-muted me-2 d-none d-sm-inline">Welcome, <strong><c:out value="${sessionScope.email}"/></strong></span>
                        <a href="${dashboardUrl}" class="btn bg-primary-container text-white rounded-pill px-3 py-1 fw-semibold shadow-sm text-decoration-none small d-inline-flex align-items-center justify-content-center gap-1" style="font-size: 13px;">
                            <span class="material-symbols-outlined fs-6">dashboard</span> Go to Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary rounded-pill px-3 py-1 fw-semibold text-decoration-none small d-inline-flex align-items-center justify-content-center" style="font-size: 13px;">
                            Sign Out
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn bg-primary-container text-white rounded-pill px-4 py-1 fw-semibold shadow-sm text-decoration-none small d-inline-flex align-items-center justify-content-center" style="font-size: 13px;">
                            Sign In
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Bottom Row: Logo & Navigation Bar -->
    <div class="container-xl d-flex justify-content-between align-items-center py-3">
        <!-- Logo school + Tên thư viện (ví dụ: Thư viện Đại học [Tên Trường]) -->
        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center gap-2 text-decoration-none">
            <span class="text-primary-custom material-symbols-outlined fs-2">library_books</span>
            <div class="lh-sm">
                <span class="fs-5 fw-bold text-primary-custom d-block">UniLib LMS</span>
                <span class="text-secondary-custom d-block" style="font-size: 11px; letter-spacing: 0.05em; font-weight: 600; text-transform: uppercase;">University Library</span>
            </div>
        </a>

        <!-- Main Navigation Bar -->
        <nav class="d-none d-md-flex align-items-center gap-4">
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/">Home</a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/services.jsp">Services</a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/policies.jsp">Policies</a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/news.jsp">News</a>
            <a class="nav-link-custom" href="#contact">Contact</a>
        </nav>
    </div>
</header>
