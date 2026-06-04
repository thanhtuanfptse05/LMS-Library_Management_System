<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<%--
    Manager — Notification Broadcast
    Gửi thông báo hàng loạt hoặc theo đối tượng (học kỳ mới, thu hồi sách, nghỉ lễ, v.v.)
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ── Page-specific extras ── */
    .bcast-page-header {
        background-color: var(--surface-container-lowest, #ffffff);
        border-bottom: 1px solid var(--outline-variant);
        padding: 28px 0 20px;
    }

    /* ── Audience type card ── */
    .audience-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        padding: 18px 12px;
        border-radius: 14px;
        border: 2px solid var(--outline-variant);
        background-color: var(--surface-container-lowest, #ffffff);
        cursor: pointer;
        transition: border-color 0.18s ease, background-color 0.18s ease, transform 0.18s ease;
        text-align: center;
        user-select: none;
    }
    .audience-card:hover {
        border-color: var(--primary, #9d4300);
        background-color: var(--primary-fixed, #ffdbca);
        transform: translateY(-2px);
    }
    .audience-card.selected {
        border-color: var(--primary, #9d4300);
        background-color: var(--primary-fixed, #ffdbca);
        box-shadow: 0 0 0 3px rgba(157, 67, 0, 0.15);
    }
    .audience-card input[type="radio"] { display: none; }
    .audience-card .ac-icon {
        width: 48px; height: 48px;
        border-radius: 12px;
        display: flex; align-items: center; justify-content: center;
        font-size: 24px;
        background-color: var(--surface-container-high, #efe3d9);
        color: var(--on-surface-variant);
        transition: background-color 0.18s, color 0.18s;
    }
    .audience-card.selected .ac-icon {
        background-color: var(--primary, #9d4300);
        color: #fff;
    }
    .audience-card .ac-label {
        font-size: 13px;
        font-weight: 700;
        color: var(--on-surface, #251913);
    }
    .audience-card .ac-sublabel {
        font-size: 11px;
        color: var(--on-surface-variant);
    }

    /* ── Notification type chips ── */
    .type-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        border: 1.5px solid var(--outline-variant);
        background: var(--surface-container-lowest, #ffffff);
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.18s ease;
        user-select: none;
    }
    .type-chip:hover {
        border-color: var(--primary, #9d4300);
        color: var(--primary, #9d4300);
        background-color: rgba(157, 67, 0, 0.06);
    }
    .type-chip.selected {
        background-color: var(--primary, #9d4300);
        color: #ffffff;
        border-color: var(--primary, #9d4300);
    }
    .type-chip input[type="radio"] { display: none; }
    .type-chip .material-symbols-outlined { font-size: 15px; }

    /* ── Form area ── */
    .bcast-form-label {
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        color: var(--on-surface-variant);
        margin-bottom: 6px;
        display: block;
    }
    .bcast-input,
    .bcast-textarea,
    .bcast-select {
        width: 100%;
        border: 1.5px solid var(--outline-variant);
        border-radius: 10px;
        padding: 10px 14px;
        font-size: 14px;
        font-family: 'Inter', sans-serif;
        color: var(--on-surface, #251913);
        background-color: var(--surface-container-lowest, #ffffff);
        transition: border-color 0.18s ease, box-shadow 0.18s ease;
        outline: none;
    }
    .bcast-input:focus,
    .bcast-textarea:focus,
    .bcast-select:focus {
        border-color: var(--primary, #9d4300);
        box-shadow: 0 0 0 3px rgba(157, 67, 0, 0.12);
    }
    .bcast-textarea { resize: vertical; min-height: 120px; }

    /* ── Priority selector ── */
    .priority-row {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .priority-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        border: 1.5px solid transparent;
        cursor: pointer;
        transition: all 0.18s;
        user-select: none;
    }
    .priority-badge input[type="radio"] { display: none; }
    .priority-badge.prio-low  { background: rgba(22,163,74,0.08); color: #16a34a; border-color: rgba(22,163,74,0.25); }
    .priority-badge.prio-normal { background: rgba(0,99,152,0.08); color: var(--tertiary, #006398); border-color: rgba(0,99,152,0.25); }
    .priority-badge.prio-high { background: rgba(234,179,8,0.1); color: #854d0e; border-color: rgba(234,179,8,0.3); }
    .priority-badge.prio-urgent { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); border-color: rgba(186,26,26,0.3); }
    .priority-badge.selected { filter: brightness(0.88); transform: scale(0.97); }
    .priority-badge.prio-low.selected    { background: #16a34a; color: #fff; border-color: #16a34a; filter: none; }
    .priority-badge.prio-normal.selected { background: var(--tertiary, #006398); color: #fff; border-color: var(--tertiary); filter: none; }
    .priority-badge.prio-high.selected   { background: #854d0e; color: #fff; border-color: #854d0e; filter: none; }
    .priority-badge.prio-urgent.selected { background: var(--error, #ba1a1a); color: #fff; border-color: var(--error); filter: none; }

    /* ── Preview panel ── */
    .preview-panel {
        background: linear-gradient(135deg, rgba(157,67,0,0.04) 0%, var(--surface-container-lowest, #fff) 60%);
        border: 1px solid var(--outline-variant);
        border-left: 4px solid var(--primary, #9d4300);
        border-radius: 14px;
        padding: 20px;
    }
    .preview-panel .preview-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 3px 10px;
        border-radius: 999px;
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        background: rgba(157,67,0,0.1);
        color: var(--primary, #9d4300);
        margin-bottom: 8px;
    }
    .preview-panel .preview-title {
        font-size: 15px;
        font-weight: 700;
        color: var(--on-surface, #251913);
        margin-bottom: 6px;
    }
    .preview-panel .preview-body {
        font-size: 13px;
        color: var(--on-surface-variant);
        line-height: 1.6;
    }
    .preview-panel .preview-meta {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-top: 12px;
        flex-wrap: wrap;
    }
    .preview-panel .preview-meta-item {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 11px;
        color: var(--on-surface-variant);
        font-weight: 600;
    }
    .preview-panel .preview-meta-item .material-symbols-outlined { font-size: 14px; }

    /* ── Recipient count ── */
    .recipient-count-box {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 18px;
        background-color: var(--surface-container-low, #fff1eb);
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
    }
    .recipient-count-box .rc-icon {
        width: 42px; height: 42px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        background-color: var(--primary-fixed, #ffdbca);
        color: var(--primary, #9d4300);
        font-size: 22px;
        flex-shrink: 0;
    }
    .recipient-count-box .rc-count { font-size: 22px; font-weight: 700; color: var(--on-surface, #251913); }
    .recipient-count-box .rc-label { font-size: 12px; color: var(--on-surface-variant); }

    /* ── History table ── */
    .hist-row-status {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 3px 10px; border-radius: 999px;
        font-size: 11px; font-weight: 700;
    }
    .hist-row-status.sent    { background: rgba(22,163,74,0.1); color: #16a34a; }
    .hist-row-status.draft   { background: var(--surface-container-high, #efe3d9); color: var(--on-surface-variant); }
    .hist-row-status.failed  { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .hist-row-status.pending { background: rgba(234,179,8,0.1); color: #854d0e; }

    /* ── Submit buttons ── */
    .btn-broadcast-primary {
        display: inline-flex; align-items: center; gap: 8px;
        padding: 11px 24px; border-radius: 10px;
        font-size: 14px; font-weight: 700;
        background-color: var(--primary, #9d4300); color: #ffffff;
        border: none; cursor: pointer;
        transition: transform 0.15s ease, filter 0.15s ease;
    }
    .btn-broadcast-primary:hover { filter: brightness(110%); transform: scale(1.02); }
    .btn-broadcast-primary:active { transform: scale(0.98); }
    .btn-broadcast-primary .material-symbols-outlined { font-size: 18px; }

    .btn-broadcast-outline {
        display: inline-flex; align-items: center; gap: 8px;
        padding: 10px 20px; border-radius: 10px;
        font-size: 14px; font-weight: 700;
        background: transparent; color: var(--on-surface-variant);
        border: 1.5px solid var(--outline-variant); cursor: pointer;
        transition: all 0.15s ease;
    }
    .btn-broadcast-outline:hover {
        border-color: var(--primary, #9d4300);
        color: var(--primary, #9d4300);
        background-color: rgba(157, 67, 0, 0.04);
    }
    .btn-broadcast-outline .material-symbols-outlined { font-size: 18px; }

    /* ── Responsive ── */
    @media (max-width: 991.98px) {
        main { margin-left: 0 !important; }
        header.fixed-top > div { margin-left: 0 !important; }
    }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto" style="background-color: var(--background, #fff8f6); margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <!-- ══ Page Container ══ -->
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
                                    <a href="${pageContext.request.contextPath}/manager/dashboard"
                                       class="text-decoration-none text-on-surface-variant">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item active fw-semibold text-primary-custom"
                                    aria-current="page">Notification Broadcast</li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface, #251913);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">campaign</span>
                            Notification Broadcast
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            Compose and send targeted notifications to students, lecturers, or all members.
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                       class="btn-broadcast-outline text-decoration-none" style="color: var(--on-surface-variant);">
                        <span class="material-symbols-outlined">history</span>
                        View History
                    </a>
                </div>

                <!-- ─── Main 2-col Layout ─── -->
                <div class="row g-4">

                    <!-- ══ LEFT: Compose Form (8/12) ══ -->
                    <div class="col-12 col-lg-8">
                        <form id="broadcastForm" action="${pageContext.request.contextPath}/manager/notification-broadcast"
                              method="POST" novalidate>
                            <input type="hidden" name="action" value="send" />

                            <!-- Step 1: Choose audience -->
                            <div class="raised-card p-4 mb-4">
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-circle fw-bold text-white"
                                         style="width:26px;height:26px;background:var(--primary,#9d4300);font-size:12px;flex-shrink:0;">1</div>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Select Recipients</h2>
                                </div>

                                <div class="row g-3 mb-3" role="radiogroup" aria-labelledby="audienceGroupLabel">
                                    <span id="audienceGroupLabel" class="sr-only">Select recipient group</span>

                                    <!-- All users -->
                                    <div class="col-6 col-sm-3">
                                        <label class="audience-card w-100 selected" id="aud-all-label" for="aud-all">
                                            <input type="radio" name="audienceType" id="aud-all"
                                                   value="ALL" checked aria-label="All users" />
                                            <div class="ac-icon">
                                                <span class="material-symbols-outlined">groups</span>
                                            </div>
                                            <span class="ac-label">All Users</span>
                                            <span class="ac-sublabel">Everyone</span>
                                        </label>
                                    </div>

                                    <!-- Students only -->
                                    <div class="col-6 col-sm-3">
                                        <label class="audience-card w-100" id="aud-student-label" for="aud-student">
                                            <input type="radio" name="audienceType" id="aud-student"
                                                   value="STUDENT" aria-label="Students only" />
                                            <div class="ac-icon">
                                                <span class="material-symbols-outlined">school</span>
                                            </div>
                                            <span class="ac-label">Students</span>
                                            <span class="ac-sublabel">Members only</span>
                                        </label>
                                    </div>

                                    <!-- Lecturers only -->
                                    <div class="col-6 col-sm-3">
                                        <label class="audience-card w-100" id="aud-lecturer-label" for="aud-lecturer">
                                            <input type="radio" name="audienceType" id="aud-lecturer"
                                                   value="LECTURER" aria-label="Lecturers only" />
                                            <div class="ac-icon">
                                                <span class="material-symbols-outlined">person_book</span>
                                            </div>
                                            <span class="ac-label">Lecturers</span>
                                            <span class="ac-sublabel">Faculty only</span>
                                        </label>
                                    </div>

                                    <!-- Staff / Librarians -->
                                    <div class="col-6 col-sm-3">
                                        <label class="audience-card w-100" id="aud-staff-label" for="aud-staff">
                                            <input type="radio" name="audienceType" id="aud-staff"
                                                   value="STAFF" aria-label="Library staff" />
                                            <div class="ac-icon">
                                                <span class="material-symbols-outlined">badge</span>
                                            </div>
                                            <span class="ac-label">Library Staff</span>
                                            <span class="ac-sublabel">Librarians</span>
                                        </label>
                                    </div>
                                </div>

                                <!-- Specific user IDs (optional) -->
                                <div>
                                    <label class="bcast-form-label" for="specificUserIds">
                                        Specific User IDs
                                        <span style="font-size: 11px; text-transform: none; letter-spacing: 0; font-weight: 400; color: var(--on-surface-variant);">(optional — comma separated)</span>
                                    </label>
                                    <input type="text" id="specificUserIds" name="specificUserIds"
                                           class="bcast-input" placeholder="e.g. U001, U045, U120"
                                           aria-describedby="specificUserIdsHelp"
                                           value="${param.specificUserIds}" />
                                    <p id="specificUserIdsHelp" style="font-size: 11px; color: var(--on-surface-variant); margin-top: 4px; margin-bottom: 0;">
                                        Leave blank to send to the entire selected group.
                                    </p>
                                </div>

                                <!-- Estimated recipients -->
                                <div class="recipient-count-box mt-3">
                                    <div class="rc-icon">
                                        <span class="material-symbols-outlined">people</span>
                                    </div>
                                    <div>
                                        <div class="rc-count" id="recipientCountDisplay">
                                            <c:out value="${totalUserCount != null ? totalUserCount : '4,802'}" />
                                        </div>
                                        <div class="rc-label">Estimated recipients</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 2: Notification type -->
                            <div class="raised-card p-4 mb-4">
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-circle fw-bold text-white"
                                         style="width:26px;height:26px;background:var(--primary,#9d4300);font-size:12px;flex-shrink:0;">2</div>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Notification Type</h2>
                                </div>

                                <div class="d-flex flex-wrap gap-2" role="radiogroup" aria-label="Notification type">
                                    <label class="type-chip selected" for="type-announcement">
                                        <input type="radio" name="notifType" id="type-announcement"
                                               value="announcement" checked />
                                        <span class="material-symbols-outlined">campaign</span>
                                        Announcement
                                    </label>
                                    <label class="type-chip" for="type-holiday">
                                        <input type="radio" name="notifType" id="type-holiday"
                                               value="holiday" />
                                        <span class="material-symbols-outlined">event</span>
                                        Holiday / Closure
                                    </label>
                                    <label class="type-chip" for="type-recall">
                                        <input type="radio" name="notifType" id="type-recall"
                                               value="recall" />
                                        <span class="material-symbols-outlined">assignment_return</span>
                                        Book Recall
                                    </label>
                                    <label class="type-chip" for="type-overdue">
                                        <input type="radio" name="notifType" id="type-overdue"
                                               value="overdue" />
                                        <span class="material-symbols-outlined">warning</span>
                                        Overdue Alert
                                    </label>
                                    <label class="type-chip" for="type-policy">
                                        <input type="radio" name="notifType" id="type-policy"
                                               value="policy" />
                                        <span class="material-symbols-outlined">policy</span>
                                        Policy Update
                                    </label>
                                    <label class="type-chip" for="type-system">
                                        <input type="radio" name="notifType" id="type-system"
                                               value="system" />
                                        <span class="material-symbols-outlined">settings</span>
                                        System Notice
                                    </label>
                                </div>
                            </div>

                            <!-- Step 3: Compose content -->
                            <div class="raised-card p-4 mb-4">
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-circle fw-bold text-white"
                                         style="width:26px;height:26px;background:var(--primary,#9d4300);font-size:12px;flex-shrink:0;">3</div>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Compose Message</h2>
                                </div>

                                <!-- Subject / Title -->
                                <div class="mb-3">
                                    <label class="bcast-form-label" for="notifTitle">Notification Title *</label>
                                    <input type="text" id="notifTitle" name="notifTitle"
                                           class="bcast-input" required maxlength="200"
                                           placeholder="e.g. Library Closed on National Day — September 2, 2026"
                                           aria-required="true"
                                           value="${param.notifTitle}"/>
                                    <div id="titleError" class="text-danger" style="font-size: 12px; margin-top: 4px; display: none;">
                                        <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: -2px;">error</span>
                                        Title is required.
                                    </div>
                                </div>

                                <!-- Body -->
                                <div class="mb-3">
                                    <label class="bcast-form-label" for="notifBody">Message Body *</label>
                                    <textarea id="notifBody" name="notifBody"
                                              class="bcast-textarea" required maxlength="2000"
                                              placeholder="Write the full notification message here…"
                                              aria-required="true"
                                              rows="5"><c:out value="${param.notifBody}" /></textarea>
                                    <div class="d-flex justify-content-between mt-1">
                                        <div id="bodyError" class="text-danger" style="font-size: 12px; display: none;">
                                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: -2px;">error</span>
                                            Message body is required.
                                        </div>
                                        <span id="charCount" style="font-size: 11px; color: var(--on-surface-variant); margin-left: auto;">0 / 2000</span>
                                    </div>
                                </div>

                                <!-- Action URL (optional) -->
                                <div class="mb-3">
                                    <label class="bcast-form-label" for="actionUrl">
                                        Action URL
                                        <span style="font-size: 11px; text-transform: none; letter-spacing: 0; font-weight: 400;">(optional)</span>
                                    </label>
                                    <input type="text" id="actionUrl" name="actionUrl"
                                           class="bcast-input"
                                           placeholder="/student/loans  or  /policies.jsp"
                                           value="${param.actionUrl}" />
                                </div>
                                <div class="mb-3">
                                    <label class="bcast-form-label" for="actionLabel">
                                        Action Button Label
                                        <span style="font-size: 11px; text-transform: none; letter-spacing: 0; font-weight: 400;">(optional)</span>
                                    </label>
                                    <input type="text" id="actionLabel" name="actionLabel"
                                           class="bcast-input" maxlength="60"
                                           placeholder="e.g. View Details, Return Book, Read Policy"
                                           value="${param.actionLabel}" />
                                </div>
                            </div>

                            <!-- Step 4: Priority & schedule -->
                            <div class="raised-card p-4 mb-4">
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-circle fw-bold text-white"
                                         style="width:26px;height:26px;background:var(--primary,#9d4300);font-size:12px;flex-shrink:0;">4</div>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Priority & Delivery</h2>
                                </div>

                                <!-- Priority -->
                                <label class="bcast-form-label">Priority Level</label>
                                <div class="priority-row mb-3" role="radiogroup" aria-label="Priority level">
                                    <label class="priority-badge prio-low" for="prio-low">
                                        <input type="radio" name="priority" id="prio-low" value="LOW" />
                                        <span class="material-symbols-outlined" style="font-size: 14px;">arrow_downward</span>
                                        Low
                                    </label>
                                    <label class="priority-badge prio-normal selected" for="prio-normal">
                                        <input type="radio" name="priority" id="prio-normal" value="NORMAL" checked />
                                        <span class="material-symbols-outlined" style="font-size: 14px;">remove</span>
                                        Normal
                                    </label>
                                    <label class="priority-badge prio-high" for="prio-high">
                                        <input type="radio" name="priority" id="prio-high" value="HIGH" />
                                        <span class="material-symbols-outlined" style="font-size: 14px;">arrow_upward</span>
                                        High
                                    </label>
                                    <label class="priority-badge prio-urgent" for="prio-urgent">
                                        <input type="radio" name="priority" id="prio-urgent" value="URGENT" />
                                        <span class="material-symbols-outlined" style="font-size: 14px;">priority_high</span>
                                        Urgent
                                    </label>
                                </div>

                                <!-- Scheduled send time -->
                                <div class="row g-3">
                                    <div class="col-12 col-sm-6">
                                        <label class="bcast-form-label" for="scheduledDate">
                                            Send Date
                                            <span style="font-size: 11px; text-transform: none; letter-spacing: 0; font-weight: 400;">(leave blank to send now)</span>
                                        </label>
                                        <input type="date" id="scheduledDate" name="scheduledDate"
                                               class="bcast-input"
                                               value="${param.scheduledDate}" />
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <label class="bcast-form-label" for="scheduledTime">Send Time</label>
                                        <input type="time" id="scheduledTime" name="scheduledTime"
                                               class="bcast-input"
                                               value="${param.scheduledTime != null ? param.scheduledTime : '08:00'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex align-items-center gap-3 flex-wrap">
                                <button type="submit" name="submitAction" value="send"
                                        class="btn-broadcast-primary" id="btnSend"
                                        aria-label="Send notification now">
                                    <span class="material-symbols-outlined">send</span>
                                    Send Now
                                </button>
                                <button type="submit" name="submitAction" value="schedule"
                                        class="btn-broadcast-outline" id="btnSchedule"
                                        aria-label="Schedule notification for later">
                                    <span class="material-symbols-outlined">schedule_send</span>
                                    Schedule
                                </button>
                                <button type="submit" name="submitAction" value="draft"
                                        class="btn-broadcast-outline" id="btnSaveDraft"
                                        aria-label="Save as draft">
                                    <span class="material-symbols-outlined">draft</span>
                                    Save Draft
                                </button>
                                <button type="reset" class="btn-broadcast-outline ms-auto" id="btnReset"
                                        aria-label="Reset form">
                                    <span class="material-symbols-outlined">restart_alt</span>
                                    Reset
                                </button>
                            </div>

                        </form>
                    </div><!-- /col-lg-8 -->

                    <!-- ══ RIGHT: Preview + History (4/12) ══ -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Live Preview -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex align-items-center gap-2"
                                 style="background: var(--surface-container-lowest,#fff); border-bottom: 1px solid var(--outline-variant);">
                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary, #9d4300);">preview</span>
                                <h3 class="fw-bold mb-0" style="font-size: 15px; color: var(--on-surface);">Live Preview</h3>
                            </div>
                            <div class="p-3">
                                <div class="preview-panel" id="previewPanel">
                                    <div class="preview-badge" id="previewBadge">
                                        <span class="material-symbols-outlined" style="font-size: 13px;">campaign</span>
                                        <span id="previewBadgeText">Announcement</span>
                                    </div>
                                    <div class="preview-title" id="previewTitle">Notification title appears here</div>
                                    <div class="preview-body" id="previewBody">
                                        Your notification message will appear here as you type.
                                    </div>
                                    <div class="preview-meta">
                                        <span class="preview-meta-item">
                                            <span class="material-symbols-outlined">groups</span>
                                            <span id="previewAudience">All Users</span>
                                        </span>
                                        <span class="preview-meta-item">
                                            <span class="material-symbols-outlined">remove</span>
                                            <span id="previewPriority">Normal</span>
                                        </span>
                                        <span class="preview-meta-item">
                                            <span class="material-symbols-outlined">schedule</span>
                                            Now
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Broadcast History -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center"
                                 style="background: var(--surface-container-lowest,#fff); border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-bold mb-0" style="font-size: 15px; color: var(--on-surface);">Recent Broadcasts</h3>
                                <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                   class="text-primary-custom fw-bold text-decoration-none" style="font-size: 12px;">View all →</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0" style="min-width: 340px;">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>To</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentBroadcasts}">
                                                <c:forEach var="b" items="${recentBroadcasts}">
                                                    <tr>
                                                        <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                            <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp?id=${b.id}"
                                                               class="text-decoration-none text-on-surface">
                                                                <c:out value="${b.title}" />
                                                            </a>
                                                        </td>
                                                        <td style="font-size: 12px; color: var(--on-surface-variant);">
                                                            <c:out value="${b.audienceType}" />
                                                        </td>
                                                        <td>
                                                            <span class="hist-row-status ${b.status == 'SENT' ? 'sent' : b.status == 'DRAFT' ? 'draft' : b.status == 'FAILED' ? 'failed' : 'pending'}">
                                                                <c:out value="${b.status}" />
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Fallback demo rows -->
                                                <tr>
                                                    <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                                           class="text-decoration-none text-on-surface">Library Closed — Jun 2</a>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">All Users</td>
                                                    <td><span class="hist-row-status sent">SENT</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                                           class="text-decoration-none text-on-surface">Book Recall — SE301</a>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">Students</td>
                                                    <td><span class="hist-row-status sent">SENT</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                                           class="text-decoration-none text-on-surface">Policy Update v2.1</a>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">All Users</td>
                                                    <td><span class="hist-row-status sent">SENT</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                                           class="text-decoration-none text-on-surface">Semester Reminder Draft</a>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">Lecturers</td>
                                                    <td><span class="hist-row-status draft">DRAFT</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-size: 13px; font-weight: 600; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                                           class="text-decoration-none text-on-surface">Exam Period Hours</a>
                                                    </td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">All Users</td>
                                                    <td><span class="hist-row-status pending">PENDING</span></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Broadcast Tips -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="material-symbols-outlined" style="color: var(--tertiary, #006398); font-size: 20px;">lightbulb</span>
                                <h3 class="fw-bold mb-0" style="font-size: 14px; color: var(--on-surface);">Broadcast Tips</h3>
                            </div>
                            <div class="d-flex flex-column gap-2">
                                <div class="d-flex gap-2 align-items-start">
                                    <span class="material-symbols-outlined flex-shrink-0"
                                          style="font-size: 16px; color: #16a34a; margin-top: 1px;">check_circle</span>
                                    <p style="font-size: 12px; color: var(--on-surface-variant); margin: 0;">
                                        Keep titles under <strong>80 characters</strong> for best readability on mobile.
                                    </p>
                                </div>
                                <div class="d-flex gap-2 align-items-start">
                                    <span class="material-symbols-outlined flex-shrink-0"
                                          style="font-size: 16px; color: #16a34a; margin-top: 1px;">check_circle</span>
                                    <p style="font-size: 12px; color: var(--on-surface-variant); margin: 0;">
                                        Use <strong>Urgent</strong> priority only for critical recalls or closures.
                                    </p>
                                </div>
                                <div class="d-flex gap-2 align-items-start">
                                    <span class="material-symbols-outlined flex-shrink-0"
                                          style="font-size: 16px; color: #16a34a; margin-top: 1px;">check_circle</span>
                                    <p style="font-size: 12px; color: var(--on-surface-variant); margin: 0;">
                                        Include a clear <strong>action URL</strong> so recipients know what to do next.
                                    </p>
                                </div>
                                <div class="d-flex gap-2 align-items-start">
                                    <span class="material-symbols-outlined flex-shrink-0"
                                          style="font-size: 16px; color: var(--tertiary, #006398); margin-top: 1px;">info</span>
                                    <p style="font-size: 12px; color: var(--on-surface-variant); margin: 0;">
                                        Scheduled broadcasts are queued via the async email service. Delivery may take up to 5 minutes.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

</body>

<script>
/* ══ Audience card selection ══ */
document.querySelectorAll('.audience-card input[type="radio"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        document.querySelectorAll('.audience-card').forEach(function(card) { card.classList.remove('selected'); });
        this.closest('.audience-card').classList.add('selected');
        updatePreviewAudience(this.value);
    });
});

function updatePreviewAudience(val) {
    var map = { ALL: 'All Users', STUDENT: 'Students', LECTURER: 'Lecturers', STAFF: 'Library Staff' };
    var el = document.getElementById('previewAudience');
    if (el) el.textContent = map[val] || val;
}

/* ══ Type chip selection ══ */
document.querySelectorAll('.type-chip input[type="radio"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        document.querySelectorAll('.type-chip').forEach(function(chip) { chip.classList.remove('selected'); });
        this.closest('.type-chip').classList.add('selected');
        var label = this.closest('.type-chip').textContent.trim();
        var badge = document.getElementById('previewBadgeText');
        if (badge) badge.textContent = label;
    });
});

/* ══ Priority selection ══ */
document.querySelectorAll('.priority-badge input[type="radio"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        document.querySelectorAll('.priority-badge').forEach(function(b) { b.classList.remove('selected'); });
        this.closest('.priority-badge').classList.add('selected');
        var prioText = { LOW: 'Low', NORMAL: 'Normal', HIGH: 'High', URGENT: 'Urgent' };
        var el = document.getElementById('previewPriority');
        if (el) el.textContent = prioText[this.value] || this.value;
    });
});

/* ══ Live preview updates ══ */
var titleInput = document.getElementById('notifTitle');
var bodyInput  = document.getElementById('notifBody');
var charCount  = document.getElementById('charCount');

if (titleInput) {
    titleInput.addEventListener('input', function() {
        var el = document.getElementById('previewTitle');
        if (el) el.textContent = this.value || 'Notification title appears here';
        document.getElementById('titleError').style.display = 'none';
    });
}
if (bodyInput) {
    bodyInput.addEventListener('input', function() {
        var el = document.getElementById('previewBody');
        if (el) el.textContent = this.value || 'Your notification message will appear here as you type.';
        if (charCount) charCount.textContent = this.value.length + ' / 2000';
        document.getElementById('bodyError').style.display = 'none';
    });
}

/* ══ Form validation ══ */
document.getElementById('broadcastForm').addEventListener('submit', function(e) {
    var valid = true;
    if (!titleInput.value.trim()) {
        document.getElementById('titleError').style.display = 'block';
        titleInput.focus(); valid = false;
    }
    if (!bodyInput.value.trim()) {
        document.getElementById('bodyError').style.display = 'block';
        if (valid) bodyInput.focus(); valid = false;
    }
    if (!valid) e.preventDefault();
});
</script>

</html>
