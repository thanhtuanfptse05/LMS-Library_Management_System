<%-- Fragment: _sidebar.jsp — Left sidebar navigation for Lecturer --%>
<!-- ════════════════ SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column sidebar-layout gap-4 p-4"
       style="height: 100vh; position: fixed; left: 0; top: 0;
              background-color: var(--surface-container-low);
              border-right: 1px solid var(--outline-variant); overflow-y: auto; z-index: 60;">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom" style="font-size: 18px; line-height: 1.2;">Cổng thông tin Thư viện</p>
        <p class="text-on-surface-variant mb-0" style="font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase;">Truy cập Giảng viên</p>
    </a>

    <!-- Navigation -->
    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.15em;">Không gian làm việc</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/dashboard">
            <span class="material-symbols-outlined">dashboard</span><span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">library_books</span><span>Sách tôi mượn</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">payments</span><span>Tiền phạt &amp; Thanh toán</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">bookmark</span><span>Danh sách đã lưu</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">notifications</span>
            <span>Thông báo</span>
            <span style="margin-left: auto; min-width: 18px; height: 18px; border-radius: 999px;
                         background-color: var(--tertiary, #006398); color: #fff;
                         font-size: 10px; font-weight: 700;
                         display: inline-flex; align-items: center; justify-content: center; padding: 0 5px;">4</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Tài nguyên học tập</p>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">menu_book</span><span>Sách theo môn học</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">article</span><span>Danh mục tài liệu đọc</span>
        </a>
        <a class="sidebar-link" href="#">
            <span class="material-symbols-outlined">science</span><span>Tài liệu nghiên cứu</span>
        </a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3" style="font-size: 10px; letter-spacing: 0.15em;">Thư viện</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-search">
            <span class="material-symbols-outlined">search</span><span>Tra cứu Mục lục</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/lecturer/profile">
            <span class="material-symbols-outlined">manage_accounts</span><span>Hồ sơ của tôi</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span><span>Trợ giúp</span>
        </a>
    </div>

    <!-- Assistance Box -->
    <div class="mt-auto p-3 rounded-3"
         style="background-color: rgba(0, 99, 152, 0.08); border: 1px solid rgba(0, 99, 152, 0.2);">
         <p class="fw-bold mb-1" style="color: var(--tertiary); font-size: 11px;">Hỗ trợ Nghiên cứu</p>
         <p class="text-on-surface-variant mb-2" style="font-size: 11px;">
             Cần một tạp chí hay cơ sở dữ liệu cụ thể? Liên hệ thủ thư nghiên cứu của chúng tôi.
         </p>
         <a href="${pageContext.request.contextPath}/#contact"
            class="btn w-100 btn-sm text-decoration-none d-block text-center rounded-3 fw-bold"
            style="background-color: var(--tertiary); color: white;">
             Liên hệ Thủ thư
         </a>
    </div>
</aside>
