<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">
        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5 d-flex align-items-center justify-content-center" style="min-height: calc(100vh - 160px);">
                
                <!-- Success Response Card -->
                <div class="raised-card p-5 border border-outline-variant bg-white text-center" style="max-width: 540px; width: 100%;">
                    
                    <!-- Icon -->
                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-success-subtle text-success mx-auto mb-4" style="width: 80px; height: 80px;">
                        <span class="material-symbols-outlined" style="font-size: 48px;">check_circle</span>
                    </div>

                    <h2 class="mb-2 fw-bold text-success">Payment Successful!</h2>
                    <p class="text-muted mb-4">Thank you. The institutional fine checkout has been processed, and details have been registered under your profile.</p>

                    <!-- Receipt Summary -->
                    <div class="border rounded-3 p-4 bg-light text-start mb-4" style="border-color: var(--outline-variant) !important;">
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Receipt Number</span>
                            <span class="fw-bold text-dark small">REC-2026-8902</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Transaction ID (VNPAY)</span>
                            <span class="fw-bold text-dark small">VNP-778901239248</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Date / Time</span>
                            <span class="fw-bold text-dark small">Jun 04, 2026 • 19:45</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Amount Paid</span>
                            <span class="fw-bold text-success small">$45.00</span>
                        </div>
                        <div class="d-flex justify-content-between py-2">
                            <span class="text-muted small">Status</span>
                            <span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3">PAID</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex flex-column gap-2">
                        <a href="${pageContext.request.contextPath}/lecturer/my-fines.jsp" class="btn btn-primary-custom py-2.5 rounded-pill fw-bold d-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined">payments</span>
                            Go to Fines & Billing
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/dashboard" class="btn btn-outline-secondary py-2 rounded-pill fw-bold">
                            Return to Dashboard
                        </a>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
