<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Trang: book-copies.jsp - Quản lý Bản sao Sách Vật lý --%>
<%-- Cho phép Thủ thư xem danh sách, cập nhật vị trí và ghi nhận sự cố --%>
<%-- đối với từng cuốn sách vật lý có mã vạch (Barcode) riêng biệt --%>

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

                    <%-- Tiêu đề trang và Nút thêm bản sao mới --%>
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Kho vật lý</p>
                            <h2 class="bm-page__title mb-1">Tất cả bản sao</h2>
                            <p class="bm-page__subtitle mb-0">Theo dõi từng cuốn sách vật lý theo mã vạch, vị trí và trạng thái lưu thông.</p>
                        </div>
                        <div class="bm-actions">
                            <c:url var="exportCopiesUrl" value="/librarian/book-management/copies/export">
                                <c:param name="q" value="${q}" />
                                <c:param name="location" value="${selectedLocation}" />
                                <c:param name="status" value="${selectedStatus}" />
                            </c:url>
                            <a class="btn bm-btn-secondary" href="${exportCopiesUrl}">
                                <span class="material-symbols-outlined">download</span>
                                Xuất CSV
                            </a>
                            <c:if test="${canEdit}">
                                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createCopyModal">
                                    <span class="material-symbols-outlined">add</span>
                                    Thêm bản sao
                                </button>
                            </c:if>
                        </div>
                    </section>

                    <%-- Bộ lọc tìm kiếm bản sao sách (theo từ khóa/mã vạch, vị trí, trạng thái) --%>
                    <form class="bm-filter-card bm-list-filter mb-3" method="get" action="${pageContext.request.contextPath}/librarian/book-management/copies">
                        <div class="row g-2">
                            <div class="col-xl-4 col-lg-6 bm-search">
                                <span class="material-symbols-outlined">barcode_scanner</span>
                                <input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Quét mã vạch hoặc tìm tên sách">
                            </div>
                            <div class="col-xl-3 col-md-4">
                                <select class="form-select" name="location">
                                    <option value="">Tất cả vị trí</option>
                                    <c:forEach var="item" items="${locations}">
                                        <option value="<c:out value="${item}" />" ${selectedLocation == item ? 'selected' : ''}>
                                            <c:out value="${item}" />
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-xl-3 col-md-4">
                                <select class="form-select" name="status">
                                    <option value="">Mọi trạng thái</option>
                                    <option value="available" ${selectedStatus == 'available' ? 'selected' : ''}>Sẵn sàng</option>
                                    <option value="borrowed" ${selectedStatus == 'borrowed' ? 'selected' : ''}>Đang mượn</option>
                                    <option value="reserved" ${selectedStatus == 'reserved' ? 'selected' : ''}>Đặt trước</option>
                                    <option value="incident" ${selectedStatus == 'incident' ? 'selected' : ''}>Hỏng hoặc mất</option>
                                    <option value="unavailable" ${selectedStatus == 'unavailable' ? 'selected' : ''}>Ngừng lưu thông</option>
                                </select>
                            </div>
                            <div class="col-xl-2 col-lg-6">
                                <div class="bm-filter-actions bm-filter-actions--compact">
                                    <button class="btn bm-filter-button ${not empty q or not empty selectedLocation or not empty selectedStatus ? 'bm-filter-button--active' : ''}" type="submit">
                                        <span class="material-symbols-outlined">filter_alt</span>
                                        <span>Lọc</span>
                                        <c:if test="${not empty q or not empty selectedLocation or not empty selectedStatus}">
                                            <span class="bm-filter-badge">Đang áp dụng</span>
                                        </c:if>
                                    </button>
                                    <a class="btn bm-reset-button" href="${pageContext.request.contextPath}/librarian/book-management/copies" title="Đặt lại bộ lọc" aria-label="Đặt lại bộ lọc">
                                        <span class="material-symbols-outlined">refresh</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>

                    <c:choose>
                        <c:when test="${selectedStatus == 'available'}"><c:set var="selectedStatusLabel" value="Sẵn sàng" /></c:when>
                        <c:when test="${selectedStatus == 'borrowed'}"><c:set var="selectedStatusLabel" value="Đang mượn" /></c:when>
                        <c:when test="${selectedStatus == 'reserved'}"><c:set var="selectedStatusLabel" value="Đặt trước" /></c:when>
                        <c:when test="${selectedStatus == 'incident'}"><c:set var="selectedStatusLabel" value="Hỏng hoặc mất" /></c:when>
                        <c:when test="${selectedStatus == 'unavailable'}"><c:set var="selectedStatusLabel" value="Ngừng lưu thông" /></c:when>
                    </c:choose>
                    <c:if test="${not empty q or not empty selectedLocation or not empty selectedStatus}">
                        <div class="bm-active-filters mb-3" aria-label="Bộ lọc đang áp dụng">
                            <span class="bm-active-filters__label">Đang lọc:</span>
                            <c:if test="${not empty q}">
                                <span class="bm-active-filter-chip">Từ khóa: <strong><c:out value="${q}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedLocation}">
                                <span class="bm-active-filter-chip">Vị trí: <strong><c:out value="${selectedLocation}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedStatus}">
                                <span class="bm-active-filter-chip">Trạng thái: <strong><c:out value="${selectedStatusLabel}" /></strong></span>
                            </c:if>
                            <a class="bm-active-filters__clear" href="${pageContext.request.contextPath}/librarian/book-management/copies">Xóa bộ lọc</a>
                        </div>
                    </c:if>

                    <div class="bm-rule-note bm-rule-note--compact mb-3"><strong>Quy tắc:</strong> Không thể sửa bản sao đang được mượn, đã đặt trước hoặc đang chờ xử lý sự cố. Mã vạch không thể thay đổi sau khi tạo.</div>

                    <%-- Thống kê tổng quan về các bản sao (Tổng, Sẵn sàng, Đang mượn, Hỏng/Mất) --%>
                    <div class="bm-list-stats bm-list-stats--five mb-3">
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
                        <article class="bm-list-stat bm-list-stat--info">
                            <span class="material-symbols-outlined">menu_book</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Đang mượn</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.borrowedCopies}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--warning">
                            <span class="material-symbols-outlined">event_available</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Đặt trước</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.reservedCopies}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--danger">
                            <span class="material-symbols-outlined">report</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Hỏng/mất</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.incidentCopies}" /></p>
                            </div>
                        </article>
                    </div>

                    <%-- Bảng danh sách bản sao sách --%>
                    <section class="bm-table-card bm-table-card--primary bm-data-table">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead>
                                    <tr>
                                        <th>Mã vạch</th>
                                        <th>Đầu sách</th>
                                        <th>Vị trí</th>
                                        <th>Tình trạng</th>
                                        <th>Lưu thông</th>
                                        <th>Cập nhật</th>
                                        <th class="bm-copy-action-column">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="copy" items="${copies}">
                                        <tr>
                                            <td><strong><c:out value="${copy.barcode}" /></strong></td>
                                            <td>
                                                <strong><c:out value="${copy.bookTitle}" /></strong>
                                                <div class="bm-book__meta"><c:out value="${copy.isbn}" /></div>
                                            </td>
                                            <td><c:out value="${copy.location}" /></td>
                                            <td>
                                                <%-- Tình trạng hao mòn của sách vật lý (Tốt, Hỏng, Mất) --%>
                                                <c:choose>
                                                    <c:when test="${copy.condition == 'good'}">
                                                        <span class="bm-badge bm-badge--success">Tốt</span>
                                                    </c:when>
                                                    <c:when test="${copy.condition == 'damaged'}">
                                                        <span class="bm-badge bm-badge--danger">Hỏng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bm-badge bm-badge--danger">Mất</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <%-- Trạng thái lưu thông/giao dịch (Sẵn sàng, Đang mượn, Đặt trước, Ngừng lưu thông) --%>
                                                <c:choose>
                                                    <c:when test="${copy.status == 'available'}">
                                                        <span class="bm-badge bm-badge--success">Sẵn sàng</span>
                                                    </c:when>
                                                    <c:when test="${copy.status == 'borrowed'}">
                                                        <span class="bm-badge bm-badge--info">Đang mượn</span>
                                                    </c:when>
                                                    <c:when test="${copy.status == 'reserved'}">
                                                        <span class="bm-badge bm-badge--warning">Đặt trước</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bm-badge bm-badge--neutral">Ngừng lưu thông</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${empty copy.updatedAt ? copy.createdAt : copy.updatedAt}" pattern="dd/MM/yyyy" /></td>
                                            <td class="bm-copy-action-column">
                                                <%-- Hành động dựa trên tình trạng và trạng thái --%>
                                                <div class="dropdown bm-copy-actions">
                                                    <button class="btn bm-row-action-button dropdown-toggle" type="button" data-bs-toggle="dropdown" data-bs-boundary="viewport" aria-expanded="false" aria-label="Mở menu thao tác">
                                                        <span class="material-symbols-outlined" aria-hidden="true">more_vert</span>
                                                    </button>
                                                    <div class="dropdown-menu dropdown-menu-end bm-row-action-menu">
                                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/book-management/circulation-history?bookCopyId=${copy.bookCopyId}">
                                                            <span class="material-symbols-outlined" aria-hidden="true">history</span>
                                                            <span>Xem lịch sử</span>
                                                        </a>
                                                    <c:choose>
                                                        <%-- 1. Nếu sách không tốt (Hỏng/Mất), cho phép xem sự cố liên quan --%>
                                                        <c:when test="${canEdit and copy.condition != 'good'}">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/book-management/incidents?q=${copy.barcode}">
                                                                <span class="material-symbols-outlined" aria-hidden="true">visibility</span>
                                                                <span>Xem sự cố</span>
                                                            </a>
                                                        </c:when>
                                                        <%-- 2. Nếu sách tốt & sẵn sàng trong thư viện, cho phép cập nhật vị trí hoặc báo cáo sự cố phát sinh --%>
                                                        <c:when test="${canEdit and copy.status == 'available' and copy.condition == 'good'}">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/book-management/copies?editId=${copy.bookCopyId}">
                                                                <span class="material-symbols-outlined" aria-hidden="true">edit</span>
                                                                <span>Cập nhật vị trí</span>
                                                            </a>
                                                            <a class="dropdown-item dropdown-item--danger" href="${pageContext.request.contextPath}/librarian/book-management/incidents?bookCopyId=${copy.bookCopyId}">
                                                                <span class="material-symbols-outlined" aria-hidden="true">report</span>
                                                                <span>Ghi nhận sự cố</span>
                                                            </a>
                                                        </c:when>
                                                        <%-- 3. Sách ngừng lưu thông, hiển thị nút xem sự cố --%>
                                                        <c:when test="${canEdit and copy.status == 'unavailable'}">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/librarian/book-management/incidents?q=${copy.barcode}">
                                                                <span class="material-symbols-outlined" aria-hidden="true">visibility</span>
                                                                <span>Xem sự cố</span>
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty copies}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="bm-empty-state">
                                                    <span class="material-symbols-outlined">inventory_2</span>
                                                    <strong>Không tìm thấy bản sao</strong>
                                                    <span>Hãy thử thay đổi bộ lọc hoặc thêm bản sao mới.</span>
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
                        <jsp:param name="label" value="Phân trang bản sao" />
                        <jsp:param name="inputId" value="bookCopyPageJump" />
                    </jsp:include>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
                <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
            </main>
        </div>

        <%-- Modal 1: Thêm bản sao sách mới --%>
        <c:if test="${canEdit}">
            <div class="modal fade bm-modal" id="createCopyModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/copies">
                            <input type="hidden" name="action" value="create">
                            <div class="modal-header">
                                <div>
                                    <h5 class="modal-title">Thêm bản sao vật lý</h5>
                                    <p class="bm-section-note mb-0">Bản sao mới được khởi tạo ở trạng thái tốt và sẵn sàng.</p>
                                </div>
                                <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <%-- Chọn đầu sách mẹ --%>
                                <div class="mb-3">
                                    <label class="form-label">Đầu sách <span class="bm-required">*</span></label>
                                    <select class="form-select" name="bookId" required>
                                        <option value="">Chọn đầu sách</option>
                                        <c:forEach var="book" items="${books}">
                                            <option value="${book.bookId}">
                                                <c:out value="${book.title}" /> · <c:out value="${book.isbn}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <%-- Mã vạch: Khóa tự nhiên duy nhất của bản sao sách vật lý --%>
                                <div class="mb-3">
                                    <label class="form-label">Mã vạch <span class="bm-required">*</span></label>
                                    <input class="form-control" name="barcode" required maxlength="50" placeholder="Ví dụ: BC-00018293">
                                </div>
                                <%-- Vị trí lưu trữ trong kho (kệ, tầng, hàng) --%>
                                <div>
                                    <label class="form-label">Vị trí <span class="bm-required">*</span></label>
                                    <input class="form-control" name="location" required maxlength="255" list="locationOptions" placeholder="Ví dụ: Kho A · Kệ A12">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn bm-btn-secondary" type="button" data-bs-dismiss="modal">Hủy</button>
                                <button class="btn btn-primary-custom" type="submit">Lưu bản sao</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <%-- Datalist gợi ý nhanh vị trí kho sách dựa trên các dữ liệu đã có trước đó --%>
        <datalist id="locationOptions">
            <c:forEach var="item" items="${locations}">
                <option value="<c:out value="${item}" />">
                </c:forEach>
        </datalist>

        <%-- Modal 2: Cập nhật vị trí bản sao sách (chỉ áp dụng đối với sách sẵn có ở trạng thái tốt) --%>
        <c:if test="${canEdit and not empty editCopy}">
            <div class="modal fade bm-modal" id="editCopyModal" tabindex="-1" aria-hidden="true" data-auto-open="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/copies">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="bookCopyId" value="${editCopy.bookCopyId}">
                            <div class="modal-header">
                                <div>
                                    <h5 class="modal-title">Cập nhật vị trí bản sao</h5>
                                    <p class="bm-section-note mb-0">Mã vạch <strong><c:out value="${editCopy.barcode}" /></strong> không thể thay đổi.</p>
                                </div>
                                <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Vị trí</label>
                                    <input class="form-control" name="location" required maxlength="255" list="locationOptions" value="<c:out value="${editCopy.location}" />">
                                </div>
                                <p class="bm-section-note mt-2 mb-0">Tình trạng Hỏng/Mất phải được ghi nhận và xác minh tại màn Hỏng &amp; mất.</p>
                            </div>
                            <div class="modal-footer">
                                <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/copies">Hủy</a>
                                <button class="btn btn-primary-custom" type="submit">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
    </body>
</html>
