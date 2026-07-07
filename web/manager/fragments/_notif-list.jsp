<%-- Fragment: _notif-list.jsp — Danh sách thông báo + Toolbar tìm kiếm/lọc + Phân trang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-12 col-xl-8">
    <div class="raised-card overflow-hidden">

        <%-- Toolbar: tìm kiếm & lọc --%>
        <div class="p-3 d-flex flex-wrap gap-2 align-items-center justify-content-between"
             style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
            <form method="get" action="${pageContext.request.contextPath}/manager/notifications"
                  class="d-flex flex-wrap gap-2 flex-grow-1">
                <div class="input-group" style="width: 260px; flex-shrink: 0;">
                    <span class="input-group-text bg-white border-end-0 rounded-start-3"
                          style="border-color: var(--outline-variant);">
                        <span class="material-symbols-outlined" style="font-size: 18px; color: var(--on-surface-variant);">search</span>
                    </span>
                    <input type="text" name="keyword" class="form-control border-start-0 rounded-end-3"
                           value="${keyword}" placeholder="Tìm theo tiêu đề..."
                           style="border-color: var(--outline-variant);">
                </div>
                <select name="typeFilter" class="form-select rounded-3"
                        style="width: 180px; border-color: var(--outline-variant);">
                    <option value="">Tất cả loại</option>
                    <option value="general" ${typeFilter == 'general' ? 'selected' : ''}>📢 Chung</option>
                    <option value="urgent"  ${typeFilter == 'urgent'  ? 'selected' : ''}>🔴 Khẩn cấp</option>
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

        <%-- Danh sách --%>
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

                            <%-- Icon type --%>
                            <div class="notif-type-icon flex-shrink-0
                                        ${notif.type == 'urgent'  ? 'icon-urgent'  :
                                          notif.type == 'event'   ? 'icon-event'   : 'icon-general'}">
                                <span class="material-symbols-outlined"
                                      style="font-variation-settings: 'FILL' 1; font-size: 20px;">
                                    ${notif.type == 'urgent'  ? 'error'         :
                                      notif.type == 'event'   ? 'celebration'   : 'campaign'}
                                </span>
                            </div>

                            <%-- Content --%>
                            <div class="flex-grow-1 min-w-0">
                                <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                                    <c:if test="${notif.pinned}">
                                        <span class="material-symbols-outlined"
                                              style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;"
                                              title="Đã ghim">push_pin</span>
                                    </c:if>
                                    <span class="notif-badge-type type-${notif.type}">
                                        ${notif.type == 'urgent'  ? 'Khẩn cấp'        :
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
                                <%-- Hidden full content for modal --%>
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
                                        <span class="d-flex align-items-center gap-1" style="font-style: italic;">
                                            <span class="material-symbols-outlined" style="font-size: 14px;">edit</span>
                                            <fmt:formatDate value="${notif.updatedAt}" pattern="dd/MM HH:mm" />
                                        </span>
                                    </c:if>
                                    <%-- Badge đối tượng nhận --%>
                                    <c:choose>
                                        <c:when test="${notif.targetRole == 'STUDENT'}">
                                            <span class="target-badge target-student">
                                                <span class="material-symbols-outlined" style="font-size: 11px;">school</span> Sinh viên
                                            </span>
                                        </c:when>
                                        <c:when test="${notif.targetRole == 'LECTURER'}">
                                            <span class="target-badge target-lecturer">
                                                <span class="material-symbols-outlined" style="font-size: 11px;">cast_for_education</span> Giảng viên
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="target-badge target-all">
                                                <span class="material-symbols-outlined" style="font-size: 11px;">groups</span> Tất cả
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <%-- Actions --%>
                            <div class="d-flex align-items-center gap-1 flex-shrink-0">
                                <a href="${pageContext.request.contextPath}/manager/notifications?action=edit&notificationId=${notif.notificationId}"
                                   class="btn-icon rounded-2" title="Chỉnh sửa thông báo">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                </a>
                                <form method="post" action="${pageContext.request.contextPath}/manager/notifications"
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

                <%-- Phân trang --%>
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
