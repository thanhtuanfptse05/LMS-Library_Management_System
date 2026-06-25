<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">check_circle</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">error</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Section Header ─── -->
                <div class="page-header d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">
                            Sức khỏe Cơ sở dữ liệu
                        </h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">schedule</span>
                            Kiểm tra lần cuối: Vừa xong
                        </p>
                    </div>
                </div>

                <!-- ─── KPI Stats Grid ─── -->
                <div class="row g-3 mb-4">
                    <!-- Card: Total Books -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                        <div class="stat-card h-100" style="--card-accent: var(--primary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">menu_book</span>
                                </div>
                                <span class="badge-pill badge-success">Ổn định</span>
                            </div>
                            <p class="stat-label">Tổng số Sách</p>
                            <p class="stat-value"><c:out value="${totalBooks != null ? totalBooks : '124,502'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 85%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Card: Library Members -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                        <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--tertiary);">person</span>
                                </div>
                                <span class="badge-pill badge-success">Hoạt động</span>
                            </div>
                            <p class="stat-label">Thành viên Thư viện</p>
                            <p class="stat-value"><c:out value="${totalMembers != null ? totalMembers : '12,890'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 62%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Card: Transactions/hr -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                        <div class="stat-card h-100" style="--card-accent: var(--warning);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--warning);">sync_alt</span>
                                </div>
                                <span class="badge-pill badge-warning">Tải cao</span>
                            </div>
                            <p class="stat-label">Giao dịch / giờ</p>
                            <p class="stat-value">456</p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 92%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Card: Index Latency -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                        <div class="stat-card h-100" style="--card-accent: var(--error);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--error);">database</span>
                                </div>
                                <span class="badge-pill badge-error">Bị trễ</span>
                            </div>
                            <p class="stat-label">Độ trễ Index</p>
                            <p class="stat-value">42ms</p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 40%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: User Accounts + Configurations -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- User Accounts Table -->
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
                                                                <div class="avatar avatar-sm" style="background-color: var(--secondary-fixed-dim); color: var(--on-secondary-fixed);">
                                                                    <c:out value="${fn:toUpperCase(fn:substring(u.email,0,2))}" />
                                                                </div>
                                                                <div>
                                                                    <p class="fw-bold mb-0" style="font-size: 13.5px;"><c:out value="${u.email}" /></p>
                                                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;"><c:out value="${u.role}" /></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge-pill badge-info"><c:out value="${u.role}" /></span>
                                                        </td>
                                                        <td>
                                                            <span class="d-flex align-items-center gap-1" style="color: var(--success); font-size: 13px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 7px; height: 7px; background: var(--success);"></span>
                                                                Hoạt động
                                                            </span>
                                                        </td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;">—</td>
                                                        <td class="text-end">
                                                            <div class="d-flex justify-content-end gap-1">
                                                                <button class="btn-icon" title="Khóa Tài khoản"><span class="material-symbols-outlined">lock</span></button>
                                                                <button class="btn-icon" title="Đặt lại Mật khẩu"><span class="material-symbols-outlined">key</span></button>
                                                                <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined">edit</span></button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Sample rows when no data -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--secondary-fixed-dim); color: var(--on-secondary-fixed);">JS</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13.5px;">John Stevens</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">j.stevens@uni.edu</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill badge-info">Thủ thư Trưởng</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: var(--success); font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 7px; height: 7px; background: var(--success);"></span>Hoạt động</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">2 phút trước</td>
                                                    <td class="text-end">
                                                        <div class="d-flex justify-content-end gap-1">
                                                            <button class="btn-icon" title="Khóa"><span class="material-symbols-outlined">lock</span></button>
                                                            <button class="btn-icon" title="Reset MK"><span class="material-symbols-outlined">key</span></button>
                                                            <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined">edit</span></button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">MK</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13.5px;">Maria Kovacs</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">m.kovacs@uni.edu</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill badge-primary">SysAdmin</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: var(--success); font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 7px; height: 7px; background: var(--success);"></span>Hoạt động</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">5 phút trước</td>
                                                    <td class="text-end">
                                                        <div class="d-flex justify-content-end gap-1">
                                                            <button class="btn-icon" title="Khóa"><span class="material-symbols-outlined">lock</span></button>
                                                            <button class="btn-icon" title="Reset MK"><span class="material-symbols-outlined">key</span></button>
                                                            <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined">edit</span></button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr style="background: rgba(186,26,26,0.03);">
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--error-container); color: var(--error);">RL</div>
                                                            <div>
                                                                <p class="fw-bold mb-0" style="font-size: 13.5px;">Robert Lang</p>
                                                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">r.lang@external.com</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge-pill badge-neutral">Khách</span></td>
                                                    <td><span class="d-flex align-items-center gap-1" style="color: var(--error); font-size: 13px;"><span class="rounded-circle d-inline-block" style="width: 7px; height: 7px; background: var(--error);"></span>Đã khóa</span></td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">3 ngày trước</td>
                                                    <td class="text-end">
                                                        <div class="d-flex justify-content-end gap-1">
                                                            <button class="btn-icon" style="color: var(--success);" title="Mở khóa"><span class="material-symbols-outlined">lock_open</span></button>
                                                            <button class="btn-icon" title="Reset MK"><span class="material-symbols-outlined">key</span></button>
                                                            <button class="btn-icon" title="Sửa"><span class="material-symbols-outlined">edit</span></button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-3 text-center" style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                                <a href="${pageContext.request.contextPath}/admin/user"
                                   class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1"
                                   style="font-size: 13px;">
                                    Xem Tất cả Tài khoản
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- System Configurations -->
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
                                               style="font-size: 10px; letter-spacing: 0.08em;">MAX_LOAN_DURATION_DAYS</label>
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
                                        <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                                               style="font-size: 10px; letter-spacing: 0.08em;">PENALTY_RATE_VND/DAY</label>
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
                                        <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                                               style="font-size: 10px; letter-spacing: 0.08em;">RESERVATION_EXPIRY_HRS</label>
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
                                        <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                                               style="font-size: 10px; letter-spacing: 0.08em;">AUTO_RENEW_LIMIT</label>
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

                        <!-- Maintenance Operations -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Bảo trì & Vận hành Hệ thống</h3>
                                    <p class="card-subtitle">Kích hoạt nhanh quy trình xử lý tác vụ định kỳ bằng tay</p>
                                </div>
                            </div>
                            <div class="p-4">
                                <div class="d-flex flex-wrap gap-3">
                                    <button id="btn-trigger-expiration" class="btn rounded-3 fw-semibold d-flex align-items-center gap-2"
                                            style="border: 1.5px solid var(--outline-variant); font-size: 13.5px; padding: 10px 16px; color: var(--on-surface-variant); background: var(--surface-container-low); transition: all 0.2s ease;">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">cleaning_services</span>
                                        Dọn dẹp Đặt trước Quá hạn (F5)
                                    </button>
                                </div>
                                <div id="maintenance-msg" class="mt-3 d-none p-3 rounded-2" style="font-size: 13.5px;"></div>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Security Audit Feed -->
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
                                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                                                    Người dùng: <span style="color: var(--on-surface); font-weight: 600;"><c:out value="${log.performedBy}" /></span>
                                                </p>
                                                <div class="p-2 rounded-2" style="background-color: var(--surface-container-low); font-family: monospace; font-size: 11px; color: var(--on-surface-variant);">
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
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                                                Người dùng: <span style="color: var(--on-surface); font-weight: 600;">admin_maria</span>
                                            </p>
                                            <div class="p-2 rounded-2" style="background-color: var(--surface-container-low); font-family: monospace; font-size: 11px; color: var(--on-surface-variant);">
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
                                        <div class="audit-item" style="border-left-color: var(--tertiary);">
                                            <div class="audit-dot" style="background-color: var(--tertiary);"></div>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="fw-bold mb-0" style="font-size: 13px;">Tài khoản Locked</p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;">13:55:12</span>
                                            </div>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">
                                                Mục tiêu: <span style="color: var(--on-surface); font-weight: 600;">r.lang@external.com</span>
                                            </p>
                                            <p class="text-on-surface-variant mb-0" style="font-size: 12px;">
                                                Lý do: Vi phạm Chính sách Bảo mật
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
                            <div class="p-3" style="border-top: 1px solid var(--outline-variant);">
                                <a href="#" class="btn w-100 rounded-3 fw-semibold d-flex align-items-center justify-content-center gap-2"
                                   style="border: 1.5px solid var(--outline-variant); font-size: 13px; padding: 10px; color: var(--on-surface-variant); transition: all 0.2s ease;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">download</span>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hover effect on audit export button
        document.querySelectorAll('.card-header-row a, .card-header-row button').forEach(function(el) {
            el.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-1px)';
            });
            el.addEventListener('mouseleave', function() {
                this.style.transform = '';
            });
        });

        // Trigger Reservation Expiration AJAX (F5)
        const btnTrigger = document.getElementById('btn-trigger-expiration');
        const maintenanceMsg = document.getElementById('maintenance-msg');
        
        if (btnTrigger) {
            btnTrigger.addEventListener('click', function() {
                btnTrigger.disabled = true;
                btnTrigger.innerHTML = '<span class="material-symbols-outlined spin" style="font-size: 20px; animation: rotation 2s infinite linear;">sync</span> Đang xử lý...';
                
                maintenanceMsg.classList.add('d-none');
                maintenanceMsg.className = 'mt-3 p-3 rounded-2'; // Reset classes
                
                fetch('${pageContext.request.contextPath}/admin/trigger-reservation-expiration', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => {
                    if (response.status === 403) {
                        throw new Error('Bạn không có quyền thực hiện hành động này.');
                    }
                    if (!response.ok) {
                        throw new Error('Lỗi hệ thống khi dọn dẹp.');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        maintenanceMsg.classList.remove('d-none');
                        maintenanceMsg.classList.add('alert', 'alert-success');
                        maintenanceMsg.innerText = data.message;
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Lỗi không xác định.');
                    }
                })
                .catch(err => {
                    maintenanceMsg.classList.remove('d-none');
                    maintenanceMsg.classList.add('alert', 'alert-danger');
                    maintenanceMsg.innerText = err.message;
                    
                    btnTrigger.disabled = false;
                    btnTrigger.innerHTML = '<span class="material-symbols-outlined" style="font-size: 20px;">cleaning_services</span> Dọn dẹp Đặt trước Quá hạn (F5)';
                });
            });
        }
    </script>
    <style>
        @keyframes rotation {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    </style>
</body>
</html>
