<%-- Fragment: _admin-audit-feed.jsp — Luồng nhật ký bảo mật Audit (Real-time Feed) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="col-12 col-lg-4">
    <div class="raised-card d-flex flex-column" style="height: 720px; position: sticky; top: 80px;">
        <div class="card-header-row">
            <div>
                <h3 class="card-title">Bảo mật Audit</h3>
                <p class="card-subtitle">Luồng nhật ký giám sát trực tiếp</p>
            </div>
            <div class="position-relative">
                <span class="animate-pulse position-absolute rounded-circle"
                      style="width: 10px; height: 10px; background: var(--error); border: 2px solid white; top: -4px; right: -4px;"></span>
                <span class="material-symbols-outlined text-on-surface-variant">stream</span>
            </div>
        </div>
        <div class="flex-grow-1 p-3 d-flex flex-column gap-3 custom-scrollbar" style="overflow-y: auto;">
            <c:choose>
                <c:when test="${not empty auditLogs}">
                    <c:forEach var="log" items="${auditLogs}">
                        <c:set var="itemColor" value="var(--primary)" />
                        <c:set var="itemIcon" value="info" />
                        <c:choose>
                            <c:when test="${fn:contains(log.actionType, 'DELETE') || fn:contains(log.actionType, 'REMOVE') || fn:contains(log.actionType, 'CANCEL')}">
                                <c:set var="itemColor" value="var(--outline)" />
                                <c:set var="itemIcon" value="delete" />
                            </c:when>
                            <c:when test="${fn:contains(log.actionType, 'LOCK') || fn:contains(log.actionType, 'FAIL') || fn:contains(log.actionType, 'ERROR') || fn:contains(log.actionType, 'REJECT') || fn:contains(log.actionType, 'SUSPEND')}">
                                <c:set var="itemColor" value="var(--error)" />
                                <c:set var="itemIcon" value="gpp_bad" />
                            </c:when>
                            <c:when test="${fn:contains(log.actionType, 'UNLOCK')}">
                                <c:set var="itemColor" value="var(--success)" />
                                <c:set var="itemIcon" value="lock_open" />
                            </c:when>
                            <c:when test="${fn:contains(log.actionType, 'CREATE') || fn:contains(log.actionType, 'INSERT') || fn:contains(log.actionType, 'IMPORT')}">
                                <c:set var="itemColor" value="var(--success)" />
                                <c:set var="itemIcon" value="add_circle" />
                            </c:when>
                            <c:when test="${fn:contains(log.actionType, 'UPDATE') || fn:contains(log.actionType, 'EDIT') || fn:contains(log.actionType, 'PASSWORD')}">
                                <c:set var="itemColor" value="var(--warning)" />
                                <c:set var="itemIcon" value="${log.entityName == 'SystemConfigurations' || log.entityName == 'SystemConfig' ? 'settings' : 'edit'}" />
                            </c:when>
                        </c:choose>
                        <div class="audit-item" style="border-left-color: ${itemColor};">
                            <div class="audit-dot" style="background-color: ${itemColor};"></div>
                            <div class="d-flex justify-content-between align-items-start">
                                <p class="fw-bold mb-0 d-flex align-items-center gap-1" style="font-size: 13px;">
                                    <span class="material-symbols-outlined" style="font-size: 16px; color: ${itemColor};">${itemIcon}</span>
                                    <c:choose>
                                        <c:when test="${log.actionType == 'LOCK_USER'}">Khóa tài khoản</c:when>
                                        <c:when test="${log.actionType == 'UNLOCK_USER'}">Mở khóa tài khoản</c:when>
                                        <c:when test="${log.actionType == 'CREATE_USER'}">Tạo tài khoản</c:when>
                                        <c:when test="${log.actionType == 'UPDATE_USER'}">Cập nhật tài khoản</c:when>
                                        <c:when test="${log.actionType == 'IMPORT_USERS'}">Nhập tài khoản hàng loạt</c:when>
                                        <c:when test="${log.actionType == 'CREATE_SYSTEM_CONFIG' || log.actionType == 'UPDATE_SYSTEM_CONFIG'}">Cập nhật cấu hình</c:when>
                                        <c:when test="${log.actionType == 'CHECK_OUT'}">Cho mượn sách</c:when>
                                        <c:when test="${fn:contains(log.actionType, 'CHECK_IN')}">Nhận trả sách</c:when>
                                        <c:when test="${log.actionType == 'CASH_PAYMENT'}">Thanh toán tiền phạt</c:when>
                                        <c:when test="${log.actionType == 'CANCEL_EXPIRED_RESERVATION'}">Hủy đặt trước quá hạn</c:when>
                                        <c:when test="${log.actionType == 'CHANGE_PASSWORD'}">Thay đổi mật khẩu</c:when>
                                        <c:otherwise><c:out value="${log.actionType}" /></c:otherwise>
                                    </c:choose>
                                    <span style="font-weight: 500; font-size: 11px; color: var(--on-surface-variant);">(<c:out value="${log.entityName}" />)</span>
                                </p>
                                <span class="text-on-surface-variant" style="font-size: 11px;">
                                    <fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" />
                                </span>
                            </div>
                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                                Người dùng: <span style="color: var(--on-surface); font-weight: 600;"><c:out value="${not empty log.userEmail ? log.userEmail : 'Hệ thống'}" /></span>
                            </p>
                            <div class="p-2 rounded-2"
                                 style="background-color: var(--surface-container-low); font-size: 11.5px; color: var(--on-surface-variant); line-height: 1.5; word-break: break-all;">
                                <c:choose>
                                    <c:when test="${log.actionType == 'LOCK_USER'}">Trạng thái: Khóa tài khoản</c:when>
                                    <c:when test="${log.actionType == 'UNLOCK_USER'}">Trạng thái: Mở khóa hoạt động</c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty log.friendlyOldValues}">
                                            <div>Cũ: <c:out value="${log.friendlyOldValues}" /></div>
                                        </c:if>
                                        <c:if test="${not empty log.friendlyNewValues}">
                                            <div>Mới: <c:out value="${log.friendlyNewValues}" /></div>
                                        </c:if>
                                        <c:if test="${empty log.oldValues && empty log.newValues}">
                                            ID Thực thể: <c:out value="${log.entityId}" />
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- Placeholder khi chưa có audit logs --%>
                    <div class="audit-item" style="border-left-color: var(--primary);">
                        <div class="audit-dot" style="background-color: var(--primary);"></div>
                        <div class="d-flex justify-content-between align-items-start">
                            <p class="fw-bold mb-0" style="font-size: 13px;">Cập nhật cấu hình</p>
                            <span class="text-on-surface-variant" style="font-size: 11px;">14:22:01</span>
                        </div>
                        <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                            Người dùng: <span style="color: var(--on-surface); font-weight: 600;">admin_maria</span>
                        </p>
                        <div class="p-2 rounded-2"
                             style="background-color: var(--surface-container-low); font-family: monospace; font-size: 11px; color: var(--on-surface-variant);">
                            PENALTY_RATE: 0.25 &rarr; 0.50
                        </div>
                    </div>
                    <div class="audit-item" style="border-left-color: var(--error);">
                        <div class="audit-dot" style="background-color: var(--error);"></div>
                        <div class="d-flex justify-content-between align-items-start">
                            <p class="fw-bold mb-0" style="font-size: 13px;">Xác thực thất bại</p>
                            <span class="text-on-surface-variant" style="font-size: 11px;">14:18:44</span>
                        </div>
                        <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                            IP: <span style="color: var(--on-surface); font-weight: 600;">192.168.1.142</span>
                        </p>
                        <p class="mb-0" style="font-size: 12px; color: var(--error); font-weight: 600;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">warning</span>
                            Đăng nhập sai nhiều lần (5)
                        </p>
                    </div>
                    <div class="audit-item" style="border-left-color: var(--outline); opacity: 0.6;">
                        <div class="audit-dot" style="background-color: var(--outline);"></div>
                        <div class="d-flex justify-content-between align-items-start">
                            <p class="fw-bold mb-0" style="font-size: 13px;">Thực thể đã xóa</p>
                            <span class="text-on-surface-variant" style="font-size: 11px;">12:10:00</span>
                        </div>
                        <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                            Người dùng: <span style="color: var(--on-surface); font-weight: 600;">system_daemon</span>
                        </p>
                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">
                            Bảng: Transactions_Archive_2023
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
