<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<%--
    Admin — Audit Log Detail
    Hiển thị chi tiết một log thao tác cụ thể:
      - Thông tin thao tác (ai, khi nào, từ IP nào, trên bảng nào)
      - Giá trị cũ (oldValues) và giá trị mới (newValues) dạng JSON diff
      - Metadata kỹ thuật (User-Agent, sessionId, requestPath)
    Query param: ?id=LOG_ID
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── 2-column layout ── */
    .detail-layout {
        display: grid;
        grid-template-columns: 1fr 320px;
        gap: 24px;
        align-items: start;
    }
    @media (max-width: 1100px) { .detail-layout { grid-template-columns: 1fr; } }

    /* ── Meta header card ── */
    .log-meta-header {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 16px;
        overflow: hidden;
    }
    .log-meta-header__banner {
        padding: 20px 24px;
        background: linear-gradient(135deg, rgba(157,67,0,0.06) 0%, rgba(255,219,202,0.15) 100%);
        border-bottom: 1px solid var(--outline-variant);
        display: flex;
        align-items: center;
        gap: 16px;
        flex-wrap: wrap;
    }
    .log-meta-header__icon {
        width: 52px; height: 52px; border-radius: 14px;
        display: flex; align-items: center; justify-content: center;
        font-size: 26px; flex-shrink: 0;
    }
    .log-meta-header__title { font-size: 18px; font-weight: 700; color: var(--on-surface); }
    .log-meta-header__sub   { font-size: 13px; color: var(--on-surface-variant); margin-top: 2px; }
    .log-meta-header__body  { padding: 20px 24px; }

    .meta-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
    }
    @media (max-width: 768px) { .meta-grid { grid-template-columns: 1fr 1fr; } }

    .meta-item { display: flex; flex-direction: column; gap: 4px; }
    .meta-item__label {
        font-size: 10px; font-weight: 700; letter-spacing: 0.08em;
        text-transform: uppercase; color: var(--on-surface-variant);
    }
    .meta-item__value { font-size: 14px; font-weight: 600; color: var(--on-surface); }
    .meta-item__value.mono { font-family: 'Courier New', monospace; font-size: 13px; }

    /* ── Diff viewer ── */
    .diff-card {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 14px;
        overflow: hidden;
    }
    .diff-card__header {
        padding: 14px 20px;
        background: var(--surface-container-low);
        border-bottom: 1px solid var(--outline-variant);
        display: flex; align-items: center; gap: 8px;
    }
    .diff-card__header h2 { font-size: 14px; font-weight: 700; color: var(--on-surface); margin: 0; }
    .diff-card__body { padding: 0; }

    .diff-table { width: 100%; border-collapse: collapse; }
    .diff-table thead th {
        padding: 10px 16px;
        font-size: 11px; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase;
        color: var(--on-surface-variant);
        border-bottom: 1px solid var(--outline-variant);
    }
    .diff-table .col-field { width: 200px; }
    .diff-table .col-old   { width: 50%; border-right: 1px solid var(--outline-variant); }
    .diff-table .col-new   { width: 50%; }
    .diff-table thead .col-old { background: rgba(186,26,26,0.04); }
    .diff-table thead .col-new { background: rgba(22,163,74,0.04); }

    .diff-row td {
        padding: 12px 16px;
        font-size: 13px;
        border-bottom: 1px solid var(--outline-variant);
        vertical-align: top;
    }
    .diff-row:last-child td { border-bottom: none; }
    .diff-row:hover td { background-color: var(--surface-container-low); }

    .diff-row .field-name {
        font-family: 'Courier New', monospace;
        font-size: 12px;
        font-weight: 700;
        color: var(--on-surface-variant);
        background: var(--surface-container-low);
        padding: 3px 8px;
        border-radius: 4px;
        display: inline-block;
    }
    .diff-row .old-val {
        font-family: 'Courier New', monospace;
        font-size: 13px;
        color: var(--error, #ba1a1a);
        background: rgba(186,26,26,0.05);
        padding: 4px 10px;
        border-radius: 6px;
        text-decoration: line-through;
        opacity: 0.85;
    }
    .diff-row .new-val {
        font-family: 'Courier New', monospace;
        font-size: 13px;
        color: #16a34a;
        background: rgba(22,163,74,0.07);
        padding: 4px 10px;
        border-radius: 6px;
        font-weight: 700;
    }
    .diff-row .unchanged-val {
        font-family: 'Courier New', monospace;
        font-size: 13px;
        color: var(--on-surface-variant);
    }
    .diff-row.unchanged td { opacity: 0.5; }
    .diff-changed-badge {
        display: inline-flex; align-items: center;
        padding: 2px 7px; border-radius: 999px;
        font-size: 10px; font-weight: 700;
        background: rgba(0,99,152,0.1); color: var(--tertiary, #006398);
        margin-left: 6px; vertical-align: middle;
    }

    /* ── JSON raw viewer ── */
    .json-viewer {
        background: #1e1e2e;
        color: #cdd6f4;
        font-family: 'Courier New', monospace;
        font-size: 12px;
        line-height: 1.6;
        padding: 16px 20px;
        border-radius: 0 0 12px 12px;
        overflow-x: auto;
        white-space: pre;
        max-height: 280px;
        overflow-y: auto;
    }
    .json-viewer .json-key   { color: #89b4fa; }
    .json-viewer .json-str   { color: #a6e3a1; }
    .json-viewer .json-num   { color: #fab387; }
    .json-viewer .json-bool  { color: #cba6f7; }
    .json-viewer .json-null  { color: #f38ba8; }

    /* ── Side cards ── */
    .side-card {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 14px;
        overflow: hidden;
    }
    .side-card__header {
        padding: 13px 18px;
        background: var(--surface-container-low);
        border-bottom: 1px solid var(--outline-variant);
        display: flex; align-items: center; gap: 8px;
    }
    .side-card__header h3 { font-size: 14px; font-weight: 700; color: var(--on-surface); margin: 0; }
    .side-card__body { padding: 16px 18px; }

    .info-row {
        display: flex; justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid var(--outline-variant);
        font-size: 13px;
        gap: 8px;
    }
    .info-row:last-child { border-bottom: none; padding-bottom: 0; }
    .info-row .ir-label { color: var(--on-surface-variant); flex-shrink: 0; }
    .info-row .ir-value { font-weight: 600; color: var(--on-surface); text-align: right; word-break: break-all; }
    .info-row .ir-value.mono { font-family: 'Courier New', monospace; font-size: 12px; }

    /* ── Action badges (reused) ── */
    .action-badge {
        display: inline-flex; align-items: center; gap: 4px;
        padding: 3px 10px; border-radius: 999px;
        font-size: 11px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase;
    }
    .action-badge.create { background: rgba(22,163,74,0.1); color: #16a34a; }
    .action-badge.update { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); }
    .action-badge.delete { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .action-badge.login  { background: rgba(157,67,0,0.1); color: var(--primary, #9d4300); }
    .action-badge.failed { background: rgba(186,26,26,0.08); color: #9f1239; }
    .action-badge.config { background: var(--surface-container-high); color: var(--on-surface-variant); }

    /* ── Severity chip ── */
    .sev-chip {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 4px 12px; border-radius: 999px;
        font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em;
    }
    .sev-chip .sev-dot { width: 7px; height: 7px; border-radius: 50%; }
    .sev-chip.high   { background: rgba(186,26,26,0.1); color: var(--error, #ba1a1a); }
    .sev-chip.high .sev-dot   { background: var(--error, #ba1a1a); }
    .sev-chip.medium { background: rgba(217,119,6,0.1); color: #d97706; }
    .sev-chip.medium .sev-dot { background: #d97706; }
    .sev-chip.low    { background: rgba(22,163,74,0.1); color: #16a34a; }
    .sev-chip.low .sev-dot    { background: #16a34a; }
    .sev-chip.info   { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); }
    .sev-chip.info .sev-dot   { background: var(--tertiary, #006398); }

    /* ── Buttons ── */
    .btn-detail-back {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 9px 18px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        background: transparent; color: var(--on-surface-variant);
        border: 1.5px solid var(--outline-variant); cursor: pointer;
        transition: all 0.15s; text-decoration: none;
    }
    .btn-detail-back:hover { border-color: var(--primary,#9d4300); color: var(--primary,#9d4300); }
    .btn-detail-back .material-symbols-outlined { font-size: 17px; }

    .btn-detail-export {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 9px 18px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        background: var(--primary,#9d4300); color: #fff;
        border: none; cursor: pointer;
        transition: transform 0.15s, filter 0.15s;
    }
    .btn-detail-export:hover { filter: brightness(110%); transform: scale(1.02); }
    .btn-detail-export .material-symbols-outlined { font-size: 17px; }

    /* ── Tab toggle (diff / raw) ── */
    .view-tabs {
        display: flex;
        gap: 0;
        border-bottom: 1px solid var(--outline-variant);
        padding: 0 16px;
        background: var(--surface-container-lowest, #fff);
    }
    .view-tab-btn {
        padding: 10px 16px;
        font-size: 13px; font-weight: 700;
        color: var(--on-surface-variant);
        border: none; background: transparent; cursor: pointer;
        border-bottom: 2px solid transparent;
        transition: all 0.15s;
    }
    .view-tab-btn.active {
        color: var(--primary, #9d4300);
        border-bottom-color: var(--primary, #9d4300);
    }
    .view-tab-btn:hover:not(.active) { color: var(--on-surface); }

    /* ── User avatar ── */
    .actor-avatar {
        width: 44px; height: 44px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 14px; font-weight: 700; flex-shrink: 0;
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

                <!-- ─── Page Header ─── -->
                <div class="d-flex align-items-start justify-content-between flex-wrap gap-3 mb-4">
                    <div>
                        <nav aria-label="breadcrumb" style="margin-bottom: 6px;">
                            <ol class="breadcrumb mb-0" style="font-size: 12px;">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                       class="text-decoration-none text-on-surface-variant">Bảng điều khiển</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp"
                                       class="text-decoration-none text-on-surface-variant">Nhật ký Kiểm toán</a>
                                </li>
                                <li class="breadcrumb-item active fw-semibold text-primary-custom"
                                    aria-current="page">
                                    Log #<c:out value="${not empty param.id ? param.id : 'LOG-002'}" />
                                </li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">manage_search</span>
                            Audit Chi tiết nhật ký
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            Full snapshot of the operation — old values, new values, and technical metadata.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp"
                           class="btn-detail-back" aria-label="Back to audit log list">
                            <span class="material-symbols-outlined">arrow_back</span>
                            Quay lại to Logs
                        </a>
                        <button class="btn-detail-export" id="btnExportLog"
                                aria-label="Xuất bản ghi nhật ký dạng JSON">
                            <span class="material-symbols-outlined">download</span>
                            Xuất JSON
                        </button>
                    </div>
                </div>

                <!-- ─── 2-Col Detail Layout ─── -->
                <div class="detail-layout">

                    <!-- ══ LEFT: Main content ══ -->
                    <div class="d-flex flex-column gap-4">

                        <!-- Meta Header Card -->
                        <div class="log-meta-header">
                            <div class="log-meta-header__banner">
                                <div class="log-meta-header__icon"
                                     style="background: rgba(0,99,152,0.1);">
                                    <span class="material-symbols-outlined"
                                          style="color: var(--tertiary,#006398); font-variation-settings: 'FILL' 1;">
                                        settings_applications
                                    </span>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <span class="action-badge config">CONFIG CHANGE</span>
                                        <span class="sev-chip medium">
                                            <span class="sev-dot"></span>
                                            Medium
                                        </span>
                                    </div>
                                    <div class="log-meta-header__title mt-1">
                                        SystemConfigurations updated
                                    </div>
                                    <div class="log-meta-header__sub">
                                        Mã nhật ký: <strong><c:out value="${not empty param.id ? param.id : 'LOG-002'}" /></strong>
                                        &nbsp;·&nbsp;
                                        <c:choose>
                                            <c:when test="${not empty auditLog.timestamp}">
                                                <fmt:formatDate value="${auditLog.timestamp}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </c:when>
                                            <c:otherwise>04/06/2026 14:22:01</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-2" style="flex-shrink: 0;">
                                    <div class="actor-avatar"
                                         style="background: rgba(157,67,0,0.1); color: var(--primary,#9d4300);">
                                        AM
                                    </div>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 700; color: var(--on-surface);">
                                            <c:out value="${not empty auditLog.performedBy ? auditLog.performedBy : 'admin_maria'}" />
                                        </div>
                                        <div style="font-size: 12px; color: var(--on-surface-variant);">System Administrator</div>
                                    </div>
                                </div>
                            </div>
                            <div class="log-meta-header__body">
                                <div class="meta-grid">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Entity / Table</span>
                                        <span class="meta-item__value">
                                            <c:out value="${not empty auditLog.tableName ? auditLog.tableName : 'SystemConfigurations'}" />
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-item__label">ID thực thể</span>
                                        <span class="meta-item__value mono">
                                            <c:out value="${not empty auditLog.entityId ? auditLog.entityId : 'PENALTY_RATE_PER_DAY_VND'}" />
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-item__label">IP Địa chỉ</span>
                                        <span class="meta-item__value mono">
                                            <c:out value="${not empty auditLog.ipAddress ? auditLog.ipAddress : '10.0.0.5'}" />
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-item__label">Session ID</span>
                                        <span class="meta-item__value mono" style="font-size: 11px;">
                                            <c:out value="${not empty auditLog.sessionId ? auditLog.sessionId : 'sess_a9f3b1d2e7'}" />
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-item__label">Đường dẫn yêu cầu</span>
                                        <span class="meta-item__value mono" style="font-size: 11px;">
                                            <c:out value="${not empty auditLog.requestPath ? auditLog.requestPath : 'POST /admin/config'}" />
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-item__label">Change Lý do</span>
                                        <span class="meta-item__value" style="font-size: 13px;">
                                            <c:out value="${not empty auditLog.changeReason ? auditLog.changeReason : 'Adjust fine rate for Q3 policy update'}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div><!-- /.log-meta-header -->

                        <!-- Diff Viewer Card -->
                        <div class="diff-card">
                            <div class="diff-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">
                                    compare_arrows
                                </span>
                                <h2>Giá trị Changes (Old → New)</h2>
                                <span style="font-size: 12px; color: var(--on-surface-variant); margin-left: auto;">
                                    <c:out value="${not empty auditLog.changedFieldCount ? auditLog.changedFieldCount : '1'}" /> field(s) modified
                                </span>
                            </div>

                            <!-- Tab switcher: Visual Diff / Raw JSON -->
                            <div class="view-tabs" role="tablist">
                                <button class="view-tab-btn active" id="tabDiff" role="tab"
                                        aria-selected="true" aria-controls="panelDiff">
                                    <span class="material-symbols-outlined" style="font-size: 15px; vertical-align: -2px;">diff</span>
                                    Visual Diff
                                </button>
                                <button class="view-tab-btn" id="tabOldJson" role="tab"
                                        aria-selected="false" aria-controls="panelOldJson">
                                    <span class="material-symbols-outlined" style="font-size: 15px; vertical-align: -2px;">code</span>
                                    Old Values (JSON)
                                </button>
                                <button class="view-tab-btn" id="tabNewJson" role="tab"
                                        aria-selected="false" aria-controls="panelNewJson">
                                    <span class="material-symbols-outlined" style="font-size: 15px; vertical-align: -2px;">code</span>
                                    New Values (JSON)
                                </button>
                            </div>

                            <!-- Panel: Visual Diff -->
                            <div id="panelDiff" role="tabpanel" aria-labelledby="tabDiff">
                                <div class="diff-card__body">
                                    <table class="diff-table" aria-label="Field-level diff">
                                        <thead>
                                            <tr>
                                                <th class="col-field" scope="col">Field</th>
                                                <th class="col-old" scope="col">
                                                    <span class="material-symbols-outlined"
                                                          style="font-size: 14px; vertical-align: -2px; color: var(--error,#ba1a1a);">
                                                        remove_circle
                                                    </span>
                                                    Giá trị cũ
                                                </th>
                                                <th class="col-new" scope="col">
                                                    <span class="material-symbols-outlined"
                                                          style="font-size: 14px; vertical-align: -2px; color: #16a34a;">
                                                        add_circle
                                                    </span>
                                                    Giá trị mới
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty auditLog.fieldDiffs}">
                                                    <c:forEach var="diff" items="${auditLog.fieldDiffs}">
                                                        <tr class="diff-row ${diff.changed ? '' : 'unchanged'}">
                                                            <td>
                                                                <span class="field-name"><c:out value="${diff.field}" /></span>
                                                                <c:if test="${diff.changed}">
                                                                    <span class="diff-changed-badge">changed</span>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${diff.changed}">
                                                                        <span class="old-val"><c:out value="${diff.oldValue}" /></span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="unchanged-val"><c:out value="${diff.oldValue}" /></span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${diff.changed}">
                                                                        <span class="new-val"><c:out value="${diff.newValue}" /></span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="unchanged-val"><c:out value="${diff.newValue}" /></span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- Demo diff data --%>
                                                    <tr class="diff-row">
                                                        <td>
                                                            <span class="field-name">configKey</span>
                                                        </td>
                                                        <td><span class="unchanged-val">PENALTY_RATE_PER_DAY_VND</span></td>
                                                        <td><span class="unchanged-val">PENALTY_RATE_PER_DAY_VND</span></td>
                                                    </tr>
                                                    <tr class="diff-row">
                                                        <td>
                                                            <span class="field-name">value</span>
                                                            <span class="diff-changed-badge">changed</span>
                                                        </td>
                                                        <td><span class="old-val">2500</span></td>
                                                        <td><span class="new-val">5000</span></td>
                                                    </tr>
                                                    <tr class="diff-row">
                                                        <td>
                                                            <span class="field-name">updatedAt</span>
                                                            <span class="diff-changed-badge">changed</span>
                                                        </td>
                                                        <td><span class="old-val">2026-03-15 09:10:00</span></td>
                                                        <td><span class="new-val">2026-06-04 14:22:01</span></td>
                                                    </tr>
                                                    <tr class="diff-row">
                                                        <td>
                                                            <span class="field-name">updatedBy</span>
                                                            <span class="diff-changed-badge">changed</span>
                                                        </td>
                                                        <td><span class="old-val">admin_root</span></td>
                                                        <td><span class="new-val">admin_maria</span></td>
                                                    </tr>
                                                    <tr class="diff-row">
                                                        <td><span class="field-name">unit</span></td>
                                                        <td><span class="unchanged-val">VND/day</span></td>
                                                        <td><span class="unchanged-val">VND/day</span></td>
                                                    </tr>
                                                    <tr class="diff-row">
                                                        <td><span class="field-name">isActive</span></td>
                                                        <td><span class="unchanged-val">true</span></td>
                                                        <td><span class="unchanged-val">true</span></td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div><!-- /#panelDiff -->

                            <!-- Panel: Old JSON -->
                            <div id="panelOldJson" role="tabpanel" aria-labelledby="tabOldJson" style="display:none;">
                                <div class="json-viewer" aria-label="Old values JSON">
<span class="json-key">"oldValues"</span>: {
  <span class="json-key">"configKey"</span>:   <span class="json-str">"PENALTY_RATE_PER_DAY_VND"</span>,
  <span class="json-key">"value"</span>:        <span class="json-num">2500</span>,
  <span class="json-key">"unit"</span>:         <span class="json-str">"VND/day"</span>,
  <span class="json-key">"category"</span>:     <span class="json-str">"FINE"</span>,
  <span class="json-key">"isActive"</span>:     <span class="json-bool">true</span>,
  <span class="json-key">"updatedBy"</span>:    <span class="json-str">"admin_root"</span>,
  <span class="json-key">"updatedAt"</span>:    <span class="json-str">"2026-03-15T09:10:00Z"</span>,
  <span class="json-key">"minValue"</span>:     <span class="json-num">0</span>,
  <span class="json-key">"maxValue"</span>:     <span class="json-null">null</span>
}</div>
                            </div><!-- /#panelOldJson -->

                            <!-- Panel: New JSON -->
                            <div id="panelNewJson" role="tabpanel" aria-labelledby="tabNewJson" style="display:none;">
                                <div class="json-viewer" aria-label="New values JSON">
<span class="json-key">"newValues"</span>: {
  <span class="json-key">"configKey"</span>:   <span class="json-str">"PENALTY_RATE_PER_DAY_VND"</span>,
  <span class="json-key">"value"</span>:        <span class="json-num">5000</span>,
  <span class="json-key">"unit"</span>:         <span class="json-str">"VND/day"</span>,
  <span class="json-key">"category"</span>:     <span class="json-str">"FINE"</span>,
  <span class="json-key">"isActive"</span>:     <span class="json-bool">true</span>,
  <span class="json-key">"updatedBy"</span>:    <span class="json-str">"admin_maria"</span>,
  <span class="json-key">"updatedAt"</span>:    <span class="json-str">"2026-06-04T14:22:01Z"</span>,
  <span class="json-key">"minValue"</span>:     <span class="json-num">0</span>,
  <span class="json-key">"maxValue"</span>:     <span class="json-null">null</span>
}</div>
                            </div><!-- /#panelNewJson -->

                        </div><!-- /.diff-card -->

                        <!-- User Agent card -->
                        <div class="raised-card p-4">
                            <h3 class="fw-bold mb-3" style="font-size: 14px; color: var(--on-surface);">
                                <span class="material-symbols-outlined me-2"
                                      style="font-size: 17px; vertical-align: -3px; color: var(--primary,#9d4300);">
                                    devices
                                </span>
                                Siêu dữ liệu kỹ thuật
                            </h3>
                            <div class="row g-3">
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">User-Agent</span>
                                        <span class="meta-item__value mono" style="font-size: 11px; word-break: break-all;">
                                            <c:out value="${not empty auditLog.userAgent ? auditLog.userAgent : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}" />
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Phương thức HTTP</span>
                                        <span class="meta-item__value">
                                            <c:out value="${not empty auditLog.httpMethod ? auditLog.httpMethod : 'POST'}" />
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Response Code</span>
                                        <span class="meta-item__value" style="color: #16a34a;">
                                            <c:out value="${not empty auditLog.responseCode ? auditLog.responseCode : '302 Redirect'}" />
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Thời hạn</span>
                                        <span class="meta-item__value">
                                            <c:out value="${not empty auditLog.durationMs ? auditLog.durationMs : '43'}" /> ms
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Server Instance</span>
                                        <span class="meta-item__value mono">
                                            <c:out value="${not empty auditLog.serverInstance ? auditLog.serverInstance : 'lms-app-01'}" />
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="meta-item">
                                        <span class="meta-item__label">Transaction ID</span>
                                        <span class="meta-item__value mono" style="font-size: 11px;">
                                            <c:out value="${not empty auditLog.transactionId ? auditLog.transactionId : 'txn_0f4a7c2b9e1d'}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- /left col -->

                    <!-- ══ RIGHT: Side panels ══ -->
                    <div class="d-flex flex-column gap-4">

                        <!-- Quick Summary -->
                        <div class="side-card">
                            <div class="side-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">
                                    summarize
                                </span>
                                <h3>Tóm tắt nhanh</h3>
                            </div>
                            <div class="side-card__body">
                                <div class="info-row">
                                    <span class="ir-label">Mã nhật ký</span>
                                    <span class="ir-value mono">
                                        <c:out value="${not empty param.id ? param.id : 'LOG-002'}" />
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Hành động Type</span>
                                    <span class="ir-value"><span class="action-badge config">CONFIG CHANGE</span></span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Severity</span>
                                    <span class="ir-value">
                                        <span class="sev-chip medium">
                                            <span class="sev-dot"></span>
                                            Medium
                                        </span>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Table</span>
                                    <span class="ir-value">SystemConfigurations</span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Fields Changed</span>
                                    <span class="ir-value" style="color: var(--tertiary,#006398);">3 of 9</span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Date &amp; Time</span>
                                    <span class="ir-value" style="font-size: 12px;">04/06/2026 14:22:01</span>
                                </div>
                            </div>
                        </div>

                        <!-- Operator Info -->
                        <div class="side-card">
                            <div class="side-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">
                                    manage_accounts
                                </span>
                                <h3>Operator</h3>
                            </div>
                            <div class="side-card__body">
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <div class="actor-avatar" style="background: rgba(157,67,0,0.1); color: var(--primary,#9d4300);">AM</div>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 700; color: var(--on-surface);">admin_maria</div>
                                        <div style="font-size: 12px; color: var(--on-surface-variant);">m.kovacs@uni.edu</div>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Vai trò</span>
                                    <span class="ir-value">System Administrator</span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">IP</span>
                                    <span class="ir-value mono">10.0.0.5</span>
                                </div>
                                <div class="info-row">
                                    <span class="ir-label">Đăng nhập cuối</span>
                                    <span class="ir-value" style="font-size: 12px;">04/06/2026 08:01</span>
                                </div>
                            </div>
                        </div>

                        <!-- Related logs -->
                        <div class="side-card">
                            <div class="side-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">link</span>
                                <h3>Related Logs</h3>
                            </div>
                            <div class="side-card__body" style="display: flex; flex-direction: column; gap: 8px;">
                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-001"
                                   class="text-decoration-none d-flex align-items-start gap-2 p-2 rounded-2"
                                   style="border: 1px solid var(--outline-variant); font-size: 12px;"
                                   aria-label="Related log LOG-001">
                                    <span class="material-symbols-outlined" style="font-size: 15px; color: var(--error,#ba1a1a); flex-shrink:0; margin-top: 1px;">gpp_bad</span>
                                    <div>
                                        <div class="fw-bold" style="color: var(--on-surface);">LOG-001</div>
                                        <div style="color: var(--on-surface-variant);">FAILED LOGIN — 14:22:35</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-detail.jsp?id=LOG-003"
                                   class="text-decoration-none d-flex align-items-start gap-2 p-2 rounded-2"
                                   style="border: 1px solid var(--outline-variant); font-size: 12px;"
                                   aria-label="Related log LOG-003">
                                    <span class="material-symbols-outlined" style="font-size: 15px; color: var(--tertiary,#006398); flex-shrink:0; margin-top: 1px;">update</span>
                                    <div>
                                        <div class="fw-bold" style="color: var(--on-surface);">LOG-003</div>
                                        <div style="color: var(--on-surface-variant);">UPDATE — BorrowRecords — 13:55</div>
                                    </div>
                                </a>
                                <div class="mt-2 pt-2" style="border-top: 1px solid var(--outline-variant);">
                                    <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?user=admin_maria"
                                       class="text-primary-custom fw-bold text-decoration-none" style="font-size: 12px;">
                                        All logs by admin_maria →
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="raised-card p-4">
                            <h3 class="fw-bold mb-3" style="font-size: 14px; color: var(--on-surface);">Hành động</h3>
                            <div class="d-flex flex-column gap-2">
                                <a href="${pageContext.request.contextPath}/admin/config-edit.jsp?key=PENALTY_RATE_PER_DAY_VND"
                                   class="btn-detail-back text-decoration-none" style="justify-content: center;">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">open_in_new</span>
                                    Xem Config Parameter
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?entity=SystemConfigurations"
                                   class="btn-detail-back text-decoration-none" style="justify-content: center;">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">filter_list</span>
                                    Bộ lọc by Entity
                                </a>
                            </div>
                        </div>

                    </div><!-- /right col -->

                </div><!-- /.detail-layout -->

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

/* ── Tab switching (Diff / Old JSON / New JSON) ── */
var tabs = {
    tabDiff:    'panelDiff',
    tabOldJson: 'panelOldJson',
    tabNewJson: 'panelNewJson'
};
Object.keys(tabs).forEach(function(tabId) {
    var btn = document.getElementById(tabId);
    if (!btn) return;
    btn.addEventListener('click', function() {
        /* Deactivate all */
        Object.keys(tabs).forEach(function(tid) {
            var b = document.getElementById(tid);
            var p = document.getElementById(tabs[tid]);
            if (b) { b.classList.remove('active'); b.setAttribute('aria-selected', 'false'); }
            if (p) p.style.display = 'none';
        });
        /* Activate clicked */
        btn.classList.add('active');
        btn.setAttribute('aria-selected', 'true');
        var panel = document.getElementById(tabs[tabId]);
        if (panel) panel.style.display = '';
    });
});

/* ── Export stub ── */
var btnExport = document.getElementById('btnExportLog');
if (btnExport) {
    btnExport.addEventListener('click', function() {
        var logId = '${not empty param.id ? param.id : "LOG-002"}';
        alert('Export: Downloading JSON snapshot for log ' + logId);
    });
}
</script>

</body>
</html>
