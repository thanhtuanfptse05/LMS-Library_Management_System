<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- TopAppBar — 2-row layout -->
<header class="w-100 shadow-sm fixed-top" style="background-color: var(--surface-container-high);" id="main-header">
    <div class="container-xl px-4">

        <!-- Row 1: Logo / Branding & Hours -->
        <div class="d-flex justify-content-between align-items-center py-2"
            style="border-bottom: 1px solid rgba(219, 194, 176, 0.35);">

            <!-- Logo + Full Name -->
            <a href="${pageContext.request.contextPath}/"
                class="text-decoration-none d-flex align-items-center gap-2">
                <i class="bi bi-book-half" style="font-size: 26px; color: var(--primary-color);"></i>
                <div class="lh-sm">
                    <span class="fw-bold d-block"
                        style="font-size: 17px; color: var(--primary-color); letter-spacing: -0.01em;">
                        University Library Management System
                    </span>
                    <span class="d-block fw-semibold text-uppercase"
                        style="font-size: 10px; letter-spacing: 0.08em; color: var(--text-muted-custom);">
                        UniLib LMS
                    </span>
                </div>
            </a>

            <!-- Operational Status -->
            <div class="d-none d-sm-flex align-items-center gap-2 fw-medium"
                style="font-size: 13px; color: var(--text-muted-custom);">
                <span class="custom-badge-pulse"></span>
                Today's Hours:&nbsp;<strong style="color: var(--bs-body-color);">08:00 AM – 08:00 PM</strong>
            </div>
        </div>

        <!-- Row 2: Navigation & Auth CTA -->
        <nav class="d-flex justify-content-between align-items-center py-2">

            <!-- Main Nav Links -->
            <div class="d-none d-md-flex gap-4">
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/">Home</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/services.jsp">Services</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/policies.jsp">Policies</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/news.jsp">News</a>
                <a class="nav-link-custom" href="#contact">Contact</a>
            </div>

            <!-- Auth CTA -->
            <div class="d-flex align-items-center gap-2 ms-auto">
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
                        <span class="small fw-medium d-none d-lg-inline" style="color: var(--text-muted-custom);">
                            Welcome, <strong><c:out value="${sessionScope.email}"/></strong>
                        </span>
                        <a href="${dashboardUrl}"
                            class="btn btn-primary-custom px-3 py-2 rounded-3 fw-semibold d-inline-flex align-items-center gap-1"
                            style="font-size: 13px;">
                            <i class="bi bi-grid-fill"></i> Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/logout"
                            class="btn btn-outline-secondary px-3 py-2 rounded-3 fw-semibold"
                            style="font-size: 13px;">
                            Sign Out
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"
                            class="btn btn-primary-custom px-4 py-2 rounded-3 fw-semibold"
                            style="font-size: 14px;">
                            Sign In
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>
