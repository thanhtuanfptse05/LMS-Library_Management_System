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
        <main class="flex-grow-1 overflow-y-auto"
              style="background-color: var(--background); margin-left: 256px; max-width: 1400px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="p-3 p-md-4">

                <%-- ─── Alert Messages ─── --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <%-- ─── Bento Grid Layout ─── --%>
                <div class="row g-4 mb-4">

                    <%-- Book Header Detail (Large Left Card) --%>
                    <section class="col-12 col-lg-8">
                        <div class="bg-lowest p-4 rounded-3 border h-100 d-flex flex-column flex-md-row gap-4"
                             style="border-color: var(--surface-container-high) !important; box-shadow: 0 4px 15px rgba(0,0,0,0.04);">
                            <div class="flex-shrink-0" style="width: 160px;">
                                <img class="w-100 rounded-3 shadow-sm border"
                                     style="aspect-ratio: 3/4; object-fit: cover; border-color: var(--outline-variant) !important;"
                                     alt="Book Cover"
                                     src="${not empty reservation.bookCoverUrl ? reservation.bookCoverUrl : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBYGevQcDjdis4VdsuZBAu7KKFO9QtPkunlJ192hDcQNHlBRPMWcj0v0Bdld5deNjLs_Yp-qlAI-jxRNjPH8ojAKDHjrIxWdkU9QLbhemvdP6tSq_M0vT39GjKqJZgMQOUPXFA3YVLo5mQm3u6scfE-YmCLXHFAPbg-XAKuT1JbyG3J6NdpKhxfCAGuTB0upShOTJ85N9O1crEqj31qELwmaw3bXghf2b5g1fYKJOPJctkOg7SM_10QVFYh1je1cQuMzxTVgGP3ZTg'}" />
                            </div>
                            <div class="flex-grow-1 d-flex flex-column justify-content-between">
                                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                    <div>
                                        <span class="badge font-label-md rounded-pill px-3 py-1 mb-2 border-0"
                                              style="background-color: rgba(157,67,0,0.1); color: var(--primary); font-size: 10px;">HIGH DEMAND</span>
                                        <h3 class="font-headline-md text-dark mb-1">
                                            <c:out value="${not empty reservation.bookTitle ? reservation.bookTitle : 'Advanced Quantum Mechanics'}" />
                                        </h3>
                                        <p class="font-body-md text-secondary-custom mb-0">
                                            by <c:out value="${not empty reservation.bookAuthor ? reservation.bookAuthor : 'Prof. Julian Sterling'}" />
                                            &bull; <c:out value="${not empty reservation.bookEdition ? reservation.bookEdition : '2023 Edition'}" />
                                        </p>
                                    </div>
                                    <div class="text-md-end">
                                        <p class="font-label-md text-secondary-custom mb-0">ISBN-13</p>
                                        <p class="font-body-sm fw-semibold text-dark mb-0">
                                            <c:out value="${not empty reservation.isbn ? reservation.isbn : '978-3-16-148410-0'}" />
                                        </p>
                                    </div>
                                </div>

                                <div class="row g-2 mt-3">
                                    <div class="col-4">
                                        <div class="bg-light p-2 rounded-3 border" style="border-color: var(--surface-container-high) !important;">
                                            <p class="mb-1 text-secondary-custom fw-bold" style="font-size: 10px;">TOTAL RESERVED</p>
                                            <p class="font-headline-md text-primary-custom mb-0">
                                                <c:out value="${not empty totalReserved ? totalReserved : '24'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="bg-light p-2 rounded-3 border" style="border-color: var(--surface-container-high) !important;">
                                            <p class="mb-1 text-secondary-custom fw-bold" style="font-size: 10px;">ACTIVE LOANS</p>
                                            <p class="font-headline-md text-secondary-custom mb-0">
                                                <c:out value="${not empty activeLoans ? activeLoans : '12'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="bg-light p-2 rounded-3 border" style="border-color: var(--surface-container-high) !important;">
                                            <p class="mb-1 text-secondary-custom fw-bold" style="font-size: 10px;">WAIT TIME (EST.)</p>
                                            <p class="font-headline-md mb-0" style="color: var(--on-tertiary-fixed-variant);">
                                                <c:out value="${not empty estimatedWait ? estimatedWait : '14 Days'}" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- Available Copies Panel (Right Side Panel) --%>
                    <section class="col-12 col-lg-4">
                        <div class="bg-low p-4 rounded-3 border h-100 d-flex flex-column"
                             style="border-color: var(--surface-container-high) !important;">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="font-title-lg text-dark mb-0 d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined text-primary-custom">inventory_2</span> Available Stock
                                </h4>
                                <span class="badge font-label-md px-2 py-1 rounded border-0 text-white"
                                      style="background-color: var(--primary-container); font-size: 10px;">
                                    <c:out value="${availableCopies != null ? availableCopies : '3'}" /> READY
                                </span>
                            </div>

                            <div class="d-flex flex-column gap-2 flex-grow-1 custom-scrollbar overflow-y-auto pe-1"
                                 style="max-height: 220px;">
                                <c:choose>
                                    <c:when test="${not empty bookCopies}">
                                        <c:forEach var="copy" items="${bookCopies}">
                                            <div class="stock-card p-3 rounded-3 shadow-sm border-start border-4"
                                                 style="border-left-color: ${copy.available ? 'var(--primary)' : 'var(--outline)'} !important;
                                                        ${!copy.available ? 'opacity: 0.5; cursor: not-allowed;' : 'cursor: pointer;'}">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <p class="font-label-md text-dark fw-bold mb-0">#<c:out value="${copy.barcode}" /></p>
                                                        <p class="mb-0 text-secondary-custom" style="font-size: 10px;"><c:out value="${copy.location}" /></p>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${copy.available}">
                                                            <button class="btn btn-sm rounded-circle p-1 border-0 d-flex align-items-center justify-content-center"
                                                                    style="background-color: rgba(157,67,0,0.05); color: var(--primary); width: 28px; height: 28px;"
                                                                    onclick="selectCopy('${copy.barcode}')">
                                                                <span class="material-symbols-outlined" style="font-size: 18px;">arrow_forward</span>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="material-symbols-outlined text-secondary-custom" style="font-size: 18px;">build</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <c:if test="${copy.returnedToday}">
                                                    <div class="mt-2 d-flex align-items-center gap-2">
                                                        <span class="text-success d-flex align-items-center gap-1 fw-semibold" style="font-size: 10px;">
                                                            <span class="rounded-circle d-inline-block bg-success" style="width: 6px; height: 6px;"></span> Returned Today
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Sample stock cards --%>
                                        <div class="stock-card p-3 rounded-3 shadow-sm border-start border-4" style="border-left-color: var(--primary) !important; cursor: pointer;">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <p class="font-label-md text-dark fw-bold mb-0">#LUM-8829-X</p>
                                                    <p class="mb-0 text-secondary-custom" style="font-size: 10px;">Floor 2, Shelf A4</p>
                                                </div>
                                                <button class="btn btn-sm rounded-circle p-1 border-0 d-flex align-items-center justify-content-center"
                                                        style="background-color: rgba(157,67,0,0.05); color: var(--primary); width: 28px; height: 28px;"
                                                        onclick="selectCopy('LUM-8829-X')">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">arrow_forward</span>
                                                </button>
                                            </div>
                                            <div class="mt-2 d-flex align-items-center gap-2">
                                                <span class="text-success d-flex align-items-center gap-1 fw-semibold" style="font-size: 10px;">
                                                    <span class="rounded-circle d-inline-block bg-success" style="width: 6px; height: 6px;"></span> Returned Today
                                                </span>
                                            </div>
                                        </div>
                                        <div class="stock-card p-3 rounded-3 shadow-sm border-start border-4" style="border-left-color: var(--primary) !important; cursor: pointer;">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <p class="font-label-md text-dark fw-bold mb-0">#LUM-4112-Q</p>
                                                    <p class="mb-0 text-secondary-custom" style="font-size: 10px;">Collection Desk</p>
                                                </div>
                                                <button class="btn btn-sm rounded-circle p-1 border-0 d-flex align-items-center justify-content-center"
                                                        style="background-color: rgba(157,67,0,0.05); color: var(--primary); width: 28px; height: 28px;"
                                                        onclick="selectCopy('LUM-4112-Q')">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">arrow_forward</span>
                                                </button>
                                            </div>
                                        </div>
                                        <div class="stock-card p-3 rounded-3 shadow-sm border-start border-4 opacity-50" style="border-left-color: var(--outline) !important; cursor: not-allowed;">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <p class="font-label-md text-dark fw-bold mb-0">#LUM-9003-B</p>
                                                    <p class="mb-0 text-secondary-custom" style="font-size: 10px;">Maintenance</p>
                                                </div>
                                                <span class="material-symbols-outlined text-secondary-custom" style="font-size: 18px;">build</span>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>
                </div>

                <%-- ─── Queue Management Table (Main Bottom Section) ─── --%>
                <section class="card border-0 rounded-3 overflow-hidden mb-4"
                         style="box-shadow: 0 4px 15px rgba(0,0,0,0.04); border: 1px solid var(--surface-container-high) !important;">
                    <div class="card-header bg-lowest p-3 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3"
                         style="border-color: var(--surface-container-high) !important;">
                        <h4 class="font-title-lg text-dark mb-0">Queue Management</h4>
                        <div class="d-flex gap-2 flex-wrap">
                            <div class="position-relative">
                                <input class="form-control bg-low border-0 rounded-3 py-2 font-body-sm shadow-none"
                                       style="padding-left: 2.5rem; width: 240px;"
                                       placeholder="Search members..."
                                       type="text"
                                       id="queue_search" />
                                <span class="material-symbols-outlined position-absolute start-0 top-50 translate-middle-y ms-3 text-secondary-custom opacity-75">search</span>
                            </div>
                            <select class="form-select bg-low border-0 rounded-3 py-2 font-body-sm text-secondary-custom shadow-none"
                                    style="width: 130px;" id="priority_filter">
                                <option value="">All Status</option>
                                <option value="URGENT">Urgent</option>
                                <option value="NORMAL">Normal</option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-start">
                            <thead>
                                <tr class="bg-light text-secondary-custom font-label-md border-bottom"
                                    style="font-size: 12px; border-color: var(--surface-container-high) !important;">
                                    <th class="p-3 fw-bold border-0">Pos</th>
                                    <th class="p-3 fw-bold border-0">Name</th>
                                    <th class="p-3 fw-bold border-0">Member Type</th>
                                    <th class="p-3 fw-bold border-0">Request Date</th>
                                    <th class="p-3 fw-bold border-0">Priority Status</th>
                                    <th class="p-3 fw-bold border-0">Action</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider border-0">
                                <c:choose>
                                    <c:when test="${not empty queueList}">
                                        <c:forEach var="q" items="${queueList}" varStatus="loop">
                                            <tr class="border-bottom" style="border-color: var(--surface-container-high) !important;">
                                                <td class="p-3">
                                                    <span class="rounded-circle text-white d-flex align-items-center justify-content-center fw-bold"
                                                          style="width: 32px; height: 32px;
                                                                 background-color: ${loop.index == 0 ? 'var(--primary-container)' : 'var(--surface-container-high)'};
                                                                 color: ${loop.index == 0 ? '#ffffff' : 'var(--on-surface)'}; font-size: 12px;">
                                                        <c:out value="${loop.count}" />
                                                    </span>
                                                </td>
                                                <td class="p-3">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                             style="width: 32px; height: 32px; background-color: var(--secondary-container); color: var(--primary); font-size: 14px;">
                                                            <c:out value="${fn:substring(q.memberName,0,2)}" />
                                                        </div>
                                                        <div>
                                                            <p class="font-body-sm fw-semibold text-dark mb-0"><c:out value="${q.memberName}" /></p>
                                                            <p class="mb-0 text-secondary-custom" style="font-size: 10px;">M-ID: <c:out value="${q.memberId}" /></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="p-3">
                                                    <span class="badge text-dark font-body-sm px-2 py-1 border-0"
                                                          style="background-color: var(--surface-container-high); font-size: 10px; font-weight: 600;">
                                                        <c:out value="${q.memberType}" />
                                                    </span>
                                                </td>
                                                <td class="p-3 font-body-sm text-dark">
                                                    <fmt:formatDate value="${q.requestDate}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td class="p-3">
                                                    <c:choose>
                                                        <c:when test="${q.priority == 'URGENT'}">
                                                            <span class="text-danger fw-bold d-inline-flex align-items-center gap-1" style="font-size: 10px; letter-spacing: -0.02em;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px;">priority_high</span> Urgent / Research
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-secondary-custom opacity-50 fw-bold" style="font-size: 10px;">Normal</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="p-3">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <c:choose>
                                                            <c:when test="${loop.index == 0 and not empty availableCopyForAssign}">
                                                                <button class="btn btn-sm text-white fw-bold px-3 py-2 border-0 rounded-3"
                                                                        style="background-color: var(--primary); font-size: 11px;"
                                                                        onclick="assignCopy('${availableCopyForAssign}', '${q.memberId}')">
                                                                    Assign #<c:out value="${availableCopyForAssign}" />
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn btn-sm fw-bold border px-3 py-2 rounded-3 text-primary-custom"
                                                                        style="border-color: var(--outline) !important; font-size: 11px;">
                                                                    Assign Copy
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <button class="btn btn-link p-1 text-secondary-custom shadow-none border-0"
                                                                title="Send Notification">
                                                            <span class="material-symbols-outlined" style="font-size: 20px;">notifications</span>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Sample queue rows --%>
                                        <tr class="border-bottom" style="border-color: var(--surface-container-high) !important;">
                                            <td class="p-3">
                                                <span class="rounded-circle text-white d-flex align-items-center justify-content-center fw-bold"
                                                      style="width: 32px; height: 32px; background-color: var(--primary-container); font-size: 12px;">1</span>
                                            </td>
                                            <td class="p-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                         style="width: 32px; height: 32px; background-color: var(--secondary-container); color: var(--primary); font-size: 14px;">JD</div>
                                                    <div>
                                                        <p class="font-body-sm fw-semibold text-dark mb-0">Jonathan Doe</p>
                                                        <p class="mb-0 text-secondary-custom" style="font-size: 10px;">M-ID: 882019</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="p-3">
                                                <span class="badge text-dark font-body-sm px-2 py-1 border-0"
                                                      style="background-color: var(--surface-container-high); font-size: 10px; font-weight: 600;">Postgrad Student</span>
                                            </td>
                                            <td class="p-3 font-body-sm text-dark">Oct 12, 2023</td>
                                            <td class="p-3">
                                                <span class="text-danger fw-bold d-inline-flex align-items-center gap-1" style="font-size: 10px; letter-spacing: -0.02em;">
                                                    <span class="material-symbols-outlined" style="font-size: 14px;">priority_high</span> Urgent / Research
                                                </span>
                                            </td>
                                            <td class="p-3">
                                                <div class="d-flex align-items-center gap-2">
                                                    <button class="btn btn-sm text-white fw-bold px-3 py-2 border-0 rounded-3 btn-assign-trigger"
                                                            style="background-color: var(--primary); font-size: 11px;">
                                                        Assign #LUM-8829-X
                                                    </button>
                                                    <button class="btn btn-link p-1 text-secondary-custom shadow-none border-0">
                                                        <span class="material-symbols-outlined" style="font-size: 20px;">notifications</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="border-bottom" style="border-color: var(--surface-container-high) !important;">
                                            <td class="p-3">
                                                <span class="rounded-circle text-dark d-flex align-items-center justify-content-center fw-bold"
                                                      style="width: 32px; height: 32px; background-color: var(--surface-container-high); font-size: 12px;">2</span>
                                            </td>
                                            <td class="p-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                         style="width: 32px; height: 32px; background-color: var(--secondary-container); color: var(--primary); font-size: 14px;">ER</div>
                                                    <div>
                                                        <p class="font-body-sm fw-semibold text-dark mb-0">Dr. Elena Rodriguez</p>
                                                        <p class="mb-0 text-secondary-custom" style="font-size: 10px;">M-ID: 440211</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="p-3">
                                                <span class="badge text-dark font-body-sm px-2 py-1 border-0"
                                                      style="background-color: var(--surface-container-high); font-size: 10px; font-weight: 600;">Senior Faculty</span>
                                            </td>
                                            <td class="p-3 font-body-sm text-dark">Oct 14, 2023</td>
                                            <td class="p-3">
                                                <span class="text-secondary-custom opacity-50 fw-bold" style="font-size: 10px;">Normal</span>
                                            </td>
                                            <td class="p-3">
                                                <div class="d-flex align-items-center gap-2">
                                                    <button class="btn btn-sm fw-bold border px-3 py-2 rounded-3 text-primary-custom"
                                                            style="border-color: var(--outline) !important; font-size: 11px;">Assign Copy</button>
                                                    <button class="btn btn-link p-1 text-secondary-custom shadow-none border-0">
                                                        <span class="material-symbols-outlined" style="font-size: 20px;">notifications</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <div class="card-footer bg-lowest p-3 border-top d-flex justify-content-between align-items-center"
                         style="font-size: 11px; font-weight: 600; letter-spacing: 0.05em; border-color: var(--surface-container-high) !important;">
                        <span class="text-secondary-custom">
                            Showing 1-<c:out value="${queueList != null ? queueList.size() : '3'}" />
                            of <c:out value="${totalReserved != null ? totalReserved : '24'}" /> members
                        </span>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm p-0 rounded border d-flex align-items-center justify-content-center shadow-none"
                                    style="width: 32px; height: 32px; border-color: var(--outline-variant) !important; cursor: not-allowed; opacity: 0.5;" disabled>
                                <span class="material-symbols-outlined" style="font-size: 18px;">chevron_left</span>
                            </button>
                            <button class="btn btn-sm p-0 rounded border d-flex align-items-center justify-content-center shadow-none"
                                    style="width: 32px; height: 32px; border-color: var(--outline-variant) !important; transition: background-color 0.2s;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">chevron_right</span>
                            </button>
                        </div>
                    </div>
                </section>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Toast Notification --%>
<div id="toast">
    <span class="material-symbols-outlined text-success">check_circle</span>
    <span class="font-body-sm" id="toast-message">Assignment successful!</span>
</div>

<%-- Page-specific styles --%>
<style>
    .font-headline-md { font-size: 24px; line-height: 32px; font-weight: 600; }
    .font-headline-lg { font-size: 32px; line-height: 40px; letter-spacing: -0.01em; font-weight: 600; }
    .font-title-lg { font-size: 20px; line-height: 28px; font-weight: 600; }
    .font-body-md { font-size: 16px; line-height: 24px; font-weight: 400; }
    .font-body-sm { font-size: 14px; line-height: 20px; font-weight: 400; }
    .font-label-md { font-size: 12px; line-height: 16px; letter-spacing: 0.05em; font-weight: 600; }
    .bg-lowest { background-color: var(--surface-container-lowest); }
    .bg-low { background-color: var(--surface-container-low); }
    .text-primary-custom { color: var(--primary); }
    .text-secondary-custom { color: var(--secondary); }
    .custom-scrollbar::-webkit-scrollbar { width: 6px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e0e3e5; border-radius: 10px; }
    .stock-card {
        background-color: var(--surface-container-lowest);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .stock-card:hover { transform: translateX(4px); }
    #toast {
        position: fixed; bottom: 24px; right: 24px;
        background-color: var(--inverse-surface); color: var(--inverse-on-surface);
        padding: 12px 24px; border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        display: flex; align-items: center; gap: 8px;
        transform: translateY(100px); opacity: 0;
        transition: all 0.3s ease; z-index: 1050;
    }
    #toast.show { transform: translateY(0); opacity: 1; }
</style>

<script>
    function showToast(msg) {
        const toast = document.getElementById('toast');
        document.getElementById('toast-message').innerText = msg;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    }

    function selectCopy(barcode) {
        showToast('Copy #' + barcode + ' selected for manual assignment');
    }

    function assignCopy(barcode, memberId) {
        showToast('Assignment of #' + barcode + ' to member ' + memberId + ' successful!');
    }

    // Assign button click for sample row
    document.querySelectorAll('.btn-assign-trigger').forEach(btn => {
        btn.onclick = () => showToast('Assignment successful!');
    });

    // Stock card click for sample cards
    document.querySelectorAll('.stock-card:not(.opacity-50)').forEach(card => {
        card.onclick = () => showToast('Copy selected for manual assignment');
    });
</script>

</html>
