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
                <div><p class="bm-page__eyebrow mb-1">Kho vật lý</p><h2 class="bm-page__title mb-1">Tất cả bản sao</h2><p class="bm-page__subtitle mb-0">Theo dõi từng cuốn sách vật lý theo mã vạch, vị trí và trạng thái lưu thông.</p></div>
                <c:if test="${canEdit}"><button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createCopyModal"><span class="material-symbols-outlined">add</span>Thêm bản sao</button></c:if>
            </section>

            <form class="bm-filter-card bm-list-filter mb-3" method="get" action="${pageContext.request.contextPath}/book-management/copies">
                <div class="row g-2">
                    <div class="col-xl-4 col-lg-6 bm-search"><span class="material-symbols-outlined">barcode_scanner</span><input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Quét mã vạch hoặc tìm tên sách"></div>
                    <div class="col-xl-3 col-md-4"><select class="form-select" name="location"><option value="">Tất cả vị trí</option><c:forEach var="item" items="${locations}"><option value="<c:out value="${item}" />" ${selectedLocation == item ? 'selected' : ''}><c:out value="${item}" /></option></c:forEach></select></div>
                    <div class="col-xl-3 col-md-4"><select class="form-select" name="status"><option value="">Mọi trạng thái</option><option value="available" ${selectedStatus == 'available' ? 'selected' : ''}>Sẵn sàng</option><option value="borrowed" ${selectedStatus == 'borrowed' ? 'selected' : ''}>Đang mượn</option><option value="reserved" ${selectedStatus == 'reserved' ? 'selected' : ''}>Đặt trước</option><option value="incident" ${selectedStatus == 'incident' ? 'selected' : ''}>Hỏng hoặc mất</option><option value="unavailable" ${selectedStatus == 'unavailable' ? 'selected' : ''}>Ngừng lưu thông</option></select></div>
                    <div class="col-xl-2 col-lg-6"><div class="bm-filter-actions bm-filter-actions--compact"><button class="btn bm-filter-button" type="submit"><span class="material-symbols-outlined">filter_alt</span><span>Lọc</span></button><a class="btn bm-reset-button" href="${pageContext.request.contextPath}/book-management/copies" title="Đặt lại bộ lọc" aria-label="Đặt lại bộ lọc"><span class="material-symbols-outlined">refresh</span></a></div></div>
                </div>
            </form>

            <div class="bm-rule-note bm-rule-note--compact mb-3"><strong>Quy tắc:</strong> Không thể sửa bản sao đang được mượn, đã đặt trước hoặc đang chờ xử lý sự cố. Mã vạch không thể thay đổi sau khi tạo.</div>
            <div class="bm-list-stats bm-list-stats--four mb-3">
                <article class="bm-list-stat"><span class="material-symbols-outlined">inventory_2</span><div><p class="bm-stat-card__label mb-1">Tổng bản sao</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.totalCopies}" /></p></div></article>
                <article class="bm-list-stat bm-list-stat--success"><span class="material-symbols-outlined">check_circle</span><div><p class="bm-stat-card__label mb-1">Sẵn sàng</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.availableCopies}" /></p></div></article>
                <article class="bm-list-stat bm-list-stat--info"><span class="material-symbols-outlined">menu_book</span><div><p class="bm-stat-card__label mb-1">Đang mượn</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.borrowedCopies}" /></p></div></article>
                <article class="bm-list-stat bm-list-stat--danger"><span class="material-symbols-outlined">report</span><div><p class="bm-stat-card__label mb-1">Hỏng/mất</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.incidentCopies}" /></p></div></article>
            </div>

            <section class="bm-table-card bm-table-card--primary bm-data-table"><div class="table-responsive"><table class="table table-lms">
                <thead><tr><th>Mã vạch</th><th>Đầu sách</th><th>Vị trí</th><th>Tình trạng</th><th>Lưu thông</th><th>Cập nhật</th><th class="bm-copy-action-column">Thao tác</th></tr></thead>
                <tbody>
                    <c:forEach var="copy" items="${copies}"><tr>
                        <td><strong><c:out value="${copy.barcode}" /></strong></td>
                        <td><strong><c:out value="${copy.bookTitle}" /></strong><div class="bm-book__meta"><c:out value="${copy.isbn}" /></div></td>
                        <td><c:out value="${copy.location}" /></td>
                        <td><c:choose><c:when test="${copy.condition == 'good'}"><span class="bm-badge bm-badge--success">Tốt</span></c:when><c:when test="${copy.condition == 'damaged'}"><span class="bm-badge bm-badge--danger">Hỏng</span></c:when><c:otherwise><span class="bm-badge bm-badge--danger">Mất</span></c:otherwise></c:choose></td>
                        <td><c:choose><c:when test="${copy.status == 'available'}"><span class="bm-badge bm-badge--success">Sẵn sàng</span></c:when><c:when test="${copy.status == 'borrowed'}"><span class="bm-badge bm-badge--info">Đang mượn</span></c:when><c:when test="${copy.status == 'reserved'}"><span class="bm-badge bm-badge--warning">Đặt trước</span></c:when><c:otherwise><span class="bm-badge bm-badge--neutral">Ngừng lưu thông</span></c:otherwise></c:choose></td>
                        <td><fmt:formatDate value="${empty copy.updatedAt ? copy.createdAt : copy.updatedAt}" pattern="dd/MM/yyyy" /></td>
                        <td class="bm-copy-action-column"><c:choose>
                            <c:when test="${canEdit and copy.condition != 'good'}">
                                <a class="bm-action-icon bm-action-icon--danger" href="${pageContext.request.contextPath}/book-management/incidents?q=${copy.barcode}" title="Xem sự cố" aria-label="Xem sự cố"><span class="material-symbols-outlined" aria-hidden="true">visibility</span></a>
                            </c:when>
                            <c:when test="${canEdit and copy.status == 'available' and copy.condition == 'good'}">
                                <div class="bm-copy-actions">
                                    <a class="bm-action-icon" href="${pageContext.request.contextPath}/book-management/copies?editId=${copy.bookCopyId}" title="Cập nhật vị trí" aria-label="Cập nhật vị trí"><span class="material-symbols-outlined" aria-hidden="true">edit</span></a>
                                    <a class="bm-action-icon bm-action-icon--danger" href="${pageContext.request.contextPath}/book-management/incidents?bookCopyId=${copy.bookCopyId}" title="Ghi nhận sự cố" aria-label="Ghi nhận sự cố"><span class="material-symbols-outlined" aria-hidden="true">report</span></a>
                                </div>
                            </c:when>
                            <c:when test="${canEdit and copy.status == 'unavailable'}">
                                <a class="bm-action-icon bm-action-icon--danger" href="${pageContext.request.contextPath}/book-management/incidents?q=${copy.barcode}" title="Xem sự cố" aria-label="Xem sự cố"><span class="material-symbols-outlined" aria-hidden="true">visibility</span></a>
                            </c:when>
                            <c:otherwise><span class="bm-badge bm-badge--neutral">Chỉ xem</span></c:otherwise>
                        </c:choose></td>
                    </tr></c:forEach>
                    <c:if test="${empty copies}"><tr><td colspan="7"><div class="bm-empty-state"><span class="material-symbols-outlined">inventory_2</span><strong>Không tìm thấy bản sao</strong><span>Hãy thử thay đổi bộ lọc hoặc thêm bản sao mới.</span></div></td></tr></c:if>
                </tbody>
            </table></div></section>

            <c:if test="${totalPages > 1}"><nav class="d-flex justify-content-between align-items-center mt-3"><span class="bm-section-note">Trang ${currentPage}/${totalPages} · ${totalItems} kết quả</span><div class="bm-actions"><c:url var="previousUrl" value="/book-management/copies"><c:param name="q" value="${q}" /><c:param name="location" value="${selectedLocation}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage - 1}" /></c:url><c:url var="nextUrl" value="/book-management/copies"><c:param name="q" value="${q}" /><c:param name="location" value="${selectedLocation}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage + 1}" /></c:url><a class="btn bm-btn-secondary ${currentPage == 1 ? 'disabled' : ''}" href="${previousUrl}">Trang trước</a><a class="btn bm-btn-secondary ${currentPage == totalPages ? 'disabled' : ''}" href="${nextUrl}">Trang sau</a></div></nav></c:if>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260618-1"></script>
    </main>
</div>

<c:if test="${canEdit}">
    <div class="modal fade bm-modal" id="createCopyModal" tabindex="-1" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><form method="post" action="${pageContext.request.contextPath}/book-management/copies"><input type="hidden" name="action" value="create"><div class="modal-header"><div><h5 class="modal-title">Thêm bản sao vật lý</h5><p class="bm-section-note mb-0">Bản sao mới được khởi tạo ở trạng thái tốt và sẵn sàng.</p></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button></div><div class="modal-body"><div class="mb-3"><label class="form-label">Đầu sách <span class="bm-required">*</span></label><select class="form-select" name="bookId" required><option value="">Chọn đầu sách</option><c:forEach var="book" items="${books}"><option value="${book.bookId}"><c:out value="${book.title}" /> · <c:out value="${book.isbn}" /></option></c:forEach></select></div><div class="mb-3"><label class="form-label">Mã vạch <span class="bm-required">*</span></label><input class="form-control" name="barcode" required maxlength="50" placeholder="Ví dụ: BC-00018293"></div><div><label class="form-label">Vị trí <span class="bm-required">*</span></label><input class="form-control" name="location" required maxlength="255" list="locationOptions" placeholder="Ví dụ: Kho A · Kệ A12"></div></div><div class="modal-footer"><button class="btn bm-btn-secondary" type="button" data-bs-dismiss="modal">Hủy</button><button class="btn btn-primary-custom" type="submit">Lưu bản sao</button></div></form></div></div></div>
</c:if>

<datalist id="locationOptions"><c:forEach var="item" items="${locations}"><option value="<c:out value="${item}" />"></c:forEach></datalist>

<c:if test="${canEdit and not empty editCopy}">
    <div class="modal fade bm-modal" id="editCopyModal" tabindex="-1" aria-hidden="true" data-auto-open="true"><div class="modal-dialog"><div class="modal-content"><form method="post" action="${pageContext.request.contextPath}/book-management/copies"><input type="hidden" name="action" value="update"><input type="hidden" name="bookCopyId" value="${editCopy.bookCopyId}"><div class="modal-header"><div><h5 class="modal-title">Cập nhật vị trí bản sao</h5><p class="bm-section-note mb-0">Mã vạch <strong><c:out value="${editCopy.barcode}" /></strong> không thể thay đổi.</p></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button></div><div class="modal-body"><label class="form-label">Vị trí</label><input class="form-control" name="location" required maxlength="255" list="locationOptions" value="<c:out value="${editCopy.location}" />"><p class="bm-section-note mt-2 mb-0">Tình trạng Hỏng/Mất phải được ghi nhận và xác minh tại màn Hỏng &amp; mất.</p></div><div class="modal-footer"><a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/copies">Hủy</a><button class="btn btn-primary-custom" type="submit">Lưu thay đổi</button></div></form></div></div></div>
</c:if>
</body>
</html>
