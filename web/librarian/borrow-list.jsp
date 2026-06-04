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
        <main class="flex-grow-1 overflow-y-auto custom-scrollbar"
              style="background-color: var(--surface-bright); height: 100vh; margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="p-4 mx-auto animate-in" style="max-width: 1400px; padding-top: 48px !important; padding-bottom: 48px !important;">

                <%-- ─── Alert Messages ─── --%>
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

                <%-- ─── Book Hero Section (Bento Style) ─── --%>
                <section class="row g-4 mb-4">
                    <div class="col-11 col-lg-4">
                        <div class="bento-card d-flex flex-column align-items-center h-100 text-center">
                            <img class="shadow rounded mb-3"
                                 style="width: 192px; aspect-ratio: 2/3; object-fit: cover;"
                                 alt="Book Cover"
                                 src="${not empty book.coverUrl ? book.coverUrl : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBrnYGzHpZJ4BwkqVqQzKVOuwI965LL-tkSYHZ7J-uFXI7evZLzVlVEXQ0bjbdir2DCR9lZGPoQemex1kgfwXmlDoYkSGYBPDiz0jRkA1c04IBATSUNCFmFVifr0a2d-7QGhY2Ti1wpsoxd__eRLDUXUif1Lcra0rTjgPw0T0MlQ-My3LZuTm8oI_TueNYDt4VBHnJmDR4h2xxcKEpImez1Dj7xcUv06PEoH6rx7A4I-cGAc2JPlGLVsQdPlOVVmS3FTu7rqupIO94'}" />
                            <span class="px-3 py-1 rounded-pill text-label-md font-weight-bold mb-2"
                                  style="background-color: var(--secondary-container); color: var(--on-secondary-container);">
                                ISBN: <c:out value="${not empty book.isbn ? book.isbn : '978-0141036144'}" />
                            </span>
                            <h3 class="fw-bold mb-1" style="font-size: 24px;">
                                <c:out value="${not empty book.title ? book.title : 'Nineteen Eighty-Four'}" />
                            </h3>
                            <p class="mb-0" style="color: var(--on-surface-variant);">
                                <c:out value="${not empty book.author ? book.author : 'George Orwell'}" />
                                &bull;
                                <c:out value="${not empty book.publishYear ? book.publishYear : '1949'}" />
                            </p>
                        </div>
                    </div>

                    <div class="col-12 col-lg-8">
                        <div class="row g-4 h-100">
                            <div class="col-12 col-md-6">
                                <div class="bento-card d-flex flex-column justify-content-between h-100">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2" style="color: var(--primary);">
                                            <span class="material-symbols-outlined">analytics</span>
                                            <span class="text-label-md text-uppercase tracking-wider">Queue Health</span>
                                        </div>
                                        <p class="text-display m-0 lh-1" style="color: var(--primary);">
                                            <c:out value="${not empty totalReservations ? totalReservations : '12'}" />
                                        </p>
                                        <p class="mt-1 mb-0" style="color: var(--on-surface-variant);">Active Reservations</p>
                                    </div>
                                    <div class="mt-4">
                                        <div class="d-flex justify-content-between text-label-md mb-2 fw-bold">
                                            <span>Estimated Wait Time</span>
                                            <span style="color: var(--primary);">~42 Days</span>
                                        </div>
                                        <div class="progress" style="height: 8px; background-color: var(--surface-container); border-radius: 9999px;">
                                            <div class="progress-bar" role="progressbar"
                                                 style="width: 75%; background-color: var(--primary-container); border-radius: 9999px;"
                                                 aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-6">
                                <div class="bento-card d-flex flex-column justify-content-between h-100"
                                     style="background-color: var(--primary-fixed);">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2" style="color: var(--on-primary-fixed);">
                                            <span class="material-symbols-outlined">inventory_2</span>
                                            <span class="text-label-md text-uppercase tracking-wider">Inventory Status</span>
                                        </div>
                                        <div class="d-flex align-items-end gap-2">
                                            <p class="text-display m-0 lh-1" style="color: var(--on-primary-fixed);">
                                                <c:out value="${not empty availableCopies ? availableCopies : '0'}" />/<c:out value="${not empty totalCopies ? totalCopies : '4'}" />
                                            </p>
                                            <p class="mb-1" style="color: var(--on-primary-fixed-variant);">Copies Available</p>
                                        </div>
                                    </div>
                                    <button class="btn w-full py-3 fw-bold d-flex align-items-center justify-content-center gap-2 border-0 mt-4 text-white"
                                            style="background-color: var(--primary); border-radius: 12px;">
                                        <span class="material-symbols-outlined">add</span> Mark Return Early
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <%-- ─── Reservation Queue Table (Fragment) ─── --%>
                <jsp:include page="fragments/_borrow-list-table.jsp" />

                <%-- ─── Notification Configuration Section ─── --%>
                <section class="row g-4">
                    <div class="col-12 col-md-8">
                        <div class="bento-card h-100" style="border-left: 4px solid var(--primary) !important;">
                            <div class="d-flex justify-content-between align-items-start mb-4">
                                <div>
                                    <h4 class="fw-bold mb-1" style="font-size: 24px;">Notification Integration</h4>
                                    <p class="mb-0" style="color: var(--on-surface-variant);">
                                        Configure automated 'Pickup Reminder' templates and triggers.
                                    </p>
                                </div>
                                <div class="px-3 py-1 rounded fw-bold text-label-md text-uppercase"
                                     style="background-color: rgba(0,99,152,0.1); color: var(--tertiary);">Active Engine</div>
                            </div>

                            <div class="d-flex flex-column gap-2">
                                <div class="p-3 d-flex align-items-center justify-content-between"
                                     style="background-color: var(--surface-container-low); border-radius: 12px; cursor: pointer;">
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="material-symbols-outlined text-display" style="color: var(--primary);">description</span>
                                        <div>
                                            <p class="fw-bold mb-0" style="color: var(--on-surface);">Standard_Pickup_V2.html</p>
                                            <p class="mb-0 text-muted" style="font-size: 14px;">Trigger: copy_returned | Recipients: Next_in_Queue</p>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined" style="color: var(--on-surface-variant);">chevron_right</span>
                                </div>

                                <div class="p-3 d-flex align-items-center justify-content-between"
                                     style="background-color: var(--surface-container-low); border-radius: 12px; cursor: pointer;">
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="material-symbols-outlined text-display" style="color: var(--primary);">pending_actions</span>
                                        <div>
                                            <p class="fw-bold mb-0" style="color: var(--on-surface);">Expired_Reservation.html</p>
                                            <p class="mb-0 text-muted" style="font-size: 14px;">Trigger: 48h_unclaimed | Action: Auto_Cancel</p>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined" style="color: var(--on-surface-variant);">chevron_right</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="p-4 h-100 d-flex flex-column justify-content-center align-items-center text-center gap-3"
                             style="background-color: var(--inverse-surface); color: var(--inverse-on-surface); border-radius: 12px;">
                            <div class="rounded-circle d-flex align-items-center justify-content-center"
                                 style="width: 80px; height: 80px; background-color: rgba(157,67,0,0.2);">
                                <span class="material-symbols-outlined" style="font-size: 48px; color: var(--primary-fixed-dim);">auto_awesome</span>
                            </div>
                            <h5 class="fw-bold mb-0" style="font-size: 24px;">Smart Queue Bot</h5>
                            <p class="mb-0 opacity-75" style="font-size: 14px;">
                                Enable AI to suggest queue re-ordering based on patron history and borrowing urgency.
                            </p>
                            <button class="btn px-4 py-2 fw-bold rounded-pill border-0"
                                    style="background-color: var(--primary-fixed); color: var(--on-primary-fixed);">Enable Assistant</button>
                        </div>
                    </div>
                </section>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Page-specific styles: Bento card, queue row hover, toast, slide animation --%>
<style>
    .bento-card {
        background: white;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.04);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .text-display { font-size: 48px; font-weight: 700; letter-spacing: -0.02em; }
    .text-label-md { font-size: 12px; line-height: 16px; letter-spacing: 0.05em; font-weight: 600; }
    .queue-row .actions-cell .btn-group-actions { opacity: 0; transition: opacity 0.2s ease; }
    .queue-row:hover .actions-cell .btn-group-actions { opacity: 1; }
    #toast {
        position: fixed; bottom: 48px; right: 48px;
        background-color: var(--inverse-surface); color: var(--inverse-on-surface);
        padding: 12px 24px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        display: flex; align-items: center; gap: 16px;
        transform: translateY(100px); opacity: 0;
        transition: all 0.3s ease; z-index: 1050;
    }
    #toast.show { transform: translateY(0); opacity: 1; }
    @keyframes slideIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    .animate-in { animation: slideIn 0.4s ease-out forwards; }
    .sidebar-spacer { margin-left: 260px; }
</style>

<%-- Toast & Hover JS --%>
<script>
    function showNotificationToast(patronName) {
        const toast = document.getElementById('toast');
        const message = document.getElementById('toast-message');
        message.innerText = `Pickup Reminder sent to ${patronName}.`;
        toast.classList.add('show');
        setTimeout(() => { hideToast(); }, 5000);
    }
    function hideToast() {
        document.getElementById('toast').classList.remove('show');
    }
    document.querySelectorAll('.animate-in .bento-card').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-4px)';
            card.style.boxShadow = '0 8px 25px rgba(0,0,0,0.08)';
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'translateY(0)';
            card.style.boxShadow = '0 4px 15px rgba(0,0,0,0.04)';
        });
    });
</script>

<%-- Notification Toast --%>
<div id="toast">
    <span class="material-symbols-outlined" style="color: var(--primary-fixed-dim);">check_circle</span>
    <p class="fw-bold mb-0" style="font-size: 14px;" id="toast-message">Notification sent successfully!</p>
    <span class="material-symbols-outlined" style="color: var(--on-surface-variant); cursor: pointer;" onclick="hideToast()">close</span>
</div>

</html>
