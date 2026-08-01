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
                            <button type="button" onclick="location.reload()"
                                    class="btn btn-sm btn-outline-secondary rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                <span class="material-symbols-outlined" style="font-size: 16px;">refresh</span> Làm mới dữ liệu
                            </button>
                            <a href="${pageContext.request.contextPath}/librarian/book-management/overview"
                               class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                                <span class="material-symbols-outlined" style="font-size: 16px;">auto_stories</span> Quản lý sách
                            </a>
                            <a href="${pageContext.request.contextPath}/librarian/desk-dashboard"
                               class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                                <span class="material-symbols-outlined" style="font-size: 16px;">room_service</span> Quầy lưu thông
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
                            </div>
                        </div>
                    </div>

                    <!-- ─── Scoped Custom styles ─── -->
                    <style>
                        .border-hover {
                            transition: border-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
                        }
                        .border-hover:hover {
                            border-color: var(--primary) !important;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(217, 119, 6, 0.08);
                        }
                    </style>

                    <!-- ─── Main Split Layout ─── -->
                    <div class="row g-4">

                        <!-- Left 2/3: My Loans + Overdue Loans -->
                        <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                            <!-- Sách tôi đã xử lý (loans do thủ thư này tạo) -->

                            <div class="raised-card overflow-hidden d-flex flex-column">
                                <div class="card-header-row">
                                    <div>
                                        <h3 class="card-title">Hoạt động lưu thông hệ thống</h3>
                                        <p class="card-subtitle">Tất cả giao dịch mượn/trả sách mới nhất trong thư viện</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard"
                                       class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Cho mượn sách
                                    </a>
                                </div>
                                <div class="table-responsive flex-grow-1">
                                    <table class="table table-lms mb-0">
                                        <thead>
                                            <tr>
                                                <th>Thành viên</th>
                                                <th>Tiêu đề sách</th>
                                                <th>Hạn trả</th>
                                                <th>Người xử lý</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty myLoans}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-4">
                                                            <span class="material-symbols-outlined text-muted" style="font-size: 32px;">inbox</span>
                                                            <p class="text-muted mt-2 mb-0" style="font-size: 13px;">Chưa có dữ liệu</p>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="loan" items="${myLoans}" end="7">
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
                                                            <td style="font-size: 13px; max-width: 180px;">
                                                                <span class="d-block text-truncate" title="${loan.bookTitle}"><c:out value="${loan.bookTitle}" /></span>
                                                            </td>
                                                            <td style="font-size: 13px; <c:if test='${(loan.status eq "borrowed" or loan.status eq "overdue") and loan.endDate.time lt now.time}'>color: var(--error); font-weight: bold;</c:if>">
                                                                <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td style="font-size: 12px;">
                                                                <c:choose>
                                                                    <c:when test="${not empty loan.staffName}">
                                                                        <span class="fw-semibold text-dark"><c:out value="${loan.staffName}" /></span>
                                                                        <div class="text-muted" style="font-size: 11px;"><c:out value="${loan.staffCode != null ? loan.staffCode : 'Thủ thư'}" /></div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-light text-secondary border">Đặt Online</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${loan.status eq 'returned'}">
                                                                        <span class="badge-pill badge-success">Đã trả</span>
                                                                    </c:when>
                                                                    <c:when test="${loan.status eq 'overdue' or loan.endDate.time lt now.time}">
                                                                        <span class="badge-pill badge-error">Quá hạn</span>
                                                                    </c:when>
                                                                    <c:when test="${(loan.endDate.time - now.time) lt 3 * 24 * 60 * 60 * 1000}">
                                                                        <span class="badge-pill badge-warning">Sắp đến hạn</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge-pill badge-info">Đang mượn</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="p-3 text-center d-flex justify-content-between align-items-center mt-auto" style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                        Xử lý lưu thông tại quầy
                                        <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                    </a>
                                    <c:if test="${not empty myLoans}">
                                        <a href="${pageContext.request.contextPath}/librarian/borrowings" class="text-muted fw-bold text-decoration-none" style="font-size: 13px;">
                                            Xem tất cả &rarr;
                                        </a>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Khoản mượn quá hạn — chỉ hiển thị nếu có data -->
                            <c:if test="${not empty overdueLoans}">
                            <div class="raised-card overflow-hidden">
                                <div class="card-header-row">
                                    <div>
                                        <h3 class="card-title">Khoản mượn quá hạn</h3>
                                        <p class="card-subtitle">Danh sách cần nhắc nhở trả sách ngay</p>
                                    </div>
                                    <span class="badge-pill badge-error">
                                        <c:out value="${overdueCount}" /> Quá hạn
                                    </span>
                                </div>
                                <div class="table-responsive" style="max-height: 320px; overflow-y: auto;">
                                    <table class="table table-lms mb-0">
                                        <thead>
                                            <tr>
                                                <th>Thành viên</th>
                                                <th>Tên sách</th>
                                                <th>Hạn trả</th>
                                                <th class="text-end">Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="overdue" items="${overdueLoans}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--error-container); color: var(--error);">
                                                                <c:out value="${fn:toUpperCase(fn:substring(overdue.memberName, 0, 2))}" />
                                                            </div>
                                                            <div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${overdue.memberName}" /></span>
                                                                <div class="text-muted" style="font-size: 11px;"><c:out value="${overdue.memberCode}" /></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="font-size: 13px; max-width: 180px;">
                                                        <span class="d-block text-truncate" title="${overdue.bookTitle}"><c:out value="${overdue.bookTitle}" /></span>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--error); font-weight: 600;">
                                                        <fmt:formatDate value="${overdue.endDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${overdue.memberCode}"
                                                           class="btn-icon text-decoration-none" title="Xử lý trả sách">
                                                            <span class="material-symbols-outlined">assignment_return</span>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="p-3 text-center" style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                        Xử lý trả sách tại quầy
                                        <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                    </a>
                                </div>
                            </div>
                            </c:if>

                        </div><!-- /col-lg-8 -->

                        <!-- Right 1/3: Ready Pickup + Fine Alerts -->
                        <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                            <!-- 1. Sẵn sàng lấy sách (Bằng kích thước với card Thu phạt) -->
                            <div class="raised-card overflow-hidden d-flex flex-column flex-fill" style="min-height: 320px;">
                                <div class="card-header-row d-flex justify-content-between align-items-center">
                                    <div>
                                        <h3 class="card-title mb-0">Sẵn sàng lấy sách</h3>
                                        <p class="card-subtitle mb-0">Đơn đặt trước chờ độc giả đến nhận</p>
                                    </div>
                                    <span class="badge-pill badge-warning">
                                        ${fn:length(readyPickupList)} Chờ lấy
                                    </span>
                                </div>
                                <div class="p-3 d-flex flex-column gap-2 flex-grow-1" style="height: 220px; overflow-y: auto;">
                                    <c:choose>
                                        <c:when test="${empty readyPickupList}">
                                            <div class="text-center py-4 my-auto">
                                                <span class="material-symbols-outlined text-muted" style="font-size: 32px;">inbox</span>
                                                <p class="text-muted mt-2 mb-0" style="font-size: 13px;">Không có đơn chờ nhận sách</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="pickup" items="${readyPickupList}">
                                                <div class="p-3 rounded-3" style="background: linear-gradient(135deg, rgba(217,119,6,0.05) 0%, rgba(217,119,6,0.02) 100%); border: 1px solid rgba(217,119,6,0.2);">
                                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                                        <span class="fw-bold" style="font-size: 13px;"><c:out value="${pickup.memberName}" /></span>
                                                        <span class="badge-pill badge-warning" style="font-size: 10px;">Chờ lấy</span>
                                                    </div>
                                                    <p class="text-on-surface-variant mb-1" style="font-size: 12px; font-weight: 600;">
                                                        <span class="material-symbols-outlined" style="font-size: 13px; vertical-align: middle;">book</span>
                                                        <c:out value="${pickup.bookTitle}" />
                                                    </p>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span class="text-muted" style="font-size: 11px;">
                                                            <c:out value="${pickup.memberCode}" /> &bull;
                                                            Hết hạn: <fmt:formatDate value="${pickup.endDate}" pattern="dd/MM/yyyy" />
                                                        </span>
                                                        <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${pickup.memberCode}"
                                                           class="btn btn-sm btn-primary-custom rounded-2 fw-bold text-decoration-none" style="font-size: 11px; line-height: 1.8; padding: 2px 10px;">
                                                            Cho mượn
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="p-2 text-center mt-auto" style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-low);">
                                    <a href="${pageContext.request.contextPath}/librarian/desk-dashboard" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                        Đến quầy lưu thông
                                        <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                    </a>
                                </div>
                            </div>

                            <!-- 2. Danh sách đơn phạt & Thu nợ (Bằng kích thước với card Sẵn sàng lấy sách) -->
                            <div class="raised-card overflow-hidden d-flex flex-column flex-fill" style="min-height: 320px;">
                                <div class="card-header-row d-flex justify-content-between align-items-center">
                                    <div>
                                        <h3 class="card-title mb-0">Danh sách đơn phạt & Thu nợ</h3>
                                        <p class="card-subtitle mb-0">Tất cả đơn vi phạm & phạt gần đây</p>
                                    </div>
                                    <div>
                                        <span class="badge-pill badge-info">${fn:length(unpaidFinesList)} Đơn</span>
                                    </div>
                                </div>
                                <div class="p-3 d-flex flex-column gap-2 flex-grow-1" style="height: 220px; overflow-y: auto;">
                                    <c:choose>
                                        <c:when test="${empty unpaidFinesList}">
                                            <div class="text-center py-4 my-auto">
                                                <span class="material-symbols-outlined text-muted" style="font-size: 32px;">inbox</span>
                                                <p class="text-muted mt-2 mb-0" style="font-size: 13px;">Chưa có dữ liệu đơn phạt</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="fine" items="${unpaidFinesList}" varStatus="loop" end="7">
                                                <div class="d-flex justify-content-between align-items-center py-2 ${!loop.last ? 'border-bottom' : ''}" style="border-color: var(--outline-variant) !important;">
                                                    <div>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${fine.memberName}" /></p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 11px;"><c:out value="${fine.memberCode}" /></p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px; margin-top: 4px;"><c:out value="${fine.reason}" /></p>
                                                    </div>
                                                    <div class="text-end">
                                                        <p class="mb-1" style="font-size: 14px; font-weight: 700; color: ${fine.status eq 'paid' ? 'var(--tertiary)' : 'var(--error)'};">
                                                            <fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                                        </p>
                                                        <c:choose>
                                                            <c:when test="${fine.status eq 'unpaid'}">
                                                                <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${fine.memberCode}"
                                                                   class="btn btn-sm fw-bold px-3 text-decoration-none rounded-2"
                                                                   style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none; display: inline-block;">
                                                                    Thu
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill badge-success" style="font-size: 10px;">Đã thu</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="p-2 text-center mt-auto" style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-low);">
                                    <a href="${pageContext.request.contextPath}/librarian/fines" class="text-muted fw-bold text-decoration-none" style="font-size: 13px;">
                                        Xem tất cả đơn phạt &rarr;
                                    </a>
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
