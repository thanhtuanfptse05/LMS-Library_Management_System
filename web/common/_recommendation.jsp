<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .ai-card {
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        border-radius: 0.75rem;
        border: 1px solid var(--surface-container-high);
        background-color: var(--surface-lowest);
        height: 100%;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    }

    .ai-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.08);
        border-color: var(--primary-color);
    }

    .ai-book-img-wrapper {
        height: 200px;
        background-color: var(--surface-container-low);
        border-radius: 0.75rem 0.75rem 0 0;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .ai-book-img-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .ai-badge {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
</style>

<!-- Unified Recommendation UI -->
<c:choose>
    <c:when test="${not empty recommendedBooks}">
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-5 g-4">
            <c:forEach var="book" items="${recommendedBooks}">
                <div class="col">
                    <div class="ai-card d-flex flex-column">
                        <div class="ai-book-img-wrapper">
                            <c:choose>
                                <c:when test="${not empty book.coverImage}">
                                    <img src="<c:out value="${book.coverImage}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column align-items-center justify-content-center h-100 w-100" style="color: var(--text-muted-custom);">
                                        <i class="bi bi-book" style="font-size: 32px;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="card-body p-3 d-flex flex-column flex-grow-1">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <c:choose>
                                    <c:when test="${book.availableQuantity > 0}">
                                        <span class="badge rounded-pill bg-success bg-opacity-10 text-success ai-badge px-2 py-1">Sẵn sàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger ai-badge px-2 py-1">Đang mượn</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <h6 class="fw-bold text-truncate-2 mt-1 mb-1" style="color: var(--bs-body-color); line-height: 1.4;" title="<c:out value="${book.title}"/>">
                                <c:out value="${book.title}"/>
                            </h6>
                            
                            <p class="mb-3" style="font-size: 12px; color: var(--text-muted-custom); text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                                <c:out value="${book.author}"/>
                            </p>
                            
                            <div class="mt-auto pt-2" style="border-top: 1px solid var(--surface-container-high);">
                                <a href="${pageContext.request.contextPath}/student/book-detail?id=${book.bookId}" class="btn btn-sm btn-outline-secondary w-100 fw-bold" style="font-size: 12px;">
                                    Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center p-4 rounded-3" style="background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant);">
            <i class="bi bi-robot fs-1 mb-2" style="color: var(--text-muted-custom);"></i>
            <p class="fw-medium mb-0" style="color: var(--text-muted-custom);">Hiện chưa có gợi ý nào dành cho bạn.</p>
        </div>
    </c:otherwise>
</c:choose>
