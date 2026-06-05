<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<%--
    Admin — Audit Logs
    Hiển thị lịch sử thao tác của các thủ thư/admin.
    Theo dõi: ai đã thêm/sửa/xóa thông tin gì, lúc nào, trên bảng nào.
    Tương ứng với bảng AuditLogs trong DB.
    Query param: ?key=PARAM_KEY (optional, filter by config key)
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── KPI Strip ── */
    .audit-kpi-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 16px;
        margin-bottom: 24px;
    }
    @media (max-width: 992px) { .audit-kpi-row { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 576px) { .audit-kpi-row { grid-template-columns: 1fr; } }

    .audit-kpi-card {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
        padding: 16px 20px;
        display: flex;
        align-items: center;
        gap: 14px;
    }
    .audit-kpi-card .akc-icon {
        width: 42px; height: 42px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 21px;
        flex-shrink: 0;
    }
    .audit-kpi-card .akc-value { font-size: 22px; font-weight: 700; color: var(--on-surface); line-height: 1; }
    .audit-kpi-card .akc-label { font-size: 12px; color: var(--on-surface-variant); margin-top: 2px; }

    /* ── Filter bar ── */
    .audit-filter-bar {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 14px 20px;
        background: var(--surface-container-lowest, #fff);
        border-bottom: 1px solid var(--outline-variant);
        flex-wrap: wrap;
    }
    .audit-search-wrap { position: relative; flex: 1; min-width: 200px; }
    .audit-search-wrap .material-symbols-outlined {
        position: absolute; left: 10px; top: 50%;
        transform: translateY(-50%); font-size: 17px;
        color: var(--on-surface-variant); pointer-events: none;
    }
    .audit-search-input {
        width: 100%; padding: 8px 12px 8px 34px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant); border-radius: 8px;
        font-size: 13px; font-family: 'Inter', sans-serif;
        color: var(--on-surface); outline: none;
        transition: border-color 0.18s, box-shadow 0.18s;
    }
    .audit-search-input:focus {
        border-color: var(--primary, #9d4300);
        box-shadow: 0 0 0 3px rgba(157,67,0,0.1);
    }
    .audit-filter-select {
        padding: 8px 12px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant); border-radius: 8px;
        font-size: 13px; font-family: 'Inter', sans-serif;
        color: var(--on-surface); outline: none; cursor: pointer;
    }
    .audit-filter-select:focus { border-color: var(--primary, #9d4300); }

    /* ── Action type badges ── */
    .action-badge {
        display: inline-flex; align-items: center; gap: 4px;
        padding: 3px 10px; border-radius: 999px;
        font-size: 11px; font-weight: 700; letter-spacing: 0.05em;
        text-transform: uppercase;
    }
    .action-badge.create { background: rgba(22,163,74,0.1); color: #16a34a; }
    .action-badge.update { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); }
    .action-badge.delete { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .action-badge.login  { background: rgba(157,67,0,0.1); color: var(--primary, #9d4300); }
    .action-badge.failed { background: rgba(186,26,26,0.08); color: #9f1239; border: 1px solid rgba(186,26,26,0.2); }
    .action-badge.export { background: rgba(234,179,8,0.1); color: #854d0e; }
    .action-badge.config { background: var(--surface-container-high); color: var(--on-surface-variant); }

    /* ── Severity indicator ── */
    .severity-dot {
        width: 8px; height: 8px; border-radius: 50%;
        display: inline-block; flex-shrink: 0;
    }
    .severity-dot.high   { background: var(--error, #ba1a1a); box-shadow: 0 0 0 3px rgba(186,26,26,0.15); }
    .severity-dot.medium { background: #d97706; }
    .severity-dot.low    { background: #16a34a; }
    .severity-dot.info   { background: var(--tertiary, #006398); }

    /* ── Table column widths ── */
    .audit-table thead th { white-space: nowrap; }
    .col-ts    { width: 140px; }
    .col-user  { width: 160px; }
    .col-action { width: 120px; }
    .col-entity { width: 130px; }
    .col-detail { min-width: 200px; }
    .col-ip    { width: 120px; }
    .col-sev   { width: 80px; text-align: center; }
    .col-act   { width: 70px; text-align: center; }

    /* ── Row hover / expanded ── */
    .audit-row { cursor: pointer; }
    .audit-row:hover { background-color: var(--surface-container-low) !important; }
    .audit-row.is-high td:first-child {
        border-left: 3px solid var(--error, #ba1a1a);
    }
    .audit-row.is-medium td:first-child {
        border-left: 3px solid #d97706;
    }

    /* ── Detail delta snippet ── */
    .delta-snippet {
        font-family: 'Courier New', monospace;
        font-size: 11px;
        background: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 6px;
        padding: 4px 8px;
        color: var(--on-surface-variant);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 260px;
        display: inline-block;
    }

    /* ── Pagination ── */
    .audit-pagination {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 20px;
        background: var(--surface-container-lowest, #fff);
        border-top: 1px solid var(--outline-variant);
        flex-wrap: wrap;
        gap: 10px;
    }
    .pagination-btn {
        display: inline-flex; align-items: center;
        padding: 6px 12px; border-radius: 6px;
        font-size: 13px; font-weight: 600;
        border: 1px solid var(--outline-variant);
        background: transparent; color: var(--on-surface-variant);
        cursor: pointer; gap: 4px;
        transition: all 0.15s;
    }
    .pagination-btn:hover:not(:disabled) { border-color: var(--primary, #9d4300); color: var(--primary, #9d4300); }
    .pagination-btn:disabled { opacity: 0.4; cursor: not-allowed; }
    .pagination-btn.active { background: var(--primary, #9d4300); color: #fff; border-color: var(--primary, #9d4300); }
    .pagination-btn .material-symbols-outlined { font-size: 16px; }

    /* ── Export button ── */
    .btn-audit-export {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 9px 18px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        background: var(--primary, #9d4300); color: #fff;
        border: none; cursor: pointer;
        transition: transform 0.15s, filter 0.15s;
    }
    .btn-audit-export:hover { filter: brightness(110%); transform: scale(1.02); }
    .btn-audit-export .material-symbols-outlined { font-size: 16px; }

    /* ── Live indicator ── */
    .live-badge {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 4px 10px; border-radius: 999px;
        font-size: 11px; font-weight: 700;
        background: rgba(22,163,74,0.1); color: #16a34a;
    }
    .live-dot {
        width: 7px; height: 7px; border-radius: 50%;
        background: #16a34a; animation: pulse 2s infinite;
    }

    /* ── Avatar ── */
    .user-avatar {
        width: 28px; height: 28px; border-radius: 50%;
        display: inline-flex; align-items: center; justify-content: center;
        font-size: 10px; font-weight: 700; flex-shrink: 0;
    }

    /* ── Responsive ── */
    @media (max-width: 991.98px) {
        .d-flex.main-wrapper main { margin-left: 0 !important; }
    }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <div class="d-flex main-wrapper overflow-hidden">
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb; margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

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
                                    aria-current="page">Nhật ký Kiểm toán</li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">receipt_long</span>
                            Nhật ký Kiểm toán
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            Complete record of all system operations — who did what, when, and on which entity.
                            <c:if test="${not empty param.key}">
                                Filtered to key: <strong><c:out value="${param.key}" /></strong>.
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp"
                                   class="text-primary-custom text-decoration-none fw-bold" style="font-size: 13px;">Xóa filter ×</a>
                            </c:if>
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <span class="live-badge" aria-label="Live stream active">
                            <span class="live-dot"></span>
                            LIVE
                        </span>
                        <button class="btn-audit-export" id="btnExportLogs" aria-label="Export audit logs as CSV">
                            <span class="material-symbols-outlined">download</span>
                            Export CSV
                        </button>
                    </div>
                </div>

                <!-- ─── KPI Cards ─── -->
                <div class="audit-kpi-row">
                    <div class="audit-kpi-card">
                        <div class="akc-icon" style="background: rgba(157,67,0,0.1);">
                            <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">receipt_long</span>
                        </div>
                        <div>
                            <div class="akc-value"><c:out value="${totalLogs != null ? totalLogs : '12,847'}" /></div>
                            <div class="akc-label">Total Log Entries</div>
                        </div>
                    </div>
                    <div class="audit-kpi-card">
                        <div class="akc-icon" style="background: rgba(186,26,26,0.1);">
                            <span class="material-symbols-outlined" style="color: var(--error,#ba1a1a);">gpp_bad</span>
                        </div>
                        <div>
                            <div class="akc-value" style="color: var(--error,#ba1a1a);">
                                <c:out value="${highSeverityToday != null ? highSeverityToday : '3'}" />
                            </div>
                            <div class="akc-label">High-Severity Hôm nay</div>
                        </div>
                    </div>
                    <div class="audit-kpi-card">
                        <div class="akc-icon" style="background: rgba(0,99,152,0.1);">
                            <span class="material-symbols-outlined" style="color: var(--tertiary,#006398);">manage_accounts</span>
                        </div>
                        <div>
                            <div class="akc-value" style="color: var(--tertiary,#006398);">
                                <c:out value="${activeAdminCount != null ? activeAdminCount : '7'}" />
                            </div>
                            <div class="akc-label">Hoạt động Operators</div>
                        </div>
                    </div>
                    <div class="audit-kpi-card">
                        <div class="akc-icon" style="background: rgba(22,163,74,0.1);">
                            <span class="material-symbols-outlined" style="color: #16a34a;">update</span>
                        </div>
                        <div>
                            <div class="akc-value" style="color: #16a34a;">
                                <c:out value="${logsToday != null ? logsToday : '142'}" />
                            </div>
                            <div class="akc-label">Entries Hôm nay</div>
                        </div>
                    </div>
                </div>

                <!-- ─── Main Table Card ─── -->
                <div class="raised-card overflow-hidden">

                    <!-- Filter Bar -->
                    <div class="audit-filter-bar">
                        <div class="audit-search-wrap">
                            <span class="material-symbols-outlined">search</span>
                            <input type="search" id="auditSearchInput" class="audit-search-input"
                                   placeholder="Search by user, action, entity, or IP…"
                                   value="${not empty param.q ? param.q : ''}"
                                   aria-label="Search audit logs" />
                        </div>
                        <select class="audit-filter-select" id="actionTypeFilter" aria-label="Filter by action type">
                            <option value="all">All Hành động</option>
                            <option value="CREATE">CREATE</option>
                            <option value="UPDATE">UPDATE</option>
                            <option value="DELETE">DELETE</option>
                            <option value="LOGIN">LOGIN</option>
                            <option value="FAILED_LOGIN">FAILED LOGIN</option>
                            <option value="EXPORT">EXPORT</option>
                            <option value="CONFIG_CHANGE">CONFIG CHANGE</option>
                        </select>
                        <select class="audit-filter-select" id="severityFilter" aria-label="Filter by severity">
                            <option value="all">All Severity</option>
                            <option value="high">High</option>
                            <option value="medium">Medium</option>
                            <option value="low">Low</option>
                            <option value="info">Info</option>
                        </select>
                        <select class="audit-filter-select" id="dateRangeFilter" aria-label="Filter by date range">
                            <option value="today">Hôm nay</option>
                            <option value="week" selected>This Week</option>
                            <option value="month">This Month</option>
                            <option value="all">All Time</option>
                        </select>
                        <span id="auditResultCount" style="font-size: 12px; color: var(--on-surface-variant); white-space: nowrap;">
                            142 entries
                        </span>
                    </div>

                    <!-- Table -->
                    <div class="table-responsive">
                        <table class="table table-lms mb-0" id="auditTable" aria-label="Audit log entries">
                            <thead>
                                <tr>
                                    <th class="col-ts" scope="col">Timestamp</th>
                                    <th class="col-user" scope="col">Operator</th>
                                    <th class="col-action" scope="col">Hành động</th>
                                    <th class="col-entity" scope="col">Entity / Table</th>
                                    <th class="col-detail" scope="col">Chi tiết / Change</th>
                                    <th class="col-ip" scope="col">IP Địa chỉ</th>
                                    <th class="col-sev" scope="col">Severity</th>
                                    <th class="col-act" scope="col">Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty auditLogs}">
                                        <c:forEach var="log" items="${auditLogs}">
                                            <tr class="audit-row is-${log.severity == 'HIGH' ? 'high' : log.severity == 'MEDIUM' ? 'medium' : 'low'}"
                                                data-action="${log.actionType}"
                                                data-severity="${fn:toLowerCase(log.severity)}"
                                                data-id="${log.id}">
                                                <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                    <fmt:formatDate value="${log.timestamp}" pattern="dd/MM/yyyy" /><br/>
                                                    <strong style="color: var(--on-surface);">
                                                        <fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" />
                                                    </strong>
                                                </td>
                                                <td class="col-user">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">
                                                            <c:out value="${fn:toUpperCase(fn:substring(log.performedBy, 0, 2))}" />
                                                        </div>
                                                        <span style="font-size: 13px; font-weight: 600;"><c:out value="${log.performedBy}" /></span>
                                                    </div>
                                                </td>
                                                <td class="col-action">
                                                    <span class="action-badge ${fn:toLowerCase(log.actionType) == 'create' ? 'create' : fn:toLowerCase(log.actionType) == 'update' ? 'update' : fn:toLowerCase(log.actionType) == 'delete' ? 'delete' : fn:toLowerCase(log.actionType) == 'login' ? 'login' : fn:toLowerCase(log.actionType) == 'failed_login' ? 'failed' : 'config'}">
                                                        <c:out value="${log.actionType}" />
                                                    </span>
                                                </td>
                                                <td class="col-entity" style="font-size: 13px; font-weight: 600;">
                                                    <c:out value="${log.tableName}" />
                                                    <c:if test="${not empty log.entityId}">
                                                        <br/><span style="font-size: 11px; color: var(--on-surface-variant); font-weight: 400;">
                                                            #<c:out value="${log.entityId}" />
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td class="col-detail">
                                                    <span class="delta-snippet">
                                                        <c:out value="${log.details}" />
                                                    </span>
                                                </td>
                                                <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">
                                                    <c:out value="${log.ipAddress}" />
                                                </td>
                                                <td class="col-sev" style="text-align: center;">
                                                    <span class="severity-dot ${fn:toLowerCase(log.severity)}" title="${log.severity}"></span>
                                                </td>
                                                <td class="col-act" style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=${log.id}"
                                                       class="btn-icon" title="View detail" aria-label="View audit log detail">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Demo rows --%>
                                        <tr class="audit-row is-high" data-action="FAILED_LOGIN" data-severity="high">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                04/06/2026<br/><strong style="color: var(--on-surface);">14:22:35</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: var(--error-container); color: var(--error);">UN</div>
                                                    <span style="font-size: 13px; font-weight: 600; color: var(--error);">Unknown</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge failed">FAILED LOGIN</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">Users</td>
                                            <td class="col-detail"><span class="delta-snippet">5 consecutive failures — j.doe@uni.edu</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--error);">192.168.1.142</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot high" title="HIGH"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-001"
                                                   class="btn-icon" title="View detail" aria-label="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                        <tr class="audit-row" data-action="CONFIG_CHANGE" data-severity="medium">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                04/06/2026<br/><strong style="color: var(--on-surface);">14:22:01</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">AM</div>
                                                    <span style="font-size: 13px; font-weight: 600;">admin_maria</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge config">CONFIG CHANGE</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">SystemConfigurations</td>
                                            <td class="col-detail"><span class="delta-snippet">PENALTY_RATE: 2500 → 5000</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">10.0.0.5</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot medium" title="MEDIUM"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-002"
                                                   class="btn-icon" title="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                        <tr class="audit-row" data-action="UPDATE" data-severity="low">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                04/06/2026<br/><strong style="color: var(--on-surface);">13:55:12</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">LJ</div>
                                                    <span style="font-size: 13px; font-weight: 600;">lib_john</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge update">UPDATE</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">BorrowRecords
                                                <br/><span style="font-size: 11px; color: var(--on-surface-variant); font-weight:400;">#BR-2026-441</span>
                                            </td>
                                            <td class="col-detail"><span class="delta-snippet">status: ACTIVE → RETURNED</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">10.0.0.12</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot low" title="LOW"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-003"
                                                   class="btn-icon" title="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                        <tr class="audit-row" data-action="CREATE" data-severity="low">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                04/06/2026<br/><strong style="color: var(--on-surface);">13:10:44</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">LJ</div>
                                                    <span style="font-size: 13px; font-weight: 600;">lib_john</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge create">CREATE</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">BorrowRecords
                                                <br/><span style="font-size: 11px; color: var(--on-surface-variant); font-weight:400;">#BR-2026-442</span>
                                            </td>
                                            <td class="col-detail"><span class="delta-snippet">userId: U-1044 borrowed bookId: BK-9921</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">10.0.0.12</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot low" title="LOW"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-004"
                                                   class="btn-icon" title="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                        <tr class="audit-row" data-action="LOGIN" data-severity="info">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                04/06/2026<br/><strong style="color: var(--on-surface);">08:01:05</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">AR</div>
                                                    <span style="font-size: 13px; font-weight: 600;">admin_root</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge login">LOGIN</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">Users</td>
                                            <td class="col-detail"><span class="delta-snippet">Successful login — admin_root</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">10.0.0.1</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot info" title="INFO"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-005"
                                                   class="btn-icon" title="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                        <tr class="audit-row" data-action="DELETE" data-severity="high">
                                            <td class="col-ts" style="font-size: 12px; color: var(--on-surface-variant);">
                                                03/06/2026<br/><strong style="color: var(--on-surface);">17:30:00</strong>
                                            </td>
                                            <td class="col-user">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary);">AM</div>
                                                    <span style="font-size: 13px; font-weight: 600;">admin_maria</span>
                                                </div>
                                            </td>
                                            <td class="col-action"><span class="action-badge delete">DELETE</span></td>
                                            <td class="col-entity" style="font-size: 13px; font-weight: 600;">Users
                                                <br/><span style="font-size: 11px; color: var(--on-surface-variant); font-weight:400;">#U-0892</span>
                                            </td>
                                            <td class="col-detail"><span class="delta-snippet">Soft-delete: status ACTIVE → DELETED</span></td>
                                            <td class="col-ip" style="font-size: 12px; font-family: monospace; color: var(--on-surface-variant);">10.0.0.5</td>
                                            <td class="col-sev" style="text-align: center;"><span class="severity-dot high" title="HIGH"></span></td>
                                            <td class="col-act" style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-006"
                                                   class="btn-icon" title="View detail">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">open_in_new</span>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div><!-- /table-responsive -->

                    <!-- Pagination -->
                    <div class="audit-pagination">
                        <span style="font-size: 12px; color: var(--on-surface-variant);" id="paginationInfo">
                            Showing <strong>1–10</strong> of
                            <strong><c:out value="${totalLogs != null ? totalLogs : '142'}" /></strong> entries
                        </span>
                        <div class="d-flex align-items-center gap-1">
                            <button class="pagination-btn" id="btnPrevPage" disabled aria-label="Previous page">
                                <span class="material-symbols-outlined">chevron_left</span>
                            </button>
                            <button class="pagination-btn active" aria-label="Page 1" aria-current="page">1</button>
                            <button class="pagination-btn" aria-label="Page 2">2</button>
                            <button class="pagination-btn" aria-label="Page 3">3</button>
                            <span style="font-size: 13px; color: var(--on-surface-variant);">…</span>
                            <button class="pagination-btn" aria-label="Page 15">15</button>
                            <button class="pagination-btn" id="btnNextPage" aria-label="Next page">
                                <span class="material-symbols-outlined">chevron_right</span>
                            </button>
                        </div>
                    </div>

                </div><!-- /.raised-card -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

<script>
/* ── Sidebar active state ── */
(function() {
    var links = document.querySelectorAll('aside .sidebar-link');
    links.forEach(function(l) { l.classList.remove('active'); });
    links.forEach(function(l) {
        if (l.href && l.href.indexOf('audit') !== -1) l.classList.add('active');
    });
})();

/* ── Client-side filter ── */
var searchInput  = document.getElementById('auditSearchInput');
var actionFilter = document.getElementById('actionTypeFilter');
var sevFilter    = document.getElementById('severityFilter');
var resultCount  = document.getElementById('auditResultCount');

function applyAuditFilters() {
    var q      = (searchInput.value || '').toLowerCase().trim();
    var action = (actionFilter.value || 'all').toLowerCase();
    var sev    = (sevFilter.value || 'all').toLowerCase();
    var rows   = document.querySelectorAll('#auditTable tbody tr.audit-row');
    var visible = 0;

    rows.forEach(function(row) {
        var rowAction = (row.getAttribute('data-action') || '').toLowerCase();
        var rowSev    = (row.getAttribute('data-severity') || '').toLowerCase();
        var rowText   = row.textContent.toLowerCase();

        var matchQ      = !q || rowText.indexOf(q) !== -1;
        var matchAction = action === 'all' || rowAction.replace('_', '') === action.replace('_', '') || rowAction === action;
        var matchSev    = sev === 'all' || rowSev === sev;

        var show = matchQ && matchAction && matchSev;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    resultCount.textContent = visible + ' entr' + (visible !== 1 ? 'ies' : 'y');
}

if (searchInput)  searchInput.addEventListener('input', applyAuditFilters);
if (actionFilter) actionFilter.addEventListener('change', applyAuditFilters);
if (sevFilter)    sevFilter.addEventListener('change', applyAuditFilters);

/* ── Export stub ── */
var btnExport = document.getElementById('btnExportLogs');
if (btnExport) {
    btnExport.addEventListener('click', function() {
        alert('Export: This will download the filtered audit log as a CSV file.');
    });
}

/* ── Row click → detail page ── */
document.querySelectorAll('#auditTable tbody tr.audit-row').forEach(function(row) {
    row.addEventListener('click', function(e) {
        if (e.target.closest('a') || e.target.closest('button')) return;
        var id = row.getAttribute('data-id') || 'LOG-001';
        window.location = '${pageContext.request.contextPath}/admin/audit-detail.jsp?id=' + id;
    });
});
</script>

</body>
</html>
