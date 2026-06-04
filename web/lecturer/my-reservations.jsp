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

            <div class="p-3 p-lg-4" style="max-width: 1200px; margin: 0 auto;">

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
                <div class="mb-4 d-flex flex-column flex-md-row justify-content-between gap-3">
                    <div>
                        <h3 class="fw-bold text-dark mb-1" style="font-size: 32px; letter-spacing: -0.01em;">My Reservations</h3>
                        <p class="text-muted mb-0">Manage your active book reservations for both departmental research and upcoming course materials.</p>
                    </div>
                    <div class="d-flex align-self-start align-self-md-auto">
                        <div class="d-flex p-1 rounded-3" style="background-color: #eceef0;">
                            <button class="btn-switch active" id="btn-active" onclick="filterTab('active')">Active</button>
                            <button class="btn-switch" id="btn-history" onclick="filterTab('history')">History</button>
                        </div>
                    </div>
                </div>

                <%-- ─── Stats Cards ─── --%>
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="card glass-card custom-shadow p-3 rounded-3 d-flex flex-row align-items-center gap-3">
                            <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 3rem; height: 3rem; background-color: rgba(249, 115, 22, 0.15); color: #9d4300;">
                                <span class="material-symbols-outlined">book</span>
                            </div>
                            <div>
                                <p class="text-muted small fw-semibold text-uppercase mb-0" style="font-size: 12px; letter-spacing: 0.05em;">Research Reserves</p>
                                <p class="h4 fw-bold mb-0" style="font-size: 24px; color: #9d4300;">
                                    <c:out value="${researchCount != null ? researchCount : '12'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card glass-card custom-shadow p-3 rounded-3 d-flex flex-row align-items-center gap-3">
                            <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 3rem; height: 3rem; background-color: rgba(0, 162, 244, 0.15); color: #006398;">
                                <span class="material-symbols-outlined">school</span>
                            </div>
                            <div>
                                <p class="text-muted small fw-semibold text-uppercase mb-0" style="font-size: 12px; letter-spacing: 0.05em;">Course Related</p>
                                <p class="h4 fw-bold mb-0" style="font-size: 24px; color: #006398;">
                                    <c:out value="${courseCount != null ? courseCount : '08'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card glass-card custom-shadow p-3 rounded-3 d-flex flex-row align-items-center gap-3">
                            <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 3rem; height: 3rem; background-color: rgba(86, 94, 116, 0.15); color: #565e74;">
                                <span class="material-symbols-outlined">hourglass_empty</span>
                            </div>
                            <div>
                                <p class="text-muted small fw-semibold text-uppercase mb-0" style="font-size: 12px; letter-spacing: 0.05em;">Pending Arrival</p>
                                <p class="h4 fw-bold text-dark mb-0" style="font-size: 24px;">
                                    <c:out value="${pendingCount != null ? pendingCount : '03'}" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ─── Reservation Table ─── --%>
                <div class="card bg-white rounded-3 custom-shadow overflow-hidden border border-light-subtle">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr class="border-bottom" style="border-bottom-color: rgba(140, 113, 100, 0.3) !important;">
                                    <th>Title &amp; Author</th>
                                    <th>Category</th>
                                    <th class="text-center">Position</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider" style="border-top-color: rgba(140, 113, 100, 0.2);">
                                <c:choose>
                                    <c:when test="${not empty reservationList}">
                                        <c:forEach var="res" items="${reservationList}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded shadow-sm flex-shrink-0 overflow-hidden" style="width: 3rem; height: 4rem;">
                                                            <img alt="<c:out value='${res.bookTitle}' />"
                                                                 src="<c:out value='${res.bookCoverUrl}' />"
                                                                 class="w-100 h-100 object-fit-cover" />
                                                        </div>
                                                        <div>
                                                            <p class="fw-bold text-dark mb-0" style="font-size: 16px;"><c:out value="${res.bookTitle}" /></p>
                                                            <p class="text-muted small mb-0"><c:out value="${res.bookAuthor}" /></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge px-3 py-2 rounded-pill"
                                                          style="background-color: ${res.category == 'RESEARCH' ? 'rgba(249, 115, 22, 0.1)' : 'rgba(0, 162, 244, 0.1)'};
                                                                 color: ${res.category == 'RESEARCH' ? '#9d4300' : '#006398'};
                                                                 border: 1px solid ${res.category == 'RESEARCH' ? 'rgba(249, 115, 22, 0.2)' : 'rgba(0, 162, 244, 0.2)'};
                                                                 font-size: 12px; font-weight: 600;">
                                                        <c:out value="${res.categoryLabel}" />
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${not empty res.queuePosition}">
                                                            <span class="h5 fw-bold mb-0" style="color: #9d4300;"><c:out value="${res.queuePosition}" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted opacity-50">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${res.status == 'ARRIVING_TOMORROW'}">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="spinner-grow spinner-grow-sm text-warning" role="status" style="width: 8px; height: 8px;"></span>
                                                                <span class="small fw-semibold text-dark">Arriving Tomorrow</span>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${res.status == 'READY'}">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="rounded-circle bg-success" style="width: 8px; height: 8px;"></div>
                                                                <span class="small fw-semibold text-dark">Ready for Pickup</span>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${res.status == 'IN_CIRCULATION'}">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="rounded-circle bg-warning" style="width: 8px; height: 8px;"></div>
                                                                <span class="small fw-semibold text-dark">In Circulation</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="d-flex flex-column" style="width: 100px;">
                                                                <span class="small text-muted mb-1" style="font-size: 11px; font-weight: 600;">Waitlist Active</span>
                                                                <div class="progress" style="height: 4px;">
                                                                    <div class="progress-bar" role="progressbar"
                                                                         style="width: ${res.waitlistPercent}%; background-color: #9d4300;"></div>
                                                                </div>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${res.status == 'READY' or res.status == 'ARRIVING_TOMORROW'}">
                                                            <button class="action-icon-btn btn-info" title="View Info">
                                                                <span class="material-symbols-outlined">info</span>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${pageContext.request.contextPath}/lecturer/reservation-cancel" method="post" style="display: inline;">
                                                                <input type="hidden" name="reservationId" value="${res.reservationId}" />
                                                                <button class="action-icon-btn btn-cancel" title="Cancel Reservation" type="submit"
                                                                        onclick="return confirm('Cancel this reservation?')">
                                                                    <span class="material-symbols-outlined">cancel</span>
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Sample rows --%>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded shadow-sm flex-shrink-0 overflow-hidden" style="width: 3rem; height: 4rem;">
                                                        <img alt="Advanced Quantum Mechanics"
                                                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuDgbuTN_Xh-R8JE69H72_0H4aueF8CmopkP9SrQ7Ctp3xvtBl1emFNyQVRtGaD-FqoTxaO6DZAZCO7amQlrdDVc-jUDClk_kivV0eHFWCPWccqDFAQWXLTf-CEItr4KLrwdDMFtMof30JwFZ6SF3BirrOA6W78tcVGPG-DOp8n6Rdw517n_qvRiWT1OH6lFTDSa68ytczrvnufL2ctkC1zanXhx641Ie7vbNno2aBsUvb2HoxWF5dAPu6q8WtFKI7yBA5pLLJhbmGM"
                                                             class="w-100 h-100 object-fit-cover" />
                                                    </div>
                                                    <div>
                                                        <p class="fw-bold text-dark mb-0" style="font-size: 16px;">Advanced Quantum Mechanics</p>
                                                        <p class="text-muted small mb-0">Dr. Julian Thorne</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge px-3 py-2 rounded-pill"
                                                      style="background-color: rgba(249, 115, 22, 0.1); color: #9d4300; border: 1px solid rgba(249, 115, 22, 0.2); font-size: 12px; font-weight: 600;">
                                                    Research
                                                </span>
                                            </td>
                                            <td class="text-center"><span class="h5 fw-bold mb-0" style="color: #9d4300;">1st</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="spinner-grow spinner-grow-sm text-warning" role="status" style="width: 8px; height: 8px;"></span>
                                                    <span class="small fw-semibold text-dark">Arriving Tomorrow</span>
                                                </div>
                                            </td>
                                            <td>
                                                <button class="action-icon-btn btn-cancel" title="Cancel Reservation">
                                                    <span class="material-symbols-outlined">cancel</span>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded shadow-sm flex-shrink-0 overflow-hidden" style="width: 3rem; height: 4rem;">
                                                        <img alt="Sociology of Modern Cities"
                                                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuAhgaVNqoMWENSOpscfMQmWOC3mWt--qSYduH_-5V3V7EH3YiBlPbHnvyUEjJSTm3oqvXnO1Y-K9x5MST1gkZIFi9izPAVM6yxWYZBTzh1MA1YEQ-eCjl4W5yrF2SfJBTWXUmWtS8YYHSfLiirYA1wKCBd2QFwlOlQrfh5Rj2izpe0XaDgvFvcXiFIvud30VgyUXtAmaPIk3uv7KpHK15ZQ04DAQCe6Romfb5aOhdBc0HVIVOhR2TLlYIDbqx_gIQ2TX-RCinyHc4k"
                                                             class="w-100 h-100 object-fit-cover" />
                                                    </div>
                                                    <div>
                                                        <p class="fw-bold text-dark mb-0" style="font-size: 16px;">Sociology of Modern Cities</p>
                                                        <p class="text-muted small mb-0">Prof. Sarah Jenkins</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge px-3 py-2 rounded-pill"
                                                      style="background-color: rgba(0, 162, 244, 0.1); color: #006398; border: 1px solid rgba(0, 162, 244, 0.2); font-size: 12px; font-weight: 600;">
                                                    SOC204 Course
                                                </span>
                                            </td>
                                            <td class="text-center"><span class="text-muted opacity-50">--</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="rounded-circle bg-success" style="width: 8px; height: 8px;"></div>
                                                    <span class="small fw-semibold text-dark">Ready for Pickup</span>
                                                </div>
                                            </td>
                                            <td>
                                                <button class="action-icon-btn btn-info" title="View Info">
                                                    <span class="material-symbols-outlined">info</span>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded shadow-sm flex-shrink-0 overflow-hidden" style="width: 3rem; height: 4rem;">
                                                        <img alt="The Evolution of Language"
                                                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuDr5mfvSwQZamhHNJozDT6OQC4aZ2Yv8quIxL8V-PnrJFdcWggEfgMoCy4qRwMWwgQd_20LHglSceLxlMeTGdUfX_nndGo3jjaUYyUxAanOqiGNnSVR8qSBlG6Foy-ltc5GCEc7b5min0TeEG3i-t3NA2KihUT8sHpTOrNt5CYaMQ4N4MmaSV7DA5YMX83OcLPpSCKb7ehG9sYP_nR4iz4l-L2q21JF0XatHhy4tU_a9l2bmviRrqgddrAzBzweqi2Mxz_NT_oOwiI"
                                                             class="w-100 h-100 object-fit-cover" />
                                                    </div>
                                                    <div>
                                                        <p class="fw-bold text-dark mb-0" style="font-size: 16px;">The Evolution of Language</p>
                                                        <p class="text-muted small mb-0">Dr. Marcus Vane</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge px-3 py-2 rounded-pill"
                                                      style="background-color: rgba(249, 115, 22, 0.1); color: #9d4300; border: 1px solid rgba(249, 115, 22, 0.2); font-size: 12px; font-weight: 600;">
                                                    Research
                                                </span>
                                            </td>
                                            <td class="text-center"><span class="h5 fw-bold text-secondary mb-0">4th</span></td>
                                            <td>
                                                <div class="d-flex flex-column" style="width: 100px;">
                                                    <span class="small text-muted mb-1" style="font-size: 11px; font-weight: 600;">Waitlist Active</span>
                                                    <div class="progress" style="height: 4px;">
                                                        <div class="progress-bar" role="progressbar" style="width: 25%; background-color: #9d4300;"></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <button class="action-icon-btn btn-cancel" title="Cancel Reservation">
                                                    <span class="material-symbols-outlined">cancel</span>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- Pagination Footer --%>
                    <div class="p-3 bg-light border-top d-flex justify-content-between align-items-center" style="border-top-color: rgba(140, 113, 100, 0.2) !important;">
                        <span class="small fw-semibold text-secondary" style="font-size: 12px;">
                            Showing <c:out value="${reservationList != null ? reservationList.size() : '4'}" />
                            of <c:out value="${totalReservations != null ? totalReservations : '20'}" /> reservations
                        </span>
                        <div class="d-flex gap-1">
                            <button class="btn btn-sm border rounded p-1 d-inline-flex align-items-center justify-content-center" style="width: 2rem; height: 2rem;">
                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_left</span>
                            </button>
                            <button class="btn btn-sm border rounded p-1 d-inline-flex align-items-center justify-content-center" style="width: 2rem; height: 2rem;">
                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_right</span>
                            </button>
                        </div>
                    </div>
                </div>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Page-specific styles --%>
<style>
    .glass-card {
        background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.3);
    }
    .custom-shadow { box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04); }
    .btn-switch {
        font-size: 12px; font-weight: 600; padding: 0.25rem 1rem;
        border: none; border-radius: 0.375rem; transition: all 0.2s ease; cursor: pointer;
    }
    .btn-switch.active { background-color: #ffffff; color: #9d4300; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .btn-switch:not(.active) { background-color: transparent; color: #5c647a; }
    .table th { font-size: 12px; font-weight: 600; color: #5c647a; background-color: #f2f4f6; text-transform: uppercase; letter-spacing: 0.05em; padding: 1rem; }
    .table td { padding: 1rem; vertical-align: middle; }
    .action-icon-btn { color: #5c647a; opacity: 0.4; background: none; border: none; transition: all 0.2s ease; cursor: pointer; }
    tr:hover .action-icon-btn { opacity: 1; }
    .action-icon-btn.btn-cancel:hover { color: #ba1a1a; }
    .action-icon-btn.btn-info:hover { color: #9d4300; }
</style>

<script>
    function filterTab(tab) {
        document.getElementById('btn-active').classList.toggle('active', tab === 'active');
        document.getElementById('btn-history').classList.toggle('active', tab === 'history');
        // Actual filtering will be handled server-side via URL param
        if (tab === 'history') {
            location.href = '${pageContext.request.contextPath}/lecturer/my-reservations?tab=history';
        } else {
            location.href = '${pageContext.request.contextPath}/lecturer/my-reservations?tab=active';
        }
    }

    document.querySelectorAll('.btn-cancel').forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            const row = this.closest('tr');
            if (confirm('Are you sure you want to cancel this reservation?')) {
                row.style.opacity = '0';
                row.style.transform = 'translateX(20px)';
                row.style.transition = 'all 0.3s ease-out';
                setTimeout(() => row.remove(), 300);
            }
        });
    });
</script>

</html>
