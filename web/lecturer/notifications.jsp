<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #faf9f8;">
            <div class="container-xl px-4 py-5" style="max-width: 1200px; margin: 0 auto;">

                <!-- ─── BREADCRUMB ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted link-dark"
                       href="${pageContext.request.contextPath}/lecturer/dashboard">Trang chủ</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span class="text-dark">Bảng tin hệ thống</span>
                </nav>

                <!-- ─── PAGE HEADER ─── -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-5">
                    <div>
                        <h1 class="fw-bold mb-1" style="font-size: 28px; color: #191c1e;">
                            <span class="material-symbols-outlined me-2 align-middle"
                                  style="font-size: 30px; color: var(--primary); font-variation-settings: 'FILL' 1;">campaign</span>
                            Bảng tin Thư viện
                        </h1>
                        <p class="text-secondary mb-0" style="font-size: 14px;">
                            Cập nhật thông báo, chính sách và sự kiện từ Thư viện Đại học LMS.
                        </p>
                    </div>
                    <c:if test="${unreadCount > 0}">
                        <div class="d-flex align-items-center gap-3 flex-shrink-0" id="markAllArea">
                            <div class="px-3 py-2 rounded-3 d-flex align-items-center gap-2"
                                 style="background: linear-gradient(135deg, rgba(157,67,0,0.08), rgba(249,115,22,0.05)); border: 1px solid rgba(157,67,0,0.2);">
                                <div class="pulsing-dot"></div>
                                <span class="fw-bold" style="font-size: 15px; color: var(--primary);">${unreadCount}</span>
                                <span style="font-size: 13px; color: var(--on-surface-variant);">chưa đọc</span>
                            </div>
                            <button id="markAllReadBtn" class="btn rounded-3 fw-semibold"
                                    style="font-size: 13px; background: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                <span class="material-symbols-outlined me-1 align-middle" style="font-size: 16px;">done_all</span>
                                Đánh dấu tất cả đã đọc
                            </button>
                        </div>
                    </c:if>
                </div>

                <div class="row g-4">

                    <!-- ═══════════════════════════════════════════
                         LEFT: Danh sách thông báo
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-lg-8">

                        <!-- Search & Filter Bar -->
                        <div class="raised-card p-3 mb-4">
                            <form method="get" action="${pageContext.request.contextPath}/notifications"
                                  class="d-flex flex-wrap gap-2 align-items-center">
                                <div class="input-group flex-grow-1" style="min-width: 200px;">
                                    <span class="input-group-text bg-white border-end-0 rounded-start-3"
                                          style="border-color: #e5e5e5;">
                                        <span class="material-symbols-outlined" style="font-size: 18px; color: var(--on-surface-variant);">search</span>
                                    </span>
                                    <input type="text" name="keyword" class="form-control border-start-0 rounded-end-3"
                                           value="${keyword}" placeholder="Tìm thông báo..."
                                           style="border-color: #e5e5e5;">
                                </div>
                                <select name="typeFilter" class="form-select rounded-3" style="width: 160px; border-color: #e5e5e5;">
                                    <option value="">Tất cả loại</option>
                                    <option value="general" ${typeFilter == 'general' ? 'selected' : ''}>📢 Chung</option>
                                    <option value="urgent"  ${typeFilter == 'urgent'  ? 'selected' : ''}>🔴 Khẩn cấp</option>
                                    <option value="policy"  ${typeFilter == 'policy'  ? 'selected' : ''}>📋 Nội quy</option>
                                    <option value="event"   ${typeFilter == 'event'   ? 'selected' : ''}>🎯 Sự kiện</option>
                                </select>
                                <button type="submit" class="btn btn-primary-custom rounded-3 px-3 fw-semibold">
                                    Lọc
                                </button>
                                <c:if test="${not empty keyword or not empty typeFilter}">
                                    <a href="${pageContext.request.contextPath}/notifications"
                                       class="btn rounded-3 px-3"
                                       style="background: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid #e5e5e5;">
                                        <span class="material-symbols-outlined" style="font-size: 18px;">close</span>
                                    </a>
                                </c:if>
                            </form>
                        </div>

                        <!-- Notification Cards -->
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <div class="d-flex flex-column gap-3" id="notificationsList">
                                    <c:forEach var="notif" items="${notifications}">
                                        <div class="notif-card ${notif.pinned ? 'notif-card--pinned' : ''} ${not notif.read ? 'notif-card--unread' : ''}"
                                             id="notif-${notif.notificationId}"
                                             data-notif-id="${notif.notificationId}"
                                             data-read="${notif.read}">

                                            <!-- Unread indicator strip -->
                                            <div class="notif-unread-strip ${not notif.read ? 'strip-visible' : ''}"></div>

                                            <div class="d-flex gap-3 p-4">
                                                <!-- Type icon -->
                                                <div class="notif-card-icon
                                                            ${notif.type == 'urgent'  ? 'icon-urgent'  :
                                                              notif.type == 'policy'  ? 'icon-policy'  :
                                                              notif.type == 'event'   ? 'icon-event'   : 'icon-general'}">
                                                    <span class="material-symbols-outlined"
                                                          style="font-variation-settings: 'FILL' 1; font-size: 22px;">
                                                        ${notif.type == 'urgent'  ? 'error'       :
                                                          notif.type == 'policy'  ? 'policy'      :
                                                          notif.type == 'event'   ? 'celebration' : 'campaign'}
                                                    </span>
                                                </div>

                                                <!-- Main content -->
                                                <div class="flex-grow-1 min-w-0">
                                                    <div class="d-flex align-items-start justify-content-between gap-2 mb-1">
                                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                                            <!-- Pin indicator -->
                                                            <c:if test="${notif.pinned}">
                                                                <span class="material-symbols-outlined"
                                                                      style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;"
                                                                      title="Đã ghim">push_pin</span>
                                                            </c:if>
                                                            <!-- Type badge -->
                                                            <span class="notif-badge-type type-${notif.type}">
                                                                ${notif.type == 'urgent'  ? 'Khẩn cấp'     :
                                                                  notif.type == 'policy'  ? 'Nội quy'       :
                                                                  notif.type == 'event'   ? 'Sự kiện'       : 'Thông tin'}
                                                            </span>
                                                            <!-- Unread dot -->
                                                            <c:if test="${not notif.read}">
                                                                <span class="unread-dot" title="Chưa đọc"></span>
                                                            </c:if>
                                                        </div>
                                                        <span class="text-secondary small font-monospace flex-shrink-0"
                                                              style="font-size: 12px;">
                                                            <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>

                                                    <!-- Title -->
                                                    <h5 class="notif-title fw-bold mb-1 ${not notif.read ? 'text-dark' : ''}"
                                                        style="font-size: 15px; color: ${notif.read ? '#555' : '#191c1e'};">
                                                        <c:out value="${notif.title}" />
                                                    </h5>

                                                    <!-- Summary -->
                                                    <p class="notif-summary text-secondary mb-2"
                                                       style="font-size: 13.5px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                        <c:out value="${notif.content}" />
                                                    </p>

                                                    <!-- Hidden full content for modal -->
                                                    <div class="d-none notif-full-content">
                                                        <c:out value="${notif.content}" />
                                                    </div>

                                                    <!-- Footer: author + action -->
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="d-flex align-items-center gap-1 text-secondary"
                                                              style="font-size: 12px;">
                                                            <span class="material-symbols-outlined" style="font-size: 14px;">person</span>
                                                            <c:out value="${not empty notif.createdByName ? notif.createdByName : 'Ban Quản lý'}" />
                                                        </span>
                                                        <button class="btn-read-more d-flex align-items-center gap-1 fw-semibold"
                                                                onclick="openNotifDetail(this)"
                                                                style="font-size: 13px; color: var(--primary); background: none; border: none; padding: 0; cursor: pointer;">
                                                            Xem chi tiết
                                                            <span class="material-symbols-outlined" style="font-size: 16px;">arrow_right_alt</span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Phân trang -->
                                <c:if test="${totalPages > 1}">
                                    <div class="d-flex justify-content-between align-items-center mt-4 flex-wrap gap-2">
                                        <span class="text-secondary small">
                                            Trang <strong>${currentPage}</strong> / ${totalPages}
                                            &nbsp;·&nbsp; ${totalCount} thông báo
                                        </span>
                                        <nav>
                                            <ul class="pagination pagination-sm mb-0 gap-1">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link rounded-2"
                                                           href="${pageContext.request.contextPath}/notifications?page=${currentPage-1}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                            <span class="material-symbols-outlined" style="font-size: 16px;">chevron_left</span>
                                                        </a>
                                                    </li>
                                                </c:if>
                                                <c:forEach begin="1" end="${totalPages}" var="p">
                                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                        <a class="page-link rounded-2"
                                                           href="${pageContext.request.contextPath}/notifications?page=${p}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                            ${p}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link rounded-2"
                                                           href="${pageContext.request.contextPath}/notifications?page=${currentPage+1}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                            <span class="material-symbols-outlined" style="font-size: 16px;">chevron_right</span>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
                            </c:when>

                            <c:otherwise>
                                <!-- Empty State -->
                                <div class="raised-card text-center py-5 px-4">
                                    <div class="empty-state-icon mx-auto mb-3">
                                        <span class="material-symbols-outlined" style="font-size: 40px; color: var(--on-surface-variant); font-variation-settings: 'FILL' 1;">mail_outline</span>
                                    </div>
                                    <h4 class="fw-bold mb-1" style="color: #191c1e;">Không có thông báo nào</h4>
                                    <p class="text-secondary small mb-4">
                                        <c:choose>
                                            <c:when test="${not empty keyword or not empty typeFilter}">
                                                Không tìm thấy thông báo phù hợp với bộ lọc. Hãy thử thay đổi từ khóa.
                                            </c:when>
                                            <c:otherwise>
                                                Bảng tin hiện đang trống. Hãy quay lại sau để xem cập nhật mới!
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/lecturer/dashboard"
                                       class="btn btn-primary-custom rounded-pill px-4 py-2 fw-semibold">
                                        Về trang chủ
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- ═══════════════════════════════════════════
                         RIGHT: Sidebar thống kê & info
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-lg-4">

                        <!-- Thống kê nhanh -->
                        <div class="raised-card p-4 mb-4">
                            <h5 class="fw-bold mb-3" style="color: #191c1e; font-size: 15px;">Tổng quan Bảng tin</h5>
                            <div class="d-flex flex-column gap-2">
                                <div class="stat-row d-flex justify-content-between align-items-center p-3 rounded-3"
                                     style="background-color: #f7f9fb;">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary); font-variation-settings: 'FILL' 1;">notifications</span>
                                        <span class="small fw-semibold text-secondary">Tổng thông báo</span>
                                    </div>
                                    <span class="fw-bold" style="color: #191c1e;">${totalCount}</span>
                                </div>
                                <c:if test="${unreadCount > 0}">
                                    <div class="stat-row d-flex justify-content-between align-items-center p-3 rounded-3"
                                         style="background: linear-gradient(135deg, rgba(157,67,0,0.06), rgba(249,115,22,0.04)); border: 1px solid rgba(157,67,0,0.12);">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary); font-variation-settings: 'FILL' 1;">mark_email_unread</span>
                                            <span class="small fw-semibold" style="color: var(--primary);">Chưa đọc</span>
                                        </div>
                                        <span class="fw-bold" style="color: var(--primary);">${unreadCount}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Phân loại thông báo -->
                        <div class="raised-card p-4 mb-4">
                            <h5 class="fw-bold mb-3" style="color: #191c1e; font-size: 15px;">Phân loại</h5>
                            <div class="d-flex flex-column gap-2">
                                <a href="${pageContext.request.contextPath}/notifications?typeFilter=urgent"
                                   class="type-filter-btn ${typeFilter == 'urgent' ? 'active-filter' : ''}">
                                    <span class="notif-badge-type type-urgent me-2">Khẩn cấp</span>
                                    <span class="text-secondary small">Thông báo hỏa tốc</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/notifications?typeFilter=policy"
                                   class="type-filter-btn ${typeFilter == 'policy' ? 'active-filter' : ''}">
                                    <span class="notif-badge-type type-policy me-2">Nội quy</span>
                                    <span class="text-secondary small">Quy định mượn trả</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/notifications?typeFilter=event"
                                   class="type-filter-btn ${typeFilter == 'event' ? 'active-filter' : ''}">
                                    <span class="notif-badge-type type-event me-2">Sự kiện</span>
                                    <span class="text-secondary small">Hoạt động, workshop</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/notifications?typeFilter=general"
                                   class="type-filter-btn ${typeFilter == 'general' ? 'active-filter' : ''}">
                                    <span class="notif-badge-type type-general me-2">Chung</span>
                                    <span class="text-secondary small">Thông tin thường kỳ</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/notifications"
                                   class="type-filter-btn ${empty typeFilter ? 'active-filter' : ''}">
                                    <span class="material-symbols-outlined me-2" style="font-size: 16px; color: var(--on-surface-variant);">format_list_bulleted</span>
                                    <span class="text-secondary small">Tất cả thông báo</span>
                                </a>
                            </div>
                        </div>

                        <!-- Lưu ý -->
                        <div class="raised-card p-4"
                             style="background: linear-gradient(135deg, rgba(0,99,152,0.04), rgba(0,99,152,0.02)); border: 1px solid rgba(0,99,152,0.15);">
                            <div class="d-flex align-items-start gap-3">
                                <div class="rounded-2 d-flex align-items-center justify-content-center flex-shrink-0"
                                     style="width: 36px; height: 36px; background: rgba(0,99,152,0.1);">
                                    <span class="material-symbols-outlined" style="color: var(--tertiary); font-size: 20px; font-variation-settings: 'FILL' 1;">info</span>
                                </div>
                                <div>
                                    <h6 class="fw-bold mb-1" style="color: #191c1e;">Về Bảng tin</h6>
                                    <p class="small text-secondary mb-0" style="line-height: 1.6; font-size: 12.5px;">
                                        Bảng tin cung cấp thông báo về lịch nghỉ lễ, thay đổi chính sách, và sự kiện thư viện.
                                        Các cảnh báo cá nhân (quá hạn, tiền phạt) được gửi trực tiếp qua Email.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </div><!-- /.col-lg-4 -->
                </div><!-- /.row -->

            </div><!-- /.container-xl -->

            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.main-wrapper -->


    <!-- ════════════════ DETAIL MODAL ════════════════ -->
    <div class="modal fade" id="notifDetailModal" tabindex="-1" aria-labelledby="notifDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
            <div class="modal-content border-0 rounded-4 overflow-hidden shadow-lg">
                <!-- Modal Header -->
                <div class="modal-header border-0 px-4 py-3" id="modalHeaderBg" style="background-color: #f7f9fb;">
                    <div class="d-flex align-items-center gap-3 w-100">
                        <div id="modalTypeIcon" class="notif-card-icon icon-general">
                            <span class="material-symbols-outlined" id="modalTypeIconSymbol"
                                  style="font-variation-settings: 'FILL' 1; font-size: 22px;">campaign</span>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span id="modalTypeBadge" class="notif-badge-type type-general">Thông tin</span>
                                <span id="modalPinBadge" class="d-none material-symbols-outlined"
                                      style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;">push_pin</span>
                            </div>
                            <h5 class="modal-title fw-bold" id="notifDetailModalLabel"
                                style="color: #191c1e; font-size: 17px;">Chi tiết thông báo</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                </div>
                <!-- Modal Body -->
                <div class="modal-body px-4 py-3">
                    <div class="d-flex align-items-center gap-3 mb-3 pb-3"
                         style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex align-items-center gap-2 text-secondary small">
                            <span class="material-symbols-outlined" style="font-size: 16px;">person</span>
                            <span id="modalAuthor"></span>
                        </div>
                        <div class="d-flex align-items-center gap-2 text-secondary small">
                            <span class="material-symbols-outlined" style="font-size: 16px;">schedule</span>
                            <span id="modalTime"></span>
                        </div>
                    </div>
                    <div id="modalContent" class="text-secondary"
                         style="line-height: 1.75; font-size: 14.5px;"></div>
                </div>
                <!-- Modal Footer -->
                <div class="modal-footer border-0 px-4 py-3" style="background-color: #fafafa;">
                    <button type="button" class="btn rounded-3 px-4 fw-semibold"
                            style="background: var(--surface-container-high); color: var(--on-surface-variant);"
                            data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>


        const CTX_PATH = '${pageContext.request.contextPath}';

        // ── Highlight sidebar active link ─────────────────────────
        document.querySelectorAll('.sidebar-link').forEach(link => {
            if (link.href.includes('/notifications')) link.classList.add('active');
        });

        // ── Badge counter (live, in-session) ─────────────────────
        let currentUnreadCount = ${unreadCount};

        function updateBadgeCount(newCount) {
            currentUnreadCount = Math.max(0, newCount);
            const badgeEl = document.getElementById('headerUnreadBadge');
            if (badgeEl) {
                if (currentUnreadCount > 0) {
                    badgeEl.textContent = currentUnreadCount > 99 ? '99+' : currentUnreadCount;
                    badgeEl.classList.remove('d-none');
                } else {
                    badgeEl.classList.add('d-none');
                }
            }
        }

        // ── Mark single notification as read ─────────────────────
        async function markOneRead(notifId) {
            const cardEl = document.getElementById('notif-' + notifId);
            if (!cardEl || cardEl.dataset.read === 'true') return;

            try {
                const resp = await fetch(CTX_PATH + '/notification/mark-read', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=markOne&notificationId=' + notifId
                });
                const data = await resp.json();
                if (data.status === 'ok') {
                    cardEl.classList.remove('notif-card--unread');
                    cardEl.querySelector('.notif-unread-strip')?.classList.remove('strip-visible');
                    cardEl.querySelector('.unread-dot')?.remove();
                    cardEl.dataset.read = 'true';
                    updateBadgeCount(data.unreadCount);
                }
            } catch (e) { /* Silent fail */ }
        }

        // ── Mark ALL as read ─────────────────────────────────────
        const markAllBtn = document.getElementById('markAllReadBtn');
        if (markAllBtn) {
            markAllBtn.addEventListener('click', async () => {
                markAllBtn.disabled = true;
                markAllBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang xử lý...';
                try {
                    const resp = await fetch(CTX_PATH + '/notification/mark-read', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'action=markAll'
                    });
                    const data = await resp.json();
                    if (data.status === 'ok') {
                        document.querySelectorAll('.notif-card--unread').forEach(card => {
                            card.classList.remove('notif-card--unread');
                            card.querySelector('.notif-unread-strip')?.classList.remove('strip-visible');
                            card.querySelector('.unread-dot')?.remove();
                            card.dataset.read = 'true';
                        });
                        updateBadgeCount(0);
                        document.getElementById('markAllArea')?.remove();
                    }
                } catch (e) {
                    markAllBtn.disabled = false;
                    markAllBtn.innerHTML = '<span class="material-symbols-outlined me-1 align-middle" style="font-size:16px">done_all</span>Đánh dấu tất cả đã đọc';
                }
            });
        }

        // ── Open detail modal + auto mark as read ────────────────
        const typeIconMap = {
            urgent:  { symbol: 'error',       cls: 'icon-urgent',  badgeCls: 'type-urgent',  label: 'Khẩn cấp' },
            policy:  { symbol: 'policy',      cls: 'icon-policy',  badgeCls: 'type-policy',  label: 'Nội quy' },
            event:   { symbol: 'celebration', cls: 'icon-event',   badgeCls: 'type-event',   label: 'Sự kiện' },
            general: { symbol: 'campaign',    cls: 'icon-general', badgeCls: 'type-general', label: 'Thông tin' }
        };

        function openNotifDetail(btn) {
            const card = btn.closest('.notif-card');
            if (!card) return;

            const notifId   = card.dataset.notifId;
            const title     = card.querySelector('.notif-title')?.textContent.trim() || '';
            const content   = card.querySelector('.notif-full-content')?.textContent.trim() || '';
            const time      = card.querySelector('.font-monospace')?.textContent.trim() || '';
            const author    = card.querySelector('.btn-read-more')?.previousElementSibling?.textContent.trim() || '';
            const badgeEl   = card.querySelector('.notif-badge-type');
            const typeClass = badgeEl ? [...badgeEl.classList].find(c => c.startsWith('type-')) : 'type-general';
            const type      = typeClass ? typeClass.replace('type-', '') : 'general';
            const isPinned  = card.classList.contains('notif-card--pinned');

            const meta = typeIconMap[type] || typeIconMap.general;

            document.getElementById('notifDetailModalLabel').textContent = title;
            document.getElementById('modalContent').textContent           = content;
            document.getElementById('modalTime').textContent              = time;
            document.getElementById('modalAuthor').textContent            = author.replace(/^person/, '').trim();

            const iconEl = document.getElementById('modalTypeIcon');
            iconEl.className = 'notif-card-icon ' + meta.cls;
            document.getElementById('modalTypeIconSymbol').textContent = meta.symbol;

            const badgeModalEl = document.getElementById('modalTypeBadge');
            badgeModalEl.className  = 'notif-badge-type ' + meta.badgeCls;
            badgeModalEl.textContent = meta.label;

            const pinEl = document.getElementById('modalPinBadge');
            isPinned ? pinEl.classList.remove('d-none') : pinEl.classList.add('d-none');

            new bootstrap.Modal(document.getElementById('notifDetailModal')).show();

            if (notifId) markOneRead(notifId);
        }
    </script>

    <style>
        /* ─── Notification Cards ─── */
        .notif-card {
            background: #ffffff;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
            border: 1px solid #ebebeb;
            transition: transform 0.22s ease, box-shadow 0.22s ease;
            position: relative;
            overflow: hidden;
        }
        .notif-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.07);
        }
        .notif-card--pinned {
            border-left: 4px solid var(--primary);
            background: linear-gradient(90deg, rgba(157,67,0,0.02), #ffffff 60%);
        }
        .notif-card--unread {
            background: linear-gradient(135deg, rgba(157,67,0,0.03), #ffffff 70%);
            border-color: rgba(157,67,0,0.2);
        }
        .notif-card--unread .notif-title { font-weight: 700 !important; }

        /* ─── Unread strip ─── */
        .notif-unread-strip {
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 3px;
            background: transparent;
            border-radius: 3px 0 0 3px;
            transition: background 0.3s ease;
        }
        .strip-visible { background: var(--primary); }

        /* ─── Unread dot ─── */
        .unread-dot {
            display: inline-block;
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--primary);
            flex-shrink: 0;
        }

        /* ─── Pulsing dot ─── */
        .pulsing-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            background: var(--primary);
            animation: pulse-ring 1.5s ease-in-out infinite;
        }
        @keyframes pulse-ring {
            0%, 100% { box-shadow: 0 0 0 0 rgba(157,67,0,0.4); }
            50%       { box-shadow: 0 0 0 5px rgba(157,67,0,0); }
        }

        /* ─── Type Icon ─── */
        .notif-card-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .icon-general { background: rgba(0,99,152,0.10); color: var(--tertiary); }
        .icon-urgent  { background: rgba(239,68,68,0.10); color: #ef4444; }
        .icon-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
        .icon-event   { background: rgba(22,163,74,0.10); color: #16a34a; }

        /* ─── Type Badges ─── */
        .notif-badge-type {
            display: inline-flex; align-items: center;
            padding: 2px 10px; border-radius: 999px;
            font-size: 11px; font-weight: 700; letter-spacing: 0.04em; white-space: nowrap;
        }
        .type-general { background: rgba(0,99,152,0.10);  color: var(--tertiary); }
        .type-urgent  { background: rgba(239,68,68,0.12); color: #dc2626; }
        .type-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
        .type-event   { background: rgba(22,163,74,0.10); color: #15803d; }

        /* ─── Type filter sidebar buttons ─── */
        .type-filter-btn {
            display: flex; align-items: center;
            padding: 8px 12px; border-radius: 0.5rem;
            text-decoration: none; cursor: pointer;
            transition: background 0.2s ease;
        }
        .type-filter-btn:hover { background-color: var(--surface-container-high); }
        .active-filter { background-color: rgba(157,67,0,0.06); }

        /* ─── Empty state icon ─── */
        .empty-state-icon {
            width: 80px; height: 80px; border-radius: 50%;
            background: #f4f3f2; display: flex;
            align-items: center; justify-content: center;
        }

        /* ─── Pagination ─── */
        .page-link {
            border-color: #e5e5e5; color: #737373;
            font-size: 13px; padding: 4px 10px;
        }
        .page-item.active .page-link {
            background-color: var(--primary); border-color: var(--primary); color: white;
        }
        .page-link:hover { background-color: var(--surface-container-high); color: var(--primary); }

        /* ─── Read-more button hover ─── */
        .btn-read-more:hover { color: #7a2e00 !important; text-decoration: underline; }

        /* ─── Modal Plain Text Rendering ─── */
        #modalContent { color: #333; white-space: pre-line; }
        #modalContent a { color: var(--primary); text-decoration: none; }
        #modalContent a:hover { text-decoration: underline; }
    </style>
</body>
</html>
