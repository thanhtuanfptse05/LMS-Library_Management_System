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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard" class="text-decoration-none" style="color: var(--primary-color);">Bảng điều khiển</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Sách của tôi</li>
                </ol>
            </nav>

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="fw-bold mb-1" style="color: var(--bs-body-color);">Sách của tôi</h1>
                    <p class="text-secondary mb-0">Theo dõi thông tin mượn và đặt trước sách trực tuyến.</p>
                </div>
            </div>

            <!-- Flash Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show mb-4 rounded-3 border-0 shadow-sm d-flex align-items-center" role="alert" style="background-color: rgba(16, 185, 129, 0.15); color: #0f766e;">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div>
                        <c:out value="${sessionScope.successMessage}"/>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-3 border-0 shadow-sm d-flex align-items-center" role="alert" style="background-color: rgba(239, 68, 68, 0.15); color: #991b1b;">
                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                    <div>
                        <c:out value="${sessionScope.errorMessage}"/>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs border-bottom mb-4" id="borrowTabs" role="tablist" style="border-color: var(--surface-container-high) !important;">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active fw-bold px-4 py-3" id="borrowed-tab" data-bs-toggle="tab" data-bs-target="#borrowed" type="button" role="tab" aria-controls="borrowed" aria-selected="true" style="font-size: 15px;">
                        <i class="bi bi-book-half me-2"></i>Sách đang mượn (${borrows.size()})
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link fw-bold px-4 py-3" id="reserved-tab" data-bs-toggle="tab" data-bs-target="#reserved" type="button" role="tab" aria-controls="reserved" aria-selected="false" style="font-size: 15px;">
                        <i class="bi bi-clock-history me-2"></i>Sách đang đặt trước (${reservations.size()})
                    </button>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="borrowTabsContent">

                <!-- 1. Tab Sách đang mượn -->
                <div class="tab-pane fade show active" id="borrowed" role="tabpanel" aria-labelledby="borrowed-tab">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2 mb-3 p-3 bg-white rounded-3 shadow-sm border">
                        <div class="fw-semibold text-secondary" style="font-size: 14px;">
                            <i class="bi bi-funnel me-1"></i> Sắp xếp danh sách mượn
                        </div>
                        <form method="GET" action="${pageContext.request.contextPath}/student/my-borrowings" class="d-flex gap-2 align-items-center flex-wrap">
                            <input type="hidden" name="resSortBy" value="${resSortBy}">
                            <input type="hidden" name="resSortOrder" value="${resSortOrder}">
                            <select name="borrowSortBy" class="form-select form-select-sm" style="width: 180px;" onchange="this.form.submit()">
                                <option value="startDate" ${borrowSortBy == 'startDate' ? 'selected' : ''}>Ngày mượn sách</option>
                                <option value="endDate" ${borrowSortBy == 'endDate' ? 'selected' : ''}>Hạn trả sách</option>
                                <option value="title" ${borrowSortBy == 'title' ? 'selected' : ''}>Tên sách</option>
                                <option value="id" ${borrowSortBy == 'id' ? 'selected' : ''}>Mã phiếu mượn</option>
                            </select>
                            <select name="borrowSortOrder" class="form-select form-select-sm" style="width: 130px;" onchange="this.form.submit()">
                                <option value="DESC" ${borrowSortOrder == 'DESC' ? 'selected' : ''}>Giảm dần (↓)</option>
                                <option value="ASC" ${borrowSortOrder == 'ASC' ? 'selected' : ''}>Tăng dần (↑)</option>
                            </select>
                        </form>
                    </div>
                    <div class="card border-0 rounded-3 shadow-sm overflow-hidden" style="background-color: var(--surface-lowest); border: 1px solid var(--outline-variant) !important;">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty borrows}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-journal-x display-3 text-muted mb-3 d-block"></i>
                                        <h5 class="fw-bold text-secondary">Bạn hiện không mượn cuốn sách nào</h5>
                                        <p class="text-secondary-custom mb-4">Hãy tra cứu mục lục và đăng ký mượn/đặt trước cuốn sách bạn yêu thích.</p>
                                        <a href="${pageContext.request.contextPath}/book-search" class="btn btn-primary-custom fw-bold px-4">Tìm kiếm sách</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size: 14px;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="py-3 px-4" style="font-weight: 600;">Thông tin tài liệu</th>
                                                    <th class="py-3" style="font-weight: 600;">Ngày mượn</th>
                                                    <th class="py-3" style="font-weight: 600;">Hạn trả</th>
                                                    <th class="py-3" style="font-weight: 600; width: 220px;">Thời hạn mượn</th>
                                                    <th class="py-3" style="font-weight: 600;">Số lần gia hạn</th>
                                                    <th class="py-3 text-end px-4" style="font-weight: 600; width: 140px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="br" items="${borrows}">
                                                    <tr>
                                                        <td class="py-3 px-4">
                                                            <div class="d-flex align-items-center">
                                                                <div class="book-cover-mini me-3 rounded bg-light border d-flex align-items-center justify-content-center" style="width: 45px; height: 60px; overflow:hidden;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty br.book.imagePath}">
                                                                            <c:choose>
                                                                                <c:when test="${fn:startsWith(br.book.imagePath, 'http://') or fn:startsWith(br.book.imagePath, 'https://')}">
                                                                                    <img src="${br.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}/book-images/${br.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="bi bi-book text-muted"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div>
                                                                    <a href="${pageContext.request.contextPath}/book-detail?id=${br.bookId}" class="fw-bold text-decoration-none text-dark d-block mb-1"><c:out value="${br.book.title}"/></a>
                                                                    <span class="text-muted d-block" style="font-size:12px;">Mã vạch: <strong><c:out value="${br.bookCopy.barcode}"/></strong></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="py-3">
                                                            <fmt:formatDate value="${br.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </td>
                                                        <td class="py-3">
                                                            <span class="${br.status eq 'overdue' or br.percentPassed >= 100 ? 'text-danger fw-bold' : ''}">
                                                                <fmt:formatDate value="${br.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </span>
                                                            <c:if test="${br.status eq 'overdue' or br.percentPassed >= 100}">
                                                                <span class="badge bg-danger ms-1" style="font-size: 10px;">Quá hạn</span>
                                                            </c:if>
                                                        </td>
                                                        <td class="py-3">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="progress flex-grow-1" style="height: 6px; border-radius: 3px; background-color: var(--surface-container-high, #e2e8f0);">
                                                                    <div class="progress-bar ${br.barColorClass}" role="progressbar" style="width: ${br.percentPassedInt}%" aria-valuenow="${br.percentPassedInt}" aria-valuemin="0" aria-valuemax="100"></div>
                                                                </div>
                                                                <span class="text-muted" style="font-size: 12px;">${br.percentPassedInt}%</span>
                                                            </div>
                                                        </td>
                                                        <td class="py-3 text-center">
                                                            <c:out value="${br.extensionCount}"/>
                                                        </td>
                                                        <td class="py-3 text-end px-4">
                                                            <form action="${pageContext.request.contextPath}/student/renew" method="post" class="d-inline">
                                                                <input type="hidden" name="borrowRecordId" value="${br.borrowRecordId}">
                                                                <button type="submit" class="btn btn-outline-primary btn-sm fw-bold px-3 rounded-2" ${br.extensionCount >= 3 ? 'disabled' : ''}>
                                                                    <i class="bi bi-arrow-repeat me-1"></i> Gia hạn
                                                                </button>
                                                            </form>
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
                </div>

                <!-- 2. Tab Sách đang đặt trước -->
                <div class="tab-pane fade" id="reserved" role="tabpanel" aria-labelledby="reserved-tab">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2 mb-3 p-3 bg-white rounded-3 shadow-sm border">
                        <div class="fw-semibold text-secondary" style="font-size: 14px;">
                            <i class="bi bi-funnel me-1"></i> Sắp xếp hàng chờ đặt trước
                        </div>
                        <form method="GET" action="${pageContext.request.contextPath}/student/my-borrowings" class="d-flex gap-2 align-items-center flex-wrap">
                            <input type="hidden" name="borrowSortBy" value="${borrowSortBy}">
                            <input type="hidden" name="borrowSortOrder" value="${borrowSortOrder}">
                            <select name="resSortBy" class="form-select form-select-sm" style="width: 180px;" onchange="this.form.submit()">
                                <option value="queuePosition" ${resSortBy == 'queuePosition' ? 'selected' : ''}>Vị trí hàng chờ</option>
                                <option value="startDate" ${resSortBy == 'startDate' ? 'selected' : ''}>Ngày đặt sách</option>
                                <option value="endDate" ${resSortBy == 'endDate' ? 'selected' : ''}>Hạn giữ sách</option>
                                <option value="title" ${resSortBy == 'title' ? 'selected' : ''}>Tên sách</option>
                            </select>
                            <select name="resSortOrder" class="form-select form-select-sm" style="width: 130px;" onchange="this.form.submit()">
                                <option value="ASC" ${resSortOrder == 'ASC' ? 'selected' : ''}>Tăng dần (↑)</option>
                                <option value="DESC" ${resSortOrder == 'DESC' ? 'selected' : ''}>Giảm dần (↓)</option>
                            </select>
                        </form>
                    </div>
                    <div class="card border-0 rounded-3 shadow-sm overflow-hidden" style="background-color: var(--surface-lowest); border: 1px solid var(--outline-variant) !important;">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty reservations}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-journal-x display-3 text-muted mb-3 d-block"></i>
                                        <h5 class="fw-bold text-secondary">Bạn hiện không đặt trước cuốn sách nào</h5>
                                        <p class="text-secondary-custom mb-4">Hãy tra cứu mục lục và đặt trước cuốn sách bạn yêu thích.</p>
                                        <a href="${pageContext.request.contextPath}/book-search" class="btn btn-primary-custom fw-bold px-4">Tìm kiếm sách</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size: 14px;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="py-3 px-4" style="font-weight: 600;">Thông tin tài liệu</th>
                                                    <th class="py-3" style="font-weight: 600;">Ngày yêu cầu</th>
                                                    <th class="py-3" style="font-weight: 600;">Trạng thái đặt</th>
                                                    <th class="py-3" style="font-weight: 600;">Hạn giữ sách</th>
                                                    <th class="py-3 text-end px-4" style="font-weight: 600; width: 140px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="res" items="${reservations}">
                                                    <tr>
                                                        <td class="py-3 px-4">
                                                            <div class="d-flex align-items-center">
                                                                <div class="book-cover-mini me-3 rounded bg-light border d-flex align-items-center justify-content-center" style="width: 45px; height: 60px; overflow:hidden;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty res.book.imagePath}">
                                                                            <c:choose>
                                                                                <c:when test="${fn:startsWith(res.book.imagePath, 'http://') or fn:startsWith(res.book.imagePath, 'https://')}">
                                                                                    <img src="${res.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}/book-images/${res.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="bi bi-book text-muted"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div>
                                                                    <a href="${pageContext.request.contextPath}/book-detail?id=${res.bookId}" class="fw-bold text-decoration-none text-dark d-block mb-1"><c:out value="${res.book.title}"/></a>
                                                                    <c:if test="${not empty res.bookCopy}">
                                                                        <span class="text-muted d-block" style="font-size:12px;">Mã bản sao: <strong><c:out value="${res.bookCopy.barcode}"/></strong></span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="py-3">
                                                            <fmt:formatDate value="${res.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </td>
                                                        <td class="py-3">
                                                            <c:choose>
                                                                <c:when test="${res.queuePosition == 0}">
                                                                    <span class="badge rounded-pill bg-success-subtle text-success py-2 px-3 fw-bold">
                                                                        <i class="bi bi-check-circle me-1"></i>Sẵn sàng nhận sách
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge rounded-pill bg-warning-subtle text-warning py-2 px-3 fw-bold" style="color: #d97706 !important; background-color: rgba(251, 191, 36, 0.15) !important;">
                                                                        <i class="bi bi-clock me-1"></i>Đang chờ (Vị trí #${res.queuePosition})
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="py-3">
                                                            <c:choose>
                                                                 <c:when test="${res.queuePosition == 0 && not empty res.endDate}">
                                                                     <div class="d-flex flex-column">
                                                                         <span class="text-danger fw-bold">
                                                                             <fmt:formatDate value="${res.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                                         </span>
                                                                         <small class="text-danger-custom fw-semibold countdown-timer" data-endtime="${res.endDate.time}" style="font-size: 11px;">
                                                                             Đang tính thời gian...
                                                                         </small>
                                                                     </div>
                                                                 </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="py-3 text-end px-4">
                                                            <form action="${pageContext.request.contextPath}/student/cancel-reservation" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt trước cuốn sách này?');">
                                                                <input type="hidden" name="reservationId" value="${res.reservationId}">
                                                                <button type="submit" class="btn btn-outline-danger btn-sm fw-bold px-3 rounded-2">
                                                                    <i class="bi bi-trash me-1"></i> Hủy đặt
                                                                </button>
                                                            </form>
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
                </div>

            </div><!-- /.tab-content -->

        </div><!-- /.container-xl -->

        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div><!-- /.d-flex.main-wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        if(window.location.hash) {
            var triggerEl = document.querySelector('button[data-bs-target="' + window.location.hash + '"]');
            if (triggerEl) {
                var tab = new bootstrap.Tab(triggerEl);
                tab.show();
            }
        }

        // Script tự động đếm ngược và tự động Reload trang khi hết hạn giữ sách
        var timers = document.querySelectorAll('.countdown-timer');
        if (timers.length > 0) {
            setInterval(function() {
                var now = new Date().getTime();
                timers.forEach(function(el) {
                    var endTime = parseInt(el.getAttribute('data-endtime'));
                    var distance = endTime - now;

                    if (distance <= 0) {
                        el.innerHTML = '<span class="badge bg-danger">Hết hạn - Đang cập nhật...</span>';
                        // Tự động reload trang sau 1.5 giây để kích hoạt Lazy Sweep và cập nhật lại giao diện
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                        var seconds = Math.floor((distance % (1000 * 60)) / 1000);
                        el.innerText = 'Còn lại: ' + hours + 'h ' + minutes + 'm ' + seconds + 's';
                    }
                });
            }, 1000);
        }
    });
</script>
</body>
</html>
