<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Lecturer --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column lms-sidebar sidebar-layout">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Truy cập Giảng viên</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Lecturer navigation">

        <!-- Không gian làm việc -->
        <p class="sidebar-section-label">Không gian làm việc</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/my-borrowings">
            <span class="material-symbols-outlined">library_books</span>
            <span>Hàng mượn & chờ sách</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/borrow-history">
            <span class="material-symbols-outlined">history</span>
            <span>Lịch sử mượn trả</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/fines">
            <span class="material-symbols-outlined">payments</span>
            <span>Tiền phạt &amp; Thanh toán</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/notifications">
            <span class="material-symbols-outlined">campaign</span>
            <span>Bảng tin</span>
        </a>

        <!-- Tài nguyên học tập -->
        <p class="sidebar-section-label">Tài nguyên học tập</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">menu_book</span>
            <span>Sách theo môn học</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">article</span>
            <span>Danh mục tài liệu đọc</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">science</span>
            <span>Tài liệu nghiên cứu</span>
        </a>

        <!-- Thư viện -->
        <p class="sidebar-section-label">Thư viện</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-search">
            <span class="material-symbols-outlined">search</span>
            <span>Tra cứu Mục lục</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span>
            <span>Trợ giúp</span>
        </a>

    </nav>

    <!-- ── Footer: Research Support Box ── -->
    <div class="px-3 pb-3">
        <div class="sidebar-status-card" style="background: linear-gradient(135deg, rgba(205,229,255,0.4) 0%, rgba(0,99,152,0.08) 100%); border-color: rgba(0,99,152,0.2);">
            <p class="fw-bold mb-2" style="color: var(--tertiary); font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">science</span>
                Hỗ trợ Nghiên cứu
            </p>
            <p class="text-on-surface-variant mb-2" style="font-size: 11.5px; line-height: 1.5;">
                Cần tạp chí hay cơ sở dữ liệu cụ thể? Liên hệ thủ thư nghiên cứu.
            </p>
            <a href="${pageContext.request.contextPath}/#contact"
               class="btn w-100 btn-sm text-decoration-none d-block text-center rounded-3 fw-bold"
               style="background-color: var(--tertiary); color: white; font-size: 12px; padding: 8px 12px;">
                Liên hệ Thủ thư
            </a>
        </div>
    </div>

</aside>

<script>
/* Lecturer Sidebar: exact pathname match for active state */
(function () {
    var curPath = window.location.pathname;
    document.querySelectorAll('aside .sidebar-link').forEach(function(link) {
        var hrefAttr = link.getAttribute('href');
        if (!hrefAttr || hrefAttr.trim() === '' || hrefAttr.trim().startsWith('#')) return;
        var linkPath = link.pathname;
        if (linkPath && (curPath === linkPath || curPath.startsWith(linkPath + '/'))) {
            link.classList.add('active');
        }
    });
})();
</script>
