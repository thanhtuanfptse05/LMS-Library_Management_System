<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Librarian --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column sidebar-layout gap-4 p-4"
       style="height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Cổng thông tin Thư viện</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">Quầy lưu thông</p>
    </a>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.15em;">Lưu thông</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/checkout">
            <span class="material-symbols-outlined">published_with_changes</span><span>Mượn / Trả sách</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">bookmark_add</span><span>Đặt trước</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/cash-payment">
            <span class="material-symbols-outlined">payments</span><span>Thu tiền phạt</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Catalog</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">auto_stories</span><span>Danh mục chính</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">inventory</span><span>Kho vật lý</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">category</span><span>Thể loại</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">sell</span><span>Thẻ</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Người dùng</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">group</span><span>Danh bạ thành viên</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/profile">
            <span class="material-symbols-outlined">manage_accounts</span><span>Hồ sơ của tôi</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span><span>Trợ giúp</span>
        </a>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(249, 115, 22, 0.08); border: 1px solid rgba(249, 115, 22, 0.2);">
        <p class="fw-bold text-primary-custom mb-1 small">Cảnh báo quá hạn</p>
        <p class="text-on-surface-variant mb-2" style="font-size: 11px;">
            3 khoản mượn quá hạn nghiêm trọng. Gửi thông báo phạt.
        </p>
        <a href="#" class="btn btn-primary-custom w-100 btn-sm text-decoration-none d-block text-center rounded-3">
            Gửi thông báo
        </a>
    </div>
</aside>
