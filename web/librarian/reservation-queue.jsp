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

                    <%-- Flash Messages --%>
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
                    <c:if test="${not empty errorMessage}">
                        <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                            <span class="material-symbols-outlined">error</span>
                            <span class="flex-grow-1"><c:out value="${errorMessage}" /></span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                    </c:if>

                    <%-- Page Header --%>
                    <div class="d-flex justify-content-between align-items-end mb-4">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <a href="${pageContext.request.contextPath}/librarian/dashboard" class="btn btn-sm btn-icon text-muted" title="Trở lại">
                                    <span class="material-symbols-outlined">arrow_back</span>
                                </a>
                                <h2 class="mb-0" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">Quản lý Hàng chờ Đặt trước</h2>
                            </div>
                            <p class="text-on-surface-variant mb-0 ms-5" style="font-size: 13px;">
                                Tra cứu, xem thứ tự hàng chờ và hỗ trợ hủy lượt đặt trước cho độc giả
                            </p>
                        </div>
                    </div>

                    <%-- Search & Filter --%>
                    <div class="raised-card mb-4 p-3">
                        <form method="GET" action="${pageContext.request.contextPath}/librarian/reservation-queue" class="row g-3 align-items-center">
                            <div class="col-md-5">
                                <label class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Tìm kiếm từ khóa</label>
                                <div class="input-group">
                                    <span class="input-group-text" style="background: var(--surface-container-lowest); border-color: var(--outline-variant);">
                                        <span class="material-symbols-outlined text-muted" style="font-size: 18px;">search</span>
                                    </span>
                                    <input type="text" name="keyword" class="form-control"
                                           placeholder="Tên sách, ISBN, Mã độc giả, Họ tên..."
                                           value="<c:out value='${keyword}' />"
                                           style="border-color: var(--outline-variant);">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" style="font-size: 12px; font-weight: 600; color: var(--on-surface-variant);">Trạng thái đặt trước</label>
                                <select name="status" class="form-select" style="border-color: var(--outline-variant);">
                                    <option value="all" ${status == 'all' ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Đang chờ trong hàng đợi (pending)</option>
                                    <option value="readypickup" ${status == 'readypickup' ? 'selected' : ''}>Sẵn sàng nhận sách (readypickup)</option>
                                    <option value="fulfilled" ${status == 'fulfilled' ? 'selected' : ''}>Đã mượn sách (fulfilled)</option>
                                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Đã hủy (cancelled)</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1">
                                    <span class="material-symbols-outlined align-middle me-1" style="font-size: 18px;">filter_alt</span> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/librarian/reservation-queue" class="btn btn-outline-secondary">Đặt lại</a>
                            </div>
                        </form>
                    </div>

                    <%-- Queue Table --%>
                    <div class="raised-card overflow-hidden">
                        <div class="card-header-row">
                            <div>
                                <h3 class="card-title">Danh sách Hàng chờ Đặt trước</h3>
                                <p class="card-subtitle">
                                    <span class="badge-pill badge-info"><c:out value="${totalItems}" /> Đơn</span>
                                </p>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Tựa sách</th>
                                        <th>Độc giả</th>
                                        <th>Mã độc giả</th>
                                        <th class="text-center">Vị trí hàng chờ</th>
                                        <th class="text-center">Trạng thái</th>
                                        <th>Ngày đặt</th>
                                        <th>Hạn nhận sách</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty queueList}">
                                            <tr>
                                                <td colspan="9" class="text-center py-5">
                                                    <span class="material-symbols-outlined text-muted" style="font-size: 48px;">inbox</span>
                                                    <p class="text-muted mt-2 mb-0" style="font-size: 14px;">Không tìm thấy đơn đặt trước nào thỏa mãn bộ lọc.</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="res" items="${queueList}">
                                                <tr>
                                                    <td>
                                                        <span style="font-size: 13px; font-weight: 600; color: var(--on-surface-variant);">#<c:out value="${res.reservationId}" /></span>
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 13px; font-weight: 600;"><c:out value="${res.bookTitle}" /></div>
                                                        <div class="text-muted" style="font-size: 11px;">ID: <c:out value="${res.bookId}" /></div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--secondary-container); color: var(--on-secondary-container);">
                                                                <c:out value="${fn:toUpperCase(fn:substring(res.memberName, 0, 2))}" />
                                                            </div>
                                                            <span style="font-size: 13px; font-weight: 600;"><c:out value="${res.memberName}" /></span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge-pill badge-info"><c:out value="${res.memberCode}" /></span>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${res.queuePosition == 0}">
                                                                <span class="badge-pill badge-success">
                                                                    <span class="material-symbols-outlined align-middle me-1" style="font-size: 14px;">verified</span>
                                                                    Đến lượt nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${not empty res.queuePosition and res.queuePosition > 0}">
                                                                <span class="badge-pill badge-warning">Vị trí #<c:out value="${res.queuePosition}" /></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted" style="font-size: 13px;">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${res.status == 'pending'}">
                                                                <span class="badge-pill badge-warning">Đang chờ</span>
                                                            </c:when>
                                                            <c:when test="${res.status == 'readypickup'}">
                                                                <span class="badge-pill badge-success">Sẵn sàng nhận</span>
                                                            </c:when>
                                                            <c:when test="${res.status == 'fulfilled'}">
                                                                <span class="badge-pill badge-info">Đã nhận sách</span>
                                                            </c:when>
                                                            <c:when test="${res.status == 'cancelled'}">
                                                                <span class="badge-pill badge-error">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill badge-info"><c:out value="${res.status}" /></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">
                                                        <fmt:formatDate value="${res.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td style="font-size: 13px;">
                                                        <c:choose>
                                                            <c:when test="${not empty res.endDate}">
                                                                <fmt:formatDate value="${res.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </c:when>
                                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <c:if test="${res.status == 'pending' or res.status == 'readypickup'}">
                                                            <button type="button"
                                                                    class="btn btn-sm fw-bold px-3 text-decoration-none rounded-2"
                                                                    style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none;"
                                                                    onclick="openCancelModal('${res.reservationId}', '<c:out value="${fn:replace(res.bookTitle, \"'\", \"\\\\'\")}" />', '<c:out value="${fn:replace(res.memberName, \"'\", \"\\\\'\")}" />')">
                                                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 14px;">cancel</span>
                                                                Hủy lượt
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <%-- Pagination --%>
                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-between align-items-center px-4 py-3 border-top" style="border-color: var(--outline-variant) !important;">
                                <div style="font-size: 13px; color: var(--on-surface-variant);">
                                    Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong> &nbsp;·&nbsp; Tổng <strong>${totalItems}</strong> bản ghi
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm mb-0">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/librarian/reservation-queue?keyword=${keyword}&amp;status=${status}&amp;page=${currentPage - 1}">Trước</a>
                                            </li>
                                        </c:if>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/librarian/reservation-queue?keyword=${keyword}&amp;status=${status}&amp;page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/librarian/reservation-queue?keyword=${keyword}&amp;status=${status}&amp;page=${currentPage + 1}">Sau</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>

                </div>
                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>

        <%-- Modal Hủy Lượt Đặt Trước --%>
        <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="POST" action="${pageContext.request.contextPath}/librarian/reservation-queue">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="reservationId" id="cancelReservationId">
                        <div class="modal-header">
                            <h5 class="modal-title fw-bold" id="cancelModalLabel">Xác nhận Hủy lượt đặt trước</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            <p class="mb-2">
                                Bạn đang hủy lượt đặt trước <strong id="cancelBookTitle"></strong>
                                của độc giả <strong id="cancelMemberName"></strong>.
                            </p>
                            <p style="font-size: 13px; color: var(--on-surface-variant);" class="mb-3">
                                Sau khi hủy, hệ thống sẽ tự động đôn vị trí hàng chờ của độc giả xếp phía sau lên.
                            </p>
                            <div class="mb-3">
                                <label for="cancelReason" class="form-label fw-semibold">Lý do hủy <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="reason" id="cancelReason" rows="3"
                                          placeholder="Nhập lý do hủy lượt đặt trước..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận Hủy đơn</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function openCancelModal(resId, bookTitle, memberName) {
                document.getElementById('cancelReservationId').value = resId;
                document.getElementById('cancelBookTitle').innerText = bookTitle;
                document.getElementById('cancelMemberName').innerText = memberName;
                document.getElementById('cancelReason').value = '';
                var modal = new bootstrap.Modal(document.getElementById('cancelModal'));
                modal.show();
            }
        </script>
    </body>
</html>
