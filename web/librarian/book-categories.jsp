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
                <div class="alert alert-success alert-dismissible fade show"><c:out value="${sessionScope.successMessage}" /><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button></div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show"><c:out value="${sessionScope.errorMessage}" /><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button></div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                <div>
                    <p class="bm-page__eyebrow mb-1">Danh mục sách</p>
                    <h2 class="bm-page__title mb-1">Thể loại</h2>
                    <p class="bm-page__subtitle mb-0">Quản lý nhóm phân loại chính dùng cho đầu sách.</p>
                </div>
                <c:if test="${canEdit}"><button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createCategoryModal"><span class="material-symbols-outlined">add</span>Tạo thể loại</button></c:if>
            </section>

            <form class="bm-filter-card bm-list-filter mb-3 bm-auto-filter" method="get" action="${pageContext.request.contextPath}/book-management/categories">
                <div class="row g-2">
                    <div class="col-lg-8 bm-search"><span class="material-symbols-outlined">search</span><input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Tìm kiếm thể loại..."></div>
                    <div class="col-lg-3"><select class="form-select" name="status"><option value="">Mọi trạng thái</option><option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Đang dùng</option><option value="hidden" ${selectedStatus == 'hidden' ? 'selected' : ''}>Đã ẩn</option></select></div>
                    <div class="col-lg-1"><a class="btn bm-reset-button w-100" href="${pageContext.request.contextPath}/book-management/categories" title="Đặt lại bộ lọc"><span class="material-symbols-outlined">refresh</span></a></div>
                </div>
            </form>

            <section class="bm-table-card bm-table-card--primary bm-data-table"><div class="table-responsive"><table class="table table-lms">
                <thead><tr><th>Tên thể loại</th><th>Mô tả</th><th>Số đầu sách</th><th>Trạng thái</th><th>Cập nhật gần nhất</th><th class="bm-action-column"><span class="visually-hidden">Thao tác</span></th></tr></thead>
                <tbody>
                    <c:forEach var="category" items="${categories}"><tr>
                        <td><strong><c:out value="${category.name}" /></strong></td>
                        <td><c:out value="${empty category.description ? 'Chưa có mô tả' : category.description}" /></td>
                        <td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?categoryId=${category.categoryId}">Xem <fmt:formatNumber value="${category.bookCount}" /> đầu sách</a></td>
                        <td><span class="bm-badge ${category.status == 'active' ? 'bm-badge--success' : 'bm-badge--neutral'}">${category.status == 'active' ? 'Đang dùng' : 'Đã ẩn'}</span></td>
                        <td><fmt:formatDate value="${category.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td class="bm-action-column"><c:choose><c:when test="${canEdit}"><a class="bm-action-icon" href="${pageContext.request.contextPath}/book-management/categories?editId=${category.categoryId}" title="Chỉnh sửa thể loại" aria-label="Chỉnh sửa thể loại"><span class="material-symbols-outlined" aria-hidden="true">edit</span></a></c:when><c:otherwise><span class="bm-badge bm-badge--neutral">Chỉ xem</span></c:otherwise></c:choose></td>
                    </tr></c:forEach>
                    <c:if test="${empty categories}"><tr><td colspan="6"><div class="bm-empty-state"><span class="material-symbols-outlined">category</span><strong>Không tìm thấy thể loại</strong><span>Hãy thử thay đổi từ khóa hoặc trạng thái.</span></div></td></tr></c:if>
                </tbody>
            </table></div></section>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/book-categories.js?v=20260610-1"></script>
    </main>
</div>

<c:if test="${canEdit}">
    <div class="modal fade bm-modal" id="createCategoryModal" tabindex="-1" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><form method="post" action="${pageContext.request.contextPath}/book-management/categories">
        <input type="hidden" name="action" value="create"><input type="hidden" name="status" value="active">
        <div class="modal-header"><div><h5 class="modal-title">Tạo thể loại</h5><p class="bm-section-note mb-0">Thể loại mới sẽ sẵn sàng để gán cho đầu sách.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
        <div class="modal-body"><div class="mb-3"><label class="form-label">Tên thể loại <span class="bm-required">*</span></label><input class="form-control" name="name" required maxlength="255"></div><div><label class="form-label">Mô tả</label><textarea class="form-control" name="description" rows="4"></textarea></div></div>
        <div class="modal-footer"><button type="button" class="btn bm-btn-secondary" data-bs-dismiss="modal">Hủy</button><button class="btn btn-primary-custom" type="submit">Lưu thể loại</button></div>
    </form></div></div></div>
</c:if>

<c:if test="${canEdit and not empty editCategory}">
    <div class="modal fade bm-modal" id="editCategoryModal" tabindex="-1" aria-hidden="true" data-auto-open="true"><div class="modal-dialog"><div class="modal-content"><form method="post" action="${pageContext.request.contextPath}/book-management/categories">
        <input type="hidden" name="action" value="update"><input type="hidden" name="categoryId" value="${editCategory.categoryId}">
        <div class="modal-header"><div><h5 class="modal-title">Chỉnh sửa thể loại</h5><p class="bm-section-note mb-0">Ẩn thể loại để ngừng gán mới mà vẫn giữ lịch sử.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
        <div class="modal-body"><div class="mb-3"><label class="form-label">Tên thể loại</label><input class="form-control" name="name" required maxlength="255" value="<c:out value="${editCategory.name}" />"></div><div class="mb-3"><label class="form-label">Mô tả</label><textarea class="form-control" name="description" rows="4"><c:out value="${editCategory.description}" /></textarea></div><div><label class="form-label">Trạng thái</label><select class="form-select" name="status"><option value="active" ${editCategory.status == 'active' ? 'selected' : ''}>Đang dùng</option><option value="hidden" ${editCategory.status == 'hidden' ? 'selected' : ''}>Đã ẩn</option></select></div></div>
        <div class="modal-footer"><a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/categories">Hủy</a><button class="btn btn-primary-custom" type="submit">Lưu thay đổi</button></div>
    </form></div></div></div>
</c:if>
</body>
</html>
