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
                <div><p class="bm-page__eyebrow mb-1">Kho vật lý</p><h2 class="bm-page__title mb-1">Hỏng &amp; mất</h2><p class="bm-page__subtitle mb-0">Xác minh và xử lý các bản sao không còn đủ điều kiện lưu thông.</p></div>
                <c:if test="${canEdit}"><button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#reportModal"><span class="material-symbols-outlined">add</span>Ghi nhận sự cố</button></c:if>
            </section>

            <div class="row g-3 mb-3">
                <div class="col-md-4"><article class="raised-card p-3"><p class="bm-stat-card__label mb-1">Chờ xác minh</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.pendingCount}" /></p></article></div>
                <div class="col-md-4"><article class="raised-card p-3"><p class="bm-stat-card__label mb-1">Đang xử lý</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.investigatingCount}" /></p></article></div>
                <div class="col-md-4"><article class="raised-card p-3"><p class="bm-stat-card__label mb-1">Đã xử lý tháng này</p><p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.resolvedThisMonthCount}" /></p></article></div>
            </div>

            <form class="bm-filter-card mb-3" method="get" action="${pageContext.request.contextPath}/book-management/incidents">
                <div class="row g-2">
                    <div class="col-xl-5 col-lg-6 bm-search"><span class="material-symbols-outlined">search</span><input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Tìm mã vạch hoặc đầu sách"></div>
                    <div class="col-xl-3 col-md-4"><select class="form-select" name="type"><option value="">Tất cả loại sự cố</option><option value="damaged" ${selectedType == 'damaged' ? 'selected' : ''}>Hỏng</option><option value="lost" ${selectedType == 'lost' ? 'selected' : ''}>Mất</option></select></div>
                    <div class="col-xl-2 col-md-4"><select class="form-select" name="status"><option value="">Mọi trạng thái</option><option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>Chờ xác minh</option><option value="investigating" ${selectedStatus == 'investigating' ? 'selected' : ''}>Đang xử lý</option><option value="resolved" ${selectedStatus == 'resolved' ? 'selected' : ''}>Đã xử lý</option><option value="rejected" ${selectedStatus == 'rejected' ? 'selected' : ''}>Báo sai</option></select></div>
                    <div class="col-xl-2 col-lg-6"><div class="bm-filter-actions"><button class="btn bm-filter-button flex-grow-1" type="submit"><span class="material-symbols-outlined">filter_alt</span><span>Lọc</span></button><a class="btn bm-reset-button" href="${pageContext.request.contextPath}/book-management/incidents" title="Đặt lại bộ lọc"><span class="material-symbols-outlined">refresh</span></a></div></div>
                </div>
            </form>

            <div class="bm-rule-note mb-3"><strong>Quy tắc:</strong> Ghi nhận sự cố sẽ tạm ngừng lưu thông bản sao. Tình trạng Hỏng/Mất chỉ được cập nhật sau khi có kết luận.</div>

            <section class="bm-table-card"><div class="table-responsive"><table class="table table-lms">
                <thead><tr><th>Bản sao</th><th>Sự cố</th><th>Ghi nhận</th><th>Người báo</th><th>Trạng thái</th><th>Hướng xử lý</th><th></th></tr></thead>
                <tbody>
                    <c:forEach var="incident" items="${incidents}"><tr>
                        <td><strong><c:out value="${incident.barcode}" /></strong><div class="bm-book__meta"><c:out value="${incident.bookTitle}" /></div></td>
                        <td><span class="bm-badge bm-badge--danger">${incident.incidentType == 'damaged' ? 'Hỏng' : 'Mất'}</span><div class="bm-book__meta"><c:out value="${incident.description}" /></div></td>
                        <td><fmt:formatDate value="${incident.reportedAt}" pattern="dd/MM/yyyy" /></td>
                        <td><c:out value="${incident.reportedByName}" /></td>
                        <td><c:choose><c:when test="${incident.status == 'pending'}"><span class="bm-badge bm-badge--warning">Chờ xác minh</span></c:when><c:when test="${incident.status == 'investigating'}"><span class="bm-badge bm-badge--info">Đang xử lý</span></c:when><c:when test="${incident.status == 'resolved'}"><span class="bm-badge bm-badge--success">Đã xử lý</span></c:when><c:otherwise><span class="bm-badge bm-badge--neutral">Báo sai</span></c:otherwise></c:choose></td>
                        <td><c:choose><c:when test="${empty incident.resolution}">Chưa có kết luận</c:when><c:otherwise><c:out value="${incident.resolution}" /></c:otherwise></c:choose></td>
                        <td><div class="bm-actions">
                            <c:if test="${canEdit and incident.status == 'pending'}"><form method="post" action="${pageContext.request.contextPath}/book-management/incidents"><input type="hidden" name="action" value="investigate"><input type="hidden" name="incidentId" value="${incident.incidentId}"><button class="btn btn-sm btn-primary-custom" type="submit">Bắt đầu xác minh</button></form></c:if>
                            <a class="btn btn-sm bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/incidents?incidentId=${incident.incidentId}">${canEdit and (incident.status == 'pending' or incident.status == 'investigating') ? 'Kết luận' : 'Chi tiết'}</a>
                        </div></td>
                    </tr></c:forEach>
                    <c:if test="${empty incidents}"><tr><td colspan="7"><div class="bm-empty-state"><span class="material-symbols-outlined">verified</span><strong>Không có sự cố nào</strong><span>Tất cả bản sao đang ổn định hoặc bộ lọc không khớp kết quả.</span></div></td></tr></c:if>
                </tbody>
            </table></div></section>

            <c:if test="${totalPages > 1}"><nav class="d-flex justify-content-between align-items-center mt-3"><span class="bm-section-note">Trang ${currentPage}/${totalPages} · ${totalItems} kết quả</span><div class="bm-actions"><c:url var="previousUrl" value="/book-management/incidents"><c:param name="q" value="${q}" /><c:param name="type" value="${selectedType}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage - 1}" /></c:url><c:url var="nextUrl" value="/book-management/incidents"><c:param name="q" value="${q}" /><c:param name="type" value="${selectedType}" /><c:param name="status" value="${selectedStatus}" /><c:param name="page" value="${currentPage + 1}" /></c:url><a class="btn bm-btn-secondary ${currentPage == 1 ? 'disabled' : ''}" href="${previousUrl}">Trang trước</a><a class="btn bm-btn-secondary ${currentPage == totalPages ? 'disabled' : ''}" href="${nextUrl}">Trang sau</a></div></nav></c:if>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
        <script src="${pageContext.request.contextPath}/assets/js/book-copies.js?v=20260610-2"></script>
    </main>
</div>

<jsp:include page="fragments/_book-incident-report-modal.jsp" />
<jsp:include page="fragments/_book-incident-detail-modal.jsp" />
</body>
</html>
