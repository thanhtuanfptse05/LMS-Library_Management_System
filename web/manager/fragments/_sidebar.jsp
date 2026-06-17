<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Library Manager --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column lms-sidebar sidebar-layout">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Quản lý Thư viện</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Manager navigation">

        <!-- Tổng quan -->
        <p class="sidebar-section-label">Tổng quan</p>
        <a class="sidebar-link" id="mgr-nav-dashboard" href="${pageContext.request.contextPath}/manager/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>

        <!-- Quản lý Chính sách -->
        <p class="sidebar-section-label">Chính sách &amp; Cấu hình</p>
        <a class="sidebar-link" id="mgr-nav-policy" href="#">
            <span class="material-symbols-outlined">gavel</span>
            <span>Chính sách Hoạt động</span>
        </a>
        <a class="sidebar-link" id="mgr-nav-config" href="#">
            <span class="material-symbols-outlined">settings</span>
            <span>Cấu hình Hệ thống</span>
        </a>
        <a class="sidebar-link" id="mgr-nav-documents" href="${pageContext.request.contextPath}/manager/document-templates">
            <span class="material-symbols-outlined">description</span>
            <span>Mẫu Văn bản</span>
        </a>

        <!-- Thông báo & Báo cáo -->
        <p class="sidebar-section-label">Thông báo &amp; Báo cáo</p>
        <a class="sidebar-link" id="mgr-nav-notifications" href="${pageContext.request.contextPath}/manager/notifications">
            <span class="material-symbols-outlined">campaign</span>
            <span>Quản lý Thông báo</span>
        </a>
        <a class="sidebar-link" id="mgr-nav-email" href="${pageContext.request.contextPath}/manager/email-templates">
            <span class="material-symbols-outlined">mail</span>
            <span>Mẫu Email</span>
        </a>
        <a class="sidebar-link" id="mgr-nav-reports" href="#">
            <span class="material-symbols-outlined">bar_chart</span>
            <span>Báo cáo Thống kê</span>
        </a>

        <!-- Nhân viên -->
        <p class="sidebar-section-label">Nhân viên</p>
        <a class="sidebar-link" id="mgr-nav-staff" href="#">
            <span class="material-symbols-outlined">groups</span>
            <span>Hiệu suất Nhân viên</span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link" id="mgr-nav-profile" href="${pageContext.request.contextPath}/manager/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>

    </nav>

    <!-- ── Footer ── -->
    <div class="px-3 pb-3">
        <a class="sidebar-link mb-2" href="#">
            <span class="material-symbols-outlined">help</span>
            <span>Trung tâm Trợ giúp</span>
        </a>
        <div class="sidebar-status-card">
            <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">insights</span>
                KPI Tháng này
            </p>
            <div class="d-flex align-items-center gap-2">
                <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                      style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Đạt 78% mục tiêu</span>
            </div>
        </div>
    </div>

</aside>

<script>
/* Manager Sidebar: exact pathname match for active state */
(function () {
    var curPath = window.location.pathname;
    document.querySelectorAll('aside .sidebar-link').forEach(function(link) {
        if (link.getAttribute('href') === '#') return;
        var linkPath = link.pathname;
        if (linkPath && (curPath === linkPath || curPath.startsWith(linkPath + '/'))) {
            link.classList.add('active');
        }
    });
})();
</script>
