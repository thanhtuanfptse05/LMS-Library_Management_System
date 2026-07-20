<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Trang: book-import-history.jsp - Lịch sử các đợt nhập sách Excel --%>
<%-- Cho phép Thủ thư xem danh sách các đợt kiểm tra/nhập sách trước đây, --%>
<%-- trạng thái kết quả (Thành công/Thất bại) và chi tiết các dòng lỗi nếu có --%>

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

                    <%-- Tiêu đề và nút dẫn đến trang Nhập sách mới --%>
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Nhập dữ liệu &amp; lịch sử</p>
                            <h2 class="bm-page__title mb-1">Lịch sử xử lý</h2>
                            <p class="bm-page__subtitle mb-0">Theo dõi kết quả, người thực hiện và lỗi của từng phiên nhập sách trong một năm.</p>
                        </div>
                        <c:if test="${sessionScope.role == 'LIBRARIAN' or sessionScope.role == 'librarian'}">
                            <a class="btn btn-primary-custom" href="${pageContext.request.contextPath}/librarian/book-management/import">
                                <span class="material-symbols-outlined">upload_file</span>Nhập mới
                            </a>
                        </c:if>
                    </section>

                    <%-- Bộ lọc tìm kiếm các phiên nhập sách trước đây --%>
                    <form class="bm-filter-card bm-list-filter mb-3" method="get" action="${pageContext.request.contextPath}/librarian/book-management/import-history">
                        <div class="row g-2">
                            <div class="col-lg-7 bm-search">
                                <span class="material-symbols-outlined">search</span>
                                <input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Tìm mã phiên hoặc tên tệp">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="status">
                                    <option value="">Mọi kết quả</option>
                                    <option value="success" ${selectedStatus == 'success' ? 'selected' : ''}>Thành công</option>
                                    <option value="failed" ${selectedStatus == 'failed' ? 'selected' : ''}>Thất bại</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <div class="bm-filter-actions bm-filter-actions--compact">
                                    <button class="btn bm-filter-button ${not empty q or not empty selectedStatus ? 'bm-filter-button--active' : ''}" type="submit">
                                        <span class="material-symbols-outlined">filter_alt</span><span>Lọc</span>
                                        <c:if test="${not empty q or not empty selectedStatus}">
                                            <span class="bm-filter-badge">Đang áp dụng</span>
                                        </c:if>
                                    </button>
                                    <a class="btn bm-reset-button" href="${pageContext.request.contextPath}/librarian/book-management/import-history">
                                        <span class="material-symbols-outlined">refresh</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>

                    <c:choose>
                        <c:when test="${selectedStatus == 'success'}"><c:set var="selectedStatusLabel" value="Thành công" /></c:when>
                        <c:when test="${selectedStatus == 'failed'}"><c:set var="selectedStatusLabel" value="Thất bại" /></c:when>
                    </c:choose>
                    <c:if test="${not empty q or not empty selectedStatus}">
                        <div class="bm-active-filters mb-3" aria-label="Bộ lọc đang áp dụng">
                            <span class="bm-active-filters__label">Đang lọc:</span>
                            <c:if test="${not empty q}">
                                <span class="bm-active-filter-chip">Từ khóa: <strong><c:out value="${q}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedStatus}">
                                <span class="bm-active-filter-chip">Kết quả: <strong><c:out value="${selectedStatusLabel}" /></strong></span>
                            </c:if>
                            <a class="bm-active-filters__clear" href="${pageContext.request.contextPath}/librarian/book-management/import-history">Xóa bộ lọc</a>
                        </div>
                    </c:if>

                    <%-- Bảng danh sách lịch sử các đợt nhập Excel --%>
                    <section class="bm-table-card bm-table-card--primary bm-data-table">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead>
                                    <tr>
                                        <th>Mã phiên</th>
                                        <th>Tệp dữ liệu</th>
                                        <th>Người thực hiện</th>
                                        <th>Thời gian</th>
                                        <th>Kết quả</th>
                                        <th>Tổng / thành công / lỗi</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="batch" items="${batches}">
                                        <tr>
                                            <td><strong>Nhập #${batch.importBatchId}</strong></td>
                                            <td><c:out value="${batch.fileName}" /></td>
                                            <td><c:out value="${batch.importedByName}" /></td>
                                            <td><fmt:formatDate value="${batch.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td>
                                                <%-- Trạng thái đợt nhập --%>
                                                <c:choose>
                                                    <c:when test="${batch.status == 'success'}">
                                                        <span class="bm-badge bm-badge--success">Thành công</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bm-badge bm-badge--danger">Thất bại</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${batch.totalRows} / ${batch.successRows} / ${batch.failedRows}</td>
                                            <td>
                                                <%-- Nút dẫn tới xem lỗi chi tiết nếu thất bại hoặc xem chi tiết đợt nhập thành công --%>
                                                <a class="btn btn-sm bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/import-history?batchId=${batch.importBatchId}">
                                                    ${batch.status == 'failed' ? 'Xem lỗi' : 'Chi tiết'}
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty batches}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="bm-empty-state">
                                                    <span class="material-symbols-outlined">history</span>
                                                    <strong>Chưa có phiên nhập dữ liệu</strong>
                                                    <span>Lịch sử xử lý sẽ xuất hiện sau khi tệp đầu tiên được kiểm tra.</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <%-- Thanh phân trang --%>
                    <jsp:include page="fragments/_book-pagination.jsp">
                        <jsp:param name="label" value="Phân trang lịch sử nhập" />
                        <jsp:param name="inputId" value="bookImportHistoryPageJump" />
                    </jsp:include>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
                <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
            </main>
        </div>
        <%-- Modal hiển thị chi tiết lỗi của phiên nhập sách thất bại --%>
        <jsp:include page="fragments/_book-import-history-modal.jsp" />
    </body>
</html>
