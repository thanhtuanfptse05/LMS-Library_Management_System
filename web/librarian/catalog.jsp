<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Catalog Management ── */

    /* Search input */
    .search-wrapper { position: relative; flex-grow: 1; }
    .search-wrapper .search-icon {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--on-surface-variant);
        font-size: 20px;
        pointer-events: none;
    }
    .search-wrapper input {
        width: 100%;
        padding: 10px 14px 10px 44px;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 0.625rem;
        font-size: 14px;
        color: var(--on-surface);
        transition: border-color 0.15s, box-shadow 0.15s, background-color 0.15s;
    }
    .search-wrapper input:focus {
        outline: none;
        background-color: var(--surface-container-lowest);
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
    }

    /* Category select */
    .cat-select {
        width: 100%;
        padding: 10px 14px;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 0.625rem;
        font-size: 14px;
        color: var(--on-surface);
        cursor: pointer;
        transition: border-color 0.15s;
    }
    .cat-select:focus {
        outline: none;
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
    }

    /* Filter tag pills */
    .filter-pill-label {
        color: var(--on-surface-variant);
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 999px;
        padding: 5px 14px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.15s ease;
        user-select: none;
        display: inline-block;
    }
    .filter-pill-label:hover {
        background-color: var(--surface-container-low);
    }
    .btn-check:checked + .filter-pill-label {
        background-color: var(--primary-fixed);
        color: var(--on-primary-container);
        border-color: var(--primary-fixed-dim);
    }

    /* Book thumbnail in table */
    .book-thumb-sm {
        width: 28px;
        min-width: 28px;
        height: 42px;
        border-radius: 3px;
        overflow: hidden;
        background-color: var(--surface-container-high);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .book-thumb-sm img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    /* ISBN monospace */
    .isbn-text {
        font-family: 'Courier New', Courier, monospace;
        font-size: 12px;
        color: var(--on-surface-variant);
        letter-spacing: 0.02em;
    }

    /* Quantity badges */
    .qty-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 36px;
        padding: 2px 8px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 700;
    }
    .qty-ok   { background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant); }
    .qty-low  { background-color: var(--error-container); color: var(--on-error-container); }
    .qty-zero { background-color: var(--surface-container-high); color: var(--on-surface-variant); }

    /* Pagination buttons */
    .page-btn {
        min-width: 32px;
        height: 32px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid var(--outline-variant);
        background-color: var(--surface-container-low);
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.15s ease;
        padding: 0 8px;
    }
    .page-btn:hover:not(:disabled) {
        background-color: var(--surface-container);
        color: var(--on-surface);
    }
    .page-btn.active {
        background-color: var(--primary);
        color: #fff;
        border-color: var(--primary);
    }
    .page-btn:disabled { opacity: 0.4; cursor: not-allowed; }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto" style="background-color: var(--background); margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <%-- ─── Flash Messages ─── --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <%-- ─── Page Header ─── --%>
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 gap-3">
                    <div>
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Quản lý mục lục sách</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Quản lý kho, cập nhật hồ sơ và thêm sách mới.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/librarian/book-register.jsp"
                       class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-inline-flex align-items-center gap-1"
                       style="height: 40px; text-decoration: none;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">add_circle</span>
                        Thêm sách mới
                    </a>
                </div>

                <%-- ─── Filter & Search Card ─── --%>
                <form action="${pageContext.request.contextPath}/librarian/catalog" method="GET"
                      id="filterSearchForm" class="raised-card p-4 mb-4">

                    <div class="row g-3 mb-3">
                        <%-- Search --%>
                        <div class="col-12 col-lg-8 col-md-7">
                            <div class="search-wrapper">
                                <span class="material-symbols-outlined search-icon">search</span>
                                <input type="text" id="catalogSearch" name="q"
                                       placeholder="Tìm kiếm theo ISBN, Tiêu đề hoặc Tác giả..."
                                       aria-label="Search catalog"
                                       value="<c:out value='${param.q}'/>" />
                            </div>
                        </div>
                        <%-- Category filter --%>
                        <div class="col-12 col-lg-4 col-md-5">
                            <select class="cat-select" name="category" id="categoryFilter"
                                    onchange="document.getElementById('filterSearchForm').submit()">
                                <option value="">Tất cả thể loại</option>
                                <c:choose>
                                    <c:when test="${not empty categories}">
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="<c:out value='${cat.categoryId}'/>"
                                                    ${param.category == cat.categoryId ? 'selected' : ''}>
                                                <c:out value="${cat.categoryName}" />
                                            </option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="cs"  ${param.category == 'cs'  ? 'selected' : ''}>Khoa học Máy tính</option>
                                        <option value="lit" ${param.category == 'lit' ? 'selected' : ''}>Văn học</option>
                                        <option value="sci" ${param.category == 'sci' ? 'selected' : ''}>Khoa học Vật lý</option>
                                        <option value="ref" ${param.category == 'ref' ? 'selected' : ''}>Tham khảo</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                    </div>

                    <%-- Tag filter pills --%>
                    <div class="pt-3" style="border-top: 1px solid var(--outline-variant);">
                        <div class="d-flex flex-wrap align-items-center gap-2">
                            <span style="font-size: 12px; font-weight: 700; color: var(--on-surface-variant); text-transform: uppercase; letter-spacing: 0.06em; margin-right: 4px;">Bộ lọc:</span>

                            <input type="checkbox" class="btn-check" id="tagAvailable" name="tag" value="available" autocomplete="off"
                                   ${param.tag == 'available' ? 'checked' : ''} onchange="document.getElementById('filterSearchForm').submit()">
                            <label class="filter-pill-label" for="tagAvailable">Sẵn có</label>

                            <input type="checkbox" class="btn-check" id="tagLowStock" name="tag" value="low_stock" autocomplete="off"
                                   ${param.tag == 'low_stock' ? 'checked' : ''} onchange="document.getElementById('filterSearchForm').submit()">
                            <label class="filter-pill-label" for="tagLowStock">Sắp hết</label>

                            <input type="checkbox" class="btn-check" id="tagNewArrivals" name="tag" value="new_arrival" autocomplete="off"
                                   ${param.tag == 'new_arrival' ? 'checked' : ''} onchange="document.getElementById('filterSearchForm').submit()">
                            <label class="filter-pill-label" for="tagNewArrivals">Sách mới</label>

                            <input type="checkbox" class="btn-check" id="tagReference" name="tag" value="reference_only" autocomplete="off"
                                   ${param.tag == 'reference_only' ? 'checked' : ''} onchange="document.getElementById('filterSearchForm').submit()">
                            <label class="filter-pill-label" for="tagReference">Chỉ tham khảo</label>

                            <c:if test="${not empty param.q or not empty param.category or not empty param.tag}">
                                <a href="${pageContext.request.contextPath}/librarian/catalog.jsp"
                                   class="text-decoration-none fw-semibold"
                                   style="font-size: 12px; color: var(--on-surface-variant); margin-left: 4px;">
                                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">close</span>
                                    Xóa bộ lọc
                                </a>
                            </c:if>
                        </div>
                    </div>

                </form>

                <%-- ─── Catalog Table ─── --%>
                <section class="raised-card overflow-hidden mb-5">
                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Book catalog">
                            <thead>
                                <tr>
                                    <th style="width: 150px;">ISBN</th>
                                    <th>Tiêu đề</th>
                                    <th>Tác giả</th>
                                    <th class="text-end" style="width: 140px;">Giá (VNĐ)</th>
                                    <th class="text-center" style="width: 80px;">SL</th>
                                    <th class="text-center" style="width: 100px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty books}">
                                        <c:forEach var="book" items="${books}">
                                            <tr>
                                                <td><span class="isbn-text"><c:out value="${book.isbn}" /></span></td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="book-thumb-sm">
                                                            <c:choose>
                                                                <c:when test="${not empty book.coverImageUrl}">
                                                                    <img src="${pageContext.request.contextPath}/<c:out value='${book.coverImageUrl}'/>"
                                                                         alt="<c:out value='${book.title}'/>" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">book</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <span class="fw-semibold" style="font-size: 13px;">
                                                            <c:out value="${book.title}" />
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="text-on-surface-variant" style="font-size: 13px;">
                                                    <c:out value="${book.author}" />
                                                </td>
                                                <td class="text-end fw-semibold" style="font-size: 13px;">
                                                    <c:choose>
                                                        <c:when test="${not empty book.replacementPrice}">
                                                            <fmt:formatNumber value="${book.replacementPrice}" type="number" maxFractionDigits="0" />
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${book.availableCopies == 0}">
                                                            <span class="qty-badge qty-zero"><c:out value="${book.availableCopies}" /></span>
                                                        </c:when>
                                                        <c:when test="${book.availableCopies <= 3}">
                                                            <span class="qty-badge qty-low"><c:out value="${book.availableCopies}" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="qty-badge qty-ok"><c:out value="${book.availableCopies}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${book.bookId}'/>"
                                                       class="btn-icon" title="Xem chi tiết">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp?id=<c:out value='${book.bookId}'/>"
                                                       class="btn-icon" title="Sửa bản ghi">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Static sample rows --%>
                                        <tr>
                                            <td><span class="isbn-text">978-0134685991</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="book-thumb-sm"><span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">book</span></div>
                                                    <span class="fw-semibold" style="font-size: 13px;">Effective Java</span>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Joshua Bloch</td>
                                            <td class="text-end fw-semibold" style="font-size: 13px;">1.250.000</td>
                                            <td class="text-center"><span class="qty-badge qty-ok">12</span></td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp" class="btn-icon" title="Xem chi tiết"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp" class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="isbn-text">978-0201633610</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="book-thumb-sm"><span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">book</span></div>
                                                    <span class="fw-semibold" style="font-size: 13px;">Design Patterns: Elements of Reusable Object-Oriented Software</span>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Erich Gamma et al.</td>
                                            <td class="text-end fw-semibold" style="font-size: 13px;">1.400.000</td>
                                            <td class="text-center"><span class="qty-badge qty-low">2</span></td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp" class="btn-icon" title="Xem chi tiết"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp" class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="isbn-text">978-0132350884</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="book-thumb-sm"><span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">book</span></div>
                                                    <span class="fw-semibold" style="font-size: 13px;">Clean Code</span>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Robert C. Martin</td>
                                            <td class="text-end fw-semibold" style="font-size: 13px;">950.000</td>
                                            <td class="text-center"><span class="qty-badge qty-ok">24</span></td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp" class="btn-icon" title="Xem chi tiết"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp" class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="isbn-text">978-1449331818</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="book-thumb-sm"><span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">book</span></div>
                                                    <span class="fw-semibold" style="font-size: 13px;">Learning Python</span>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Mark Lutz</td>
                                            <td class="text-end fw-semibold" style="font-size: 13px;">1.650.000</td>
                                            <td class="text-center"><span class="qty-badge qty-zero">0</span></td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp" class="btn-icon" title="Xem chi tiết"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp" class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- ─── Pagination ─── --%>
                    <div class="d-flex align-items-center justify-content-between px-4 py-3"
                         style="border-top: 1px solid var(--outline-variant); background-color: var(--surface-container-lowest);">
                        <span style="font-size: 13px; color: var(--on-surface-variant);">
                            <c:choose>
                                <c:when test="${not empty totalBooks}">
                                    Hiển thị
                                    <c:out value="${(currentPage - 1) * pageSize + 1}" /> –
                                    <c:out value="${currentPage * pageSize > totalBooks ? totalBooks : currentPage * pageSize}" />
                                    của <c:out value="${totalBooks}" /> bản ghi
                                </c:when>
                                <c:otherwise>Hiển thị 1 – 4 của 248 bản ghi</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="d-flex gap-1 align-items-center">
                            <button class="page-btn" ${currentPage <= 1 ? 'disabled' : ''}
                                    onclick="goToPage(${currentPage - 1})"
                                    aria-label="Previous page">
                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_left</span>
                            </button>
                            <c:choose>
                                <c:when test="${not empty totalPages}">
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <button class="page-btn ${p == currentPage ? 'active' : ''}"
                                                onclick="goToPage(${p})"
                                                aria-label="Page ${p}"
                                                aria-current="${p == currentPage ? 'page' : 'false'}">
                                            <c:out value="${p}" />
                                        </button>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <button class="page-btn active" aria-current="page">1</button>
                                    <button class="page-btn" onclick="goToPage(2)">2</button>
                                    <button class="page-btn" onclick="goToPage(3)">3</button>
                                    <span class="page-btn" style="cursor:default;border:none;background:none;color:var(--on-surface-variant);">…</span>
                                    <button class="page-btn" onclick="goToPage(62)">62</button>
                                </c:otherwise>
                            </c:choose>
                            <button class="page-btn" ${currentPage >= totalPages ? 'disabled' : ''}
                                    onclick="goToPage(${currentPage + 1})"
                                    aria-label="Next page">
                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_right</span>
                            </button>
                        </div>
                    </div>

                </section>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';

            /* ── Search with debounce (submit form on pause) ── */
            const searchInput = document.getElementById('catalogSearch');
            if (searchInput) {
                let debounceTimer;
                searchInput.addEventListener('input', function () {
                    clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        document.getElementById('filterSearchForm').submit();
                    }, 500);
                });
            }

            /* ── Server-side pagination (preserves current filters) ── */
            function goToPage(page) {
                const url = new URL(window.location.href);
                url.searchParams.set('page', page);
                window.location.href = url.toString();
            }

            window.goToPage = goToPage;

        })();
    </script>

</body>
</html>
