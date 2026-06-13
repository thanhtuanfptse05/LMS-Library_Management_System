<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Quick Access / Shortcut Grid -->
<section class="py-5" style="background-color: var(--bs-body-bg);" id="quicklinks">
    <div class="container-xl px-4">

        <!-- Section Header -->
        <div class="mb-4">
            <span class="fw-bold text-uppercase"
                style="font-size: 12px; letter-spacing: 0.1em; color: var(--primary-color);">Truy cập nhanh</span>
            <h2 class="fw-bold mt-1 mb-0" style="font-size: 28px; color: var(--bs-body-color);">Lối tắt Thư viện</h2>
        </div>

        <div class="row g-4 row-cols-1 row-cols-md-3">

            <!-- Card 1: Catalog Search -->
            <div class="col">
                <a href="${pageContext.request.contextPath}/book-search" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-book-half fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Mục lục</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Duyệt qua bộ sưu tập thư viện vật lý và kỹ thuật số của chúng tôi trên tất cả các lĩnh vực.
                        </p>
                    </div>
                </a>
            </div>

            <!-- Card 2: Borrow & Return -->
            <div class="col">
                <a href="${pageContext.request.contextPath}/services.jsp?tab=circulation" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-cart3 fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Mượn sách</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Yêu cầu tài liệu để nhận trực tiếp hoặc mượn liên thư viện một cách dễ dàng.
                        </p>
                    </div>
                </a>
            </div>

            <!-- Card 3: Renew Items -->
            <div class="col">
                <a href="${pageContext.request.contextPath}/services.jsp?tab=renewal" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-arrow-clockwise fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Gia hạn</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Gia hạn các khoản mượn hiện tại của bạn và quản lý tài khoản trực tuyến.
                        </p>
                    </div>
                </a>
            </div>

            <!-- Card 4: Policies -->
            <div class="col">
                <a href="${pageContext.request.contextPath}/policies.jsp" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-gavel fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Chính sách</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Tìm hiểu các quyền truy cập, thời hạn mượn và các hướng dẫn của thư viện.
                        </p>
                    </div>
                </a>
            </div>

            <!-- Card 5: My Dashboard (role-aware) -->
            <div class="col">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'admin'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LIBRARIAN' or sessionScope.role eq 'librarian'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'MANAGER' or sessionScope.role eq 'manager'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'STUDENT' or sessionScope.role eq 'student'}">
                                <c:set var="dashUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LECTURER' or sessionScope.role eq 'lecturer'}">
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
                <a href="${dashUrl}" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-speedometer2 fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Bảng điều khiển</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Tổng quan cá nhân hóa về nghiên cứu và các tài liệu đã mượn của bạn.
                        </p>
                    </div>
                </a>
            </div>

            <!-- Card 6: Librarian Chat -->
            <div class="col">
                <a href="#contact" onclick="openLibrarianChat(event)" class="text-decoration-none d-block h-100">
                    <div class="shortcut-card h-100">
                        <div class="icon-circle mb-4">
                            <i class="bi bi-chat-dots fs-4"></i>
                        </div>
                        <h3 class="fw-medium mb-2" style="font-size: 22px; color: var(--bs-body-color);">Trò chuyện với Thủ thư</h3>
                        <p class="mb-0 small" style="color: var(--text-muted-custom);">
                            Nhận sự hỗ trợ nghiên cứu chuyên môn từ các thủ thư chuyên nghiệp của chúng tôi.
                        </p>
                    </div>
                </a>
            </div>

        </div>
    </div>
</section>
