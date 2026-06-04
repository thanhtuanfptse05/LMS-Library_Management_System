<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<%--
    Admin — Config Edit
    Form cập nhật (hoặc tạo mới) giá trị của một tham số cấu hình trong SystemConfigurations.
    Query param: ?key=PARAM_KEY  (mode=create nếu tạo mới)
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Form card structure ── */
    .edit-layout {
        display: grid;
        grid-template-columns: 1fr 340px;
        gap: 24px;
        align-items: start;
    }
    @media (max-width: 1100px) {
        .edit-layout { grid-template-columns: 1fr; }
    }

    /* ── Form groups ── */
    .form-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
        margin-bottom: 20px;
    }
    .form-group:last-child { margin-bottom: 0; }

    .form-label {
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.07em;
        text-transform: uppercase;
        color: var(--on-surface-variant);
    }
    .form-label .required-star { color: var(--error, #ba1a1a); margin-left: 2px; }

    .form-control-cfg {
        width: 100%;
        padding: 10px 14px;
        background: var(--surface-container-lowest, #fff);
        border: 1.5px solid var(--outline-variant);
        border-radius: 10px;
        font-size: 14px;
        font-family: 'Inter', sans-serif;
        color: var(--on-surface);
        outline: none;
        transition: border-color 0.18s ease, box-shadow 0.18s ease;
    }
    .form-control-cfg:focus {
        border-color: var(--primary, #9d4300);
        box-shadow: 0 0 0 3px rgba(157,67,0,0.12);
    }
    .form-control-cfg.is-invalid {
        border-color: var(--error, #ba1a1a);
        box-shadow: 0 0 0 3px rgba(186,26,26,0.1);
    }
    .form-control-cfg[readonly] {
        background: var(--surface-container-low);
        color: var(--on-surface-variant);
        cursor: not-allowed;
    }
    textarea.form-control-cfg { resize: vertical; min-height: 80px; }

    .form-hint {
        font-size: 12px;
        color: var(--on-surface-variant);
        line-height: 1.4;
    }
    .form-error-msg {
        font-size: 12px;
        color: var(--error, #ba1a1a);
        display: flex;
        align-items: center;
        gap: 4px;
        display: none;
    }
    .form-error-msg .material-symbols-outlined { font-size: 14px; }

    /* ── Value input with unit suffix ── */
    .input-with-unit {
        display: flex;
        align-items: center;
        border: 1.5px solid var(--outline-variant);
        border-radius: 10px;
        overflow: hidden;
        transition: border-color 0.18s, box-shadow 0.18s;
        background: var(--surface-container-lowest, #fff);
    }
    .input-with-unit:focus-within {
        border-color: var(--primary, #9d4300);
        box-shadow: 0 0 0 3px rgba(157,67,0,0.12);
    }
    .input-with-unit input {
        flex: 1;
        padding: 10px 14px;
        border: none;
        background: transparent;
        font-size: 15px;
        font-weight: 700;
        font-family: 'Inter', sans-serif;
        color: var(--on-surface);
        outline: none;
    }
    .input-with-unit .unit-label {
        padding: 10px 14px;
        background: var(--surface-container-low);
        border-left: 1.5px solid var(--outline-variant);
        font-size: 12px;
        font-weight: 700;
        color: var(--on-surface-variant);
        white-space: nowrap;
        user-select: none;
    }

    /* ── Category / data-type chips ── */
    .type-chip-group {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
    }
    .type-chip-opt {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 7px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        border: 1.5px solid var(--outline-variant);
        background: var(--surface-container-lowest, #fff);
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.15s;
        user-select: none;
    }
    .type-chip-opt input { display: none; }
    .type-chip-opt:hover { border-color: var(--primary, #9d4300); color: var(--primary, #9d4300); }
    .type-chip-opt.selected { background: var(--primary, #9d4300); color: #fff; border-color: var(--primary, #9d4300); }
    .type-chip-opt .material-symbols-outlined { font-size: 14px; }

    /* ── Action buttons ── */
    .btn-edit-primary {
        display: inline-flex; align-items: center; gap: 8px;
        padding: 11px 24px; border-radius: 10px;
        font-size: 14px; font-weight: 700;
        background: var(--primary, #9d4300); color: #fff;
        border: none; cursor: pointer;
        transition: transform 0.15s, filter 0.15s;
    }
    .btn-edit-primary:hover { filter: brightness(110%); transform: scale(1.02); }
    .btn-edit-primary:active { transform: scale(0.98); }
    .btn-edit-primary .material-symbols-outlined { font-size: 18px; }

    .btn-edit-outline {
        display: inline-flex; align-items: center; gap: 8px;
        padding: 10px 20px; border-radius: 10px;
        font-size: 14px; font-weight: 700;
        background: transparent; color: var(--on-surface-variant);
        border: 1.5px solid var(--outline-variant); cursor: pointer;
        transition: all 0.15s;
        text-decoration: none;
    }
    .btn-edit-outline:hover { border-color: var(--primary, #9d4300); color: var(--primary, #9d4300); }
    .btn-edit-outline .material-symbols-outlined { font-size: 18px; }

    .btn-edit-danger {
        display: inline-flex; align-items: center; gap: 8px;
        padding: 10px 20px; border-radius: 10px;
        font-size: 14px; font-weight: 700;
        background: transparent; color: var(--error, #ba1a1a);
        border: 1.5px solid rgba(186,26,26,0.3); cursor: pointer;
        transition: all 0.15s;
    }
    .btn-edit-danger:hover { background: var(--error-container, #ffdad6); border-color: var(--error, #ba1a1a); }
    .btn-edit-danger .material-symbols-outlined { font-size: 18px; }

    /* ── Sidebar panel card ── */
    .side-info-card {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 14px;
        overflow: hidden;
    }
    .side-info-card__header {
        padding: 14px 18px;
        background: var(--surface-container-low);
        border-bottom: 1px solid var(--outline-variant);
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .side-info-card__header h3 {
        font-size: 14px;
        font-weight: 700;
        color: var(--on-surface);
        margin: 0;
    }
    .side-info-card__body { padding: 16px 18px; }

    /* ── History timeline (side panel) ── */
    .history-item {
        display: flex;
        gap: 12px;
        padding: 10px 0;
        border-bottom: 1px solid var(--outline-variant);
    }
    .history-item:last-child { border-bottom: none; padding-bottom: 0; }
    .history-item .hi-dot {
        width: 28px; height: 28px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 15px;
        flex-shrink: 0;
        margin-top: 2px;
    }
    .history-item .hi-content { flex: 1; }
    .history-item .hi-actor { font-size: 13px; font-weight: 700; color: var(--on-surface); }
    .history-item .hi-change {
        font-size: 12px;
        color: var(--on-surface-variant);
        margin-top: 2px;
        font-family: 'Courier New', monospace;
    }
    .history-item .hi-time { font-size: 11px; color: var(--on-surface-variant); margin-top: 4px; }

    /* ── Constraint box ── */
    .constraint-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid var(--outline-variant);
        font-size: 13px;
    }
    .constraint-row:last-child { border-bottom: none; padding-bottom: 0; }
    .constraint-row .cr-label { color: var(--on-surface-variant); }
    .constraint-row .cr-value { font-weight: 700; color: var(--on-surface); font-family: monospace; }

    /* ── Confirm modal ── */
    .confirm-modal-overlay {
        position: fixed; inset: 0; z-index: 9999;
        background: rgba(37,25,19,0.5); backdrop-filter: blur(4px);
        display: flex; align-items: center; justify-content: center;
        opacity: 0; pointer-events: none; transition: opacity 0.2s;
    }
    .confirm-modal-overlay.open { opacity: 1; pointer-events: auto; }
    .confirm-modal-dialog {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 16px;
        padding: 28px;
        width: 100%;
        max-width: 440px;
        box-shadow: 0 16px 48px rgba(0,0,0,0.12);
        transform: translateY(12px);
        transition: transform 0.2s;
    }
    .confirm-modal-overlay.open .confirm-modal-dialog { transform: translateY(0); }

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
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
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
                                       class="text-decoration-none text-on-surface-variant">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/admin/config-list.jsp"
                                       class="text-decoration-none text-on-surface-variant">Configurations</a>
                                </li>
                                <li class="breadcrumb-item active fw-semibold text-primary-custom" aria-current="page">
                                    <c:choose>
                                        <c:when test="${param.mode == 'create'}">New Parameter</c:when>
                                        <c:otherwise>Edit — <c:out value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" /></c:otherwise>
                                    </c:choose>
                                </li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">tune</span>
                            <c:choose>
                                <c:when test="${param.mode == 'create'}">New Configuration Parameter</c:when>
                                <c:otherwise>Edit Configuration</c:otherwise>
                            </c:choose>
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            <c:choose>
                                <c:when test="${param.mode == 'create'}">
                                    Define a new system parameter key and its initial value.
                                </c:when>
                                <c:otherwise>
                                    Update the value of
                                    <strong><c:out value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" /></strong>.
                                    All changes are audit-logged automatically.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/config-list.jsp"
                       class="btn-edit-outline text-decoration-none" aria-label="Cancel and go back">
                        <span class="material-symbols-outlined">arrow_back</span>
                        Cancel
                    </a>
                </div>

                <!-- ─── 2-Col Edit Layout ─── -->
                <div class="edit-layout">

                    <!-- ══ LEFT: Edit Form ══ -->
                    <div class="d-flex flex-column gap-4">

                        <!-- Form Card -->
                        <div class="raised-card p-4">
                            <form id="configEditForm"
                                  action="${pageContext.request.contextPath}/admin/config"
                                  method="POST" novalidate>
                                <input type="hidden" name="action"
                                       value="${param.mode == 'create' ? 'create' : 'update'}" />
                                <input type="hidden" name="originalKey"
                                       value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" />

                                <!-- ── Key (readonly if editing) ── -->
                                <div class="form-group">
                                    <label class="form-label" for="configKey">
                                        Parameter Key <span class="required-star">*</span>
                                    </label>
                                    <input type="text"
                                           id="configKey"
                                           name="configKey"
                                           class="form-control-cfg"
                                           style="font-family: 'Courier New', monospace; letter-spacing: 0.04em;"
                                           placeholder="e.g. MAX_LOAN_DURATION_DAYS"
                                           value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}"
                                           ${param.mode != 'create' ? 'readonly' : ''}
                                           required
                                           aria-required="true"
                                           aria-describedby="configKeyHelp configKeyError" />
                                    <p id="configKeyHelp" class="form-hint">
                                        <c:choose>
                                            <c:when test="${param.mode == 'create'}">
                                                Use SCREAMING_SNAKE_CASE. This key must be unique. Cannot be changed after creation.
                                            </c:when>
                                            <c:otherwise>
                                                Parameter keys are immutable. Create a new parameter to use a different key name.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <span class="form-error-msg" id="configKeyError" role="alert">
                                        <span class="material-symbols-outlined">error</span>
                                        Parameter key is required and must be SCREAMING_SNAKE_CASE.
                                    </span>
                                </div>

                                <!-- ── Display Name ── -->
                                <div class="form-group">
                                    <label class="form-label" for="displayName">
                                        Display Name <span class="required-star">*</span>
                                    </label>
                                    <input type="text"
                                           id="displayName"
                                           name="displayName"
                                           class="form-control-cfg"
                                           placeholder="e.g. Penalty Rate per Overdue Day"
                                           value="${not empty configParam.displayName ? configParam.displayName : 'Penalty Rate per Overdue Day (VND)'}"
                                           required
                                           maxlength="120"
                                           aria-required="true"
                                           aria-describedby="displayNameError" />
                                    <span class="form-error-msg" id="displayNameError" role="alert">
                                        <span class="material-symbols-outlined">error</span>
                                        Display name is required.
                                    </span>
                                </div>

                                <!-- ── Category ── -->
                                <div class="form-group">
                                    <label class="form-label">Category</label>
                                    <div class="type-chip-group" role="radiogroup" aria-label="Parameter category">
                                        <label class="type-chip-opt ${not empty configParam.category ? (configParam.category == 'LOAN' ? 'selected' : '') : ''}"
                                               for="cat-loan">
                                            <input type="radio" name="category" id="cat-loan" value="LOAN" />
                                            <span class="material-symbols-outlined">book</span> Loan
                                        </label>
                                        <label class="type-chip-opt ${not empty configParam.category ? (configParam.category == 'FINE' ? 'selected' : '') : 'selected'}"
                                               for="cat-fine">
                                            <input type="radio" name="category" id="cat-fine" value="FINE"
                                                   ${empty configParam.category ? 'checked' : (configParam.category == 'FINE' ? 'checked' : '')} />
                                            <span class="material-symbols-outlined">payments</span> Fine
                                        </label>
                                        <label class="type-chip-opt ${not empty configParam.category and configParam.category == 'RESERVATION' ? 'selected' : ''}"
                                               for="cat-reserve">
                                            <input type="radio" name="category" id="cat-reserve" value="RESERVATION" />
                                            <span class="material-symbols-outlined">bookmark</span> Reservation
                                        </label>
                                        <label class="type-chip-opt ${not empty configParam.category and configParam.category == 'EMAIL' ? 'selected' : ''}"
                                               for="cat-email">
                                            <input type="radio" name="category" id="cat-email" value="EMAIL" />
                                            <span class="material-symbols-outlined">email</span> Email
                                        </label>
                                        <label class="type-chip-opt ${not empty configParam.category and configParam.category == 'SYSTEM' ? 'selected' : ''}"
                                               for="cat-system">
                                            <input type="radio" name="category" id="cat-system" value="SYSTEM" />
                                            <span class="material-symbols-outlined">settings_applications</span> System
                                        </label>
                                    </div>
                                </div>

                                <!-- ── Data Type ── -->
                                <div class="form-group">
                                    <label class="form-label" for="dataType">Data Type</label>
                                    <select id="dataType" name="dataType" class="form-control-cfg"
                                            aria-label="Data type">
                                        <option value="INTEGER" ${configParam.dataType == 'INTEGER' ? 'selected' : ''}>INTEGER — Whole number (e.g. 5, 21)</option>
                                        <option value="DECIMAL" ${configParam.dataType == 'DECIMAL' or empty configParam.dataType ? 'selected' : ''}>DECIMAL — Decimal number (e.g. 5000.00)</option>
                                        <option value="STRING" ${configParam.dataType == 'STRING' ? 'selected' : ''}>STRING — Free text value</option>
                                        <option value="BOOLEAN" ${configParam.dataType == 'BOOLEAN' ? 'selected' : ''}>BOOLEAN — true / false flag</option>
                                    </select>
                                </div>

                                <!-- ── Current Value ── -->
                                <div class="form-group">
                                    <label class="form-label" for="configValue">
                                        Value <span class="required-star">*</span>
                                    </label>
                                    <div class="input-with-unit" id="valueInputWrapper">
                                        <input type="text"
                                               id="configValue"
                                               name="configValue"
                                               placeholder="Enter the new value…"
                                               value="${not empty configParam.value ? configParam.value : '5000'}"
                                               required
                                               aria-required="true"
                                               aria-describedby="configValueHelp configValueError" />
                                        <span class="unit-label" id="unitLabel">
                                            <c:out value="${not empty configParam.unit ? configParam.unit : 'VND/day'}" />
                                        </span>
                                    </div>
                                    <p id="configValueHelp" class="form-hint">
                                        Current production value:
                                        <strong><c:out value="${not empty configParam.currentValue ? configParam.currentValue : '5,000 VND/day'}" /></strong>.
                                        Enter the new value to apply.
                                    </p>
                                    <span class="form-error-msg" id="configValueError" role="alert">
                                        <span class="material-symbols-outlined">error</span>
                                        Value is required and must match the selected data type.
                                    </span>
                                </div>

                                <!-- ── Unit ── -->
                                <div class="form-group">
                                    <label class="form-label" for="configUnit">Unit / Suffix</label>
                                    <input type="text"
                                           id="configUnit"
                                           name="configUnit"
                                           class="form-control-cfg"
                                           placeholder="e.g. days, books, VND/day, hrs, min"
                                           value="${not empty configParam.unit ? configParam.unit : 'VND/day'}"
                                           maxlength="30"
                                           aria-describedby="configUnitHelp" />
                                    <p id="configUnitHelp" class="form-hint">
                                        Optional display unit shown next to the value (for human readability only).
                                    </p>
                                </div>

                                <!-- ── Description ── -->
                                <div class="form-group">
                                    <label class="form-label" for="configDescription">Description</label>
                                    <textarea id="configDescription"
                                              name="configDescription"
                                              class="form-control-cfg"
                                              rows="3"
                                              maxlength="500"
                                              placeholder="Explain what this parameter controls and its impact on system behaviour…"
                                              aria-describedby="configDescHelp"><c:out value="${not empty configParam.description ? configParam.description : 'Late return fine applied per calendar day after the due date. Unit: VND.'}" /></textarea>
                                    <p id="configDescHelp" class="form-hint">
                                        <span id="descCharCount">0</span> / 500 characters
                                    </p>
                                </div>

                                <!-- ── Min / Max constraints ── -->
                                <div class="row g-3">
                                    <div class="col-6">
                                        <div class="form-group mb-0">
                                            <label class="form-label" for="minValue">Minimum Value</label>
                                            <input type="number" id="minValue" name="minValue"
                                                   class="form-control-cfg"
                                                   placeholder="e.g. 0"
                                                   value="${not empty configParam.minValue ? configParam.minValue : '0'}"
                                                   aria-describedby="minValueHelp" />
                                            <p id="minValueHelp" class="form-hint">Leave blank for no lower bound.</p>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="form-group mb-0">
                                            <label class="form-label" for="maxValue">Maximum Value</label>
                                            <input type="number" id="maxValue" name="maxValue"
                                                   class="form-control-cfg"
                                                   placeholder="e.g. 1000000"
                                                   value="${not empty configParam.maxValue ? configParam.maxValue : ''}"
                                                   aria-describedby="maxValueHelp" />
                                            <p id="maxValueHelp" class="form-hint">Leave blank for no upper bound.</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- ── Change Reason (required for audit log) ── -->
                                <div class="form-group mt-4">
                                    <label class="form-label" for="changeReason">
                                        Reason for Change <span class="required-star">*</span>
                                    </label>
                                    <textarea id="changeReason"
                                              name="changeReason"
                                              class="form-control-cfg"
                                              rows="2"
                                              required
                                              maxlength="300"
                                              placeholder="Briefly explain why this value is being changed (recorded in Audit Log)…"
                                              aria-required="true"
                                              aria-describedby="changeReasonError"></textarea>
                                    <span class="form-error-msg" id="changeReasonError" role="alert">
                                        <span class="material-symbols-outlined">error</span>
                                        A reason for the change is required for audit trail.
                                    </span>
                                </div>

                                <!-- ── Status toggle ── -->
                                <div class="d-flex align-items-center justify-content-between mt-3 p-3 rounded-3"
                                     style="background: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div>
                                        <div class="fw-bold" style="font-size: 13px; color: var(--on-surface);">Parameter Status</div>
                                        <div class="form-hint mt-0">Inactive parameters are ignored by the system runtime.</div>
                                    </div>
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox"
                                               role="switch" id="configActive" name="isActive"
                                               value="true"
                                               ${empty configParam or configParam.active ? 'checked' : ''}
                                               style="width: 48px; height: 26px; cursor: pointer;" />
                                        <label class="form-check-label fw-bold ms-2" for="configActive"
                                               style="font-size: 13px;" id="statusLabel">Active</label>
                                    </div>
                                </div>

                                <!-- ── Submit buttons ── -->
                                <div class="d-flex align-items-center gap-3 flex-wrap mt-4">
                                    <button type="submit" class="btn-edit-primary" id="btnSaveConfig"
                                            aria-label="Save configuration changes">
                                        <span class="material-symbols-outlined">save</span>
                                        Save Changes
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/config-list.jsp"
                                       class="btn-edit-outline text-decoration-none" aria-label="Discard and go back">
                                        <span class="material-symbols-outlined">close</span>
                                        Discard
                                    </a>
                                    <c:if test="${param.mode != 'create'}">
                                        <button type="button" class="btn-edit-danger ms-auto"
                                                id="btnResetDefault" aria-label="Reset to default value">
                                            <span class="material-symbols-outlined">restart_alt</span>
                                            Reset to Default
                                        </button>
                                    </c:if>
                                </div>

                            </form>
                        </div><!-- /.raised-card form -->

                    </div><!-- /left col -->

                    <!-- ══ RIGHT: Info Panels ══ -->
                    <div class="d-flex flex-column gap-4">

                        <!-- Constraint Info -->
                        <div class="side-info-card">
                            <div class="side-info-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">info</span>
                                <h3>Parameter Info</h3>
                            </div>
                            <div class="side-info-card__body">
                                <div class="constraint-row">
                                    <span class="cr-label">Key</span>
                                    <span class="cr-value" style="font-size: 12px;">
                                        <c:out value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" />
                                    </span>
                                </div>
                                <div class="constraint-row">
                                    <span class="cr-label">Data Type</span>
                                    <span class="cr-value">
                                        <c:out value="${not empty configParam.dataType ? configParam.dataType : 'DECIMAL'}" />
                                    </span>
                                </div>
                                <div class="constraint-row">
                                    <span class="cr-label">Min Allowed</span>
                                    <span class="cr-value">
                                        <c:out value="${not empty configParam.minValue ? configParam.minValue : '0'}" />
                                    </span>
                                </div>
                                <div class="constraint-row">
                                    <span class="cr-label">Max Allowed</span>
                                    <span class="cr-value">
                                        <c:out value="${not empty configParam.maxValue ? configParam.maxValue : 'Unlimited'}" />
                                    </span>
                                </div>
                                <div class="constraint-row">
                                    <span class="cr-label">Default Value</span>
                                    <span class="cr-value">
                                        <c:out value="${not empty configParam.defaultValue ? configParam.defaultValue : '5000'}" />
                                    </span>
                                </div>
                                <div class="constraint-row">
                                    <span class="cr-label">Created At</span>
                                    <span class="cr-value" style="font-size: 11px;">
                                        <c:choose>
                                            <c:when test="${not empty configParam.createdAt}">
                                                <fmt:formatDate value="${configParam.createdAt}" pattern="dd/MM/yyyy" />
                                            </c:when>
                                            <c:otherwise>20/05/2026</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Impact Warning -->
                        <div class="raised-card p-4" style="border-left: 4px solid #854d0e;">
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <span class="material-symbols-outlined" style="color: #854d0e; font-size: 20px;">warning</span>
                                <span class="fw-bold" style="font-size: 14px; color: #854d0e;">Impact Warning</span>
                            </div>
                            <p style="font-size: 13px; color: var(--on-surface-variant); margin: 0; line-height: 1.6;">
                                Changes to
                                <strong><c:out value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" /></strong>
                                take effect <strong>immediately</strong> after saving.
                                All new fines and overdue calculations will use the updated value.
                                Existing records are <strong>not retroactively recalculated</strong>.
                            </p>
                        </div>

                        <!-- Change History (recent) -->
                        <div class="side-info-card">
                            <div class="side-info-card__header">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary,#9d4300);">history</span>
                                <h3>Recent Changes</h3>
                            </div>
                            <div class="side-info-card__body">
                                <c:choose>
                                    <c:when test="${not empty configHistory}">
                                        <c:forEach var="h" items="${configHistory}" varStatus="st">
                                            <c:if test="${st.index < 5}">
                                                <div class="history-item">
                                                    <div class="hi-dot" style="background: rgba(157,67,0,0.1);">
                                                        <span class="material-symbols-outlined" style="font-size: 14px; color: var(--primary,#9d4300);">edit</span>
                                                    </div>
                                                    <div class="hi-content">
                                                        <div class="hi-actor"><c:out value="${h.performedBy}" /></div>
                                                        <div class="hi-change">
                                                            <c:out value="${h.oldValue}" /> → <c:out value="${h.newValue}" />
                                                        </div>
                                                        <div class="hi-time">
                                                            <fmt:formatDate value="${h.changedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Demo history items -->
                                        <div class="history-item">
                                            <div class="hi-dot" style="background: rgba(157,67,0,0.1);">
                                                <span class="material-symbols-outlined" style="font-size: 14px; color: var(--primary,#9d4300);">edit</span>
                                            </div>
                                            <div class="hi-content">
                                                <div class="hi-actor">admin_maria</div>
                                                <div class="hi-change">2500 → 5000</div>
                                                <div class="hi-time">03/06/2026 14:22</div>
                                            </div>
                                        </div>
                                        <div class="history-item">
                                            <div class="hi-dot" style="background: rgba(157,67,0,0.1);">
                                                <span class="material-symbols-outlined" style="font-size: 14px; color: var(--primary,#9d4300);">edit</span>
                                            </div>
                                            <div class="hi-content">
                                                <div class="hi-actor">admin_root</div>
                                                <div class="hi-change">1000 → 2500</div>
                                                <div class="hi-time">15/03/2026 09:10</div>
                                            </div>
                                        </div>
                                        <div class="history-item">
                                            <div class="hi-dot" style="background: rgba(22,163,74,0.1);">
                                                <span class="material-symbols-outlined" style="font-size: 14px; color: #16a34a;">add_circle</span>
                                            </div>
                                            <div class="hi-content">
                                                <div class="hi-actor">admin_root</div>
                                                <div class="hi-change">— → 1000 (created)</div>
                                                <div class="hi-time">20/05/2025 08:00</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="mt-3 pt-2" style="border-top: 1px solid var(--outline-variant);">
                                    <a href="${pageContext.request.contextPath}/admin/audit-logs.jsp?key=${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}"
                                       class="text-primary-custom fw-bold text-decoration-none"
                                       style="font-size: 12px;">
                                        View full audit history →
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div><!-- /right col -->

                </div><!-- /.edit-layout -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <!-- ═══ Reset to Default Modal ═══ -->
    <div class="confirm-modal-overlay" id="resetModal" role="dialog" aria-modal="true"
         aria-labelledby="resetModalTitle">
        <div class="confirm-modal-dialog">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="d-flex align-items-center justify-content-center rounded-circle"
                     style="width:44px;height:44px;background:rgba(234,179,8,0.1); flex-shrink:0;">
                    <span class="material-symbols-outlined" style="color: #854d0e; font-size:22px;">restart_alt</span>
                </div>
                <div>
                    <h2 class="fw-bold mb-0" id="resetModalTitle" style="font-size: 16px; color: var(--on-surface);">
                        Reset to Default?
                    </h2>
                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">This action cannot be undone.</p>
                </div>
            </div>
            <p style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.6; margin-bottom: 20px;">
                This will reset
                <strong><c:out value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" /></strong>
                back to its factory default value of
                <strong><c:out value="${not empty configParam.defaultValue ? configParam.defaultValue : '1,000'}" /></strong>.
                The change will be logged in the Audit Log.
            </p>
            <div class="d-flex align-items-center gap-2 justify-content-end">
                <button type="button" class="btn-edit-outline" id="btnCancelReset">Cancel</button>
                <form action="${pageContext.request.contextPath}/admin/config" method="POST" style="display:inline;">
                    <input type="hidden" name="action" value="reset" />
                    <input type="hidden" name="key"
                           value="${not empty param.key ? param.key : 'PENALTY_RATE_PER_DAY_VND'}" />
                    <button type="submit" class="btn-edit-danger">
                        <span class="material-symbols-outlined">restart_alt</span>
                        Yes, Reset
                    </button>
                </form>
            </div>
        </div>
    </div>

<script>
/* ── Sidebar active state ── */
(function() {
    var links = document.querySelectorAll('aside .sidebar-link');
    links.forEach(function(l) { l.classList.remove('active'); });
    links.forEach(function(l) {
        if (l.href && l.href.indexOf('config') !== -1) l.classList.add('active');
    });
})();

/* ── Category chip selection ── */
document.querySelectorAll('.type-chip-opt input').forEach(function(radio) {
    radio.addEventListener('change', function() {
        document.querySelectorAll('.type-chip-opt').forEach(function(c) { c.classList.remove('selected'); });
        this.closest('.type-chip-opt').classList.add('selected');
    });
});

/* ── Unit label live update ── */
var unitInput = document.getElementById('configUnit');
var unitLabel = document.getElementById('unitLabel');
if (unitInput && unitLabel) {
    unitInput.addEventListener('input', function() {
        unitLabel.textContent = this.value || '—';
    });
}

/* ── Description char count ── */
var descArea = document.getElementById('configDescription');
var descCount = document.getElementById('descCharCount');
if (descArea && descCount) {
    descCount.textContent = descArea.value.length;
    descArea.addEventListener('input', function() {
        descCount.textContent = this.value.length;
    });
}

/* ── Status label toggle ── */
var toggleSwitch = document.getElementById('configActive');
var statusLabel  = document.getElementById('statusLabel');
if (toggleSwitch && statusLabel) {
    toggleSwitch.addEventListener('change', function() {
        statusLabel.textContent = this.checked ? 'Active' : 'Inactive';
    });
}

/* ── Form validation ── */
document.getElementById('configEditForm').addEventListener('submit', function(e) {
    var valid = true;
    var keyInput    = document.getElementById('configKey');
    var nameInput   = document.getElementById('displayName');
    var valueInput  = document.getElementById('configValue');
    var reasonInput = document.getElementById('changeReason');

    function showErr(id) {
        document.getElementById(id).style.display = 'flex';
    }
    function hideErr(id) {
        document.getElementById(id).style.display = 'none';
    }

    hideErr('configKeyError'); hideErr('displayNameError');
    hideErr('configValueError'); hideErr('changeReasonError');

    if (!keyInput.value.trim() || !/^[A-Z0-9_]+$/.test(keyInput.value.trim())) {
        showErr('configKeyError'); if (valid) keyInput.focus(); valid = false;
    }
    if (!nameInput.value.trim()) {
        showErr('displayNameError'); if (valid) nameInput.focus(); valid = false;
    }
    if (!valueInput.value.trim()) {
        showErr('configValueError'); if (valid) valueInput.focus(); valid = false;
    }
    if (!reasonInput.value.trim()) {
        showErr('changeReasonError'); if (valid) reasonInput.focus(); valid = false;
    }
    if (!valid) e.preventDefault();
});

/* ── Reset Default Modal ── */
var resetModal = document.getElementById('resetModal');
var btnReset   = document.getElementById('btnResetDefault');
var btnCancel  = document.getElementById('btnCancelReset');

if (btnReset && resetModal) {
    btnReset.addEventListener('click', function() {
        resetModal.classList.add('open');
    });
}
if (btnCancel && resetModal) {
    btnCancel.addEventListener('click', function() {
        resetModal.classList.remove('open');
    });
}
resetModal && resetModal.addEventListener('click', function(e) {
    if (e.target === resetModal) resetModal.classList.remove('open');
});
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') resetModal && resetModal.classList.remove('open');
});
</script>

</body>
</html>
