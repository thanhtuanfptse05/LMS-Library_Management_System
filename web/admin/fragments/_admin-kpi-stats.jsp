<%-- Fragment: _admin-kpi-stats.jsp — 4 ô thống kê KPI trên trang Admin Dashboard --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row g-3 mb-4">

    <%-- Card: Total Books --%>
    <div class="col-12 col-sm-6 col-xl-3 fade-in-up">
        <div class="stat-card h-100" style="--card-accent: var(--primary);">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                    <span class="material-symbols-outlined" style="color: var(--primary);">menu_book</span>
                </div>
                <span class="badge-pill badge-success">Ổn định</span>
            </div>
            <p class="stat-label">Tổng số Sách</p>
            <p class="stat-value">
                <fmt:formatNumber value="${not empty totalBooks ? totalBooks : 0}" pattern="#,###" />
            </p>
            <div class="mini-progress">
                <div class="mini-progress-bar"
                     style="width: 100%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
            </div>
        </div>
    </div>

    <%-- Card: Library Members --%>
    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
        <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                    <span class="material-symbols-outlined" style="color: var(--tertiary);">person</span>
                </div>
                <span class="badge-pill badge-success">Hoạt động</span>
            </div>
            <p class="stat-label">Thành viên Thư viện</p>
            <p class="stat-value">
                <fmt:formatNumber value="${not empty totalMembers ? totalMembers : 0}" pattern="#,###" />
            </p>
            <div class="mini-progress">
                <div class="mini-progress-bar"
                     style="width: 100%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
            </div>
        </div>
    </div>

    <%-- Card: Unpaid Fines --%>
    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
        <div class="stat-card h-100" style="--card-accent: var(--warning);">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                    <span class="material-symbols-outlined" style="color: var(--warning);">payments</span>
                </div>
                <span class="badge-pill badge-warning">Chưa thu</span>
            </div>
            <p class="stat-label">Tổng Phạt chưa thanh toán</p>
            <p class="stat-value" style="font-size: 20px;">
                <fmt:formatNumber value="${not empty unpaidFines ? unpaidFines : 0}" pattern="#,###" /> đ
            </p>
            <div class="mini-progress">
                <div class="mini-progress-bar"
                     style="width: 100%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
            </div>
        </div>
    </div>

    <%-- Card: Pending Payments --%>
    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
        <div class="stat-card h-100" style="--card-accent: var(--error);">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                    <span class="material-symbols-outlined" style="color: var(--error);">hourglass_empty</span>
                </div>
                <span class="badge-pill badge-error">Chờ duyệt</span>
            </div>
            <p class="stat-label">Thanh toán chờ duyệt</p>
            <p class="stat-value">
                <fmt:formatNumber value="${not empty pendingPayments ? pendingPayments : 0}" pattern="#,###" />
            </p>
            <div class="mini-progress">
                <div class="mini-progress-bar"
                     style="width: 100%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
            </div>
        </div>
    </div>

</div>
