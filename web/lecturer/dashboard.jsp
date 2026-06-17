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

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

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

                <!-- ─── Welcome Banner ─── -->
                <section class="welcome-banner mb-4">
                    <div class="row align-items-center g-0">
                        <div class="col-12 col-md-8">
                            <p class="text-on-surface-variant fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase;">Thư viện Đại học LMS</p>
                            <h2 class="fw-bold mb-1" style="font-size: 24px; color: var(--on-primary-container);">
                                Chào mừng trở lại, <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Giảng viên'}" />!
                            </h2>
                            <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                                Quản lý danh sách tài liệu môn học, hoạt động mượn sách và tài liệu nghiên cứu của bạn.
                            </p>
                        </div>
                        <div class="col-4 d-none d-md-flex justify-content-end align-items-center">
                            <span class="material-symbols-outlined" aria-hidden="true"
                                  style="font-size: 100px; color: var(--on-primary-container); opacity: 0.18;
                                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                                school
                            </span>
                        </div>
                    </div>
                </section>

                <!-- ─── Stats Cards ─── -->
                <section class="mb-4">
                    <div class="row g-3">
                        <!-- Active Loans -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-1">
                            <div class="stat-card h-100" style="--card-accent: var(--primary);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--primary-fixed-dim) 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--primary);">library_books</span>
                                    </div>
                                    <span class="badge-pill badge-info">Đang mượn</span>
                                </div>
                                <p class="stat-label">Sách đang mượn</p>
                                <p class="stat-value"><c:out value="${activeLoansCount != null ? activeLoansCount : '3'}" /></p>
                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;">trong số 10 tối đa</p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 30%; background: linear-gradient(90deg, var(--primary-fixed-dim), var(--primary));"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Course Reading Lists -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-2">
                            <div class="stat-card h-100" style="--card-accent: var(--tertiary);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--tertiary-fixed) 0%, #a0d0f5 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--tertiary);">article</span>
                                    </div>
                                    <span class="badge-pill badge-success"><c:out value="${courseCount != null ? courseCount : '4'}" /> Môn học</span>
                                </div>
                                <p class="stat-label">Danh sách tài liệu</p>
                                <p class="stat-value"><c:out value="${readingListCount != null ? readingListCount : '12'}" /></p>
                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Tổng số đầu sách</p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 60%; background: linear-gradient(90deg, var(--tertiary-fixed), var(--tertiary));"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Pending Requests -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-3">
                            <div class="stat-card h-100" style="--card-accent: var(--warning);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-container) 0%, #fde68a 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--warning);">pending_actions</span>
                                    </div>
                                    <span class="badge-pill badge-warning">Chờ xử lý</span>
                                </div>
                                <p class="stat-label">Yêu cầu chờ duyệt</p>
                                <p class="stat-value"><c:out value="${pendingRequestsCount != null ? pendingRequestsCount : '2'}" /></p>
                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Yêu cầu bổ sung sách</p>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 25%; background: linear-gradient(90deg, #fde68a, var(--warning));"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Outstanding Fines -->
                        <div class="col-12 col-sm-6 col-xl-3 fade-in-up fade-in-up-4">
                            <div class="stat-card h-100" style="--card-accent: var(--success);">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="stat-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);">
                                        <span class="material-symbols-outlined" style="color: var(--success);">payments</span>
                                    </div>
                                    <span class="badge-pill badge-success">Sạch</span>
                                </div>
                                <p class="stat-label">Tiền phạt chưa đóng</p>
                                <p class="stat-value">0đ</p>
                                <p style="font-size: 12px; color: var(--success); margin: 0; font-weight: 600;">Tài khoản ở trạng thái tốt</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Course Reading Lists + My Current Loans -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Course Chips -->
                        <div class="raised-card p-4">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Môn học của tôi</h3>
                                    <p class="card-subtitle">Học kỳ 1 — Năm học 2025</p>
                                </div>
                                <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">add</span> Yêu cầu Sách
                                </button>
                            </div>
                            <div class="d-flex flex-wrap gap-2 mb-4">
                                <c:choose>
                                    <c:when test="${not empty courses}">
                                        <c:forEach var="course" items="${courses}">
                                            <a href="#" class="course-chip">
                                                <span class="material-symbols-outlined" style="font-size: 16px; color: var(--primary);">school</span>
                                                <c:out value="${course.code}" /> — <c:out value="${course.name}" />
                                            </a>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="#" class="course-chip active">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: var(--primary);">school</span>
                                            SWP391 — Software Project
                                        </a>
                                        <a href="#" class="course-chip">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">school</span>
                                            PRJ301 — Java Web App
                                        </a>
                                        <a href="#" class="course-chip">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">school</span>
                                            DBI202 — Database Systems
                                        </a>
                                        <a href="#" class="course-chip">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">school</span>
                                            SWT301 — Software Testing
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Resources for selected course -->
                            <p class="fw-semibold text-on-surface-variant text-uppercase mb-2" style="font-size: 10px; letter-spacing: 0.1em;">Danh sách tài liệu môn học — SWP391</p>
                            <div class="d-flex flex-column gap-2">
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed); flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Software Engineering: A Practitioner's Approach</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Roger S. Pressman — 8th Edition</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: #d1fae5; color: #059669; flex-shrink: 0;">Sẵn có</span>
                                </div>
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed); flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Agile Estimating and Planning</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Mike Cohn — Prentice Hall</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--primary); flex-shrink: 0;">Đang mượn</span>
                                </div>
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7; flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">The Mythical Man-Month</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Frederick P. Brooks Jr. — Addison-Wesley</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: #d1fae5; color: #059669; flex-shrink: 0;">Sẵn có</span>
                                </div>
                            </div>
                        </div>

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Sách đang mượn</h3>
                                    <p class="card-subtitle">Sách tôi đã mượn</p>
                                </div>
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 13px;">
                                    Xem Lịch sử <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Sách</th>
                                            <th>Ngày mượn</th>
                                            <th>Hạn trả</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty myLoans}">
                                                <c:forEach var="loan" items="${myLoans}">
                                                    <tr>
                                                        <td>
                                                            <p class="fw-bold mb-0" style="font-size: 13px;"><c:out value="${loan.bookTitle}" /></p>
                                                            <p class="text-on-surface-variant mb-0" style="font-size: 12px;"><c:out value="${loan.isbn}" /></p>
                                                        </td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.issueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td style="font-size: 13px;"><fmt:formatDate value="${loan.dueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                        <td class="text-end">
                                                            <button class="btn-icon" title="Gia hạn"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;">Clean Code</p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Robert C. Martin · ISBN 978-0132350884</p>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">15/05/2025</td>
                                                    <td style="font-size: 13px;">05/06/2025</td>
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Gia hạn"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;">Design Patterns</p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Gang of Four · ISBN 978-0201633610</p>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">20/05/2025</td>
                                                    <td style="font-size: 13px;">10/06/2025</td>
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Gia hạn"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;">The Pragmatic Programmer</p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Hunt &amp; Thomas · ISBN 978-0135957059</p>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">25/05/2025</td>
                                                    <td style="font-size: 13px; color: #d97706; font-weight: 600;">15/06/2025</td>
                                                    <td><span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Sắp đến hạn</span></td>
                                                    <td class="text-end"><button class="btn-icon" style="color: var(--primary);" title="Gia hạn"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Book Requests + Recent Library News -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Book Acquisition Requests -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Yêu cầu Sách của tôi</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2 d-flex align-items-center gap-1" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Yêu cầu mới
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Continuous Delivery</p>
                                        <span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">Đang xét duyệt</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Jez Humble, David Farley</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;">Đã yêu cầu: 28/05/2025</p>
                                </div>
                                <div class="p-3 rounded-3" style="background-color: rgba(209,250,229,0.3); border: 1px solid #a7f3d0;">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Release It!</p>
                                        <span class="badge-pill" style="background-color: #d1fae5; color: #059669;">Đã phê duyệt</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Michael T. Nygard</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;">Dự kiến: 10/06/2025</p>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Profile Card -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="avatar" style="width: 52px; height: 52px; font-size: 18px; background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.email}">
                                            <c:out value="${fn:substring(sessionScope.email,0,2).toUpperCase()}" default="GV" />
                                        </c:when>
                                        <c:otherwise>GV</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="fw-bold mb-0" style="font-size: 15px;"><c:out value="${not empty sessionScope.email ? sessionScope.email : 'Giảng viên'}" /></p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Giảng viên · Đại học FPT</p>
                                </div>
                            </div>
                            <div class="d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Hạn mức mượn đã dùng</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--primary);">
                                        <c:out value="${activeLoansCount != null ? activeLoansCount : '3'}" /> / 10
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Trạng thái thư viện</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--success);">Tốt</span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Cấp độ truy cập</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--tertiary);">Nhân viên học thuật</span>
                                </div>
                            </div>
                            <a href="#" class="btn btn-sm w-100 mt-3 rounded-3 fw-bold"
                               style="background-color: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                Xem toàn bộ Hồ sơ
                            </a>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

</body>
</html>
