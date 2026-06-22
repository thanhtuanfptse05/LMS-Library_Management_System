<%-- Fragment: _section-stats.jsp — Quick Stats Grid (Active Loans, Due Soon, Reserved, Fines) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- ── Quick Stats Grid ── -->
<section class="row g-3 mb-5">

    <!-- Active Loans -->
    <div class="col-12 col-md-6 col-lg-3 fade-in-up fade-in-up-1">
        <a href="${pageContext.request.contextPath}/student/my-borrowings" class="text-decoration-none text-reset d-block h-100">
            <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                        <span class="material-symbols-outlined" style="color: var(--tertiary);">book_online</span>
                    </div>
                    <span class="badge-pill badge-info">Đang mượn</span>
                </div>
                <p class="stat-label">Sách đang mượn</p>
                <p class="stat-value"><c:out value="${not empty activeLoansCount ? activeLoansCount : '0'}" /></p>
                <div class="mini-progress">
                    <div class="mini-progress-bar" style="width: ${not empty activeLoansCount ? (activeLoansCount * 10 > 100 ? 100 : activeLoansCount * 10) : 0}%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                </div>
            </div>
        </a>
    </div>

    <!-- Due Soon -->
    <div class="col-12 col-md-6 col-lg-3 fade-in-up fade-in-up-2">
        <a href="${pageContext.request.contextPath}/student/my-borrowings" class="text-decoration-none text-reset d-block h-100">
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
                <p class="stat-value"><c:out value="${not empty dueSoonCount ? dueSoonCount : '0'}" /></p>
                <div class="mini-progress">
                    <div class="mini-progress-bar" style="width: ${not empty dueSoonCount ? (dueSoonCount * 20 > 100 ? 100 : dueSoonCount * 20) : 0}%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                </div>
            </div>
        </a>
    </div>

    <!-- Reserved -->
    <div class="col-12 col-md-6 col-lg-3 fade-in-up fade-in-up-3">
        <a href="${pageContext.request.contextPath}/student/my-borrowings#reserved" class="text-decoration-none text-reset d-block h-100">
            <div class="stat-card h-100" style="--card-accent: var(--primary);">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                        <span class="material-symbols-outlined" style="color: var(--primary);">bookmarks</span>
                    </div>
                    <span class="badge-pill badge-primary">Đã đặt</span>
                </div>
                <p class="stat-label">Đã đặt trước</p>
                <p class="stat-value"><c:out value="${not empty reservedCount ? reservedCount : '0'}" /></p>
                <div class="mini-progress">
                    <div class="mini-progress-bar" style="width: ${not empty reservedCount ? (reservedCount * 15 > 100 ? 100 : reservedCount * 15) : 0}%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                </div>
            </div>
        </a>
    </div>

    <!-- Overdue Fines -->
    <div class="col-12 col-md-6 col-lg-3 fade-in-up fade-in-up-4">
        <a href="${pageContext.request.contextPath}/student/fines" class="text-decoration-none text-reset d-block h-100">
            <div class="stat-card h-100" style="--card-accent: ${not empty totalFines and totalFines gt 0 ? 'var(--warning)' : 'var(--success)'};">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="stat-icon"
                         style="background: ${not empty totalFines and totalFines gt 0 ? 'linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%)' : 'linear-gradient(135deg, var(--success-container) 0%, #a7f3d0 100%)'} ;">
                        <span class="material-symbols-outlined"
                              style="color: ${not empty totalFines and totalFines gt 0 ? 'var(--warning)' : 'var(--success)'};">payments</span>
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
                <p class="stat-label">Tiền phạt quá hạn</p>
                <p class="stat-value">
                    <c:choose>
                        <c:when test="${not empty totalFines}">
                            <fmt:formatNumber value="${totalFines}" type="number" maxFractionDigits="0"/> VNĐ
                        </c:when>
                        <c:otherwise>0 VNĐ</c:otherwise>
                    </c:choose>
                </p>
                <div class="mini-progress">
                    <div class="mini-progress-bar"
                         style="width: ${not empty totalFines and totalFines gt 0 ? '45' : '0'}%; background: ${not empty totalFines and totalFines gt 0 ? 'linear-gradient(90deg, #fde68a, var(--warning))' : 'linear-gradient(90deg, #a7f3d0, var(--success))'};"></div>
                </div>
            </div>
        </a>
    </div>

</section>
