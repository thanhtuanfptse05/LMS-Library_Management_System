<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/_head.jsp" />
<body class="d-flex flex-column min-vh-100 bg-container-low">

    <jsp:include page="common/_header.jsp" />

    <main class="flex-grow-1" style="padding-top: 20px;">
        <div class="container-xl py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <!-- Back Button -->
                    <a href="${pageContext.request.contextPath}/news" class="text-decoration-none text-muted mb-4 d-inline-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>

                    <!-- Article Header -->
                    <div class="mb-4 mt-3">
                        <span class="badge bg-primary bg-opacity-10 text-primary mb-3 px-3 py-2 rounded-pill fw-medium">
                            <c:choose>
                                <c:when test="${newsDetail.type == 'event'}">Sự kiện</c:when>
                                <c:otherwise>Tin tức</c:otherwise>
                            </c:choose>
                        </span>
                        <h1 class="fw-bold mb-3" style="font-size: 36px; line-height: 1.3;"><c:out value="${newsDetail.title}" /></h1>
                        <div class="text-muted d-flex align-items-center gap-3" style="font-size: 14px;">
                            <span class="d-flex align-items-center gap-1">
                                <i class="bi bi-calendar3"></i> 
                                <fmt:formatDate value="${newsDetail.createdAt}" pattern="dd 'tháng' MM, yyyy HH:mm" />
                            </span>
                        </div>
                    </div>

                    <!-- Main Image -->
                    <c:if test="${not empty newsDetail.thumbnailUrl}">
                        <div class="rounded-4 overflow-hidden mb-5 shadow-sm" style="max-height: 400px;">
                            <img src="${newsDetail.thumbnailUrl}" class="w-100 h-100 object-fit-cover" alt="Article image">
                        </div>
                    </c:if>

                    <!-- Article Content -->
                    <div class="article-content fs-5" style="line-height: 1.8; color: var(--bs-body-color); white-space: pre-line;">
                        <c:out value="${newsDetail.content}" />
                    </div>

                    <hr class="my-5 opacity-10">

                    <!-- Related News -->
                    <c:if test="${not empty relatedNews}">
                        <h3 class="fw-bold mb-4 fs-4">Bài viết liên quan</h3>
                        <div class="row g-4">
                            <c:forEach var="item" items="${relatedNews}">
                                <div class="col-md-6">
                                    <div class="card h-100 border-0 shadow-sm card-hover" style="cursor: pointer;"
                                         onclick="window.location.href='${pageContext.request.contextPath}/news?id=${item.notificationId}'">
                                        <div class="card-body p-4">
                                            <span class="text-primary small fw-medium mb-2 d-block">
                                                <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy" />
                                            </span>
                                            <h5 class="fw-semibold mb-3 fs-6 line-clamp-2"><c:out value="${item.title}" /></h5>
                                            <p class="text-muted small mb-0 line-clamp-2"><c:out value="${item.content}" /></p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/_footer.jsp" />

    <style>
        .article-content img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin: 1.5rem 0;
        }
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</body>
</html>
