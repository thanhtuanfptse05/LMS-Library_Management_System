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

                <!-- ─── Cảnh báo trùng tiêu đề ─── -->
                <c:if test="${not empty sessionScope.similarWarning}">
                    <div class="card border-warning mb-4 shadow-sm" style="border-left: 5px solid var(--warning);">
                        <div class="card-body">
                            <div class="d-flex align-items-start gap-3">
                                <span class="material-symbols-outlined text-warning" style="font-size: 32px;">warning</span>
                                <div class="flex-grow-1">
                                    <h5 class="card-title fw-bold text-warning-emphasis">Cảnh báo: Đề xuất có tiêu đề tương tự đã tồn tại</h5>
                                    <p class="card-text text-muted mb-3">
                                        Hệ thống phát hiện đã có một hoặc nhiều đề xuất tương tự với cuốn sách <strong>"${sessionScope.tempTitle}"</strong>. 
                                        Bạn có muốn tìm kiếm đề xuất sẵn có để vote (+1) hay vẫn tiếp tục tạo đề xuất mới?
                                    </p>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/lecturer/book-suggestions" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="create" />
                                            <input type="hidden" name="confirmSimilar" value="true" />
                                            <input type="hidden" name="title" value="<c:out value="${sessionScope.tempTitle}" />" />
                                            <input type="hidden" name="author" value="<c:out value="${sessionScope.tempAuthor}" />" />
                                            <input type="hidden" name="publisher" value="<c:out value="${sessionScope.tempPublisher}" />" />
                                            <input type="hidden" name="isbn" value="<c:out value="${sessionScope.tempIsbn}" />" />
                                            <input type="hidden" name="reason" value="<c:out value="${sessionScope.tempReason}" />" />
                                            <button type="submit" class="btn btn-warning btn-sm text-dark fw-bold">Vẫn gửi đề xuất mới</button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/lecturer/book-suggestions?q=${sessionScope.tempTitle}" class="btn btn-outline-secondary btn-sm">Tìm kiếm đề xuất trùng</a>
                                        <a href="${pageContext.request.contextPath}/lecturer/book-suggestions?action=cancelWarning" class="btn btn-link btn-sm text-muted">Hủy bỏ</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        // Xóa các biến cảnh báo sau khi render
                        session.removeAttribute("similarWarning");
                        session.removeAttribute("tempTitle");
                        session.removeAttribute("tempAuthor");
                        session.removeAttribute("tempPublisher");
                        session.removeAttribute("tempIsbn");
                        session.removeAttribute("tempReason");
                    %>
                </c:if>

                <!-- ─── Banner Header ─── -->
                <section class="welcome-banner mb-4">
                    <div class="row align-items-center g-0">
                        <div class="col-12 col-md-8">
                            <p class="text-on-surface-variant fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase;">Độc giả Giảng viên</p>
                            <h2 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-primary-container);">
                                Đề xuất sách thư viện
                            </h2>
                            <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                                Gửi yêu cầu mua sách mới cho môn học/nghiên cứu hoặc ủng hộ các đề xuất của giảng viên khác.
                            </p>
                        </div>
                        <div class="col-4 d-none d-md-flex justify-content-end align-items-center">
                            <span class="material-symbols-outlined" aria-hidden="true"
                                  style="font-size: 100px; color: var(--on-primary-container); opacity: 0.18;
                                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                                font_download
                            </span>
                        </div>
                    </div>
                </section>

                <div class="row g-4">
                    <!-- ─── Form Đề xuất (Cột Trái 1/3) ─── -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card p-4">
                            <h3 class="card-title mb-1">
                                <c:choose>
                                    <c:when test="${not empty editSuggestion}">Cập nhật đề xuất</c:when>
                                    <c:otherwise>Đề xuất sách mới</c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="card-subtitle mb-4">Nhập chi tiết tài liệu cần đề xuất bổ sung</p>

                            <form action="${pageContext.request.contextPath}/lecturer/book-suggestions" method="POST" id="suggestionForm">
                                <input type="hidden" name="action" value="${not empty editSuggestion ? 'update' : 'create'}" />
                                <c:if test="${not empty editSuggestion}">
                                    <input type="hidden" name="suggestionId" value="${editSuggestion.suggestionId}" />
                                </c:if>

                                <div class="mb-3">
                                    <label for="title" class="form-label fw-semibold">Tiêu đề sách <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="title" name="title" required maxlength="255"
                                           value="<c:out value="${not empty editSuggestion ? editSuggestion.title : param.q}" />" placeholder="Ví dụ: Clean Code" />
                                </div>

                                <div class="mb-3">
                                    <label for="author" class="form-label fw-semibold">Tác giả <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="author" name="author" required maxlength="255"
                                           value="<c:out value="${not empty editSuggestion ? editSuggestion.author : ''}" />" placeholder="Ví dụ: Robert C. Martin" />
                                </div>

                                <div class="mb-3">
                                    <label for="publisher" class="form-label fw-semibold">Nhà xuất bản</label>
                                    <input type="text" class="form-control" id="publisher" name="publisher" maxlength="255"
                                           value="<c:out value="${not empty editSuggestion ? editSuggestion.publisher : ''}" />" placeholder="Nhà xuất bản (tùy chọn)" />
                                </div>

                                <div class="mb-3">
                                    <label for="isbn" class="form-label fw-semibold">Mã ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" minlength="10" maxlength="13"
                                           value="<c:out value="${not empty editSuggestion ? editSuggestion.isbn : ''}" />" placeholder="10 hoặc 13 số (tùy chọn)" />
                                </div>

                                <div class="mb-3">
                                    <label for="reason" class="form-label fw-semibold">Lý do đề xuất <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="reason" name="reason" rows="4" required maxlength="1000"
                                              placeholder="Nêu rõ lý do cần bổ sung sách này (phục vụ môn học, nghiên cứu gì...)"><c:out value="${not empty editSuggestion ? editSuggestion.reason : ''}" /></textarea>
                                </div>

                                <div class="d-flex gap-2 pt-2">
                                    <button type="submit" class="btn btn-primary w-100 fw-bold" id="submitBtn">
                                        <c:choose>
                                            <c:when test="${not empty editSuggestion}">Cập nhật</c:when>
                                            <c:otherwise>Gửi đề xuất</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <c:if test="${not empty editSuggestion}">
                                        <a href="${pageContext.request.contextPath}/lecturer/book-suggestions" class="btn btn-outline-secondary w-50">Hủy</a>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- ─── Danh sách đề xuất (Cột Phải 2/3) ─── -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card overflow-hidden">
                            <!-- Header & Filter Row -->
                            <div class="card-header-row pb-3">
                                <div class="flex-grow-1">
                                    <h3 class="card-title">Tất cả đề xuất từ Giảng viên</h3>
                                    <p class="card-subtitle">Danh sách sắp xếp theo độ ưu tiên quan tâm của tập thể</p>
                                </div>
                            </div>
                            
                            <!-- Search & Filter Controls -->
                            <div class="px-4 py-3 bg-light border-bottom">
                                <form action="${pageContext.request.contextPath}/lecturer/book-suggestions" method="GET" class="row g-2">
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
                                        <button type="submit" class="btn btn-sm btn-secondary fw-semibold">Lọc kết quả</button>
                                    </div>
                                </form>
                            </div>

                            <!-- Table Content -->
                            <div class="table-responsive">
                                <c:choose>
                                    <c:when test="${not empty suggestions}">
                                        <table class="table table-lms align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th style="width: 35%;">Thông tin sách</th>
                                                    <th style="width: 25%;">Lý do & Ghi chú</th>
                                                    <th style="width: 15%; text-align: center;">Lượt vote</th>
                                                    <th style="width: 10%;">Trạng thái</th>
                                                    <th style="width: 15%; text-align: right;">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${suggestions}">
                                                    <tr>
                                                        <td>
                                                            <div class="fw-bold text-dark"><c:out value="${item.title}" /></div>
                                                            <div class="text-muted" style="font-size: 13px;">Tác giả: <c:out value="${item.author}" /></div>
                                                            <c:if test="${not empty item.isbn}">
                                                                <div class="text-muted" style="font-size: 12px;">ISBN: <c:out value="${item.isbn}" /></div>
                                                            </c:if>
                                                            <div class="text-muted" style="font-size: 11px; margin-top: 4px;">
                                                                Gửi bởi: <c:out value="${item.createdByName}" />
                                                                <br>Ngày: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 13px;">
                                                            <div class="text-secondary text-truncate-2" title="<c:out value="${item.reason}" />">
                                                                <strong>Lý do:</strong> <c:out value="${item.reason}" />
                                                            </div>
                                                            <c:if test="${not empty item.librarianNote}">
                                                                <div class="mt-2 p-2 bg-light border-start border-3 border-primary rounded" style="font-size: 12px;">
                                                                    <strong>Thủ thư ghi nhận:</strong> <c:out value="${item.librarianNote}" />
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <span class="fs-5 fw-bold text-primary"><c:out value="${item.voteCount}" /></span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.status == 'pending'}">
                                                                    <span class="badge bg-warning text-dark px-2.5 py-1">Chờ duyệt</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'acknowledged'}">
                                                                    <span class="badge bg-success text-white px-2.5 py-1">Đã ghi nhận</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'rejected'}">
                                                                    <span class="badge bg-danger text-white px-2.5 py-1">Bác bỏ</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td style="text-align: right;">
                                                            <div class="d-flex flex-column gap-1 align-items-end justify-content-end">
                                                                <!-- Nút Vote / Hủy Vote -->
                                                                <c:if test="${item.status == 'pending'}">
                                                                    <c:set var="hasVoted" value="false" />
                                                                    <c:forEach var="votedId" items="${userVotedIds}">
                                                                        <c:if test="${votedId == item.suggestionId}">
                                                                            <c:set var="hasVoted" value="true" />
                                                                        </c:if>
                                                                    </c:forEach>

                                                                    <form action="${pageContext.request.contextPath}/lecturer/book-suggestions" method="POST" class="d-inline voteForm">
                                                                        <input type="hidden" name="suggestionId" value="${item.suggestionId}" />
                                                                        <input type="hidden" name="action" value="${hasVoted ? 'unvote' : 'vote'}" />
                                                                        <input type="hidden" name="q_filter" value="<c:out value="${q}" />" />
                                                                        <input type="hidden" name="status_filter" value="<c:out value="${status}" />" />
                                                                        <input type="hidden" name="page_filter" value="${currentPage}" />
                                                                        
                                                                        <button type="submit" class="btn btn-sm ${hasVoted ? 'btn-outline-danger' : 'btn-outline-primary'} fw-bold" style="min-width: 80px;">
                                                                            <c:choose>
                                                                                <c:when test="${hasVoted}">Hủy vote</c:when>
                                                                                <c:otherwise>Tôi cần (+1)</c:otherwise>
                                                                            </c:choose>
                                                                        </button>
                                                                    </form>
                                                                </c:if>

                                                                <!-- Nút Sửa / Xóa (Nếu là của chính mình và chưa ai khác vote) -->
                                                                <c:if test="${item.createdBy == sessionScope.userId && item.status == 'pending' && item.voteCount == 1}">
                                                                    <div class="d-flex gap-1 mt-1">
                                                                        <a href="${pageContext.request.contextPath}/lecturer/book-suggestions?editId=${item.suggestionId}&q=<c:out value="${q}" />&status=${status}&page=${currentPage}" 
                                                                           class="btn btn-link btn-sm text-decoration-none p-0 text-secondary" style="font-size: 12px;">Sửa</a>
                                                                           
                                                                        <span class="text-muted" style="font-size: 12px;">|</span>
                                                                        
                                                                        <form action="${pageContext.request.contextPath}/lecturer/book-suggestions" method="POST" class="d-inline" onsubmit="return confirm('Bạn chắc chắn muốn xóa đề xuất sách này?');">
                                                                            <input type="hidden" name="suggestionId" value="${item.suggestionId}" />
                                                                            <input type="hidden" name="action" value="delete" />
                                                                            <input type="hidden" name="q_filter" value="<c:out value="${q}" />" />
                                                                            <input type="hidden" name="status_filter" value="<c:out value="${status}" />" />
                                                                            <input type="hidden" name="page_filter" value="${currentPage}" />
                                                                            <button type="submit" class="btn btn-link btn-sm text-decoration-none p-0 text-danger" style="font-size: 12px; border:none; background:none;">Xóa</button>
                                                                        </form>
                                                                    </div>
                                                                </c:if>
                                                            </div>
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
                                            <a class="page-link" href="${pageContext.request.contextPath}/lecturer/book-suggestions?page=${currentPage - 1}&q=<c:out value="${q}" />&status=${status}">Trước</a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/lecturer/book-suggestions?page=${i}&q=<c:out value="${q}" />&status=${status}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/lecturer/book-suggestions?page=${currentPage + 1}&q=<c:out value="${q}" />&status=${status}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>

            </div>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <!-- Script chống double submit -->
    <script>
        document.getElementById('suggestionForm').addEventListener('submit', function() {
            document.getElementById('submitBtn').disabled = true;
        });
        
        document.querySelectorAll('.voteForm').forEach(function(form) {
            form.addEventListener('submit', function() {
                var btn = form.querySelector('button[type="submit"]');
                if (btn) {
                    btn.disabled = true;
                }
            });
        });
    </script>
</body>
</html>
