<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="d-none d-lg-flex flex-column sidebar-layout gap-4 p-4">
    <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-block">
        <p class="fw-bold mb-0 text-primary-custom">Cổng thông tin Thư viện</p>
        <p class="text-on-surface-variant mb-0 text-uppercase small">Nghiệp vụ thủ thư</p>
    </a>

    <div class="flex-grow-1 d-flex flex-column gap-1">
        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 small">Lưu thông tại quầy</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/dashboard"><span class="material-symbols-outlined">dashboard</span><span>Bảng điều khiển</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/desk-dashboard"><span class="material-symbols-outlined">room_service</span><span>Bảng điều khiển quầy</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/desk-checkout"><span class="material-symbols-outlined">output</span><span>Mượn sách</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/desk-checkin"><span class="material-symbols-outlined">assignment_return</span><span>Trả sách</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/cash-payment"><span class="material-symbols-outlined">payments</span><span>Thanh toán tiền phạt</span></a>

        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3 small">Quản lý sách</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/book-overview.jsp"><span class="material-symbols-outlined">space_dashboard</span><span>Tổng quan</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/titles"><span class="material-symbols-outlined">menu_book</span><span>Đầu sách</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/categories"><span class="material-symbols-outlined">category</span><span>Thể loại</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/tags"><span class="material-symbols-outlined">sell</span><span>Tag sách</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/copies"><span class="material-symbols-outlined">inventory_2</span><span>Tất cả bản sao</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/incidents"><span class="material-symbols-outlined">report</span><span>Hỏng và mất</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/inventory"><span class="material-symbols-outlined">fact_check</span><span>Đối chiếu tồn kho</span></a>
        <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'LIBRARIAN' or sessionScope.role == 'admin' or sessionScope.role == 'librarian'}">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/import"><span class="material-symbols-outlined">upload_file</span><span>Import dữ liệu</span></a>
        </c:if>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/book-management/import-history"><span class="material-symbols-outlined">history</span><span>Lịch sử xử lý</span></a>

        <p class="text-on-surface-variant fw-bold text-uppercase mb-1 mt-3 small">Tài khoản</p>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/librarian/profile"><span class="material-symbols-outlined">manage_accounts</span><span>Hồ sơ của tôi</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/#contact"><span class="material-symbols-outlined">contact_support</span><span>Trợ giúp</span></a>
    </div>
</aside>
