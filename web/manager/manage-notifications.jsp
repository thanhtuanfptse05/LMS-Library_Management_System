<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    /* ─── Notification Row ─── */
    .notif-row {
        border-bottom: 1px solid var(--outline-variant);
        transition: background-color 0.2s ease;
    }
    .notif-row:last-child { border-bottom: none; }
    .notif-row:hover { background-color: var(--surface-container-low); }
    .notif-pinned {
        background: linear-gradient(90deg, rgba(157,67,0,0.04), transparent);
    }
    .notif-pinned:hover {
        background: linear-gradient(90deg, rgba(157,67,0,0.08), var(--surface-container-low));
    }
    /* ─── Type Icon ─── */
    .notif-type-icon {
        width: 42px; height: 42px; border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
    }
    .icon-general { background: rgba(0,99,152,0.10); color: var(--tertiary); }
    .icon-urgent  { background: rgba(239,68,68,0.10); color: #ef4444; }
    .icon-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
    .icon-event   { background: rgba(22,163,74,0.10); color: var(--success); }
    /* ─── Type Badges ─── */
    .notif-badge-type {
        display: inline-flex; align-items: center;
        padding: 2px 10px; border-radius: 999px;
        font-size: 11px; font-weight: 700; letter-spacing: 0.04em;
        white-space: nowrap;
    }
    .type-general { background: rgba(0,99,152,0.10);  color: var(--tertiary); }
    .type-urgent  { background: rgba(239,68,68,0.12); color: #dc2626; }
    .type-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
    .type-event   { background: rgba(22,163,74,0.10); color: #15803d; }
    /* ─── Pagination ─── */
    .page-link {
        border-color: var(--outline-variant);
        color: var(--on-surface-variant);
        font-size: 13px;
        padding: 4px 10px;
    }
    .page-item.active .page-link {
        background-color: var(--primary);
        border-color: var(--primary);
        color: white;
    }
    .page-link:hover { background-color: var(--surface-container-high); color: var(--primary); }
    /* ─── Target Role Badges ─── */
    .target-badge {
        display: inline-flex; align-items: center; gap: 3px;
        padding: 2px 8px; border-radius: 999px;
        font-size: 11px; font-weight: 600; white-space: nowrap;
    }
    .target-all      { background: rgba(0,0,0,0.06);      color: #555; }
    .target-student  { background: rgba(59,130,246,0.10);  color: #1d4ed8; }
    .target-lecturer { background: rgba(139,92,246,0.10);  color: #6d28d9; }
    /* ─── Modal plain text rendering ─── */
    #modalContent { color: #333; white-space: pre-line; }
    #modalContent a { color: var(--primary); text-decoration: none; }
    #modalContent a:hover { text-decoration: underline; }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1300px; margin: 0 auto;">

                <%-- Breadcrumb --%>
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted"
                       href="${pageContext.request.contextPath}/manager/dashboard">Bảng điều khiển</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span style="color: var(--on-surface);">Quản lý Bảng tin</span>
                </nav>

                <%-- Page Title --%>
                <div class="d-flex justify-content-between align-items-start mb-5 flex-wrap gap-3">
                    <div>
                        <h1 class="fw-bold mb-1" style="font-size: 28px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2 align-middle"
                                  style="font-size: 30px; color: var(--primary); font-variation-settings: 'FILL' 1;">campaign</span>
                            Quản lý Bảng tin
                        </h1>
                        <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-0">
                            Đăng thông báo nội bộ đến toàn bộ Sinh viên và Giảng viên trong hệ thống.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3 d-flex align-items-center gap-2"
                             style="background: linear-gradient(135deg, rgba(157,67,0,0.08), rgba(249,115,22,0.05)); border: 1px solid rgba(157,67,0,0.15);">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 18px;">notifications_active</span>
                            <span class="fw-bold" style="font-size: 22px; color: var(--primary);">${totalCount}</span>
                            <span style="font-size: 12px; color: var(--on-surface-variant);">thông báo</span>
                        </div>
                    </div>
                </div>

                <%-- Alert Messages --%>
                <c:if test="${not empty param.success}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3" role="alert"
                         style="background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(22,163,74,0.04)); border: 1px solid rgba(22,163,74,0.25); color: #15803d;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #16a34a;">check_circle</span>
                        <span class="fw-semibold"><c:out value="${param.success}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3" role="alert"
                         style="background: linear-gradient(135deg, rgba(186,26,26,0.08), rgba(186,26,26,0.04)); border: 1px solid rgba(186,26,26,0.2); color: #93000a;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #ef4444;">error</span>
                        <span class="fw-semibold"><c:out value="${param.error}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <div class="row g-4">
                    <%-- LEFT: Form đăng / chỉnh sửa --%>
                    <jsp:include page="fragments/_notif-form.jsp" />

                    <%-- RIGHT: Danh sách thông báo --%>
                    <jsp:include page="fragments/_notif-list.jsp" />
                </div>

            </div>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <%-- Modals --%>
    <jsp:include page="fragments/_notif-modals.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fix sidebar active link — exact pathname match
        (function() {
            var curPath = window.location.pathname;
            document.querySelectorAll('.sidebar-link').forEach(function(link) {
                if (link.getAttribute('href') === '#') return;
                var linkPath = link.pathname;
                if (linkPath && (curPath === linkPath || curPath.startsWith(linkPath + '/'))) {
                    link.classList.add('active');
                }
            });
        })();

        let pendingDeleteForm = null;

        function confirmDelete(event, title) {
            event.preventDefault();
            pendingDeleteForm = event.target;
            document.getElementById('deleteModalTitle').textContent = '"' + title + '"';
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
            return false;
        }

        document.getElementById('confirmDeleteBtn').addEventListener('click', () => {
            if (pendingDeleteForm) pendingDeleteForm.submit();
        });

        /**
         * Ẩn/hiện dropdown chọn mẫu email dựa theo trạng thái checkbox isSendEmail.
         */
        function toggleTemplateDropdown(wrapperId, checkbox) {
            var wrapper = document.getElementById(wrapperId);
            if (!wrapper) return;
            wrapper.style.display = checkbox.checked ? 'block' : 'none';
            var sel = wrapper.querySelector('select[name="templateName"]');
            if (sel) {
                if (checkbox.checked) {
                    sel.setAttribute('required', 'required');
                } else {
                    sel.removeAttribute('required');
                    sel.value = '';
                }
            }
        }

        // Toggle hiện/ẩn thumbnail & ghi chú công khai khi chọn type (form tạo mới)
        function onTypeChangeCreate(selectEl) {
            const val = selectEl.value;
            const isPublic = (val === 'general' || val === 'event');
            document.getElementById('thumbnailSectionCreate').style.display = isPublic ? 'block' : 'none';
            document.getElementById('publicNoteCreate').style.display = isPublic ? 'block' : 'none';
        }
        // Khởi tạo trạng thái ban đầu
        (function() {
            const sel = document.getElementById('notifType');
            if (sel) onTypeChangeCreate(sel);
        })();

        const typeIconMap = {
            urgent:  { symbol: 'error',       cls: 'icon-urgent',  badgeCls: 'type-urgent',  label: 'Khẩn cấp' },
            policy:  { symbol: 'policy',      cls: 'icon-policy',  badgeCls: 'type-policy',  label: 'Nội quy' },
            event:   { symbol: 'celebration', cls: 'icon-event',   badgeCls: 'type-event',   label: 'Sự kiện' },
            general: { symbol: 'campaign',    cls: 'icon-general', badgeCls: 'type-general', label: 'Thông tin' }
        };

        function openManagerDetail(btn) {
            const row = btn.closest('.notif-row');
            if (!row) return;

            const title    = row.getAttribute('data-title');
            const author   = row.getAttribute('data-author');
            const time     = row.getAttribute('data-time');
            const type     = row.getAttribute('data-type') || 'general';
            const isPinned = row.getAttribute('data-pinned') === 'true';
            const notifId  = row.getAttribute('data-notif-id');
            const content  = row.querySelector('.notif-full-content').textContent.trim();

            const meta = typeIconMap[type] || typeIconMap.general;

            document.getElementById('notifDetailModalLabel').textContent = title;
            document.getElementById('modalContent').textContent = content;
            document.getElementById('modalTime').textContent = time;
            document.getElementById('modalAuthor').textContent = author;

            const iconEl = document.getElementById('modalTypeIcon');
            iconEl.className = 'notif-type-icon ' + meta.cls;
            document.getElementById('modalTypeIconSymbol').textContent = meta.symbol;

            const badgeModalEl = document.getElementById('modalTypeBadge');
            badgeModalEl.className = 'notif-badge-type ' + meta.badgeCls;
            badgeModalEl.textContent = meta.label;

            const pinEl = document.getElementById('modalPinBadge');
            isPinned ? pinEl.classList.remove('d-none') : pinEl.classList.add('d-none');

            new bootstrap.Modal(document.getElementById('notifDetailModal')).show();

            // Mark as read: gọi API nếu chưa đọc
            if (notifId && !row.classList.contains('notif-read')) {
                fetch('${pageContext.request.contextPath}/notification/read-status', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'notificationId=' + encodeURIComponent(notifId)
                })
                .then(function(res) {
                    if (res.ok) {
                        row.classList.add('notif-read');
                        var badge = document.getElementById('headerUnreadBadge');
                        if (badge) {
                            var count = parseInt(badge.textContent, 10);
                            if (!isNaN(count) && count > 1) {
                                badge.textContent = count - 1;
                            } else {
                                badge.remove();
                            }
                        }
                    }
                })
                .catch(function() { /* silent fail */ });
            }
        }
    </script>
</body>
</html>
