<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="d-none d-lg-flex flex-column sidebar-layout gap-4 p-4">
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom">Cổng thông tin Thư viện</p>
        <p class="text-on-surface-variant mb-0 text-uppercase small">Quầy lưu thông</p>
    </a>

    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 small">Lưu thông</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/dashboard"><span class="material-symbols-outlined">dashboard</span><span>Bảng điều khiển</span></a>
        <a class="sidebar-link" href="#"><span class="material-symbols-outlined">published_with_changes</span><span>Mượn / Trả sách</span></a>
        <a class="sidebar-link" href="#"><span class="material-symbols-outlined">bookmark_add</span><span>Đặt trước</span></a>
        <a class="sidebar-link" href="#"><span class="material-symbols-outlined">payments</span><span>Thu tiền phạt</span></a>

        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3 small">Quản lý sách</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-overview.jsp"><span class="material-symbols-outlined">space_dashboard</span><span>Tổng quan</span></a>
        <p class="bm-sidebar-group mb-0 mt-2">Danh mục sách</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-titles.jsp"><span class="material-symbols-outlined">menu_book</span><span>Đầu sách</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-taxonomy.jsp"><span class="material-symbols-outlined">category</span><span>Thể loại &amp; thẻ</span></a>
        <p class="bm-sidebar-group mb-0 mt-2">Kho vật lý</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-copies.jsp"><span class="material-symbols-outlined">inventory_2</span><span>Tất cả bản sao</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-damaged-lost.jsp"><span class="material-symbols-outlined">report</span><span>Hỏng &amp; mất</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-inventory-reconciliation.jsp"><span class="material-symbols-outlined">fact_check</span><span>Đối chiếu tồn kho</span></a>
        <p class="bm-sidebar-group mb-0 mt-2">Import &amp; lịch sử</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-import.jsp"><span class="material-symbols-outlined">upload_file</span><span>Import dữ liệu</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-import-history.jsp"><span class="material-symbols-outlined">history</span><span>Lịch sử xử lý</span></a>

        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3 small">Người dùng</p>
        <a class="sidebar-link" href="#"><span class="material-symbols-outlined">group</span><span>Danh bạ thành viên</span></a>
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3 small">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/profile"><span class="material-symbols-outlined">manage_accounts</span><span>Hồ sơ của tôi</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact"><span class="material-symbols-outlined">contact_support</span><span>Trợ giúp</span></a>
    </div>

    <div class="bm-sidebar-alert mt-auto p-3 rounded-3">
        <p class="fw-bold text-primary-custom mb-1 small">Cảnh báo quá hạn</p>
        <p class="text-on-surface-variant mb-2 small">3 khoản mượn quá hạn nghiêm trọng cần gửi thông báo.</p>
        <a href="#" class="btn btn-primary-custom w-100 btn-sm text-decoration-none rounded-3">Gửi thông báo</a>
    </div>
</aside>
