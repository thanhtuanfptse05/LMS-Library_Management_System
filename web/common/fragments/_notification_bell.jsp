<%-- Fragment: _notification_bell.jsp — Shared Premium Notification Bell Dropdown --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="defaultNotifLink" value="${pageContext.request.contextPath}/notifications" />
<c:set var="finalNotifLink" value="${not empty notifLink ? notifLink : defaultNotifLink}" />

<!-- ════ NOTIFICATION BELL ════ -->
<div class="notif-bell-wrapper" id="lmsNotifWrapper">
    <button class="header-icon-btn notif-bell-btn"
            id="lmsNotifBtn"
            aria-label="Thông báo"
            aria-expanded="false"
            aria-controls="lmsNotifPanel">
        <span class="material-symbols-outlined notif-bell-icon"
              style="font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;">
            notifications
        </span>
        <!-- Unread badge -->
        <c:choose>
            <c:when test="${not empty unreadNotificationCount and unreadNotificationCount > 0}">
                <span class="notif-count-badge" id="headerUnreadBadge">
                    <c:choose>
                        <c:when test="${unreadNotificationCount > 99}">99+</c:when>
                        <c:otherwise><c:out value="${unreadNotificationCount}"/></c:otherwise>
                    </c:choose>
                </span>
            </c:when>
            <c:otherwise>
                <span class="notif-pulse-dot"></span>
            </c:otherwise>
        </c:choose>
    </button>

    <!-- ════ DROPDOWN PANEL ════ -->
    <div class="notif-panel" id="lmsNotifPanel" role="dialog" aria-label="Bảng thông báo">

        <!-- Panel Header -->
        <div class="notif-panel-header">
            <div class="d-flex align-items-center gap-2">
                <span class="material-symbols-outlined"
                      style="font-size: 20px; color: var(--primary); font-variation-settings: 'FILL' 1;">
                    notifications_active
                </span>
                <span class="fw-bold" style="font-size: 15px; color: var(--on-surface);">Thông báo</span>
                <c:if test="${not empty unreadNotificationCount and unreadNotificationCount > 0}">
                    <span class="notif-header-count">
                        <c:out value="${unreadNotificationCount}"/> mới
                    </span>
                </c:if>
            </div>
            <a href="${finalNotifLink}" class="notif-see-all-btn">
                Xem tất cả
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">arrow_forward</span>
            </a>
        </div>

        <!-- Panel Body -->
        <div class="notif-panel-body" id="lmsNotifBody">
            <c:choose>
                <c:when test="${not empty recentNotifications}">
                    <c:forEach var="notif" items="${recentNotifications}" varStatus="vs">
                        <c:if test="${vs.index < 5}">
                            <div class="notif-item ${notif.pinned ? 'notif-item-pinned' : ''} ${notif.read ? 'notif-read' : 'notif-unread'}">
                                <!-- Unread indicator dot -->
                                <c:if test="${!notif.read}">
                                    <div class="notif-unread-dot"></div>
                                </c:if>
                                <!-- Type icon -->
                                <div class="notif-item-icon
                                    ${notif.type == 'urgent'  ? 'notif-icon-urgent'  :
                                      notif.type == 'policy'  ? 'notif-icon-policy'  :
                                      notif.type == 'event'   ? 'notif-icon-event'   : 'notif-icon-general'}">
                                    <span class="material-symbols-outlined"
                                          style="font-size: 16px; font-variation-settings: 'FILL' 1;">
                                        ${notif.type == 'urgent'  ? 'error'       :
                                          notif.type == 'policy'  ? 'policy'      :
                                          notif.type == 'event'   ? 'celebration' : 'campaign'}
                                    </span>
                                </div>
                                <!-- Content -->
                                <div class="notif-item-content">
                                    <p class="notif-item-title">
                                        <c:if test="${notif.pinned}">
                                            <span class="material-symbols-outlined"
                                                  style="font-size: 12px; color: var(--primary); font-variation-settings: 'FILL' 1; vertical-align: middle;">
                                                push_pin
                                            </span>
                                        </c:if>
                                        <c:out value="${notif.title}"/>
                                    </p>
                                    <p class="notif-item-meta">
                                        <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">schedule</span>
                                        <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                                <!-- Type chip -->
                                <span class="notif-item-chip
                                    ${notif.type == 'urgent'  ? 'chip-urgent'  :
                                      notif.type == 'policy'  ? 'chip-policy'  :
                                      notif.type == 'event'   ? 'chip-event'   : 'chip-general'}">
                                    ${notif.type == 'urgent'  ? 'Khẩn' :
                                      notif.type == 'policy'  ? 'Nội quy' :
                                      notif.type == 'event'   ? 'Sự kiện' : 'Chung'}
                                </span>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Empty state -->
                    <div class="notif-empty-state">
                        <div class="notif-empty-icon">
                            <span class="material-symbols-outlined"
                                  style="font-size: 32px; color: var(--primary); opacity: 0.5;
                                         font-variation-settings: 'FILL' 1;">
                                notifications_off
                            </span>
                        </div>
                        <p class="fw-bold mb-1" style="font-size: 14px; color: var(--on-surface);">Chưa có thông báo mới</p>
                        <p class="mb-0" style="font-size: 12px; color: var(--on-surface-variant);">
                            Khi có thông báo mới sẽ hiển thị tại đây.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Panel Footer -->
        <div class="notif-panel-footer">
            <a href="${finalNotifLink}"
               class="btn btn-primary-custom w-100 rounded-3 fw-bold d-flex align-items-center justify-content-center gap-2"
               style="font-size: 13px; padding: 9px 16px;">
                <span class="material-symbols-outlined" style="font-size: 16px;">open_in_new</span>
                Xem chi tiết Bảng tin
            </a>
        </div>

    </div><!-- /notif-panel -->
</div><!-- /notif-bell-wrapper -->

<!-- ════════════════ NOTIFICATION STYLES ════════════════ -->
<style>
    .notif-bell-wrapper { position: relative; }
    .notif-bell-btn { transition: transform 0.2s ease, background 0.2s ease !important; }
    .notif-bell-btn.active { background: var(--surface-container-high) !important; }
    .notif-bell-btn.active .notif-bell-icon {
        font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24 !important;
        color: var(--primary);
    }
    .notif-count-badge {
        position: absolute; top: 5px; right: 4px;
        background: linear-gradient(135deg, var(--primary), #c0550a);
        color: white; font-size: 9px; font-weight: 800; border-radius: 999px;
        padding: 1px 5px; min-width: 16px; text-align: center; border: 2px solid white;
        line-height: 1.4; animation: notifPop 0.4s ease;
    }
    .notif-pulse-dot {
        position: absolute; top: 7px; right: 7px; width: 7px; height: 7px;
        background: var(--primary); border-radius: 50%; border: 1.5px solid white;
        animation: pulse 2s ease-in-out infinite;
    }
    @keyframes notifPop {
        0%   { transform: scale(0); opacity: 0; }
        70%  { transform: scale(1.2); }
        100% { transform: scale(1); opacity: 1; }
    }
    @keyframes pulse {
        0%, 100% { transform: scale(1); opacity: 1; }
        50%       { transform: scale(1.35); opacity: 0.6; }
    }
    .notif-panel {
        position: absolute; top: calc(100% + 12px); right: 0; width: 360px;
        background: rgba(255,255,255,0.98); border: 1px solid var(--outline-variant);
        border-radius: 16px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.03), 0 12px 30px rgba(0,0,0,0.10), 0 2px 4px rgba(157,67,0,0.06);
        backdrop-filter: blur(16px); z-index: 2000;
        opacity: 0; visibility: hidden; transform: translateY(-10px) scale(0.97);
        transform-origin: top right;
        transition: opacity 0.22s cubic-bezier(0.4, 0, 0.2, 1), transform 0.22s cubic-bezier(0.4, 0, 0.2, 1), visibility 0.22s;
        pointer-events: none;
    }
    .notif-panel.open {
        opacity: 1; visibility: visible; transform: translateY(0) scale(1); pointer-events: auto;
    }
    .notif-panel-header {
        display: flex; align-items: center; justify-content: space-between;
        padding: 14px 18px 12px; border-bottom: 1px solid var(--outline-variant);
        background: linear-gradient(135deg, rgba(255,219,202,0.3), rgba(255,255,255,0));
        border-radius: 16px 16px 0 0;
    }
    .notif-header-count {
        background: linear-gradient(135deg, rgba(157,67,0,0.12), rgba(249,115,22,0.08));
        color: var(--primary); font-size: 11px; font-weight: 700; border-radius: 999px;
        padding: 2px 8px; border: 1px solid rgba(157,67,0,0.15);
    }
    .notif-see-all-btn {
        font-size: 12px; font-weight: 700; color: var(--primary); text-decoration: none;
        display: flex; align-items: center; gap: 3px; opacity: 0.8; transition: opacity 0.2s ease;
    }
    .notif-see-all-btn:hover { opacity: 1; text-decoration: underline; }
    .notif-panel-body { max-height: 320px; overflow-y: auto; overscroll-behavior: contain; }
    .notif-panel-body::-webkit-scrollbar { width: 4px; }
    .notif-panel-body::-webkit-scrollbar-thumb { background: var(--outline-variant); border-radius: 10px; }
    .notif-item {
        display: flex; align-items: flex-start; gap: 12px; padding: 13px 18px;
        border-bottom: 1px solid rgba(0,0,0,0.04); cursor: pointer; transition: background 0.15s ease;
        position: relative;
    }
    .notif-item:last-child { border-bottom: none; }
    .notif-item:hover { background: linear-gradient(90deg, rgba(157,67,0,0.03), transparent); }
    .notif-item-pinned { background: linear-gradient(90deg, rgba(157,67,0,0.04), transparent) !important; }
    
    /* Read / Unread styles */
    .notif-read { opacity: 0.75; }
    .notif-unread { background: rgba(157,67,0,0.02); }
    .notif-unread .notif-item-title { font-weight: 800; color: var(--primary); }
    .notif-unread-dot {
        position: absolute; left: 6px; top: 22px; width: 6px; height: 6px;
        background: var(--primary); border-radius: 50%;
    }

    .notif-item-icon {
        width: 36px; height: 36px; border-radius: 10px; display: flex;
        align-items: center; justify-content: center; flex-shrink: 0;
    }
    .notif-icon-general { background: rgba(0,99,152,0.10); color: var(--tertiary); }
    .notif-icon-urgent  { background: rgba(186,26,26,0.10); color: var(--error); }
    .notif-icon-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
    .notif-icon-event   { background: rgba(22,163,74,0.10); color: #16a34a; }
    .notif-item-content { flex: 1; min-width: 0; }
    .notif-item-title {
        font-size: 13px; font-weight: 600; color: var(--on-surface); margin: 0 0 4px;
        white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 210px; line-height: 1.4;
    }
    .notif-item-meta { font-size: 11px; color: var(--on-surface-variant); margin: 0; display: flex; gap: 3px; }
    .notif-item-chip {
        flex-shrink: 0; font-size: 10px; font-weight: 700; border-radius: 999px; padding: 2px 8px; white-space: nowrap;
    }
    .chip-general { background: rgba(0,99,152,0.10); color: var(--tertiary); }
    .chip-urgent  { background: rgba(186,26,26,0.10); color: var(--error); }
    .chip-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
    .chip-event   { background: rgba(22,163,74,0.10); color: #15803d; }
    .notif-empty-state { display: flex; flex-direction: column; align-items: center; padding: 36px 24px; text-align: center; }
    .notif-empty-icon {
        width: 64px; height: 64px; border-radius: 50%;
        background: linear-gradient(135deg, rgba(157,67,0,0.06), rgba(249,115,22,0.04));
        display: flex; align-items: center; justify-content: center; margin-bottom: 14px;
    }
    .notif-panel-footer {
        padding: 12px 16px 14px; border-top: 1px solid var(--outline-variant);
        background: var(--surface-container-low); border-radius: 0 0 16px 16px;
    }
    .notif-panel::before {
        content: ''; position: absolute; top: -8px; right: 18px; width: 16px; height: 16px;
        background: white; border: 1px solid var(--outline-variant); border-bottom: none; border-right: none;
        transform: rotate(45deg); border-radius: 2px 0 0 0;
    }
    @keyframes bellShake {
        0%, 100% { transform: rotate(0deg); }
        15%       { transform: rotate(12deg); }
        30%       { transform: rotate(-10deg); }
        45%       { transform: rotate(8deg); }
        60%       { transform: rotate(-6deg); }
        75%       { transform: rotate(4deg); }
    }
    .bell-shake { animation: bellShake 0.55s ease; }
</style>

<!-- ════════════════ NOTIFICATION SCRIPT ════════════════ -->
<script>
(function() {
    var btn    = document.getElementById('lmsNotifBtn');
    var panel  = document.getElementById('lmsNotifPanel');
    var wrapper = document.getElementById('lmsNotifWrapper');
    var bellIcon = btn ? btn.querySelector('.notif-bell-icon') : null;

    if (!btn || !panel) return;

    function openPanel() {
        panel.classList.add('open');
        btn.classList.add('active');
        btn.setAttribute('aria-expanded', 'true');
        if (bellIcon) {
            bellIcon.classList.add('bell-shake');
            setTimeout(function() { bellIcon.classList.remove('bell-shake'); }, 600);
        }
    }
    function closePanel() {
        panel.classList.remove('open');
        btn.classList.remove('active');
        btn.setAttribute('aria-expanded', 'false');
    }
    function togglePanel() {
        if (panel.classList.contains('open')) { closePanel(); } else { openPanel(); }
    }

    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        togglePanel();
    });
    document.addEventListener('click', function(e) {
        if (!wrapper.contains(e.target)) closePanel();
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closePanel();
    });
    
    // Sync the sidebar unread badge
    var unreadCount = parseInt('${not empty unreadNotificationCount ? unreadNotificationCount : 0}');
    var sidebarNavBadge = document.getElementById('sidebarNavUnreadBadge');
    if (sidebarNavBadge) {
        if (unreadCount > 0) {
            sidebarNavBadge.textContent = unreadCount > 99 ? '99+' : unreadCount;
            sidebarNavBadge.style.display = 'inline-block';
        } else {
            sidebarNavBadge.style.display = 'none';
        }
    }
})();
</script>
