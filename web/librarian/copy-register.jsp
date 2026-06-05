<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-scoped styles for Copy Register (focus-mode form) ── */

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
        max-width: 720px;
        margin: 0 auto;
    }

    /* Consistent form cards */
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

    /* Icon-prefixed input wrapper */
    .input-icon-wrap { position: relative; }
    .input-icon-wrap .input-icon {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--outline);
        font-size: 18px;
        pointer-events: none;
    }
    .input-icon-wrap .form-control { padding-left: 42px; }
    
    /* Input group for barcode scanner */
    .barcode-group {
        display: flex;
        gap: 8px;
    }
    .barcode-group .input-icon-wrap { flex-grow: 1; }
    .btn-scan {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 44px;
        border: 1px solid var(--outline-variant);
        border-radius: 0.5rem;
        background-color: var(--surface-container);
        color: var(--on-surface-variant);
        transition: all 0.15s;
    }
    .btn-scan:hover {
        background-color: var(--primary-container);
        color: var(--on-primary-container);
        border-color: var(--primary-container);
    }

    /* Associated book banner */
    .book-banner {
        display: flex;
        align-items: center;
        gap: 16px;
        background-color: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 1rem;
        padding: 1.25rem;
        margin-bottom: 1.25rem;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    }
    .book-banner-thumb {
        width: 56px;
        min-width: 56px;
        height: 80px;
        border-radius: 6px;
        background-color: var(--surface-container-high);
        border: 1px solid var(--outline-variant);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        flex-shrink: 0;
    }
    .book-banner-thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }
    .book-banner-tag {
        display: block;
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: var(--primary-container);
        margin-bottom: 4px;
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
                        <a href="${pageContext.request.contextPath}/librarian/catalog.jsp" class="breadcrumb-link" aria-label="Quay lại mục lục">
                            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                            <span>Mục lục Sách</span>
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${book.bookId}'/>" class="breadcrumb-link">
                            Chi tiết sách
                        </a>
                        <span class="text-on-surface-variant" style="font-size: 16px; user-select: none;">/</span>
                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface);">Thêm bản sao</span>
                    </div>

                    <%-- ─── Page Title ─── --%>
                    <div class="mb-4">
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Thêm bản sao vật lý</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Đăng ký một bản sao vật lý mới của một cuốn sách hiện có vào kho.</p>
                    </div>

                    <%-- ─── Associated Book Banner ─── --%>
                    <div class="book-banner">
                        <div class="book-banner-thumb">
                            <c:choose>
                                <c:when test="${not empty book.coverImageUrl}">
                                    <img src="${pageContext.request.contextPath}/<c:out value='${book.coverImageUrl}'/>"
                                         alt="Cover of <c:out value='${book.title}'/>" />
                                </c:when>
                                <c:otherwise>
                                    <span class="material-symbols-outlined" style="font-size: 28px; color: var(--on-surface-variant);">menu_book</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex-grow-1 min-width-0">
                            <span class="book-banner-tag">Bản ghi gốc</span>
                            <h3 class="fw-bold mb-1" style="font-size: 16px; color: var(--on-surface); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                <c:out value="${not empty book.title ? book.title : 'Tiêu đề sách đã chọn'}" />
                            </h3>
                            <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">
                                <c:out value="${not empty book.author ? book.author : 'Tên tác giả'}" />
                                <c:if test="${not empty book.isbn}">
                                    &middot; ISBN: <span class="font-monospace"><c:out value="${book.isbn}" /></span>
                                </c:if>
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${book.bookId}'/>"
                           class="btn-icon flex-shrink-0" title="Xem bản ghi sách">
                            <span class="material-symbols-outlined" style="font-size: 20px;">open_in_new</span>
                        </a>
                    </div>

                    <%-- ─── Register Form ─── --%>
                    <form action="${pageContext.request.contextPath}/librarian/copies" method="POST"
                          id="registerCopyForm" novalidate>
                        <input type="hidden" name="action" value="addCopy" />
                        <input type="hidden" name="bookId" value="<c:out value='${book.bookId}'/>" />

                        <%-- Identification --%>
                        <div class="form-card">
                            <p class="form-section-title">Định danh</p>
                            <div class="mb-0">
                                <label class="form-label" for="barcode">Mã vạch hệ thống <span style="color: var(--error);">*</span></label>
                                <div class="barcode-group">
                                    <div class="input-icon-wrap">
                                        <span class="material-symbols-outlined input-icon">barcode_scanner</span>
                                        <input type="text" id="barcode" name="barcode" class="form-control rounded-3"
                                               value="<c:out value='${param.barcode}'/>"
                                               placeholder="Quét hoặc nhập mã vạch thủ công"
                                               required aria-describedby="barcodeHelp" autofocus />
                                    </div>
                                    <button type="button" class="btn-scan" title="Tự động tạo mã vạch" id="btnGenerateBarcode">
                                        <span class="material-symbols-outlined">auto_fix_high</span>
                                    </button>
                                </div>
                                <div id="barcodeHelp" class="form-text">Phải là duy nhất trên toàn hệ thống thư viện.</div>
                            </div>
                        </div>

                        <%-- Physical Details --%>
                        <div class="form-card">
                            <p class="form-section-title">Chi tiết vật lý</p>
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="location">Vị trí kệ <span style="color: var(--error);">*</span></label>
                                    <div class="input-icon-wrap">
                                        <span class="material-symbols-outlined input-icon">location_on</span>
                                        <input type="text" id="location" name="location" class="form-control rounded-3"
                                               value="<c:out value='${param.location}'/>"
                                               placeholder="VD: Kệ chính, Tầng 3, Kệ B4" required />
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="condition">Tình trạng ban đầu <span style="color: var(--error);">*</span></label>
                                    <select id="condition" name="condition" class="form-select rounded-3" required>
                                        <option value="New"     ${param.condition == 'New'     || empty param.condition ? 'selected' : ''}>Mới / Hoàn hảo</option>
                                        <option value="Good"    ${param.condition == 'Good'    ? 'selected' : ''}>Tốt / Hao mòn nhẹ</option>
                                        <option value="Fair"    ${param.condition == 'Fair'    ? 'selected' : ''}>Khá / Có thể sử dụng</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="conditionNotes">Ghi chú tình trạng <span class="form-text fw-normal text-lowercase" style="letter-spacing: 0;">(tùy chọn)</span></label>
                                    <textarea id="conditionNotes" name="conditionNotes" class="form-control rounded-3"
                                              rows="2" style="resize: vertical;"
                                              placeholder="Ghi lại mọi khiếm khuyết hiện có khi nhận..."><c:out value="${param.conditionNotes}" /></textarea>
                                </div>
                            </div>
                        </div>
                        
                        <%-- Initial Status --%>
                        <div class="form-card">
                            <p class="form-section-title">Trạng thái kho</p>
                            <div class="mb-0">
                                <label class="form-label" for="status">Trạng thái ban đầu</label>
                                <select id="status" name="status" class="form-select rounded-3">
                                    <option value="AVAILABLE" selected>Sẵn có (Sẵn sàng luân chuyển)</option>
                                    <option value="MAINTENANCE">Đang xử lý (Chưa thể đưa lên kệ)</option>
                                </select>
                            </div>
                        </div>

                        <%-- Form Actions --%>
                        <div class="d-flex justify-content-end align-items-center gap-2 pt-2 pb-5">
                            <a href="${pageContext.request.contextPath}/librarian/book-detail.jsp?id=<c:out value='${book.bookId}'/>"
                               class="btn py-2 px-4 rounded-pill fw-bold"
                               style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                Hủy
                            </a>
                            <button type="submit" class="btn btn-primary-custom py-2 px-4 rounded-pill fw-bold d-flex align-items-center gap-2" id="btnSaveCopy">
                                <span class="material-symbols-outlined" style="font-size: 18px;">add_task</span>
                                Đăng ký bản sao
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
            
            /* ── Auto-generate Barcode (Mock implementation for UX) ── */
            document.getElementById('btnGenerateBarcode')?.addEventListener('click', function() {
                const prefix = 'LIB-';
                const randomPart = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
                const barcodeInput = document.getElementById('barcode');
                barcodeInput.value = prefix + randomPart;
                barcodeInput.focus();
            });

            /* ── Client-side validation ── */
            document.getElementById('registerCopyForm').addEventListener('submit', function (e) {
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
