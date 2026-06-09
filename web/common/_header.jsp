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
                        Hệ thống Quản lý Thư viện Đại học
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
                Giờ làm việc hôm nay:&nbsp;<strong style="color: var(--bs-body-color);">08:00 AM – 08:00 PM</strong>
            </div>
        </div>

        <!-- Row 2: Navigation & Auth CTA -->
        <nav class="d-flex justify-content-between align-items-center py-2">

            <!-- Main Nav Links -->
            <div class="d-none d-md-flex gap-4">
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/">Trang chủ</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/services.jsp">Dịch vụ</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/policies.jsp">Chính sách</a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/news.jsp">Tin tức</a>
                <a class="nav-link-custom" href="#contact">Liên hệ</a>
            </div>

            <!-- Auth CTA -->
            <div class="d-flex align-items-center gap-2 ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'admin'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LIBRARIAN' or sessionScope.role eq 'librarian'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'MANAGER' or sessionScope.role eq 'manager'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'STUDENT' or sessionScope.role eq 'student'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LECTURER' or sessionScope.role eq 'lecturer'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/lecturer/dashboard" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:otherwise>
                        </c:choose>
                        <span class="small fw-medium d-none d-lg-inline" style="color: var(--text-muted-custom);">
                            Chào mừng, <strong><c:out value="${sessionScope.email}"/></strong>
                        </span>
                        <a href="${dashboardUrl}"
                            class="btn btn-primary-custom px-3 py-2 rounded-3 fw-semibold d-inline-flex align-items-center gap-1"
                            style="font-size: 13px;">
                            <i class="bi bi-grid-fill"></i> Bảng điều khiển
                        </a>
                        <a href="${pageContext.request.contextPath}/logout"
                            class="btn btn-outline-secondary px-3 py-2 rounded-3 fw-semibold"
                            style="font-size: 13px;">
                            Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"
                            class="btn btn-primary-custom px-4 py-2 rounded-3 fw-semibold"
                            style="font-size: 14px;">
                            Đăng nhập
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>
<!-- Khối đệm (Spacer) để chống việc Header (fixed-top) che mất nội dung bên dưới -->
<div style="height: 115px;"></div>
