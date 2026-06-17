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
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">Lưu thông hôm nay</h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">sensors</span>
                            Tổng quan hoạt động quầy theo thời gian thực
                        </p>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/librarian/book-overview.jsp"
                           class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 16px;">auto_stories</span> Quản lý sách
                        </a>
                        <a href="${pageContext.request.contextPath}/librarian/catalog.jsp"
                           class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 16px;">add</span> Mượn sách
                        </a>
                    </div>
                </div>

                <!-- ─── KPI Stats Grid ─── -->
                <div class="row g-3 mb-4">
                    <!-- Issued Today -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                        <div class="stat-card h-100" style="--card-accent: var(--primary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                </div>
                                <span class="badge-pill badge-success">+12 hôm nay</span>
                            </div>
                            <p class="stat-label">Sách đã mượn</p>
                            <p class="stat-value"><c:out value="${issuedToday != null ? issuedToday : '38'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 70%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Returned Today -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                        <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--tertiary);">assignment_return</span>
                                </div>
                                <span class="badge-pill badge-success">+8 hôm nay</span>
                            </div>
                            <p class="stat-label">Sách đã trả</p>
                            <p class="stat-value"><c:out value="${returnedToday != null ? returnedToday : '22'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 50%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Overdue -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                        <div class="stat-card h-100" style="--card-accent: var(--error);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--error-container) 0%, #fca5a5 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--error);">event_busy</span>
                                </div>
                                <span class="badge-pill badge-error">Cần hành động</span>
                            </div>
                            <p class="stat-label">Khoản mượn quá hạn</p>
                            <p class="stat-value"><c:out value="${overdueCount != null ? overdueCount : '7'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 30%; background: linear-gradient(90deg, #fca5a5, var(--error));"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Active Reservations -->
                    <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                        <div class="stat-card h-100" style="--card-accent: var(--warning);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--warning);">bookmark</span>
                                </div>
                                <span class="badge-pill badge-warning">Chờ duyệt</span>
                            </div>
                            <p class="stat-label">Đặt trước chờ duyệt</p>
                            <p class="stat-value"><c:out value="${pendingReservations != null ? pendingReservations : '15'}" /></p>
                            <div class="mini-progress">
                                <div class="mini-progress-bar" style="width: 60%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Active Loans + Quick Issue Form -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Khoản mượn hoạt động</h3>
                                    <p class="card-subtitle">Sách đang được mượn</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-secondary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">filter_list</span> Bộ lọc
                                    </button>
                                    <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Mượn mới
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thành viên</th>
                                            <th>Tiêu đề sách</th>
                                            <th>Ngày mượn</th>
                                            <th>Hạn trả</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty activeLoans}">
                                                <c:forEach var="loan" items="${activeLoans}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">ST</div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${loan.memberName}" /></span>
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 13px;"><c:out value="${loan.bookTitle}" /></td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.issueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td style="font-size: 13px; color: var(--error);"><fmt:formatDate value="${loan.dueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td><span class="badge-pill badge-info">Hoạt động</span></td>
                                                        <td class="text-end">
                                                            <button class="btn-icon" title="Xử lý trả sách">
                                                                <span class="material-symbols-outlined">assignment_return</span>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Sample rows -->
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">TN</div><span style="font-size: 13px; font-weight: 600;">Tran Nguyen</span></div></td>
                                                    <td style="font-size: 13px;">Clean Code (R. Martin)</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">20/05/2025</td>
                                                    <td style="font-size: 13px; color: var(--on-surface);">10/06/2025</td>
                                                    <td><span class="badge-pill badge-info">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined">assignment_return</span></button></td>
                                                </tr>
                                                <tr style="background: rgba(186,26,26,0.03);">
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background-color: var(--error-container); color: var(--error);">LM</div><span style="font-size: 13px; font-weight: 600;">Le Minh</span></div></td>
                                                    <td style="font-size: 13px;">Design Patterns (GoF)</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">01/05/2025</td>
                                                    <td style="font-size: 13px; color: var(--error); font-weight: 700;">22/05/2025 ⚠</td>
                                                    <td><span class="badge-pill badge-error">Quá hạn</span></td>
                                                    <td class="text-end"><button class="btn-icon" style="color: var(--error);" title="Trả sách"><span class="material-symbols-outlined">assignment_return</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed);">HP</div><span style="font-size: 13px; font-weight: 600;">Hoang Phuong</span></div></td>
                                                    <td style="font-size: 13px;">Introduction to Algorithms</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">28/05/2025</td>
                                                    <td style="font-size: 13px;">18/06/2025</td>
                                                    <td><span class="badge-pill badge-info">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined">assignment_return</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">VT</div><span style="font-size: 13px; font-weight: 600;">Vo Thanh</span></div></td>
                                                    <td style="font-size: 13px;">The Pragmatic Programmer</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">29/05/2025</td>
                                                    <td style="font-size: 13px;">19/06/2025</td>
                                                    <td><span class="badge-pill badge-success">Sắp đến hạn</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined">assignment_return</span></button></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-3 text-center" style="background: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem tất cả khoản mượn hoạt động
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- Quick Issue Form -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-4">
                                <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                    <span class="material-symbols-outlined" style="color: var(--primary);">published_with_changes</span>
                                </div>
                                <div>
                                    <h3 class="card-title mb-0">Mượn / Trả nhanh</h3>
                                    <p class="card-subtitle mb-0">Hành động quầy lưu thông nhanh</p>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-12 col-md-5">
                                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.08em;">
                                        Mã thành viên / Email
                                    </label>
                                    <input class="form-control rounded-3" style="border: 1.5px solid var(--outline-variant);"
                                           type="text" placeholder="Quét hoặc nhập mã thành viên..." aria-label="Member ID or email" />
                                </div>
                                <div class="col-12 col-md-5">
                                    <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.08em;">
                                        ISBN / ID Sách
                                    </label>
                                    <input class="form-control rounded-3" style="border: 1.5px solid var(--outline-variant);"
                                           type="text" placeholder="Quét hoặc nhập ISBN..." aria-label="Book ISBN or ID" />
                                </div>
                                <div class="col-12 col-md-2 d-flex align-items-end">
                                    <button class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">Mượn</button>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Pending Reservations + Fine Alerts -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Pending Reservations -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Chờ duyệt Đặt trước</h3>
                                <span class="badge-pill badge-primary">
                                    <c:out value="${pendingReservations != null ? pendingReservations : '15'}" /> Đang chờ
                                </span>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <span class="fw-bold" style="font-size: 13px;">Nguyen Duc Hieu</span>
                                        <span class="badge-pill badge-error">2 ngày</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-2" style="font-size: 12px;">Refactoring (Martin Fowler)</p>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Xác nhận</button>
                                        <button class="btn btn-sm btn-secondary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Từ chối</button>
                                    </div>
                                </div>
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <span class="fw-bold" style="font-size: 13px;">Pham Thi Lan</span>
                                        <span class="badge-pill badge-warning">1 ngày</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-2" style="font-size: 12px;">Java: The Complete Reference</p>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Xác nhận</button>
                                        <button class="btn btn-sm btn-secondary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Từ chối</button>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3 text-center" style="border-top: 1px solid var(--outline-variant); background: var(--surface-container-low);">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem tất cả đặt trước
                                    <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                        </div>

                        <!-- Today's Fine Alerts -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title mb-0">Thu tiền phạt hôm nay</h3>
                                    <p class="card-subtitle mb-0">Số dư phạt chưa thanh toán</p>
                                </div>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3"
                                     style="background: linear-gradient(135deg, rgba(186,26,26,0.05) 0%, rgba(186,26,26,0.02) 100%); border: 1px solid rgba(186,26,26,0.15);">
                                    <div>
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Le Minh</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Quá hạn: 11 ngày</p>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-1" style="font-size: 15px; font-weight: 700; color: var(--error);">55,000đ</p>
                                        <button class="btn btn-sm rounded-2 fw-bold px-3"
                                                style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none;">Thu</button>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3"
                                     style="background: linear-gradient(135deg, rgba(186,26,26,0.05) 0%, rgba(186,26,26,0.02) 100%); border: 1px solid rgba(186,26,26,0.15);">
                                    <div>
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Nguyen Van An</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Quá hạn: 4 ngày</p>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-1" style="font-size: 15px; font-weight: 700; color: var(--error);">20,000đ</p>
                                        <button class="btn btn-sm rounded-2 fw-bold px-3"
                                                style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none;">Thu</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
