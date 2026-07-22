<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="currentRolePath" value="${fn:toLowerCase(sessionScope.role)}" />
<!-- ════════════════ DESKTOP SIDEBAR ════════════════ -->
<aside class="d-none d-lg-flex flex-column lms-sidebar sidebar-layout">

    <!-- ── Brand ── -->
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <span class="material-symbols-outlined">local_library</span>
        </div>
        <div class="sidebar-brand-text">
            <p class="sidebar-brand-name">LMS Thư viện</p>
            <p class="sidebar-brand-role">Nghiệp vụ Thủ thư</p>
        </div>
    </a>

    <!-- ── Nav ── -->
    <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Librarian navigation">

        <!-- Lưu thông tại quầy -->
        <p class="sidebar-section-label">Lưu thông tại quầy</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/desk-dashboard">
            <span class="material-symbols-outlined">room_service</span>
            <span>Bảng điều khiển quầy</span>
        </a>

        <!-- Quản lý sách -->
        <p class="sidebar-section-label">Quản lý sách</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/overview">
            <span class="material-symbols-outlined">space_dashboard</span>
            <span>Tổng quan</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/titles">
            <span class="material-symbols-outlined">menu_book</span>
            <span>Đầu sách</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/categories">
            <span class="material-symbols-outlined">category</span>
            <span>Thể loại</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/tags">
            <span class="material-symbols-outlined">sell</span>
            <span>Nhãn sách</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-suggestions">
            <span class="material-symbols-outlined">approval_delegation</span>
            <span>Đề xuất sách</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/copies">
            <span class="material-symbols-outlined">inventory_2</span>
            <span>Tất cả bản sao</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/incidents">
            <span class="material-symbols-outlined">report</span>
            <span>Hỏng và mất</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/inventory">
            <span class="material-symbols-outlined">fact_check</span>
            <span>Đối chiếu tồn kho</span>
        </a>
        <c:if test="${sessionScope.role == 'LIBRARIAN' or sessionScope.role == 'librarian'}">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/import">
                <span class="material-symbols-outlined">upload_file</span>
                <span>Nhập dữ liệu</span>
            </a>
        </c:if>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/import-history">
            <span class="material-symbols-outlined">history</span>
            <span>Lịch sử xử lý</span>
        </a>

        <!-- Tài khoản -->
        <p class="sidebar-section-label">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/profile">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Hồ sơ của tôi</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
            <span class="material-symbols-outlined">contact_support</span>
            <span>Trợ giúp</span>
        </a>

    </nav>

    <!-- ── Footer ── -->
    <div class="px-3 pb-3">
        <div class="sidebar-status-card">
            <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">monitor_heart</span>
                Trạng thái Hệ thống
            </p>
            <div class="d-flex align-items-center gap-2">
                <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                      style="width: 8px; height: 8px; background: #10b981;"></span>
                <span style="font-size: 12px; color: var(--on-surface-variant);">Hệ thống hoạt động bình thường</span>
            </div>
        </div>
    </div>

</aside>

<!-- ════════════════ MOBILE OFFCANVAS SIDEBAR ════════════════ -->
<div class="offcanvas offcanvas-start lms-sidebar d-lg-none" tabindex="-1" id="librarianSidebarOffcanvas" aria-labelledby="librarianSidebarOffcanvasLabel" style="width: 280px;">
    <div class="offcanvas-header sidebar-brand border-bottom py-3">
        <div class="d-flex align-items-center gap-2">
            <div class="sidebar-brand-icon">
                <span class="material-symbols-outlined">local_library</span>
            </div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-name m-0">LMS Thư viện</p>
                <p class="sidebar-brand-role m-0">Nghiệp vụ Thủ thư</p>
            </div>
        </div>
        <button type="button" class="btn-close text-reset ms-auto" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
    </div>
    <div class="offcanvas-body p-0 d-flex flex-column">
        <nav class="flex-grow-1 px-3 py-2 d-flex flex-column" aria-label="Librarian mobile navigation">
            <p class="sidebar-section-label">Lưu thông tại quầy</p>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Bảng điều khiển</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/desk-dashboard">
                <span class="material-symbols-outlined">room_service</span>
                <span>Bảng điều khiển quầy</span>
            </a>

            <p class="sidebar-section-label">Quản lý sách</p>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/overview">
                <span class="material-symbols-outlined">space_dashboard</span>
                <span>Tổng quan</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/titles">
                <span class="material-symbols-outlined">menu_book</span>
                <span>Đầu sách</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/categories">
                <span class="material-symbols-outlined">category</span>
                <span>Thể loại</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/tags">
                <span class="material-symbols-outlined">sell</span>
                <span>Nhãn sách</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-suggestions">
                <span class="material-symbols-outlined">approval_delegation</span>
                <span>Đề xuất sách</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/copies">
                <span class="material-symbols-outlined">inventory_2</span>
                <span>Tất cả bản sao</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/incidents">
                <span class="material-symbols-outlined">report</span>
                <span>Hỏng và mất</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/inventory">
                <span class="material-symbols-outlined">fact_check</span>
                <span>Đối chiếu tồn kho</span>
            </a>
            <c:if test="${sessionScope.role == 'LIBRARIAN' or sessionScope.role == 'librarian'}">
                <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/import">
                    <span class="material-symbols-outlined">upload_file</span>
                    <span>Nhập dữ liệu</span>
                </a>
            </c:if>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-management/import-history">
                <span class="material-symbols-outlined">history</span>
                <span>Lịch sử xử lý</span>
            </a>

            <p class="sidebar-section-label">Tài khoản</p>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/profile">
                <span class="material-symbols-outlined">manage_accounts</span>
                <span>Hồ sơ của tôi</span>
            </a>
            <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact">
                <span class="material-symbols-outlined">contact_support</span>
                <span>Trợ giúp</span>
            </a>
        </nav>
        <div class="px-3 pb-3">
            <div class="sidebar-status-card">
                <p class="fw-bold mb-2 text-primary-custom" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em;">
                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">monitor_heart</span>
                    Trạng thái Hệ thống
                </p>
                <div class="d-flex align-items-center gap-2">
                    <span class="animate-pulse rounded-circle d-inline-block flex-shrink-0"
                          style="width: 8px; height: 8px; background: #10b981;"></span>
                    <span style="font-size: 12px; color: var(--on-surface-variant);">Hệ thống hoạt động bình thường</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/* Librarian Sidebar: exact pathname match for active state */
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
