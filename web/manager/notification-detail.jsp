<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<%--
    Manager — Notification Detail
    Trang chi tiết xem nội dung thông báo và lịch sử broadcast đã gửi.
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation (position: fixed)
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ══ Page-specific styles ══ */

    /* ── Status pill ── */
    .status-pill {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 5px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.04em;
    }
    .status-pill.sent    { background: rgba(22,163,74,0.1); color: #16a34a; border: 1px solid rgba(22,163,74,0.25); }
    .status-pill.draft   { background: var(--surface-container-high, #efe3d9); color: var(--on-surface-variant); border: 1px solid var(--outline-variant); }
    .status-pill.failed  { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); border: 1px solid rgba(186,26,26,0.25); }
    .status-pill.pending { background: rgba(234,179,8,0.1); color: #854d0e; border: 1px solid rgba(234,179,8,0.3); }
    .status-pill.cancelled { background: var(--surface-container-high, #efe3d9); color: var(--on-surface-variant); border: 1px solid var(--outline-variant); }
    .status-pill .material-symbols-outlined { font-size: 14px; }

    /* ── Meta info strip ── */
    .meta-strip {
        display: flex;
        flex-wrap: wrap;
        gap: 0;
        background: var(--surface-container-low, #fff1eb);
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
        overflow: hidden;
    }
    .meta-strip-item {
        flex: 1;
        min-width: 130px;
        padding: 14px 18px;
        border-right: 1px solid var(--outline-variant);
        display: flex;
        flex-direction: column;
        gap: 3px;
    }
    .meta-strip-item:last-child { border-right: none; }
    .meta-strip-item .msi-label {
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: var(--on-surface-variant);
    }
    .meta-strip-item .msi-value {
        font-size: 14px;
        font-weight: 700;
        color: var(--on-surface, #251913);
    }
    .meta-strip-item .msi-icon { font-size: 16px; color: var(--primary, #9d4300); }

    /* ── Notification content card ── */
    .notif-content-card {
        background: linear-gradient(135deg, rgba(157,67,0,0.04) 0%, var(--surface-container-lowest, #fff) 60%);
        border: 1px solid var(--outline-variant);
        border-left: 5px solid var(--primary, #9d4300);
        border-radius: 14px;
        padding: 28px 28px 24px;
    }
    .notif-content-card.type-holiday { border-left-color: #16a34a; }
    .notif-content-card.type-recall  { border-left-color: #854d0e; }
    .notif-content-card.type-overdue { border-left-color: var(--error, #ba1a1a); }
    .notif-content-card.type-policy  { border-left-color: var(--tertiary, #006398); }
    .notif-content-card.type-system  { border-left-color: var(--on-surface-variant); }

    .notif-type-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 3px 10px;
        border-radius: 999px;
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        margin-bottom: 10px;
    }
    .notif-type-badge.type-announcement { background: rgba(157,67,0,0.1); color: var(--primary, #9d4300); }
    .notif-type-badge.type-holiday  { background: rgba(22,163,74,0.1); color: #16a34a; }
    .notif-type-badge.type-recall   { background: rgba(234,179,8,0.1); color: #854d0e; }
    .notif-type-badge.type-overdue  { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .notif-type-badge.type-policy   { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); }
    .notif-type-badge.type-system   { background: var(--surface-container-high, #efe3d9); color: var(--on-surface-variant); }
    .notif-type-badge .material-symbols-outlined { font-size: 13px; }

    .notif-title-display {
        font-size: 22px;
        font-weight: 700;
        color: var(--on-surface, #251913);
        line-height: 1.3;
        margin-bottom: 12px;
    }
    .notif-body-display {
        font-size: 15px;
        color: var(--on-surface-variant);
        line-height: 1.75;
        margin-bottom: 16px;
        white-space: pre-wrap;
        max-width: 680px;
    }
    .notif-action-link {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 18px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 700;
        background-color: var(--primary, #9d4300);
        color: #ffffff;
        text-decoration: none;
        transition: filter 0.15s ease, transform 0.15s ease;
    }
    .notif-action-link:hover { filter: brightness(110%); transform: scale(1.02); color: #fff; }
    .notif-action-link .material-symbols-outlined { font-size: 16px; }

    /* ── Delivery stats cards ── */
    .delivery-stat-card {
        background: var(--surface-container-lowest, #fff);
        border: 1px solid var(--outline-variant);
        border-radius: 14px;
        padding: 18px 20px;
        display: flex;
        align-items: center;
        gap: 14px;
        transition: box-shadow 0.18s ease;
    }
    .delivery-stat-card:hover { box-shadow: 0 4px 14px rgba(0,0,0,0.06); }
    .delivery-stat-card .dsc-icon {
        width: 44px; height: 44px;
        border-radius: 11px;
        display: flex; align-items: center; justify-content: center;
        font-size: 22px;
        flex-shrink: 0;
    }
    .delivery-stat-card .dsc-value { font-size: 22px; font-weight: 700; color: var(--on-surface, #251913); line-height: 1; }
    .delivery-stat-card .dsc-label { font-size: 11px; color: var(--on-surface-variant); font-weight: 600; }

    /* ── Recipient table ── */
    .recipient-status-dot {
        width: 8px; height: 8px;
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
    }
    .recipient-status-dot.read   { background-color: #16a34a; }
    .recipient-status-dot.unread { background-color: var(--outline, #8c7164); }
    .recipient-status-dot.failed { background-color: var(--error, #ba1a1a); }

    /* ── Filter tabs for recipient list ── */
    .recip-tab {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 6px 14px; border-radius: 999px;
        font-size: 12px; font-weight: 700;
        border: 1px solid var(--outline-variant);
        background: var(--surface-container-lowest, #fff);
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.15s ease;
        user-select: none;
    }
    .recip-tab:hover { border-color: var(--primary, #9d4300); color: var(--primary, #9d4300); }
    .recip-tab.active {
        background: var(--primary, #9d4300);
        color: #fff;
        border-color: var(--primary, #9d4300);
    }
    .recip-tab .material-symbols-outlined { font-size: 13px; }

    /* ── Timeline ── */
    .timeline-item {
        display: flex;
        gap: 14px;
        position: relative;
    }
    .timeline-item:not(:last-child)::before {
        content: '';
        position: absolute;
        left: 14px;
        top: 36px;
        bottom: -12px;
        width: 2px;
        background-color: var(--outline-variant);
    }
    .timeline-dot {
        width: 30px; height: 30px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
        font-size: 16px;
        z-index: 1;
    }
    .timeline-dot.success { background: rgba(22,163,74,0.1); color: #16a34a; border: 2px solid #16a34a; }
    .timeline-dot.info    { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); border: 2px solid var(--tertiary, #006398); }
    .timeline-dot.warning { background: rgba(234,179,8,0.1); color: #854d0e; border: 2px solid rgba(234,179,8,0.5); }
    .timeline-dot.error   { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); border: 2px solid var(--error, #ba1a1a); }
    .timeline-content { flex: 1; padding-bottom: 16px; }
    .timeline-content .tc-title { font-size: 13px; font-weight: 700; color: var(--on-surface, #251913); }
    .timeline-content .tc-time  { font-size: 11px; color: var(--on-surface-variant); margin-top: 2px; }
    .timeline-content .tc-body  { font-size: 12px; color: var(--on-surface-variant); margin-top: 4px; line-height: 1.5; }

    /* ── Action buttons ── */
    .btn-detail-action {
        display: inline-flex; align-items: center; gap: 6px;
        padding: 8px 18px; border-radius: 8px;
        font-size: 13px; font-weight: 700;
        cursor: pointer;
        transition: all 0.15s ease;
        border: none;
    }
    .btn-detail-action.primary {
        background: var(--primary, #9d4300); color: #fff;
    }
    .btn-detail-action.primary:hover { filter: brightness(110%); transform: scale(1.02); }
    .btn-detail-action.outline {
        background: transparent; color: var(--on-surface-variant);
        border: 1.5px solid var(--outline-variant);
    }
    .btn-detail-action.outline:hover { border-color: var(--primary); color: var(--primary); }
    .btn-detail-action.danger {
        background: transparent; color: var(--error, #ba1a1a);
        border: 1.5px solid rgba(186,26,26,0.3);
    }
    .btn-detail-action.danger:hover { background: var(--error-container, #ffdad6); border-color: var(--error); }
    .btn-detail-action .material-symbols-outlined { font-size: 16px; }

    /* ── Responsive ── */
    @media (max-width: 991.98px) {
        .d-flex.main-wrapper main { margin-left: 0 !important; }
        .meta-strip-item { min-width: 100%; border-right: none; border-bottom: 1px solid var(--outline-variant); }
        .meta-strip-item:last-child { border-bottom: none; }
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
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/manager/notification-broadcast.jsp"
                                       class="text-decoration-none text-on-surface-variant">Broadcasts</a>
                                </li>
                                <li class="breadcrumb-item active fw-semibold text-primary-custom" aria-current="page">
                                    Notification Detail
                                </li>
                            </ol>
                        </nav>
                        <h1 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-surface, #251913);">
                            <span class="material-symbols-outlined me-2"
                                  style="font-size: 26px; vertical-align: -4px; color: var(--primary, #9d4300);
                                         font-variation-settings: 'FILL' 1;">notifications</span>
                            Notification Detail
                        </h1>
                        <p style="font-size: 14px; color: var(--on-surface-variant); margin: 0;">
                            View broadcast content, delivery statistics, and recipient engagement.
                        </p>
                    </div>
                    <!-- Page-level actions -->
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <c:choose>
                            <c:when test="${notification.status == 'DRAFT' or empty notification}">
                                <a href="${pageContext.request.contextPath}/manager/notification-broadcast.jsp?id=${notification.id}"
                                   class="btn-detail-action primary text-decoration-none"
                                   aria-label="Edit and send this notification">
                                    <span class="material-symbols-outlined">edit</span>
                                    Edit &amp; Send
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-detail-action primary"
                                        onclick="window.location='${pageContext.request.contextPath}/manager/notification-broadcast.jsp'"
                                        aria-label="Create a similar notification">
                                    <span class="material-symbols-outlined">content_copy</span>
                                    Duplicate
                                </button>
                            </c:otherwise>
                        </c:choose>
                        <button class="btn-detail-action outline" id="btnExport" aria-label="Export notification data">
                            <span class="material-symbols-outlined">download</span>
                            Export
                        </button>
                        <button class="btn-detail-action danger" id="btnDelete"
                                aria-label="Delete notification"
                                data-bs-toggle="modal" data-bs-target="#deleteModal">
                            <span class="material-symbols-outlined">delete</span>
                            Delete
                        </button>
                    </div>
                </div>

                <!-- ─── Main 2-col Layout ─── -->
                <div class="row g-4">

                    <!-- ══ LEFT: Content + Recipients (8/12) ══ -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Notification Content -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex align-items-center justify-content-between"
                                 style="background: var(--surface-container-lowest, #fff); border-bottom: 1px solid var(--outline-variant);">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined" style="color: var(--primary, #9d4300);">article</span>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Notification Content</h2>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty notification}">
                                        <span class="status-pill ${notification.status == 'SENT' ? 'sent' : notification.status == 'DRAFT' ? 'draft' : notification.status == 'FAILED' ? 'failed' : 'pending'}">
                                            <span class="material-symbols-outlined">
                                                <c:choose>
                                                    <c:when test="${notification.status == 'SENT'}">check_circle</c:when>
                                                    <c:when test="${notification.status == 'DRAFT'}">draft</c:when>
                                                    <c:when test="${notification.status == 'FAILED'}">error</c:when>
                                                    <c:otherwise>schedule</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <c:out value="${notification.status}" />
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill sent">
                                            <span class="material-symbols-outlined">check_circle</span>
                                            SENT
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-4">
                                <!-- Notification card -->
                                <div class="notif-content-card
                                     ${not empty notification ? 'type-' += notification.notifType : 'type-announcement'}">
                                    <c:choose>
                                        <c:when test="${not empty notification}">
                                            <div class="notif-type-badge type-${notification.notifType}">
                                                <span class="material-symbols-outlined">
                                                    <c:choose>
                                                        <c:when test="${notification.notifType == 'announcement'}">campaign</c:when>
                                                        <c:when test="${notification.notifType == 'holiday'}">event</c:when>
                                                        <c:when test="${notification.notifType == 'recall'}">assignment_return</c:when>
                                                        <c:when test="${notification.notifType == 'overdue'}">warning</c:when>
                                                        <c:when test="${notification.notifType == 'policy'}">policy</c:when>
                                                        <c:otherwise>settings</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <c:out value="${notification.notifType}" />
                                            </div>
                                            <div class="notif-title-display"><c:out value="${notification.title}" /></div>
                                            <div class="notif-body-display"><c:out value="${notification.body}" /></div>
                                            <c:if test="${not empty notification.actionUrl}">
                                                <a href="${pageContext.request.contextPath}${notification.actionUrl}"
                                                   class="notif-action-link">
                                                    <span class="material-symbols-outlined">arrow_forward</span>
                                                    <c:out value="${not empty notification.actionLabel ? notification.actionLabel : 'View Details'}" />
                                                </a>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Demo fallback content --%>
                                            <div class="notif-type-badge type-announcement">
                                                <span class="material-symbols-outlined">campaign</span>
                                                Announcement
                                            </div>
                                            <div class="notif-title-display">
                                                Library Closed — National Day Holiday, September 2, 2026
                                            </div>
                                            <div class="notif-body-display">
Dear library members,

The university library will be closed on <strong>Tuesday, September 2, 2026</strong> in observance of the National Day public holiday.

Regular library services, including book borrowing, returns, and reading room access, will be suspended for the day. All existing loans due on this date will be automatically extended by one day with no late fee penalty.

The library will resume normal operations on <strong>Wednesday, September 3, 2026</strong> at 7:30 AM.

We appreciate your understanding. Happy National Day!

— Library Management Team
                                            </div>
                                            <a href="${pageContext.request.contextPath}/policies.jsp"
                                               class="notif-action-link">
                                                <span class="material-symbols-outlined">arrow_forward</span>
                                                View Library Hours
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Delivery Statistics -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="material-symbols-outlined" style="color: var(--primary, #9d4300);">analytics</span>
                                <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Delivery Statistics</h2>
                            </div>
                            <div class="row g-3">
                                <div class="col-6 col-md-3">
                                    <div class="delivery-stat-card">
                                        <div class="dsc-icon" style="background: rgba(157,67,0,0.1);">
                                            <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">send</span>
                                        </div>
                                        <div>
                                            <div class="dsc-value">
                                                <c:out value="${notification.totalSent != null ? notification.totalSent : '4,802'}" />
                                            </div>
                                            <div class="dsc-label">Total Sent</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="delivery-stat-card">
                                        <div class="dsc-icon" style="background: rgba(22,163,74,0.1);">
                                            <span class="material-symbols-outlined" style="color: #16a34a;">mark_email_read</span>
                                        </div>
                                        <div>
                                            <div class="dsc-value" style="color: #16a34a;">
                                                <c:out value="${notification.totalRead != null ? notification.totalRead : '3,147'}" />
                                            </div>
                                            <div class="dsc-label">Read</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="delivery-stat-card">
                                        <div class="dsc-icon" style="background: rgba(0,99,152,0.1);">
                                            <span class="material-symbols-outlined" style="color: var(--tertiary,#006398);">ads_click</span>
                                        </div>
                                        <div>
                                            <div class="dsc-value" style="color: var(--tertiary,#006398);">
                                                <c:out value="${notification.totalClicked != null ? notification.totalClicked : '892'}" />
                                            </div>
                                            <div class="dsc-label">Clicked</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="delivery-stat-card">
                                        <div class="dsc-icon" style="background: var(--error-container,#ffdad6);">
                                            <span class="material-symbols-outlined" style="color: var(--error,#ba1a1a);">error</span>
                                        </div>
                                        <div>
                                            <div class="dsc-value" style="color: var(--error,#ba1a1a);">
                                                <c:out value="${notification.totalFailed != null ? notification.totalFailed : '12'}" />
                                            </div>
                                            <div class="dsc-label">Failed</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Read rate progress bar -->
                            <div class="mt-4">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span style="font-size: 12px; font-weight: 700; color: var(--on-surface-variant);">READ RATE</span>
                                    <span style="font-size: 12px; font-weight: 700; color: #16a34a;" id="readRateText">65.5%</span>
                                </div>
                                <div class="mini-progress" style="height: 8px;">
                                    <div class="mini-progress-bar" id="readRateBar"
                                         style="width: 65.5%; background: linear-gradient(90deg, #16a34a, #22c55e);"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">0%</span>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Click rate: 18.6%</span>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">100%</span>
                                </div>
                            </div>
                        </div>

                        <!-- Recipient List -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex align-items-center justify-content-between flex-wrap gap-2"
                                 style="background: var(--surface-container-lowest,#fff); border-bottom: 1px solid var(--outline-variant);">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined" style="color: var(--primary, #9d4300);">people</span>
                                    <h2 class="fw-bold mb-0" style="font-size: 16px; color: var(--on-surface);">Recipient Details</h2>
                                </div>
                                <!-- Filter tabs -->
                                <div class="d-flex gap-2" role="tablist" aria-label="Filter recipients">
                                    <button class="recip-tab active" data-filter="all" id="recip-tab-all"
                                            role="tab" aria-selected="true" aria-controls="recipientTable">
                                        All
                                    </button>
                                    <button class="recip-tab" data-filter="read" id="recip-tab-read"
                                            role="tab" aria-selected="false">
                                        <span class="material-symbols-outlined">mark_email_read</span>
                                        Read
                                    </button>
                                    <button class="recip-tab" data-filter="unread" id="recip-tab-unread"
                                            role="tab" aria-selected="false">
                                        <span class="material-symbols-outlined">mark_email_unread</span>
                                        Unread
                                    </button>
                                    <button class="recip-tab" data-filter="failed" id="recip-tab-failed"
                                            role="tab" aria-selected="false">
                                        <span class="material-symbols-outlined">error</span>
                                        Failed
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0" id="recipientTable">
                                    <thead>
                                        <tr>
                                            <th>Recipient</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th>Read At</th>
                                            <th>Clicked</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recipients}">
                                                <c:forEach var="r" items="${recipients}">
                                                    <tr data-status="${r.readStatus}">
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar"
                                                                     style="background-color: var(--primary-fixed); color: var(--on-primary-container);">
                                                                    <c:out value="${r.initials}" />
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${r.name}" /></p>
                                                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;"><c:out value="${r.email}" /></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge-pill"
                                                                  style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">
                                                                <c:out value="${r.role}" />
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="${r.readStatus == 'read' ? 'text-success' : r.readStatus == 'failed' ? 'text-danger' : 'text-on-surface-variant'}"
                                                                  style="font-size: 13px; font-weight: 600;">
                                                                <span class="recipient-status-dot ${r.readStatus}"></span>
                                                                <c:choose>
                                                                    <c:when test="${r.readStatus == 'read'}">Read</c:when>
                                                                    <c:when test="${r.readStatus == 'failed'}">Failed</c:when>
                                                                    <c:otherwise>Unread</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td style="font-size: 12px; color: var(--on-surface-variant);">
                                                            <c:choose>
                                                                <c:when test="${not empty r.readAt}">
                                                                    <fmt:formatDate value="${r.readAt}" pattern="dd/MM/yyyy HH:mm" />
                                                                </c:when>
                                                                <c:otherwise>—</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="font-size: 13px; text-align: center;">
                                                            <c:choose>
                                                                <c:when test="${r.clicked}">
                                                                    <span class="material-symbols-outlined" style="font-size: 16px; color: #16a34a;">check</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="color: var(--on-surface-variant);">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- Fallback demo recipients --%>
                                                <tr data-status="read">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">NV</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13px;">Nguyen Van An</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">an.nv@fpt.edu.vn</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">STUDENT</span></td>
                                                    <td><span style="font-size: 13px; font-weight: 600; color: #16a34a;"><span class="recipient-status-dot read"></span>Read</span></td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">03/06/2026 08:42</td>
                                                    <td style="font-size: 13px; text-align: center;"><span class="material-symbols-outlined" style="font-size: 16px; color: #16a34a;">check</span></td>
                                                </tr>
                                                <tr data-status="read">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed-variant);">TH</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13px;">Tran Thi Huong</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">huong.tt@fpt.edu.vn</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">LECTURER</span></td>
                                                    <td><span style="font-size: 13px; font-weight: 600; color: #16a34a;"><span class="recipient-status-dot read"></span>Read</span></td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">03/06/2026 09:15</td>
                                                    <td style="font-size: 13px; text-align: center;"><span style="color: var(--on-surface-variant);">—</span></td>
                                                </tr>
                                                <tr data-status="unread">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed);">LM</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13px;">Le Minh Duc</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">duc.lm@fpt.edu.vn</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">STUDENT</span></td>
                                                    <td><span style="font-size: 13px; font-weight: 600; color: var(--on-surface-variant);"><span class="recipient-status-dot unread"></span>Unread</span></td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">—</td>
                                                    <td style="font-size: 13px; text-align: center;"><span style="color: var(--on-surface-variant);">—</span></td>
                                                </tr>
                                                <tr data-status="failed">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--error-container); color: var(--error);">PQ</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13px;">Phan Quoc Bao</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">bao.pq@fpt.edu.vn</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">STUDENT</span></td>
                                                    <td><span style="font-size: 13px; font-weight: 600; color: var(--error);"><span class="recipient-status-dot failed"></span>Failed</span></td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">—</td>
                                                    <td style="font-size: 13px; text-align: center;"><span style="color: var(--on-surface-variant);">—</span></td>
                                                </tr>
                                                <tr data-status="unread">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">HT</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13px;">Hoang Thi Lan</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">lan.ht@fpt.edu.vn</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background: var(--surface-container-high); color: var(--on-surface-variant); font-size: 11px;">STUDENT</span></td>
                                                    <td><span style="font-size: 13px; font-weight: 600; color: var(--on-surface-variant);"><span class="recipient-status-dot unread"></span>Unread</span></td>
                                                    <td style="font-size: 12px; color: var(--on-surface-variant);">—</td>
                                                    <td style="font-size: 13px; text-align: center;"><span style="color: var(--on-surface-variant);">—</span></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Pagination -->
                            <div class="p-3 d-flex justify-content-between align-items-center flex-wrap gap-2"
                                 style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-lowest,#fff);">
                                <span style="font-size: 12px; color: var(--on-surface-variant);">
                                    Showing <strong>1–5</strong> of
                                    <strong><c:out value="${notification.totalSent != null ? notification.totalSent : '4,802'}" /></strong> recipients
                                </span>
                                <div class="d-flex gap-1">
                                    <button class="btn btn-sm rounded-2 fw-bold px-3"
                                            style="border: 1px solid var(--outline-variant); color: var(--on-surface-variant); font-size: 12px;"
                                            disabled aria-label="Previous page">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">chevron_left</span>
                                    </button>
                                    <button class="btn btn-sm rounded-2 fw-bold px-3"
                                            style="background-color: var(--primary, #9d4300); color: white; font-size: 12px;"
                                            aria-label="Page 1" aria-current="page">1</button>
                                    <button class="btn btn-sm rounded-2 fw-bold px-3"
                                            style="border: 1px solid var(--outline-variant); color: var(--on-surface-variant); font-size: 12px;"
                                            aria-label="Page 2">2</button>
                                    <button class="btn btn-sm rounded-2 fw-bold px-3"
                                            style="border: 1px solid var(--outline-variant); color: var(--on-surface-variant); font-size: 12px;"
                                            aria-label="Next page">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">chevron_right</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- ══ RIGHT: Metadata + Timeline (4/12) ══ -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Metadata Strip -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex align-items-center gap-2"
                                 style="background: var(--surface-container-lowest,#fff); border-bottom: 1px solid var(--outline-variant);">
                                <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">info</span>
                                <h3 class="fw-bold mb-0" style="font-size: 15px; color: var(--on-surface);">Broadcast Info</h3>
                            </div>
                            <div class="p-0">
                                <div class="meta-strip">
                                    <div class="meta-strip-item">
                                        <span class="msi-label">Audience</span>
                                        <span class="msi-value">
                                            <span class="material-symbols-outlined msi-icon">groups</span>
                                            <c:out value="${not empty notification.audienceType ? notification.audienceType : 'All Users'}" />
                                        </span>
                                    </div>
                                    <div class="meta-strip-item">
                                        <span class="msi-label">Priority</span>
                                        <span class="msi-value">
                                            <c:choose>
                                                <c:when test="${notification.priority == 'URGENT'}">
                                                    <span style="color: var(--error, #ba1a1a);">🔴 Urgent</span>
                                                </c:when>
                                                <c:when test="${notification.priority == 'HIGH'}">
                                                    <span style="color: #854d0e;">🟠 High</span>
                                                </c:when>
                                                <c:when test="${notification.priority == 'LOW'}">
                                                    <span style="color: #16a34a;">🟢 Low</span>
                                                </c:when>
                                                <c:otherwise>🔵 Normal</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="meta-strip-item">
                                        <span class="msi-label">Sent At</span>
                                        <span class="msi-value" style="font-size: 13px;">
                                            <c:choose>
                                                <c:when test="${not empty notification.sentAt}">
                                                    <fmt:formatDate value="${notification.sentAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>03/06/2026 07:30</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="meta-strip-item">
                                        <span class="msi-label">Created By</span>
                                        <span class="msi-value" style="font-size: 13px;">
                                            <c:out value="${not empty notification.createdBy ? notification.createdBy : sessionScope.email != null ? sessionScope.email : 'Manager'}" />
                                        </span>
                                    </div>
                                    <div class="meta-strip-item">
                                        <span class="msi-label">Notif. ID</span>
                                        <span class="msi-value" style="font-size: 12px; font-family: monospace;">
                                            #<c:out value="${not empty notification.id ? notification.id : 'BRD-20260603-001'}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Activity Timeline -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-2 mb-4">
                                <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">timeline</span>
                                <h3 class="fw-bold mb-0" style="font-size: 15px; color: var(--on-surface);">Activity Log</h3>
                            </div>
                            <div class="d-flex flex-column" id="activityTimeline">

                                <div class="timeline-item">
                                    <div class="timeline-dot success">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">check_circle</span>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="tc-title">Delivery Completed</div>
                                        <div class="tc-time">03/06/2026 — 07:35 AM</div>
                                        <div class="tc-body">Sent to 4,802 recipients. 12 failed.</div>
                                    </div>
                                </div>

                                <div class="timeline-item">
                                    <div class="timeline-dot info">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">send</span>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="tc-title">Broadcast Dispatched</div>
                                        <div class="tc-time">03/06/2026 — 07:30 AM</div>
                                        <div class="tc-body">Notification queued and dispatched by email service.</div>
                                    </div>
                                </div>

                                <div class="timeline-item">
                                    <div class="timeline-dot info">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">verified</span>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="tc-title">Approved for Sending</div>
                                        <div class="tc-time">03/06/2026 — 07:28 AM</div>
                                        <div class="tc-body">Final content review passed. Audience: All Users (4,802).</div>
                                    </div>
                                </div>

                                <div class="timeline-item">
                                    <div class="timeline-dot warning">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">draft</span>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="tc-title">Draft Saved</div>
                                        <div class="tc-time">02/06/2026 — 04:55 PM</div>
                                        <div class="tc-body">Draft saved by Library Manager.</div>
                                    </div>
                                </div>

                                <div class="timeline-item">
                                    <div class="timeline-dot info">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">add_circle</span>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="tc-title">Notification Created</div>
                                        <div class="tc-time">02/06/2026 — 04:50 PM</div>
                                        <div class="tc-body">Broadcast form started by
                                            <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Manager'}" />.
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- Related notifications -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex align-items-center gap-2"
                                 style="background: var(--surface-container-lowest,#fff); border-bottom: 1px solid var(--outline-variant);">
                                <span class="material-symbols-outlined" style="color: var(--primary,#9d4300);">view_list</span>
                                <h3 class="fw-bold mb-0" style="font-size: 15px; color: var(--on-surface);">Other Broadcasts</h3>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <c:choose>
                                    <c:when test="${not empty relatedNotifications}">
                                        <c:forEach var="rn" items="${relatedNotifications}">
                                            <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp?id=${rn.id}"
                                               class="d-flex align-items-start gap-3 p-3 rounded-3 text-decoration-none"
                                               style="border: 1px solid var(--outline-variant); background: var(--surface-container-low,#fff1eb);
                                                      transition: border-color 0.15s;">
                                                <span class="material-symbols-outlined flex-shrink-0"
                                                      style="font-size: 20px; color: var(--primary,#9d4300); margin-top: 2px;">campaign</span>
                                                <div class="flex-grow-1 min-width-0">
                                                    <p class="fw-bold mb-0 text-on-surface" style="font-size: 13px;"><c:out value="${rn.title}" /></p>
                                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;"><c:out value="${rn.audienceType}" /> · <fmt:formatDate value="${rn.sentAt}" pattern="dd/MM/yyyy" /></p>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Demo related notifications -->
                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                           class="d-flex align-items-start gap-3 p-3 rounded-3 text-decoration-none"
                                           style="border: 1px solid var(--outline-variant); background: var(--surface-container-low,#fff1eb);">
                                            <span class="material-symbols-outlined flex-shrink-0"
                                                  style="font-size: 20px; color: var(--primary,#9d4300); margin-top: 2px;">assignment_return</span>
                                            <div>
                                                <p class="fw-bold mb-0 text-on-surface" style="font-size: 13px;">Book Recall — SE301 Course Materials</p>
                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">Students · 01/06/2026</p>
                                            </div>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                           class="d-flex align-items-start gap-3 p-3 rounded-3 text-decoration-none"
                                           style="border: 1px solid var(--outline-variant); background: var(--surface-container-low,#fff1eb);">
                                            <span class="material-symbols-outlined flex-shrink-0"
                                                  style="font-size: 20px; color: var(--tertiary, #006398); margin-top: 2px;">policy</span>
                                            <div>
                                                <p class="fw-bold mb-0 text-on-surface" style="font-size: 13px;">Library Policy Update v2.1</p>
                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">All Users · 28/05/2026</p>
                                            </div>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/notification-detail.jsp"
                                           class="d-flex align-items-start gap-3 p-3 rounded-3 text-decoration-none"
                                           style="border: 1px solid var(--outline-variant); background: var(--surface-container-low,#fff1eb);">
                                            <span class="material-symbols-outlined flex-shrink-0"
                                                  style="font-size: 20px; color: #16a34a; margin-top: 2px;">event</span>
                                            <div>
                                                <p class="fw-bold mb-0 text-on-surface" style="font-size: 13px;">Summer Extended Hours Notice</p>
                                                <p class="text-on-surface-variant mb-0" style="font-size: 11px;">All Users · 01/06/2026</p>
                                            </div>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/manager/notification-broadcast.jsp"
                                   class="text-primary-custom fw-bold text-decoration-none mt-1"
                                   style="font-size: 13px;">Create New Broadcast →</a>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

</body>

<!-- ── Delete Confirmation Modal ── -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
        <div class="modal-content rounded-4 border-0 shadow-lg">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="deleteModalLabel" style="color: var(--error, #ba1a1a);">
                    <span class="material-symbols-outlined me-2" style="vertical-align: -4px;">warning</span>
                    Delete Notification?
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3">
                <p style="font-size: 14px; color: var(--on-surface-variant);">
                    This action will permanently remove the notification and all its delivery records.
                    This <strong>cannot be undone</strong>.
                </p>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/manager/notification-broadcast" method="POST">
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="notifId" value="${notification.id}" />
                    <button type="submit" class="btn rounded-pill px-4 fw-bold text-white"
                            style="background-color: var(--error, #ba1a1a);">
                        <span class="material-symbols-outlined me-1" style="font-size: 16px; vertical-align: -3px;">delete</span>
                        Delete Permanently
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
/* ── Sidebar active state ── */
(function() {
    var links = document.querySelectorAll('aside .sidebar-link');
    links.forEach(function(link) { link.classList.remove('active'); });
    links.forEach(function(link) {
        if (link.href && link.href.indexOf('notification-detail') !== -1) {
            link.classList.add('active');
        }
    });
})();

/* ══ Recipient filter tabs ══ */
var recipTabs  = document.querySelectorAll('.recip-tab');
var recipRows  = document.querySelectorAll('#recipientTable tbody tr');

recipTabs.forEach(function(tab) {
    tab.addEventListener('click', function() {
        recipTabs.forEach(function(t) {
            t.classList.remove('active');
            t.setAttribute('aria-selected', 'false');
        });
        this.classList.add('active');
        this.setAttribute('aria-selected', 'true');

        var filter = this.getAttribute('data-filter');
        recipRows.forEach(function(row) {
            var status = row.getAttribute('data-status');
            row.style.display = (filter === 'all' || status === filter) ? '' : 'none';
        });
    });
});

/* ══ Export stub ══ */
document.getElementById('btnExport').addEventListener('click', function() {
    alert('Export feature: This will download the delivery report as CSV.');
});
</script>

</html>
