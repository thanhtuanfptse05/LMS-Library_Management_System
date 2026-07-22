<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ════════════════ UNIFIED SIDEBAR & MOBILE OFFCANVAS ════════════════ -->
<aside class="offcanvas-lg offcanvas-start lms-sidebar sidebar-layout" tabindex="-1" id="managerSidebarOffcanvas" aria-labelledby="managerSidebarOffcanvasLabel">

    <!-- ── Mobile Offcanvas Header ── -->
    <div class="offcanvas-header sidebar-brand border-bottom d-lg-none py-2 px-3">
        <div class="d-flex align-items-center gap-2">
            <div class="sidebar-brand-icon">
                <span class="material-symbols-outlined">local_library</span>
            </div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-name m-0">LMS Thư viện</p>
                <p class="sidebar-brand-role m-0">Quản lý Thư viện</p>
            </div>
        </div>
        <button type="button" class="btn-close text-reset ms-auto" data-bs-dismiss="offcanvas" data-bs-target="#managerSidebarOffcanvas" aria-label="Đóng"></button>
    </div>

    <!-- ── Desktop Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand d-none d-lg-flex">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Quản lý Thư viện</p>
        </div>
    </a>

    <!-- ── Nav Links ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Manager navigation" style="overflow-y: auto;">

        <!-- Tổng quan -->
        <p class="sidebar-section-label">Tổng quan</p>
        <a class="sidebar-link" id="mgr-nav-dashboard" href="${pageContext.request.contextPath}/manager/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>

        <!-- Quản lý Chính sách -->
        <p class="sidebar-section-label">Chính sách &amp; Cấu hình</p>

        <a class="sidebar-link" id="mgr-nav-config" href="${pageContext.request.contextPath}/manager/system-config">
            <span class="material-symbols-outlined">settings</span>
            <span>Cấu hình Hệ thống</span>
        </a>
        <a class="sidebar-link" id="mgr-nav-payment-config" href="${pageContext.request.contextPath}/manager/payment-config">
            <span class="material-symbols-outlined">qr_code_scanner</span>
            <span>Cấu hình Thanh toán</span>
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
        <a class="sidebar-link" id="mgr-nav-reports" href="${pageContext.request.contextPath}/manager/reports/dashboard">
            <span class="material-symbols-outlined">bar_chart</span>
            <span>Báo cáo Thống kê</span>
        </a>

        <!-- Nhân viên -->
        <p class="sidebar-section-label">Nhân viên</p>
        <a class="sidebar-link" id="mgr-nav-staff" href="${pageContext.request.contextPath}/manager/staff-performance">
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
    <div class="px-3 pb-3 mt-auto">
        <a class="sidebar-link mb-2" href="${pageContext.request.contextPath}/#contact">
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
    document.querySelectorAll('.sidebar-link').forEach(function(link) {
        var hrefAttr = link.getAttribute('href');
        if (!hrefAttr || hrefAttr.trim() === '' || hrefAttr.trim().startsWith('#')) return;
        var linkPath = link.pathname;
        if (linkPath && (curPath === linkPath || curPath.startsWith(linkPath + '/'))) {
            link.classList.add('active');
        }
    });
})();
</script>
