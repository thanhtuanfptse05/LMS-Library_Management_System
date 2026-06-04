<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Category Management ── */

    /* Count badge variants */
    .count-badge {
        display: inline-block;
        padding: 3px 12px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.05em;
    }
    .count-badge--default  { background-color: var(--surface-container-high); color: var(--on-surface-variant); }
    .count-badge--primary  { background-color: var(--primary-fixed); color: var(--on-primary-container); }
    .count-badge--tertiary { background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant); }

    /* Category name link style */
    .cat-name {
        font-weight: 700;
        font-size: 14px;
        color: var(--primary);
        text-decoration: none;
        transition: opacity 0.15s ease;
    }
    .cat-name:hover { opacity: 0.75; }

    /* Description cell truncation */
    .cat-desc {
        max-width: 320px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        color: var(--on-surface-variant);
        font-size: 13px;
    }

    /* Pagination buttons (reuse from copy-list.jsp) */
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
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Category Management</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Organize and define classification schemas for the library catalog.</p>
                    </div>
                    <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                            style="height: 40px;"
                            data-bs-toggle="modal" data-bs-target="#addCategoryModal"
                            id="btnAddCategory">
                        <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
                        Add New Category
                    </button>
                </div>

                <%-- ─── Categories Table ─── --%>
                <section class="raised-card overflow-hidden mb-5">
                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Book categories">
                            <thead>
                                <tr>
                                    <th>Category Name</th>
                                    <th>Description</th>
                                    <th>Books</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty categories}">
                                        <c:forEach var="cat" items="${categories}">
                                            <tr>
                                                <td>
                                                    <span class="cat-name">
                                                        <c:out value="${cat.categoryName}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="cat-desc" title="<c:out value='${cat.description}'/>">
                                                        <c:out value="${not empty cat.description ? cat.description : '—'}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cat.bookCount > 2000}">
                                                            <span class="count-badge count-badge--tertiary">
                                                                <fmt:formatNumber value="${cat.bookCount}" type="number" />
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${cat.bookCount > 800}">
                                                            <span class="count-badge count-badge--primary">
                                                                <fmt:formatNumber value="${cat.bookCount}" type="number" />
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="count-badge count-badge--default">
                                                                <c:out value="${cat.bookCount}" />
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <button class="btn-icon"
                                                            title="Edit category"
                                                            onclick="openEditModal('<c:out value="${cat.categoryId}"/>', '<c:out value="${cat.categoryName}"/>', '<c:out value="${cat.description}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </button>
                                                    <button class="btn-icon" style="color: var(--error);"
                                                            title="Delete category"
                                                            onclick="openDeleteModal('<c:out value="${cat.categoryId}"/>', '<c:out value="${cat.categoryName}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Static sample rows --%>
                                        <tr>
                                            <td><span class="cat-name">Science Fiction</span></td>
                                            <td><span class="cat-desc">Imaginative and futuristic concepts such as advanced science, technology, space exploration, time travel.</span></td>
                                            <td><span class="count-badge count-badge--primary">1,240</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="cat-name">Historical Fiction</span></td>
                                            <td><span class="cat-desc">Stories written to portray a time period or convey information about a specific historical period.</span></td>
                                            <td><span class="count-badge count-badge--default">856</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="cat-name">Academic Journals</span></td>
                                            <td><span class="cat-desc">Peer-reviewed periodicals in which scholarship relating to a particular academic discipline is published.</span></td>
                                            <td><span class="count-badge count-badge--tertiary">3,412</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="cat-name">Biographies</span></td>
                                            <td><span class="cat-desc">Detailed descriptions of a person's life including education, relationships, career, and achievements.</span></td>
                                            <td><span class="count-badge count-badge--default">520</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
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
                                <c:when test="${not empty totalCategories}">
                                    Showing
                                    <c:out value="${(currentPage - 1) * pageSize + 1}" /> –
                                    <c:out value="${currentPage * pageSize > totalCategories ? totalCategories : currentPage * pageSize}" />
                                    of <c:out value="${totalCategories}" /> categories
                                </c:when>
                                <c:otherwise>Showing 1 – 4 of 24 categories</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="d-flex gap-1">
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

    <%-- ════════════════════════════════════════
         MODAL: Add New Category
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="addCategoryModalLabel" style="font-size: 18px;">Create New Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/categories" method="POST"
                      id="addCategoryForm" novalidate>
                    <input type="hidden" name="action" value="addCategory" />
                    <div class="modal-body py-3">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase"
                                       style="font-size: 11px; letter-spacing: 0.05em;" for="addCatName">
                                    Category Name <span style="color: var(--error);">*</span>
                                </label>
                                <input type="text" id="addCatName" name="categoryName"
                                       class="form-control rounded-3 py-2"
                                       style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;"
                                       placeholder="e.g. Young Adult Fiction" required />
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase"
                                       style="font-size: 11px; letter-spacing: 0.05em;" for="addCatDesc">
                                    Description <span class="fw-normal text-lowercase" style="letter-spacing: 0;">(optional)</span>
                                </label>
                                <textarea id="addCatDesc" name="description"
                                          class="form-control rounded-3 py-2"
                                          style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px; resize: vertical;"
                                          rows="4"
                                          placeholder="Briefly describe the contents of this category..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Save Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════
         MODAL: Edit Category
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editCategoryModalLabel" style="font-size: 18px;">Edit Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/categories" method="POST"
                      id="editCategoryForm" novalidate>
                    <input type="hidden" name="action" value="editCategory" />
                    <input type="hidden" name="categoryId" id="editCatId" />
                    <div class="modal-body py-3">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase"
                                       style="font-size: 11px; letter-spacing: 0.05em;" for="editCatName">
                                    Category Name <span style="color: var(--error);">*</span>
                                </label>
                                <input type="text" id="editCatName" name="categoryName"
                                       class="form-control rounded-3 py-2"
                                       style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;"
                                       required />
                            </div>
                            <div>
                                <label class="form-label fw-semibold text-on-surface-variant text-uppercase"
                                       style="font-size: 11px; letter-spacing: 0.05em;" for="editCatDesc">
                                    Description <span class="fw-normal text-lowercase" style="letter-spacing: 0;">(optional)</span>
                                </label>
                                <textarea id="editCatDesc" name="description"
                                          class="form-control rounded-3 py-2"
                                          style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px; resize: vertical;"
                                          rows="4"></textarea>
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
         MODAL: Delete Category (Soft-delete confirm)
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="deleteCategoryModalLabel" style="font-size: 18px; color: var(--error);">Delete Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/categories" method="POST">
                    <input type="hidden" name="action" value="deleteCategory" />
                    <input type="hidden" name="categoryId" id="deleteCatId" />
                    <div class="modal-body py-3">
                        <p class="mb-1" style="font-size: 14px; color: var(--on-surface);">
                            Remove category <strong id="deleteCatName"></strong>?
                        </p>
                        <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                            This will unlink all associated books. The books themselves will not be deleted.
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';

            /* ── Populate and open the Edit modal ── */
            function openEditModal(id, name, description) {
                document.getElementById('editCatId').value   = id;
                document.getElementById('editCatName').value = name;
                document.getElementById('editCatDesc').value = description || '';
                new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
            }

            /* ── Populate and open the Delete confirm modal ── */
            function openDeleteModal(id, name) {
                document.getElementById('deleteCatId').value          = id;
                document.getElementById('deleteCatName').textContent  = name;
                new bootstrap.Modal(document.getElementById('deleteCategoryModal')).show();
            }

            /* ── Form validation ── */
            ['addCategoryForm', 'editCategoryForm'].forEach(formId => {
                const form = document.getElementById(formId);
                if (form) {
                    form.addEventListener('submit', function (e) {
                        if (!this.checkValidity()) {
                            e.preventDefault();
                            e.stopPropagation();
                        }
                        this.classList.add('was-validated');
                    });
                }
            });

            /* ── Server-side pagination ── */
            function goToPage(page) {
                const url = new URL(window.location.href);
                url.searchParams.set('page', page);
                window.location.href = url.toString();
            }

            window.openEditModal   = openEditModal;
            window.openDeleteModal = openDeleteModal;
            window.goToPage        = goToPage;

        })();
    </script>

</body>
</html>
