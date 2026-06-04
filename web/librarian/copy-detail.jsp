<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Copy Detail ── */

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

    /* Detail card (raised + no hover lift on static info cards) */
    .detail-card {
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 1rem;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        padding: 1.5rem;
    }

    /* Key-value rows inside the logistics card */
    .kv-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid var(--outline-variant);
        font-size: 14px;
    }
    .kv-row:last-child { border-bottom: none; }
    .kv-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        color: var(--on-surface-variant);
    }
    .kv-value {
        font-weight: 600;
        color: var(--on-surface);
        text-align: right;
    }

    /* Condition dot indicator */
    .condition-dot {
        display: inline-block;
        width: 8px;
        height: 8px;
        border-radius: 50%;
        margin-left: 6px;
        flex-shrink: 0;
    }

    /* Status badges (reusing badge-pill from _head.jsp + page-local colors) */
    .status-available  { color: #059669; background-color: #d1fae5; }
    .status-borrowed   { color: var(--on-primary-container); background-color: var(--primary-fixed); }
    .status-reserved   { color: #d97706; background-color: #fef3c7; }
    .status-lost       { color: var(--on-error-container); background-color: var(--error-container); }
    .status-maintenance{ color: var(--on-surface-variant); background-color: var(--surface-container-high); }

    /* Loan history table (augments the shared .table-lms from _head.jsp) */
    .history-badge {
        display: inline-block;
        padding: 3px 10px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.04em;
    }
    .history-returned     { color: #059669; background-color: #d1fae5; }
    .history-late-return  { color: var(--on-error-container); background-color: var(--error-container); }
    .history-active       { color: var(--on-primary-container); background-color: var(--primary-fixed); }

    /* Book cover thumbnail */
    .book-thumb {
        width: 120px;
        min-width: 120px;
        height: 180px;
        border-radius: 0.5rem;
        overflow: hidden;
        background: linear-gradient(135deg, var(--primary-fixed), var(--secondary-container));
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .book-thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }
    .book-thumb-placeholder {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 100%;
    }

    /* Monospace barcode chip */
    .barcode-chip {
        font-family: 'Courier New', Courier, monospace;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 6px;
        padding: 3px 10px;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 0.04em;
        color: var(--on-surface);
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
                            <span>Catalog</span>
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${copy.bookId}'/>" class="breadcrumb-link">
                            <span>Book Details</span>
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface);">
                            Copy: <c:out value="${not empty copy.barcode ? copy.barcode : 'CPY-8842-109'}" />
                        </span>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                                style="background-color: var(--surface-container-low); color: var(--on-surface); border: 1px solid var(--outline-variant);"
                                data-bs-toggle="modal" data-bs-target="#editConditionModal"
                                title="Edit Condition">
                            <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                            Edit Condition
                        </button>
                        <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                                data-bs-toggle="modal" data-bs-target="#changeStatusModal"
                                title="Change Status">
                            <span class="material-symbols-outlined" style="font-size: 18px;">sync_alt</span>
                            Change Status
                        </button>
                    </div>
                </div>

                <%-- ─── Hero Section: Book Info + Copy Logistics ─── --%>
                <div class="row g-4 mb-4 align-items-stretch">

                    <%-- Left: Book Info Card --%>
                    <div class="col-12 col-lg-8">
                        <div class="detail-card d-flex flex-column flex-sm-row gap-4 h-100">

                            <%-- Book thumbnail --%>
                            <div class="book-thumb">
                                <c:choose>
                                    <c:when test="${not empty copy.book.coverImageUrl}">
                                        <img src="${pageContext.request.contextPath}/<c:out value='${copy.book.coverImageUrl}'/>"
                                             alt="Cover of <c:out value='${copy.book.title}'/>" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-thumb-placeholder">
                                            <span class="material-symbols-outlined text-primary-custom" style="font-size: 48px; opacity: 0.6;">menu_book</span>
                                            <p class="text-primary-custom mb-0 mt-1" style="font-size: 10px; opacity: 0.6; text-transform: uppercase; letter-spacing: 0.08em;">No Cover</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Book metadata --%>
                            <div class="d-flex flex-column justify-content-between py-1 flex-grow-1">
                                <div>
                                    <p class="mb-1" style="font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: var(--on-surface-variant);">Linked Book Title</p>
                                    <h2 class="fw-bold mb-1" style="font-size: 20px; color: var(--on-surface); line-height: 1.3;">
                                        <c:out value="${not empty copy.book.title ? copy.book.title : 'The Design of Everyday Things'}" />
                                    </h2>
                                    <p class="mb-3" style="font-size: 14px; color: var(--on-surface-variant);">
                                        By <span class="fw-semibold"><c:out value="${not empty copy.book.author ? copy.book.author : 'Don Norman'}" /></span>
                                    </p>

                                    <div class="row g-3">
                                        <div class="col-6">
                                            <p class="mb-1 kv-label">ISBN</p>
                                            <p class="mb-0 fw-semibold" style="font-size: 14px;">
                                                <c:out value="${not empty copy.book.isbn ? copy.book.isbn : '978-0465050659'}" />
                                            </p>
                                        </div>
                                        <div class="col-6">
                                            <p class="mb-1 kv-label">Publisher</p>
                                            <p class="mb-0 fw-semibold" style="font-size: 14px;">
                                                <c:out value="${not empty copy.book.publisher ? copy.book.publisher : '—'}" />
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${copy.bookId}'/>"
                                   class="d-inline-flex align-items-center gap-1 fw-bold text-decoration-none mt-3"
                                   style="font-size: 13px; color: var(--primary);">
                                    Manage Master Book Record
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <%-- Right: Copy Logistics --%>
                    <div class="col-12 col-lg-4">
                        <div class="detail-card h-100 d-flex flex-column">
                            <h3 class="fw-bold mb-3 pb-2" style="font-size: 16px; color: var(--on-surface); border-bottom: 1px solid var(--outline-variant);">Copy Logistics</h3>

                            <div class="kv-row">
                                <span class="kv-label">Status</span>
                                <c:choose>
                                    <c:when test="${copy.status == 'AVAILABLE' or empty copy.status}">
                                        <span class="badge-pill status-available">
                                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle; margin-right: 2px;">check_circle</span>Available
                                        </span>
                                    </c:when>
                                    <c:when test="${copy.status == 'BORROWED'}">
                                        <span class="badge-pill status-borrowed">Borrowed</span>
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
                            </div>

                            <div class="kv-row">
                                <span class="kv-label">Barcode</span>
                                <span class="barcode-chip">
                                    <c:out value="${not empty copy.barcode ? copy.barcode : 'CPY-8842-109'}" />
                                </span>
                            </div>

                            <div class="kv-row">
                                <span class="kv-label">Location</span>
                                <span class="kv-value">
                                    <c:out value="${not empty copy.location ? copy.location : 'Main Floor, Aisle 4, Shelf B2'}" />
                                </span>
                            </div>

                            <div class="kv-row">
                                <span class="kv-label">Condition</span>
                                <span class="d-flex align-items-center kv-value">
                                    <c:out value="${not empty copy.condition ? copy.condition : 'Good'}" />
                                    <c:choose>
                                        <c:when test="${copy.condition == 'Good' or empty copy.condition}">
                                            <span class="condition-dot" style="background-color: #059669;"></span>
                                        </c:when>
                                        <c:when test="${copy.condition == 'Fair'}">
                                            <span class="condition-dot" style="background-color: #d97706;"></span>
                                        </c:when>
                                        <c:when test="${copy.condition == 'Damaged' or copy.condition == 'Lost'}">
                                            <span class="condition-dot" style="background-color: var(--error);"></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="condition-dot" style="background-color: var(--outline);"></span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="kv-row">
                                <span class="kv-label">Date Added</span>
                                <span class="kv-value">
                                    <c:choose>
                                        <c:when test="${not empty copy.dateAdded}">
                                            <fmt:formatDate value="${copy.dateAdded}" pattern="MMM dd, yyyy" />
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="kv-row">
                                <span class="kv-label">Total Borrows</span>
                                <span class="kv-value">
                                    <c:out value="${not empty copy.totalBorrows ? copy.totalBorrows : loanHistory.size()}" default="0" />
                                </span>
                            </div>
                        </div>
                    </div>

                </div>

                <%-- ─── Loan / Borrowing History ─── --%>
                <section class="raised-card overflow-hidden mb-5">
                    <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-2"
                         style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-lowest);">
                        <div>
                            <h2 class="fw-bold mb-0" style="font-size: 18px; color: var(--on-surface);">Borrowing History</h2>
                            <p class="mb-0 text-on-surface-variant" style="font-size: 13px; margin-top: 2px;">Complete loan record for this physical copy.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/librarian/copies/export?copyId=<c:out value='${copy.copyId}'/>"
                           class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                           style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined" style="font-size: 18px;">download</span>
                            Export CSV
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Borrowing history for this copy">
                            <thead>
                                <tr>
                                    <th>Patron</th>
                                    <th>Checked Out</th>
                                    <th>Due Date</th>
                                    <th>Returned</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty loanHistory}">
                                        <c:forEach var="loan" items="${loanHistory}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">
                                                            <c:out value="${loan.patronInitials}" default="??" />
                                                        </div>
                                                        <div>
                                                            <p class="mb-0 fw-semibold" style="font-size: 13px;"><c:out value="${loan.patronName}" /></p>
                                                            <p class="mb-0 text-on-surface-variant" style="font-size: 11px;"><c:out value="${loan.patronId}" /></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-on-surface-variant" style="font-size: 13px;">
                                                    <fmt:formatDate value="${loan.checkoutDate}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td style="font-size: 13px;">
                                                    <fmt:formatDate value="${loan.dueDate}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td class="text-on-surface-variant" style="font-size: 13px;">
                                                    <c:choose>
                                                        <c:when test="${not empty loan.returnDate}">
                                                            <fmt:formatDate value="${loan.returnDate}" pattern="MMM dd, yyyy" />
                                                        </c:when>
                                                        <c:otherwise><span class="text-on-surface-variant">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${loan.loanStatus == 'RETURNED'}">
                                                            <span class="history-badge history-returned">Returned</span>
                                                        </c:when>
                                                        <c:when test="${loan.loanStatus == 'LATE_RETURN'}">
                                                            <span class="history-badge history-late-return">Late Return</span>
                                                        </c:when>
                                                        <c:when test="${loan.loanStatus == 'ACTIVE'}">
                                                            <span class="history-badge history-active">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="history-badge" style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">
                                                                <c:out value="${loan.loanStatus}" />
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <button class="btn-icon" title="View loan record"
                                                            onclick="window.location='${pageContext.request.contextPath}/librarian/loans?id=<c:out value="${loan.loanId}"/>'">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Static sample rows shown when no DB data is available --%>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">SJ</div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">Sarah Jenkins</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 11px;">USR-1092</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Oct 12, 2023</td>
                                            <td style="font-size: 13px;">Oct 26, 2023</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Oct 24, 2023</td>
                                            <td><span class="history-badge history-returned">Returned</span></td>
                                            <td class="text-center"><button class="btn-icon" title="View"><span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span></button></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed);">MC</div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">Michael Chen</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 11px;">USR-3341</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Sep 05, 2023</td>
                                            <td style="font-size: 13px;">Sep 19, 2023</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Sep 19, 2023</td>
                                            <td><span class="history-badge history-returned">Returned</span></td>
                                            <td class="text-center"><button class="btn-icon" title="View"><span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span></button></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar" style="background-color: var(--error-container); color: var(--error);">ER</div>
                                                    <div>
                                                        <p class="mb-0 fw-semibold" style="font-size: 13px;">Elena Rodriguez</p>
                                                        <p class="mb-0 text-on-surface-variant" style="font-size: 11px;">USR-0922</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Aug 01, 2023</td>
                                            <td style="font-size: 13px; color: var(--error); font-weight: 600;">Aug 15, 2023 ⚠</td>
                                            <td class="text-on-surface-variant" style="font-size: 13px;">Aug 18, 2023</td>
                                            <td><span class="history-badge history-late-return">Late Return</span></td>
                                            <td class="text-center"><button class="btn-icon" style="color: var(--error);" title="View"><span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span></button></td>
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
         MODAL: Edit Condition
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="editConditionModal" tabindex="-1" aria-labelledby="editConditionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editConditionModalLabel" style="font-size: 18px;">Edit Condition</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="POST">
                    <input type="hidden" name="action" value="editCondition" />
                    <input type="hidden" name="copyId" value="<c:out value='${copy.copyId}'/>" />
                    <div class="modal-body py-3">
                        <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="conditionSelect">Physical Condition</label>
                        <select id="conditionSelect" name="condition" class="form-select rounded-3 py-2"
                                style="background-color: var(--surface-container-low); border-color: var(--outline-variant); color: var(--on-surface); font-size: 14px;">
                            <option value="New"     ${copy.condition == 'New'     ? 'selected' : ''}>New</option>
                            <option value="Good"    ${copy.condition == 'Good'    ? 'selected' : ''}>Good</option>
                            <option value="Fair"    ${copy.condition == 'Fair'    ? 'selected' : ''}>Fair</option>
                            <option value="Damaged" ${copy.condition == 'Damaged' ? 'selected' : ''}>Damaged</option>
                            <option value="Lost"    ${copy.condition == 'Lost'    ? 'selected' : ''}>Lost</option>
                        </select>
                        <div class="mt-2">
                            <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="conditionNotes">Notes (optional)</label>
                            <textarea id="conditionNotes" name="conditionNotes" class="form-control rounded-3" rows="3"
                                      style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 13px;"
                                      placeholder="Describe damage or changes..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Change Status
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="changeStatusModal" tabindex="-1" aria-labelledby="changeStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="changeStatusModalLabel" style="font-size: 18px;">Change Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/copies" method="POST">
                    <input type="hidden" name="action" value="changeStatus" />
                    <input type="hidden" name="copyId" value="<c:out value='${copy.copyId}'/>" />
                    <div class="modal-body py-3">
                        <p class="mb-2" style="font-size: 13px; color: var(--on-surface-variant);">
                            Current: <strong><c:out value="${not empty copy.status ? copy.status : 'AVAILABLE'}" /></strong>
                        </p>
                        <label class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;" for="statusSelect">New Status</label>
                        <select id="statusSelect" name="status" class="form-select rounded-3 py-2"
                                style="background-color: var(--surface-container-low); border-color: var(--outline-variant); color: var(--on-surface); font-size: 14px;">
                            <option value="AVAILABLE"   ${copy.status == 'AVAILABLE'   ? 'selected' : ''}>Available</option>
                            <option value="RESERVED"    ${copy.status == 'RESERVED'    ? 'selected' : ''}>Reserved</option>
                            <option value="BORROWED"    ${copy.status == 'BORROWED'    ? 'selected' : ''}>Borrowed</option>
                            <option value="LOST"        ${copy.status == 'LOST'        ? 'selected' : ''}>Lost</option>
                            <option value="MAINTENANCE" ${copy.status == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                        </select>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Confirm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
