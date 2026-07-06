<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- Latest News Section (Full Categorized) -->
<section class="bg-container-low py-5" id="news">
    <style>
        .news-categories {
            border-bottom: 2px solid var(--surface-container-highest);
            padding-bottom: 0.75rem;
        }
        .news-category-btn {
            background: transparent;
            border: none;
            color: var(--secondary);
            font-weight: 600;
            font-size: 15px;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }
        .news-category-btn:hover {
            background-color: rgba(157, 67, 0, 0.05);
            color: var(--primary-color);
        }
        .news-category-btn.active {
            background-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(157, 67, 0, 0.25);
        }
        .news-pane {
            animation: newsFadeIn 0.4s ease-out forwards;
        }
        @keyframes newsFadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
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

    <div class="container-xl py-3">
        <div class="mb-4">
            <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">Cập nhật</span>
            <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Tin tức Thư viện &amp; Sự kiện</h2>
        </div>

        <!-- News Categories Navigation -->
        <div class="news-categories d-flex flex-wrap gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/news" class="news-category-btn ${empty activeType ? 'active' : ''}">
                Tất cả
            </a>
            <a href="${pageContext.request.contextPath}/news?type=general" class="news-category-btn ${activeType == 'general' ? 'active' : ''}">
                Tin tức
            </a>
            <a href="${pageContext.request.contextPath}/news?type=event" class="news-category-btn ${activeType == 'event' ? 'active' : ''}">
                Sự kiện
            </a>
        </div>

        <!-- Content Area -->
        <div class="news-content">
            <div class="news-pane active">
                <c:choose>
                    <c:when test="${not empty newsList}">
                        <div class="row g-4 row-cols-1 row-cols-md-3">
                            <c:forEach var="item" items="${newsList}">
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
                        </div>
                        
                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-center mt-5">
                                <ul class="pagination pagination-sm mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/news?page=${currentPage - 1}${not empty activeType ? '&type='.concat(activeType) : ''}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/news?page=${p}${not empty activeType ? '&type='.concat(activeType) : ''}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/news?page=${currentPage + 1}${not empty activeType ? '&type='.concat(activeType) : ''}">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:if>

                    </c:when>
                    <c:otherwise>
                        <div class="row g-4 justify-content-center">
                            <div class="col-12 col-md-8 text-center py-5">
                                <div class="p-5 bg-white rounded-3 shadow-sm border border-outline-variant">
                                    <span class="material-symbols-outlined text-muted" style="font-size: 56px;">article</span>
                                    <h4 class="fw-bold mt-3 mb-2 text-dark">Chưa có bài viết nào</h4>
                                    <p class="text-muted mx-auto mb-0" style="max-width: 450px;">
                                        Hiện tại chưa có tin tức hoặc sự kiện nào trong thư mục này. Vui lòng quay lại sau!
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>
