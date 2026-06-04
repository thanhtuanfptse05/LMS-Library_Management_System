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
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Create User Account</h2>
                    <p class="font-body-md text-on-surface-variant">Register a new reader (Student/Lecturer) or staff member (Librarian/Manager) in the system.</p>
                </div>

                <!-- Form Card -->
                <div class="raised-card p-4 border border-outline-variant bg-white" style="max-width: 800px;">
                    <form action="${pageContext.request.contextPath}/admin/user-list.jsp" method="POST" id="userAddForm">
                        
                        <div class="row g-3 mb-4">
                            <h4 class="fw-bold text-on-surface-variant mb-2 fs-5 border-bottom pb-2">1. Credentials & Primary Info</h4>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">Full Name</label>
                                <input type="text" class="form-control rounded-3 py-2 border-outline-variant" placeholder="e.g. John Doe" required />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">Email Address</label>
                                <input type="email" class="form-control rounded-3 py-2 border-outline-variant" placeholder="john.doe@uni.edu" required />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">Username</label>
                                <input type="text" class="form-control rounded-3 py-2 border-outline-variant" placeholder="johndoe" required />
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">Temporary Password</label>
                                <div class="input-group">
                                    <input type="password" id="tempPassword" class="form-control rounded-start-3 py-2 border-outline-variant" placeholder="••••••••" required />
                                    <button type="button" class="btn btn-outline-secondary rounded-end-3" onclick="togglePasswordVisibility()"><span class="material-symbols-outlined fs-5">visibility</span></button>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <h4 class="fw-bold text-on-surface-variant mb-2 fs-5 border-bottom pb-2">2. Role Assignment & Profile Properties</h4>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">System Role</label>
                                <select id="roleSelector" class="form-select rounded-3 py-2 border-outline-variant" onchange="handleRoleChange()" required>
                                    <option value="STUDENT">Student</option>
                                    <option value="LECTURER">Lecturer</option>
                                    <option value="LIBRARIAN">Librarian</option>
                                    <option value="MANAGER">Library Manager</option>
                                    <option value="ADMIN">Administrator</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold text-on-surface-variant">Gender</label>
                                <select class="form-select rounded-3 py-2 border-outline-variant">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <!-- Dynamic Role-specific Section -->
                        <div class="row g-3 mb-4 p-3 border rounded-3 bg-light" id="rolePropsBox" style="border-color: var(--outline-variant) !important;">
                            <h5 class="fw-bold text-primary-custom mb-2">Student Parameters</h5>
                            <div class="col-12 col-md-6" id="studentCodeCol">
                                <label class="form-label fw-bold text-on-surface-variant">Student Code / ID</label>
                                <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="e.g. SE180293" required />
                            </div>
                            <div class="col-12 col-md-6" id="studentMajorCol">
                                <label class="form-label fw-bold text-on-surface-variant">Academic Major</label>
                                <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="Software Engineering" required />
                            </div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex align-items-center gap-2 pt-3 border-top">
                            <button type="submit" class="btn btn-primary-custom rounded-pill px-4 py-2.5 fw-bold">Register Account</button>
                            <a href="${pageContext.request.contextPath}/admin/user-list.jsp" class="btn btn-light rounded-pill px-4 py-2.5 fw-bold">Cancel</a>
                        </div>
                    </form>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePasswordVisibility() {
            const input = document.getElementById('tempPassword');
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        function handleRoleChange() {
            const role = document.getElementById('roleSelector').value;
            const propsBox = document.getElementById('rolePropsBox');
            
            if (role === 'STUDENT') {
                propsBox.innerHTML = `
                    <h5 class="fw-bold text-primary-custom mb-2">Student Parameters</h5>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Student Code / ID</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="e.g. SE180293" required />
                    </div>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Academic Major</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="Software Engineering" required />
                    </div>
                `;
                propsBox.classList.remove('d-none');
            } else if (role === 'LECTURER') {
                propsBox.innerHTML = `
                    <h5 class="fw-bold text-primary-custom mb-2">Lecturer Parameters</h5>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Lecturer Code / ID</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="e.g. LEC-1090" required />
                    </div>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Department</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="Computer Science" required />
                    </div>
                `;
                propsBox.classList.remove('d-none');
            } else if (role === 'LIBRARIAN' || role === 'MANAGER') {
                propsBox.innerHTML = `
                    <h5 class="fw-bold text-primary-custom mb-2">Staff Parameters</h5>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Staff Code / ID</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="e.g. STAFF-0921" required />
                    </div>
                    <div class="col-12 col-md-6">
                        <label class="form-label fw-bold text-on-surface-variant">Duty Station</label>
                        <input type="text" class="form-control rounded-3 py-2 border-outline-variant bg-white" placeholder="Central Library Desk" required />
                    </div>
                `;
                propsBox.classList.remove('d-none');
            } else {
                propsBox.classList.add('d-none');
            }
        }
    </script>
</body>
</html>
