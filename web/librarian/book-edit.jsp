<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Book Edit (focus-mode form) ── */

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

    /* Narrow form container */
    .form-content-max {
        max-width: 860px;
        margin: 0 auto;
    }

    /* Form cards */
    .form-card {
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 1rem;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        padding: 1.5rem;
        margin-bottom: 1.25rem;
    }
    .form-section-title {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: var(--on-surface-variant);
        padding-bottom: 10px;
        margin-bottom: 16px;
        border-bottom: 1px solid var(--outline-variant);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* Form controls – override Bootstrap to match design system */
    .form-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        color: var(--on-surface-variant);
        margin-bottom: 6px;
    }
    .form-control,
    .form-select {
        background-color: var(--surface-container-low);
        border-color: var(--outline-variant);
        color: var(--on-surface);
        font-size: 14px;
        padding: 10px 14px;
    }
    .form-control:focus,
    .form-select:focus {
        background-color: var(--surface-container-lowest);
        border-color: var(--primary-container);
        box-shadow: 0 0 0 0.2rem rgba(249, 115, 22, 0.2);
        color: var(--on-surface);
    }
    /* Lock ISBN style */
    .form-control:disabled,
    .form-control[readonly] {
        background-color: var(--surface-container);
        color: var(--on-surface-variant);
        opacity: 0.85;
        cursor: not-allowed;
    }
    .form-text {
        font-size: 11px;
        color: var(--on-surface-variant);
        margin-top: 4px;
    }

    /* Cover image preview component */
    .cover-upload-area {
        display: flex;
        gap: 20px;
        align-items: flex-start;
    }
    .cover-preview {
        width: 120px;
        height: 180px;
        border-radius: 8px;
        background-color: var(--surface-container-high);
        border: 2px dashed var(--outline-variant);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        flex-shrink: 0;
    }
    .cover-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: none;
    }
    .cover-preview.has-image img { display: block; }
    .cover-preview.has-image .preview-icon { display: none; }
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

                <div class="form-content-max">

                    <%-- ─── Breadcrumb ─── --%>
                    <div class="d-flex align-items-center gap-2 mb-4">
                        <a href="${pageContext.request.contextPath}/librarian/catalog" class="breadcrumb-link" aria-label="Quay lại mục lục">
                            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                            <span>Mục lục Sách</span>
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <a href="${pageContext.request.contextPath}/librarian/book-detail?id=<c:out value='${book.bookId}'/>" class="breadcrumb-link">
                            Chi tiết sách
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface);">Sửa sách</span>
                    </div>

                    <%-- ─── Page Title ─── --%>
                    <div class="mb-4">
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Sửa bản ghi sách</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Cập nhật siêu dữ liệu, phân loại và ảnh bìa cho sách này.</p>
                    </div>

                    <%-- ─── Edit Form ─── --%>
                    <form action="${pageContext.request.contextPath}/librarian/books" method="POST"
                          id="editBookForm" novalidate>
                        <input type="hidden" name="action" value="editBook" />
                        <input type="hidden" name="bookId" value="<c:out value='${book.bookId}'/>" />

                        <%-- Core Identification (Readonly ISBN) --%>
                        <div class="form-card">
                            <div class="form-section-title">
                                <span>Định danh cốt lõi</span>
                                <span class="badge" style="background-color: var(--surface-container-high); color: var(--on-surface-variant); font-size: 10px;">ID: <c:out value="${book.bookId}" /></span>
                            </div>
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="isbn">ISBN (Mã số sách tiêu chuẩn quốc tế)</label>
                                    <div class="input-group">
                                        <span class="input-group-text" style="background-color: var(--surface-container); border-color: var(--outline-variant); color: var(--on-surface-variant);">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">lock</span>
                                        </span>
                                        <input type="text" id="isbn" name="isbn" class="form-control"
                                               value="<c:out value='${book.isbn}'/>"
                                               readonly aria-describedby="isbnHelp" />
                                    </div>
                                    <div id="isbnHelp" class="form-text">Không thể thay đổi ISBN sau khi đăng ký.</div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="publisher">Nhà xuất bản <span style="color: var(--error);">*</span></label>
                                    <input type="text" id="publisher" name="publisher" class="form-control rounded-3"
                                           value="<c:out value='${book.publisher}'/>"
                                           required />
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="publishYear">Năm xuất bản <span style="color: var(--error);">*</span></label>
                                    <input type="number" id="publishYear" name="publishYear" class="form-control rounded-3"
                                           value="<c:out value='${book.publishYear}'/>"
                                           min="1000" max="2100" required />
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="replacementPrice">Giá bồi thường (VNĐ) <span style="color: var(--error);">*</span></label>
                                    <input type="number" id="replacementPrice" name="replacementPrice" class="form-control rounded-3"
                                           value="<c:out value='${book.replacementPrice}'/>"
                                           min="0" required />
                                </div>
                            </div>
                        </div>

                        <%-- Metadata --%>
                        <div class="form-card">
                            <p class="form-section-title">Siêu dữ liệu sách</p>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label" for="title">Tiêu đề sách <span style="color: var(--error);">*</span></label>
                                    <input type="text" id="title" name="title" class="form-control rounded-3"
                                           value="<c:out value='${book.title}'/>"
                                           required />
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="author">Tác giả <span style="color: var(--error);">*</span></label>
                                    <input type="text" id="author" name="author" class="form-control rounded-3"
                                           value="<c:out value='${book.author}'/>"
                                           placeholder="Phân tách nhiều tác giả bằng dấu phẩy" required />
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="description">Tóm tắt / Mô tả</label>
                                    <textarea id="description" name="description" class="form-control rounded-3"
                                              rows="4" style="resize: vertical;"><c:out value="${book.description}" /></textarea>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="categoryId">Thể loại <span style="color: var(--error);">*</span></label>
                                    <select id="categoryId" name="categoryId" class="form-select rounded-3" required>
                                        <option value="" disabled>Chọn một thể loại...</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" ${book.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="tags">Thẻ</label>
                                    <select id="tags" name="tagIds" class="form-select rounded-3" multiple aria-describedby="tagHelp">
                                        <%-- Note: Multi-select UI should ideally be enhanced with Select2 or similar --%>
                                        <c:forEach var="tag" items="${tags}">
                                            <option value="${tag.tagId}" ${book.tagIds.contains(tag.tagId) ? 'selected' : ''}>
                                                ${tag.tagName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div id="tagHelp" class="form-text">Giữ Ctrl/Cmd để chọn nhiều thẻ.</div>
                                </div>
                            </div>
                        </div>

                        <%-- Visuals --%>
                        <div class="form-card">
                            <p class="form-section-title">Tài nguyên hình ảnh</p>
                            <div class="cover-upload-area">
                                <div class="cover-preview ${not empty book.coverImageUrl ? 'has-image' : ''}" id="coverPreviewContainer">
                                    <span class="material-symbols-outlined preview-icon" style="font-size: 32px; color: var(--outline-variant);">add_photo_alternate</span>
                                    <img id="coverPreviewImage" 
                                         src="${not empty book.coverImageUrl ? pageContext.request.contextPath.concat('/').concat(book.coverImageUrl) : ''}" 
                                         alt="Cover Preview" />
                                </div>
                                <div class="flex-grow-1">
                                    <label class="form-label" for="coverImageUrl">URL ảnh bìa</label>
                                    <input type="url" id="coverImageUrl" name="coverImageUrl" class="form-control rounded-3 mb-2"
                                           value="<c:out value='${book.coverImageUrl}'/>"
                                           placeholder="https://example.com/cover.jpg" />
                                    <div class="form-text">Hiện tại, chúng tôi chỉ hỗ trợ URL ảnh bên ngoài. Để trống để sử dụng biểu tượng sách mặc định.</div>
                                </div>
                            </div>
                        </div>

                        <%-- Form Actions --%>
                        <div class="d-flex justify-content-end align-items-center gap-2 pt-2 pb-5">
                            <a href="${pageContext.request.contextPath}/librarian/book-detail?id=<c:out value='${book.bookId}'/>"
                               class="btn py-2 px-4 rounded-pill fw-bold"
                               style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                Hủy
                            </a>
                            <button type="submit" class="btn btn-primary-custom py-2 px-4 rounded-pill fw-bold d-flex align-items-center gap-2" id="btnSaveBook">
                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                Lưu thay đổi
                            </button>
                        </div>

                    </form>

                </div><%-- /form-content-max --%>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';
            
            /* ── Live Image Preview ── */
            const coverInput = document.getElementById('coverImageUrl');
            const previewContainer = document.getElementById('coverPreviewContainer');
            const previewImage = document.getElementById('coverPreviewImage');

            coverInput.addEventListener('input', function() {
                const url = this.value.trim();
                if (url) {
                    previewImage.src = url;
                    previewContainer.classList.add('has-image');
                } else {
                    previewImage.src = '';
                    previewContainer.classList.remove('has-image');
                }
            });

            /* ── Client-side Validation ── */
            document.getElementById('editBookForm').addEventListener('submit', function (e) {
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
