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
            <div class="container-xl px-4 py-5">
                
                <!-- Page Header -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4 gap-3">
                    <div>
                        <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Global Fine Directory</h2>
                        <p class="font-body-md text-on-surface-variant mb-0">Track, adjust, and collect fines for all university members.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/librarian/fine-create.jsp" class="btn btn-primary-custom px-4 py-2 rounded-pill fw-bold d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">add_circle</span>
                            Create Manual Fine
                        </a>
                        <button class="btn btn-outline-secondary px-3 py-2 rounded-pill fw-bold">Export Report</button>
                    </div>
                </div>

                <!-- Filters Bento Card -->
                <div class="raised-card p-4 border border-outline-variant bg-white mb-4">
                    <div class="row g-3">
                        <div class="col-12 col-md-5">
                            <div class="position-relative">
                                <span class="material-symbols-outlined position-absolute text-muted" style="left: 12px; top: 50%; transform: translateY(-50%);">search</span>
                                <input type="text" class="form-control rounded-3 py-2 ps-5" placeholder="Search by student code, name, or book title..." />
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select rounded-3 py-2">
                                <option value="">All Member Types</option>
                                <option value="STUDENT">Student</option>
                                <option value="LECTURER">Lecturer</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select rounded-3 py-2">
                                <option value="">All Fine Statuses</option>
                                <option value="UNPAID">Unpaid</option>
                                <option value="PAID">Paid</option>
                                <option value="WAIVED">Waived</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-1">
                            <button class="btn btn-primary-custom w-100 py-2 rounded-3 d-flex align-items-center justify-content-center">
                                <span class="material-symbols-outlined">tune</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Fines Data Table -->
                <div class="raised-card overflow-hidden border border-outline-variant bg-white">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr style="background-color: var(--surface-container-low);">
                                    <th class="ps-4">Member Info</th>
                                    <th>Violated Book Copy</th>
                                    <th>Days Overdue</th>
                                    <th>Fine Amount</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Fine Row 1 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 36px; height: 36px;">
                                                JV
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Jordan Vance</p>
                                                <small class="text-muted">Student • ID: 230014</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <p class="mb-0 fw-bold">Introduction to Algorithms (4th Edition)</p>
                                        <small class="text-muted">Barcode: LMS-BK-10293 • Late Return</small>
                                    </td>
                                    <td><span class="badge badge-overdue">24 Days</span></td>
                                    <td class="fw-bold text-danger">$12.00</td>
                                    <td><span class="badge rounded-pill bg-danger-subtle text-danger fw-bold px-3 py-1.5">UNPAID</span></td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=230014" class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1 fw-bold">Process Cash</a>
                                        <button class="btn btn-sm btn-link text-muted text-decoration-none ms-2">Waive</button>
                                    </td>
                                </tr>

                                <!-- Fine Row 2 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-secondary-container text-on-secondary-container fw-bold" style="width: 36px; height: 36px;">
                                                MK
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Maria Kovacs</p>
                                                <small class="text-muted">Lecturer • ID: 108891</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <p class="mb-0 fw-bold">Quantum Mechanics: Concepts and Applications</p>
                                        <small class="text-muted">Barcode: LMS-BK-22891 • Damaged Pages</small>
                                    </td>
                                    <td><span class="badge badge-overdue">60 Days</span></td>
                                    <td class="fw-bold text-danger">$30.00</td>
                                    <td><span class="badge rounded-pill bg-danger-subtle text-danger fw-bold px-3 py-1.5">UNPAID</span></td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=108891" class="btn btn-sm btn-outline-primary-custom rounded-pill px-3 py-1 fw-bold">Process Cash</a>
                                        <button class="btn btn-sm btn-link text-muted text-decoration-none ms-2">Waive</button>
                                    </td>
                                </tr>

                                <!-- Fine Row 3 -->
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-light text-secondary fw-bold" style="width: 36px; height: 36px;">
                                                EV
                                            </div>
                                            <div>
                                                <p class="mb-0 fw-bold">Elena Vance</p>
                                                <small class="text-muted">Student • ID: 220042</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <p class="mb-0 fw-bold">Advanced Thermodynamics</p>
                                        <small class="text-muted">Barcode: LMS-BK-04882 • Late Return</small>
                                    </td>
                                    <td><span class="badge badge-returned">-</span></td>
                                    <td class="fw-bold text-success">$15.50</td>
                                    <td><span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3 py-1.5">PAID</span></td>
                                    <td class="text-end pe-4">
                                        <span class="text-muted small">Cleared via VNPAY</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="p-3 bg-light border-top border-outline-variant d-flex justify-content-between align-items-center">
                        <span class="text-muted small">Showing 1-3 of 145 results</span>
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                <li class="page-item active"><a class="page-link bg-primary-custom border-primary-custom" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link text-primary-custom" href="#">Next</a></li>
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
