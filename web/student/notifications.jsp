<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<%--
    Student Notifications — Hộp thư thông báo cá nhân dành cho Sinh viên
    Fragment inventory:
        fragments/_head.jsp     — <head>: meta, CSS, custom styles
        fragments/_header.jsp   — Fixed top navigation bar
        fragments/_sidebar.jsp  — Left sidebar navigation
        fragments/_footer.jsp   — Footer + Bootstrap JS
--%>

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

<%-- ══ Page-specific styles ══ --%>
<style>
    /* ── Layout offset for fixed sidebar ── */
    .notif-page-wrapper {
        margin-left: 256px;
        background-color: #f7f9fb;
        min-height: calc(100vh - 64px);
    }

    /* ── Page header strip ── */
    .notif-page-header {
        background-color: #ffffff;
        border-bottom: 1px solid var(--outline-variant);
        padding: 28px 40px 20px;
    }
    .notif-page-header h1 {
        font-size: 24px;
        font-weight: 700;
        color: var(--on-surface, #251913);
        margin: 0 0 4px 0;
    }
    .notif-page-header .subtitle {
        font-size: 14px;
        color: var(--on-surface-variant);
        margin: 0;
    }

    /* ── Mark-all / Bulk actions bar ── */
    .notif-actions-bar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 12px;
        padding: 16px 40px;
        background: #ffffff;
        border-bottom: 1px solid var(--outline-variant);
    }

    /* ── Filter tabs ── */
    .notif-tabs {
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
    }
    .notif-tab {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 16px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 600;
        border: 1px solid var(--outline-variant);
        background: #ffffff;
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.18s ease;
        user-select: none;
    }
    .notif-tab:hover {
        border-color: var(--primary);
        color: var(--primary);
        background-color: rgba(157, 67, 0, 0.05);
    }
    .notif-tab.active {
        background-color: var(--primary);
        color: #ffffff;
        border-color: var(--primary);
    }
    .notif-tab .tab-count {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 18px;
        height: 18px;
        padding: 0 5px;
        border-radius: 999px;
        font-size: 10px;
        font-weight: 700;
        background: rgba(255,255,255,0.25);
        color: inherit;
    }
    .notif-tab:not(.active) .tab-count {
        background: rgba(157, 67, 0, 0.1);
        color: var(--primary);
    }

    /* ── Bulk action buttons ── */
    .btn-notif-action {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 14px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        border: 1px solid var(--outline-variant);
        background: #ffffff;
        color: var(--on-surface-variant);
        cursor: pointer;
        transition: all 0.18s ease;
    }
    .btn-notif-action:hover {
        background-color: var(--surface-container-high, #e6e8ea);
        border-color: var(--outline);
    }
    .btn-notif-action .material-symbols-outlined { font-size: 16px; }

    /* ── Notification list container ── */
    .notif-list-wrapper {
        padding: 24px 40px;
        max-width: 900px;
    }

    /* ── Individual notification item ── */
    .notif-item {
        display: flex;
        align-items: flex-start;
        gap: 16px;
        padding: 18px 20px;
        background: #ffffff;
        border: 1px solid var(--outline-variant);
        border-radius: 14px;
        margin-bottom: 10px;
        transition: box-shadow 0.18s ease, border-color 0.18s ease, transform 0.18s ease;
        cursor: pointer;
        position: relative;
    }
    .notif-item:hover {
        box-shadow: 0 6px 20px rgba(0,0,0,0.07);
        border-color: rgba(157, 67, 0, 0.3);
        transform: translateY(-1px);
    }
    .notif-item.is-unread {
        background: linear-gradient(135deg, #fff8f6 0%, #ffffff 60%);
        border-left: 4px solid var(--primary);
    }
    .notif-item.is-unread .notif-title { font-weight: 700; }

    /* Unread dot indicator */
    .unread-dot {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        background-color: var(--primary);
        flex-shrink: 0;
        margin-top: 7px;
        box-shadow: 0 0 0 2px rgba(157, 67, 0, 0.2);
    }
    .notif-item:not(.is-unread) .unread-dot { background-color: transparent; box-shadow: none; }

    /* Icon avatar */
    .notif-icon-wrap {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        font-size: 22px;
    }
    .notif-icon-wrap.type-overdue    { background-color: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .notif-icon-wrap.type-due-soon   { background-color: rgba(234, 179, 8, 0.12); color: #854d0e; }
    .notif-icon-wrap.type-approved   { background-color: rgba(22, 163, 74, 0.1); color: #16a34a; }
    .notif-icon-wrap.type-system     { background-color: rgba(0, 99, 152, 0.1); color: var(--tertiary, #006398); }
    .notif-icon-wrap.type-return     { background-color: var(--secondary-container, #fdd6a9); color: var(--on-secondary-container, #785c38); }
    .notif-icon-wrap.type-general    { background-color: var(--surface-container-high, #e6e8ea); color: var(--on-surface-variant); }

    /* Content area */
    .notif-content { flex: 1; min-width: 0; }
    .notif-meta {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 5px;
        flex-wrap: wrap;
    }
    .notif-category {
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        padding: 2px 8px;
        border-radius: 999px;
    }
    .notif-category.type-overdue  { background: var(--error-container, #ffdad6); color: var(--error, #ba1a1a); }
    .notif-category.type-due-soon { background: rgba(234,179,8,0.12); color: #854d0e; }
    .notif-category.type-approved { background: rgba(22,163,74,0.1); color: #16a34a; }
    .notif-category.type-system   { background: rgba(0,99,152,0.1); color: var(--tertiary, #006398); }
    .notif-category.type-return   { background: var(--secondary-container, #fdd6a9); color: var(--on-secondary-container, #785c38); }
    .notif-category.type-general  { background: var(--surface-container-high, #e6e8ea); color: var(--on-surface-variant); }

    .notif-timestamp {
        font-size: 11px;
        color: var(--on-surface-variant);
    }
    .notif-title {
        font-size: 14px;
        font-weight: 600;
        color: var(--on-surface, #251913);
        margin-bottom: 4px;
        line-height: 1.4;
    }
    .notif-body {
        font-size: 13px;
        color: var(--on-surface-variant);
        line-height: 1.6;
        margin-bottom: 10px;
    }
    .notif-action-btn {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 5px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 600;
        background-color: var(--primary);
        color: #ffffff;
        text-decoration: none;
        transition: transform 0.15s ease, filter 0.15s ease;
        border: none;
    }
    .notif-action-btn:hover {
        color: #ffffff;
        transform: scale(1.03);
        filter: brightness(108%);
    }
    .notif-action-btn:active { transform: scale(0.97); }
    .notif-action-btn .material-symbols-outlined { font-size: 14px; }

    /* Dismiss button on hover */
    .notif-dismiss {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 8px;
        border: none;
        background: transparent;
        color: var(--on-surface-variant);
        cursor: pointer;
        opacity: 0;
        transition: opacity 0.18s ease, background-color 0.18s ease;
        flex-shrink: 0;
    }
    .notif-item:hover .notif-dismiss { opacity: 1; }
    .notif-dismiss:hover { background-color: var(--surface-container-high, #e6e8ea); }
    .notif-dismiss .material-symbols-outlined { font-size: 18px; }

    /* ── Empty state ── */
    .notif-empty {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 80px 20px;
        text-align: center;
    }
    .notif-empty .empty-icon-wrap {
        width: 72px; height: 72px;
        border-radius: 50%;
        background-color: var(--surface-container-high, #e6e8ea);
        display: flex; align-items: center; justify-content: center;
        margin-bottom: 20px;
    }
    .notif-empty .empty-icon-wrap .material-symbols-outlined { font-size: 36px; color: var(--on-surface-variant); }
    .notif-empty h3 { font-size: 18px; font-weight: 700; color: var(--on-surface, #251913); margin-bottom: 8px; }
    .notif-empty p  { font-size: 14px; color: var(--on-surface-variant); margin: 0; }

    /* ── Section date separator ── */
    .notif-date-sep {
        display: flex;
        align-items: center;
        gap: 12px;
        margin: 20px 0 12px;
    }
    .notif-date-sep span {
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: var(--on-surface-variant);
        white-space: nowrap;
    }
    .notif-date-sep::before,
    .notif-date-sep::after {
        content: '';
        flex: 1;
        height: 1px;
        background-color: var(--outline-variant);
    }

    /* ── Summary ribbon at top ── */
    .notif-summary-ribbon {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        padding: 0 40px 20px;
        max-width: 900px;
    }
    .notif-summary-card {
        flex: 1;
        min-width: 130px;
        background: #ffffff;
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
        padding: 14px 16px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .notif-summary-card .sc-icon {
        width: 38px; height: 38px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 20px; flex-shrink: 0;
    }
    .notif-summary-card .sc-label { font-size: 11px; color: var(--on-surface-variant); font-weight: 500; }
    .notif-summary-card .sc-value { font-size: 20px; font-weight: 700; color: var(--on-surface, #251913); line-height: 1; }

    /* ── Responsive ── */
    @media (max-width: 991.98px) {
        .notif-page-wrapper { margin-left: 0; }
        .notif-page-header, .notif-actions-bar, .notif-list-wrapper, .notif-summary-ribbon { padding-left: 16px; padding-right: 16px; }
        .notif-dismiss { opacity: 1; }
    }
</style>

<jsp:include page="fragments/_header.jsp" />

<div class="d-flex main-wrapper overflow-hidden">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ══ MAIN CONTENT ══ -->
    <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb;">

        <!-- Page Header -->
        <div class="notif-page-header" style="margin-left: 0;">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                <div>
                    <nav aria-label="breadcrumb" style="margin-bottom: 6px;">
                        <ol class="breadcrumb mb-0" style="font-size: 12px;">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/student/dashboard"
                                   class="text-decoration-none text-on-surface-variant">Home</a>
                            </li>
                            <li class="breadcrumb-item active text-primary-custom fw-semibold" aria-current="page">Notifications</li>
                        </ol>
                    </nav>
                    <h1>
                        <span class="material-symbols-outlined me-2"
                              style="font-size: 26px; vertical-align: -4px; font-variation-settings: 'FILL' 1;">notifications</span>
                        My Notifications
                    </h1>
                    <p class="subtitle">Stay up to date with your loans, fines, and library announcements.</p>
                </div>
                <!-- Unread badge summary -->
                <div class="d-flex align-items-center gap-2">
                    <span class="badge rounded-pill text-white fw-bold px-3 py-2"
                          style="background-color: var(--primary); font-size: 13px;">
                        <c:out value="${unreadCount != null ? unreadCount : 3}" /> Unread
                    </span>
                </div>
            </div>
        </div>

        <!-- Summary ribbon -->
        <div class="notif-summary-ribbon pt-4">
            <div class="notif-summary-card">
                <div class="sc-icon" style="background: rgba(157,67,0,0.1);">
                    <span class="material-symbols-outlined" style="color: var(--primary);">mark_email_unread</span>
                </div>
                <div>
                    <div class="sc-label">Unread</div>
                    <div class="sc-value text-primary-custom">
                        <c:out value="${unreadCount != null ? unreadCount : 3}" />
                    </div>
                </div>
            </div>
            <div class="notif-summary-card">
                <div class="sc-icon" style="background: var(--error-container, #ffdad6);">
                    <span class="material-symbols-outlined" style="color: var(--error, #ba1a1a);">warning</span>
                </div>
                <div>
                    <div class="sc-label">Overdue Alerts</div>
                    <div class="sc-value" style="color: var(--error, #ba1a1a);">
                        <c:out value="${overdueCount != null ? overdueCount : 1}" />
                    </div>
                </div>
            </div>
            <div class="notif-summary-card">
                <div class="sc-icon" style="background: rgba(22,163,74,0.1);">
                    <span class="material-symbols-outlined" style="color: #16a34a;">check_circle</span>
                </div>
                <div>
                    <div class="sc-label">Approved</div>
                    <div class="sc-value" style="color: #16a34a;">
                        <c:out value="${approvedCount != null ? approvedCount : 1}" />
                    </div>
                </div>
            </div>
            <div class="notif-summary-card">
                <div class="sc-icon" style="background: rgba(0,99,152,0.1);">
                    <span class="material-symbols-outlined" style="color: var(--tertiary, #006398);">campaign</span>
                </div>
                <div>
                    <div class="sc-label">Announcements</div>
                    <div class="sc-value" style="color: var(--tertiary, #006398);">
                        <c:out value="${announcementCount != null ? announcementCount : 2}" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter tabs + bulk action bar -->
        <div class="notif-actions-bar" style="max-width: 980px; margin-left: 0; border-top: 1px solid var(--outline-variant);">
            <!-- Filter tabs -->
            <div class="notif-tabs" role="tablist" aria-label="Notification filters">
                <button class="notif-tab active" role="tab" aria-selected="true"
                        id="tab-all" data-filter="all" aria-controls="notif-list">
                    All
                    <span class="tab-count">6</span>
                </button>
                <button class="notif-tab" role="tab" aria-selected="false"
                        id="tab-unread" data-filter="unread" aria-controls="notif-list">
                    <span class="material-symbols-outlined" style="font-size: 14px;">mark_email_unread</span>
                    Unread
                    <span class="tab-count">3</span>
                </button>
                <button class="notif-tab" role="tab" aria-selected="false"
                        id="tab-overdue" data-filter="overdue">
                    <span class="material-symbols-outlined" style="font-size: 14px;">warning</span>
                    Overdue
                </button>
                <button class="notif-tab" role="tab" aria-selected="false"
                        id="tab-system" data-filter="system">
                    <span class="material-symbols-outlined" style="font-size: 14px;">campaign</span>
                    Announcements
                </button>
            </div>
            <!-- Bulk actions -->
            <div class="d-flex align-items-center gap-2">
                <button class="btn-notif-action" id="btn-mark-all-read"
                        title="Mark all as read" aria-label="Mark all notifications as read">
                    <span class="material-symbols-outlined">done_all</span>
                    Mark all read
                </button>
                <button class="btn-notif-action" id="btn-clear-read"
                        title="Clear read notifications" aria-label="Clear all read notifications">
                    <span class="material-symbols-outlined">delete_sweep</span>
                    Clear read
                </button>
            </div>
        </div>

        <!-- ══ Notification List ══ -->
        <div class="notif-list-wrapper" id="notif-list" role="tabpanel" aria-labelledby="tab-all">

            <c:choose>
                <c:when test="${empty notifications}">
                    <%-- ── Fallback demo data (replaced by real ${notifications} from Servlet) ── --%>

                    <!-- TODAY separator -->
                    <div class="notif-date-sep" aria-hidden="true"><span>Today</span></div>

                    <!-- Notification 1 — Overdue (UNREAD) -->
                    <div class="notif-item is-unread"
                         tabindex="0" role="article"
                         aria-label="Overdue alert — unread"
                         data-type="overdue" data-id="notif-1">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-overdue" aria-hidden="true">
                            <span class="material-symbols-outlined">error</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-overdue">Overdue</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    2 hours ago
                                </span>
                            </div>
                            <div class="notif-title">Your borrowed book is overdue!</div>
                            <div class="notif-body">
                                <strong>"Introduction to Algorithms"</strong> (3rd Edition) was due on
                                <strong>June 2, 2026</strong>. A late fee of <strong>5,000 VND/day</strong> is being
                                accumulated. Please return it as soon as possible to avoid further charges.
                            </div>
                            <a href="${pageContext.request.contextPath}/student/fines"
                               class="notif-action-btn" aria-label="View fine details">
                                <span class="material-symbols-outlined">payments</span>
                                View Fine Details
                            </a>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <!-- Notification 2 — Due Soon (UNREAD) -->
                    <div class="notif-item is-unread"
                         tabindex="0" role="article"
                         aria-label="Due soon reminder — unread"
                         data-type="due-soon" data-id="notif-2">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-due-soon" aria-hidden="true">
                            <span class="material-symbols-outlined">alarm</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-due-soon">Due Soon</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    5 hours ago
                                </span>
                            </div>
                            <div class="notif-title">Return reminder: 2 days remaining</div>
                            <div class="notif-body">
                                <strong>"Design Patterns: Elements of Reusable Object-Oriented Software"</strong>
                                is due on <strong>June 6, 2026</strong>. You have 2 days left to return it
                                or request a renewal.
                            </div>
                            <div class="d-flex gap-2 flex-wrap">
                                <a href="${pageContext.request.contextPath}/student/loans"
                                   class="notif-action-btn" aria-label="View loan details">
                                    <span class="material-symbols-outlined">book</span>
                                    View Loan
                                </a>
                                <a href="${pageContext.request.contextPath}/student/loans/renew"
                                   class="notif-action-btn"
                                   style="background-color: transparent; color: var(--primary); border: 1px solid var(--primary);"
                                   aria-label="Renew book">
                                    <span class="material-symbols-outlined">autorenew</span>
                                    Request Renewal
                                </a>
                            </div>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <!-- Notification 3 — Reservation Approved (UNREAD) -->
                    <div class="notif-item is-unread"
                         tabindex="0" role="article"
                         aria-label="Reservation approved — unread"
                         data-type="approved" data-id="notif-3">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-approved" aria-hidden="true">
                            <span class="material-symbols-outlined">check_circle</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-approved">Approved</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    Yesterday, 10:45 AM
                                </span>
                            </div>
                            <div class="notif-title">Your reservation has been approved</div>
                            <div class="notif-body">
                                <strong>"Clean Code: A Handbook of Agile Software Craftsmanship"</strong>
                                is now ready for pickup at the <strong>Main Library — Desk B</strong>.
                                Please collect it within <strong>3 days</strong> or your reservation will expire.
                            </div>
                            <a href="${pageContext.request.contextPath}/student/reservations"
                               class="notif-action-btn" aria-label="View reservation">
                                <span class="material-symbols-outlined">bookmark</span>
                                View Reservation
                            </a>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <!-- EARLIER separator -->
                    <div class="notif-date-sep" aria-hidden="true"><span>Earlier</span></div>

                    <!-- Notification 4 — Return Confirmed (READ) -->
                    <div class="notif-item"
                         tabindex="0" role="article"
                         aria-label="Return confirmed"
                         data-type="return" data-id="notif-4">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-return" aria-hidden="true">
                            <span class="material-symbols-outlined">assignment_return</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-return">Return</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    June 1, 2026
                                </span>
                            </div>
                            <div class="notif-title">Book return confirmed</div>
                            <div class="notif-body">
                                You have successfully returned <strong>"Operating System Concepts"</strong>
                                (10th Edition). No outstanding fines. Thank you!
                            </div>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <!-- Notification 5 — System / Announcement (READ) -->
                    <div class="notif-item"
                         tabindex="0" role="article"
                         aria-label="Library announcement"
                         data-type="system" data-id="notif-5">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-system" aria-hidden="true">
                            <span class="material-symbols-outlined">campaign</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-system">Announcement</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    May 30, 2026
                                </span>
                            </div>
                            <div class="notif-title">Library hours extended during exam period</div>
                            <div class="notif-body">
                                The university library will be open until <strong>11:00 PM</strong> from
                                <strong>June 3 – June 20, 2026</strong> to support students during the
                                final examination period. Additional study rooms are also available for booking.
                            </div>
                            <a href="${pageContext.request.contextPath}/services.jsp"
                               class="notif-action-btn" aria-label="View library services">
                                <span class="material-symbols-outlined">arrow_forward</span>
                                Learn More
                            </a>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <!-- Notification 6 — General (READ) -->
                    <div class="notif-item"
                         tabindex="0" role="article"
                         aria-label="Account notification"
                         data-type="general" data-id="notif-6">
                        <div class="unread-dot" aria-hidden="true"></div>
                        <div class="notif-icon-wrap type-general" aria-hidden="true">
                            <span class="material-symbols-outlined">manage_accounts</span>
                        </div>
                        <div class="notif-content">
                            <div class="notif-meta">
                                <span class="notif-category type-general">Account</span>
                                <span class="notif-timestamp">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: -2px;">schedule</span>
                                    May 28, 2026
                                </span>
                            </div>
                            <div class="notif-title">Your library card has been renewed</div>
                            <div class="notif-body">
                                Your student library access card has been renewed and is valid until
                                <strong>May 2027</strong>. You may now borrow up to <strong>5 books</strong>
                                simultaneously.
                            </div>
                        </div>
                        <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                </c:when>
                <c:otherwise>
                    <%-- ── Real data from Servlet ── --%>
                    <c:if test="${empty todayNotifications and empty earlierNotifications}">
                        <div class="notif-empty" role="status" aria-live="polite">
                            <div class="empty-icon-wrap" aria-hidden="true">
                                <span class="material-symbols-outlined">notifications_off</span>
                            </div>
                            <h3>All caught up!</h3>
                            <p>You have no notifications at the moment.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty todayNotifications}">
                        <div class="notif-date-sep" aria-hidden="true"><span>Today</span></div>
                        <c:forEach var="notif" items="${todayNotifications}">
                            <div class="notif-item ${not notif.read ? 'is-unread' : ''}"
                                 tabindex="0" role="article"
                                 data-type="${notif.type}" data-id="notif-${notif.id}">
                                <div class="unread-dot" aria-hidden="true"></div>
                                <div class="notif-icon-wrap type-${notif.type}" aria-hidden="true">
                                    <span class="material-symbols-outlined">${notif.icon}</span>
                                </div>
                                <div class="notif-content">
                                    <div class="notif-meta">
                                        <span class="notif-category type-${notif.type}"><c:out value="${notif.categoryLabel}"/></span>
                                        <span class="notif-timestamp">
                                            <span class="material-symbols-outlined" style="font-size:12px;vertical-align:-2px;">schedule</span>
                                            <fmt:formatDate value="${notif.createdAt}" pattern="HH:mm" />
                                        </span>
                                    </div>
                                    <div class="notif-title"><c:out value="${notif.title}"/></div>
                                    <div class="notif-body"><c:out value="${notif.body}"/></div>
                                    <c:if test="${not empty notif.actionUrl}">
                                        <a href="${pageContext.request.contextPath}${notif.actionUrl}"
                                           class="notif-action-btn">
                                            <span class="material-symbols-outlined">arrow_forward</span>
                                            <c:out value="${notif.actionLabel}"/>
                                        </a>
                                    </c:if>
                                </div>
                                <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${not empty earlierNotifications}">
                        <div class="notif-date-sep" aria-hidden="true"><span>Earlier</span></div>
                        <c:forEach var="notif" items="${earlierNotifications}">
                            <div class="notif-item ${not notif.read ? 'is-unread' : ''}"
                                 tabindex="0" role="article"
                                 data-type="${notif.type}" data-id="notif-${notif.id}">
                                <div class="unread-dot" aria-hidden="true"></div>
                                <div class="notif-icon-wrap type-${notif.type}" aria-hidden="true">
                                    <span class="material-symbols-outlined">${notif.icon}</span>
                                </div>
                                <div class="notif-content">
                                    <div class="notif-meta">
                                        <span class="notif-category type-${notif.type}"><c:out value="${notif.categoryLabel}"/></span>
                                        <span class="notif-timestamp">
                                            <span class="material-symbols-outlined" style="font-size:12px;vertical-align:-2px;">schedule</span>
                                            <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy" />
                                        </span>
                                    </div>
                                    <div class="notif-title"><c:out value="${notif.title}"/></div>
                                    <div class="notif-body"><c:out value="${notif.body}"/></div>
                                    <c:if test="${not empty notif.actionUrl}">
                                        <a href="${pageContext.request.contextPath}${notif.actionUrl}"
                                           class="notif-action-btn">
                                            <span class="material-symbols-outlined">arrow_forward</span>
                                            <c:out value="${notif.actionLabel}"/>
                                        </a>
                                    </c:if>
                                </div>
                                <button class="notif-dismiss" title="Dismiss" aria-label="Dismiss notification">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                        </c:forEach>
                    </c:if>
                </c:otherwise>
            </c:choose>

        </div><!-- /#notif-list -->

    </main>
</div><!-- /.d-flex.main-wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* ── Filter tabs ── */
    var tabs = document.querySelectorAll('.notif-tab');
    var items = document.querySelectorAll('.notif-item');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            tabs.forEach(function(t) {
                t.classList.remove('active');
                t.setAttribute('aria-selected', 'false');
            });
            tab.classList.add('active');
            tab.setAttribute('aria-selected', 'true');

            var filter = tab.getAttribute('data-filter');
            items.forEach(function(item) {
                if (filter === 'all') {
                    item.style.display = '';
                } else if (filter === 'unread') {
                    item.style.display = item.classList.contains('is-unread') ? '' : 'none';
                } else {
                    item.style.display = item.getAttribute('data-type') === filter ? '' : 'none';
                }
            });
        });
    });

    /* ── Mark all read ── */
    var btnMarkAll = document.getElementById('btn-mark-all-read');
    if (btnMarkAll) {
        btnMarkAll.addEventListener('click', function() {
            items.forEach(function(item) {
                item.classList.remove('is-unread');
                var dot = item.querySelector('.unread-dot');
                if (dot) { dot.style.background = 'transparent'; dot.style.boxShadow = 'none'; }
            });
            // Update unread tab count
            var countSpan = document.querySelector('#tab-unread .tab-count');
            if (countSpan) countSpan.textContent = '0';
            document.querySelectorAll('.notif-summary-card .sc-value')[0].textContent = '0';
        });
    }

    /* ── Dismiss individual item ── */
    document.querySelectorAll('.notif-dismiss').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            var item = btn.closest('.notif-item');
            if (item) {
                item.style.transition = 'opacity 0.25s ease, transform 0.25s ease, max-height 0.3s ease';
                item.style.opacity = '0';
                item.style.transform = 'translateX(16px)';
                setTimeout(function() { item.remove(); }, 300);
            }
        });
    });

    /* ── Clear read ── */
    var btnClearRead = document.getElementById('btn-clear-read');
    if (btnClearRead) {
        btnClearRead.addEventListener('click', function() {
            items.forEach(function(item) {
                if (!item.classList.contains('is-unread')) {
                    item.style.transition = 'opacity 0.2s, transform 0.2s';
                    item.style.opacity = '0';
                    setTimeout(function() { item.remove(); }, 220);
                }
            });
        });
    }

    /* ── Keyboard: Enter on notif-item acts like click ── */
    document.querySelectorAll('.notif-item').forEach(function(item) {
        item.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                var link = item.querySelector('a.notif-action-btn');
                if (link) link.click();
            }
        });
    });
</script>

</body>
</html>
