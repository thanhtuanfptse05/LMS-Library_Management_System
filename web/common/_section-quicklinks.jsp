<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Quick Links / Dashboard Shortcut Grid -->
<section class="py-5 bg-white border-top border-bottom border-outline-variant" id="quicklinks">
    <div class="container-xl py-3">
        <div class="mb-4 text-center text-md-start">
            <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">Quick Access</span>
            <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Library Shortcuts</h2>
        </div>
        
        <div class="row g-4">
            <!-- Shortcut 1: Catalog Search -->
            <div class="col-6 col-md-4 col-lg-4">
                <a href="${pageContext.request.contextPath}/book-search.jsp" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">search</span>
                    <span class="fw-bold text-dark small">Search Catalog</span>
                </a>
            </div>
            
            <!-- Shortcut 2: Circulation Services -->
            <div class="col-6 col-md-4 col-lg-4">
                <a href="${pageContext.request.contextPath}/services.jsp?tab=circulation" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">sync_alt</span>
                    <span class="fw-bold text-dark small">Borrow & Return</span>
                </a>
            </div>
            
            <!-- Shortcut 3: Document Renewal -->
            <div class="col-6 col-md-4 col-lg-4">
                <a href="${pageContext.request.contextPath}/services.jsp?tab=renewal" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">autorenew</span>
                    <span class="fw-bold text-dark small">Renew Items</span>
                </a>
            </div>
            
            <!-- Shortcut 4: Library Policies -->
            <div class="col-6 col-md-4 col-lg-4">
                <a href="${pageContext.request.contextPath}/policies.jsp" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">gavel</span>
                    <span class="fw-bold text-dark small">Library Policies</span>
                </a>
            </div>
            
            <!-- Shortcut 5: Student Dashboard -->
            <div class="col-6 col-md-4 col-lg-4">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'ADMIN'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LIBRARIAN'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'MANAGER'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'STUDENT'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LECTURER'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/lecturer/dashboard" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="dashUrl" value="${pageContext.request.contextPath}/login" />
                    </c:otherwise>
                </c:choose>
                <a href="${dashUrl}" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">dashboard</span>
                    <span class="fw-bold text-dark small">My Dashboard</span>
                </a>
            </div>
            
            <!-- Shortcut 6: Chat with Librarian -->
            <div class="col-6 col-md-4 col-lg-4">
                <a href="#contact" onclick="openLibrarianChat(event)" class="card h-100 border border-outline-variant text-center p-3 text-decoration-none card-hover rounded-3 bg-container-low d-flex flex-column align-items-center justify-content-center py-4">
                    <span class="material-symbols-outlined text-primary-custom display-6 mb-2">forum</span>
                    <span class="fw-bold text-dark small">Librarian Chat</span>
                </a>
            </div>
        </div>
    </div>
</section>
