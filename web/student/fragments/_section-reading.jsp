<%-- Fragment: _section-reading.jsp — Currently Reading + Recommended Books (Bento layout) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                            <img class="book-cover-img"
                                 src="${not empty loan.book.imagePath ? loan.book.imagePath : 'https://via.placeholder.com/96x144?text=No+Cover'}"
                                 alt="<c:out value='${loan.book.title}'/>"
                                 onerror="this.src='https://via.placeholder.com/96x144?text=Không+Cover'" />

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
                                    <a href="${pageContext.request.contextPath}/student/loans?action=renew&borrowRecordId=${loan.borrowRecordId}"
                                       class="btn btn-primary-custom flex-grow-1 btn-sm text-decoration-none d-block text-center rounded-3">
                                        Gia hạn
                                    </a>
                                    <a href="${pageContext.request.contextPath}/student/loans?action=return&borrowRecordId=${loan.borrowRecordId}"
                                       class="btn btn-light bg-surface-container-high text-dark flex-grow-1 btn-sm border-0 text-decoration-none d-block text-center rounded-3">
                                        Trả sách
                                    </a>
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

    <!-- Recommended Books (4 cols) -->
    <div class="col-12 col-lg-4">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h2 class="fs-4 fw-bold mb-0 text-dark" id="dash-rec-title">
                ✨ Đang tải gợi ý...
            </h2>
            <a href="${pageContext.request.contextPath}/book-search"
               class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                Xem tất cả
            </a>
        </div>

        <div class="raised-card p-4 d-flex flex-column" style="min-height: 400px;">
            <p class="text-on-surface-variant small mb-4" id="dash-rec-subtitle">
                Hệ thống đang tìm những cuốn sách phù hợp nhất cho bạn...
            </p>

            <div class="d-flex flex-column gap-3 flex-grow-1" id="dash-rec-container">
                <!-- Loader placeholder -->
                <div class="d-flex justify-content-center align-items-center flex-grow-1">
                    <div class="spinner-border text-primary-custom" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/book-search"
               class="btn btn-outline-primary-custom w-100 rounded-3 py-2 mt-4 text-decoration-none d-block text-center">
                Khám phá thêm
            </a>
        </div>
    </div>
</div>
