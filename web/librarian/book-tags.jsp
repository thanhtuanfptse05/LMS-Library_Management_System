<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Trang: book-tags.jsp - Quản lý Nhãn Sách (Tags) --%>
<%-- Cho phép Thủ thư tạo nhãn, ẩn nhãn, chỉnh sửa nhãn, --%>
<%-- và thực hiện thao tác gộp (merge) hai nhãn trùng lặp hoặc tương đương --%>

<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
<jsp:include page="fragments/_sidebar.jsp" />
<div class="d-flex main-wrapper overflow-hidden">
    <main class="flex-grow-1 overflow-y-auto main-content-layout">
        <jsp:include page="fragments/_header.jsp" />
        <div class="container-fluid px-4 py-4 bm-page">
            <%-- Thông báo kết quả thao tác --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show">
                    <c:out value="${sessionScope.successMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <c:out value="${sessionScope.errorMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <%-- Tiêu đề và Các nút thao tác chính (Gộp nhãn, Tạo nhãn mới) --%>
            <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                <div>
                    <p class="bm-page__eyebrow mb-1">Danh mục sách</p>
                    <h2 class="bm-page__title mb-1">Nhãn sách</h2>
                    <p class="bm-page__subtitle mb-0">Quản lý nhãn mô tả linh hoạt dùng để tìm kiếm đầu sách.</p>
                </div>
                <c:if test="${canEdit}">
                    <div class="bm-actions">
                        <button class="btn bm-btn-secondary" data-bs-toggle="modal" data-bs-target="#mergeTagModal">Gộp nhãn</button>
                        <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createTagModal">
                            <span class="material-symbols-outlined">add</span>Tạo nhãn sách
                        </button>
                    </div>
                </c:if>
            </section>

            <%-- Biểu mẫu tìm kiếm và lọc trạng thái nhãn sách --%>
            <form class="bm-filter-card bm-list-filter mb-3 bm-auto-filter" method="get" action="${pageContext.request.contextPath}/book-management/tags">
                <div class="row g-2">
                    <div class="col-lg-8 bm-search">
                        <span class="material-symbols-outlined">search</span>
                        <input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Tìm kiếm nhãn sách...">
                    </div>
                    <div class="col-lg-3">
                        <select class="form-select" name="status">
                            <option value="">Mọi trạng thái</option>
                            <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Đang dùng</option>
                            <option value="hidden" ${selectedStatus == 'hidden' ? 'selected' : ''}>Đã ẩn</option>
                        </select>
                    </div>
                    <div class="col-lg-1">
                        <a class="btn bm-reset-button w-100" href="${pageContext.request.contextPath}/book-management/tags" title="Đặt lại bộ lọc">
                            <span class="material-symbols-outlined">refresh</span>
                        </a>
                    </div>
                </div>
            </form>

            <c:choose>
                <c:when test="${selectedStatus == 'active'}"><c:set var="selectedStatusLabel" value="Đang dùng" /></c:when>
                <c:when test="${selectedStatus == 'hidden'}"><c:set var="selectedStatusLabel" value="Đã ẩn" /></c:when>
            </c:choose>
            <c:if test="${not empty q or not empty selectedStatus}">
                <div class="bm-active-filters mb-3" aria-label="Bộ lọc đang áp dụng">
                    <span class="bm-active-filters__label">Đang lọc:</span>
                    <c:if test="${not empty q}">
                        <span class="bm-active-filter-chip">Từ khóa: <strong><c:out value="${q}" /></strong></span>
                    </c:if>
                    <c:if test="${not empty selectedStatus}">
                        <span class="bm-active-filter-chip">Trạng thái: <strong><c:out value="${selectedStatusLabel}" /></strong></span>
                    </c:if>
                    <a class="bm-active-filters__clear" href="${pageContext.request.contextPath}/book-management/tags">Xóa bộ lọc</a>
                </div>
            </c:if>

            <%-- Khối thống kê nhanh nhãn sách --%>
            <div class="bm-list-stats bm-list-stats--four mb-3">
                <article class="bm-list-stat">
                    <span class="material-symbols-outlined">sell</span>
                    <div>
                        <p class="bm-stat-card__label mb-1">Tổng nhãn sách</p>
                        <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.totalCount}" /></p>
                    </div>
                </article>
                <article class="bm-list-stat bm-list-stat--success">
                    <span class="material-symbols-outlined">check_circle</span>
                    <div>
                        <p class="bm-stat-card__label mb-1">Đang sử dụng</p>
                        <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.activeCount}" /></p>
                    </div>
                </article>
                <article class="bm-list-stat bm-list-stat--warning">
                    <span class="material-symbols-outlined">visibility_off</span>
                    <div>
                        <p class="bm-stat-card__label mb-1">Đã ẩn</p>
                        <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.hiddenCount}" /></p>
                    </div>
                </article>
                <article class="bm-list-stat bm-list-stat--info">
                    <span class="material-symbols-outlined">library_add</span>
                    <div>
                        <p class="bm-stat-card__label mb-1">Chưa có đầu sách</p>
                        <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.unusedCount}" /></p>
                    </div>
                </article>
            </div>

            <%-- Bảng danh sách nhãn sách --%>
            <section class="bm-table-card bm-table-card--primary bm-data-table">
                <div class="table-responsive">
                    <table class="table table-lms">
                        <thead>
                            <tr>
                                <th>Tên nhãn</th>
                                <th>Số đầu sách</th>
                                <th>Trạng thái</th>
                                <th class="bm-action-column"><span class="visually-hidden">Thao tác</span></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tag" items="${tags}">
                                <tr>
                                    <td>
                                        <%-- Huy hiệu tên nhãn (hiển thị nhạt màu hơn nếu nhãn đang ở trạng thái ẩn) --%>
                                        <span class="bm-tag ${tag.status == 'hidden' ? 'bm-tag--secondary' : ''}">
                                            <c:out value="${tag.name}" />
                                        </span>
                                    </td>
                                    <td>
                                        <a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?tagId=${tag.tagId}">
                                            Xem <fmt:formatNumber value="${tag.bookCount}" /> đầu sách
                                        </a>
                                    </td>
                                    <td>
                                        <span class="bm-badge ${tag.status == 'active' ? 'bm-badge--success' : 'bm-badge--neutral'}">
                                            ${tag.status == 'active' ? 'Đang dùng' : 'Đã ẩn'}
                                        </span>
                                    </td>
                                    <td class="bm-action-column">
                                        <c:choose>
                                            <c:when test="${canEdit}">
                                                <a class="bm-action-icon" href="${pageContext.request.contextPath}/book-management/tags?editId=${tag.tagId}" title="Chỉnh sửa nhãn sách" aria-label="Chỉnh sửa nhãn sách">
                                                    <span class="material-symbols-outlined" aria-hidden="true">edit</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bm-badge bm-badge--neutral">Chỉ xem</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty tags}">
                                <tr>
                                    <td colspan="4">
                                        <div class="bm-empty-state">
                                            <span class="material-symbols-outlined">sell</span>
                                            <strong>Không tìm thấy nhãn sách</strong>
                                            <span>Hãy thử thay đổi từ khóa hoặc trạng thái.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <jsp:include page="fragments/_book-pagination.jsp">
                <jsp:param name="label" value="Phân trang nhãn sách" />
                <jsp:param name="inputId" value="bookTagPageJump" />
                <jsp:param name="pageSize" value="${pageSize}" />
            </jsp:include>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
        <script src="${pageContext.request.contextPath}/assets/js/book-tags.js?v=20260610-1"></script>
    </main>
</div>

<%-- Modal 1: Tạo mới nhãn sách --%>
<c:if test="${canEdit}">
    <div class="modal fade bm-modal" id="createTagModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/book-management/tags">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="status" value="active">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title">Tạo nhãn sách</h5>
                            <p class="bm-section-note mb-0">Tên nhãn nên ngắn gọn và dễ tìm kiếm.</p>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <label class="form-label">Tên nhãn sách <span class="bm-required">*</span></label>
                        <input class="form-control" name="name" required maxlength="100">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn bm-btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button class="btn btn-primary-custom" type="submit">Lưu nhãn sách</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%-- Modal 2: Gộp hai nhãn sách (chuyển toàn bộ sách đang gán nhãn nguồn sang nhãn đích, sau đó ẩn nhãn nguồn) --%>
    <div class="modal fade bm-modal" id="mergeTagModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/book-management/tags">
                    <input type="hidden" name="action" value="merge">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title">Gộp nhãn sách</h5>
                            <p class="bm-section-note mb-0">Nhãn nguồn sẽ được ẩn sau khi chuyển toàn bộ liên kết.</p>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label">Nhãn nguồn</label>
                            <select class="form-select" name="sourceTagId" required>
                                <option value="">Chọn nhãn cần gộp</option>
                                <c:forEach var="item" items="${allTags}">
                                    <option value="${item.tagId}">
                                        <c:out value="${item.name}" />${item.status == 'hidden' ? ' (Đã ẩn)' : ''}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Nhãn đích đang dùng</label>
                            <select class="form-select" name="targetTagId" required>
                                <option value="">Chọn nhãn nhận dữ liệu</option>
                                <c:forEach var="item" items="${allTags}">
                                    <c:if test="${item.status == 'active'}">
                                        <option value="${item.tagId}"><c:out value="${item.name}" /></option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn bm-btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button class="btn btn-primary-custom" type="submit">Xác nhận gộp</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>

<%-- Modal 3: Chỉnh sửa tên / trạng thái ẩn hiện của nhãn sách --%>
<c:if test="${canEdit and not empty editTag}">
    <div class="modal fade bm-modal" id="editTagModal" tabindex="-1" aria-hidden="true" data-auto-open="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/book-management/tags">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="tagId" value="${editTag.tagId}">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title">Chỉnh sửa nhãn sách</h5>
                            <p class="bm-section-note mb-0">Nhãn đã ẩn không còn được gợi ý khi gán cho đầu sách mới.</p>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tên nhãn sách</label>
                            <input class="form-control" name="name" required maxlength="100" value="<c:out value="${editTag.name}" />">
                        </div>
                        <div>
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="active" ${editTag.status == 'active' ? 'selected' : ''}>Đang dùng</option>
                                <option value="hidden" ${editTag.status == 'hidden' ? 'selected' : ''}>Đã ẩn</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/tags">Hủy</a>
                        <button class="btn btn-primary-custom" type="submit">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>
</body>
</html>
