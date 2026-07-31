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

            <%-- Header --%>
            <header class="lms-header header-layout">
                <div class="d-flex align-items-center gap-3 flex-grow-1 text-nowrap overflow-hidden me-3">
                    <h1 class="mb-0 fw-bold text-primary-custom d-none d-md-block" style="font-size: 16px; white-space: nowrap;">
                        <span class="material-symbols-outlined me-1" style="font-size: 18px; font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">groups</span>
                        Hiệu suất Nhân viên
                    </h1>
                </div>
                <div class="d-flex align-items-center gap-2 flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/admin/profile"
                       class="d-flex align-items-center gap-2 text-decoration-none" title="Xem Hồ sơ">
                        <div class="header-avatar" title="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}">
                            <c:choose>
                                <c:when test="${not empty sessionScope.fullName}">
                                    ${fn:toUpperCase(fn:substring(sessionScope.fullName,0,2))}
                                </c:when>
                                <c:when test="${not empty sessionScope.email}">
                                    ${fn:toUpperCase(fn:substring(sessionScope.email,0,2))}
                                </c:when>
                                <c:otherwise>QL</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="d-none d-sm-block" style="max-width: 140px;">
                            <p class="mb-0 fw-bold text-truncate" style="font-size: 13px; color: var(--on-surface);">
                                <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.email}" default="Quản lý"/>
                            </p>
                            <p class="mb-0 text-uppercase text-on-surface-variant text-truncate" style="font-size: 10px; letter-spacing: 0.1em;">
                                <c:out value="${sessionScope.role}" default="ADMIN"/>
                            </p>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="header-icon-btn" title="Đăng xuất">
                        <span class="material-symbols-outlined">logout</span>
                    </a>
                </div>
            </header>

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                <%-- ─── Tiêu đề trang ─── --%>
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Hiệu suất Nhân viên</h2>
                        <p class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">
                            Thống kê hoạt động hàng tháng của Thủ thư — Tháng
                            <strong><c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/></strong>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                        <span class="material-symbols-outlined" style="font-size: 16px;">arrow_back</span>
                        Quay lại Dashboard
                    </a>
                </div>

                <%-- ─── Bộ lọc Tháng / Năm ─── --%>
                <div class="raised-card p-3 mb-4">
                    <form method="get" action="${pageContext.request.contextPath}/admin/staff-performance"
                          class="d-flex flex-wrap align-items-center gap-3">
                        <label class="fw-semibold mb-0" style="font-size: 13px; color: var(--on-surface);">Lọc theo:</label>

                        <div class="d-flex align-items-center gap-2">
                            <label class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Tháng:</label>
                            <select name="month" class="form-select form-select-sm" style="width: auto; font-size: 13px;">
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="d-flex align-items-center gap-2">
                            <label class="mb-0" style="font-size: 13px; color: var(--on-surface-variant);">Năm:</label>
                            <select name="year" class="form-select form-select-sm" style="width: auto; font-size: 13px;">
                                <c:forEach var="y" begin="2023" end="${currentYear}">
                                    <option value="${y}" ${y == selectedYear ? 'selected' : ''}>
                                        <c:out value="${y}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                            <span class="material-symbols-outlined" style="font-size: 15px;">filter_list</span>
                            Áp dụng
                        </button>
                    </form>
                </div>

                <%-- ─── 3 KPI Summary Cards ─── --%>
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="stat-card h-100" style="--card-accent: var(--primary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                </div>
                            </div>
                            <p class="stat-label">Tổng phiếu Cấp</p>
                            <p class="stat-value"><c:out value="${totalIssues}"/></p>
                            <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                                Tháng <c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/>
                            </p>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--tertiary);">assignment_return</span>
                                </div>
                            </div>
                            <p class="stat-label">Tổng phiếu Trả</p>
                            <p class="stat-value"><c:out value="${totalReturns}"/></p>
                            <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                                Tháng <c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/>
                            </p>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="stat-card h-100" style="--card-accent: var(--success);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--success-container) 0%, #a7f3d0 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--success);">payments</span>
                                </div>
                            </div>
                            <p class="stat-label">Tổng Tiền phạt Thu</p>
                            <p class="stat-value" style="font-size: 20px;">
                                <fmt:formatNumber value="${totalFine}" type="number" groupingUsed="true"/>đ
                            </p>
                            <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                                Tháng <c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/>
                            </p>
                        </div>
                    </div>
                </div>

                <%-- ─── Bảng Chi tiết Nhân viên ─── --%>
                <div class="raised-card overflow-hidden">
                    <div class="card-header-row">
                        <div>
                            <h3 class="card-title">Danh sách Thủ thư</h3>
                            <p class="card-subtitle">
                                Thống kê chi tiết tháng <c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/>
                            </p>
                        </div>
                        <span class="badge-pill badge-primary">
                            <c:choose>
                                <c:when test="${not empty staffList}"><c:out value="${staffList.size()}"/> nhân viên</c:when>
                                <c:otherwise>0 nhân viên</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty staffList}">
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Thủ thư</th>
                                            <th>Mã NV</th>
                                            <th class="text-center">Phiếu Cấp</th>
                                            <th class="text-center">Phiếu Trả</th>
                                            <th class="text-end">Tiền phạt Thu</th>
                                            <th class="text-center">Tỷ lệ Trả</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="staff" items="${staffList}" varStatus="loop">
                                            <tr>
                                                <td style="color: var(--on-surface-variant); font-size: 13px;">
                                                    <c:out value="${loop.index + 1}"/>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="avatar avatar-sm"
                                                             style="background: linear-gradient(135deg, var(--primary-fixed), var(--primary-fixed-dim)); color: var(--on-primary-container);">
                                                            <c:out value="${staff.initials}"/>
                                                        </div>
                                                        <span style="font-size: 13px; font-weight: 600;">
                                                            <c:out value="${staff.fullName}"/>
                                                        </span>
                                                    </div>
                                                </td>
                                                <td style="font-size: 13px; color: var(--on-surface-variant);">
                                                    <c:out value="${staff.staffCode}"/>
                                                </td>
                                                <td class="text-center fw-bold" style="font-size: 13px;">
                                                    <c:out value="${staff.issueCount}"/>
                                                </td>
                                                <td class="text-center fw-bold" style="font-size: 13px;">
                                                    <c:out value="${staff.returnCount}"/>
                                                </td>
                                                <td class="text-end fw-bold" style="font-size: 13px; color: var(--success);">
                                                    <fmt:formatNumber value="${staff.fineCollected}" type="number" groupingUsed="true"/>đ
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${staff.issueCount > 0}">
                                                            <c:set var="rate" value="${staff.returnCount * 100 / staff.issueCount}"/>
                                                            <span class="badge-pill ${rate >= 80 ? 'badge-success' : rate >= 50 ? 'badge-warning' : 'badge-error'}">
                                                                <fmt:formatNumber value="${rate}" maxFractionDigits="0"/>%
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-pill badge-neutral">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <span class="material-symbols-outlined d-block mb-3"
                                      style="font-size: 48px; color: var(--outline-variant);">groups</span>
                                <p class="fw-semibold mb-1" style="color: var(--on-surface);">Chưa có dữ liệu</p>
                                <p style="font-size: 13px; color: var(--on-surface-variant);">
                                    Không có hoạt động nào được ghi nhận trong tháng
                                    <strong><c:out value="${selectedMonth}"/>/<c:out value="${selectedYear}"/></strong>.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div><%-- /container-fluid --%>

            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><%-- /.main-wrapper --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Đánh dấu active cho sidebar item Hiệu suất Nhân viên
        const staffNav = document.getElementById('mgr-nav-staff');
        if (staffNav) {
            staffNav.classList.add('active');
        }
    </script>

</body>
</html>
