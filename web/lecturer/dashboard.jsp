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
                                Chào mừng trở lại, <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}" default="Giảng viên" />!
                            </h2>
                            <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                                Quản lý danh sách tài liệu môn học, hoạt động mượn sách và tài liệu nghiên cứu của bạn.
                            </p>
                        </div>
                        <div class="col-4 d-none d-md-flex justify-content-end align-items-center">
                            <span class="material-symbols-outlined" aria-hidden="true"
                                  style="font-size: 100px; color: var(--on-primary-container); opacity: 0.18;
                                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                                school
                            </span>
                        </div>
                    </div>
                </section>

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
                            <a href="${pageContext.request.contextPath}/lecturer/my-borrowings" class="text-decoration-none text-reset d-block h-100">
                                <div class="stat-card h-100" style="--card-accent: var(--error);">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                                            <span class="material-symbols-outlined" style="color: var(--error);">schedule</span>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty dueSoonCount and dueSoonCount gt 0}">
                                                <span class="badge-pill badge-error">Cần chú ý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-pill badge-success">Tốt</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="stat-label">Sắp đến hạn</p>
                                    <p class="stat-value"><c:out value="${dueSoonCount != null ? dueSoonCount : '0'}" /></p>
                                    <p class="text-on-surface-variant mb-1" style="font-size: 12px;">trong 3 ngày tới</p>
                                    <div class="mini-progress">
                                        <div class="mini-progress-bar" style="width: ${dueSoonCount != null ? (dueSoonCount * 20 > 100 ? 100 : dueSoonCount * 20) : 0}%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <!-- Reserved -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                            <a href="${pageContext.request.contextPath}/lecturer/my-borrowings#reserved" class="text-decoration-none text-reset d-block h-100">
                                <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                            <span class="material-symbols-outlined" style="color: var(--tertiary);">bookmarks</span>
                                        </div>
                                        <span class="badge-pill badge-primary">Đã đặt</span>
                                    </div>
                                    <p class="stat-label">Đã đặt trước</p>
                                    <p class="stat-value"><c:out value="${reservedCount != null ? reservedCount : '0'}" /></p>
                                    <p class="text-on-surface-variant mb-1" style="font-size: 12px;">chờ nhận sách</p>
                                    <div class="mini-progress">
                                        <div class="mini-progress-bar" style="width: ${reservedCount != null ? (reservedCount * 15 > 100 ? 100 : reservedCount * 15) : 0}%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
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

                    <!-- Left 2/3: My Current Loans & Recent Activity -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Sách đang mượn</h3>
                                    <p class="card-subtitle">Các tài liệu bạn đang mượn hiện tại</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/lecturer/borrow-history" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem Lịch sử <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <c:choose>
                                    <c:when test="${not empty myLoans}">
                                        <table class="table table-lms mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Sách</th>
                                                    <th>Ngày mượn</th>
                                                    <th>Hạn trả</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="loan" items="${myLoans}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="book-cover-mini me-3 rounded bg-light border d-flex align-items-center justify-content-center" style="width: 32px; height: 44px; overflow:hidden; flex-shrink: 0;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty loan.book.imagePath}">
                                                                            <c:choose>
                                                                                <c:when test="${fn:startsWith(loan.book.imagePath, 'http://') or fn:startsWith(loan.book.imagePath, 'https://')}">
                                                                                    <img src="${loan.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}/book-images/${loan.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="material-symbols-outlined text-muted" style="font-size: 20px;">book</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${loan.book.title}" /></p>
                                                                    <span class="text-on-surface-variant" style="font-size: 11px;">Mã vạch: <strong><c:out value="${loan.bookCopy.barcode}" /></strong></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td style="font-size: 13px; color: ${loan.status eq 'overdue' ? 'var(--error)' : 'inherit'}; font-weight: ${loan.status eq 'overdue' ? '600' : 'normal'};">
                                                            <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${loan.status eq 'overdue'}">
                                                                    <span class="badge-pill badge-error">Quá hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Đang giữ</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Empty State -->
                                        <div class="text-center py-5">
                                            <span class="material-symbols-outlined d-block mb-3" style="font-size: 48px; color: var(--outline-variant);">menu_book</span>
                                            <h5 class="fw-bold text-on-surface-variant">Không có sách đang mượn</h5>
                                            <p class="text-on-surface-variant small mb-3">Hiện tại bạn không mượn tài liệu nào từ thư viện.</p>
                                            <a href="${pageContext.request.contextPath}/book-search" class="btn btn-sm btn-primary-custom rounded-3 fw-bold text-decoration-none">
                                                Tìm kiếm sách
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Recent Activity Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Hoạt động gần đây</h3>
                                    <p class="card-subtitle">Lịch sử giao dịch mượn trả gần nhất</p>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <c:choose>
                                    <c:when test="${not empty recentLoans}">
                                        <table class="table table-lms mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Sách</th>
                                                    <th>Ngày mượn</th>
                                                    <th>Ngày trả thực tế</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="loan" items="${recentLoans}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="book-cover-mini me-3 rounded bg-light border d-flex align-items-center justify-content-center" style="width: 32px; height: 44px; overflow:hidden; flex-shrink: 0;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty loan.book.imagePath}">
                                                                            <c:choose>
                                                                                <c:when test="${fn:startsWith(loan.book.imagePath, 'http://') or fn:startsWith(loan.book.imagePath, 'https://')}">
                                                                                    <img src="${loan.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}/book-images/${loan.book.imagePath}" alt="Bìa" style="width:100%; height:100%; object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="material-symbols-outlined text-muted" style="font-size: 20px;">book</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${loan.book.title}" /></p>
                                                                    <span class="text-on-surface-variant" style="font-size: 11px;">Tác giả: <c:out value="${loan.book.author}" /></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;">
                                                            <c:choose>
                                                                <c:when test="${not empty loan.returnedAt}">
                                                                    <fmt:formatDate value="${loan.returnedAt}" pattern="dd/MM/yyyy" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-warning fw-semibold">— Đang mượn —</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${loan.status eq 'returned'}">
                                                                    <span class="badge-pill badge-success">Đã trả</span>
                                                                </c:when>
                                                                <c:when test="${loan.status eq 'overdue'}">
                                                                    <span class="badge-pill badge-error">Quá hạn</span>
                                                                </c:when>
                                                                <c:when test="${loan.status eq 'borrowed'}">
                                                                    <span class="badge-pill badge-warning">Đang mượn</span>
                                                                </c:when>
                                                                <c:when test="${loan.status eq 'damaged'}">
                                                                    <span class="badge-pill badge-error">Làm hỏng</span>
                                                                </c:when>
                                                                <c:when test="${loan.status eq 'lost'}">
                                                                    <span class="badge-pill badge-error">Làm mất</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-pill badge-neutral"><c:out value="${loan.status}" /></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <span class="material-symbols-outlined d-block mb-3" style="font-size: 48px; color: var(--outline-variant);">history_edu</span>
                                            <h5 class="fw-bold text-on-surface-variant">Không có hoạt động gần đây</h5>
                                            <p class="text-on-surface-variant small mb-0">Bạn chưa thực hiện giao dịch nào.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-3 bg-surface-container-low text-center" style="border-top: 1px solid var(--outline-variant);">
                                <a href="${pageContext.request.contextPath}/lecturer/borrow-history" class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                                    Xem toàn bộ lịch sử mượn trả
                                </a>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Quick Profile Card -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Quick Profile Card -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="avatar" style="width: 52px; height: 52px; font-size: 18px; background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant); display: flex; align-items: center; justify-content: center; border-radius: 50%; font-weight: bold;">
                                    <c:choose>
                                        <c:when test="${not empty profile.fullName}">
                                            <c:out value="${fn:substring(profile.fullName, 0, 1).toUpperCase()}" />
                                        </c:when>
                                        <c:when test="${not empty sessionScope.email}">
                                            <c:out value="${fn:substring(sessionScope.email, 0, 2).toUpperCase()}" />
                                        </c:when>
                                        <c:otherwise>GV</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="fw-bold mb-0" style="font-size: 15px;">
                                        <c:out value="${not empty profile.fullName ? profile.fullName : 'Giảng viên'}" />
                                    </p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">
                                        Giảng viên
                                        <c:if test="${not empty lecturerInfo.department}">
                                            · Bộ môn <c:out value="${lecturerInfo.department}" />
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                            <div class="d-flex flex-column gap-2">
                                <c:if test="${not empty lecturerInfo.lecturerCode}">
                                    <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                        <span style="font-size: 13px; color: var(--on-surface-variant);">Mã giảng viên</span>
                                        <span style="font-size: 13px; font-weight: 700; color: var(--on-surface);"><c:out value="${lecturerInfo.lecturerCode}" /></span>
                                    </div>
                                </c:if>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Hạn mức mượn đã dùng</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--primary);">
                                        <c:out value="${activeLoansCount != null ? activeLoansCount : '0'}" /> / 10 sách
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Trạng thái thư viện</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--success);">Tốt</span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Cấp độ tài khoản</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--tertiary);">Nhân viên học thuật</span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/lecturer/profile" class="btn btn-sm w-100 mt-3 rounded-3 fw-bold text-decoration-none text-center d-block"
                               style="background-color: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant); padding: 8px;">
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
