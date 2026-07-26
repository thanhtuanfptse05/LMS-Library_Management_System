<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />
                <div class="container-fluid px-4 py-4 bm-page bm-title-page">
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
                        <div class="bm-actions">
                            <c:url var="exportTitlesUrl" value="/librarian/book-management/titles/export">
                                <c:param name="q" value="${q}" />
                                <c:param name="categoryId" value="${selectedCategoryId}" />
                                <c:param name="tagId" value="${selectedTagId}" />
                                <c:param name="status" value="${selectedStatus}" />
                                <c:param name="sort" value="${selectedSort}" />
                            </c:url>
                            <a class="btn bm-btn-secondary" href="${exportTitlesUrl}">
                                <span class="material-symbols-outlined">download</span>
                                Xuất CSV
                            </a>
                            <c:if test="${canEdit}">
                                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createBookModal">
                                    <span class="material-symbols-outlined">add</span>
                                    Tạo đầu sách
                                </button>
                            </c:if>
                        </div>
                    </section>

                    <c:forEach var="category" items="${categories}">
                        <c:if test="${selectedCategoryId == category.categoryId}">
                            <c:set var="selectedCategoryName" value="${category.name}" />
                        </c:if>
                    </c:forEach>
                    <c:forEach var="tag" items="${tags}">
                        <c:if test="${selectedTagId == tag.tagId}">
                            <c:set var="selectedTagName" value="${tag.name}" />
                        </c:if>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${selectedStatus == 'available'}"><c:set var="selectedStatusLabel" value="Đang sử dụng" /></c:when>
                        <c:when test="${selectedStatus == 'noCopies'}"><c:set var="selectedStatusLabel" value="Chưa có bản sao" /></c:when>
                        <c:when test="${selectedStatus == 'unavailable'}"><c:set var="selectedStatusLabel" value="Ngừng sử dụng" /></c:when>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectedSort == 'title_asc'}"><c:set var="selectedSortLabel" value="Tên sách A-Z" /></c:when>
                        <c:when test="${selectedSort == 'title_desc'}"><c:set var="selectedSortLabel" value="Tên sách Z-A" /></c:when>
                        <c:when test="${selectedSort == 'available_desc'}"><c:set var="selectedSortLabel" value="Sẵn sàng nhiều nhất" /></c:when>
                        <c:when test="${selectedSort == 'available_asc'}"><c:set var="selectedSortLabel" value="Sẵn sàng ít nhất" /></c:when>
                        <c:when test="${selectedSort == 'published_desc'}"><c:set var="selectedSortLabel" value="Xuất bản mới nhất" /></c:when>
                        <c:when test="${selectedSort == 'published_asc'}"><c:set var="selectedSortLabel" value="Xuất bản cũ nhất" /></c:when>
                    </c:choose>

                    <%-- URL quay lại danh sách kèm nguyên bộ lọc, sắp xếp và trang hiện tại. --%>
                    <%-- Dùng cho link sửa, action của form và nút Hủy để thủ thư không bị văng --%>
                    <%-- về trang 1 chưa lọc sau mỗi lần chỉnh sửa một đầu sách. --%>
                    <%-- Lưu ý: sort và page luôn có giá trị nên listUrl luôn chứa dấu "?"; --%>
                    <%-- nhờ vậy chỗ nối thêm "&editId=..." bên dưới luôn hợp lệ. --%>
                    <c:url var="listUrl" value="/librarian/book-management/titles">
                        <c:param name="q" value="${q}" />
                        <c:param name="categoryId" value="${selectedCategoryId}" />
                        <c:param name="tagId" value="${selectedTagId}" />
                        <c:param name="status" value="${selectedStatus}" />
                        <c:param name="sort" value="${selectedSort}" />
                        <c:param name="page" value="${currentPage}" />
                    </c:url>

                    <form class="bm-filter-card bm-list-filter mb-3" method="get" action="${pageContext.request.contextPath}/librarian/book-management/titles">
                        <c:if test="${not empty selectedTagId}"><input type="hidden" name="tagId" value="${selectedTagId}"></c:if>
                            <div class="row g-2">
                                <div class="col-xl-4 col-lg-6 bm-search">
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
                            <div class="col-xl-2 col-md-4">
                                <select class="form-select" name="sort" aria-label="Sắp xếp đầu sách">
                                    <option value="updated_desc" ${selectedSort == 'updated_desc' ? 'selected' : ''}>Mới cập nhật</option>
                                    <option value="title_asc" ${selectedSort == 'title_asc' ? 'selected' : ''}>Tên sách A-Z</option>
                                    <option value="title_desc" ${selectedSort == 'title_desc' ? 'selected' : ''}>Tên sách Z-A</option>
                                    <option value="available_desc" ${selectedSort == 'available_desc' ? 'selected' : ''}>Sẵn sàng nhiều nhất</option>
                                    <option value="available_asc" ${selectedSort == 'available_asc' ? 'selected' : ''}>Sẵn sàng ít nhất</option>
                                    <option value="published_desc" ${selectedSort == 'published_desc' ? 'selected' : ''}>Xuất bản mới nhất</option>
                                    <option value="published_asc" ${selectedSort == 'published_asc' ? 'selected' : ''}>Xuất bản cũ nhất</option>
                                </select>
                            </div>
                            <div class="col-xl-2 col-lg-6">
                                <div class="bm-filter-actions bm-filter-actions--compact">
                                    <button class="btn bm-filter-button ${not empty q or not empty selectedCategoryId or not empty selectedTagId or not empty selectedStatus or selectedSort != 'updated_desc' ? 'bm-filter-button--active' : ''}" type="submit">
                                        <span class="material-symbols-outlined">filter_alt</span>
                                        Lọc
                                        <c:if test="${not empty q or not empty selectedCategoryId or not empty selectedTagId or not empty selectedStatus or selectedSort != 'updated_desc'}">
                                            <span class="bm-filter-badge">Đang áp dụng</span>
                                        </c:if>
                                    </button>
                                    <a class="btn bm-reset-button" href="${pageContext.request.contextPath}/librarian/book-management/titles"
                                       title="Đặt lại bộ lọc" aria-label="Đặt lại bộ lọc">
                                        <span class="material-symbols-outlined">refresh</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>

                    <c:if test="${not empty q or not empty selectedCategoryId or not empty selectedTagId or not empty selectedStatus or selectedSort != 'updated_desc'}">
                        <div class="bm-active-filters mb-3" aria-label="Bộ lọc đang áp dụng">
                            <span class="bm-active-filters__label">Đang lọc:</span>
                            <c:if test="${not empty q}">
                                <span class="bm-active-filter-chip">Từ khóa: <strong><c:out value="${q}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedCategoryId}">
                                <span class="bm-active-filter-chip">Thể loại: <strong><c:out value="${selectedCategoryName}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedTagId}">
                                <span class="bm-active-filter-chip">Nhãn: <strong><c:out value="${selectedTagName}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedStatus}">
                                <span class="bm-active-filter-chip">Trạng thái: <strong><c:out value="${selectedStatusLabel}" /></strong></span>
                            </c:if>
                            <c:if test="${selectedSort != 'updated_desc'}">
                                <span class="bm-active-filter-chip">Sắp xếp: <strong><c:out value="${selectedSortLabel}" /></strong></span>
                            </c:if>
                            <a class="bm-active-filters__clear" href="${pageContext.request.contextPath}/librarian/book-management/titles">Xóa bộ lọc</a>
                        </div>
                    </c:if>

                    <div class="bm-list-stats bm-list-stats--four mb-3">
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">menu_book</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Tổng đầu sách</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.totalBooks}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">inventory_2</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Tổng bản sao</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.totalCopies}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--success">
                            <span class="material-symbols-outlined">check_circle</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Sẵn sàng</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.availableCopies}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--warning">
                            <span class="material-symbols-outlined">library_add</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Chưa có bản sao</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.booksWithoutCopies}" /></p>
                            </div>
                        </article>
                    </div>

                    <section class="bm-table-card bm-table-card--primary bm-title-table">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <colgroup>
                                    <col class="bm-title-col-book">
                                    <col class="bm-title-col-isbn">
                                    <col class="bm-title-col-tags">
                                    <col class="bm-title-col-publisher">
                                    <col class="bm-title-col-number">
                                    <col class="bm-title-col-number">
                                    <col class="bm-title-col-status">
                                    <col class="bm-title-col-action">
                                </colgroup>
                                <thead><tr><th>Đầu sách</th><th>ISBN</th><th>Thể loại &amp; nhãn</th><th>Xuất bản</th><th class="bm-number-cell">Tổng bản sao</th><th class="bm-number-cell">Sẵn sàng</th><th>Trạng thái</th><th class="bm-action-column"><span class="visually-hidden">Thao tác</span></th></tr></thead>
                                <tbody>
                                    <c:forEach var="book" items="${books}">
                                        <tr class="bm-title-row" data-book-drawer-trigger data-book-id="${book.bookId}" tabindex="0">
                                            <td>
                                                <div class="bm-book">
                                                    <c:choose>
                                                        <c:when test="${not empty book.imagePath}">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(book.imagePath, 'http://') or fn:startsWith(book.imagePath, 'https://')}">
                                                                    <img class="bm-book__cover" src="${book.imagePath}" alt="Ảnh bìa đầu sách" loading="lazy">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img class="bm-book__cover" src="${pageContext.request.contextPath}/book-images/${book.imagePath}" alt="Ảnh bìa đầu sách" loading="lazy">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="bm-book__cover material-symbols-outlined">menu_book</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <span class="bm-book__title bm-book__title--trigger mb-1"
                                                              role="button" tabindex="0" data-book-drawer-trigger data-book-id="${book.bookId}">
                                                            <c:out value="${book.title}" />
                                                        </span>
                                                        <p class="bm-book__meta mb-0"><c:out value="${empty book.author ? 'Chưa cập nhật tác giả' : book.author}" /></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="bm-isbn-cell"><c:out value="${book.isbn}" /></td>
                                            <td>
                                                <c:set var="labelCount" value="${fn:length(book.categories) + fn:length(book.tags)}" />
                                                <c:set var="shownLabels" value="0" />
                                                <c:set var="allLabels" value="" />
                                                <c:forEach var="category" items="${book.categories}">
                                                    <c:set var="allLabels" value="${allLabels}${empty allLabels ? '' : ', '}${category.name}" />
                                                </c:forEach>
                                                <c:forEach var="tag" items="${book.tags}">
                                                    <c:set var="allLabels" value="${allLabels}${empty allLabels ? '' : ', '}${tag.name}" />
                                                </c:forEach>
                                                <div class="bm-label-list">
                                                    <c:forEach var="category" items="${book.categories}">
                                                        <c:if test="${shownLabels < 2}">
                                                            <span class="bm-tag"><c:out value="${category.name}" /></span>
                                                            <c:set var="shownLabels" value="${shownLabels + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:forEach var="tag" items="${book.tags}">
                                                        <c:if test="${shownLabels < 2}">
                                                            <span class="bm-tag bm-tag--secondary"><c:out value="${tag.name}" /></span>
                                                            <c:set var="shownLabels" value="${shownLabels + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${labelCount > 2}">
                                                        <button class="bm-tag-overflow" type="button" data-bs-toggle="tooltip"
                                                                data-bs-placement="top" title="<c:out value="${allLabels}" />"
                                                                aria-label="Xem đầy đủ thể loại và nhãn">+${labelCount - 2}</button>
                                                    </c:if>
                                                    <c:if test="${empty book.categories and empty book.tags}"><span class="bm-empty-note">Chưa phân loại</span></c:if>
                                                    </div>
                                                </td>
                                                <td><c:out value="${empty book.publisher ? 'Chưa cập nhật' : book.publisher}" /><c:if test="${not empty book.publicationYear}">, <c:out value="${book.publicationYear}" /></c:if></td>
                                            <td class="bm-number-cell"><strong><fmt:formatNumber value="${book.totalQuantity}" /></strong></td>
                                            <td class="bm-number-cell"><strong><fmt:formatNumber value="${book.availableQuantity}" /></strong></td>
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
                                                        <c:set var="editUrl" value="${listUrl}&editId=${book.bookId}" />
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

                    <jsp:include page="fragments/_book-pagination.jsp">
                        <jsp:param name="label" value="Phân trang đầu sách" />
                        <jsp:param name="inputId" value="bookTitlePageJump" />
                    </jsp:include>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
                <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
                <script src="${pageContext.request.contextPath}/assets/js/book-titles.js?v=20260726-price-format-1"></script>
            </main>
        </div>

        <jsp:include page="fragments/_book-title-drawer.jsp" />

        <c:if test="${canEdit}">
            <div class="modal fade bm-modal" id="createBookModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg"><div class="modal-content">
                        <form method="post" enctype="multipart/form-data" action="${listUrl}">
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
                        <form method="post" enctype="multipart/form-data" action="${listUrl}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="bookId" value="${editBook.bookId}">
                            <div class="modal-header"><div><h5 class="modal-title">Chỉnh sửa đầu sách</h5><p class="bm-section-note mb-0">ISBN và số lượng tồn kho không thể sửa trực tiếp.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
                            <div class="modal-body"><jsp:include page="fragments/_book-form-fields.jsp"><jsp:param name="editing" value="true" /></jsp:include></div>
                            <div class="modal-footer"><a class="btn bm-btn-secondary" href="${listUrl}">Hủy</a><button type="submit" class="btn btn-primary-custom">Lưu thay đổi</button></div>
                        </form>
                    </div></div>
            </div>
        </c:if>
    </body>
</html>
