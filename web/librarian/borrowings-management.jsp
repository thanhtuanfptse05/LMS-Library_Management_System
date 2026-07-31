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

                    <!-- Filter Card -->
                    <div class="card border-0 shadow-sm rounded-3 mb-4">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/librarian/borrowings" method="get" class="row g-3">
                                <div class="col-12 col-md-3">
                                    <label for="userKeyword" class="form-label small fw-semibold text-secondary">Độc giả (Tên / Mã SV-GV / Email)</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">person_search</span></span>
                                        <input type="text" class="form-control border-start-0 bg-light" id="userKeyword" name="userKeyword" value="<c:out value='${userKeyword}' />" placeholder="Nhập tên, mã SV/GV...">
                                    </div>
                                </div>

                                <div class="col-12 col-md-3">
                                    <label for="barcodeKeyword" class="form-label small fw-semibold text-secondary">Mã vạch bản sao sách</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">qr_code_scanner</span></span>
                                        <input type="text" class="form-control border-start-0 bg-light" id="barcodeKeyword" name="barcodeKeyword" value="<c:out value='${barcodeKeyword}' />" placeholder="Nhập mã vạch...">
                                    </div>
                                </div>

                                <div class="col-12 col-md-2">
                                    <label for="status" class="form-label small fw-semibold text-secondary">Trạng thái mượn</label>
                                    <select class="form-select bg-light" id="status" name="status">
                                        <option value="all" ${status == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                                        <option value="borrowed" ${status == 'borrowed' ? 'selected' : ''}>Đang mượn</option>
                                        <option value="overdue" ${status == 'overdue' ? 'selected' : ''}>Quá hạn</option>
                                        <option value="recalled" ${status == 'recalled' ? 'selected' : ''}>Đã thu hồi</option>
                                        <option value="returned" ${status == 'returned' ? 'selected' : ''}>Đã trả</option>
                                    </select>
                                </div>

                                <div class="col-12 col-md-2">
                                    <label for="fromDate" class="form-label small fw-semibold text-secondary">Từ ngày mượn</label>
                                    <input type="date" class="form-control bg-light" id="fromDate" name="fromDate" value="<c:out value='${fromDate}' />">
                                </div>

                                <div class="col-12 col-md-2">
                                    <label for="toDate" class="form-label small fw-semibold text-secondary">Đến ngày mượn</label>
                                    <input type="date" class="form-control bg-light" id="toDate" name="toDate" value="<c:out value='${toDate}' />">
                                </div>

                                <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                                    <a href="${pageContext.request.contextPath}/librarian/borrowings" class="btn btn-outline-secondary d-inline-flex align-items-center">
                                        <span class="material-symbols-outlined me-1">restart_alt</span> Đặt lại
                                    </a>
                                    <button type="submit" class="btn btn-primary d-inline-flex align-items-center">
                                        <span class="material-symbols-outlined me-1">search</span> Tìm kiếm
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Data Table Card -->
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-header bg-transparent border-0 px-4 py-3 d-flex justify-content-between align-items-center">
                            <h5 class="card-title fw-bold mb-0 text-secondary">
                                Danh sách lượt mượn (<c:out value="${totalRecords}" /> lượt mượn)
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="px-4 py-3 text-secondary" style="width: 70px;">ID</th>
                                            <th class="py-3 text-secondary">Thông tin Độc giả</th>
                                            <th class="py-3 text-secondary">Thông tin Sách mượn</th>
                                            <th class="py-3 text-secondary">Ngày mượn</th>
                                            <th class="py-3 text-secondary">Hạn trả sách</th>
                                            <th class="py-3 text-secondary text-center">Trạng thái</th>
                                            <th class="px-4 py-3 text-secondary text-end" style="width: 180px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty borrowings}">
                                                <c:forEach var="item" items="${borrowings}">
                                                    <tr>
                                                        <td class="px-4 py-3 fw-bold text-muted">#<c:out value="${item.borrowRecordId}" /></td>
                                                        <td>
                                                            <div class="fw-semibold text-dark"><c:out value="${item.userFullName}" /></div>
                                                            <div class="small text-muted">
                                                                Mã: <span class="badge bg-light text-dark border"><c:out value="${item.userCode}" /></span>
                                                                | Email: <c:out value="${item.userEmail}" />
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="fw-semibold text-dark"><c:out value="${item.bookTitle}" /></div>
                                                            <div class="small text-muted">
                                                                Mã vạch: <span class="badge bg-light text-primary border"><c:out value="${item.barcode}" /></span>
                                                                <c:if test="${not empty item.isbn}">
                                                                    | ISBN: <c:out value="${item.isbn}" />
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${item.status == 'borrowed'}">
                                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 rounded-pill">Đang mượn</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'overdue'}">
                                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1 rounded-pill">Quá hạn</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'recalled'}">
                                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1 rounded-pill">Đã thu hồi</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'returned'}">
                                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">Đã trả</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary-subtle text-secondary px-2 py-1 rounded-pill"><c:out value="${item.status}" /></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="px-4 py-3 text-end">
                                                            <c:if test="${item.status == 'borrowed' or item.status == 'overdue'}">
                                                                <button type="button" class="btn btn-sm btn-outline-warning text-dark d-inline-flex align-items-center"
                                                                        data-bs-toggle="modal" data-bs-target="#sendRecallModal"
                                                                        data-id="${item.borrowRecordId}"
                                                                        data-user="${fn:escapeXml(item.userFullName)}"
                                                                        data-book="${fn:escapeXml(item.bookTitle)}"
                                                                        data-barcode="${fn:escapeXml(item.barcode)}">
                                                                    <span class="material-symbols-outlined me-1" style="font-size: 1.1rem;">mail</span>
                                                                    Gửi Gmail Thu hồi
                                                                </button>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <span class="material-symbols-outlined fs-1 text-secondary d-block mb-2">inbox</span>
                                                        Không tìm thấy lượt mượn sách nào phù hợp với bộ lọc.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Pagination Footer -->
                        <c:if test="${totalPages > 1}">
                            <div class="card-footer bg-transparent border-0 px-4 py-3 d-flex justify-content-between align-items-center">
                                <span class="small text-muted">Trang <strong><c:out value="${currentPage}" /></strong> / <strong><c:out value="${totalPages}" /></strong></span>
                                <nav aria-label="Pagination">
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${currentPage - 1}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">Trước</a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${i}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/librarian/borrowings?page=${currentPage + 1}&userKeyword=${userKeyword}&barcodeKeyword=${barcodeKeyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">Sau</a>
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
            document.addEventListener('DOMContentLoaded', function () {
                var sendRecallModal = document.getElementById('sendRecallModal');
                if (sendRecallModal) {
                    sendRecallModal.addEventListener('show.bs.modal', function (event) {
                        var button = event.relatedTarget;
                        var id = button.getAttribute('data-id');
                        var user = button.getAttribute('data-user');
                        var book = button.getAttribute('data-book');
                        var barcode = button.getAttribute('data-barcode');

                        document.getElementById('modalBorrowRecordId').value = id;
                        document.getElementById('modalUserFullName').textContent = user;
                        document.getElementById('modalBookTitle').textContent = book;
                        document.getElementById('modalBarcode').textContent = barcode;
                        document.getElementById('recallReason').value = '';
                    });
                }
            });
        </script>
    </body>
</html>
