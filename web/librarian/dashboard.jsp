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
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

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

                <!-- ─── Section Header ─── -->
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">Lưu thông hôm nay</h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">sensors</span>
                            Tổng quan hoạt động quầy theo thời gian thực
                        </p>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/librarian/book-overview.jsp"
                           class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 16px;">auto_stories</span> Quản lý sách
                        </a>
                        <a href="${pageContext.request.contextPath}/librarian/catalog.jsp"
                           class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 16px;">add</span> Mượn sách
                        </a>
                    </div>
                </div>

                <!-- ─── KPI Stats Grid ─── -->
                <div class="row g-3 mb-4">
                    <!-- Issued Today -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                        <div class="stat-card h-100" style="--card-accent: var(--primary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                </div>
                                <span class="badge-pill badge-success">+<c:out value="${issuedToday != null ? issuedToday : '0'}" /> hôm nay</span>
                            </div>
                            <p class="stat-label">Sách đã mượn</p>
                            <p class="stat-value"><c:out value="${issuedToday != null ? issuedToday : '0'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 70%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Returned Today -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                        <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--tertiary);">assignment_return</span>
                                </div>
                                <span class="badge-pill badge-success">+<c:out value="${returnedToday != null ? returnedToday : '0'}" /> hôm nay</span>
                            </div>
                            <p class="stat-label">Sách đã trả</p>
                            <p class="stat-value"><c:out value="${returnedToday != null ? returnedToday : '0'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 50%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Overdue -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                        <div class="stat-card h-100" style="--card-accent: var(--error);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--error);">event_busy</span>
                                </div>
                                <span class="badge-pill badge-error">Quá hạn</span>
                            </div>
                            <p class="stat-label">Khoản mượn quá hạn</p>
                            <p class="stat-value"><c:out value="${overdueCount != null ? overdueCount : '0'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 30%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Active Reservations -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                        <div class="stat-card h-100" style="--card-accent: var(--warning);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--warning);">bookmark</span>
                                </div>
                                <span class="badge-pill badge-warning">Đang chờ</span>
                            </div>
                            <p class="stat-label">Đặt trước chờ duyệt</p>
                            <p class="stat-value"><c:out value="${pendingReservations != null ? pendingReservations : '0'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 60%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Active Loans + Quick Issue Form -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Khoản mượn hoạt động</h3>
                                    <p class="card-subtitle">Sách đang được mượn</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">filter_list</span> Bộ lọc
                                    </button>
                                    <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Mượn mới
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thành viên</th>
                                            <th>Tiêu đề sách</th>
                                            <th>Ngày mượn</th>
                                            <th>Hạn trả</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty activeLoans}">
                                                <c:forEach var="loan" items="${activeLoans}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">
                                                                    <c:out value="${fn:toUpperCase(fn:substring(loan.memberName, 0, 2))}" />
                                                                </div>
                                                                <div>
                                                                    <span style="font-size: 13px; font-weight: 600;"><c:out value="${loan.memberName}" /></span>
                                                                    <div class="text-muted" style="font-size: 11px;"><c:out value="${loan.memberCode}" /></div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 13px;"><c:out value="${loan.bookTitle}" /></td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td style="font-size: 13px; <c:if test='${loan.endDate.time < now.time}'>color: var(--error); font-weight: bold;</c:if>">
                                                            <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${loan.endDate.time < now.time}">
                                                                    <span class="badge-pill badge-error">Quá hạn</span>
                                                                </c:when>
                                                                <c:when test="${(loan.endDate.time - now.time) < 3L * 24 * 60 * 60 * 1000}">
                                                                    <span class="badge-pill badge-warning">Sắp đến hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-pill badge-info">Hoạt động</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${loan.memberCode}" 
                                                               class="btn-icon text-decoration-none" title="Trả sách">
                                                                <span class="material-symbols-outlined">assignment_return</span>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="6" class="text-center text-muted py-4">
                                                        <span class="material-symbols-outlined d-block fs-2 mb-2">inbox</span>
                                                        Không có khoản mượn nào đang hoạt động.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-3 text-center" style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                                <a href="${pageContext.request.contextPath}/librarian/desk-dashboard" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xử lý lưu thông tại quầy
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- Quick Reader Lookup Form -->
                        <form action="${pageContext.request.contextPath}/librarian/desk-dashboard" method="get" class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-4">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">search</span>
                                </div>
                                <div>
                                    <h3 class="card-title mb-0">Tra cứu quầy lưu thông nhanh</h3>
                                    <p class="card-subtitle mb-0">Nhập mã độc giả để bắt đầu mượn/trả sách hoặc thanh toán</p>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-12 col-md-10">
                                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.08em;">
                                        Mã định danh độc giả (MSSV / MSGV)
                                    </label>
                                    <input class="form-control rounded-3" style="border: 1.5px solid var(--outline-variant);"
                                           type="text" name="memberCode" placeholder="Nhập mã sinh viên hoặc giảng viên..." required />
                                </div>
                                <div class="col-12 col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">Tra cứu</button>
                                </div>
                            </div>
                        </form>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Pending Reservations + Fine Alerts -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Pending Reservations -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Chờ duyệt Đặt trước</h3>
                                <span class="badge-pill badge-primary">
                                    <c:out value="${pendingReservations != null ? pendingReservations : '0'}" /> Đang chờ
                                </span>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2" style="max-height: 400px; overflow-y: auto;">
                                <c:choose>
                                    <c:when test="${not empty pendingReservationsList}">
                                        <c:forEach var="res" items="${pendingReservationsList}">
                                            <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                                <div class="d-flex justify-content-between align-items-start mb-1">
                                                    <span class="fw-bold" style="font-size: 13px;"><c:out value="${res.memberName}" /></span>
                                                    <div class="text-muted" style="font-size: 11px;"><c:out value="${res.memberCode}" /></div>
                                                </div>
                                                <p class="text-on-surface-variant mb-2" style="font-size: 12px; font-weight: 600;"><c:out value="${res.bookTitle}" /></p>
                                                <div class="d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${res.memberCode}" 
                                                       class="btn btn-sm btn-primary-custom rounded-2 fw-bold flex-fill text-center text-decoration-none" style="font-size: 12px; line-height: 1.8;">
                                                        Xác nhận
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/librarian/dashboard" method="post" class="flex-fill mb-0" onsubmit="return confirm('Bạn có chắc chắn muốn hủy yêu cầu đặt trước này?');">
                                                        <input type="hidden" name="action" value="cancelReservation" />
                                                        <input type="hidden" name="reservationId" value="${res.reservationId}" />
                                                        <button type="submit" class="btn btn-sm btn-secondary-custom rounded-2 fw-bold w-100" style="font-size: 12px;">
                                                            Từ chối
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted py-4">
                                            Không có đơn đặt trước nào đang chờ.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-3 text-center" style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-low);">
                                <a href="${pageContext.request.contextPath}/librarian/desk-dashboard" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xử lý tại quầy
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- Today's Fine Alerts -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title mb-0">Thu tiền phạt</h3>
                                    <p class="card-subtitle mb-0">Các khoản phạt chưa thanh toán</p>
                                </div>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2" style="max-height: 400px; overflow-y: auto;">
                                <c:choose>
                                    <c:when test="${not empty unpaidFinesList}">
                                        <c:forEach var="fine" items="${unpaidFinesList}">
                                            <div class="d-flex justify-content-between align-items-center p-3 rounded-3"
                                                 style="background: linear-gradient(135deg, rgba(186,26,26,0.05) 0%, rgba(186,26,26,0.02) 100%); border: 1px solid rgba(186,26,26,0.15);">
                                                <div>
                                                    <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${fine.memberName}" /></p>
                                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;"><c:out value="${fine.memberCode}" /></p>
                                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px; margin-top: 4px;"><c:out value="${fine.reason}" /></p>
                                                </div>
                                                <div class="text-end">
                                                    <p class="mb-1" style="font-size: 14px; font-weight: 700; color: var(--error);">
                                                        <fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                                    </p>
                                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${fine.memberCode}" 
                                                       class="btn btn-sm btn-danger rounded-2 fw-bold px-3 text-decoration-none"
                                                       style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none; display: inline-block;">
                                                        Thu
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted py-4">
                                            Không có khoản phạt chưa thanh toán nào.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
