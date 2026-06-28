<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

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

                <!-- ─── KPI Section Header ─── -->
                <section class="mb-4">
                    <div class="d-flex justify-content-between align-items-end mb-3">
                        <div>
                            <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Hiệu suất Thư viện</h2>
                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                                Tóm tắt KPI hàng tháng —
                                <span id="current-month" class="fw-semibold"></span>
                            </p>
                        </div>
                        <a href="#" class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 16px;">download</span> Xuất báo cáo
                        </a>
                    </div>

                    <!-- KPI Cards -->
                    <div class="row g-3">
                        <!-- Total Borrowings -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                            <div class="stat-card h-100" style="--card-accent: var(--primary);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                    </div>
                                    <span class="fw-bold kpi-trend-up d-flex align-items-center gap-1" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">trending_up</span> +8.2%
                                    </span>
                                </div>
                                <p class="stat-label">Tổng số Mượn (tháng này)</p>
                                <p class="stat-value"><c:out value="${not empty totalBorrowings ? totalBorrowings : '—'}" /></p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 78%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Active Members -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                            <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--tertiary);">people</span>
                                    </div>
                                    <span class="fw-bold kpi-trend-up d-flex align-items-center gap-1" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">trending_up</span> +3.5%
                                    </span>
                                </div>
                                <p class="stat-label">Thành viên hoạt động</p>
                                <p class="stat-value"><c:out value="${not empty activeMembers ? activeMembers : '—'}" /></p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 65%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Fine Revenue -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                            <div class="stat-card h-100" style="--card-accent: var(--warning);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--warning);">payments</span>
                                    </div>
                                    <span class="fw-bold kpi-trend-up d-flex align-items-center gap-1" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">trending_up</span> +12.1%
                                    </span>
                                </div>
                                <p class="stat-label">Doanh thu Tiền phạt (tháng này)</p>
                                <p class="stat-value"><c:out value="${not empty fineRevenue ? fineRevenue : '—'}" /></p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 55%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Overdue Rate -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                            <div class="stat-card h-100" style="--card-accent: var(--error);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--error);">event_busy</span>
                                    </div>
                                    <span class="fw-bold kpi-trend-down d-flex align-items-center gap-1" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">trending_down</span> -1.4%
                                    </span>
                                </div>
                                <p class="stat-label">Tỷ lệ Trễ hạn</p>
                                <p class="stat-value"><c:out value="${not empty overdueRate ? overdueRate : '—'}" /></p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: ${not empty overdueRateVal ? overdueRateVal : 0}%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Borrowing Chart + Staff Table -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Monthly Borrowing Trend Chart -->
                        <div class="raised-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h3 class="card-title">Xu hướng Mượn hàng tháng</h3>
                                    <p class="card-subtitle">Số phiếu mượn mỗi tháng (8 tháng gần nhất)</p>
                                </div>
                                <span class="badge-pill badge-primary" id="chart-year-badge"></span>
                            </div>
                            <div class="d-flex align-items-end gap-2 pt-2" style="height: 140px; border-bottom: 2px solid var(--outline-variant);">
                                <c:choose>
                                    <c:when test="${not empty monthlyTrend}">
                                        <c:forEach var="row" items="${monthlyTrend}" varStatus="loop">
                                            <c:set var="barHeight" value="${maxTrend > 0 ? row[2] * 100 / maxTrend : 0}" />
                                            <c:set var="isLast" value="${loop.last}" />
                                            <div class="bar-chart-col flex-fill" title="Tháng ${row[1]}/${row[0]}: ${row[2]}">
                                                <div class="bar-track" style="height: ${barHeight}%; background: ${isLast ? 'linear-gradient(180deg, var(--primary-container) 0%, var(--primary) 100%)' : 'var(--surface-container-high)'};"></div>
                                                <span style="font-size: 10px; color: ${isLast ? 'var(--primary)' : 'var(--on-surface-variant)'}; font-weight: ${isLast ? '700' : 'normal'};">Th<c:out value="${row[1]}"/></span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Fallback: hiển thị 8 cột trống khi chưa có dữ liệu --%>
                                        <c:forEach begin="1" end="8">
                                            <div class="bar-chart-col flex-fill">
                                                <div class="bar-track" style="height: 10%; background-color: var(--surface-container-high);"></div>
                                                <span style="font-size: 10px; color: var(--on-surface-variant);">—</span>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="d-flex gap-4 mt-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="rounded-1 d-inline-block" style="width: 14px; height: 10px; background: var(--primary);"></span>
                                    <span style="font-size: 12px; color: var(--on-surface-variant);">Tháng hiện tại</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="rounded-1 d-inline-block" style="width: 14px; height: 10px; background: var(--surface-container-high);"></span>
                                    <span style="font-size: 12px; color: var(--on-surface-variant);">Tháng trước</span>
                                </div>
                            </div>
                        </div>

                        <!-- Staff Performance Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Hiệu suất Nhân viên</h3>
                                    <p class="card-subtitle">Hoạt động hàng tháng theo thủ thư</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/manager/staff-performance"
                                   class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 text-decoration-none">
                                    Báo cáo Chi tiết
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thủ thư</th>
                                            <th class="text-center">Phiếu cấp</th>
                                            <th class="text-center">Phiếu trả</th>
                                            <th class="text-end">Tiền phạt thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty staffStats}">
                                                <c:forEach var="staff" items="${staffStats}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar avatar-sm" style="background: linear-gradient(135deg, var(--primary-fixed), var(--primary-fixed-dim)); color: var(--on-primary-container);">
                                                                    <c:out value="${staff.initials}"/>
                                                                </div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${staff.fullName}" /></span>
                                                            </div>
                                                        </td>
                                                        <td class="fw-bold text-center" style="font-size: 13px;"><c:out value="${staff.issueCount}" /></td>
                                                        <td class="fw-bold text-center" style="font-size: 13px;"><c:out value="${staff.returnCount}" /></td>
                                                        <td class="fw-bold text-end" style="font-size: 13px; color: var(--success);"><c:out value="${staff.fineCollectedFormatted}" /></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background: linear-gradient(135deg, var(--primary-fixed), var(--primary-fixed-dim)); color: var(--on-primary-container);">JS</div><span style="font-size: 13px; font-weight: 600;">John Stevens</span></div></td>
                                                    <td class="fw-bold" style="font-size: 13px;">345</td>
                                                    <td class="fw-bold" style="font-size: 13px;">312</td>
                                                    <td class="fw-bold" style="font-size: 13px; color: var(--success);">680,000đ</td>
                                                    <td><span class="badge-pill badge-success">★ 4.9</span></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background: linear-gradient(135deg, var(--secondary-fixed), var(--secondary-fixed-dim)); color: var(--on-secondary-fixed);">MH</div><span style="font-size: 13px; font-weight: 600;">Mai Huong</span></div></td>
                                                    <td class="fw-bold" style="font-size: 13px;">298</td>
                                                    <td class="fw-bold" style="font-size: 13px;">281</td>
                                                    <td class="fw-bold" style="font-size: 13px; color: var(--success);">540,000đ</td>
                                                    <td><span class="badge-pill badge-success">★ 4.7</span></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background: linear-gradient(135deg, var(--tertiary-fixed), #a0d0f5); color: var(--on-tertiary-fixed);">NQ</div><span style="font-size: 13px; font-weight: 600;">Nguyen Quang</span></div></td>
                                                    <td class="fw-bold" style="font-size: 13px;">210</td>
                                                    <td class="fw-bold" style="font-size: 13px;">195</td>
                                                    <td class="fw-bold" style="font-size: 13px; color: var(--warning);">380,000đ</td>
                                                    <td><span class="badge-pill badge-warning">★ 4.2</span></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Policies + Announcements -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Library Policies -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Chính sách Hoạt động</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2 d-flex align-items-center gap-1" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Thêm mới
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="policy-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Chính sách Thời hạn Mượn</p>
                                        <span class="badge-pill badge-success">Hoạt động</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Tối đa 21 ngày mỗi lần mượn. Gia hạn được 1 lần.</p>
                                </div>
                                <div class="policy-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Chính sách Tiền phạt</p>
                                        <span class="badge-pill badge-success">Hoạt động</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Phí 5.000 VND/ngày quá hạn.</p>
                                </div>
                                <div class="policy-item" style="border-left-color: var(--warning-container);">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Hết hạn Đặt trước</p>
                                        <span class="badge-pill badge-warning">Xem xét</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Đặt trước tự động hủy sau 48 giờ.</p>
                                </div>
                            </div>
                            <div class="p-3" style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-low);">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Quản lý Chính sách
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- System Announcements -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Thông báo hệ thống</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2 d-flex align-items-center gap-1" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">campaign</span> Đăng
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <c:choose>
                                    <c:when test="${not empty announcements}">
                                        <c:forEach var="ann" items="${announcements}">
                                            <div class="announcement-card">
                                                <p class="fw-bold mb-1" style="font-size: 13px;"><c:out value="${ann.title}" /></p>
                                                <p class="text-on-surface-variant mb-1" style="font-size: 12px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                    <c:out value="${ann.content}" />
                                                </p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">
                                                    <fmt:formatDate value="${ann.createdAt}" pattern="dd/MM/yyyy" />
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="announcement-card">
                                            <p class="fw-bold mb-1" style="font-size: 13px;">Cập nhật Giờ mùa hè</p>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Thư viện mở cửa đến 22:00 từ ngày 10/6 đến 31/8.</p>
                                            <span class="text-on-surface-variant" style="font-size: 11px;">Ngày đăng: 01/06/2025</span>
                                        </div>
                                        <div class="announcement-card" style="border-left-color: var(--tertiary); background-color: rgba(205,229,255,0.15);">
                                            <p class="fw-bold mb-1" style="font-size: 13px;">Thông báo bổ sung Sách mới</p>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">220 tựa sách Khoa học Máy tính mới được thêm vào danh mục Kèo Đông.</p>
                                            <span class="text-on-surface-variant" style="font-size: 11px;">Ngày đăng: 28/05/2025</span>
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
    <script>
        document.getElementById('current-month').textContent =
            new Date().toLocaleString('vi-VN', { month: 'long', year: 'numeric' });
        const chartBadge = document.getElementById('chart-year-badge');
        if (chartBadge) chartBadge.textContent = new Date().getFullYear();
    </script>
</body>
</html>
