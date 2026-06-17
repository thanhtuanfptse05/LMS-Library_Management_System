<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1300px; margin: 0 auto;">

                <!-- ─── Breadcrumb ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted"
                       href="${pageContext.request.contextPath}/manager/dashboard">Bảng điều khiển</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span style="color: var(--on-surface);">Quản lý Bảng tin</span>
                </nav>

                <!-- ─── Page Title ─── -->
                <div class="d-flex justify-content-between align-items-start mb-5 flex-wrap gap-3">
                    <div>
                        <h1 class="fw-bold mb-1" style="font-size: 28px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2 align-middle"
                                  style="font-size: 30px; color: var(--primary); font-variation-settings: 'FILL' 1;">campaign</span>
                            Quản lý Bảng tin
                        </h1>
                        <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-0">
                            Đăng thông báo nội bộ đến toàn bộ Sinh viên và Giảng viên trong hệ thống.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3 d-flex align-items-center gap-2"
                             style="background: linear-gradient(135deg, rgba(157,67,0,0.08), rgba(249,115,22,0.05)); border: 1px solid rgba(157,67,0,0.15);">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 18px;">notifications_active</span>
                            <span class="fw-bold" style="font-size: 22px; color: var(--primary);">${totalCount}</span>
                            <span style="font-size: 12px; color: var(--on-surface-variant);">thông báo</span>
                        </div>
                    </div>
                </div>

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(22,163,74,0.04)); border: 1px solid rgba(22,163,74,0.25); color: #15803d;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #16a34a;">check_circle</span>
                        <span class="fw-semibold"><c:out value="${param.success}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(186,26,26,0.08), rgba(186,26,26,0.04)); border: 1px solid rgba(186,26,26,0.2); color: #93000a;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #ef4444;">error</span>
                        <span class="fw-semibold"><c:out value="${param.error}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <div class="row g-4">

                    <!-- ═══════════════════════════════════════════
                         LEFT: Form đăng / chỉnh sửa thông báo
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-xl-4">

                        <!-- Form tạo mới hoặc chỉnh sửa -->
                        <div class="raised-card p-4 mb-4" id="notifFormCard">

                            <c:choose>
                                <c:when test="${not empty editNotification}">
                                    <!-- Chế độ CHỈNH SỬA -->
                                    <div class="d-flex align-items-center gap-2 mb-4">
                                        <div class="rounded-2 d-flex align-items-center justify-content-center"
                                             style="width: 36px; height: 36px; background: rgba(0,99,152,0.1);">
                                            <span class="material-symbols-outlined"
                                                  style="color: var(--tertiary); font-size: 20px; font-variation-settings: 'FILL' 1;">edit_note</span>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Chỉnh sửa thông báo</h5>
                                            <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">ID #${editNotification.notificationId}</p>
                                        </div>
                                    </div>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/manager/notifications"
                                          id="notifForm">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="notificationId" value="${editNotification.notificationId}">

                                        <div class="mb-3">
                                            <label for="editTitle" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Tiêu đề <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control rounded-3" id="editTitle" name="title"
                                                   value="<c:out value='${editNotification.title}'/>"
                                                   placeholder="Tiêu đề thông báo..." required maxlength="500">
                                        </div>

                                        <div class="mb-3">
                                            <label for="editType" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Phân loại</label>
                                            <select class="form-select rounded-3" id="editType" name="type">
                                                <option value="general" ${editNotification.type == 'general' ? 'selected' : ''}>📢 Thông tin chung</option>
                                                <option value="urgent"  ${editNotification.type == 'urgent'  ? 'selected' : ''}>🔴 Khẩn cấp</option>
                                                <option value="policy"  ${editNotification.type == 'policy'  ? 'selected' : ''}>📋 Nội quy / Chính sách</option>
                                                <option value="event"   ${editNotification.type == 'event'   ? 'selected' : ''}>🎯 Sự kiện / Hoạt động</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="editContent" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Nội dung</label>
                                            <textarea class="form-control rounded-3" id="editContent" name="content"
                                                      rows="6"
                                                      placeholder="Mô tả chi tiết thông báo..."><c:out value="${editNotification.content}"/></textarea>
                                        </div>

                                        <div class="form-check mb-4 d-flex align-items-center gap-2 p-0">
                                            <input class="form-check-input m-0" type="checkbox" id="editPinned"
                                                   name="isPinned" style="width: 18px; height: 18px;"
                                                   ${editNotification.pinned ? 'checked' : ''}>
                                            <label class="form-check-label small fw-semibold ms-2"
                                                   for="editPinned" style="color: var(--on-surface-variant);">
                                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px;">push_pin</span>
                                                Ghim thông báo lên đầu
                                            </label>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                                <span class="material-symbols-outlined me-1 align-middle">save</span>Lưu thay đổi
                                            </button>
                                            <a href="${pageContext.request.contextPath}/manager/notifications"
                                               class="btn rounded-3 py-2"
                                               style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">
                                                Hủy
                                            </a>
                                        </div>
                                    </form>
                                </c:when>

                                <c:otherwise>
                                    <!-- Chế độ TẠO MỚI -->
                                    <div class="d-flex align-items-center gap-2 mb-4">
                                        <div class="rounded-2 d-flex align-items-center justify-content-center"
                                             style="width: 36px; height: 36px; background: linear-gradient(135deg, rgba(157,67,0,0.12), rgba(249,115,22,0.08));">
                                            <span class="material-symbols-outlined"
                                                  style="color: var(--primary); font-size: 20px; font-variation-settings: 'FILL' 1;">campaign</span>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Đăng thông báo mới</h5>
                                            <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">Gửi đến toàn bộ thành viên</p>
                                        </div>
                                    </div>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/manager/notifications"
                                          id="notifForm">
                                        <input type="hidden" name="action" value="create">

                                        <div class="mb-3">
                                            <label for="notifTitle" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Tiêu đề <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control rounded-3" id="notifTitle" name="title"
                                                   placeholder="VD: Thư viện nghỉ lễ 30/4 - 1/5" required maxlength="500">
                                        </div>

                                        <div class="mb-3">
                                            <label for="notifType" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Phân loại</label>
                                            <select class="form-select rounded-3" id="notifType" name="type">
                                                <option value="general">📢 Thông tin chung</option>
                                                <option value="urgent">🔴 Khẩn cấp</option>
                                                <option value="policy">📋 Nội quy / Chính sách</option>
                                                <option value="event">🎯 Sự kiện / Hoạt động</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="notifContent" class="form-label small fw-semibold"
                                                   style="color: var(--on-surface-variant);">Nội dung</label>
                                            <textarea class="form-control rounded-3" id="notifContent" name="content"
                                                      rows="6" placeholder="Mô tả chi tiết nội dung thông báo..."></textarea>
<small class="text-secondary d-block mt-1" style="font-size:12px;"><i class="bi bi-markdown"></i> Hỗ trợ định dạng Markdown (**in đậm**, *in nghiêng*, - danh sách, # tiêu đề)</small>
                                        </div>

                                        <div class="form-check mb-4 d-flex align-items-center gap-2 p-0">
                                            <input class="form-check-input m-0" type="checkbox" id="notifPinned"
                                                   name="isPinned" style="width: 18px; height: 18px;">
                                            <label class="form-check-label small fw-semibold ms-2"
                                                   for="notifPinned" style="color: var(--on-surface-variant);">
                                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px;">push_pin</span>
                                                Ghim thông báo lên đầu
                                            </label>
                                        </div>

                                        <button type="submit" class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">
                                            <span class="material-symbols-outlined me-1 align-middle">send</span>
                                            Đăng lên Bảng tin
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Hướng dẫn phân loại -->
                        <div class="raised-card p-4" style="background: linear-gradient(135deg, var(--surface-container-low), var(--surface-container));">
                            <h6 class="fw-bold mb-3" style="color: var(--on-surface); font-size: 13px; text-transform: uppercase; letter-spacing: 0.05em;">
                                Hướng dẫn phân loại
                            </h6>
                            <div class="d-flex flex-column gap-2" style="font-size: 13px;">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="notif-badge-type type-general" style="flex-shrink:0;">Chung</span>
                                    <span style="color: var(--on-surface-variant);">Lịch hoạt động, thông tin định kỳ</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="notif-badge-type type-urgent" style="flex-shrink:0;">Khẩn</span>
                                    <span style="color: var(--on-surface-variant);">Đóng cửa đột xuất, thay đổi khẩn</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="notif-badge-type type-policy" style="flex-shrink:0;">Nội quy</span>
                                    <span style="color: var(--on-surface-variant);">Quy định mượn trả, nội quy mới</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="notif-badge-type type-event" style="flex-shrink:0;">Sự kiện</span>
                                    <span style="color: var(--on-surface-variant);">Workshop, triển lãm, hoạt động</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ═══════════════════════════════════════════
                         RIGHT: Danh sách thông báo
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-xl-8">
                        <div class="raised-card overflow-hidden">

                            <!-- Toolbar: tìm kiếm & lọc -->
                            <div class="p-3 d-flex flex-wrap gap-2 align-items-center justify-content-between"
                                 style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                <form method="get" action="${pageContext.request.contextPath}/manager/notifications"
                                      class="d-flex flex-wrap gap-2 flex-grow-1">
                                    <!-- Search -->
                                    <div class="input-group" style="width: 260px; flex-shrink: 0;">
                                        <span class="input-group-text bg-white border-end-0 rounded-start-3"
                                              style="border-color: var(--outline-variant);">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: var(--on-surface-variant);">search</span>
                                        </span>
                                        <input type="text" name="keyword" class="form-control border-start-0 rounded-end-3"
                                               value="${keyword}" placeholder="Tìm theo tiêu đề..."
                                               style="border-color: var(--outline-variant);">
                                    </div>
                                    <!-- Type filter -->
                                    <select name="typeFilter" class="form-select rounded-3"
                                            style="width: 180px; border-color: var(--outline-variant);">
                                        <option value="">Tất cả loại</option>
                                        <option value="general" ${typeFilter == 'general' ? 'selected' : ''}>📢 Chung</option>
                                        <option value="urgent"  ${typeFilter == 'urgent'  ? 'selected' : ''}>🔴 Khẩn cấp</option>
                                        <option value="policy"  ${typeFilter == 'policy'  ? 'selected' : ''}>📋 Nội quy</option>
                                        <option value="event"   ${typeFilter == 'event'   ? 'selected' : ''}>🎯 Sự kiện</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary-custom rounded-3 px-3">
                                        <span class="material-symbols-outlined" style="font-size: 18px;">filter_list</span>
                                    </button>
                                    <c:if test="${not empty keyword or not empty typeFilter}">
                                        <a href="${pageContext.request.contextPath}/manager/notifications"
                                           class="btn rounded-3 px-3" style="background: var(--surface-container-high); color: var(--on-surface-variant);">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">close</span>
                                        </a>
                                    </c:if>
                                </form>
                            </div>

                            <!-- Danh sách -->
                            <c:choose>
                                <c:when test="${not empty notifications}">
                                    <div class="d-flex flex-column" id="notifList">
                                        <c:forEach var="notif" items="${notifications}">
                                            <div class="notif-row px-4 py-3 d-flex align-items-start gap-3
                            ${notif.pinned ? 'notif-pinned' : ''}"
                            data-notif-id="${notif.notificationId}"
                            data-title="<c:out value='${notif.title}'/>"
                            data-author="<c:out value='${not empty notif.createdByName ? notif.createdByName : "Quản lý"}'/>"
                            data-time="<fmt:formatDate value='${notif.createdAt}' pattern='dd/MM/yyyy HH:mm' />"
                            data-type="${notif.type}"
                            data-pinned="${notif.pinned}">

                                                <!-- Icon type -->
                                                <div class="notif-type-icon flex-shrink-0
                                                            ${notif.type == 'urgent'  ? 'icon-urgent'  :
                                                              notif.type == 'policy'  ? 'icon-policy'  :
                                                              notif.type == 'event'   ? 'icon-event'   : 'icon-general'}">
                                                    <span class="material-symbols-outlined"
                                                          style="font-variation-settings: 'FILL' 1; font-size: 20px;">
                                                        ${notif.type == 'urgent'  ? 'error'         :
                                                          notif.type == 'policy'  ? 'policy'        :
                                                          notif.type == 'event'   ? 'celebration'   : 'campaign'}
                                                    </span>
                                                </div>

                                                <!-- Content -->
                                                <div class="flex-grow-1 min-w-0">
                                                    <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                                                        <!-- Pin badge -->
                                                        <c:if test="${notif.pinned}">
                                                            <span class="material-symbols-outlined"
                                                                  style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;"
                                                                  title="Đã ghim">push_pin</span>
                                                        </c:if>
                                                        <!-- Type badge -->
                                                        <span class="notif-badge-type type-${notif.type}">
                                                            ${notif.type == 'urgent'  ? 'Khẩn cấp'        :
                                                              notif.type == 'policy'  ? 'Nội quy'          :
                                                              notif.type == 'event'   ? 'Sự kiện'          : 'Chung'}
                                                        </span>
                                                        <h6 class="fw-bold mb-0 text-truncate"
                                                            style="color: var(--on-surface); max-width: 340px;">
                                                            <c:out value="${notif.title}" />
                                                        </h6>
                                                    </div>
                                                    <p class="mb-1 text-truncate notif-content-text"
                                                       style="font-size: 13px; color: var(--on-surface-variant); max-width: 380px; cursor: pointer;"
                                                       onclick="openManagerDetail(this)" title="Nhấn để xem chi tiết">
                                                        <c:out value="${notif.content}" />
                                                    </p>
                                                    <!-- Hidden full content for modal -->
                                                    <div class="d-none notif-full-content">
                                                        <c:out value="${notif.content}" />
                                                    </div>
                                                    <div class="d-flex align-items-center gap-3" style="font-size: 12px; color: var(--on-surface-variant);">
                                                        <span class="d-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined" style="font-size: 14px;">person</span>
                                                            <c:out value="${not empty notif.createdByName ? notif.createdByName : 'Quản lý'}" />
                                                        </span>
                                                        <span class="d-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined" style="font-size: 14px;">schedule</span>
                                                            <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                        <c:if test="${not empty notif.updatedAt}">
                                                            <span class="d-flex align-items-center gap-1"
                                                                  style="font-style: italic;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px;">edit</span>
                                                                <fmt:formatDate value="${notif.updatedAt}" pattern="dd/MM HH:mm" />
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Actions -->
                                                <div class="d-flex align-items-center gap-1 flex-shrink-0">
                                                    <!-- Nút sửa -->
                                                    <a href="${pageContext.request.contextPath}/manager/notifications?action=edit&notificationId=${notif.notificationId}"
                                                       class="btn-icon rounded-2" title="Chỉnh sửa thông báo">
                                                        <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                    </a>
                                                    <!-- Nút xóa -->
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/manager/notifications"
                                                          onsubmit="return confirmDelete(event, '${notif.title}')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="notificationId" value="${notif.notificationId}">
                                                        <button type="submit" class="btn-icon rounded-2"
                                                                style="color: var(--error);" title="Xóa thông báo">
                                                            <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Phân trang -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="d-flex justify-content-between align-items-center px-4 py-3"
                                             style="border-top: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                            <span style="font-size: 13px; color: var(--on-surface-variant);">
                                                Trang <strong>${currentPage}</strong> / ${totalPages}
                                                &nbsp;·&nbsp; ${totalCount} thông báo
                                            </span>
                                            <nav>
                                                <ul class="pagination pagination-sm mb-0 gap-1">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link rounded-2"
                                                               href="${pageContext.request.contextPath}/manager/notifications?page=${currentPage-1}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_left</span>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                            <a class="page-link rounded-2"
                                                               href="${pageContext.request.contextPath}/manager/notifications?page=${p}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                                ${p}
                                                            </a>
                                                        </li>
                                                    </c:forEach>
                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="page-item">
                                                            <a class="page-link rounded-2"
                                                               href="${pageContext.request.contextPath}/manager/notifications?page=${currentPage+1}&keyword=${keyword}&typeFilter=${typeFilter}">
                                                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_right</span>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>
                                </c:when>

                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                             style="width: 80px; height: 80px; background: linear-gradient(135deg, rgba(157,67,0,0.06), rgba(249,115,22,0.04));">
                                            <span class="material-symbols-outlined" style="font-size: 36px; color: var(--primary); font-variation-settings: 'FILL' 1;">notifications_off</span>
                                        </div>
                                        <h5 class="fw-bold mb-1" style="color: var(--on-surface);">Chưa có thông báo nào</h5>
                                        <p style="color: var(--on-surface-variant); font-size: 14px;">
                                            Sử dụng form bên trái để tạo thông báo đầu tiên cho hệ thống.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div><!-- /.row -->

            </div><!-- /.container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <!-- ════════════════ DETAIL MODAL ════════════════ -->
    <div class="modal fade" id="notifDetailModal" tabindex="-1" aria-labelledby="notifDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
            <div class="modal-content border-0 rounded-4 overflow-hidden shadow-lg">
                <!-- Modal Header -->
                <div class="modal-header border-0 px-4 py-3" id="modalHeaderBg" style="background-color: #f7f9fb;">
                    <div class="d-flex align-items-center gap-3 w-100">
                        <div id="modalTypeIcon" class="notif-type-icon icon-general">
                            <span class="material-symbols-outlined" id="modalTypeIconSymbol"
                                  style="font-variation-settings: 'FILL' 1; font-size: 22px;">campaign</span>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span id="modalTypeBadge" class="notif-badge-type type-general">Thông tin</span>
                                <span id="modalPinBadge" class="d-none material-symbols-outlined"
                                      style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;">push_pin</span>
                            </div>
                            <h5 class="modal-title fw-bold" id="notifDetailModalLabel"
                                style="color: #191c1e; font-size: 17px;">Chi tiết thông báo</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                </div>
                <!-- Modal Body -->
                <div class="modal-body px-4 py-3">
                    <div class="d-flex align-items-center gap-3 mb-3 pb-3"
                         style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex align-items-center gap-2 text-secondary small">
                            <span class="material-symbols-outlined" style="font-size: 16px;">person</span>
                            <span id="modalAuthor"></span>
                        </div>
                        <div class="d-flex align-items-center gap-2 text-secondary small">
                            <span class="material-symbols-outlined" style="font-size: 16px;">schedule</span>
                            <span id="modalTime"></span>
                        </div>
                    </div>
                    <div id="modalContent" class="text-secondary"
                         style="line-height: 1.75; font-size: 14.5px;"></div>
                </div>
                <!-- Modal Footer -->
                <div class="modal-footer border-0 px-4 py-3" style="background-color: #fafafa;">
                    <button type="button" class="btn rounded-3 px-4 fw-semibold"
                            style="background: var(--surface-container-high); color: var(--on-surface-variant);"
                            data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ════════════════ Confirm Delete Modal ════════════════ -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 rounded-4 overflow-hidden shadow-lg">
                <div class="modal-body text-center p-4">
                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                         style="width: 64px; height: 64px; background: rgba(239,68,68,0.08);">
                        <span class="material-symbols-outlined" style="font-size: 32px; color: #ef4444; font-variation-settings: 'FILL' 1;">delete_forever</span>
                    </div>
                    <h6 class="fw-bold mb-2" style="color: var(--on-surface);">Xác nhận xóa thông báo?</h6>
                    <p class="small mb-4" style="color: var(--on-surface-variant);" id="deleteModalTitle"></p>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn flex-grow-1 rounded-3"
                                style="background: var(--surface-container-high); color: var(--on-surface-variant);"
                                data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn flex-grow-1 rounded-3 fw-bold"
                                id="confirmDeleteBtn"
                                style="background: #ef4444; color: white;">Xóa</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fix sidebar active link — exact pathname match
        (function() {
            var curPath = window.location.pathname;
            document.querySelectorAll('.sidebar-link').forEach(function(link) {
                if (link.getAttribute('href') === '#') return;
                var linkPath = link.pathname;
                if (linkPath && (curPath === linkPath || curPath.startsWith(linkPath + '/'))) {
                    link.classList.add('active');
                }
            });
        })();

        let pendingDeleteForm = null;

        function confirmDelete(event, title) {
            event.preventDefault();
            pendingDeleteForm = event.target;
            document.getElementById('deleteModalTitle').textContent = '"' + title + '"';
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
            return false;
        }

        document.getElementById('confirmDeleteBtn').addEventListener('click', () => {
            if (pendingDeleteForm) pendingDeleteForm.submit();
        });
    </script>

    <style>
        /* ─── Notification Row ─── */
        .notif-row {
            border-bottom: 1px solid var(--outline-variant);
            transition: background-color 0.2s ease;
        }
        .notif-row:last-child { border-bottom: none; }
        .notif-row:hover { background-color: var(--surface-container-low); }
        .notif-pinned {
            background: linear-gradient(90deg, rgba(157,67,0,0.04), transparent);
        }
        .notif-pinned:hover {
            background: linear-gradient(90deg, rgba(157,67,0,0.08), var(--surface-container-low));
        }

        /* ─── Type Icon ─── */
        .notif-type-icon {
            width: 42px; height: 42px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .icon-general { background: rgba(0,99,152,0.10); color: var(--tertiary); }
        .icon-urgent  { background: rgba(239,68,68,0.10); color: #ef4444; }
        .icon-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
        .icon-event   { background: rgba(22,163,74,0.10); color: var(--success); }

        /* ─── Type Badges ─── */
        .notif-badge-type {
            display: inline-flex; align-items: center;
            padding: 2px 10px; border-radius: 999px;
            font-size: 11px; font-weight: 700; letter-spacing: 0.04em;
            white-space: nowrap;
        }
        .type-general { background: rgba(0,99,152,0.10);  color: var(--tertiary); }
        .type-urgent  { background: rgba(239,68,68,0.12); color: #dc2626; }
        .type-policy  { background: rgba(157,67,0,0.10);  color: var(--primary); }
        .type-event   { background: rgba(22,163,74,0.10); color: #15803d; }

        /* ─── Pagination ─── */
        .page-link {
            border-color: var(--outline-variant);
            color: var(--on-surface-variant);
            font-size: 13px;
            padding: 4px 10px;
        }
        .page-item.active .page-link {
            background-color: var(--primary);
            border-color: var(--primary);
            color: white;
        }
        .page-link:hover { background-color: var(--surface-container-high); color: var(--primary); }

        /* ─── Modal Markdown Rendering ─── */
        #modalContent { color: #333; }
        #modalContent p { margin-bottom: 1rem; }
        #modalContent ul, #modalContent ol { padding-left: 1.5rem; margin-bottom: 1rem; }
        #modalContent li { margin-bottom: 0.5rem; }
        #modalContent h1, #modalContent h2, #modalContent h3, #modalContent h4 { color: #191c1e; margin-top: 1.5rem; margin-bottom: 1rem; font-weight: bold; }
        #modalContent blockquote { border-left: 4px solid #e5e5e5; padding-left: 1rem; color: #555; font-style: italic; }
        #modalContent img { max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 1rem; }
        #modalContent a { color: var(--primary); text-decoration: none; }
        #modalContent a:hover { text-decoration: underline; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            if (typeof marked !== 'undefined') {
                document.querySelectorAll('.notif-content-text').forEach(el => {
                    let rawText = el.textContent || '';
                    let tempDiv = document.createElement('div');
                    tempDiv.innerHTML = marked.parse(rawText);
                    let plainText = tempDiv.textContent || tempDiv.innerText || "";
                    el.textContent = plainText.replace(/\s+/g, ' ').trim();
                });
            }
        });

const typeIconMap = {
            urgent:  { symbol: 'error',       cls: 'icon-urgent',  badgeCls: 'type-urgent',  label: 'Khẩn cấp' },
            policy:  { symbol: 'policy',      cls: 'icon-policy',  badgeCls: 'type-policy',  label: 'Nội quy' },
            event:   { symbol: 'celebration', cls: 'icon-event',   badgeCls: 'type-event',   label: 'Sự kiện' },
            general: { symbol: 'campaign',    cls: 'icon-general', badgeCls: 'type-general', label: 'Thông tin' }
        };

        function openManagerDetail(btn) {
            const row = btn.closest('.notif-row');
            if (!row) return;

            const title    = row.getAttribute('data-title');
            const author   = row.getAttribute('data-author');
            const time     = row.getAttribute('data-time');
            const type     = row.getAttribute('data-type') || 'general';
            const isPinned = row.getAttribute('data-pinned') === 'true';
            const notifId  = row.getAttribute('data-notif-id');
            const content  = row.querySelector('.notif-full-content').textContent.trim();

            const meta = typeIconMap[type] || typeIconMap.general;

            document.getElementById('notifDetailModalLabel').textContent = title;
            document.getElementById('modalContent').innerHTML = marked.parse(content);
            document.getElementById('modalTime').textContent = time;
            document.getElementById('modalAuthor').textContent = author;

            const iconEl = document.getElementById('modalTypeIcon');
            iconEl.className = 'notif-type-icon ' + meta.cls;
            document.getElementById('modalTypeIconSymbol').textContent = meta.symbol;

            const badgeModalEl = document.getElementById('modalTypeBadge');
            badgeModalEl.className = 'notif-badge-type ' + meta.badgeCls;
            badgeModalEl.textContent = meta.label;

            const pinEl = document.getElementById('modalPinBadge');
            isPinned ? pinEl.classList.remove('d-none') : pinEl.classList.add('d-none');

            new bootstrap.Modal(document.getElementById('notifDetailModal')).show();

            // ── Mark as read: gọi API nếu chưa đọc ──
            if (notifId && !row.classList.contains('notif-read')) {
                fetch('${pageContext.request.contextPath}/notification/read-status', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'notificationId=' + encodeURIComponent(notifId)
                })
                .then(function(res) {
                    if (res.ok) {
                        row.classList.add('notif-read');
                        // Giảm badge unread trên header
                        var badge = document.getElementById('headerUnreadBadge');
                        if (badge) {
                            var count = parseInt(badge.textContent, 10);
                            if (!isNaN(count) && count > 1) {
                                badge.textContent = count - 1;
                            } else {
                                badge.remove();
                            }
                        }
                    }
                })
                .catch(function() { /* silent fail — không block UI */ });
            }
        }

    </script>
</body>
</html>
