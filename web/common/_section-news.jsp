<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="newsDAO" class="dao.NotificationDAO" scope="request" />
<c:set var="topNews" value="${newsDAO.getPublicNewsPaged(null, 1, 3)}" />

<!-- Latest News Section -->
<section class="py-5" style="background-color: var(--surface-container-low);" id="news">
    <div class="container-xl px-4">

        <!-- Section Header -->
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="fw-bold text-uppercase"
                    style="font-size: 12px; letter-spacing: 0.1em; color: var(--primary-color);">Cập nhật</span>
                <h2 class="fw-bold mt-1 mb-0" style="font-size: 32px; color: var(--bs-body-color);">Tin tức mới nhất</h2>
                <p class="mb-0" style="color: var(--text-muted-custom);">Cập nhật thông tin về nghiên cứu và các sự kiện thư viện.</p>
            </div>
            <a class="fw-semibold text-decoration-none d-flex align-items-center gap-1"
                style="color: var(--primary-color); white-space: nowrap;"
                href="${pageContext.request.contextPath}/news">
                Xem tất cả tin tức <i class="bi bi-arrow-right small"></i>
            </a>
        </div>

        <div class="row g-4 row-cols-1 row-cols-md-3">
            
            <c:choose>
                <c:when test="${not empty topNews}">
                    <c:forEach var="item" items="${topNews}">
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm overflow-hidden card-hover"
                                style="background-color: var(--surface-lowest); border-radius: 0.75rem; cursor: pointer;"
                                onclick="window.location.href='${pageContext.request.contextPath}/news?id=${item.notificationId}'">
                                <div class="img-hover-zoom" style="height: 192px;">
                                    <c:choose>
                                        <c:when test="${not empty item.thumbnailUrl}">
                                            <img alt="Thumbnail" class="w-100 h-100 object-fit-cover" src="${item.thumbnailUrl}" />
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Default image if no thumbnail -->
                                            <img alt="Default Thumbnail" class="w-100 h-100 object-fit-cover"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuAGo9Uw-QmKvCKVC7g3dFXHjfsao_1QHKzwCHOVNre5bMHy0lIw8G1f1LkF3zdxA_FsmCX3iG73zzY0jlvFeSUGS-h3O-7BUP-5_PSQWNrld0oGA19v7AmrKy2sdehcSy6bkgzVv84ywAkY6S5AlVG5mR-Eknlb7WMD3UCDUICyhqBw7xH3sMw7890d3CeBGhrG78zGVdU0Lcm1M7uy7jwnFCeUA56TfJJRKMBifavQ7V7IvcF7riyG4LP_XrLwbgSaGgH3Sl-KDQXH" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="card-body p-4 d-flex flex-column">
                                    <span class="fw-medium mb-1" style="font-size: 12px; color: var(--primary-color);">
                                        <c:choose>
                                            <c:when test="${item.type == 'event'}">Sự kiện</c:when>
                                            <c:otherwise>Tin tức</c:otherwise>
                                        </c:choose>
                                        • <fmt:formatDate value="${item.createdAt}" pattern="dd 'tháng' MM, yyyy" />
                                    </span>
                                    <h4 class="fw-semibold mb-3 line-clamp-2" style="font-size: 16px;"><c:out value="${item.title}"/></h4>
                                    <p class="card-text mb-4 small line-clamp-3" style="color: var(--text-muted-custom);">
                                        <c:out value="${item.content}"/>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/news?id=${item.notificationId}"
                                        class="mt-auto align-self-start text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 read-more-link"
                                        style="color: var(--primary-color); font-size: 14px;">
                                        Đọc thêm <i class="bi bi-arrow-right small read-more-icon" style="transition: transform 0.2s;"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <p class="text-muted">Chưa có tin tức nào được đăng tải.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</section>

<style>
    .read-more-link:hover .read-more-icon { transform: translateX(4px); }
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .line-clamp-3 {
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
</style>
