<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ════════════════ UNIFIED SIDEBAR & MOBILE OFFCANVAS ════════════════ -->
<aside class="offcanvas-lg offcanvas-start lms-sidebar sidebar-layout" tabindex="-1" id="adminSidebarOffcanvas" aria-labelledby="adminSidebarOffcanvasLabel">

    <!-- ── Mobile Offcanvas Header ── -->
    <div class="offcanvas-header sidebar-brand border-bottom d-lg-none py-2 px-3">
        <div class="d-flex align-items-center gap-2">
            <div class="sidebar-brand-icon">
                <span class="material-symbols-outlined">local_library</span>
            </div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-name m-0">LMS Thư viện</p>
                <p class="sidebar-brand-role m-0">Quản trị Hệ thống</p>
            </div>
        </div>
        <button type="button" class="btn-close text-reset ms-auto" data-bs-dismiss="offcanvas" data-bs-target="#adminSidebarOffcanvas" aria-label="Đóng"></button>
    </div>

    <!-- ── Desktop Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand d-none d-lg-flex">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Quản trị Hệ thống</p>
        </div>
    </a>

    <!-- ── Nav Links ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Admin navigation" style="overflow-y: auto;">

        <!-- Tổng quan -->
        <p class="sidebar-section-label">Tổng quan</p>
        <a class="sidebar-link nav-dash-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>

        <!-- Người dùng -->
        <p class="sidebar-section-label">Người dùng</p>
        <a class="sidebar-link nav-user-link" href="${pageContext.request.contextPath}/admin/user">
            <span class="material-symbols-outlined">group</span>
            <span>Quản lý Người dùng</span>
        </a>

        <!-- Cấu hình Hệ thống -->
        <p class="sidebar-section-label">Cấu hình Hệ thống</p>
        <a class="sidebar-link nav-config-link" href="${pageContext.request.contextPath}/admin/system-config">
            <span class="material-symbols-outlined">settings</span>
            <span>Cấu hình</span>
        </a>

        <!-- Kiểm toán & Giám sát -->
        <p class="sidebar-section-label">Kiểm toán &amp; Giám sát</p>
        <a class="sidebar-link nav-audit-link" href="${pageContext.request.contextPath}/admin/audit-log">
            <span class="material-symbols-outlined">receipt_long</span>
            <span>Nhật ký Kiểm toán</span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link nav-profile-link" href="${pageContext.request.contextPath}/admin/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>

    </nav>

    <!-- ── Footer ── -->
    <div class="px-3 pb-3 mt-auto">
        <a class="sidebar-link mb-2" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">help</span>
            <span>Trung tâm Trợ giúp</span>
        </a>
        <div class="sidebar-status-card">
            <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">monitor_heart</span>
                Trạng thái Hệ thống
            </p>
            <div class="d-flex align-items-center gap-2">
                <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                      style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Cơ sở dữ liệu hoạt động</span>
            </div>
        </div>
    </div>

</aside>

<script>
/* Admin Sidebar: auto active state dựa theo URL */
(function () {
    var path = window.location.pathname;
    document.querySelectorAll('.sidebar-link').forEach(function(l) { l.classList.remove('active'); });

    function setActive(selector) {
        document.querySelectorAll(selector).forEach(function(el) { el.classList.add('active'); });
    }

    if (path.indexOf('/admin/user') !== -1) {
        setActive('.nav-user-link');
    } else if (path.indexOf('/admin/system-config') !== -1) {
        setActive('.nav-config-link');
    } else if (path.indexOf('/admin/audit-log') !== -1) {
        setActive('.nav-audit-link');
    } else if (path.indexOf('/admin/profile') !== -1) {
        setActive('.nav-profile-link');
    } else {
        setActive('.nav-dash-link');
    }
})();
</script>
