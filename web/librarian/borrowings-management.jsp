<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">
                <jsp:include page="fragments/_header.jsp" />

                <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                    <!-- Header Title -->
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                        <div>
                            <h1 class="h3 fw-bold mb-1" style="color: var(--text-heading);">
                                <span class="material-symbols-outlined align-middle me-2 text-primary" style="font-size: 2rem;">menu_book</span>
                                Quản lý Danh sách Mượn sách
                            </h1>
                            <p class="text-muted small mb-0">Tra cứu các lượt mượn sách đang hoạt động và gửi yêu cầu thu hồi sách cho độc giả.</p>
                        </div>
                    </div>

                    <!-- Flash Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                            <span class="material-symbols-outlined">error</span>
                            <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <%-- Filter Card --%>
                    <div class="raised-card mb-4 p-3">
                        <form action="${pageContext.request.contextPath}/librarian/borrowings" method="get" class="row g-3">
                            <div class="col-12 col-md-3">
                                <label for="userKeyword" class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Độc giả (Tên / Mã SV-GV / Email)</label>
                                <div class="input-group">
                                    <span class="input-group-text" style="background: var(--surface-container-lowest); border-color: var(--outline-variant);">
                                        <span class="material-symbols-outlined text-muted" style="font-size: 18px;">person_search</span>
                                    </span>
                                    <input type="text" class="form-control" id="userKeyword" name="userKeyword" value="<c:out value='${userKeyword}' />" placeholder="Nhập tên, mã SV/GV..." style="border-color: var(--outline-variant);">
                                </div>
                            </div>

                            <div class="col-12 col-md-3">
                                <label for="barcodeKeyword" class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Mã vạch bản sao sách</label>
                                <div class="input-group">
                                    <span class="input-group-text" style="background: var(--surface-container-lowest); border-color: var(--outline-variant);">
                                        <span class="material-symbols-outlined text-muted" style="font-size: 18px;">qr_code_scanner</span>
                                    </span>
                                    <input type="text" class="form-control" id="barcodeKeyword" name="barcodeKeyword" value="<c:out value='${barcodeKeyword}' />" placeholder="Nhập mã vạch..." style="border-color: var(--outline-variant);">
                                </div>
                            </div>

                            <div class="col-12 col-md-2">
                                <label for="status" class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Trạng thái mượn</label>
                                <select class="form-select" id="status" name="status" style="border-color: var(--outline-variant);">
                                    <option value="all" ${status == 'all' ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                                    <option value="borrowed" ${status == 'borrowed' ? 'selected' : ''}>Đang mượn</option>
                                    <option value="overdue" ${status == 'overdue' ? 'selected' : ''}>Quá hạn</option>
                                    <option value="recalled" ${status == 'recalled' ? 'selected' : ''}>Đã thu hồi</option>
                                    <option value="returned" ${status == 'returned' ? 'selected' : ''}>Đã trả</option>
                                </select>
                            </div>

                            <div class="col-12 col-md-2">
                                <label for="fromDate" class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Từ ngày mượn</label>
                                <input type="date" class="form-control" id="fromDate" name="fromDate" value="<c:out value='${fromDate}' />" style="border-color: var(--outline-variant);">
                            </div>

                            <div class="col-12 col-md-2">
                                <label for="toDate" class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Đến ngày mượn</label>
                                <input type="date" class="form-control" id="toDate" name="toDate" value="<c:out value='${toDate}' />" style="border-color: var(--outline-variant);">
                            </div>

                            <div class="col-12 col-md-8">
                                <label class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Sắp xếp dữ liệu</label>
                                <div class="row g-2">
                                    <div class="col-6 col-md-7">
                                        <select name="sortBy" class="form-select" style="border-color: var(--outline-variant);">
                                            <option value="startDate" ${sortBy == 'startDate' ? 'selected' : ''}>Thời gian / Ngày mượn sách</option>
                                            <option value="endDate" ${sortBy == 'endDate' ? 'selected' : ''}>Hạn trả sách</option>
                                            <option value="bookTitle" ${sortBy == 'bookTitle' ? 'selected' : ''}>Tên sách</option>
                                            <option value="userFullName" ${sortBy == 'userFullName' ? 'selected' : ''}>Tên độc giả</option>
                                            <option value="barcode" ${sortBy == 'barcode' ? 'selected' : ''}>Mã vạch bản sao</option>
                                            <option value="borrowRecordId" ${sortBy == 'borrowRecordId' ? 'selected' : ''}>Mã phiếu mượn (ID)</option>
                                        </select>
                                    </div>
                                    <div class="col-6 col-md-5">
                                        <select name="sortOrder" class="form-select" style="border-color: var(--outline-variant);">
                                            <option value="DESC" ${sortOrder == 'DESC' ? 'selected' : ''}>Giảm dần (Từ trên xuống ↓)</option>
                                            <option value="ASC" ${sortOrder == 'ASC' ? 'selected' : ''}>Tăng dần (Từ dưới lên ↑)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-4 d-flex flex-column justify-content-end">
                                <label class="form-label d-none d-md-block" style="font-size: 12px; margin-bottom: 8px; visibility: hidden;">&nbsp;</label>
                                <div class="d-flex gap-2 justify-content-end">
                                    <a href="${pageContext.request.contextPath}/librarian/borrowings"
                                       class="btn btn-outline-secondary d-inline-flex align-items-center justify-content-center"
                                       style="height: 38px; border-radius: 8px;">
                                        <span class="material-symbols-outlined me-1" style="font-size: 18px;">restart_alt</span> Đặt lại
                                    </a>
                                    <button type="submit" class="btn text-white fw-semibold d-inline-flex align-items-center justify-content-center"
                                            style="background-color: #d97706; border-color: #d97706; height: 38px; border-radius: 8px;">
                                        <span class="material-symbols-outlined me-1" style="font-size: 18px;">search</span> Tìm kiếm &amp; Lọc
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <%-- Data Table Card --%>
                    <div class="raised-card overflow-hidden">
                        <div class="card-header-row">
                            <div>
                                <h3 class="card-title">Quản lý sách đang mượn</h3>
                                <p class="card-subtitle">
                                    <span class="badge-pill badge-info"><c:out value="${totalRecords}" /> lượt mượn</span>
                                </p>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms mb-0">
                                <thead>
                                    <tr>
                                        <th style="width: 70px;">Mã phiếu</th>
                                        <th>Tựa sách &amp; Mã vạch</th>
                                        <th>Độc giả</th>
                                        <th>Mã độc giả</th>
                                        <th>Ngày mượn</th>
                                        <th>Hạn trả sách</th>
                                        <th class="text-center">Trạng thái</th>
                                        <th class="text-end" style="width: 140px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty borrowings}">
                                            <c:forEach var="item" items="${borrowings}">
                                                <tr>
                                                    <td>
                                                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface-variant);">#<c:out value="${item.borrowRecordId}" /></span>
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 13px; font-weight: 600;"><c:out value="${item.bookTitle}" /></div>
                                                        <div class="text-muted" style="font-size: 11px;">
                                                            Mã vạch: <span class="badge-pill badge-info"><c:out value="${item.barcode}" /></span>
                                                            <c:if test="${not empty item.isbn}">
                                                                | ISBN: <c:out value="${item.isbn}" />
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--secondary-container); color: var(--on-secondary-container);">
                                                                <c:out value="${fn:toUpperCase(fn:substring(item.userFullName, 0, 2))}" />
                                                            </div>
                                                            <span style="font-size: 13px; font-weight: 600;"><c:out value="${item.userFullName}" /></span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge-pill badge-info"><c:out value="${item.userCode}" /></span>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">
                                                        <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td style="font-size: 13px;">
                                                        <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${item.status == 'borrowed'}">
                                                                <span class="badge-pill badge-warning">Đang mượn</span>
                                                            </c:when>
                                                            <c:when test="${item.status == 'overdue'}">
                                                                <span class="badge-pill badge-error">Quá hạn</span>
                                                            </c:when>
                                                            <c:when test="${item.status == 'recalled'}">
                                                                <span class="badge-pill badge-warning">Đã thu hồi</span>
                                                            </c:when>
                                                            <c:when test="${item.status == 'returned'}">
                                                                <span class="badge-pill badge-success">Đã trả</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill badge-info"><c:out value="${item.status}" /></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <c:if test="${item.status == 'borrowed' || item.status == 'overdue'}">
                                                            <button type="button"
                                                                    class="btn btn-sm fw-bold px-2 text-decoration-none rounded-2"
                                                                    style="font-size: 11px; color: var(--on-secondary-container); background-color: var(--secondary-container); border: none;"
                                                                    onclick="openRecallModal('${item.borrowRecordId}', '${fn:escapeXml(item.userFullName)}', '${fn:escapeXml(item.bookTitle)}', '${item.barcode}')">
                                                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 14px;">mail</span> Thu hồi
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center py-5">
                                                    <span class="material-symbols-outlined text-muted" style="font-size: 48px;">inbox</span>
                                                    <p class="text-muted mt-2 mb-0" style="font-size: 14px;">Không tìm thấy bản ghi mượn sách nào phù hợp.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination Footer -->
                        <c:if test="${totalPages > 1}">
                            <div class="card-footer bg-transparent border-0 px-4 py-3 d-flex justify-content-between align-items-center">
                                <span class="small text-muted">Trang <strong><c:out value="${currentPage}" /></strong> / <strong><c:out value="${totalPages}" /></strong></span>
                                <nav aria-label="Pagination">
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${currentPage - 1}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">Trước</a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${i}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${currentPage + 1}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>

                </div>

                <!-- Modal: Gửi Gmail Yêu cầu Thu hồi sách -->
                <div class="modal fade" id="sendRecallModal" tabindex="-1" aria-labelledby="sendRecallModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <form action="${pageContext.request.contextPath}/librarian/borrowings" method="post">
                                <input type="hidden" name="action" value="sendRecallEmail">
                                <input type="hidden" name="borrowRecordId" id="modalBorrowRecordId">

                                <div class="modal-header bg-warning-subtle border-0">
                                    <h5 class="modal-title text-warning-emphasis fw-bold d-flex align-items-center" id="sendRecallModalLabel">
                                        <span class="material-symbols-outlined me-2">mail</span>
                                        Gửi Gmail Yêu cầu Thu hồi Sách
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="alert alert-light border mb-3">
                                        <p class="mb-1"><strong>Độc giả:</strong> <span id="modalUserFullName" class="text-primary fw-semibold"></span></p>
                                        <p class="mb-1"><strong>Tên sách:</strong> <span id="modalBookTitle" class="fw-semibold"></span></p>
                                        <p class="mb-0"><strong>Mã vạch:</strong> <span id="modalBarcode" class="badge bg-secondary"></span></p>
                                    </div>

                                    <div class="mb-3">
                                        <label for="recallReason" class="form-label fw-semibold text-secondary">
                                            Lý do thu hồi sách <span class="text-danger">*</span>
                                        </label>
                                        <textarea class="form-control" id="recallReason" name="recallReason" rows="3" required
                                                  placeholder="Nhập lý do thu hồi (ví dụ: Yêu cầu phục vụ giảng dạy, bảo quản khẩn cấp...)"></textarea>
                                        <div class="form-text small text-muted">Email thông báo mẫu RECALL_NOTICE sẽ được gửi bất đồng bộ tới hòm thư độc giả.</div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light border-0">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                                    <button type="submit" class="btn btn-warning d-inline-flex align-items-center">
                                        <span class="material-symbols-outlined me-1">send</span>
                                        Xác nhận Gửi Mail
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>

        <script>
            function openRecallModal(id, user, book, barcode) {
                document.getElementById('modalBorrowRecordId').value = id || '';
                document.getElementById('modalUserFullName').textContent = user || '';
                document.getElementById('modalBookTitle').textContent = book || '';
                document.getElementById('modalBarcode').textContent = barcode || '';
                document.getElementById('recallReason').value = '';
                var el = document.getElementById('sendRecallModal');
                if (el) {
                    var modal = bootstrap.Modal.getOrCreateInstance(el);
                    modal.show();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var sendRecallModal = document.getElementById('sendRecallModal');
                if (sendRecallModal) {
                    sendRecallModal.addEventListener('show.bs.modal', function (event) {
                        var button = event.relatedTarget;
                        if (!button) return;
                        var id = button.getAttribute('data-id');
                        var user = button.getAttribute('data-user');
                        var book = button.getAttribute('data-book');
                        var barcode = button.getAttribute('data-barcode');

                        if (id) document.getElementById('modalBorrowRecordId').value = id;
                        if (user) document.getElementById('modalUserFullName').textContent = user;
                        if (book) document.getElementById('modalBookTitle').textContent = book;
                        if (barcode) document.getElementById('modalBarcode').textContent = barcode;
                        document.getElementById('recallReason').value = '';
                    });
                }
            });
        </script>
    </body>
</html>
