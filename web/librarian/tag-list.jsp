<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Tag Management ── */

    /* Quick-add inline bar */
    .quick-add-bar {
        display: flex;
        align-items: center;
        gap: 8px;
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 0.75rem;
        padding: 8px 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    }
    .quick-add-bar .quick-input-wrap { position: relative; }
    .quick-add-bar .quick-input-wrap .input-icon {
        position: absolute;
        left: 10px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 18px;
        color: var(--on-surface-variant);
        pointer-events: none;
    }
    .quick-add-bar input {
        padding: 8px 12px 8px 36px;
        border: 1px solid var(--outline-variant);
        border-radius: 0.5rem;
        background-color: var(--surface-container-low);
        font-size: 14px;
        color: var(--on-surface);
        width: 220px;
        transition: border-color 0.15s, box-shadow 0.15s;
    }
    .quick-add-bar input:focus {
        outline: none;
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
        background-color: var(--surface-container-lowest);
    }

    /* Sort select */
    .sort-select {
        padding: 6px 28px 6px 10px;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 0.5rem;
        font-size: 13px;
        color: var(--on-surface);
        appearance: auto;
        cursor: pointer;
    }
    .sort-select:focus {
        outline: none;
        border-color: var(--primary-container);
    }

    /* Tag chip in table */
    .tag-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 4px 12px;
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 999px;
        font-size: 13px;
        font-weight: 600;
        color: var(--on-surface);
        transition: background-color 0.15s ease;
    }
    .tag-chip .material-symbols-outlined { font-size: 14px; color: var(--on-surface-variant); }

    /* Tag ID monospace chip */
    .tag-id {
        font-family: 'Courier New', Courier, monospace;
        font-size: 12px;
        font-weight: 700;
        color: var(--on-surface-variant);
        background-color: var(--surface-container);
        border-radius: 4px;
        padding: 2px 8px;
        letter-spacing: 0.03em;
    }

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

                <%-- ─── Page Header + Quick Add ─── --%>
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3 flex-wrap">
                    <div>
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Tag Management</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Organize and manage metadata tags for the library catalog.</p>
                    </div>

                    <%-- Quick-add inline form (POST to server) --%>
                    <form action="${pageContext.request.contextPath}/librarian/tags" method="POST"
                          id="quickAddTagForm" novalidate>
                        <input type="hidden" name="action" value="addTag" />
                        <div class="quick-add-bar">
                            <div class="quick-input-wrap">
                                <span class="material-symbols-outlined input-icon">sell</span>
                                <input type="text" id="quickTagName" name="tagName"
                                       placeholder="New tag name..."
                                       required maxlength="100"
                                       aria-label="New tag name" />
                            </div>
                            <button type="submit" class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1" style="height: 36px;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
                                Add Tag
                            </button>
                        </div>
                    </form>
                </div>

                <%-- ─── Tags Table Card ─── --%>
                <section class="raised-card overflow-hidden mb-5">

                    <%-- Table toolbar: sort + count --%>
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 flex-wrap gap-2"
                         style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-lowest);">
                        <form action="${pageContext.request.contextPath}/librarian/tags" method="GET"
                              id="sortForm" class="d-flex align-items-center gap-2">
                            <label for="sortSelect" style="font-size: 13px; color: var(--on-surface-variant); font-weight: 600; white-space: nowrap;">Sort by:</label>
                            <select id="sortSelect" name="sort" class="sort-select"
                                    onchange="document.getElementById('sortForm').submit()">
                                <option value="name_asc"  ${param.sort == 'name_asc'  || empty param.sort ? 'selected' : ''}>Name (A–Z)</option>
                                <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Name (Z–A)</option>
                                <option value="id_asc"    ${param.sort == 'id_asc'    ? 'selected' : ''}>ID (Ascending)</option>
                                <option value="id_desc"   ${param.sort == 'id_desc'   ? 'selected' : ''}>ID (Descending)</option>
                            </select>
                        </form>
                        <span style="font-size: 13px; color: var(--on-surface-variant);">
                            <c:choose>
                                <c:when test="${not empty totalTags}">
                                    Showing
                                    <c:out value="${(currentPage - 1) * pageSize + 1}" />–<c:out value="${currentPage * pageSize > totalTags ? totalTags : currentPage * pageSize}" />
                                    of <c:out value="${totalTags}" /> tags
                                </c:when>
                                <c:otherwise>Showing 1–5 of 42 tags</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <%-- Table --%>
                    <div class="table-responsive">
                        <table class="table table-lms mb-0" aria-label="Library metadata tags">
                            <thead>
                                <tr>
                                    <th style="width: 120px;">Tag ID</th>
                                    <th>Tag Name</th>
                                    <th class="text-end" style="width: 120px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tags}">
                                        <c:forEach var="tag" items="${tags}">
                                            <tr>
                                                <td>
                                                    <span class="tag-id">#TG-<c:out value="${tag.tagId}" /></span>
                                                </td>
                                                <td>
                                                    <span class="tag-chip">
                                                        <span class="material-symbols-outlined">sell</span>
                                                        <c:out value="${tag.tagName}" />
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <button class="btn-icon" title="Edit tag"
                                                            onclick="openEditModal('<c:out value="${tag.tagId}"/>', '<c:out value="${tag.tagName}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </button>
                                                    <button class="btn-icon" style="color: var(--error);" title="Delete tag"
                                                            onclick="openDeleteModal('<c:out value="${tag.tagId}"/>', '<c:out value="${tag.tagName}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Static sample rows --%>
                                        <tr>
                                            <td><span class="tag-id">#TG-101</span></td>
                                            <td><span class="tag-chip"><span class="material-symbols-outlined">sell</span> Science Fiction</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="tag-id">#TG-102</span></td>
                                            <td><span class="tag-chip"><span class="material-symbols-outlined">sell</span> Historical Fiction</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="tag-id">#TG-103</span></td>
                                            <td><span class="tag-chip"><span class="material-symbols-outlined">sell</span> Biography</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="tag-id">#TG-104</span></td>
                                            <td><span class="tag-chip"><span class="material-symbols-outlined">sell</span> Academic Reference</span></td>
                                            <td class="text-end">
                                                <button class="btn-icon" title="Edit"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                <button class="btn-icon" style="color: var(--error);" title="Delete"><span class="material-symbols-outlined" style="font-size: 18px;">delete</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="tag-id">#TG-105</span></td>
                                            <td><span class="tag-chip"><span class="material-symbols-outlined">sell</span> Young Adult</span></td>
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

                    <%-- Pagination footer --%>
                    <div class="d-flex align-items-center justify-content-between px-4 py-3 flex-wrap gap-2"
                         style="border-top: 1px solid var(--outline-variant); background-color: var(--surface-container-lowest);">
                        <button class="page-btn fw-semibold px-3"
                                ${currentPage <= 1 ? 'disabled' : ''}
                                onclick="goToPage(${currentPage - 1})"
                                aria-label="Previous page">
                            Previous
                        </button>
                        <div class="d-flex gap-1 align-items-center">
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
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <button class="page-btn fw-semibold px-3"
                                ${currentPage >= totalPages ? 'disabled' : ''}
                                onclick="goToPage(${currentPage + 1})"
                                aria-label="Next page">
                            Next
                        </button>
                    </div>

                </section>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

    <%-- ════════════════════════════════════════
         MODAL: Edit Tag
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="editTagModal" tabindex="-1" aria-labelledby="editTagModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editTagModalLabel" style="font-size: 18px;">Edit Tag</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/tags" method="POST"
                      id="editTagForm" novalidate>
                    <input type="hidden" name="action" value="editTag" />
                    <input type="hidden" name="tagId" id="editTagId" />
                    <div class="modal-body py-3">
                        <label class="form-label fw-semibold text-on-surface-variant text-uppercase"
                               style="font-size: 11px; letter-spacing: 0.05em;" for="editTagName">
                            Tag Name <span style="color: var(--error);">*</span>
                        </label>
                        <input type="text" id="editTagName" name="tagName"
                               class="form-control rounded-3 py-2"
                               style="background-color: var(--surface-container-low); border-color: var(--outline-variant); font-size: 14px;"
                               required maxlength="100" />
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
         MODAL: Delete Tag Confirm
    ════════════════════════════════════════ --%>
    <div class="modal fade" id="deleteTagModal" tabindex="-1" aria-labelledby="deleteTagModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="deleteTagModalLabel" style="font-size: 18px; color: var(--error);">Delete Tag</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/librarian/tags" method="POST">
                    <input type="hidden" name="action" value="deleteTag" />
                    <input type="hidden" name="tagId" id="deleteTagId" />
                    <div class="modal-body py-3">
                        <p class="mb-1" style="font-size: 14px; color: var(--on-surface);">
                            Remove tag <strong id="deleteTagName"></strong>?
                        </p>
                        <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                            This will unlink the tag from all associated books. Books will not be deleted.
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

            /* ── Open Edit modal and pre-fill fields ── */
            function openEditModal(id, name) {
                document.getElementById('editTagId').value   = id;
                document.getElementById('editTagName').value = name;
                new bootstrap.Modal(document.getElementById('editTagModal')).show();
            }

            /* ── Open Delete confirm modal ── */
            function openDeleteModal(id, name) {
                document.getElementById('deleteTagId').value         = id;
                document.getElementById('deleteTagName').textContent = name;
                new bootstrap.Modal(document.getElementById('deleteTagModal')).show();
            }

            /* ── Quick-add form validation ── */
            document.getElementById('quickAddTagForm').addEventListener('submit', function (e) {
                const input = document.getElementById('quickTagName');
                if (!input.value.trim()) {
                    e.preventDefault();
                    input.focus();
                    input.classList.add('is-invalid');
                    return;
                }
                input.classList.remove('is-invalid');
            });

            /* ── Edit form validation ── */
            document.getElementById('editTagForm').addEventListener('submit', function (e) {
                if (!this.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                this.classList.add('was-validated');
            });

            /* ── Server-side pagination (preserves sort param) ── */
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
