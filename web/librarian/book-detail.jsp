<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped overrides for Book Detail ── */
    .detail-hero-img {
        width: 100%;
        aspect-ratio: 2 / 3;
        object-fit: cover;
        display: block;
        border-radius: 0;
    }

    .meta-card {
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 0.75rem;
        padding: 14px 18px;
    }
    .meta-card small {
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: var(--on-surface-variant);
    }
    .meta-card .meta-value {
        font-size: 14px;
        font-weight: 600;
        color: var(--on-surface);
        margin-top: 4px;
    }

    .tag-chip {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 600;
        background-color: var(--surface-container-high);
        color: var(--on-surface-variant);
        border: 1px solid var(--outline-variant);
    }

    .status-in-circulation {
        background-color: var(--tertiary-fixed);
        color: var(--on-tertiary-fixed-variant);
    }
    .status-available {
        background-color: #d1fae5;
        color: #059669;
    }
    .status-reserved {
        background-color: #fef3c7;
        color: #d97706;
    }
    .status-borrowed {
        background-color: var(--primary-fixed);
        color: var(--on-primary-container);
    }
    .status-lost {
        background-color: var(--error-container);
        color: var(--on-error-container);
    }
    .status-maintenance {
        background-color: var(--surface-container-highest);
        color: var(--on-surface-variant);
    }

    .copy-badge {
        display: inline-block;
        padding: 3px 10px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.04em;
    }

    .breadcrumb-link {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        text-decoration: none;
        color: var(--on-surface-variant);
        font-size: 13px;
        font-weight: 600;
        transition: color 0.15s ease;
    }
    .breadcrumb-link:hover { color: var(--primary); }

    .section-title {
        font-size: 18px;
        font-weight: 600;
        color: var(--on-surface);
        margin-bottom: 0;
    }
    .section-subtitle {
        font-size: 13px;
        color: var(--on-surface-variant);
        margin-top: 2px;
        margin-bottom: 0;
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

                <%-- ─── Breadcrumb + Actions ─── --%>
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <a href="${pageContext.request.contextPath}/librarian/catalog.jsp" class="breadcrumb-link" aria-label="Back to Catalog">
                            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                            <span>Book Catalog</span>
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface);">Book Details</span>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/librarian/book-edit.jsp?id=<c:out value='${book.bookId}'/>" 
                           class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                           style="background-color: var(--surface-container-low); color: var(--on-surface); border: 1px solid var(--outline-variant);"
                           title="Edit Book">
                            <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                            Edit
                        </a>
                        <button class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                                style="background-color: var(--error-container); color: var(--on-error-container); border: none;"
                                data-bs-toggle="modal" data-bs-target="#deleteBookModal"
                                title="Delete Book">
                            <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                            Delete
                        </button>
                    </div>
                </div>

                <%-- ─── Hero Section: Cover + Info ─── --%>
                <div class="row g-4 mb-4 align-items-start">

                    <%-- Left: Book Cover --%>
                    <div class="col-12 col-md-3 col-lg-2">
                        <div class="raised-card overflow-hidden" style="padding: 0;">
                            <c:choose>
                                <c:when test="${not empty book.coverImageUrl}">
                                    <img src="${pageContext.request.contextPath}/<c:out value='${book.coverImageUrl}'/>"
                                         alt="Cover of <c:out value='${book.title}'/>"
                                         class="detail-hero-img" />
                                </c:when>
                                <c:otherwise>
                                    <%-- Placeholder cover --%>
                                    <div class="detail-hero-img d-flex flex-column align-items-center justify-content-center"
                                         style="background: linear-gradient(135deg, var(--primary-fixed), var(--secondary-container)); min-height: 260px;">
                                        <span class="material-symbols-outlined text-primary-custom" style="font-size: 64px; opacity: 0.6;">menu_book</span>
                                        <p class="text-primary-custom fw-bold mb-0 mt-2" style="font-size: 11px; opacity: 0.6; text-transform: uppercase; letter-spacing: 0.08em;">No Cover</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Right: Book Info --%>
                    <div class="col-12 col-md-9 col-lg-10 d-flex flex-column gap-3">

                        <%-- Title + Status --%>
                        <div class="raised-card p-4">
                            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                <div class="flex-grow-1">
                                    <h2 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface); line-height: 1.3;">
                                        <c:out value="${not empty book.title ? book.title : 'Untitled Book'}" />
                                    </h2>
                                    <p class="mb-0" style="font-size: 15px; color: var(--on-surface-variant);">
                                        by <span class="fw-semibold"><c:out value="${not empty book.author ? book.author : 'Unknown Author'}" /></span>
                                    </p>
                                </div>
                                <span class="badge-pill status-in-circulation" aria-label="Book status">
                                    <c:out value="${not empty book.status ? book.status : 'IN CIRCULATION'}" />
                                </span>
                            </div>
                        </div>

                        <%-- Meta stats --%>
                        <div class="row g-3">
                            <div class="col-6 col-lg-3">
                                <div class="meta-card h-100">
                                    <small>ISBN-13</small>
                                    <div class="meta-value"><c:out value="${not empty book.isbn ? book.isbn : '—'}" /></div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="meta-card h-100">
                                    <small>Publisher</small>
                                    <div class="meta-value"><c:out value="${not empty book.publisher ? book.publisher : '—'}" /></div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="meta-card h-100">
                                    <small>Publication Year</small>
                                    <div class="meta-value"><c:out value="${not empty book.publishYear ? book.publishYear : '—'}" /></div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="meta-card h-100">
                                    <small>Replacement Price</small>
                                    <div class="meta-value">
                                        <c:choose>
                                            <c:when test="${not empty book.replacementPrice}">
                                                <fmt:formatNumber value="${book.replacementPrice}" type="currency" currencySymbol="$" />
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Description + Categories --%>
                        <div class="row g-3">
                            <div class="col-12 col-lg-8">
                                <div class="raised-card p-4 h-100">
                                    <h3 class="fw-semibold mb-2" style="font-size: 15px; color: var(--on-surface);">Description</h3>
                                    <p class="mb-0" style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.7;">
                                        <c:out value="${not empty book.description ? book.description : 'No description available for this book.'}" />
                                    </p>
                                </div>
                            </div>
                            <div class="col-12 col-lg-4">
                                <div class="raised-card p-4 h-100">
                                    <h3 class="fw-semibold mb-3" style="font-size: 15px; color: var(--on-surface);">Categories &amp; Tags</h3>
                                    <div class="d-flex flex-wrap gap-2">
                                        <c:choose>
                                            <c:when test="${not empty book.categories}">
                                                <c:forEach var="cat" items="${book.categories}">
                                                    <span class="tag-chip">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">label</span>
                                                        <c:out value="${cat}" />
                                                    </span>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tag-chip">Uncategorized</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <%-- ─── Inventory & Copies ─── --%>
                <section class="raised-card overflow-hidden mb-5">
                    <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-2"
                         style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-lowest);">
                        <div>
                            <h2 class="section-title">Inventory &amp; Copies</h2>
                            <p class="section-subtitle">Operational status &amp; asset tracking. Monitor physical holdings.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/librarian/copy-register.jsp?bookId=<c:out value='${book.bookId}'/>" 
                           class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                           id="btnAddCopy">
                            <span class="material-symbols-outlined" style="font-size: 18px;">add_circle</span>
                            Add New Copy
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Book copies inventory">
                            <thead>
                                <tr>
                                    <th>Barcode</th>
                                    <th>Location</th>
                                    <th>Condition</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty copies}">
                                        <c:forEach var="copy" items="${copies}">
                                            <tr>
                                                <td class="fw-semibold" style="font-size: 13px;">
                                                    <c:out value="${copy.barcode}" />
                                                </td>
                                                <td style="font-size: 13px; color: var(--on-surface-variant);">
                                                    <c:out value="${copy.location}" />
                                                </td>
                                                <td style="font-size: 13px;">
                                                    <c:out value="${copy.condition}" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${copy.status == 'AVAILABLE'}">
                                                            <span class="copy-badge status-available">AVAILABLE</span>
                                                        </c:when>
                                                        <c:when test="${copy.status == 'RESERVED'}">
                                                            <span class="copy-badge status-reserved">RESERVED</span>
                                                        </c:when>
                                                        <c:when test="${copy.status == 'BORROWED'}">
                                                            <span class="copy-badge status-borrowed">BORROWED</span>
                                                        </c:when>
                                                        <c:when test="${copy.status == 'LOST'}">
                                                            <span class="copy-badge status-lost">LOST</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="copy-badge status-maintenance">
                                                                <c:out value="${copy.status}" />
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/librarian/copy-detail.jsp?id=<c:out value='${copy.copyId}'/>"
                                                       class="btn-icon" title="View Copy Details">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/librarian/copy-edit.jsp?id=<c:out value='${copy.copyId}'/>"
                                                       class="btn-icon" title="Edit Copy">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </a>
                                                    <button class="btn-icon" style="color: var(--error);"
                                                            title="Delete Copy"
                                                            onclick="openDeleteCopyModal('<c:out value="${copy.copyId}"/>', '<c:out value="${copy.barcode}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Sample static rows shown when no DB data is available yet --%>
                                        <tr>
                                            <td class="fw-semibold" style="font-size: 13px;">LIB-88392-01</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Main Stacks, Level 3, Shelf B4</td>
                                            <td style="font-size: 13px;">Good</td>
                                            <td><span class="copy-badge status-available">AVAILABLE</span></td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/librarian/copy-detail.jsp" class="btn-icon" title="View Copy Details"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/copy-edit.jsp" class="btn-icon" title="Edit Copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete Copy"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold" style="font-size: 13px;">LIB-88392-02</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Reference Desk (Hold)</td>
                                            <td style="font-size: 13px;">Fair – Cover wear</td>
                                            <td><span class="copy-badge status-reserved">RESERVED</span></td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/librarian/copy-detail.jsp" class="btn-icon" title="View Copy Details"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/copy-edit.jsp" class="btn-icon" title="Edit Copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete Copy"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold" style="font-size: 13px;">LIB-88392-03</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Patron: ID-9982 (Due Oct 15)</td>
                                            <td style="font-size: 13px;">Good</td>
                                            <td><span class="copy-badge status-borrowed">BORROWED</span></td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/librarian/copy-detail.jsp" class="btn-icon" title="View Copy Details"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/copy-edit.jsp" class="btn-icon" title="Edit Copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete Copy"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold" style="font-size: 13px;">LIB-88392-04</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Unknown</td>
                                            <td style="font-size: 13px;">Lost</td>
                                            <td><span class="copy-badge status-lost">LOST</span></td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/librarian/copy-detail.jsp" class="btn-icon" title="View Copy Details"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></a>
                                                <a href="${pageContext.request.contextPath}/librarian/copy-edit.jsp" class="btn-icon" title="Edit Copy"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></a>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete Copy"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

    <%-- ════════════════════════════════════════
         MODAL: Add New Copy
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="addCopyModal" tabindex="-1" aria-labelledby="addCopyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="addCopyModalLabel" style="font-size: 18px;">Add New Copy</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="POST" id="addCopyForm">
                    <input type="hidden" name="action" value="addCopy" />
                    <input type="hidden" name="bookId" value="<c:out value='${book.bookId}'/>" />
                    <div class="modal-body py-3">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="newBarcode">Barcode / Asset Tag</label>
                                <input type="text" id="newBarcode" name="barcode" class="form-control rounded-3 py-2"
                                       placeholder="e.g. LIB-88392-05" required />
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="newLocation">Physical Location</label>
                                <input type="text" id="newLocation" name="location" class="form-control rounded-3 py-2"
                                       placeholder="e.g. Main Stacks, Level 3, Shelf B4" />
                            </div>
                            <div class="row g-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="newCondition">Condition</label>
                                    <select id="newCondition" name="condition" class="form-select rounded-3 py-2">
                                        <option value="New">New</option>
                                        <option value="Good" selected>Good</option>
                                        <option value="Fair">Fair</option>
                                        <option value="Damaged">Damaged</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="newStatus">Initial Status</label>
                                    <select id="newStatus" name="status" class="form-select rounded-3 py-2">
                                        <option value="AVAILABLE" selected>Available</option>
                                        <option value="MAINTENANCE">In Processing</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Save Copy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Edit Copy
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="editCopyModal" tabindex="-1" aria-labelledby="editCopyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editCopyModalLabel" style="font-size: 18px;">Edit Copy</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="POST" id="editCopyForm">
                    <input type="hidden" name="action" value="editCopy" />
                    <input type="hidden" name="copyId" id="editCopyId" />
                    <div class="modal-body py-3">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editBarcode">Barcode / Asset Tag</label>
                                <input type="text" id="editBarcode" name="barcode" class="form-control rounded-3 py-2" required />
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editLocation">Physical Location</label>
                                <input type="text" id="editLocation" name="location" class="form-control rounded-3 py-2" />
                            </div>
                            <div class="row g-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editCondition">Condition</label>
                                    <select id="editCondition" name="condition" class="form-select rounded-3 py-2">
                                        <option value="New">New</option>
                                        <option value="Good">Good</option>
                                        <option value="Fair">Fair</option>
                                        <option value="Damaged">Damaged</option>
                                        <option value="Lost">Lost</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editStatus">Status</label>
                                    <select id="editStatus" name="status" class="form-select rounded-3 py-2">
                                        <option value="AVAILABLE">Available</option>
                                        <option value="RESERVED">Reserved</option>
                                        <option value="BORROWED">Borrowed</option>
                                        <option value="LOST">Lost</option>
                                        <option value="MAINTENANCE">Maintenance</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Delete Copy (Soft-delete confirm)
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="deleteCopyModal" tabindex="-1" aria-labelledby="deleteCopyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="deleteCopyModalLabel" style="font-size: 18px; color: var(--error);">Confirm Removal</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="POST" id="deleteCopyForm">
                    <input type="hidden" name="action" value="deleteCopy" />
                    <input type="hidden" name="copyId" id="deleteCopyId" />
                    <div class="modal-body py-3">
                        <p class="mb-1" style="font-size: 14px; color: var(--on-surface);">
                            Mark copy <strong id="deleteCopyBarcode"></strong> as decommissioned?
                        </p>
                        <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                            This performs a soft-delete (status update). The record is retained for audit purposes.
                        </p>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-3 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn fw-bold rounded-pill px-3"
                                style="background-color: var(--error); color: white; border: none;">Decommission</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Delete Book (Soft-delete confirm)
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="deleteBookModal" tabindex="-1" aria-labelledby="deleteBookModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="deleteBookModalLabel" style="font-size: 18px; color: var(--error);">Delete Book Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/catalog" method="POST">
                    <input type="hidden" name="action" value="deleteBook" />
                    <input type="hidden" name="bookId" value="<c:out value='${book.bookId}'/>" />
                    <div class="modal-body py-3">
                        <p class="mb-1" style="font-size: 14px; color: var(--on-surface);">
                            Remove <strong><c:out value="${book.title}" /></strong> from the catalog?
                        </p>
                        <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                            The record will be soft-deleted and hidden from patrons. All transaction history is preserved.
                        </p>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-3 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn fw-bold rounded-pill px-3"
                                style="background-color: var(--error); color: white; border: none;">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Edit Book
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="editBookModal" tabindex="-1" aria-labelledby="editBookModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editBookModalLabel" style="font-size: 18px;">Edit Book Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/catalog" method="POST">
                    <input type="hidden" name="action" value="updateBook" />
                    <input type="hidden" name="bookId" value="<c:out value='${book.bookId}'/>" />
                    <div class="modal-body py-3">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editTitle">Title</label>
                                <input type="text" id="editTitle" name="title" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.title}'/>" required />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editAuthor">Author</label>
                                <input type="text" id="editAuthor" name="author" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.author}'/>" />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editIsbn">ISBN-13</label>
                                <input type="text" id="editIsbn" name="isbn" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.isbn}'/>" />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editPublisher">Publisher</label>
                                <input type="text" id="editPublisher" name="publisher" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.publisher}'/>" />
                            </div>
                            <div class="col-6 col-md-3">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editYear">Publication Year</label>
                                <input type="number" id="editYear" name="publishYear" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.publishYear}'/>" min="1800" max="2100" />
                            </div>
                            <div class="col-6 col-md-3">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editPrice">Replacement Price ($)</label>
                                <input type="number" id="editPrice" name="replacementPrice" class="form-control rounded-3 py-2"
                                       value="<c:out value='${book.replacementPrice}'/>" min="0" step="0.01" />
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="editDescription">Description</label>
                                <textarea id="editDescription" name="description" class="form-control rounded-3 py-2" rows="4"><c:out value="${book.description}"/></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /**
         * Populate and open the Edit Copy modal with the selected copy's data.
         * @param {string} copyId
         * @param {string} barcode
         * @param {string} location
         * @param {string} condition
         * @param {string} status
         */
        function openEditCopyModal(copyId, barcode, location, condition, status) {
            document.getElementById('editCopyId').value    = copyId;
            document.getElementById('editBarcode').value  = barcode;
            document.getElementById('editLocation').value = location;

            const condSelect = document.getElementById('editCondition');
            for (let opt of condSelect.options) {
                opt.selected = (opt.value === condition);
            }
            const statSelect = document.getElementById('editStatus');
            for (let opt of statSelect.options) {
                opt.selected = (opt.value === status);
            }

            const modal = new bootstrap.Modal(document.getElementById('editCopyModal'));
            modal.show();
        }

        /**
         * Populate and open the Delete Copy confirmation modal.
         * @param {string} copyId
         * @param {string} barcode
         */
        function openDeleteCopyModal(copyId, barcode) {
            document.getElementById('deleteCopyId').value      = copyId;
            document.getElementById('deleteCopyBarcode').textContent = barcode;
            const modal = new bootstrap.Modal(document.getElementById('deleteCopyModal'));
            modal.show();
        }
    </script>

</body>
</html>
