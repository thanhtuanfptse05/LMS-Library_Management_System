<%-- Fragment: _section-stats.jsp — Quick Stats Grid (Active Loans, Due Soon, Reserved, Fines) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- ── Quick Stats Grid ── -->
<section class="row g-4 mb-5">
    <!-- Active Loans -->
    <div class="col-12 col-md-6 col-lg-3">
        <div class="raised-card p-4 d-flex align-items-center gap-3">
            <div class="rounded-3 d-flex align-items-center justify-content-center"
                 style="width: 48px; height: 48px; background-color: rgba(0, 99, 152, 0.1); color: var(--tertiary);">
                <span class="material-symbols-outlined">book_online</span>
            </div>
            <div>
                <p class="text-on-surface-variant text-uppercase mb-0 fw-semibold"
                   style="font-size: 11px; letter-spacing: 0.06em;">Active Loans</p>
                <p class="fs-4 fw-bold mb-0 text-dark">
                    <c:out value="${not empty activeLoansCount ? activeLoansCount : '0'}"/>
                </p>
            </div>
        </div>
    </div>

    <!-- Due Soon -->
    <div class="col-12 col-md-6 col-lg-3">
        <div class="raised-card p-4 d-flex align-items-center gap-3">
            <div class="rounded-3 d-flex align-items-center justify-content-center"
                 style="width: 48px; height: 48px; background-color: var(--error-container); color: var(--error);">
                <span class="material-symbols-outlined">schedule</span>
            </div>
            <div>
                <p class="text-on-surface-variant text-uppercase mb-0 fw-semibold"
                   style="font-size: 11px; letter-spacing: 0.06em;">Due Soon</p>
                <p class="fs-4 fw-bold mb-0 text-dark">
                    <c:out value="${not empty dueSoonCount ? dueSoonCount : '0'}"/>
                </p>
            </div>
        </div>
    </div>

    <!-- Reserved -->
    <div class="col-12 col-md-6 col-lg-3">
        <div class="raised-card p-4 d-flex align-items-center gap-3">
            <div class="rounded-3 d-flex align-items-center justify-content-center"
                 style="width: 48px; height: 48px; background-color: rgba(249, 115, 22, 0.1); color: var(--primary-container);">
                <span class="material-symbols-outlined">bookmarks</span>
            </div>
            <div>
                <p class="text-on-surface-variant text-uppercase mb-0 fw-semibold"
                   style="font-size: 11px; letter-spacing: 0.06em;">Reserved</p>
                <p class="fs-4 fw-bold mb-0 text-dark">
                    <c:out value="${not empty reservedCount ? reservedCount : '0'}"/>
                </p>
            </div>
        </div>
    </div>

    <!-- Overdue Fines -->
    <div class="col-12 col-md-6 col-lg-3">
        <div class="raised-card p-4 d-flex align-items-center gap-3">
            <div class="rounded-3 d-flex align-items-center justify-content-center"
                 style="width: 48px; height: 48px; background-color: var(--surface-container-high); color: var(--on-surface-variant);">
                <span class="material-symbols-outlined">payments</span>
            </div>
            <div>
                <p class="text-on-surface-variant text-uppercase mb-0 fw-semibold"
                   style="font-size: 11px; letter-spacing: 0.06em;">Overdue Fines</p>
                <p class="fs-4 fw-bold mb-0 text-dark">
                    <c:choose>
                        <c:when test="${not empty totalFines}">
                            <fmt:formatNumber value="${totalFines}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                        </c:when>
                        <c:otherwise>$0.00</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>
</section>
