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

                <!-- ─── Welcome Banner ─── -->
                <div class="raised-card p-4 mb-4 d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--secondary-fixed) 100%); border-color: var(--outline-variant);">
                    <div>
                        <h2 class="fw-semibold mb-1" style="font-size: 22px; color: var(--on-primary-container);">
                            Chào mừng trở lại, <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Giảng viên'}" />
                        </h2>
                        <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                            Quản lý danh sách tài liệu môn học, hoạt động mượn sách và tài liệu nghiên cứu của bạn.
                        </p>
                    </div>
                    <div class="d-none d-md-block">
                        <span class="material-symbols-outlined" style="font-size: 72px; color: var(--primary); opacity: 0.25;">school</span>
                    </div>
                </div>

                <!-- ─── Stats Cards ─── -->
                <section class="mb-4">
                    <div class="row g-3">
                        <!-- Active Loans -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed);">library_books</span>
                                    <span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Đang mượn</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Sách đang mượn</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${activeLoansCount != null ? activeLoansCount : '3'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">trong số 10 tối đa</p>
                            </div>
                        </div>
                        <!-- Course Reading Lists -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed);">article</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">
                                        <c:out value="${courseCount != null ? courseCount : '4'}" /> Môn học
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Danh sách tài liệu</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${readingListCount != null ? readingListCount : '12'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Tổng số đầu sách</p>
                            </div>
                        </div>
                        <!-- Pending Requests -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7;">pending_actions</span>
                                    <span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Chờ xử lý</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Yêu cầu chờ duyệt</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${pendingRequestsCount != null ? pendingRequestsCount : '2'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Yêu cầu bổ sung sách</p>
                            </div>
                        </div>
                        <!-- Outstanding Fines -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--success); background-color: #d1fae5;">payments</span>
                                    <span class="badge-pill" style="color: var(--success); background-color: #d1fae5;">Sạch</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Tiền phạt chưa đóng</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">0đ</h3>
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
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Môn học của tôi</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Học kỳ 1 — Năm học 2025</p>
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
                            <div class="p-3 d-flex justify-content-between align-items-center bg-white"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Sách đang mượn</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Sách tôi đã mượn</p>
                                </div>
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">Xem Lịch sử</a>
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
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">Yêu cầu Sách của tôi</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2" style="font-size: 12px;">
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
