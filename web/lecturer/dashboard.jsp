<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto" style="background-color: var(--background); margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Welcome Banner ─── -->
                <div class="raised-card p-4 mb-4 d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, var(--primary-fixed) 0%, var(--secondary-fixed) 100%); border-color: var(--outline-variant);">
                    <div>
                        <h2 class="fw-semibold mb-1" style="font-size: 22px; color: var(--on-primary-container);">
                            Welcome back, <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Lecturer'}" />
                        </h2>
                        <p class="mb-0" style="font-size: 14px; color: var(--on-secondary-fixed-variant);">
                            Manage your course reading lists, borrowing activity, and research materials.
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
                                    <span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Active</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Active Loans</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${activeLoansCount != null ? activeLoansCount : '3'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">of 10 allowed</p>
                            </div>
                        </div>
                        <!-- Course Reading Lists -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed);">article</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">
                                        <c:out value="${courseCount != null ? courseCount : '4'}" /> Courses
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Reading Lists</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${readingListCount != null ? readingListCount : '12'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Total curated titles</p>
                            </div>
                        </div>
                        <!-- Pending Requests -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7;">pending_actions</span>
                                    <span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Awaiting</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Pending Requests</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">
                                    <c:out value="${pendingRequestsCount != null ? pendingRequestsCount : '2'}" />
                                </h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Book acquisition requests</p>
                            </div>
                        </div>
                        <!-- Outstanding Fines -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--success); background-color: #d1fae5;">payments</span>
                                    <span class="badge-pill" style="color: var(--success); background-color: #d1fae5;">Clear</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Outstanding Fines</p>
                                <h3 class="fw-semibold mb-1" style="font-size: 28px; color: var(--on-surface);">0đ</h3>
                                <p style="font-size: 12px; color: var(--success); margin: 0; font-weight: 600;">Account in good standing</p>
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
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">My Courses</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Semester 1 — 2025 academic year</p>
                                </div>
                                <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">add</span> Request Book
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
                            <p class="fw-semibold text-on-surface-variant text-uppercase mb-2" style="font-size: 10px; letter-spacing: 0.1em;">Course Reading List — SWP391</p>
                            <div class="d-flex flex-column gap-2">
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed); flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Software Engineering: A Practitioner's Approach</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Roger S. Pressman — 8th Edition</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: #d1fae5; color: #059669; flex-shrink: 0;">Available</span>
                                </div>
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed); flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Agile Estimating and Planning</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Mike Cohn — Prentice Hall</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--primary); flex-shrink: 0;">On Loan</span>
                                </div>
                                <div class="resource-card">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7; flex-shrink: 0;">book</span>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">The Mythical Man-Month</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Frederick P. Brooks Jr. — Addison-Wesley</p>
                                    </div>
                                    <span class="badge-pill" style="background-color: #d1fae5; color: #059669; flex-shrink: 0;">Available</span>
                                </div>
                            </div>
                        </div>

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center bg-white"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">My Current Loans</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Books I have borrowed</p>
                                </div>
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">View History</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Book</th>
                                            <th>Issue Date</th>
                                            <th>Due Date</th>
                                            <th>Status</th>
                                            <th class="text-end">Action</th>
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
                                                        <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Active</span></td>
                                                        <td class="text-end">
                                                            <button class="btn-icon" title="Renew"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button>
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
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Active</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Renew"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;">Design Patterns</p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Gang of Four · ISBN 978-0201633610</p>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">20/05/2025</td>
                                                    <td style="font-size: 13px;">10/06/2025</td>
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Active</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Renew"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <p class="fw-bold mb-0" style="font-size: 13px;">The Pragmatic Programmer</p>
                                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Hunt &amp; Thomas · ISBN 978-0135957059</p>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">25/05/2025</td>
                                                    <td style="font-size: 13px; color: #d97706; font-weight: 600;">15/06/2025</td>
                                                    <td><span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Due Soon</span></td>
                                                    <td class="text-end"><button class="btn-icon" style="color: var(--primary);" title="Renew"><span class="material-symbols-outlined" style="font-size: 18px;">autorenew</span></button></td>
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
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">My Book Requests</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">add</span> New Request
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Continuous Delivery</p>
                                        <span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">Review</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Jez Humble, David Farley</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;">Requested: 28/05/2025</p>
                                </div>
                                <div class="p-3 rounded-3" style="background-color: rgba(209,250,229,0.3); border: 1px solid #a7f3d0;">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Release It!</p>
                                        <span class="badge-pill" style="background-color: #d1fae5; color: #059669;">Approved</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Michael T. Nygard</p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 11px;">ETA: 10/06/2025</p>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Profile Card -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="avatar" style="width: 52px; height: 52px; font-size: 18px; background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.email}">
                                            <c:out value="${fn:substring(sessionScope.email,0,2).toUpperCase()}" default="LC" />
                                        </c:when>
                                        <c:otherwise>LC</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="fw-bold mb-0" style="font-size: 15px;"><c:out value="${not empty sessionScope.email ? sessionScope.email : 'Lecturer'}" /></p>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Faculty Member · FPT University</p>
                                </div>
                            </div>
                            <div class="d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Loan Quota Used</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--primary);">
                                        <c:out value="${activeLoansCount != null ? activeLoansCount : '3'}" /> / 10
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Library Standing</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--success);">Good</span>
                                </div>
                                <div class="d-flex justify-content-between p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <span style="font-size: 13px; color: var(--on-surface-variant);">Access Level</span>
                                    <span style="font-size: 13px; font-weight: 700; color: var(--tertiary);">Academic Staff</span>
                                </div>
                            </div>
                            <a href="#" class="btn btn-sm w-100 mt-3 rounded-3 fw-bold"
                               style="background-color: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                View Full Profile
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
