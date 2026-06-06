<%-- Fragment: _sidebar.jsp — Left sidebar for Library Manager --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column gap-4 p-4"
       style="width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Cổng thông tin Thư viện</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">Quản lý Điều hành</p>
    </a>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.15em;">Tổng quan</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/manager/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">bar_chart</span><span>Phân tích</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">summarize</span><span>Báo cáo</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Vận hành</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">people</span><span>Quản lý Nhân viên</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">policy</span><span>Chính sách Thư viện</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">campaign</span><span>Thông báo hệ thống</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">notifications</span><span>Lịch sử Thông báo</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">inventory_2</span><span>Nhập sách</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/manager/profile">
            <span class="material-symbols-outlined">manage_accounts</span><span>Hồ sơ của tôi</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">help</span><span>Trợ giúp</span>
        </a>
    </div>

    <!-- Period selector -->
    <div class="mt-auto p-3 rounded-3" style="background-color: var(--surface-container-high); border: 1px solid var(--outline-variant);">
        <p class="fw-bold mb-2 text-on-surface-variant" style="font-size: 11px;">Kỳ Báo cáo</p>
        <select class="form-select form-select-sm rounded-3" style="border: 1px solid var(--outline-variant); color: var(--on-surface);" aria-label="Chọn kỳ báo cáo">
            <option selected>Tháng này</option>
            <option>Tháng trước</option>
            <option>Quý này</option>
            <option>Năm nay</option>
        </select>
    </div>
</aside>
