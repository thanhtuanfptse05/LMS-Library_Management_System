<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">check_circle</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">error</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Header Banner ─── -->
                <section class="welcome-banner mb-4" style="background: linear-gradient(135deg, var(--surface-container) 0%, var(--surface-variant) 100%);">
                    <div class="row align-items-center g-0">
                        <div class="col-12 col-md-8">
                            <p class="text-on-surface-variant fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase;">Quản lý Thư viện</p>
                            <h2 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-primary-container);">
                                Quản lý Đề xuất sách (F20)
                            </h2>
                            <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                                Xem xét, duyệt và phản hồi các đề xuất bổ sung tài liệu học tập từ Giảng viên.
                            </p>
                        </div>
                        <div class="col-4 d-none d-md-flex justify-content-end align-items-center">
                            <span class="material-symbols-outlined" aria-hidden="true"
                                  style="font-size: 100px; color: var(--on-primary-container); opacity: 0.18;
                                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                                approval_delegation
                            </span>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Content Table ─── -->
                <div class="raised-card overflow-hidden">
                    <div class="card-header-row pb-3">
                        <div class="flex-grow-1">
                            <h3 class="card-title">Yêu cầu đề xuất tài liệu</h3>
                            <p class="card-subtitle">Lọc theo trạng thái và sắp xếp theo lượt vote quan tâm</p>
                        </div>
                    </div>

                    <!-- Search and Filters -->
                    <div class="px-4 py-3 bg-light border-bottom">
                        <form action="${pageContext.request.contextPath}/librarian/book-suggestions" method="GET" class="row g-2">
                            <div class="col-12 col-sm-6 col-md-5">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-white border-end-0">
                                        <span class="material-symbols-outlined" style="font-size: 18px;">search</span>
                                    </span>
                                    <input type="text" name="q" class="form-control border-start-0 ps-0" placeholder="Tìm theo tiêu đề, tác giả..." value="<c:out value="${q}" />" />
                                </div>
                            </div>
                            <div class="col-12 col-sm-4 col-md-4">
                                <select name="status" class="form-select form-select-sm">
                                    <option value="">-- Tất cả trạng thái --</option>
                                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ duyệt (pending)</option>
                                    <option value="acknowledged" ${status == 'acknowledged' ? 'selected' : ''}>Đã ghi nhận (acknowledged)</option>
                                    <option value="rejected" ${status == 'rejected' ? 'selected' : ''}>Bác bỏ (rejected)</option>
                                </select>
                            </div>
                            <div class="col-12 col-sm-2 col-md-3 d-grid">
                                <button type="submit" class="btn btn-sm btn-primary fw-semibold">Lọc kết quả</button>
                            </div>
                        </form>
                    </div>

                    <!-- Table List -->
                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${not empty suggestions}">
                                <table class="table table-lms align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 30%;">Thông tin đề xuất</th>
                                            <th style="width: 30%;">Lý do từ Giảng viên</th>
                                            <th style="width: 10%; text-align: center;">Số lượt vote</th>
                                            <th style="width: 15%;">Phản hồi của Thủ thư</th>
                                            <th style="width: 15%; text-align: right;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${suggestions}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark"><c:out value="${item.title}" /></div>
                                                    <div class="text-muted small">Tác giả: <c:out value="${item.author}" /></div>
                                                    <c:if test="${not empty item.isbn}">
                                                        <div class="text-muted small">ISBN: <c:out value="${item.isbn}" /></div>
                                                    </c:if>
                                                    <div class="text-muted mt-2" style="font-size: 11px;">
                                                        Giảng viên: <strong><c:out value="${item.createdByName}" /></strong>
                                                        <br>Gửi ngày: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="text-secondary small" style="white-space: pre-line;"><c:out value="${item.reason}" /></div>
                                                </td>
                                                <td style="text-align: center;">
                                                    <span class="fs-5 fw-bold text-primary"><c:out value="${item.voteCount}" /></span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.status == 'pending'}">
                                                            <span class="badge bg-warning text-dark px-2 py-1 mb-1">Chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'acknowledged'}">
                                                            <span class="badge bg-success text-white px-2 py-1 mb-1">Đã ghi nhận</span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'rejected'}">
                                                            <span class="badge bg-danger text-white px-2 py-1 mb-1">Bác bỏ</span>
                                                        </c:when>
                                                    </c:choose>
                                                    <c:if test="${not empty item.librarianNote}">
                                                        <div class="text-muted mt-1 small border-start ps-2" style="font-size: 11px;">
                                                            <c:out value="${item.librarianNote}" />
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty item.reviewedByName}">
                                                        <div class="text-muted small mt-1" style="font-size: 10px;">
                                                            Duyệt bởi: <c:out value="${item.reviewedByName}" />
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td style="text-align: right;">
                                                    <button type="button" class="btn btn-sm btn-outline-primary fw-bold"
                                                            data-bs-toggle="modal" data-bs-target="#statusModal"
                                                            onclick="openStatusModal('${item.suggestionId}', '${item.title}', '${item.status}', '<c:out value="${item.librarianNote != null ? item.librarianNote : ''}" />')">
                                                        Cập nhật trạng thái
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-muted">
                                    <span class="material-symbols-outlined" style="font-size: 48px;">inbox</span>
                                    <p class="mt-2 mb-0">Chưa có đề xuất sách nào</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="d-flex justify-content-center py-3 bg-light border-top">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/librarian/book-suggestions?page=${currentPage - 1}&q=<c:out value="${q}" />&status=${status}">Trước</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/librarian/book-suggestions?page=${i}&q=<c:out value="${q}" />&status=${status}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/librarian/book-suggestions?page=${currentPage + 1}&q=<c:out value="${q}" />&status=${status}">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <!-- ─── Modal Cập nhật Trạng thái ─── -->
    <div class="modal fade" id="statusModal" tabindex="-1" aria-labelledby="statusModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/librarian/book-suggestions" method="POST" id="statusForm">
                    <input type="hidden" name="action" value="updateStatus" />
                    <input type="hidden" name="suggestionId" id="modalSuggestionId" />
                    <input type="hidden" name="q_filter" value="<c:out value="${q}" />" />
                    <input type="hidden" name="status_filter" value="<c:out value="${status}" />" />
                    <input type="hidden" name="page_filter" value="${currentPage}" />

                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" id="statusModalLabel">Xét duyệt đề xuất sách</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Sách đề xuất</label>
                            <div class="p-2.5 bg-light rounded text-dark fw-semibold" id="modalBookTitle"></div>
                        </div>

                        <div class="mb-3">
                            <label for="modalStatus" class="form-label fw-semibold">Trạng thái quyết định <span class="text-danger">*</span></label>
                            <select name="status" id="modalStatus" class="form-select" required>
                                <option value="pending">Chờ duyệt (pending)</option>
                                <option value="acknowledged">Đã ghi nhận (acknowledged)</option>
                                <option value="rejected">Bác bỏ (rejected)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="modalLibrarianNote" class="form-label fw-semibold">Phản hồi của Thủ thư</label>
                            <textarea name="librarianNote" id="modalLibrarianNote" class="form-control" rows="3" maxlength="1000" placeholder="Nhập lý do bác bỏ hoặc kế hoạch mua sắm..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary fw-bold" id="modalSubmitBtn">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Script điều hướng Modal & chống double submit -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openStatusModal(id, title, status, note) {
            document.getElementById('modalSuggestionId').value = id;
            document.getElementById('modalBookTitle').innerText = title;
            document.getElementById('modalStatus').value = status;
            document.getElementById('modalLibrarianNote').value = note;
        }

        document.getElementById('statusForm').addEventListener('submit', function() {
            document.getElementById('modalSubmitBtn').disabled = true;
        });
    </script>
</body>
</html>
