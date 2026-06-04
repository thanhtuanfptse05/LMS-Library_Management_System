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
        <main class="flex-grow-1 overflow-y-auto d-flex flex-column" style="background-color: #f7f9fb; margin-left: 256px;">
            <div class="container-xl px-4 py-5 flex-grow-1">
                
                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Edit User Security</h2>
                    <p class="font-body-md text-on-surface-variant">Update credentials, toggle lock states, or trigger remote password resets.</p>
                </div>

                <div class="row g-4">
                    <!-- Left: Main Settings Form (8 cols) -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card p-4 border border-outline-variant bg-white">
                            <form action="${pageContext.request.contextPath}/admin/user-list.jsp" method="POST" id="userEditForm">
                                
                                <!-- Read-only Info Header -->
                                <div class="d-flex align-items-center gap-3 mb-4 p-3 border rounded-3 bg-light" style="border-color: var(--outline-variant) !important;">
                                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 48px; height: 48px;">
                                        JV
                                    </div>
                                    <div>
                                        <p class="mb-0 fw-bold">Jordan Vance</p>
                                        <small class="text-muted">Username: jvance12 • Email: j.vance@uni.edu • Role: STUDENT</small>
                                    </div>
                                </div>

                                <!-- Lock Toggle Status -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold text-on-surface-variant mb-2" style="font-size: 14px;">1. Account Authorization State</label>
                                    <div class="form-check form-switch p-3 border rounded-3 d-flex align-items-center justify-content-between" style="border-color: var(--outline-variant) !important; padding-left: 3.5rem !important;">
                                        <div>
                                            <p class="mb-0 fw-bold">Account Locked</p>
                                            <small class="text-muted">Prevents the user from logging in or borrowing books</small>
                                        </div>
                                        <input class="form-check-input" type="checkbox" id="lockStatusToggle" onchange="toggleLockReason()" style="width: 2.8em; height: 1.5em;" />
                                    </div>
                                </div>

                                <!-- Conditional Lock Reason -->
                                <div class="mb-4 d-none" id="lockReasonBox">
                                    <label class="form-label fw-bold text-on-surface-variant">Reason for Locking Account</label>
                                    <textarea class="form-control rounded-3 py-2 border-outline-variant" rows="3" placeholder="Provide a reason for administrative locks (e.g. Unresolved outstanding fines, policy violation)..."></textarea>
                                </div>

                                <!-- Password Change Override -->
                                <div class="mb-4 border-top pt-4">
                                    <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">2. Security Credentials Override</label>
                                    <div class="p-3 border rounded-3 d-flex flex-column gap-3" style="border-color: var(--outline-variant) !important;">
                                        <div class="form-check">
                                            <input type="checkbox" class="form-check-input" id="forceResetCheck" />
                                            <label class="form-check-label text-on-surface-variant small" for="forceResetCheck">
                                                Force password change upon next login
                                            </label>
                                        </div>
                                        <div>
                                            <button type="button" class="btn btn-outline-primary-custom rounded-pill px-4 fw-bold" onclick="simulatedResetLink()">
                                                Generate Password Reset Email
                                            </button>
                                            <p class="text-muted small mt-2 mb-0" id="resetMsg"></p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="d-flex align-items-center gap-2 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary-custom rounded-pill px-4 py-2.5 fw-bold">Save Security Policy</button>
                                    <a href="${pageContext.request.contextPath}/admin/user-list.jsp" class="btn btn-light rounded-pill px-4 py-2.5 fw-bold">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleLockReason() {
            const toggle = document.getElementById('lockStatusToggle');
            const box = document.getElementById('lockReasonBox');
            if (toggle.checked) {
                box.classList.remove('d-none');
            } else {
                box.classList.add('d-none');
            }
        }

        function simulatedResetLink() {
            const msg = document.getElementById('resetMsg');
            msg.textContent = 'Password reset email sent to j.vance@uni.edu successfully.';
            msg.className = 'text-success small mt-2 mb-0';
        }
    </script>
</body>
</html>
