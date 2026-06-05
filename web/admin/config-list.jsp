<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<%--
    Admin — System Configuration List
    Quản lý tham số nghiệp vụ của thư viện:
      - Số ngày tối đa được mượn (MAX_LOAN_DURATION_DAYS)
      - Số lượng sách mượn tối đa (MAX_BORROW_LIMIT)
      - Mức phí phạt quá hạn mỗi ngày (PENALTY_RATE_PER_DAY_VND)
      - Và các tham số khác trong bảng SystemConfigurations
    Fragment inventory:
        fragments/_head.jsp   — <head>: meta, CSS, custom styles
        fragments/_header.jsp — Fixed top navigation bar
        fragments/_sidebar.jsp — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-specific styles ── */
    .cfg-page-hero {
        background: linear-gradient(135deg, rgba(157,67,0,0.06) 0%, rgba(255,219,202,0.18) 60%, #fff8f6 100%);
        border-bottom: 1px solid var(--outline-variant);
        padding: 28px 0 24px;
    }

    /* ── Category section header ── */
    .cfg-section-header {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 14px 20px;
        background: var(--surface-container-low);
        border-bottom: 1px solid var(--outline-variant);
    }
    .cfg-section-header .csh-icon {
        width: 32px; height: 32px;
        border-radius: 8px;
        display: flex; align-items: center; justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    .cfg-section-header h2 {
        font-size: 14px;
        font-weight: 700;
        color: var(--on-surface);
        margin: 0;
        letter-spacing: 0.01em;
    }
    .cfg-section-header p {
        font-size: 12px;
        color: var(--on-surface-variant);
        margin: 0;
    }

    /* ── Config row ── */
    .cfg-row {
        display: flex;
        align-items: center;
        padding: 16px 20px;
        gap: 16px;
        border-bottom: 1px solid var(--outline-variant);
        transition: background-color 0.15s ease;
    }
    .cfg-row:last-child { border-bottom: none; }
    .cfg-row:hover { background-color: var(--surface-container-low); }

    .cfg-row__key {
        flex: 0 0 300px;
    }
    .cfg-row__key .key-name {
        font-family: 'Courier New', monospace;
        font-size: 13px;
        font-weight: 700;
        color: var(--on-surface);
        letter-spacing: 0.02em;
    }
    .cfg-row__key .key-desc {
        font-size: 12px;
        color: var(--on-surface-variant);
        margin-top: 2px;
        line-height: 1.4;
    }

    .cfg-row__value {
        flex: 1;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .cfg-value-display {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 8px;
        font-size: 15px;
        font-weight: 700;
        color: var(--on-surface);
        min-width: 100px;
    }
    .cfg-value-display .unit {
        font-size: 11px;
        font-weight: 500;
        color: var(--on-surface-variant);
        margin-left: 2px;
    }

    .cfg-row__meta {
        flex: 0 0 180px;
        text-align: right;
    }
    .cfg-row__meta .updated-by {
        font-size: 12px;
        color: var(--on-surface-variant);
    }
    .cfg-row__meta .updated-at {
        font-size: 11px;
        color: var(--on-surface-variant);
        opacity: 0.7;
    }

    .cfg-row__actions {
        flex: 0 0 auto;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    /* ── Tag / category badge ── */
    .cfg-category-tag {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 2px 8px;
        border-radius: 999px;
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
    }
    .cfg-category-tag.loan     { background: rgba(157,67,0,0.1);  color: var(--primary, #9d4300); }
    .cfg-category-tag.fine     { background: rgba(186,26,26,0.1); color: var(--error, #ba1a1a); }
    .cfg-category-tag.reserve  { background: rgba(0,99,152,0.1);  color: var(--tertiary, #006398); }
    .cfg-category-tag.system   { background: var(--surface-container-high); color: var(--on-surface-variant); }
    .cfg-category-tag.email    { background: rgba(22,163,74,0.1); color: #16a34a; }

    /* ── Status badge ── */
    .cfg-status {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        font-size: 11px;
        font-weight: 700;
        padding: 2px 8px;
        border-radius: 999px;
    }
    .cfg-status.active { background: rgba(22,163,74,0.1); color: #16a34a; }
    .cfg-status.inactive { background: var(--surface-container-high); color: var(--on-surface-variant); }

    /* ── Stats cards ── */
    .cfg-stat-card {
        background: var(--surface-container-lowest);
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
        padding: 16px 20px;
        display: flex;
        align-items: center;
        gap: 14px;
    }
    .cfg-stat-card .csc-icon {
        width: 44px; height: 44px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 22px;
        flex-shrink: 0;
    }
    .cfg-stat-card .csc-value { font-size: 22px; font-weight: 700; color: var(--on-surface); }
    .cfg-stat-card .csc-label { font-size: 12px; color: var(--on-surface-variant); }

    /* ── Search + filter bar ── */
    .cfg-filter-bar {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 20px;
        background: var(--surface-container-lowest);
        border-bottom: 1px solid var(--outline-variant);
        flex-wrap: wrap;
    }
    .cfg-search-wrap {
        position: relative;
        flex: 1;
        min-width: 200px;
    }
    .cfg-search-wrap .material-symbols-outlined {
        position: absolute;
        left: 10px; top: 50%;
        transform: translateY(-50%);
        font-size: 18px;
        color: var(--on-surface-variant);
        pointer-events: none;
    }
    .cfg-search-input {
        width: 100%;
        padding: 8px 12px 8px 36px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 8px;
        font-size: 13px;
        font-family: 'Inter', sans-serif;
        color: var(--on-surface);
        outline: none;
        transition: border-color 0.18s, box-shadow 0.18s;
    }
    .cfg-search-input:focus {
        border-color: var(--primary, #9d4300);
        box-shadow: 0 0 0 3px rgba(157,67,0,0.12);
    }
    .cfg-filter-select {
        padding: 8px 12px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 8px;
        font-size: 13px;
        font-family: 'Inter', sans-serif;
        color: var(--on-surface);
        outline: none;
        cursor: pointer;
    }
    .cfg-filter-select:focus { border-color: var(--primary, #9d4300); }

    /* ── Action buttons ── */
    .btn-cfg-primary {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 9px 18px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        background: var(--primary, #9d4300); color: #fff;
        border: none; cursor: pointer;
        transition: transform 0.15s, filter 0.15s;
        text-decoration: none;
    }
    .btn-cfg-primary:hover { filter: brightness(110%); transform: scale(1.02); color: #fff; }
    .btn-cfg-primary:active { transform: scale(0.98); }
    .btn-cfg-primary .material-symbols-outlined { font-size: 17px; }

    .btn-cfg-outline {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 8px 16px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        background: transparent; color: var(--on-surface-variant);
        border: 1.5px solid var(--outline-variant); cursor: pointer;
        transition: all 0.15s;
    }
    .btn-cfg-outline:hover { border-color: var(--primary, #9d4300); color: var(--primary, #9d4300); }
    .btn-cfg-outline .material-symbols-outlined { font-size: 17px; }

    /* ── Responsive ── */
    @media (max-width: 991.98px) {
        .d-flex.main-wrapper main { margin-left: 0 !important; }
        .cfg-row { flex-wrap: wrap; }
        .cfg-row__key { flex: 0 0 100%; }
        .cfg-row__meta { display: none; }
    }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb; margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <!-- ══ Page Container ══ -->
            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Page Header ─── -->
                <div class="d-flex align-items-start justify-content-between flex-wrap gap-3 mb-4">
                    <div>
                        <nav aria-label="breadcrumb" style="margin-bottom: 6px;">
                            <ol class="breadcrumb mb-0" style="font-size: 12px;">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                       class="text-decoration-none text-on-surface-variant">Bảng điều khiển</a>
                                </li>
                                <li class="breadcrumb-item active fw-semibold text-primary-custom"
                                    aria-current="page">System Cấu hình</li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">settings</span>
                            System Cấu hình
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            Manage library operational parameters: loan limits, fine rates, and system behaviour settings.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <button class="btn-cfg-outline" id="btnExportConfig"
                                aria-label="Export configuration as JSON">
                            <span class="material-symbols-outlined">download</span>
                            Export
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp"
                           class="btn-cfg-outline text-decoration-none" aria-label="View audit logs">
                            <span class="material-symbols-outlined">history</span>
                            Audit Lịch sử
                        </a>
                    </div>
                </div>

                <!-- ─── Stats Row ─── -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-xl-3">
                        <div class="cfg-stat-card">
                            <div class="csc-icon" style="background: rgba(157,67,0,0.1);">
                                <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">tune</span>
                            </div>
                            <div>
                                <div class="csc-value">
                                    <c:out value="${totalConfigs != null ? totalConfigs : '12'}" />
                                </div>
                                <div class="csc-label">Total Parameters</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-xl-3">
                        <div class="cfg-stat-card">
                            <div class="csc-icon" style="background: rgba(22,163,74,0.1);">
                                <span class="material-symbols-outlined" style="color: #16a34a;">check_circle</span>
                            </div>
                            <div>
                                <div class="csc-value" style="color: #16a34a;">
                                    <c:out value="${activeConfigs != null ? activeConfigs : '12'}" />
                                </div>
                                <div class="csc-label">Hoạt động</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-xl-3">
                        <div class="cfg-stat-card">
                            <div class="csc-icon" style="background: rgba(0,99,152,0.1);">
                                <span class="material-symbols-outlined" style="color: var(--tertiary,#006398);">update</span>
                            </div>
                            <div>
                                <div class="csc-value" style="color: var(--tertiary,#006398);">
                                    <c:out value="${recentChanges != null ? recentChanges : '3'}" />
                                </div>
                                <div class="csc-label">Changed Hôm nay</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-xl-3">
                        <div class="cfg-stat-card">
                            <div class="csc-icon" style="background: rgba(234,179,8,0.1);">
                                <span class="material-symbols-outlined" style="color: #854d0e;">pending_actions</span>
                            </div>
                            <div>
                                <div class="csc-value" style="color: #854d0e;">
                                    <c:out value="${pendingReview != null ? pendingReview : '0'}" />
                                </div>
                                <div class="csc-label">Chờ duyệt Review</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ─── Main Config Table Card ─── -->
                <div class="raised-card overflow-hidden">

                    <!-- Filter Bar -->
                    <div class="cfg-filter-bar">
                        <div class="cfg-search-wrap">
                            <span class="material-symbols-outlined">search</span>
                            <input type="search" class="cfg-search-input" id="cfgSearchInput"
                                   placeholder="Search parameter key or description…"
                                   aria-label="Search configurations" />
                        </div>
                        <select class="cfg-filter-select" id="cfgCategoryFilter" aria-label="Filter by category">
                            <option value="all">All Thể loại</option>
                            <option value="loan">Loan Rules</option>
                            <option value="fine">Fine &amp; Penalty</option>
                            <option value="reserve">Đặt trước</option>
                            <option value="email">Email &amp; Thông báo</option>
                            <option value="system">System</option>
                        </select>
                        <select class="cfg-filter-select" id="cfgStatusFilter" aria-label="Filter by status">
                            <option value="all">All Trạng thái</option>
                            <option value="active">Hoạt động</option>
                            <option value="inactive">Không hoạt động</option>
                        </select>
                        <span id="cfgResultCount" style="font-size: 12px; color: var(--on-surface-variant); white-space: nowrap;">
                            12 parameters
                        </span>
                    </div>

                    <!-- ══ LOAN RULES Section ══ -->
                    <div class="cfg-section" data-category="loan">
                        <div class="cfg-section-header">
                            <div class="csh-icon" style="background: rgba(157,67,0,0.1);">
                                <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">book</span>
                            </div>
                            <div>
                                <h2>Loan Rules</h2>
                                <p>Parameters governing borrowing duration and quantity</p>
                            </div>
                        </div>

                        <!-- MAX_LOAN_DURATION_DAYS -->
                        <div class="cfg-row" data-category="loan" data-key="MAX_LOAN_DURATION_DAYS">
                            <div class="cfg-row__key">
                                <div class="key-name">MAX_LOAN_DURATION_DAYS</div>
                                <div class="key-desc">Maximum number of calendar days a member can borrow a book without renewal.</div>
                                <span class="cfg-category-tag loan mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">book</span>
                                    Loan
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display">
                                    <c:out value="${sysConfig.maxLoanDurationDays != null ? sysConfig.maxLoanDurationDays : '21'}" />
                                    <span class="unit">days</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">
                                    By: <c:out value="${sysConfig.maxLoanUpdatedBy != null ? sysConfig.maxLoanUpdatedBy : 'admin_root'}" />
                                </div>
                                <div class="updated-at">
                                    <c:choose>
                                        <c:when test="${not empty sysConfig.maxLoanUpdatedAt}">
                                            <fmt:formatDate value="${sysConfig.maxLoanUpdatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>03/06/2026 09:00</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=MAX_LOAN_DURATION_DAYS"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit MAX_LOAN_DURATION_DAYS">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=MAX_LOAN_DURATION_DAYS"
                                   class="btn-icon" title="View change history" aria-label="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- MAX_BORROW_LIMIT -->
                        <div class="cfg-row" data-category="loan" data-key="MAX_BORROW_LIMIT">
                            <div class="cfg-row__key">
                                <div class="key-name">MAX_BORROW_LIMIT</div>
                                <div class="key-desc">Maximum number of books a single member can borrow simultaneously.</div>
                                <span class="cfg-category-tag loan mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">book</span>
                                    Loan
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display">
                                    <c:out value="${sysConfig.maxBorrowLimit != null ? sysConfig.maxBorrowLimit : '5'}" />
                                    <span class="unit">books</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">01/06/2026 14:30</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=MAX_BORROW_LIMIT"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit MAX_BORROW_LIMIT">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=MAX_BORROW_LIMIT"
                                   class="btn-icon" title="View change history" aria-label="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- AUTO_RENEW_LIMIT -->
                        <div class="cfg-row" data-category="loan" data-key="AUTO_RENEW_LIMIT">
                            <div class="cfg-row__key">
                                <div class="key-name">AUTO_RENEW_LIMIT</div>
                                <div class="key-desc">Maximum number of times a loan can be renewed (extended) before forced return.</div>
                                <span class="cfg-category-tag loan mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">book</span>
                                    Loan
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display">
                                    <c:out value="${sysConfig.autoRenewLimit != null ? sysConfig.autoRenewLimit : '2'}" />
                                    <span class="unit">renewals</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">01/06/2026 14:30</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=AUTO_RENEW_LIMIT"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit AUTO_RENEW_LIMIT">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=AUTO_RENEW_LIMIT"
                                   class="btn-icon" title="View change history" aria-label="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- ══ FINE & PENALTY Section ══ -->
                    <div class="cfg-section" data-category="fine">
                        <div class="cfg-section-header">
                            <div class="csh-icon" style="background: rgba(186,26,26,0.1);">
                                <span class="material-symbols-outlined" style="color: var(--error,#ba1a1a);">payments</span>
                            </div>
                            <div>
                                <h2>Fine &amp; Penalty</h2>
                                <p>Overdue fine rates and damage compensation rules</p>
                            </div>
                        </div>

                        <!-- PENALTY_RATE_PER_DAY_VND -->
                        <div class="cfg-row" data-category="fine" data-key="PENALTY_RATE_PER_DAY_VND">
                            <div class="cfg-row__key">
                                <div class="key-name">PENALTY_RATE_PER_DAY_VND</div>
                                <div class="key-desc">Late return fine applied per calendar day after the due date. Unit: VND.</div>
                                <span class="cfg-category-tag fine mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">payments</span>
                                    Fine
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: var(--error,#ba1a1a);">
                                    <c:out value="${sysConfig.penaltyRatePerDayVnd != null ? sysConfig.penaltyRatePerDayVnd : '5,000'}" />
                                    <span class="unit">VND/day</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_maria</div>
                                <div class="updated-at">03/06/2026 14:22</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=PENALTY_RATE_PER_DAY_VND"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit PENALTY_RATE_PER_DAY_VND">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=PENALTY_RATE_PER_DAY_VND"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- MAX_FINE_CAP_VND -->
                        <div class="cfg-row" data-category="fine" data-key="MAX_FINE_CAP_VND">
                            <div class="cfg-row__key">
                                <div class="key-name">MAX_FINE_CAP_VND</div>
                                <div class="key-desc">Maximum total fine amount a member can accumulate per single book loan. Unit: VND.</div>
                                <span class="cfg-category-tag fine mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">payments</span>
                                    Fine
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: var(--error,#ba1a1a);">
                                    <c:out value="${sysConfig.maxFineCapVnd != null ? sysConfig.maxFineCapVnd : '200,000'}" />
                                    <span class="unit">VND</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">28/05/2026 10:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=MAX_FINE_CAP_VND"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit MAX_FINE_CAP_VND">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=MAX_FINE_CAP_VND"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- ══ RESERVATIONS Section ══ -->
                    <div class="cfg-section" data-category="reserve">
                        <div class="cfg-section-header">
                            <div class="csh-icon" style="background: rgba(0,99,152,0.1);">
                                <span class="material-symbols-outlined" style="color: var(--tertiary,#006398);">bookmark</span>
                            </div>
                            <div>
                                <h2>Đặt trước</h2>
                                <p>Sách reservation expiry and queue behaviour</p>
                            </div>
                        </div>

                        <!-- RESERVATION_EXPIRY_HRS -->
                        <div class="cfg-row" data-category="reserve" data-key="RESERVATION_EXPIRY_HRS">
                            <div class="cfg-row__key">
                                <div class="key-name">RESERVATION_EXPIRY_HRS</div>
                                <div class="key-desc">Hours a reserved book is held at the desk before the reservation expires and releases the copy.</div>
                                <span class="cfg-category-tag reserve mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">bookmark</span>
                                    Reservation
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: var(--tertiary,#006398);">
                                    <c:out value="${sysConfig.reservationExpiryHrs != null ? sysConfig.reservationExpiryHrs : '48'}" />
                                    <span class="unit">hrs</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">01/06/2026 14:30</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=RESERVATION_EXPIRY_HRS"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit RESERVATION_EXPIRY_HRS">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=RESERVATION_EXPIRY_HRS"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- MAX_RESERVATION_QUEUE -->
                        <div class="cfg-row" data-category="reserve" data-key="MAX_RESERVATION_QUEUE">
                            <div class="cfg-row__key">
                                <div class="key-name">MAX_RESERVATION_QUEUE</div>
                                <div class="key-desc">Maximum number of members that can queue for the same book title simultaneously.</div>
                                <span class="cfg-category-tag reserve mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">bookmark</span>
                                    Reservation
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: var(--tertiary,#006398);">
                                    <c:out value="${sysConfig.maxReservationQueue != null ? sysConfig.maxReservationQueue : '10'}" />
                                    <span class="unit">members</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">28/05/2026 10:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=MAX_RESERVATION_QUEUE"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit MAX_RESERVATION_QUEUE">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=MAX_RESERVATION_QUEUE"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- ══ EMAIL & NOTIFICATIONS Section ══ -->
                    <div class="cfg-section" data-category="email">
                        <div class="cfg-section-header">
                            <div class="csh-icon" style="background: rgba(22,163,74,0.1);">
                                <span class="material-symbols-outlined" style="color: #16a34a;">email</span>
                            </div>
                            <div>
                                <h2>Email &amp; Thông báo</h2>
                                <p>OTP expiry, reminder windows, and SMTP settings</p>
                            </div>
                        </div>

                        <!-- OTP_EXPIRY_MINUTES -->
                        <div class="cfg-row" data-category="email" data-key="OTP_EXPIRY_MINUTES">
                            <div class="cfg-row__key">
                                <div class="key-name">OTP_EXPIRY_MINUTES</div>
                                <div class="key-desc">Minutes before a One-Time Mật khẩu (OTP) for password reset expires and becomes invalid.</div>
                                <span class="cfg-category-tag email mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">email</span>
                                    Email
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: #16a34a;">
                                    <c:out value="${sysConfig.otpExpiryMinutes != null ? sysConfig.otpExpiryMinutes : '10'}" />
                                    <span class="unit">min</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">20/05/2026 08:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=OTP_EXPIRY_MINUTES"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit OTP_EXPIRY_MINUTES">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=OTP_EXPIRY_MINUTES"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- DUE_REMINDER_DAYS_BEFORE -->
                        <div class="cfg-row" data-category="email" data-key="DUE_REMINDER_DAYS_BEFORE">
                            <div class="cfg-row__key">
                                <div class="key-name">DUE_REMINDER_DAYS_BEFORE</div>
                                <div class="key-desc">Days before the due date to send the automatic return reminder email to the borrower.</div>
                                <span class="cfg-category-tag email mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">email</span>
                                    Email
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display" style="color: #16a34a;">
                                    <c:out value="${sysConfig.dueReminderDaysBefore != null ? sysConfig.dueReminderDaysBefore : '3'}" />
                                    <span class="unit">days</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">20/05/2026 08:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=DUE_REMINDER_DAYS_BEFORE"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit DUE_REMINDER_DAYS_BEFORE">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=DUE_REMINDER_DAYS_BEFORE"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- ══ SYSTEM Section ══ -->
                    <div class="cfg-section" data-category="system">
                        <div class="cfg-section-header">
                            <div class="csh-icon" style="background: var(--surface-container-high);">
                                <span class="material-symbols-outlined" style="color: var(--on-surface-variant);">settings_applications</span>
                            </div>
                            <div>
                                <h2>System</h2>
                                <p>General system-level controls and session parameters</p>
                            </div>
                        </div>

                        <!-- SESSION_TIMEOUT_MINUTES -->
                        <div class="cfg-row" data-category="system" data-key="SESSION_TIMEOUT_MINUTES">
                            <div class="cfg-row__key">
                                <div class="key-name">SESSION_TIMEOUT_MINUTES</div>
                                <div class="key-desc">Minutes of user inactivity before an authenticated session is automatically invalidated.</div>
                                <span class="cfg-category-tag system mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">settings_applications</span>
                                    System
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display">
                                    <c:out value="${sysConfig.sessionTimeoutMinutes != null ? sysConfig.sessionTimeoutMinutes : '30'}" />
                                    <span class="unit">min</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">15/05/2026 11:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=SESSION_TIMEOUT_MINUTES"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit SESSION_TIMEOUT_MINUTES">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=SESSION_TIMEOUT_MINUTES"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>

                        <!-- MAX_LOGIN_ATTEMPTS -->
                        <div class="cfg-row" data-category="system" data-key="MAX_LOGIN_ATTEMPTS">
                            <div class="cfg-row__key">
                                <div class="key-name">MAX_LOGIN_ATTEMPTS</div>
                                <div class="key-desc">Maximum consecutive failed login attempts before an account is temporarily locked.</div>
                                <span class="cfg-category-tag system mt-1">
                                    <span class="material-symbols-outlined" style="font-size: 10px;">settings_applications</span>
                                    System
                                </span>
                            </div>
                            <div class="cfg-row__value">
                                <div class="cfg-value-display">
                                    <c:out value="${sysConfig.maxLoginAttempts != null ? sysConfig.maxLoginAttempts : '5'}" />
                                    <span class="unit">attempts</span>
                                </div>
                                <span class="cfg-status active">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                    Hoạt động
                                </span>
                            </div>
                            <div class="cfg-row__meta">
                                <div class="updated-by">By: admin_root</div>
                                <div class="updated-at">15/05/2026 11:00</div>
                            </div>
                            <div class="cfg-row__actions">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=MAX_LOGIN_ATTEMPTS"
                                   class="btn-icon" title="Chỉnh sửa tham số" aria-label="Edit MAX_LOGIN_ATTEMPTS">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=MAX_LOGIN_ATTEMPTS"
                                   class="btn-icon" title="View change history">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">history</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Table footer -->
                    <div class="p-3 d-flex align-items-center justify-content-between flex-wrap gap-2"
                         style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-lowest);">
                        <span style="font-size: 12px; color: var(--on-surface-variant);">
                            Showing <strong>12</strong> configuration parameters · Last sync: <strong>Just now</strong>
                        </span>
                        <button class="btn-cfg-outline" id="btnAddConfig" aria-label="Add new configuration parameter"
                                style="font-size: 12px; padding: 6px 14px;">
                            <span class="material-symbols-outlined" style="font-size: 15px;">add</span>
                            Thêm Parameter
                        </button>
                    </div>
                </div><!-- /.raised-card -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

<script>
/* ── Sidebar active state ── */
(function() {
    var links = document.querySelectorAll('aside .sidebar-link');
    links.forEach(function(l) { l.classList.remove('active'); });
    links.forEach(function(l) {
        if (l.href && l.href.indexOf('config') !== -1) l.classList.add('active');
    });
})();

/* ── Client-side search & filter ── */
var searchInput   = document.getElementById('cfgSearchInput');
var catFilter     = document.getElementById('cfgCategoryFilter');
var statusFilter  = document.getElementById('cfgStatusFilter');
var resultCount   = document.getElementById('cfgResultCount');

function applyFilters() {
    var q   = searchInput.value.toLowerCase().trim();
    var cat = catFilter.value;
    var rows = document.querySelectorAll('.cfg-row');
    var visible = 0;

    rows.forEach(function(row) {
        var rowCat = row.getAttribute('data-category') || '';
        var rowKey = (row.getAttribute('data-key') || '').toLowerCase();
        var rowText = row.textContent.toLowerCase();

        var matchCat  = (cat === 'all' || rowCat === cat);
        var matchText = (!q || rowKey.indexOf(q) !== -1 || rowText.indexOf(q) !== -1);

        var show = matchCat && matchText;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    /* Hide entire section if all its rows are hidden */
    document.querySelectorAll('.cfg-section').forEach(function(section) {
        var sectionCat = section.getAttribute('data-category');
        var hasVisible = false;
        section.querySelectorAll('.cfg-row').forEach(function(r) {
            if (r.style.display !== 'none') hasVisible = true;
        });
        section.style.display = hasVisible ? '' : 'none';
    });

    resultCount.textContent = visible + ' parameter' + (visible !== 1 ? 's' : '');
}

if (searchInput) searchInput.addEventListener('input', applyFilters);
if (catFilter)   catFilter.addEventListener('change', applyFilters);
if (statusFilter) statusFilter.addEventListener('change', applyFilters);

/* ── Export stub ── */
var btnExport = document.getElementById('btnExportConfig');
if (btnExport) {
    btnExport.addEventListener('click', function() {
        alert('Export: This will generate a JSON snapshot of all current configuration values.');
    });
}

/* ── Add Parameter stub ── */
var btnAdd = document.getElementById('btnAddConfig');
if (btnAdd) {
    btnAdd.addEventListener('click', function() {
        window.location = '${pageContext.request.contextPath}/admin/config-edit.jsp?mode=create';
    });
}
</script>

</body>
</html>
