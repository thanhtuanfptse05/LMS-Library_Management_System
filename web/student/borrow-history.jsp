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

    <!-- ════════════════ MAIN CONTENT ════════════════ -->
    <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">
        
        <jsp:include page="fragments/_header.jsp" />

        <div class="container-xl px-4 py-5">

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb" style="font-size: 14px;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard" class="text-decoration-none" style="color: var(--primary);">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Lịch sử mượn trả</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="fw-bold mb-1" style="color: var(--on-surface);">Lịch sử mượn &amp; trả sách</h1>
                    <p class="mb-0" style="color: var(--on-surface-variant);">Xem lại toàn bộ thông tin và trạng thái các cuốn sách bạn đã và đang mượn tại thư viện.</p>
                </div>
            </div>

            <!-- Error Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="lms-alert lms-alert-error mb-4">
                    <span class="material-symbols-outlined">error</span>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <!-- ═══ Bảng lịch sử mượn sách ═══ -->
            <div class="raised-card overflow-hidden fade-in-up">
                <div class="card-header-row">
                    <div>
                        <h2 class="card-title">
                            <span class="material-symbols-outlined me-2" style="font-size: 20px; color: var(--primary); vertical-align: middle;">history</span>
                            Danh sách giao dịch mượn trả
                        </h2>
                        <p class="card-subtitle">Hiển thị tất cả các bản ghi mượn từ trước tới nay.</p>
                    </div>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty history}">
                            <!-- Empty State -->
                            <div class="text-center py-5">
                                <span class="material-symbols-outlined d-block mb-3" style="font-size: 64px; color: var(--outline-variant);">history_edu</span>
                                <h5 class="fw-bold" style="color: var(--on-surface-variant);">Không có lịch sử mượn sách</h5>
                                <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-4">Bạn chưa mượn cuốn sách nào từ hệ thống thư viện.</p>
                                <a href="${pageContext.request.contextPath}/book-search" class="btn btn-primary-custom fw-bold px-4 rounded-3 text-decoration-none">
                                    <span class="material-symbols-outlined me-1" style="font-size: 18px; vertical-align: middle;">search</span>
                                    Tìm kiếm sách ngay
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table-lms">
                                    <thead>
                                        <tr>
                                            <th style="padding-left: 20px; width: 100px;">Mã mượn</th>
                                            <th>Thông tin tài liệu</th>
                                            <th>Ngày mượn</th>
                                            <th>Hạn trả</th>
                                            <th>Ngày trả thực tế</th>
                                            <th class="text-center">Số lần gia hạn</th>
                                            <th class="text-center" style="padding-right: 20px; width: 150px;">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="br" items="${history}">
                                            <tr>
                                                <td style="padding-left: 20px;">
                                                    <span class="fw-bold" style="color: var(--on-surface);">#${br.borrowRecordId}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="book-cover-mini me-3 rounded bg-light border d-flex align-items-center justify-content-center" style="width: 40px; height: 55px; overflow:hidden; flex-shrink: 0;">
                                                            <c:choose>
                                                                <c:when test="${not empty br.book.imagePath}">
                                                                    <c:choose>
                                                                        <c:when test="${fn:startsWith(br.book.imagePath, 'http://') or fn:startsWith(br.book.imagePath, 'https://')}">
                                                                            <img src="${br.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/book-images/${br.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-book text-muted"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/book-detail?id=${br.bookId}" class="fw-bold text-decoration-none text-dark d-block mb-1" style="font-size: 13.5px;"><c:out value="${br.book.title}"/></a>
                                                            <span class="text-muted d-block" style="font-size:11px;">Mã vạch: <strong><c:out value="${br.bookCopy.barcode}"/></strong></span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${br.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${br.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty br.returnedAt}">
                                                            <fmt:formatDate value="${br.returnedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-warning fw-semibold">— Đang giữ —</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:out value="${br.extensionCount}"/>
                                                </td>
                                                <td class="text-center" style="padding-right: 20px;">
                                                    <c:choose>
                                                        <c:when test="${br.status == 'borrowed'}">
                                                            <span class="badge-pill badge-warning">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">bookmark</span>
                                                                Đang mượn
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${br.status == 'returned'}">
                                                            <span class="badge-pill badge-success">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">check_circle</span>
                                                                Đã trả
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${br.status == 'damaged'}">
                                                            <span class="badge-pill badge-error">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">broken_image</span>
                                                                Làm hỏng
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${br.status == 'lost'}">
                                                            <span class="badge-pill badge-error">
                                                                <span class="material-symbols-outlined" style="font-size: 13px;">cancel</span>
                                                                Làm mất
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-pill badge-neutral">
                                                                <c:out value="${br.status}"/>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><!-- /.container-xl -->

        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div><!-- /.d-flex.main-wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Micro-interaction: Hover effect on rows
    document.querySelectorAll('.table-lms tbody tr').forEach(function(row) {
        row.addEventListener('mouseenter', function() {
            this.style.cursor = 'default';
        });
    });
</script>
</body>
</html>
