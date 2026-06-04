<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <%-- ════════════════ BODY WRAPPER ════════════════ --%>
    <div class="d-flex main-wrapper overflow-hidden">

        <%-- ════════════════ MAIN CONTENT ════════════════ --%>
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb; margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-xl px-4 pb-5 pt-4" style="max-width: 1280px;">

                <%-- ─── Alert Messages ─── --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <%-- ─── Page Header ─── --%>
                <header class="mb-5">
                    <h1 class="fw-bold text-dark mb-1" style="font-size: 32px; letter-spacing: -0.01em;">My Academic Borrows</h1>
                    <p class="mb-0" style="color: #584237;">Review your current loans, research materials, and managed course reserves.</p>
                </header>

                <%-- ─── Summary Cards Bento Grid ─── --%>
                <div class="row g-4 mb-5">
                    <div class="col-12 col-md-4">
                        <div class="card-bento d-flex align-items-center justify-content-between border-start border-4" style="border-color: #9d4300 !important;">
                            <div>
                                <p class="small text-uppercase mb-1" style="font-size: 12px; font-weight: 600; letter-spacing: 0.05em; color: #584237;">Active Loans</p>
                                <h3 class="fw-bold text-dark mb-0" style="font-size: 24px;">
                                    <c:out value="${activeLoans != null ? activeLoans : '12'}" />
                                </h3>
                            </div>
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 3rem; height: 3rem; background-color: rgba(255, 219, 202, 0.6); color: #9d4300;">
                                <span class="material-symbols-outlined">book</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="card-bento d-flex align-items-center justify-content-between border-start border-4" style="border-color: #ba1a1a !important;">
                            <div>
                                <p class="small text-uppercase mb-1" style="font-size: 12px; font-weight: 600; letter-spacing: 0.05em; color: #584237;">Overdue Items</p>
                                <h3 class="fw-bold text-dark mb-0" style="font-size: 24px;">
                                    <c:out value="${overdueCount != null ? overdueCount : '2'}" />
                                </h3>
                            </div>
                            <div class="rounded-circle d-flex align-items-center justify-content-center text-danger" style="width: 3rem; height: 3rem; background-color: #ffdad6;">
                                <span class="material-symbols-outlined">warning</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="card-bento d-flex align-items-center justify-content-between border-start border-4" style="border-color: #006398 !important;">
                            <div>
                                <p class="small text-uppercase mb-1" style="font-size: 12px; font-weight: 600; letter-spacing: 0.05em; color: #584237;">Course Reserves</p>
                                <h3 class="fw-bold text-dark mb-0" style="font-size: 24px;">
                                    <c:out value="${courseReserves != null ? courseReserves : '8'}" />
                                </h3>
                            </div>
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 3rem; height: 3rem; background-color: rgba(205, 229, 255, 0.6); color: #006398;">
                                <span class="material-symbols-outlined">bookmark</span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ─── Currently Borrowed Section (Research Grid) ─── --%>
                <section class="mb-5">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h2 class="h5 fw-bold text-dark mb-0" style="font-size: 20px;">Currently Borrowed (Research)</h2>
                        <button class="btn btn-link text-primary-custom p-0 fw-bold border-0 text-decoration-none small">View All Research Materials</button>
                    </div>

                    <div class="row g-4">
                        <c:choose>
                            <c:when test="${not empty currentBorrows}">
                                <c:forEach var="borrow" items="${currentBorrows}">
                                    <div class="col-12 col-md-6 col-lg-4">
                                        <div class="card-bento p-0 overflow-hidden d-flex h-100 hover-scale-card">
                                            <div class="book-cover-wrapper position-relative">
                                                <img class="book-cover-img"
                                                     alt="<c:out value='${borrow.bookTitle}' />"
                                                     src="<c:out value='${borrow.bookCoverUrl}' />" />
                                                <c:if test="${borrow.overdue}">
                                                    <span class="position-absolute top-0 start-0 m-2 badge rounded-pill bg-danger" style="font-size: 10px;">OVERDUE</span>
                                                </c:if>
                                            </div>
                                            <div class="p-3 d-flex flex-column justify-content-between flex-grow-1">
                                                <div>
                                                    <h4 class="fw-bold text-dark lh-sm mb-1" style="font-size: 16px;"><c:out value="${borrow.bookTitle}" /></h4>
                                                    <p class="small fst-italic mb-2" style="color: #584237;">by <c:out value="${borrow.bookAuthor}" /></p>
                                                    <div class="d-flex align-items-center gap-1 small ${borrow.overdue ? 'text-danger' : ''} fw-bold">
                                                        <span class="material-symbols-outlined" style="font-size: 16px;">calendar_today</span>
                                                        Due: <fmt:formatDate value="${borrow.dueDate}" pattern="MMM dd, yyyy" />
                                                    </div>
                                                    <c:if test="${not borrow.overdue}">
                                                        <div class="progress mt-2" style="height: 4px;">
                                                            <div class="progress-bar" role="progressbar"
                                                                 style="width: ${borrow.progressPercent}%; background-color: #9d4300;"></div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="d-flex gap-2 mt-3">
                                                    <form action="${pageContext.request.contextPath}/lecturer/borrow-renew" method="post" class="flex-grow-1">
                                                        <input type="hidden" name="borrowId" value="${borrow.borrowId}" />
                                                        <button class="btn btn-sm text-white w-100 fw-bold" style="background-color: #f97316; font-size: 11px; padding: 0.4rem;" type="submit">RENEW</button>
                                                    </form>
                                                    <a href="${pageContext.request.contextPath}/lecturer/return?borrowId=${borrow.borrowId}"
                                                       class="btn btn-sm btn-outline-secondary flex-grow-1 fw-bold text-decoration-none text-center"
                                                       style="font-size: 11px; padding: 0.4rem; color: #584237;">RETURN</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <%-- Placeholder cards --%>
                                <div class="col-12 col-md-6 col-lg-4">
                                    <div class="card-bento p-0 overflow-hidden d-flex h-100 hover-scale-card">
                                        <div class="book-cover-wrapper position-relative">
                                            <img class="book-cover-img" alt="Cognitive Architectures"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuDmrDnfBNEnUBEWIG_dULy2_qBwMgEsBs1fR-zq8tAvklPKoJhYhB06ey1M1itWN5bWu1kEcIJo_iHVGYmnCd22I4Gfl6pD12H42FTRIjTZ8AKcIQ-cYhxV6L3r_81UJyfVX4bCGnMdV1eobPiz6RxXMH2WnmvHHhgxiVAms_7bbGK-bBsbUsVdBOmZdKOqSz4rAjg_cEIUCPAtcHxIkuv2FUu2RiAtVGdtLfFB-iq9kavXRtKhbH-ZI1JMh6jwinqP80PIkA3_R5o" />
                                            <span class="position-absolute top-0 start-0 m-2 badge rounded-pill bg-danger" style="font-size: 10px;">OVERDUE</span>
                                        </div>
                                        <div class="p-3 d-flex flex-column justify-content-between flex-grow-1">
                                            <div>
                                                <h4 class="fw-bold text-dark lh-sm mb-1" style="font-size: 16px;">Cognitive Architectures</h4>
                                                <p class="small fst-italic mb-2" style="color: #584237;">by Dr. Julian Vance</p>
                                                <div class="d-flex align-items-center gap-1 text-danger small fw-bold">
                                                    <span class="material-symbols-outlined" style="font-size: 16px;">calendar_today</span> Due: Oct 12, 2023
                                                </div>
                                            </div>
                                            <div class="d-flex gap-2 mt-3">
                                                <button class="btn btn-sm text-white flex-grow-1 fw-bold" style="background-color: #f97316; font-size: 11px; padding: 0.4rem;">RENEW</button>
                                                <button class="btn btn-sm btn-outline-secondary flex-grow-1 fw-bold" style="font-size: 11px; padding: 0.4rem; color: #584237;">RETURN</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 col-lg-4">
                                    <div class="card-bento p-0 overflow-hidden d-flex h-100 hover-scale-card">
                                        <div class="book-cover-wrapper">
                                            <img class="book-cover-img" alt="Principles of Digital Ethics"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuDZtG2jdhDjvim1TxNkCfkgVhHDRBKOxbm9pSNlOqM333nR871yyBdJneeo8pllzMbejGMxX-_14EJNXD3M3BKPPA-jv98fxZlgnKx8LrpV8WtscNU6z8htQOiuInTw7Sal6P1FcBbt3PK3VSQwYJP8J0nXv-wxiNw8OhNY8-BRLCE4wFAJw2yQGiuyJtkN5GWkglqN0joMOzK-VM8adGZjBzcZ97ImU8ORgtdv9sHjj451oeGyr4B1ZJYCMU_4Ovw1hYp1uQVy12I" />
                                        </div>
                                        <div class="p-3 d-flex flex-column justify-content-between flex-grow-1">
                                            <div>
                                                <h4 class="fw-bold text-dark lh-sm mb-1" style="font-size: 16px;">Principles of Digital Ethics</h4>
                                                <p class="small fst-italic mb-2" style="color: #584237;">by Sarah Jenkins</p>
                                                <div class="d-flex align-items-center gap-1 small" style="color: #584237;">
                                                    <span class="material-symbols-outlined" style="font-size: 16px;">calendar_today</span> Due: Nov 28, 2023
                                                </div>
                                                <div class="progress mt-2" style="height: 4px;">
                                                    <div class="progress-bar" role="progressbar" style="width: 65%; background-color: #9d4300;"></div>
                                                </div>
                                            </div>
                                            <div class="d-flex gap-2 mt-3">
                                                <button class="btn btn-sm text-white flex-grow-1 fw-bold" style="background-color: #f97316; font-size: 11px; padding: 0.4rem;">RENEW</button>
                                                <button class="btn btn-sm btn-outline-secondary flex-grow-1 fw-bold" style="font-size: 11px; padding: 0.4rem; color: #584237;">RETURN</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 col-lg-4">
                                    <div class="card-bento p-0 overflow-hidden d-flex h-100 hover-scale-card">
                                        <div class="book-cover-wrapper">
                                            <img class="book-cover-img" alt="Neural Network History"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuCGtyr85OerToXkzOzlaVEMKk9MPArkPmYTuRILz7cGS3Qjr0Yo86CruiLVCUNJk66dlBJKV927gDbQY6N2zFm3utDRVE0B_eruYBTvanGDGmlZhzvtFZmxLZ8VBva046ICMMOFSBPnpbGbxC4sUJJrE8FptYDvMl12p8mA_akq1qiZ9Cj0kzTSSDOFyP2J1TZs77pv_4OJMxXRGi4JG7HgUZJokjJumb5NfND7YRfUMncEAFfcfNuOPEpzmILaHLGIPcd1QBwtpZM" />
                                        </div>
                                        <div class="p-3 d-flex flex-column justify-content-between flex-grow-1">
                                            <div>
                                                <h4 class="fw-bold text-dark lh-sm mb-1" style="font-size: 16px;">Neural Network History</h4>
                                                <p class="small fst-italic mb-2" style="color: #584237;">by Alan Turing Inst.</p>
                                                <div class="d-flex align-items-center gap-1 small" style="color: #584237;">
                                                    <span class="material-symbols-outlined" style="font-size: 16px;">calendar_today</span> Due: Dec 05, 2023
                                                </div>
                                                <div class="progress mt-2" style="height: 4px;">
                                                    <div class="progress-bar" role="progressbar" style="width: 30%; background-color: #9d4300;"></div>
                                                </div>
                                            </div>
                                            <div class="d-flex gap-2 mt-3">
                                                <button class="btn btn-sm text-white flex-grow-1 fw-bold" style="background-color: #f97316; font-size: 11px; padding: 0.4rem;">RENEW</button>
                                                <button class="btn btn-sm btn-outline-secondary flex-grow-1 fw-bold" style="font-size: 11px; padding: 0.4rem; color: #584237;">RETURN</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <%-- ─── Course Reserves Table Section (Fragment) ─── --%>
                <jsp:include page="fragments/_course-reserves-table.jsp" />

                <%-- ─── Recent History List ─── --%>
                <section class="mb-4">
                    <h2 class="h5 fw-bold text-dark mb-4" style="font-size: 20px;">Recent History</h2>
                    <div class="d-flex flex-column gap-3">
                        <c:choose>
                            <c:when test="${not empty borrowHistory}">
                                <c:forEach var="hist" items="${borrowHistory}">
                                    <div class="card-bento p-3 border d-flex flex-row align-items-center justify-content-between hover-scale-card" style="cursor: pointer;">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-circle bg-light d-flex align-items-center justify-content-center text-secondary" style="width: 2.5rem; height: 2.5rem;">
                                                <span class="material-symbols-outlined text-success" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                            </div>
                                            <div>
                                                <h4 class="fw-bold text-dark mb-0" style="font-size: 16px;"><c:out value="${hist.bookTitle}" /></h4>
                                                <p class="small mb-0" style="font-size: 12px; color: #584237;">
                                                    Returned on <fmt:formatDate value="${hist.returnDate}" pattern="MMM dd, yyyy" />
                                                </p>
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/lecturer/borrow-receipt?id=${hist.borrowId}"
                                           class="small fw-bold text-decoration-none" style="color: #584237;">View Receipt</a>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="card-bento p-3 border d-flex flex-row align-items-center justify-content-between hover-scale-card" style="cursor: pointer;">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 2.5rem; height: 2.5rem;">
                                            <span class="material-symbols-outlined text-success" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        </div>
                                        <div>
                                            <h4 class="fw-bold text-dark mb-0" style="font-size: 16px;">Quantum Field Theory</h4>
                                            <p class="small mb-0" style="font-size: 12px; color: #584237;">Returned on Oct 14, 2023</p>
                                        </div>
                                    </div>
                                    <span class="small fw-bold" style="color: #584237;">View Receipt</span>
                                </div>
                                <div class="card-bento p-3 border d-flex flex-row align-items-center justify-content-between hover-scale-card" style="cursor: pointer;">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 2.5rem; height: 2.5rem;">
                                            <span class="material-symbols-outlined text-success" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        </div>
                                        <div>
                                            <h4 class="fw-bold text-dark mb-0" style="font-size: 16px;">Sociology of Education</h4>
                                            <p class="small mb-0" style="font-size: 12px; color: #584237;">Returned on Sep 28, 2023</p>
                                        </div>
                                    </div>
                                    <span class="small fw-bold" style="color: #584237;">View Receipt</span>
                                </div>
                                <div class="card-bento p-3 border d-flex flex-row align-items-center justify-content-between hover-scale-card" style="cursor: pointer;">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 2.5rem; height: 2.5rem;">
                                            <span class="material-symbols-outlined text-success" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        </div>
                                        <div>
                                            <h4 class="fw-bold text-dark mb-0" style="font-size: 16px;">Macroeconomics 101</h4>
                                            <p class="small mb-0" style="font-size: 12px; color: #584237;">Returned on Sep 15, 2023</p>
                                        </div>
                                    </div>
                                    <span class="small fw-bold" style="color: #584237;">View Receipt</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- FAB button --%>
<button class="fab-button" title="Add Course Document"
        onclick="location.href='${pageContext.request.contextPath}/lecturer/course-reserves'">
    <span class="material-symbols-outlined">post_add</span>
</button>

<%-- Page-specific styles --%>
<style>
    .text-primary-custom { color: #9d4300; }
    .card-bento {
        background-color: #ffffff; border: none;
        border-radius: 0.75rem; box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.04);
        padding: 1.5rem;
    }
    .book-cover-wrapper { width: 7rem; flex-shrink: 0; position: relative; }
    .book-cover-img { height: 100%; width: 100%; object-fit: cover; }
    .hover-scale-card { transition: transform 0.3s ease; }
    .hover-scale-card:hover { transform: scale(1.02); }
    .fab-button {
        position: fixed; bottom: 2rem; right: 2rem;
        width: 3.5rem; height: 3.5rem;
        background-color: #9d4300; color: #ffffff; border-radius: 50%; border: none;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.15);
        display: flex; align-items: center; justify-content: center;
        font-size: 1.5rem; z-index: 1050; transition: all 0.2s ease;
    }
    .fab-button:hover { transform: scale(1.1); color: #ffffff; }
    .fab-button:active { transform: scale(0.95); }
</style>

</html>
