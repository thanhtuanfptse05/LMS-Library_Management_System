<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
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
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4 gap-3">
                    <div>
                        <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">User Accounts</h2>
                        <p class="font-body-md text-on-surface-variant mb-0">System-wide account administrative controls, credential tracking, and system logs.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/user-add.jsp" class="btn btn-primary-custom px-4 py-2 rounded-pill fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">person_add</span>
                            Tạo New Tài khoản
                        </a>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-3">
                        <div class="raised-card p-3 border border-outline-variant bg-white">
                            <span class="font-label-md text-on-surface-variant text-uppercase">Total Users</span>
                            <h3 class="mb-0 fw-bold mt-1">421</h3>
                        </div>
                    </div>
                    <div class="col-12 col-md-3">
                        <div class="raised-card p-3 border border-outline-variant bg-white">
                            <span class="font-label-md text-on-surface-variant text-uppercase">Hoạt động Staff</span>
                            <h3 class="mb-0 fw-bold text-success mt-1">12</h3>
                        </div>
                    </div>
                    <div class="col-12 col-md-3">
                        <div class="raised-card p-3 border border-outline-variant bg-white">
                            <span class="font-label-md text-on-surface-variant text-uppercase">Thành viên hoạt động</span>
                            <h3 class="mb-0 fw-bold text-primary-custom mt-1">398</h3>
                        </div>
                    </div>
                    <div class="col-12 col-md-3">
                        <div class="raised-card p-3 border border-outline-variant bg-white">
                            <span class="font-label-md text-on-surface-variant text-uppercase">Locked Accounts</span>
                            <h3 class="mb-0 fw-bold text-danger mt-1">11</h3>
                        </div>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="raised-card p-4 border border-outline-variant bg-white mb-4">
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <div class="position-relative">
                                <span class="material-symbols-outlined position-absolute text-muted" style="left: 12px; top: 50%; transform: translateY(-50%);">search</span>
                                <input type="text" class="form-control rounded-3 py-2 ps-5" placeholder="Search by name, email, student ID..." />
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select rounded-3 py-2">
                                <option value="">All Roles</option>
                                <option value="ADMIN">Administrator</option>
                                <option value="LIBRARIAN">Thủ thư</option>
                                <option value="LECTURER">Giảng viên</option>
                                <option value="STUDENT">Sinh viên</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select rounded-3 py-2">
                                <option value="">All Statuses</option>
                                <option value="ACTIVE">Hoạt động</option>
                                <option value="LOCKED">Locked</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- User Table -->
                <div class="raised-card overflow-hidden border border-outline-variant bg-white">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr style="background-color: var(--surface-container-low);">
                                    <th class="ps-4">User</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Date Created</th>
                                    <th class="text-end pe-4">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Row 1 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 40px; height: 40px;">
                                                JV
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Jordan Vance</p>
                                                <small class="text-muted">j.vance@uni.edu • Code: 230014</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge rounded-pill bg-light text-dark fw-bold px-3">STUDENT</span></td>
                                    <td>
                                        <span class="d-flex align-items-center gap-1 text-success small">
                                            <span class="rounded-circle d-inline-block bg-success" style="width: 8px; height: 8px;"></span>
                                            Hoạt động
                                        </span>
                                    </td>
                                    <td>Sep 12, 2024</td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/admin/user-detail.jsp?id=230014" class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1 fw-bold">Chi tiết</a>
                                        <a href="${pageContext.request.contextPath}/admin/user-edit.jsp?id=230014" class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold ms-1">Sửa</a>
                                    </td>
                                </tr>

                                <!-- Row 2 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-secondary-container text-on-secondary-container fw-bold" style="width: 40px; height: 40px;">
                                                MK
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Maria Kovacs</p>
                                                <small class="text-muted">m.kovacs@uni.edu • Code: 108891</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge rounded-pill bg-info-subtle text-primary fw-bold px-3">LECTURER</span></td>
                                    <td>
                                        <span class="d-flex align-items-center gap-1 text-success small">
                                            <span class="rounded-circle d-inline-block bg-success" style="width: 8px; height: 8px;"></span>
                                            Hoạt động
                                        </span>
                                    </td>
                                    <td>Aug 20, 2024</td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/admin/user-detail.jsp?id=108891" class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1 fw-bold">Chi tiết</a>
                                        <a href="${pageContext.request.contextPath}/admin/user-edit.jsp?id=108891" class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold ms-1">Sửa</a>
                                    </td>
                                </tr>

                                <!-- Row 3 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-danger-subtle text-danger fw-bold" style="width: 40px; height: 40px;">
                                                RL
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Robert Lang</p>
                                                <small class="text-muted">r.lang@external.com • Code: G-9024</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge rounded-pill bg-warning-subtle text-warning fw-bold px-3">GUEST</span></td>
                                    <td>
                                        <span class="d-flex align-items-center gap-1 text-danger small">
                                            <span class="rounded-circle d-inline-block bg-danger" style="width: 8px; height: 8px;"></span>
                                            Locked
                                        </span>
                                    </td>
                                    <td>Jan 10, 2025</td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/admin/user-detail.jsp?id=G-9024" class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1 fw-bold">Chi tiết</a>
                                        <a href="${pageContext.request.contextPath}/admin/user-edit.jsp?id=G-9024" class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold ms-1">Sửa</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="p-3 bg-light border-top border-outline-variant d-flex justify-content-between align-items-center">
                        <span class="text-muted small">Showing 1-3 of 421 results</span>
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                <li class="page-item active"><a class="page-link bg-primary-custom border-primary-custom" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item text-primary-custom"><a class="page-link" href="#">Next</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
