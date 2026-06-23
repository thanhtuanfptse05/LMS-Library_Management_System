<%-- Fragment: _section-reading.jsp — Currently Reading + Recommended Books (Bento layout) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- ── Currently Reading + Recommended (Bento Layout) ── -->
<div class="row g-4 mb-5">

    <!-- Currently Reading (8 cols) -->
    <div class="col-12 col-lg-8">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h2 class="fs-4 fw-bold mb-0 text-dark">Sách đang đọc</h2>
            <a href="${pageContext.request.contextPath}/student/loans"
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
            <h2 class="fs-4 fw-bold mb-0 text-dark">
                <c:choose>
                    <c:when test="${isAiPowered}">✨ Bạn có thể sẽ thích</c:when>
                    <c:otherwise>🔥 Sách phổ biến</c:otherwise>
                </c:choose>
            </h2>
            <a href="${pageContext.request.contextPath}/book-search"
               class="d-flex align-items-center text-decoration-none text-primary-custom">
                <span class="material-symbols-outlined">arrow_forward</span>
            </a>
        </div>

        <div class="raised-card p-4 d-flex flex-column">
            <p class="text-on-surface-variant small mb-4">
                <c:choose>
                    <c:when test="${isAiPowered}">
                        Lựa chọn cá nhân hóa dựa trên lịch sử mượn sách gần đây của bạn.
                    </c:when>
                    <c:otherwise>
                        Top những sách được mượn nhiều nhất tại thư viện.
                    </c:otherwise>
                </c:choose>
            </p>

            <div class="d-flex flex-column gap-3 flex-grow-1">
                <c:choose>
                    <c:when test="${not empty recommendedBooks}">
                        <c:forEach var="book" items="${recommendedBooks}" varStatus="status" end="3">
                            <div class="d-flex gap-3 align-items-start pb-2" style="border-bottom: 1px dashed var(--outline-variant); <c:if test='${status.last}'>border-bottom: none;</c:if>">
                                <!-- Book Cover (Left) -->
                                <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="flex-shrink-0" style="width: 70px; aspect-ratio: 2/3; overflow: hidden; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.08);">
                                    <img class="w-100 h-100"
                                         style="object-fit: cover;"
                                         src="${not empty book.imagePath ? book.imagePath : 'https://via.placeholder.com/70x105?text=No+Cover'}"
                                         alt="<c:out value='${book.title}'/>"
                                         onerror="this.src='https://via.placeholder.com/70x105?text=Không+Cover'" />
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
            </div>

            <a href="${pageContext.request.contextPath}/book-search"
               class="btn btn-outline-primary-custom w-100 rounded-3 py-2 mt-4 text-decoration-none d-block text-center">
                Khám phá thêm
            </a>
        </div>
    </div>
</div>
