<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Copy List ── */

    /* Search input */
    .search-wrapper { position: relative; }
    .search-wrapper .search-icon {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--on-surface-variant);
        font-size: 20px;
        pointer-events: none;
    }
    .search-wrapper input {
        padding-left: 42px;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 0.5rem;
        font-size: 14px;
        color: var(--on-surface);
        height: 40px;
        width: 260px;
    }
    .search-wrapper input:focus {
        outline: none;
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
        background-color: var(--surface-container-lowest);
    }

    /* Stat cards */
    .stat-icon-wrap {
        width: 44px;
        height: 44px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .stat-label {
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        color: var(--on-surface-variant);
        margin-bottom: 2px;
    }
    .stat-value {
        font-size: 24px;
        font-weight: 700;
        color: var(--on-surface);
        line-height: 1.1;
    }

    /* Copy thumbnail */
    .copy-thumb {
        width: 40px;
        min-width: 40px;
        height: 56px;
        border-radius: 4px;
        overflow: hidden;
        background-color: var(--surface-container-high);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .copy-thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    /* Barcode monospace chip */
    .barcode-text {
        font-family: 'Courier New', Courier, monospace;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 0.03em;
        color: var(--on-surface);
    }

    /* Status + condition stacked badges */
    .status-available  { color: #059669; background-color: #d1fae5; }
    .status-borrowed   { color: var(--on-primary-container); background-color: var(--primary-fixed); }
    .status-reserved   { color: #d97706; background-color: #fef3c7; }
    .status-lost       { color: var(--on-error-container); background-color: var(--error-container); }
    .status-maintenance{ color: var(--on-surface-variant); background-color: var(--surface-container-high); }

    .cond-good    { color: #059669; border-color: #6ee7b7; background: transparent; }
    .cond-fair    { color: #d97706; border-color: #fcd34d; background: transparent; }
    .cond-damaged { color: var(--error); border-color: var(--error); background: transparent; }
    .cond-new     { color: var(--on-tertiary-fixed-variant); border-color: var(--tertiary-fixed); background: transparent; }
    .cond-lost    { color: var(--error); border-color: var(--error); background: transparent; }

    .cond-badge {
        display: inline-block;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.05em;
        text-transform: uppercase;
        border: 1px solid;
    }

    /* Pagination */
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
    .page-btn:disabled {
        opacity: 0.4;
        cursor: not-allowed;
    }
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
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <%-- ─── Page Header ─── --%>
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3 flex-wrap">
                    <div>
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Physical Copies</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Manage and track individual book copies across all locations.</p>
                    </div>
                    <div class="d-flex flex-column flex-sm-row align-items-sm-center gap-2">
                        <%-- Search --%>
                        <div class="search-wrapper">
                            <span class="material-symbols-outlined search-icon">search</span>
                            <input type="text" id="copySearchInput" placeholder="Search barcode or title..."
                                   aria-label="Search copies by barcode or title"
                                   value="<c:out value='${param.q}'/>" />
                        </div>
                        <%-- Filter --%>
                        <button class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                                style="height: 40px; background-color: var(--surface-container-low); color: var(--on-surface); border: 1px solid var(--outline-variant);"
                                data-bs-toggle="modal" data-bs-target="#filterModal"
                                id="btnFilter">
                            <span class="material-symbols-outlined" style="font-size: 18px;">filter_list</span>
                            Filter
                        </button>
                    </div>
                </div>

                <%-- ─── Stats Row ─── --%>
                <div class="row g-3 mb-4">
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="raised-card d-flex align-items-center gap-3 p-3">
                            <div class="stat-icon-wrap" style="background-color: var(--primary-fixed); color: var(--primary);">
                                <span class="material-symbols-outlined" style="font-size: 24px; font-variation-settings: 'FILL' 1;">library_books</span>
                            </div>
                            <div>
                                <p class="stat-label mb-0">Total Copies</p>
                                <p class="stat-value mb-0">
                                    <c:out value="${not empty totalCopies ? totalCopies : '12,450'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="raised-card d-flex align-items-center gap-3 p-3">
                            <div class="stat-icon-wrap" style="background-color: var(--error-container); color: var(--error);">
                                <span class="material-symbols-outlined" style="font-size: 24px; font-variation-settings: 'FILL' 1;">warning</span>
                            </div>
                            <div>
                                <p class="stat-label mb-0">Needs Repair</p>
                                <p class="stat-value mb-0">
                                    <c:out value="${not empty needsRepairCount ? needsRepairCount : '84'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="raised-card d-flex align-items-center gap-3 p-3">
                            <div class="stat-icon-wrap" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">
                                <span class="material-symbols-outlined" style="font-size: 24px; font-variation-settings: 'FILL' 1;">shopping_bag</span>
                            </div>
                            <div>
                                <p class="stat-label mb-0">Checked Out</p>
                                <p class="stat-value mb-0">
                                    <c:out value="${not empty checkedOutCount ? checkedOutCount : '3,102'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ─── Copies Table ─── --%>
                <section class="raised-card overflow-hidden mb-5">
                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Physical copies inventory">
                            <thead>
                                <tr>
                                    <th>Barcode</th>
                                    <th>Book Details</th>
                                    <th class="d-none d-md-table-cell">Location</th>
                                    <th>Status / Condition</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty copies}">
                                        <c:forEach var="copy" items="${copies}">
                                            <tr>
                                                <%-- Barcode --%>
                                                <td>
                                                    <div class="d-flex align-items-center gap-1">
                                                        <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 16px;">qr_code</span>
                                                        <span class="barcode-text"><c:out value="${copy.barcode}" /></span>
                                                    </div>
                                                </td>

                                                <%-- Book Details --%>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="copy-thumb">
                                                            <c:choose>
                                                                <c:when test="${not empty copy.book.coverImageUrl}">
                                                                    <img src="${pageContext.request.contextPath}/<c:out value='${copy.book.coverImageUrl}'/>"
                                                                         alt="<c:out value='${copy.book.title}'/>" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="material-symbols-outlined" style="font-size: 20px; color: var(--on-surface-variant);">menu_book</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div>
                                                            <p class="mb-0 fw-semibold" style="font-size: 13px;"><c:out value="${copy.book.title}" /></p>
                                                            <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">
                                                                <c:out value="${copy.book.author}" />
                                                                <c:if test="${not empty copy.book.publishYear}"> &bull; <c:out value="${copy.book.publishYear}" /></c:if>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </td>

                                                <%-- Location --%>
                                                <td class="d-none d-md-table-cell">
                                                    <p class="mb-0 fw-semibold" style="font-size: 13px;"><c:out value="${copy.locationArea}" default="—" /></p>
                                                    <p class="mb-0 text-on-surface-variant" style="font-size: 12px;"><c:out value="${copy.locationShelf}" /></p>
                                                </td>

                                                <%-- Status + Condition --%>
                                                <td>
                                                    <div class="d-flex flex-column gap-1 align-items-start">
                                                        <c:choose>
                                                            <c:when test="${copy.status == 'AVAILABLE'}">
                                                                <span class="badge-pill status-available">Available</span>
                                                            </c:when>
                                                            <c:when test="${copy.status == 'BORROWED'}">
                                                                <span class="badge-pill status-borrowed">Checked Out</span>
                                                            </c:when>
                                                            <c:when test="${copy.status == 'RESERVED'}">
                                                                <span class="badge-pill status-reserved">Reserved</span>
                                                            </c:when>
                                                            <c:when test="${copy.status == 'LOST'}">
                                                                <span class="badge-pill status-lost">Lost</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill status-maintenance"><c:out value="${copy.status}" /></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:choose>
                                                            <c:when test="${copy.condition == 'New'}">
                                                                <span class="cond-badge cond-new">New</span>
                                                            </c:when>
                                                            <c:when test="${copy.condition == 'Good'}">
                                                                <span class="cond-badge cond-good">Good</span>
                                                            </c:when>
                                                            <c:when test="${copy.condition == 'Fair'}">
                                                                <span class="cond-badge cond-fair">Fair</span>
                                                            </c:when>
                                                            <c:when test="${copy.condition == 'Damaged'}">
                                                                <span class="cond-badge cond-damaged">Damaged</span>
                                                            </c:when>
                                                            <c:when test="${copy.condition == 'Lost'}">
                                                                <span class="cond-badge cond-lost">Lost</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="cond-badge cond-good"><c:out value="${copy.condition}" default="Good" /></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>

                                                <%-- Actions --%>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/librarian/copies/detail?id=<c:out value='${copy.copyId}'/>"
                                                       class="btn-icon" title="View history">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/librarian/copies/edit?id=<c:out value='${copy.copyId}'/>"
                                                       class="btn-icon" title="Edit copy">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Static sample rows --%>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 16px;">qr_code</span>
                                                    <span class="barcode-text">1000100456</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="copy-thumb">
                                                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--on-surface-variant);">menu_book</span>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">The Design of Everyday Things</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">Don Norman &bull; 2013 Ed.</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                <p class="mb-0 fw-semibold" style="font-size: 13px;">Main Floor, Aisle 4</p>
                                                <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">Shelf B2</p>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-column gap-1 align-items-start">
                                                    <span class="badge-pill status-available">Available</span>
                                                    <span class="cond-badge cond-good">Good</span>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="View history"><span class="material-symbols-outlined" style="font-size: 18px;">history</span></button>
                                                <button class="btn-icon" title="Edit copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 16px;">qr_code</span>
                                                    <span class="barcode-text">1000100457</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="copy-thumb">
                                                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--on-surface-variant);">menu_book</span>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">Thinking with Type</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">Ellen Lupton &bull; 2nd Rev. Ed.</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                <p class="mb-0 fw-semibold" style="font-size: 13px;">Design Section</p>
                                                <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">Shelf D1</p>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-column gap-1 align-items-start">
                                                    <span class="badge-pill status-borrowed">Checked Out</span>
                                                    <span class="cond-badge cond-good">Good</span>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="View history"><span class="material-symbols-outlined" style="font-size: 18px;">history</span></button>
                                                <button class="btn-icon" title="Edit copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 16px;">qr_code</span>
                                                    <span class="barcode-text">1000100458</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="copy-thumb">
                                                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--on-surface-variant);">menu_book</span>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">Interaction of Color</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">Josef Albers &bull; 50th Anniv.</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                <p class="mb-0 fw-semibold" style="font-size: 13px;">Processing Room</p>
                                                <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">—</p>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-column gap-1 align-items-start">
                                                    <span class="badge-pill status-maintenance">In Repair</span>
                                                    <span class="cond-badge cond-damaged">Damaged</span>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="View history"><span class="material-symbols-outlined" style="font-size: 18px;">history</span></button>
                                                <button class="btn-icon" title="Edit copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
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
                                <c:when test="${not empty totalCopies}">
                                    Showing
                                    <c:out value="${(currentPage - 1) * pageSize + 1}" /> –
                                    <c:out value="${currentPage * pageSize > totalCopies ? totalCopies : currentPage * pageSize}" />
                                    of <c:out value="${totalCopies}" /> entries
                                </c:when>
                                <c:otherwise>Showing 1 – 3 of 12,450 entries</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="d-flex gap-1 align-items-center">
                            <button class="page-btn" id="btnPrevPage"
                                    ${currentPage <= 1 ? 'disabled' : ''}
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
                                    <span class="page-btn" style="cursor: default; border: none; background: none; color: var(--on-surface-variant);">…</span>
                                    <button class="page-btn" onclick="goToPage(415)">415</button>
                                </c:otherwise>
                            </c:choose>
                            <button class="page-btn" id="btnNextPage"
                                    ${currentPage >= totalPages ? 'disabled' : ''}
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

    <%-- ════════════════════════════════════════
         MODAL: Filter
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="filterModalLabel" style="font-size: 18px;">Filter Copies</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="GET" id="filterForm">
                    <div class="modal-body py-3">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="filterStatus">Status</label>
                                <select id="filterStatus" name="status" class="form-select rounded-3"
                                        style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;">
                                    <option value="">All Statuses</option>
                                    <option value="AVAILABLE"   ${param.status == 'AVAILABLE'   ? 'selected' : ''}>Available</option>
                                    <option value="BORROWED"    ${param.status == 'BORROWED'    ? 'selected' : ''}>Checked Out</option>
                                    <option value="RESERVED"    ${param.status == 'RESERVED'    ? 'selected' : ''}>Reserved</option>
                                    <option value="LOST"        ${param.status == 'LOST'        ? 'selected' : ''}>Lost</option>
                                    <option value="MAINTENANCE" ${param.status == 'MAINTENANCE' ? 'selected' : ''}>In Repair</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="filterCondition">Condition</label>
                                <select id="filterCondition" name="condition" class="form-select rounded-3"
                                        style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;">
                                    <option value="">All Conditions</option>
                                    <option value="New"     ${param.condition == 'New'     ? 'selected' : ''}>New</option>
                                    <option value="Good"    ${param.condition == 'Good'    ? 'selected' : ''}>Good</option>
                                    <option value="Fair"    ${param.condition == 'Fair'    ? 'selected' : ''}>Fair</option>
                                    <option value="Damaged" ${param.condition == 'Damaged' ? 'selected' : ''}>Damaged</option>
                                    <option value="Lost"    ${param.condition == 'Lost'    ? 'selected' : ''}>Lost</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="filterLocation">Location (keyword)</label>
                                <input type="text" id="filterLocation" name="location" class="form-control rounded-3"
                                       style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;"
                                       placeholder="e.g. Main Floor, Aisle 4"
                                       value="<c:out value='${param.location}'/>" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <a href="${pageContext.request.contextPath}/librarian/copies"
                           class="btn btn-light rounded-pill px-4 fw-bold">Reset</a>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Apply Filters</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';

            /* ── Navigate to page with current filters preserved ── */
            function goToPage(page) {
                const url = new URL(window.location.href);
                url.searchParams.set('page', page);
                window.location.href = url.toString();
            }
            window.goToPage = goToPage;

            /* ── Live search with debounce (GET redirect) ── */
            const searchInput = document.getElementById('copySearchInput');
            if (searchInput) {
                let debounceTimer;
                searchInput.addEventListener('input', function () {
                    clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        const url = new URL(window.location.href);
                        const q = this.value.trim();
                        if (q) {
                            url.searchParams.set('q', q);
                        } else {
                            url.searchParams.delete('q');
                        }
                        url.searchParams.set('page', '1');
                        window.location.href = url.toString();
                    }, 500);
                });
            }

        })();
    </script>

</body>
</html>
