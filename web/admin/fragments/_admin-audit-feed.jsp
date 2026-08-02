<%-- Fragment: _admin-audit-feed.jsp — Luồng nhật ký bảo mật Audit (Real-time Feed dạng danh sách tối giản) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="col-12 col-lg-4">
    <div class="card border-0 shadow-sm rounded-4" style="background: var(--surface);">
        <!-- Card Header -->
        <div class="card-header bg-transparent border-0 p-3 pb-2 d-flex align-items-center justify-content-between">
            <div>
                <h3 class="mb-0 fw-bold" style="font-size: 16px; color: var(--on-surface);">Bảo mật Audit</h3>
                <p class="mb-0 text-on-surface-variant" style="font-size: 12px;">5 hoạt động gần nhất</p>
            </div>
            <span class="badge rounded-pill bg-success-subtle text-success border border-success-subtle" style="font-size: 11px; padding: 4px 8px;">
                <span class="material-symbols-outlined align-middle" style="font-size: 13px;">signal_cellular_alt</span> Trực tiếp
            </span>
        </div>

        <!-- Clean List View -->
        <div class="card-body p-3 pt-1">
            <ul class="list-group list-group-flush border-0">
                <c:choose>
                    <c:when test="${not empty auditLogs}">
                        <c:forEach var="log" items="${auditLogs}" varStatus="status" end="4">
                            <c:set var="badgeClass" value="bg-secondary-subtle text-secondary" />
                            <c:set var="iconName" value="info" />
                            <c:set var="iconColor" value="#64748b" />
                            <c:choose>
                                <c:when test="${fn:contains(log.actionType, 'DELETE') || fn:contains(log.actionType, 'CANCEL')}">
                                    <c:set var="badgeClass" value="bg-danger-subtle text-danger border-danger-subtle" />
                                    <c:set var="iconName" value="delete" />
                                    <c:set var="iconColor" value="#dc2626" />
                                </c:when>
                                <c:when test="${fn:contains(log.actionType, 'LOCK') || fn:contains(log.actionType, 'INCIDENT')}">
                                    <c:set var="badgeClass" value="bg-warning-subtle text-warning-emphasis border-warning-subtle" />
                                    <c:set var="iconName" value="warning" />
                                    <c:set var="iconColor" value="#d97706" />
                                </c:when>
                                <c:when test="${fn:contains(log.actionType, 'CREATE') || fn:contains(log.actionType, 'UNLOCK')}">
                                    <c:set var="badgeClass" value="bg-success-subtle text-success border-success-subtle" />
                                    <c:set var="iconName" value="add_circle" />
                                    <c:set var="iconColor" value="#16a34a" />
                                </c:when>
                                <c:when test="${fn:contains(log.actionType, 'UPDATE') || fn:contains(log.actionType, 'CHECK')}">
                                    <c:set var="badgeClass" value="bg-primary-subtle text-primary border-primary-subtle" />
                                    <c:set var="iconName" value="edit_note" />
                                    <c:set var="iconColor" value="#2563eb" />
                                </c:when>
                            </c:choose>

                            <li class="list-group-item bg-transparent border-bottom py-2.5 px-0">
                                <!-- Dòng 1: Icon + Tên hành động + Giờ -->
                                <div class="d-flex align-items-center justify-content-between gap-2 mb-1">
                                    <div class="d-flex align-items-center gap-2 min-w-0">
                                        <span class="material-symbols-outlined flex-shrink-0" style="font-size: 18px; color: ${iconColor};">${iconName}</span>
                                        <span class="fw-bold text-truncate" style="font-size: 13px; color: var(--on-surface);" title="${fn:escapeXml(log.actionType)}">
                                            <c:choose>
                                                <c:when test="${log.actionType == 'LOCK_USER'}">Khóa tài khoản</c:when>
                                                <c:when test="${log.actionType == 'UNLOCK_USER'}">Mở khóa tài khoản</c:when>
                                                <c:when test="${log.actionType == 'CREATE_USER'}">Tạo tài khoản</c:when>
                                                <c:when test="${log.actionType == 'UPDATE_USER'}">Cập nhật tài khoản</c:when>
                                                <c:when test="${log.actionType == 'IMPORT_USERS'}">Nhập tài khoản</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'CONFIG')}">Cập nhật cấu hình</c:when>
                                                <c:when test="${log.actionType == 'CHECK_OUT'}">Cho mượn sách</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'CHECK_IN')}">Nhận trả sách</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'PAYMENT')}">Thanh toán tiền phạt</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'RESERVATION')}">Xử lý đặt trước</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'PASSWORD')}">Đổi mật khẩu</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'INCIDENT')}">Xử lý sự cố</c:when>
                                                <c:when test="${fn:contains(log.actionType, 'BOOK')}">Quản lý sách</c:when>
                                                <c:otherwise><c:out value="${log.actionType}" /></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <span class="text-muted flex-shrink-0" style="font-size: 11px;">
                                        <fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" />
                                    </span>
                                </div>
                                <!-- Dòng 2: Email người thực hiện + Badge Đối tượng -->
                                <div class="d-flex align-items-center justify-content-between text-muted" style="font-size: 11.5px; padding-left: 26px;">
                                    <span class="text-truncate" style="max-width: 170px;">
                                        <c:out value="${not empty log.userEmail ? log.userEmail : 'Hệ thống'}" />
                                    </span>
                                    <c:if test="${not empty log.entityName}">
                                        <span class="badge border ${badgeClass}" style="font-size: 10px; font-weight: 500; padding: 2px 6px;">
                                            <c:out value="${log.entityName}" /> ${log.entityId != null ? '#'.concat(log.entityId) : ''}
                                        </span>
                                    </c:if>
                                </div>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li class="list-group-item bg-transparent text-center py-4 text-muted border-0" style="font-size: 13px;">
                            <span class="material-symbols-outlined d-block mx-auto mb-1" style="font-size: 32px; color: var(--outline-variant);">history</span>
                            Chưa có nhật ký hoạt động nào
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <!-- Card Footer -->
        <div class="card-footer bg-transparent border-top-0 p-3 pt-1 text-center">
            <a href="${pageContext.request.contextPath}/admin/audit-log"
               class="btn btn-sm btn-light w-100 fw-semibold text-secondary"
               style="border-radius: 8px; font-size: 12.5px;">
                Xem tất cả Nhật ký &rarr;
            </a>
        </div>
    </div>
</div>
