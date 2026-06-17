<%-- Fragment: _header.jsp — Fixed top navigation bar for Library Manager --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- ════════════════ HEADER ════════════════ -->
<header class="lms-header header-layout" style="overflow: visible;">

    <!-- Left: Title -->
    <div class="d-flex align-items-center gap-3 flex-grow-1 text-nowrap overflow-hidden me-3">
        <h1 class="mb-0 fw-bold text-primary-custom d-none d-md-block" style="font-size: 16px; white-space: nowrap;">
            <span class="material-symbols-outlined me-1" style="font-size: 18px; font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">bar_chart</span>
            Bảng Phân tích Quản lý
        </h1>
    </div>

    <!-- Right: Search + Notifications + User -->
    <div class="d-flex align-items-center gap-2 flex-shrink-0">
        <div class="d-none d-md-block header-search-wrapper">
            <span class="material-symbols-outlined">search</span>
            <input class="header-search-input" placeholder="Tìm kiếm báo cáo..." type="text" aria-label="Tìm kiếm báo cáo" />
        </div>

        <!-- Right: User Profile Menu -->
        <div class="user-profile-menu dropdown ms-2">
