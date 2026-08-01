<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Student --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ─── DESKTOP SIDEBAR ─── -->
<aside class="d-none d-lg-flex flex-column lms-sidebar sidebar-layout">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Cổng Sinh viên</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Student navigation">

        <!-- Truy cập Thư viện -->
        <p class="sidebar-section-label">Truy cập Thư viện</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/student/dashboard">
            <span class="material-symbols-outlined">home</span>
            <span>Trang chủ</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-search">
            <span class="material-symbols-outlined">search</span>
            <span>Tìm kiếm Sách</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/student/my-borrowings">
            <span class="material-symbols-outlined">library_books</span>
            <span>Quản lý sách đang mượn & đặt trước</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/student/borrow-history">
            <span class="material-symbols-outlined">history</span>
            <span>Lịch sử mượn trả</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/student/fines">
            <span class="material-symbols-outlined">payments</span>
            <span>Lịch sử nộp phạt</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/notifications">
            <span class="material-symbols-outlined">campaign</span>
            <span>Bảng tin</span>
            <span id="sidebarNavUnreadBadge" class="ms-auto badge rounded-pill"
                  style="background: var(--primary); color: white; font-size: 10px; padding: 2px 7px; min-width: 20px; text-align: center; display: none;">
            </span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/student/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span>
            <span>Trung tâm Trợ giúp</span>
        </a>

    </nav>

    <!-- ── Footer: Support Box ── -->
    <div class="px-3 pb-3">
        <div class="sidebar-status-card">
            <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">support_agent</span>
                Cần hỗ trợ?
            </p>
            <p class="text-on-surface-variant mb-2" style="font-size: 11.5px; line-height: 1.5;">
                Liên hệ thủ thư để được trợ giúp nghiên cứu hoặc báo cáo sự cố.
            </p>
            <a href="${pageContext.request.contextPath}/#contact"
               class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3"
               style="font-size: 12px; padding: 8px 12px;">
                Báo cáo sự cố
            </a>
        </div>
    </div>

</aside>

<!-- ─── MOBILE OFFCANVAS SIDEBAR ─── -->
<div class="offcanvas offcanvas-start lms-sidebar d-lg-none" tabindex="-1" id="studentSidebarOffcanvas" aria-labelledby="studentSidebarOffcanvasLabel" style="width: 280px;">
    <div class="offcanvas-header sidebar-brand border-bottom py-3">
        <div class="d-flex align-items-center gap-2">
            <div class="sidebar-brand-icon">
                <span class="material-symbols-outlined">local_library</span>
            </div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-name m-0">LMS Thư viện</p>
                <p class="sidebar-brand-role m-0">Cổng Sinh viên</p>
            </div>
        </div>
        <button type="button" class="btn-close text-reset ms-auto" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
    </div>
    <div class="offcanvas-body p-0 d-flex flex-column">
        <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Student mobile navigation">

            <p class="sidebar-section-label">Truy cập Thư viện</p>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/student/dashboard">
                <span class="material-symbols-outlined">home</span>
                <span>Trang chủ</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/book-search">
                <span class="material-symbols-outlined">search</span>
                <span>Tìm kiếm Sách</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/student/my-borrowings">
                <span class="material-symbols-outlined">library_books</span>
                <span>Quản lý sách đang mượn & đặt trước</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/student/borrow-history">
                <span class="material-symbols-outlined">history</span>
                <span>Lịch sử mượn trả</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/student/fines">
                <span class="material-symbols-outlined">payments</span>
                <span>Lịch sử nộp phạt</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/notifications">
                <span class="material-symbols-outlined">campaign</span>
                <span>Bảng tin</span>
            </a>

            <p class="sidebar-section-label">Tài khoản</p>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/student/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>Hồ sơ của tôi</span>
            </a>

            <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">contact_support</span>
                <span>Trung tâm Trợ giúp</span>
            </a>

        </nav>

        <div class="px-3 pb-3">
            <div class="sidebar-status-card">
                <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">support_agent</span>
                    Cần hỗ trợ?
                </p>
                <a href="${pageContext.request.contextPath}/#contact"
                   class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3"
                   style="font-size: 12px; padding: 8px 12px;">
                    Báo cáo sự cố
                </a>
            </div>
        </div>
    </div>
</div>

<script>
/* Student Sidebar: exact pathname match for active state */
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
