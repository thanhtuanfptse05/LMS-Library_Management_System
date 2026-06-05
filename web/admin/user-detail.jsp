<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<style>
    /* Timeline style override */
    .timeline {
        border-left: 2px solid var(--outline-variant);
        position: relative;
        list-style: none;
        padding-left: 20px;
    }
    .timeline-item {
        position: relative;
        margin-bottom: 24px;
    }
    .timeline-dot {
        position: absolute;
        left: -26px;
        top: 4px;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: var(--primary);
        border: 2px solid white;
    }
</style>
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
                    <a href="${pageContext.request.contextPath}/admin/user-list.jsp" class="d-inline-flex align-items-center gap-1 text-decoration-none text-primary-custom fw-bold mb-2">
                        <span class="material-symbols-outlined fs-5">arrow_back</span>
                        Quay lại to User List
                    </a>
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">User Tài khoản Review</h2>
                    <p class="font-body-md text-on-surface-variant mb-0">Detailed activity, loan history, and invoice records for this member.</p>
                </div>

                <div class="row g-4">
                    <!-- Left: Profile Summary (4 cols) -->
                    <div class="col-12 col-lg-4">
                        <div class="bg-white p-4 rounded-3 border border-outline-variant card-shadow text-center">
                            <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold mx-auto mb-3" style="width: 100px; height: 100px; font-size: 32px;">
                                JV
                            </div>
                            <h3 class="mb-1 fw-bold">Jordan Vance</h3>
                            <p class="text-muted small mb-3">j.vance@uni.edu • Code: 230014</p>
                            
                            <span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3 py-1.5 mb-4">ACTIVE MEMBER</span>
                            
                            <div class="border-top pt-3 text-start">
                                <p class="mb-2"><span class="text-muted">Tên đăng nhập:</span> <span class="fw-bold">jvance12</span></p>
                                <p class="mb-2"><span class="text-muted">Academic Major:</span> <span class="fw-bold">Software Engineering</span></p>
                                <p class="mb-2"><span class="text-muted">Enrolled:</span> <span class="fw-bold">September 2024</span></p>
                                <p class="mb-3"><span class="text-muted">Unpaid Penalty:</span> <span class="fw-bold text-danger">$24.00</span></p>
                            </div>

                            <div class="d-flex flex-column gap-2 mt-3">
                                <a href="${pageContext.request.contextPath}/admin/user-edit.jsp?id=230014" class="btn btn-primary-custom py-2 rounded-pill fw-bold">
                                    Sửa Tài khoản Settings
                                </a>
                                <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=230014" class="btn btn-outline-primary-custom py-2 rounded-pill fw-bold">
                                    Process Cash Thanh toán
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Tabbed Detail panels (8 cols) -->
                    <div class="col-12 col-lg-8">
                        <div class="bg-white p-4 rounded-3 border border-outline-variant card-shadow">
                            
                            <ul class="nav nav-tabs mb-4 gap-2 border-0" id="detailTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active rounded-pill fw-bold px-3" id="loans-tab" data-bs-toggle="tab" data-bs-target="#loans-content" type="button" role="tab" aria-controls="loans-content" aria-selected="true">
                                        Loans & Returns
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-pill fw-bold px-3" id="fines-tab" data-bs-toggle="tab" data-bs-target="#fines-content" type="button" role="tab" aria-controls="fines-content" aria-selected="false">
                                        Tiền phạt & Receipts
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-pill fw-bold px-3" id="logs-tab" data-bs-toggle="tab" data-bs-target="#logs-content" type="button" role="tab" aria-controls="logs-content" aria-selected="false">
                                        System Activity Logs
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="detailTabsContent">
                                <!-- TAB 1: LOANS -->
                                <div class="tab-pane fade show active" id="loans-content" role="tabpanel" aria-labelledby="loans-tab">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr style="background-color: var(--surface-container-low);">
                                                    <th class="ps-3">Sách Tiêu đề</th>
                                                    <th>Loan Date</th>
                                                    <th>Hạn trả</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Introduction to Algorithms (4th Edition)</td>
                                                    <td>Apr 15, 2026</td>
                                                    <td>May 15, 2026</td>
                                                    <td><span class="badge badge-overdue">OVERDUE</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Design Patterns: Object-Oriented Software</td>
                                                    <td>May 02, 2026</td>
                                                    <td>Jun 02, 2026</td>
                                                    <td><span class="badge badge-overdue">OVERDUE</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Advanced thermodynamics</td>
                                                    <td>Mar 10, 2026</td>
                                                    <td>Apr 10, 2026</td>
                                                    <td><span class="badge badge-returned">RETURNED</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- TAB 2: FINES -->
                                <div class="tab-pane fade" id="fines-content" role="tabpanel" aria-labelledby="fines-tab">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr style="background-color: var(--surface-container-low);">
                                                    <th class="ps-3">Violation Chi tiết</th>
                                                    <th>Amount</th>
                                                    <th>Issued Date</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Introduction to Algorithms (Late Return)</td>
                                                    <td class="text-danger fw-bold">$12.00</td>
                                                    <td>May 20, 2026</td>
                                                    <td><span class="badge rounded-pill bg-danger-subtle text-danger px-3">UNPAID</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Design Patterns (Bị hỏng Sách Cover)</td>
                                                    <td class="text-danger fw-bold">$12.00</td>
                                                    <td>Jun 02, 2026</td>
                                                    <td><span class="badge rounded-pill bg-danger-subtle text-danger px-3">UNPAID</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="ps-3 fw-bold">Advanced Thermodynamics (Late Return)</td>
                                                    <td class="text-success fw-bold">$15.50</td>
                                                    <td>May 10, 2026</td>
                                                    <td><span class="badge rounded-pill bg-success-subtle text-success px-3">PAID</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- TAB 3: ACTIVITY LOGS -->
                                <div class="tab-pane fade" id="logs-content" role="tabpanel" aria-labelledby="logs-tab">
                                    <ul class="timeline mt-3">
                                        <li class="timeline-item">
                                            <span class="timeline-dot"></span>
                                            <p class="mb-0 fw-bold">Login Successful</p>
                                            <small class="text-muted">Jun 04, 2026 • 18:36 • IP: 192.168.1.104</small>
                                        </li>
                                        <li class="timeline-item">
                                            <span class="timeline-dot" style="background-color: var(--secondary);"></span>
                                            <p class="mb-0 fw-bold">Sách Check-Out (Design Patterns)</p>
                                            <small class="text-muted">May 02, 2026 • 10:14 • Processed by Librarian_John</small>
                                        </li>
                                        <li class="timeline-item">
                                            <span class="timeline-dot" style="background-color: var(--success);"></span>
                                            <p class="mb-0 fw-bold">Fine Paid ($15.50 via VNPAY)</p>
                                            <small class="text-muted">May 10, 2026 • 14:15 • Receipt: REC-2026-4402</small>
                                        </li>
                                        <li class="timeline-item">
                                            <span class="timeline-dot" style="background-color: var(--secondary);"></span>
                                            <p class="mb-0 fw-bold">Sách Returned (Advanced Thermodynamics)</p>
                                            <small class="text-muted">May 10, 2026 • 14:02 • Return processed</small>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
