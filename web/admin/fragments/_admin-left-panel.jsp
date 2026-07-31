<%-- Fragment: _admin-left-panel.jsp — Bảng tài khoản người dùng + Cấu hình hệ thống + Bảo trì vận hành --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="col-12 col-lg-8 d-flex flex-column gap-4">

    <%-- User Accounts Table --%>
    <div class="raised-card overflow-hidden">
        <div class="card-header-row">
            <div>
                <h3 class="card-title">Tài khoản Người dùng</h3>
                <p class="card-subtitle">Kiểm soát quản trị tài khoản toàn hệ thống</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/user"
               class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                <span class="material-symbols-outlined" style="font-size: 18px;">add</span> Thêm Tài khoản
            </a>
        </div>
        <div class="table-responsive">
            <table class="table table-lms mb-0">
                <thead>
                    <tr>
                        <th>Người dùng</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty adminUsers}">
                            <c:forEach var="u" items="${adminUsers}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="avatar avatar-sm"
                                                 style="background-color: var(--secondary-fixed-dim); color: var(--on-secondary-fixed);">
                                                <c:out value="${fn:toUpperCase(fn:substring(not empty u.fullName ? u.fullName : u.email, 0, 2))}" />
                                            </div>
                                            <div>
                                                <p class="fw-bold mb-0" style="font-size: 13.5px;">
                                                    <c:out value="${not empty u.fullName ? u.fullName : u.email}" />
                                                </p>
                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">
                                                    <c:out value="${u.email}" />
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge-pill badge-info">
                                            <c:choose>
                                                <c:when test="${u.role == 'ADMIN'}">SysAdmin</c:when>
                                                <c:when test="${u.role == 'LIBRARIAN'}">Thủ thư</c:when>
                                                <c:when test="${u.role == 'STUDENT'}">Sinh viên</c:when>
                                                <c:when test="${u.role == 'LECTURER'}">Giảng viên</c:when>
                                                <c:otherwise><c:out value="${u.role}" /></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'active'}">
                                                <span class="d-flex align-items-center gap-1"
                                                      style="color: var(--success); font-size: 13px;">
                                                    <span class="rounded-circle d-inline-block"
                                                          style="width: 7px; height: 7px; background: var(--success);"></span>
                                                    Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="d-flex align-items-center gap-1"
                                                      style="color: var(--error); font-size: 13px;">
                                                    <span class="rounded-circle d-inline-block"
                                                          style="width: 7px; height: 7px; background: var(--error);"></span>
                                                    Đã khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-flex justify-content-end gap-1">
                                            <c:choose>
                                                <c:when test="${u.status == 'active'}">
                                                    <button class="btn-icon" title="Khóa"
                                                            onclick="quickLock('${u.userId}', '<c:out value="${u.fullName}" />', '<c:out value="${u.email}" />')">
                                                        <span class="material-symbols-outlined">lock</span>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-icon" style="color: var(--success);"
                                                            title="Mở khóa"
                                                            onclick="quickUnlock('${u.userId}')">
                                                        <span class="material-symbols-outlined">lock_open</span>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="btn-icon" title="Sửa"
                                                    onclick="location.href='${pageContext.request.contextPath}/admin/user?search=${u.email}'">
                                                <span class="material-symbols-outlined">edit</span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="text-center text-on-surface-variant py-4" style="font-size: 14px;">
                                    <span class="material-symbols-outlined d-block mb-1"
                                          style="font-size: 32px; color: var(--outline);">group_off</span>
                                    Không tìm thấy tài khoản người dùng nào.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <div class="p-3 text-center"
             style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
            <a href="${pageContext.request.contextPath}/admin/user"
               class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1"
               style="font-size: 13px;">
                Xem Tất cả Tài khoản
                <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
            </a>
        </div>
    </div>

    <%-- System Configurations --%>
    <div class="raised-card overflow-hidden">
        <div class="card-header-row">
            <div>
                <h3 class="card-title">Cấu hình Hệ thống</h3>
                <p class="card-subtitle">Các thông số vận hành thư viện cốt lõi</p>
            </div>
            <div class="d-flex gap-1">
                <button class="btn-icon" title="Làm mới">
                    <span class="material-symbols-outlined">refresh</span>
                </button>
                <button class="btn-icon" title="Lịch sử">
                    <span class="material-symbols-outlined">history</span>
                </button>
            </div>
        </div>
        <div class="p-4">
            <div class="row g-3">
                <div class="col-12 col-md-6">
                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                           style="font-size: 10px; letter-spacing: 0.08em;">STUDENT_MAX_BORROW_DAYS</label>
                    <input class="config-input" type="text" readonly
                           value="${not empty sysConfig.maxLoanDays ? sysConfig.maxLoanDays : '14'}"
                           aria-label="Thời gian mượn tối đa tính bằng ngày" />
                </div>
                <div class="col-12 col-md-6">
                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                           style="font-size: 10px; letter-spacing: 0.08em;">FINE_RATE_PER_DAY</label>
                    <input class="config-input" type="text" readonly
                           value="${not empty sysConfig.penaltyRate ? sysConfig.penaltyRate : '5000'}"
                           aria-label="Mức phạt mỗi ngày" />
                </div>
                <div class="col-12 col-md-6">
                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                           style="font-size: 10px; letter-spacing: 0.08em;">RESERVATION_HOLD_DAYS</label>
                    <input class="config-input" type="text" readonly
                           value="${not empty sysConfig.reservationHoldDays ? sysConfig.reservationHoldDays : '3'}"
                           aria-label="Số ngày giữ đặt chỗ" />
                </div>
                <div class="col-12 col-md-6">
                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                           style="font-size: 10px; letter-spacing: 0.08em;">MAX_EXTENSION_COUNT</label>
                    <input class="config-input" type="text" readonly
                           value="${not empty sysConfig.autoRenewLimit ? sysConfig.autoRenewLimit : '3'}"
                           aria-label="Giới hạn số lần gia hạn" />
                </div>
            </div>
        </div>
        <div class="p-3 text-center"
             style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
            <a href="${pageContext.request.contextPath}/admin/system-config"
               class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1"
               style="font-size: 13px;">
                Xem Tất cả Cấu hình
                <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
            </a>
        </div>
    </div>

    <%-- Maintenance Operations --%>
    <div class="raised-card overflow-hidden">
        <div class="card-header-row">
            <div>
                <h3 class="card-title">Bảo trì &amp; Vận hành Hệ thống</h3>
                <p class="card-subtitle">Kích hoạt nhanh quy trình xử lý tác vụ định kỳ bằng tay</p>
            </div>
        </div>
        <div class="p-4">
            <div class="d-flex flex-wrap gap-3">
                <button id="btn-trigger-expiration"
                        class="btn rounded-3 fw-semibold d-flex align-items-center gap-2"
                        style="border: 1.5px solid var(--outline-variant); font-size: 13.5px; padding: 10px 16px; color: var(--on-surface-variant); background: var(--surface-container-low); transition: all 0.2s ease;">
                    <span class="material-symbols-outlined" style="font-size: 20px;">cleaning_services</span>
                    Dọn dẹp Đặt trước Quá hạn (F5)
                </button>
                <button id="btn-trigger-overdue"
                        class="btn rounded-3 fw-semibold d-flex align-items-center gap-2"
                        style="border: 1.5px solid var(--outline-variant); font-size: 13.5px; padding: 10px 16px; color: var(--on-surface-variant); background: var(--surface-container-low); transition: all 0.2s ease;">
                    <span class="material-symbols-outlined" style="font-size: 20px;">alarm_on</span>
                    Quét Phạt &amp; Khóa Quá Hạn (F9)
                </button>
            </div>
            <div id="maintenance-msg" class="mt-3 d-none p-3 rounded-2" style="font-size: 13.5px;"></div>
        </div>
    </div>

</div>
