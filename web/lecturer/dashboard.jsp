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

                <!-- ─── Welcome Banner ─── -->
                <section class="welcome-banner mb-4">
                    <div class="row align-items-center g-0">
                        <div class="col-12 col-md-8">
                            <p class="text-on-surface-variant fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase;">Thư viện Đại học LMS</p>
                            <h2 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-primary-container);">
                                Chào mừng trở lại, <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Giảng viên'}" />!
                            </h2>
                            <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                                Quản lý danh sách tài liệu môn học, hoạt động mượn sách và tài liệu nghiên cứu của bạn.
                            </p>
                        </div>
                        <div class="col-4 d-none d-md-flex justify-content-end align-items-center">
                            <span class="material-symbols-outlined" aria-hidden="true"
                                  style="font-size: 100px; color: var(--on-primary-container); opacity: 0.18;
                                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                                           <!-- ─── Stats Cards ─── -->
                <section class="mb-4">
                    <div class="row g-3">
                        <!-- Active Loans -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                            <a href="${pageContext.request.contextPath}/lecturer/my-borrowings" class="text-decoration-none text-reset d-block h-100">
                                <div class="stat-card h-100" style="--card-accent: var(--primary);">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                            <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                        </div>
                                        <span class="badge-pill badge-info">Đang mượn</span>
                                    </div>
                                    <p class="stat-label">Sách đang mượn</p>
                                    <p class="stat-value"><c:out value="${activeLoansCount != null ? activeLoansCount : '0'}" /></p>
                                    <p class="text-on-surface-variant mb-1" style="font-size: 12px;">trong số 10 tối đa</p>
                                    <div class="mini-progress">
                                        <div class="mini-progress-bar" style="width: ${activeLoansCount != null ? (activeLoansCount * 10 > 100 ? 100 : activeLoansCount * 10) : 0}%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <!-- Due Soon -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                            <div class="stat-card h-100" style="--card-accent: var(--warning);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--warning);">running_with_errors</span>
                                    </div>
                                    <span class="badge-pill badge-warning">Sắp đến hạn</span>
                                </div>
                                <p class="stat-label">Sách sắp đến hạn</p>
                                <p class="stat-value"><c:out value="${dueSoonCount != null ? dueSoonCount : '0'}" /></p>
                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Trong 3 ngày tới</p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: ${dueSoonCount != null ? (dueSoonCount * 25 > 100 ? 100 : dueSoonCount * 25) : 0}%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Reservations -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                            <a href="${pageContext.request.contextPath}/lecturer/my-borrowings" class="text-decoration-none text-reset d-block h-100">
                                <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                            <span class="material-symbols-outlined" style="color: var(--tertiary);">event_available</span>
                                        </div>
                                        <span class="badge-pill badge-success">Đặt trước</span>
                                    </div>
                                    <p class="stat-label">Yêu cầu đặt sách</p>
                                    <p class="stat-value"><c:out value="${reservedCount != null ? reservedCount : '0'}" /></p>
                                    <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Đang hoạt động</p>
                                    <div class="mini-progress">
                                        <div class="mini-progress-bar" style="width: ${reservedCount != null ? (reservedCount * 25 > 100 ? 100 : reservedCount * 25) : 0}%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <!-- Outstanding Fines -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                            <a href="${pageContext.request.contextPath}/lecturer/fines" class="text-decoration-none text-reset d-block h-100">
                                <div class="stat-card h-100" style="--card-accent: ${not empty totalFines and totalFines gt 0 ? 'var(--warning)' : 'var(--success)'};">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon" style="background: ${not empty totalFines and totalFines gt 0 ? 'linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%)' : 'linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%)'};">
                                            <span class="material-symbols-outlined" style="color: ${not empty totalFines and totalFines gt 0 ? 'var(--warning)' : 'var(--success)'};">payments</span>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty totalFines and totalFines gt 0}">
                                                <span class="badge-pill badge-warning">Cần nộp</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-pill badge-success">Sạch</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="stat-label">Tiền phạt chưa đóng</p>
                                    <p class="stat-value">
                                        <c:choose>
                                            <c:when test="${not empty totalFines}">
                                                <fmt:formatNumber value="${totalFines}" type="number" maxFractionDigits="0"/> VNĐ
                                            </c:when>
                                            <c:otherwise>0 VNĐ</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p style="font-size: 12px; color: ${not empty totalFines and totalFines gt 0 ? 'var(--warning)' : 'var(--success)'}; margin: 0; font-weight: 600;">
                                        <c:choose>
                                            <c:when test="${not empty totalFines and totalFines gt 0}">Bạn có khoản phạt chưa đóng</c:when>
                                            <c:otherwise>Tài khoản ở trạng thái tốt</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Active Loans + My Reservations -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row p-4 pb-3" style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="card-title text-dark fw-bold mb-1">Sách đang mượn</h3>
                                    <p class="card-subtitle text-muted mb-0">Danh sách các đầu sách bạn đang mượn từ thư viện</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/lecturer/borrow-history" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem Lịch sử <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-start">
                                    <thead class="bg-surface-container-low">
                                        <tr>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold" style="font-size: 11px;">Sách</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold" style="font-size: 11px;">Ngày mượn</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold" style="font-size: 11px;">Hạn trả</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold text-center" style="font-size: 11px;">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty activeLoans}">
                                                <c:forEach var="loan" items="${activeLoans}">
                                                    <tr>
                                                        <td class="px-4 py-3">
                                                            <div class="d-flex align-items-center gap-3">
                                                                <div class="overflow-hidden rounded flex-shrink-0" style="width: 32px; height: 40px; background: var(--surface-container-high);">
                                                                    <img alt="" class="w-100 h-100" style="object-fit: cover;"
                                                                         src="${not empty loan.book.imagePath ? loan.book.imagePath : ''}"
                                                                         onerror="this.style.display='none'" />
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0 text-dark" style="font-size: 13px;"><c:out value="${loan.book.title}" /></p>
                                                                    <p class="text-muted mb-0" style="font-size: 11px;"><c:out value="${loan.book.author}" /> &bull; ISBN: <c:out value="${loan.book.isbn}" /></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="px-4 py-3 text-on-surface-variant" style="font-size: 13px;">
                                                            <fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td class="px-4 py-3" style="font-size: 13px;">
                                                            <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td class="px-4 py-3 text-center">
                                                            <c:choose>
                                                                <c:when test="${loan.status eq 'overdue'}">
                                                                    <span class="badge-pill badge-warning">Quá hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-pill badge-info">Đang mượn</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="px-4 py-5 text-center text-muted">
                                                        <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px;">menu_book</span>
                                                        Hiện tại bạn không mượn cuốn sách nào.
                                                        <div class="mt-3">
                                                            <a href="${pageContext.request.contextPath}/book-search" class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3">
                                                                Tìm kiếm sách
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Active Reservations Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row p-4 pb-3" style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="card-title text-dark fw-bold mb-1">Yêu cầu đặt trước</h3>
                                    <p class="card-subtitle text-muted mb-0">Danh sách các cuốn sách bạn đã đăng ký đặt trước</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/lecturer/my-borrowings" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem Chi tiết <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-start">
                                    <thead class="bg-surface-container-low">
                                        <tr>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold" style="font-size: 11px;">Sách</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold" style="font-size: 11px;">Ngày đăng ký</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold text-center" style="font-size: 11px;">Vị trí chờ</th>
                                            <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold text-center" style="font-size: 11px;">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty activeReservations}">
                                                <c:forEach var="res" items="${activeReservations}">
                                                    <tr>
                                                        <td class="px-4 py-3">
                                                            <div class="d-flex align-items-center gap-3">
                                                                <div class="overflow-hidden rounded flex-shrink-0" style="width: 32px; height: 40px; background: var(--surface-container-high);">
                                                                    <img alt="" class="w-100 h-100" style="object-fit: cover;"
                                                                         src="${not empty res.book.imagePath ? res.book.imagePath : ''}"
                                                                         onerror="this.style.display='none'" />
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0 text-dark" style="font-size: 13px;"><c:out value="${res.book.title}" /></p>
                                                                    <p class="text-muted mb-0" style="font-size: 11px;"><c:out value="${res.book.author}" /></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="px-4 py-3 text-on-surface-variant" style="font-size: 13px;">
                                                            <fmt:formatDate value="${res.startDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td class="px-4 py-3 text-center fw-bold" style="font-size: 13px;">
                                                            <c:choose>
                                                                <c:when test="${not empty res.queuePosition}">
                                                                    #${res.queuePosition}
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="px-4 py-3 text-center">
                                                            <c:choose>
                                                                <c:when test="${res.status eq 'readypickup'}">
                                                                    <span class="badge-pill badge-success">Sẵn sàng nhận</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-pill badge-info">Đang chờ</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="px-4 py-5 text-center text-muted">
                                                        <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px;">event_busy</span>
                                                        Bạn không có yêu cầu đặt trước nào đang hoạt động.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Recent Activity + Profile Card -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Recent Activity -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row p-4 pb-3" style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="card-title text-dark fw-bold mb-0">Hoạt động gần đây</h3>
                                <a href="${pageContext.request.contextPath}/lecturer/borrow-history" class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2 d-flex align-items-center gap-1" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">open_in_new</span> Xem tất cả
                                </a>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <c:choose>
                                    <c:when test="${not empty recentLoans}">
                                        <c:forEach var="loan" items="${recentLoans}">
                                            <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                                <div class="d-flex justify-content-between align-items-start mb-1">
                                                    <p class="fw-bold mb-0 text-dark text-truncate" style="max-width: 170px; font-size: 13px;" title="<c:out value='${loan.book.title}'/>">
                                                        <c:out value="${loan.book.title}" />
                                                    </p>
                                                    <c:choose>
                                                        <c:when test="${loan.status eq 'returned'}">
                                                            <span class="badge-pill badge-success" style="font-size: 10px;">Đã trả</span>
                                                        </c:when>
                                                        <c:when test="${loan.status eq 'overdue'}">
                                                            <span class="badge-pill badge-warning" style="font-size: 10px;">Quá hạn</span>
                                                        </c:when>
                                                        <c:when test="${loan.status eq 'borrowed'}">
                                                            <span class="badge-pill badge-info" style="font-size: 10px;">Đang mượn</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-pill badge-danger" style="font-size: 10px;"><c:out value="${loan.status}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <p class="text-muted mb-1" style="font-size: 12px;"><c:out value="${loan.book.author}" /></p>
                                                <p class="text-muted mb-0" style="font-size: 11px;">Ngày mượn: <fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy" /></p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="p-3 text-center text-muted">
                                            Không có hoạt động nào gần đây.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Quick Profile Card -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="avatar" style="width: 52px; height: 52px; font-size: 18px; background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.email}">
                                            <c:out value="${fn:substring(sessionScope.email,0,2).toUpperCase()}" default="GV" />
                                        </c:when>
                                        <c:otherwise>GV</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="fw-bold mb-0 text-dark" style="font-size: 15px;"><c:out value="${not empty sessionScope.email ? sessionScope.email : 'Giảng viên'}" /></p>
                                    <p class="text-muted mb-0" style="font-size: 12px;">Giảng viên · Đại học FPT</p>
                                </div>
                            </div>
                            <div class="d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Hạn mức mượn đã dùng</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--primary);">
                                        <c:out value="${activeLoansCount != null ? activeLoansCount : '0'}" /> / 10
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Tình trạng phạt</span>
                                    <c:choose>
                                        <c:when test="${not empty totalFines and totalFines gt 0}">
                                            <span style="font-size: 13px; font-weight: 700; color: var(--warning);">
                                                <fmt:formatNumber value="${totalFines}" type="number" maxFractionDigits="0"/> VNĐ
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 13px; font-weight: 700; color: var(--success);">Tốt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Cấp độ truy cập</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--tertiary);">Giảng viên</span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/lecturer/profile" class="btn btn-sm w-100 mt-3 rounded-3 fw-bold"
                               style="background-color: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                Xem toàn bộ Hồ sơ
                            </a>
                        </div>

                    </div><!-- /col-lg-4 -->


                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

</body>
</html>
