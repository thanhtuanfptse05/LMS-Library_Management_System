<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Section: Database Health ─── -->
                <section class="mb-4">
                    <div class="d-flex justify-content-between align-items-end mb-3">
                        <div>
                            <h2 class="fw-semibold mb-0" style="font-size: 20px; color: var(--on-surface);">Sức khỏe Cơ sở dữ liệu</h2>
                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Kiểm tra lần cuối: Vừa xong</p>
                        </div>
                    </div>
                    <div class="row g-3">
                        <!-- Card: Total Books -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed);">menu_book</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">Ổn định</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Tổng số Sách</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${totalBooks != null ? totalBooks : '124,502'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 85%; background-color: var(--primary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Card: Library Members -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed);">person</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">Hoạt động</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Thành viên Thư viện</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${totalMembers != null ? totalMembers : '12,890'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 62%; background-color: var(--tertiary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Card: Transactions/hr -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7;">sync_alt</span>
                                    <span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Tải cao</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Giao dịch/giờ</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">456</h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 92%; background-color: #d97706;"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Card: Index Latency -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--error); background-color: var(--error-container);">database</span>
                                    <span class="badge-pill" style="color: var(--error); background-color: var(--error-container);">Bị trễ</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Độ trễ Index</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">42ms</h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 40%; background-color: var(--error);"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: User Accounts + Configurations -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- User Accounts Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center bg-white"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Tài khoản Người dùng</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Kiểm soát quản trị tài khoản toàn hệ thống</p>
                                </div>
                                <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">add</span> Thêm Tài khoản
                                </button>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Người dùng</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Đăng nhập cuối</th>
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
                                                                <div class="avatar" style="background-color: var(--secondary-fixed-dim); color: var(--on-secondary-fixed);">
                                                                    <c:out value="${fn:substring(u.email,0,2).toUpperCase()}" />
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0" style="font-size: 14px;"><c:out value="${u.email}" /></p>
                                                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;"><c:out value="${u.role}" /></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge-pill" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">
                                                                <c:out value="${u.role}" />
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="d-flex align-items-center gap-1" style="color: #059669; font-size: 13px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 8px; height: 8px; background: #059669;"></span>
                                                                Hoạt động
                                                            </span>
                                                        </td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;">—</td>
                                                        <td class="text-end">
                                                            <button class="btn-icon" title="Khóa Tài khoản"><span class="material-symbols-outlined" style="font-size: 18px;">lock</span></button>
                                                            <button class="btn-icon" title="Đặt lại Mật khẩu"><span class="material-symbols-outlined" style="font-size: 18px;">key</span></button>
                                                            <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Sample rows when no data -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--secondary-fixed-dim); color: var(--on-secondary-fixed);">JS</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 14px;">John Stevens</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">j.stevens@uni.edu</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">Thủ thư Trưởng</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: #059669; font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 8px; height: 8px; background: #059669;"></span>Hoạt động</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">2 phút trước</td>
                                                    <td class="text-end">
                                                        <button class="btn-icon" title="Khóa Tài khoản"><span class="material-symbols-outlined" style="font-size: 18px;">lock</span></button>
                                                        <button class="btn-icon" title="Đặt lại Mật khẩu"><span class="material-symbols-outlined" style="font-size: 18px;">key</span></button>
                                                        <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">MK</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 14px;">Maria Kovacs</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">m.kovacs@uni.edu</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed-variant);">SysAdmin</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: #059669; font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 8px; height: 8px; background: #059669;"></span>Hoạt động</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">5 phút trước</td>
                                                    <td class="text-end">
                                                        <button class="btn-icon"><span class="material-symbols-outlined" style="font-size: 18px;">lock</span></button>
                                                        <button class="btn-icon"><span class="material-symbols-outlined" style="font-size: 18px;">key</span></button>
                                                        <button class="btn-icon"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                    </td>
                                                </tr>
                                                <tr style="background-color: rgba(255,218,214,.08);">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar" style="background-color: var(--error-container); color: var(--error);">RL</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 14px;">Robert Lang</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">r.lang@external.com</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill" style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">Khách</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: var(--error); font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 8px; height: 8px; background: var(--error);"></span>Đã khóa</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">3 ngày trước</td>
                                                    <td class="text-end">
                                                        <button class="btn-icon" style="color: #059669;" title="Mở khóa"><span class="material-symbols-outlined" style="font-size: 18px;">lock_open</span></button>
                                                        <button class="btn-icon"><span class="material-symbols-outlined" style="font-size: 18px;">key</span></button>
                                                        <button class="btn-icon"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-3 text-center bg-surface-container-low">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">
                                    Xem Tất cả Tài khoản &rarr;
                                </a>
                            </div>
                        </div>

                        <!-- System Configurations -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Cấu hình Hệ thống</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Các thông số vận hành thư viện cốt lõi</p>
                                </div>
                                <div class="d-flex gap-1">
                                    <button class="btn-icon" title="Làm mới"><span class="material-symbols-outlined">refresh</span></button>
                                    <button class="btn-icon" title="Lịch sử"><span class="material-symbols-outlined">history</span></button>
                                </div>
                            </div>
                            <div class="p-4">
                                <div class="row g-3">
                                    <div class="col-12 col-md-6">
                                        <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">MAX_LOAN_DURATION_DAYS</label>
                                        <div class="d-flex gap-2">
                                            <input class="config-input" type="text"
                                                   value="${not empty sysConfig.maxLoanDays ? sysConfig.maxLoanDays : '21'}"
                                                   aria-label="Thời gian mượn tối đa tính bằng ngày" />
                                            <button class="btn btn-sm btn-primary-custom rounded-2 px-3" title="Lưu">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">PENALTY_RATE_VND/DAY</label>
                                        <div class="d-flex gap-2">
                                            <input class="config-input" type="text"
                                                   value="${not empty sysConfig.penaltyRate ? sysConfig.penaltyRate : '5,000'}"
                                                   aria-label="Tỷ lệ phạt mỗi ngày" />
                                            <button class="btn btn-sm btn-primary-custom rounded-2 px-3" title="Lưu">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">RESERVATION_EXPIRY_HRS</label>
                                        <div class="d-flex gap-2">
                                            <input class="config-input" type="text"
                                                   value="${not empty sysConfig.reservationExpiryHrs ? sysConfig.reservationExpiryHrs : '48'}"
                                                   aria-label="Giờ hết hạn đặt chỗ" />
                                            <button class="btn btn-sm btn-primary-custom rounded-2 px-3" title="Lưu">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">AUTO_RENEW_LIMIT</label>
                                        <div class="d-flex gap-2">
                                            <input class="config-input" type="text"
                                                   value="${not empty sysConfig.autoRenewLimit ? sysConfig.autoRenewLimit : '2'}"
                                                   aria-label="Giới hạn gia hạn tự động" />
                                            <button class="btn btn-sm btn-primary-custom rounded-2 px-3" title="Lưu">
                                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Security Audit Feed -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card d-flex flex-column" style="height: 700px; position: sticky; top: 80px;">
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Bảo mật Audit</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Luồng nhật ký giám sát trực tiếp</p>
                                </div>
                                <div class="position-relative">
                                    <span class="animate-pulse position-absolute rounded-circle"
                                          style="width: 10px; height: 10px; background: var(--error); border: 2px solid white; top: -4px; right: -4px;"></span>
                                    <span class="material-symbols-outlined text-on-surface-variant">stream</span>
                                </div>
                            </div>
                            <div class="flex-grow-1 p-3 d-flex flex-column gap-3 custom-scrollbar" style="overflow-y: auto;">
                                <!-- Audit Items from DB -->
                                <c:choose>
                                    <c:when test="${not empty auditLogs}">
                                        <c:forEach var="log" items="${auditLogs}">
                                            <div class="audit-item" style="border-left-color: var(--primary);">
                                                <div class="audit-dot" style="background-color: var(--primary);"></div>
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${log.action}" /></p>
                                                    <span class="text-on-surface-variant" style="font-size: 11px;"><fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" /></span>
                                                </div>
                                                <p class="text-on-surface-variant mb-1" style="font-size: 13px;">Người dùng: <span style="color: var(--on-surface); font-weight: 500;"><c:out value="${log.performedBy}" /></span></p>
                                                <div class="p-1 rounded-1" style="background-color: var(--surface-container-low); font-family: monospace; font-size: 11px; color: var(--on-surface-variant);">
                                                    <c:out value="${log.details}" />
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Sample audit items -->
                                        <div class="audit-item" style="border-left-color: var(--primary);">
                                            <div class="audit-dot" style="background-color: var(--primary);"></div>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="fw-bold mb-0" style="font-size: 13px;">Cập nhật cấu hình</p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">14:22:01</span>
                                            </div>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 13px;">Người dùng: <span style="color: var(--on-surface); font-weight: 500;">admin_maria</span></p>
                                            <div class="p-1 rounded-1" style="background-color: var(--surface-container-low); font-family: monospace; font-size: 11px; color: var(--on-surface-variant);">
                                                PENALTY_RATE: 0.25 &rarr; 0.50
                                            </div>
                                        </div>
                                        <div class="audit-item" style="border-left-color: var(--error);">
                                            <div class="audit-dot" style="background-color: var(--error);"></div>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="fw-bold mb-0" style="font-size: 13px;">Xác thực thất bại</p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">14:18:44</span>
                                            </div>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 13px;">IP: <span style="color: var(--on-surface); font-weight: 500;">192.168.1.142</span></p>
                                            <p class="mb-0" style="font-size: 13px; color: var(--error);">Cảnh báo: Đăng nhập sai nhiều lần (5)</p>
                                        </div>
                                        <div class="audit-item" style="border-left-color: var(--tertiary);">
                                            <div class="audit-dot" style="background-color: var(--tertiary);"></div>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="fw-bold mb-0" style="font-size: 13px;">Tài khoản Locked</p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">13:55:12</span>
                                            </div>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 13px;">Mục tiêu: <span style="color: var(--on-surface); font-weight: 500;">r.lang@external.com</span></p>
                                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Lý do: Vi phạm Chính sách Bảo mật</p>
                                        </div>
                                        <div class="audit-item" style="border-left-color: var(--outline); opacity: 0.6;">
                                            <div class="audit-dot" style="background-color: var(--outline);"></div>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="fw-bold mb-0" style="font-size: 13px;">Thực thể đã xóa</p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">12:10:00</span>
                                            </div>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 13px;">Người dùng: <span style="color: var(--on-surface); font-weight: 500;">system_daemon</span></p>
                                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Bảng: Transactions_Archive_2023</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-3 bg-surface-container-low" style="border-top: 1px solid var(--outline-variant);">
                                <a href="#" class="btn w-100 rounded-3 text-on-surface-variant fw-semibold"
                                   style="border: 1px solid var(--outline-variant); font-size: 13px; padding: 10px;">
                                    Xuất Toàn bộ Nhật ký Kiểm toán
                                </a>
                            </div>
                        </div>
                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

</body>
</html>
