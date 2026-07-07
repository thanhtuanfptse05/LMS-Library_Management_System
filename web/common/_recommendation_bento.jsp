<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Unified Recommendation UI Metadata -->
<div id="ai-recommendation-metadata" data-is-ai-powered="${isAiPowered}" style="display: none;"></div>

<c:choose>
    <c:when test="${not empty recommendedBooks}">
        <c:forEach var="book" items="${recommendedBooks}" varStatus="status" end="3">
            <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant); <c:if test='${status.last}'>border-bottom: none;</c:if>">
                <!-- Book Cover (Left) -->
                <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                    <c:choose>
                        <c:when test="${not empty book.imagePath}">
                            <c:choose>
                                <c:when test="${fn:startsWith(book.imagePath, 'http://') or fn:startsWith(book.imagePath, 'https://')}">
                                    <img class="w-100 h-100" style="object-fit: cover;" src="<c:out value="${book.imagePath}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                </c:when>
                                <c:otherwise>
                                    <img class="w-100 h-100" style="object-fit: cover;" src="${pageContext.request.contextPath}/book-images/<c:out value="${book.imagePath}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <img class="w-100 h-100" style="object-fit: cover;" src="${pageContext.request.contextPath}/assets/images/book-placeholder.jpg" alt="Bìa sách <c:out value="${book.title}"/>">
                        </c:otherwise>
                    </c:choose>
                </a>
                <!-- Book Details (Right) -->
                <div class="flex-grow-1" style="min-width: 0;">
                    <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="text-decoration-none">
                        <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;" title="<c:out value="${book.title}"/>">
                            <c:out value="${book.title}"/>
                        </h4>
                    </a>
                    <p class="text-on-surface-variant mb-1 text-truncate" style="font-size: 11px;">
                        bởi <c:out value="${book.author}"/>
                    </p>
                    <c:if test="${not empty recommendationReasons[book.bookId]}">
                        <div class="mt-1 p-2 rounded-2" style="background-color: rgba(217, 119, 6, 0.05); border: 1px solid rgba(217, 119, 6, 0.12);">
                            <p class="mb-0 text-wrap" style="font-size: 10px; line-height: 1.3; color: #d97706; font-style: italic;">
                                <i class="bi bi-lightbulb-fill"></i> <c:out value="${recommendationReasons[book.bookId]}"/>
                            </p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- Static demo books when no data from backend -->
        <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant);">
            <div class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                <img class="w-100 h-100" style="object-fit: cover;"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuBMFaVW8gTn8EGwb-vQRwM3JIZyEnvL4u-pKdL9yAZI-65Sq20ui2J-YMxpmEQOIOItZ86Bb6qOy6ZHcJqxaBjOR7EiGfP3wN6f34O9qupHmW6PAzhLDZm55ZWdHpAA3eI2LIgqt14BulT3mmBjFMT4L_m5P9IpdHI7_wdObtdNoxFA2EwEkKHAluhqx1igHxiCyM9nziAdt0p4kaDI-fi8LcMROKQu8cZOdqK24sSvC2AV1vBng6cYyCapNf6EWmoY_hwUZXOxIYtS"
                     alt="Thinking with Type" />
            </div>
            <div class="flex-grow-1" style="min-width: 0;">
                <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;">Thinking with Type</h4>
                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">bởi E. Lupton</p>
            </div>
        </div>
        <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant);">
            <div class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                <img class="w-100 h-100" style="object-fit: cover;"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuAvmHj56MbiSMwWUZ3XWu4-2rqNDuhPvt4Y6oCnTn7lGqCTOiE5BvqH0bZQS9LY0io_T8ayyDjfQXVaVnnFW-YANKwbZ329jVi3DrMxvwV7sHIl3d4YUEHVssxUE8e5VWDpyWSjWScrecfslefdeYXYEhz_RxXGddoqaCQqSevroSqz8wwifuS8PatY0uE7Xovp-hK7wxTPDxL_zul_KymBk0awiT2rBmB1SptJPZB2rlyEwzZj5jqvpdfUiHbJTCskRE_l4k3RgDIx"
                     alt="Universal Principles" />
            </div>
            <div class="flex-grow-1" style="min-width: 0;">
                <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;">Universal Principles</h4>
                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">bởi W. Lidwell</p>
            </div>
        </div>
        <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant);">
            <div class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                <img class="w-100 h-100" style="object-fit: cover;"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuAJpYUg7vrYH3geQVG1-5zncrdHXnCIjw5Qd-Ai0B-Lr_uWQHrlzaX3UFdvsg2jHA1rZs7z45MV-3movSZYXhxDHaRLCmJl1xEdtNKLPgEw36TOL9sL_mfTetQR3ejrzv4brXtwvE9N4DCzlsfNroao1nalEA_wE9S7Z9poDtnxdRB9aJ2DnJp2IhoPkw55gAmKATBTLkapLhzvLAEyIREEk252tap1yiv6mziSVxv5fUnD8lddLsv4u4VB-cKxe8wSP-J79gOjJ_X_"
                     alt="Interaction Design" />
            </div>
            <div class="flex-grow-1" style="min-width: 0;">
                <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;">Interaction Design</h4>
                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">bởi J. Preece</p>
            </div>
        </div>
        <div class="d-flex gap-3 align-items-start pb-2">
            <div class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                <img class="w-100 h-100" style="object-fit: cover;"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuCzcoyrJvKjZ8-93QWy-1N0tVZQ_A543LikcO7FZ9PFjB185C7t6xtUi7-5uN812BfCa4m1IUqWXoRYimsivBtM3PLeDrjlYOEUSILcuYpL_MMncRmV1gdn3n2jCJohPu69tgP4ubaYwPm1ENfBAGV8qgWoPJPnzRbR0RZXx7zTTN82YM8OmmCZd9Y2PRWjv7ad8UtLcItP-2HlCt3SzYqj2xf6DdYan0u85Z7SAND8S_sqYY7PsCkhNSi7EjuIFHzBoullSfkq2GJL"
                     alt="AI in Practice" />
            </div>
            <div class="flex-grow-1" style="min-width: 0;">
                <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;">AI in Practice</h4>
                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">bởi M. Nielsen</p>
            </div>
        </div>
    </c:otherwise>
</c:choose>
