<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Book Register ── */

    /* Form card */
    .form-card {
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 1rem;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        padding: 1.5rem;
        margin-bottom: 1.25rem;
    }
    .form-card-title {
        font-size: 15px;
        font-weight: 600;
        color: var(--on-surface);
        padding-bottom: 0.75rem;
        margin-bottom: 1.25rem;
        border-bottom: 1px solid var(--outline-variant);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* Input group overrides to match design system */
    .input-group-text {
        background-color: var(--surface-container-low);
        border-color: var(--outline-variant);
        border-right: none;
        color: var(--on-surface-variant);
    }
    .form-control,
    .form-select,
    .form-control-plain {
        background-color: var(--surface-container-low);
        border-color: var(--outline-variant);
        color: var(--on-surface);
        font-size: 14px;
    }
    .form-control:focus,
    .form-select:focus {
        background-color: var(--surface-container-lowest);
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
        color: var(--on-surface);
    }
    .input-group:focus-within .input-group-text {
        border-color: var(--primary-container);
    }
    .form-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        color: var(--on-surface-variant);
        margin-bottom: 6px;
    }
    .form-text {
        font-size: 11px;
        color: var(--on-surface-variant);
    }

    /* Cover image upload area */
    .cover-upload-zone {
        border: 2px dashed var(--outline-variant);
        border-radius: 0.75rem;
        aspect-ratio: 2 / 3;
        cursor: pointer;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 8px;
        background-color: var(--surface-container-low);
        transition: border-color 0.2s ease, background-color 0.2s ease;
        position: relative;
        overflow: hidden;
    }
    .cover-upload-zone:hover {
        border-color: var(--primary-container);
        background-color: var(--surface-container);
    }
    .cover-upload-zone .upload-label-text {
        font-size: 13px;
        font-weight: 600;
        color: var(--on-surface-variant);
    }
    .cover-upload-zone .upload-hint {
        font-size: 11px;
        color: var(--on-surface-variant);
        opacity: 0.7;
    }
    #coverPreview {
        display: none;
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    /* Category pill checkboxes */
    .category-pill {
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 999px;
        padding: 4px 14px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        color: var(--on-surface-variant);
        transition: all 0.15s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        user-select: none;
    }
    .category-pill:hover {
        background-color: var(--surface-container);
        border-color: var(--outline);
    }
    .category-pill input[type="checkbox"] {
        display: none;
    }
    .category-pill.selected {
        background-color: var(--primary-fixed);
        border-color: var(--primary-fixed-dim);
        color: var(--on-primary-container);
    }

    /* Breadcrumb link */
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

    /* Required asterisk */
    .req { color: var(--error); margin-left: 2px; }
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

                <%-- ─── Breadcrumb ─── --%>
                <div class="d-flex align-items-center gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/librarian/catalog" class="breadcrumb-link" aria-label="Back to Catalog">
                        <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                        <span>Book Catalog</span>
                    </a>
                    <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                    <span style="font-size: 13px; font-weight: 600; color: var(--on-surface);">Register New Book</span>
                </div>

                <%-- ─── Page Title ─── --%>
                <div class="mb-4">
                    <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Register Book to Collection</h2>
                    <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Add a new title to the library catalog. Fields marked <span class="req">*</span> are required.</p>
                </div>

                <%-- ─── Register Form ─── --%>
                <form action="${pageContext.request.contextPath}/librarian/catalog" method="POST"
                      enctype="multipart/form-data" id="registerBookForm" novalidate>
                    <input type="hidden" name="action" value="registerBook" />

                    <div class="row g-4 align-items-start">

                        <%-- ══════════════ LEFT COLUMN: Main Data ══════════════ --%>
                        <div class="col-12 col-xl-8 col-lg-7 d-flex flex-column gap-0">

                            <%-- Basic Information --%>
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 20px;">info</span>
                                    Basic Information
                                </h3>
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="title" class="form-label">Title <span class="req">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">book</span>
                                            </span>
                                            <input type="text" class="form-control" id="title" name="title"
                                                   placeholder="Enter full book title" required
                                                   value="<c:out value='${param.title}'/>" />
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label for="isbn" class="form-label">ISBN <span class="req">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">barcode</span>
                                            </span>
                                            <input type="text" class="form-control" id="isbn" name="isbn"
                                                   minlength="10" maxlength="13"
                                                   placeholder="e.g. 9780123456789" required
                                                   value="<c:out value='${param.isbn}'/>" />
                                        </div>
                                        <div class="form-text mt-1">ISBN-10 or ISBN-13 format</div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label for="author" class="form-label">Author <span class="req">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">person</span>
                                            </span>
                                            <input type="text" class="form-control" id="author" name="author"
                                                   placeholder="Primary author name" required
                                                   value="<c:out value='${param.author}'/>" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- Publishing Details --%>
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 20px;">domain</span>
                                    Publishing Details
                                </h3>
                                <div class="row g-3">
                                    <div class="col-12 col-md-6">
                                        <label for="publisher" class="form-label">Publisher</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">corporate_fare</span>
                                            </span>
                                            <input type="text" class="form-control" id="publisher" name="publisher"
                                                   placeholder="Publishing house"
                                                   value="<c:out value='${param.publisher}'/>" />
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="publishYear" class="form-label">Publication Year</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">calendar_today</span>
                                            </span>
                                            <input type="number" class="form-control" id="publishYear" name="publishYear"
                                                   min="1000" max="2099" placeholder="YYYY"
                                                   value="<c:out value='${param.publishYear}'/>" />
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="replacementPrice" class="form-label">Replacement Price ($)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">payments</span>
                                            </span>
                                            <input type="number" class="form-control" id="replacementPrice" name="replacementPrice"
                                                   min="0" step="0.01" placeholder="0.00"
                                                   value="<c:out value='${param.replacementPrice}'/>" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- Description --%>
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 20px;">notes</span>
                                    Description
                                </h3>
                                <label for="description" class="visually-hidden">Book description</label>
                                <textarea class="form-control" id="description" name="description"
                                          rows="5" style="resize: vertical;"
                                          placeholder="Enter book synopsis or catalog notes..."><c:out value="${param.description}"/></textarea>
                            </div>

                        </div><%-- /left col --%>

                        <%-- ══════════════ RIGHT COLUMN: Sidebar Data ══════════════ --%>
                        <div class="col-12 col-xl-4 col-lg-5 d-flex flex-column gap-0">

                            <%-- Cover Image Upload --%>
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 20px;">image</span>
                                    Cover Image
                                </h3>
                                <div class="cover-upload-zone" id="coverUploadZone"
                                     onclick="document.getElementById('coverImage').click();"
                                     role="button" tabindex="0" aria-label="Upload book cover image"
                                     onkeydown="if(event.key==='Enter'||event.key===' ') document.getElementById('coverImage').click();">
                                    <span class="material-symbols-outlined" style="font-size: 48px; color: var(--outline);">add_photo_alternate</span>
                                    <span class="upload-label-text">Click to Upload Cover</span>
                                    <span class="upload-hint">JPEG, PNG · Max 2 MB</span>
                                    <img id="coverPreview" src="" alt="Cover preview" />
                                </div>
                                <input type="file" id="coverImage" name="coverImage"
                                       class="d-none" accept="image/jpeg, image/png" />
                                <p class="form-text mt-2 text-center" id="coverFileName">No file selected</p>
                            </div>

                            <%-- Classification --%>
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <span class="material-symbols-outlined text-primary-custom" style="font-size: 20px;">label</span>
                                    Classification
                                </h3>

                                <div class="mb-4">
                                    <p class="form-label mb-2">Categories</p>
                                    <div class="d-flex flex-wrap gap-2" id="categoryPills">
                                        <label class="category-pill" data-val="Fiction">
                                            <input type="checkbox" name="categories" value="Fiction" />
                                            Fiction
                                        </label>
                                        <label class="category-pill" data-val="Non-Fiction">
                                            <input type="checkbox" name="categories" value="Non-Fiction" />
                                            Non-Fiction
                                        </label>
                                        <label class="category-pill" data-val="Science">
                                            <input type="checkbox" name="categories" value="Science" />
                                            Science
                                        </label>
                                        <label class="category-pill" data-val="Technology">
                                            <input type="checkbox" name="categories" value="Technology" />
                                            Technology
                                        </label>
                                        <label class="category-pill" data-val="History">
                                            <input type="checkbox" name="categories" value="History" />
                                            History
                                        </label>
                                        <label class="category-pill" data-val="Arts">
                                            <input type="checkbox" name="categories" value="Arts" />
                                            Arts
                                        </label>
                                        <label class="category-pill" data-val="Reference">
                                            <input type="checkbox" name="categories" value="Reference" />
                                            Reference
                                        </label>
                                    </div>
                                </div>

                                <div>
                                    <label for="tags" class="form-label">Tags <span class="form-text fw-normal">(comma-separated)</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">sell</span>
                                        </span>
                                        <input type="text" class="form-control" id="tags" name="tags"
                                               placeholder="e.g. bestseller, novel, 2023"
                                               value="<c:out value='${param.tags}'/>" />
                                    </div>
                                </div>
                            </div>

                            <%-- Action Buttons --%>
                            <div class="d-flex flex-column gap-2">
                                <button type="submit" class="btn btn-primary-custom py-2 rounded-3 fw-bold d-flex align-items-center justify-content-center gap-2" id="btnSubmitBook">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                                    Finalize Registration
                                </button>
                                <a href="${pageContext.request.contextPath}/librarian/catalog"
                                   class="btn py-2 rounded-3 fw-bold text-center"
                                   style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                    Discard &amp; Go Back
                                </a>
                            </div>

                        </div><%-- /right col --%>

                    </div><%-- /row --%>
                </form>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';

            /* ── Cover image preview ── */
            const coverInput   = document.getElementById('coverImage');
            const coverPreview = document.getElementById('coverPreview');
            const coverZone    = document.getElementById('coverUploadZone');
            const coverName    = document.getElementById('coverFileName');

            coverInput.addEventListener('change', function () {
                const file = this.files[0];
                if (!file) return;

                if (file.size > 2 * 1024 * 1024) {
                    alert('File size exceeds 2 MB. Please choose a smaller image.');
                    this.value = '';
                    return;
                }

                coverName.textContent = file.name;
                const reader = new FileReader();
                reader.onload = (e) => {
                    coverPreview.src     = e.target.result;
                    coverPreview.style.display = 'block';
                    /* Dim the overlay icons while preview is shown */
                    coverZone.querySelectorAll('.upload-label-text, .upload-hint, .material-symbols-outlined:not(img ~ *)').forEach(el => {
                        el.style.opacity = '0';
                    });
                };
                reader.readAsDataURL(file);
            });

            /* ── Category pill toggle ── */
            document.querySelectorAll('.category-pill').forEach(pill => {
                pill.addEventListener('click', function () {
                    const cb = this.querySelector('input[type="checkbox"]');
                    /* Let the browser toggle the checkbox first, then sync the class */
                    requestAnimationFrame(() => {
                        this.classList.toggle('selected', cb.checked);
                    });
                });
            });

            /* ── Client-side form validation ── */
            document.getElementById('registerBookForm').addEventListener('submit', function (e) {
                if (!this.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                this.classList.add('was-validated');
            });

        })();
    </script>

</body>
</html>
