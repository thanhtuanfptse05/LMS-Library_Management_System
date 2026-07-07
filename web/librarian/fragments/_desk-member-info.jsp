<%-- Fragment: _desk-member-info.jsp — Thẻ thông tin hồ sơ độc giả + Thống kê giao dịch --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row g-4">

    <%-- PROFILE CARD --%>
    <div class="col-12 col-lg-4">
        <div class="profile-card rounded-4 p-4 h-100">
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                     style="width:54px;height:54px;background-color:var(--primary);color:white;font-size:20px;">
                    ${not empty requestScope.searchedProfile.fullName
                      ? requestScope.searchedProfile.fullName.substring(0, 1).toUpperCase()
                      : 'Đ'}
                </div>
                <div>
                    <h4 class="fw-bold mb-0" style="font-size:16px;">
                        <c:out value="${requestScope.searchedProfile.fullName}" />
                    </h4>
                    <p class="text-on-surface-variant mb-0 small">
                        Mã số: <strong><c:out value="${requestScope.memberCode}" /></strong>
                    </p>
                </div>
            </div>

            <hr style="border-color:var(--outline-variant);">

            <div class="d-flex flex-column gap-3 small">
                <div class="d-flex justify-content-between">
                    <span class="text-on-surface-variant">Vai trò:</span>
                    <span class="fw-bold text-capitalize">
                        <c:out value="${requestScope.searchedUser.role}" />
                    </span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-on-surface-variant">Email:</span>
                    <span class="fw-bold">
                        <c:out value="${requestScope.searchedUser.email}" />
                    </span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-on-surface-variant">Số điện thoại:</span>
                    <span class="fw-bold">
                        <c:out value="${requestScope.searchedProfile.phoneNumber}" />
                    </span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="text-on-surface-variant">Trạng thái tài khoản:</span>
                    <c:choose>
                        <c:when test="${requestScope.searchedUser.status == 'active'}">
                            <span class="status-badge status-active">
                                <span class="material-symbols-outlined" style="font-size:12px;">check_circle</span>
                                Hoạt động
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-locked">
                                <span class="material-symbols-outlined" style="font-size:12px;">lock</span>
                                Bị khóa
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${requestScope.searchedUser.status != 'active'}">
                    <div class="alert alert-danger p-2 mb-0 mt-2 rounded-3 small">
                        <strong>Lý do khóa:</strong>
                        <c:out value="${not empty requestScope.searchedUserLockReasons ? requestScope.searchedUserLockReasons : 'Nợ phạt quá hạn / Chưa thanh toán'}" />
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <%-- SUMMARY STATS CARDS --%>
    <div class="col-12 col-lg-8">
        <div class="raised-card p-4 h-100">
            <h4 class="fw-bold mb-4" style="font-size:16px;color:var(--on-surface);">
                Thống kê hoạt động độc giả
            </h4>
            <div class="row g-3">
                <!-- Đang mượn -->
                <div class="col-6 col-md-3">
                    <div class="p-3 rounded-4 d-flex flex-column align-items-center text-center h-100"
                         style="background-color: rgba(13, 110, 253, 0.05); border: 1px solid rgba(13, 110, 253, 0.15);">
                        <span class="material-symbols-outlined text-primary mb-2" style="font-size: 32px;">book</span>
                        <span class="text-secondary small fw-medium mb-1">Đang mượn</span>
                        <h3 class="fw-bold text-primary m-0">${fn:length(requestScope.activeBorrows)}</h3>
                    </div>
                </div>
                <!-- Chờ nhận sách -->
                <div class="col-6 col-md-3">
                    <div class="p-3 rounded-4 d-flex flex-column align-items-center text-center h-100"
                         style="background-color: rgba(245, 158, 11, 0.05); border: 1px solid rgba(245, 158, 11, 0.15);">
                        <span class="material-symbols-outlined text-warning mb-2" style="font-size: 32px;">pending_actions</span>
                        <span class="text-secondary small fw-medium mb-1">Chờ nhận</span>
                        <h3 class="fw-bold text-warning m-0">${fn:length(requestScope.readyReservations)}</h3>
                    </div>
                </div>
                <!-- Nợ phạt chưa trả -->
                <div class="col-6 col-md-3">
                    <div class="p-3 rounded-4 d-flex flex-column align-items-center text-center h-100"
                         style="background-color: rgba(220, 53, 69, 0.05); border: 1px solid rgba(220, 53, 69, 0.15);">
                        <span class="material-symbols-outlined text-danger mb-2" style="font-size: 32px;">gavel</span>
                        <span class="text-secondary small fw-medium mb-1">Nợ phạt</span>
                        <h3 class="fw-bold text-danger m-0">${fn:length(requestScope.unpaidFines)}</h3>
                    </div>
                </div>
                <!-- Phạt đã trả -->
                <div class="col-6 col-md-3">
                    <div class="p-3 rounded-4 d-flex flex-column align-items-center text-center h-100"
                         style="background-color: rgba(40, 167, 69, 0.05); border: 1px solid rgba(40, 167, 69, 0.15);">
                        <span class="material-symbols-outlined text-success mb-2" style="font-size: 32px;">payments</span>
                        <span class="text-secondary small fw-medium mb-1">Phạt đã trả</span>
                        <h3 class="fw-bold text-success m-0">${fn:length(requestScope.paidFines)}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
