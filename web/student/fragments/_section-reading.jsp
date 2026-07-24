<%-- Fragment: _section-reading.jsp — Currently Reading + Recommended Books (Bento layout) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- ── Currently Reading + Recommended (Bento Layout) ── -->
<div class="row g-4 mb-5">

    <!-- Currently Reading (8 cols) -->
    <div class="col-12 col-lg-8">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h2 class="fs-4 fw-bold mb-0 text-dark">Sách đang đọc</h2>
            <a href="${pageContext.request.contextPath}/student/my-borrowings"
               class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                Xem tất cả
            </a>
        </div>

        <div class="d-flex flex-column gap-4">
            <c:choose>
                <c:when test="${not empty activeLoans}">
                    <c:forEach var="loan" items="${activeLoans}" end="2">
                        <div class="raised-card p-4 d-flex flex-column flex-sm-row gap-4">
                            <!-- Book Cover -->
                            <c:choose>
                                <c:when test="${not empty loan.book.imagePath}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(loan.book.imagePath, 'http://') or fn:startsWith(loan.book.imagePath, 'https://')}">
                                            <img class="book-cover-img" src="<c:out value='${loan.book.imagePath}'/>" alt="<c:out value='${loan.book.title}'/>" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg';" />
                                        </c:when>
                                        <c:otherwise>
                                            <img class="book-cover-img" src="${pageContext.request.contextPath}/book-images/<c:out value='${loan.book.imagePath}'/>" alt="<c:out value='${loan.book.title}'/>" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg';" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img class="book-cover-img" src="${pageContext.request.contextPath}/assets/images/book-placeholder.jpg" alt="<c:out value='${loan.book.title}'/>" />
                                </c:otherwise>
                            </c:choose>

                            <div class="flex-grow-1 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex align-items-start justify-content-between flex-wrap gap-2">
                                        <div>
                                            <h3 class="fs-5 fw-bold mb-1 text-dark">
                                                <c:out value="${loan.book.title}"/>
                                            </h3>
                                            <p class="text-on-surface-variant small mb-0">
                                                bởi <c:out value="${loan.book.author}"/> &bull;
                                                Đã mượn <fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy"/>
                                            </p>
                                        </div>
                                        <!-- Due date badge -->
                                        <c:choose>
                                            <c:when test="${loan.status eq 'overdue'}">
                                                <span class="badge badge-overdue text-uppercase px-2 py-1" style="font-size: 10px;">Quá hạn</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-borrowed text-uppercase px-2 py-1" style="font-size: 10px;">
                                                    Đến hạn <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Progress Bar (placeholder — no actual reading tracker in DB) -->
                                    <div class="mt-4">
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span class="text-on-surface-variant">Trạng thái mượn</span>
                                            <span class="text-primary-custom fw-bold">
                                                <c:choose>
                                                    <c:when test="${loan.status eq 'overdue'}">Quá hạn</c:when>
                                                    <c:otherwise>Đang mượn</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="progress" style="height: 6px;">
                                            <div class="progress-bar bg-primary-custom"
                                                 role="progressbar"
                                                 style="width: ${loan.status eq 'overdue' ? '100' : '60'}%;"
                                                 aria-valuenow="${loan.status eq 'overdue' ? '100' : '60'}"
                                                 aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action buttons -->
                                <div class="d-flex gap-3 mt-4">
                                    <form action="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/renew" method="post" class="flex-grow-1 m-0">
                                        <input type="hidden" name="borrowRecordId" value="${loan.borrowRecordId}">
                                        <button type="submit" class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3" ${loan.extensionCount >= 3 ? 'disabled' : ''}>
                                            Gia hạn
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-light bg-surface-container-high text-dark flex-grow-1 btn-sm border-0 text-decoration-none d-block text-center rounded-3" onclick="alert('Vui lòng mang sách đến quầy thư viện để thực hiện trả sách.')">
                                        Trả sách
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Empty state -->
                    <div class="raised-card p-5 text-center">
                        <span class="material-symbols-outlined text-on-surface-variant d-block mb-3"
                              style="font-size: 48px; opacity: 0.4;">library_books</span>
                        <p class="fw-semibold text-on-surface-variant mb-2">Không có sách mượn</p>
                        <p class="small text-on-surface-variant mb-4">Truy cập danh mục để khám phá và mượn sách.</p>
                        <a href="${pageContext.request.contextPath}/book-search"
                           class="btn btn-primary-custom btn-sm px-4 rounded-3 text-decoration-none">
                            Duyệt danh mục
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Popular Books (4 cols) -->
    <div class="col-12 col-lg-4">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h2 class="fs-4 fw-bold mb-0 text-dark">
                🔥 Sách phổ biến
            </h2>
            <a href="${pageContext.request.contextPath}/book-search"
               class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                Xem tất cả
            </a>
        </div>

        <div class="raised-card p-4 d-flex flex-column" style="min-height: 400px;">
            <p class="text-on-surface-variant small mb-4">
                Top những sách được mượn nhiều nhất tại thư viện.
            </p>

            <div class="d-flex flex-column gap-3 flex-grow-1">
                <c:choose>
                    <c:when test="${not empty topBooks}">
                        <c:forEach var="book" items="${topBooks}" varStatus="status" end="4">
                            <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant); <c:if test='${status.last}'>border-bottom: none;</c:if>">
                                <!-- Book Cover -->
                                <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="flex-shrink-0" style="width: 60px; aspect-ratio: 2/3; overflow: hidden; border-radius: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                                    <c:choose>
                                        <c:when test="${not empty book.imagePath}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(book.imagePath, 'http://') or fn:startsWith(book.imagePath, 'https://')}">
                                                    <img class="w-100 h-100" style="object-fit: cover;" src="<c:out value='${book.imagePath}'/>" alt="Bìa sách" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="w-100 h-100" style="object-fit: cover;" src="${pageContext.request.contextPath}/book-images/<c:out value='${book.imagePath}'/>" alt="Bìa sách" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img class="w-100 h-100" style="object-fit: cover;" src="${pageContext.request.contextPath}/assets/images/book-placeholder.jpg" alt="Bìa sách">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <!-- Book Details -->
                                <div class="flex-grow-1" style="min-width: 0;">
                                    <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="text-decoration-none">
                                        <h4 class="fw-bold text-dark mb-1 text-truncate" style="font-size: 13px; line-height: 1.4;" title="<c:out value='${book.title}'/>">
                                            <c:out value="${book.title}"/>
                                        </h4>
                                    </a>
                                    <p class="text-on-surface-variant mb-0 text-truncate" style="font-size: 11px;">
                                        bởi <c:out value="${book.author}"/>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small">Chưa có dữ liệu sách phổ biến.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <a href="${pageContext.request.contextPath}/book-search"
               class="btn btn-outline-primary-custom w-100 rounded-3 py-2 mt-4 text-decoration-none d-block text-center">
                Khám phá thêm
            </a>
        </div>
    </div>
</div>
