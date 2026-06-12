<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
<jsp:include page="fragments/_sidebar.jsp" />
<div class="d-flex main-wrapper overflow-hidden">
    <main class="flex-grow-1 overflow-y-auto main-content-layout">
        <jsp:include page="fragments/_header.jsp" />
        <div class="container-fluid px-4 py-4 bm-page">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <c:out value="${sessionScope.successMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <c:out value="${sessionScope.errorMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                <div>
                    <p class="bm-page__eyebrow mb-1">Danh mục sách</p>
                    <h2 class="bm-page__title mb-1">Đầu sách</h2>
                    <p class="bm-page__subtitle mb-0">Quản lý thông tin thư mục; số lượng bản sao được cập nhật qua nghiệp vụ kho vật lý.</p>
                </div>
                <c:if test="${canEdit}">
                    <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createBookModal">
                        <span class="material-symbols-outlined">add</span>
                        Tạo đầu sách
                    </button>
                </c:if>
            </section>

            <form class="bm-filter-card bm-filter-card--compact mb-2" method="get" action="${pageContext.request.contextPath}/book-management/titles">
                <c:if test="${not empty selectedTagId}"><input type="hidden" name="tagId" value="${selectedTagId}"></c:if>
                <div class="row g-2">
                    <div class="col-xl-5 col-lg-6 bm-search">
                        <span class="material-symbols-outlined">search</span>
                        <input class="form-control" name="q" value="<c:out value="${q}" />"
                               placeholder="Tìm theo tên sách, ISBN hoặc tác giả">
                    </div>
                    <div class="col-xl-2 col-md-4">
                        <select class="form-select" name="categoryId" aria-label="Lọc theo thể loại">
                            <option value="">Tất cả thể loại</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" ${selectedCategoryId == category.categoryId ? 'selected' : ''}>
                                    <c:out value="${category.name}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-xl-2 col-md-4">
                        <select class="form-select" name="status" aria-label="Lọc theo trạng thái">
                            <option value="" ${empty selectedStatus ? 'selected' : ''}>Mọi trạng thái</option>
                            <option value="available" ${selectedStatus == 'available' ? 'selected' : ''}>Đang sử dụng</option>
                            <option value="noCopies" ${selectedStatus == 'noCopies' ? 'selected' : ''}>Chưa có bản sao</option>
                            <option value="unavailable" ${selectedStatus == 'unavailable' ? 'selected' : ''}>Ngừng sử dụng</option>
                        </select>
                    </div>
                    <div class="col-xl-3 col-lg-6">
                        <div class="bm-filter-actions bm-filter-actions--compact">
                            <button class="btn bm-filter-button" type="submit">
                                <span class="material-symbols-outlined">filter_alt</span>
                                Lọc
                            </button>
                            <a class="btn bm-reset-button" href="${pageContext.request.contextPath}/book-management/titles"
                               title="Đặt lại bộ lọc" aria-label="Đặt lại bộ lọc">
                                <span class="material-symbols-outlined">refresh</span>
                            </a>
                        </div>
                    </div>
                </div>
            </form>

            <div class="bm-summary-strip bm-summary-strip--compact mb-2">
                <span class="bm-summary-strip__item">Tổng cộng: <strong><fmt:formatNumber value="${summary.totalBooks}" /> đầu sách</strong></span>
                <span class="bm-summary-strip__item">Tổng bản sao: <strong><fmt:formatNumber value="${summary.totalCopies}" /></strong></span>
                <span class="bm-summary-strip__item">Sẵn sàng: <strong><fmt:formatNumber value="${summary.availableCopies}" /></strong></span>
                <span class="bm-summary-strip__item">Chưa có bản sao: <strong><fmt:formatNumber value="${summary.booksWithoutCopies}" /> đầu sách</strong></span>
            </div>

            <section class="bm-table-card bm-table-card--primary">
                <div class="table-responsive">
                    <table class="table table-lms">
                        <thead><tr><th>Đầu sách</th><th>ISBN</th><th>Thể loại &amp; tag</th><th>Xuất bản</th><th>Tổng bản sao</th><th>Sẵn sàng</th><th>Trạng thái</th><th class="bm-action-column"><span class="visually-hidden">Thao tác</span></th></tr></thead>
                        <tbody>
                            <c:forEach var="book" items="${books}">
                                <tr>
                                    <td>
                                        <div class="bm-book">
                                            <c:choose>
                                                <c:when test="${not empty book.imagePath}">
                                                    <img class="bm-book__cover" src="${pageContext.request.contextPath}/book-images/${book.imagePath}" alt="Ảnh bìa đầu sách" loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bm-book__cover material-symbols-outlined">menu_book</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <p class="bm-book__title mb-1"><c:out value="${book.title}" /></p>
                                                <p class="bm-book__meta mb-0"><c:out value="${empty book.author ? 'Chưa cập nhật tác giả' : book.author}" /></p>
                                            </div>
                                        </div>
                                    </td>
                                    <td><c:out value="${book.isbn}" /></td>
                                    <td>
                                        <div class="d-flex flex-wrap gap-1">
                                            <c:forEach var="category" items="${book.categories}"><span class="bm-tag"><c:out value="${category.name}" /></span></c:forEach>
                                            <c:forEach var="tag" items="${book.tags}"><span class="bm-tag bm-tag--secondary"><c:out value="${tag.name}" /></span></c:forEach>
                                            <c:if test="${empty book.categories and empty book.tags}"><span class="bm-empty-note">Chưa phân loại</span></c:if>
                                        </div>
                                    </td>
                                    <td><c:out value="${empty book.publisher ? 'Chưa cập nhật' : book.publisher}" /><c:if test="${not empty book.publicationYear}">, <c:out value="${book.publicationYear}" /></c:if></td>
                                    <td><strong><fmt:formatNumber value="${book.totalQuantity}" /></strong></td>
                                    <td><strong><fmt:formatNumber value="${book.availableQuantity}" /></strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.totalQuantity == 0}"><span class="bm-badge bm-badge--neutral">Chưa có bản sao</span></c:when>
                                            <c:when test="${book.status == 'available'}"><span class="bm-badge bm-badge--success">Đang sử dụng</span></c:when>
                                            <c:otherwise><span class="bm-badge bm-badge--neutral">Ngừng sử dụng</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="bm-action-column">
                                        <c:choose>
                                            <c:when test="${canEdit}">
                                                <c:url var="editUrl" value="/book-management/titles">
                                                    <c:param name="editId" value="${book.bookId}" />
                                                </c:url>
                                                <a class="bm-action-icon" href="${editUrl}" title="Chỉnh sửa đầu sách"
                                                   aria-label="Chỉnh sửa đầu sách">
                                                    <span class="material-symbols-outlined" aria-hidden="true">edit</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise><span class="bm-badge bm-badge--neutral">Chỉ xem</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty books}">
                                <tr><td colspan="8"><div class="bm-empty-state"><span class="material-symbols-outlined">menu_book</span><strong>Không tìm thấy đầu sách</strong><span>Hãy thử thay đổi bộ lọc hoặc tạo đầu sách mới.</span></div></td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <c:if test="${totalPages > 1}">
                <nav class="d-flex justify-content-between align-items-center mt-3" aria-label="Phân trang đầu sách">
                    <span class="bm-section-note">Trang ${currentPage}/${totalPages} · ${totalItems} kết quả</span>
                    <div class="bm-actions">
                        <c:url var="previousUrl" value="/book-management/titles"><c:param name="q" value="${q}" /><c:param name="categoryId" value="${selectedCategoryId}" /><c:param name="tagId" value="${selectedTagId}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage - 1}" /></c:url>
                        <c:url var="nextUrl" value="/book-management/titles"><c:param name="q" value="${q}" /><c:param name="categoryId" value="${selectedCategoryId}" /><c:param name="tagId" value="${selectedTagId}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage + 1}" /></c:url>
                        <a class="btn bm-btn-secondary ${currentPage == 1 ? 'disabled' : ''}" href="${previousUrl}">Trang trước</a>
                        <a class="btn bm-btn-secondary ${currentPage == totalPages ? 'disabled' : ''}" href="${nextUrl}">Trang sau</a>
                    </div>
                </nav>
            </c:if>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/book-titles.js?v=20260610-1"></script>
    </main>
</div>

<c:if test="${canEdit}">
    <div class="modal fade bm-modal" id="createBookModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg"><div class="modal-content">
            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/book-management/titles">
                <input type="hidden" name="action" value="create">
                <div class="modal-header"><div><h5 class="modal-title">Tạo đầu sách</h5><p class="bm-section-note mb-0">Đầu sách mới được khởi tạo với số lượng bằng 0.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
                <div class="modal-body"><jsp:include page="fragments/_book-form-fields.jsp" /></div>
                <div class="modal-footer"><button type="button" class="btn bm-btn-secondary" data-bs-dismiss="modal">Hủy</button><button type="submit" class="btn btn-primary-custom">Lưu đầu sách</button></div>
            </form>
        </div></div>
    </div>
</c:if>

<c:if test="${canEdit and not empty editBook}">
    <div class="modal fade bm-modal" id="editBookModal" tabindex="-1" aria-hidden="true" data-auto-open="true">
        <div class="modal-dialog modal-lg"><div class="modal-content">
            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/book-management/titles">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="bookId" value="${editBook.bookId}">
                <div class="modal-header"><div><h5 class="modal-title">Chỉnh sửa đầu sách</h5><p class="bm-section-note mb-0">ISBN và số lượng tồn kho không thể sửa trực tiếp.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
                <div class="modal-body"><jsp:include page="fragments/_book-form-fields.jsp"><jsp:param name="editing" value="true" /></jsp:include></div>
                <div class="modal-footer"><a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/titles">Hủy</a><button type="submit" class="btn btn-primary-custom">Lưu thay đổi</button></div>
            </form>
        </div></div>
    </div>
</c:if>
</body>
</html>
