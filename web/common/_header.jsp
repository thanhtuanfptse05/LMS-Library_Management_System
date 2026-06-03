<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- TopNavBar -->
<header class="bg-white shadow-sm sticky-top transition-all" id="main-header">
    <div class="container-xl d-flex justify-content-between align-items-center py-3">
        <div class="d-flex align-items-center gap-2">
            <span class="text-primary-custom material-symbols-outlined fs-2">library_books</span>
            <span class="fs-5 fw-bold text-primary-custom">UniLib LMS</span>
        </div>

        <nav class="d-none d-md-flex align-items-center gap-4">
            <a class="nav-link-custom active" href="#">Home</a>
            <a class="nav-link-custom" href="#services">Services</a>
            <a class="nav-link-custom" href="#policies">Policies</a>
            <a class="nav-link-custom" href="#news">News</a>
            <a class="nav-link-custom" href="#contact">Contact</a>
        </nav>

        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/book-search.jsp" class="btn d-none d-lg-flex align-items-center text-muted rounded-pill px-3 py-1 text-decoration-none">
                <span class="material-symbols-outlined me-1">search</span>
                <span class="small">Search Catalog</span>
            </a>
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
                    <a href="${dashboardUrl}" class="btn bg-primary-container text-white rounded-pill px-4 fw-semibold shadow-sm text-decoration-none d-inline-flex align-items-center justify-content-center">
                        Go to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary rounded-pill px-3 fw-semibold text-decoration-none d-inline-flex align-items-center justify-content-center">
                        Sign Out
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn bg-primary-container text-white rounded-pill px-4 fw-semibold shadow-sm text-decoration-none d-inline-flex align-items-center justify-content-center">
                        Sign In
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
