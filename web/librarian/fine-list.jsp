<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="fragments/_head.jsp" />
<style>
    /* Status Badges */
    .status-badge {
        padding: 5px 12px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.05em;
        display: inline-block;
        text-transform: uppercase;
    }
    .status-unpaid  { background-color: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
    .status-paid    { background-color: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
    .status-waived  { background-color: #f3f4f6; color: #374151; border: 1px solid #d1d5db; }
    .status-partial { background-color: #ffedd5; color: #c2410c; border: 1px solid #fdba74; }

    /* Member Badges */
    .member-badge {
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
        padding: 2px 8px;
        border-radius: 4px;
        display: inline-block;
    }
    .member-student { background-color: rgba(0, 99, 152, 0.1); color: #006398; }
    .member-lecturer { background-color: rgba(157, 67, 0, 0.1); color: #9d4300; }

    /* Days Overdue badges */
    .days-badge {
        font-size: 12px;
        font-weight: 600;
        padding: 3px 10px;
        border-radius: 6px;
    }
    .days-low    { background-color: #f3f4f6; color: #4b5563; }
    .days-medium { background-color: #fef3c7; color: #b45309; }
    .days-high   { background-color: #fee2e2; color: #b91c1c; }

    /* Bulk Action Bar */
    .bulk-action-bar {
        background-color: var(--surface-container-low);
        border: 1px solid var(--outline-variant);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 24px;
        margin-bottom: 16px;
        transition: all 0.3s ease;
    }

    /* Side Drawer Panel */
    .side-drawer-backdrop {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background-color: rgba(0, 0, 0, 0.4);
        z-index: 1040;
        display: none;
        backdrop-filter: blur(4px);
    }
    .side-drawer-backdrop.show {
        display: block;
    }
    .side-drawer {
        position: fixed;
        top: 0;
        right: -500px;
        width: 500px;
        height: 100vh;
        background-color: #ffffff;
        box-shadow: -5px 0 25px rgba(0, 0, 0, 0.15);
        z-index: 1050;
        transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        flex-direction: column;
    }
    .side-drawer.open {
        right: 0;
    }
    .side-drawer-header {
        padding: 20px 24px;
        border-bottom: 1px solid var(--outline-variant);
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: var(--surface-container-low);
    }
    .side-drawer-body {
        padding: 24px;
        overflow-y: auto;
        flex-grow: 1;
    }
    .side-drawer-footer {
        padding: 20px 24px;
        border-top: 1px solid var(--outline-variant);
        background-color: var(--surface-container-low);
        display: flex;
        gap: 12px;
    }
    @media (max-width: 575.98px) {
        .side-drawer {
            width: 100%;
            right: -100%;
        }
    }

    /* Sortable Headers */
    .sort-header {
        cursor: pointer;
        user-select: none;
    }
    .sort-header:hover {
        background-color: var(--surface-container) !important;
    }
    .sort-icon {
        font-size: 16px !important;
        margin-left: 4px;
        vertical-align: middle;
        opacity: 0.5;
    }
    .sort-active {
        color: var(--primary) !important;
        background-color: var(--surface-container) !important;
    }
    .sort-active .sort-icon {
        opacity: 1;
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

                <!-- 1. Summary Cards (Fragment Include) -->
                <jsp:include page="fragments/_fine-stats.jsp" />

                <!-- 2. Filters Bento Card (Fragment Include) -->
                <jsp:include page="fragments/_fine-filters.jsp" />

                <!-- 9. Bulk Actions Bar -->
                <div class="bulk-action-bar d-none" id="bulkBar">
                    <div class="d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined text-primary">info</span>
                        <span class="fw-bold small" id="selectedCount">0 fines selected</span>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1.5 fw-bold" onclick="alert('Reminder notices sent to selected members.')">Send Reminder</button>
                        <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1.5 fw-bold" onclick="alert('Exported selected files.')">Export Selected</button>
                        <button class="btn btn-sm btn-outline-danger rounded-pill px-3 py-1.5 fw-bold" id="bulkWaiveBtn" onclick="waiveSelected()">Waive Selected</button>
                    </div>
                </div>

                <!-- Fines Data Table -->
                <div class="raised-card overflow-hidden border border-outline-variant bg-white">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="finesTable">
                            <thead>
                                <tr style="background-color: var(--surface-container-low);">
                                    <th style="width: 50px;" class="ps-4">
                                        <input type="checkbox" id="selectAllCheckbox" class="form-check-input" />
                                    </th>
                                    <th>Member Info</th>
                                    <th>Violated Book Copy</th>
                                    <th>Fine Type</th>
                                    <!-- 4. Sortable Headers -->
                                    <th class="sort-header" onclick="sortTable(4)">
                                        Days Overdue <span class="material-symbols-outlined sort-icon">unfold_more</span>
                                    </th>
                                    <th class="sort-header" onclick="sortTable(5)">
                                        Fine Amount <span class="material-symbols-outlined sort-icon">unfold_more</span>
                                    </th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty finesList}">
                                        <!-- Mock Data Fallback for static testing -->
                                        <!-- Fine Row 1 -->
                                        <tr data-id="FINE-0024" data-type="Late Return" data-amount="12.00" data-overdue="4" data-status="UNPAID">
                                            <td class="ps-4">
                                                <input type="checkbox" class="form-check-input fine-row-checkbox" />
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 36px; height: 36px;">
                                                        JV
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-bold">Jordan Vance</p>
                                                        <small class="text-muted"><span class="member-badge member-student me-1">Student</span>ID: 230014</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <p class="mb-0 fw-bold text-truncate" style="max-width: 200px;" title="Introduction to Algorithms (4th Edition)">Introduction to Algorithms (4th Edition)</p>
                                                <small class="text-muted">Barcode: LMS-BK-10293</small>
                                            </td>
                                            <td><span class="small fw-semibold text-muted">Late Return</span></td>
                                            <td><span class="days-badge days-low">4 days</span></td>
                                            <td class="fw-bold text-danger">$12.00</td>
                                            <td><span class="status-badge status-unpaid">UNPAID</span></td>
                                            <td class="text-end pe-4">
                                                <div class="d-inline-flex gap-1 align-items-center">
                                                    <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=230014" class="btn btn-sm btn-primary-custom rounded-pill px-3 py-1 fw-bold" title="Collect payment">Collect</a>
                                                    <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold" title="Waive fine" onclick="waiveSingle('FINE-0024')">Waive</button>
                                                    <button class="btn btn-sm btn-icon" title="View details" onclick="openDrawer('FINE-0024', 'Jordan Vance', 'Student', '230014', 'Introduction to Algorithms (4th Edition)', 'LMS-BK-10293', 'Late Return', '4 days', '$12.00', 'UNPAID', 'Borrow Date: Apr 15, 2026<br>Due Date: May 15, 2026', '4 days × $3.00/day = $12.00', 'No payment has been recorded yet.')">
                                                        <span class="material-symbols-outlined" style="font-size: 20px;">visibility</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Fine Row 2 -->
                                        <tr data-id="FINE-0060" data-type="Damaged Book" data-amount="30.00" data-overdue="60" data-status="UNPAID">
                                            <td class="ps-4">
                                                <input type="checkbox" class="form-check-input fine-row-checkbox" />
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-secondary-container text-on-secondary-container fw-bold" style="width: 36px; height: 36px;">
                                                        MK
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-bold">Maria Kovacs</p>
                                                        <small class="text-muted"><span class="member-badge member-lecturer me-1">Lecturer</span>ID: 108891</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <p class="mb-0 fw-bold text-truncate" style="max-width: 200px;" title="Quantum Mechanics: Concepts and Applications">Quantum Mechanics: Concepts and Applications</p>
                                                <small class="text-muted">Barcode: LMS-BK-22891</small>
                                            </td>
                                            <td><span class="small fw-semibold text-muted">Damaged Book</span></td>
                                            <td><span class="days-badge days-high">60 days</span></td>
                                            <td class="fw-bold text-danger">$30.00</td>
                                            <td><span class="status-badge status-unpaid">UNPAID</span></td>
                                            <td class="text-end pe-4">
                                                <div class="d-inline-flex gap-1 align-items-center">
                                                    <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=108891" class="btn btn-sm btn-primary-custom rounded-pill px-3 py-1 fw-bold" title="Collect payment">Collect</a>
                                                    <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold" title="Waive fine" onclick="waiveSingle('FINE-0060')">Waive</button>
                                                    <button class="btn btn-sm btn-icon" title="View details" onclick="openDrawer('FINE-0060', 'Maria Kovacs', 'Lecturer', '108891', 'Quantum Mechanics: Concepts and Applications', 'LMS-BK-22891', 'Damaged Book', '60 days', '$30.00', 'UNPAID', 'Borrow Date: Feb 14, 2026<br>Due Date: Apr 14, 2026', 'Damaged Book Penalty (Flat fee)', 'No payment has been recorded yet.')">
                                                        <span class="material-symbols-outlined" style="font-size: 20px;">visibility</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Fine Row 3 -->
                                        <tr data-id="FINE-0015" data-type="Late Return" data-amount="15.50" data-overdue="0" data-status="PAID">
                                            <td class="ps-4">
                                                <input type="checkbox" class="form-check-input fine-row-checkbox" />
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-light text-secondary fw-bold" style="width: 36px; height: 36px;">
                                                        EV
                                                    </div>
                                                    <div>
                                                        <p class="mb-0 fw-bold">Elena Vance</p>
                                                        <small class="text-muted"><span class="member-badge member-student me-1">Student</span>ID: 220042</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <p class="mb-0 fw-bold text-truncate" style="max-width: 200px;" title="Advanced Thermodynamics">Advanced Thermodynamics</p>
                                                <small class="text-muted">Barcode: LMS-BK-04882</small>
                                            </td>
                                            <td><span class="small fw-semibold text-muted">Late Return</span></td>
                                            <td><span class="text-muted">—</span></td>
                                            <td class="fw-bold text-success">$15.50</td>
                                            <td><span class="status-badge status-paid">PAID</span></td>
                                            <td class="text-end pe-4">
                                                <div class="d-inline-flex gap-2 align-items-center">
                                                    <span class="text-muted small">Cleared via VNPAY</span>
                                                    <button class="btn btn-sm btn-icon" title="View details" onclick="openDrawer('FINE-0015', 'Elena Vance', 'Student', '220042', 'Advanced Thermodynamics', 'LMS-BK-04882', 'Late Return', '—', '$15.50', 'PAID', 'Borrow Date: Apr 10, 2026<br>Due Date: May 10, 2026', 'Auto-calculated late penalty', 'Receipt: REC-2026-4402<br>Method: VNPAY Gateway<br>Amount: $15.50<br>Date: May 10, 2026')">
                                                        <span class="material-symbols-outlined" style="font-size: 20px;">visibility</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Dynamically generated rows from DB later -->
                                        <c:forEach var="fine" items="${finesList}">
                                            <tr data-id="${fine.id}" data-type="${fine.type}" data-amount="${fine.amount}" data-overdue="${fine.overdueDays}" data-status="${fine.status}">
                                                <td class="ps-4">
                                                    <input type="checkbox" class="form-check-input fine-row-checkbox" />
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 36px; height: 36px;">
                                                            ${fine.memberInitial}
                                                        </div>
                                                        <div>
                                                            <p class="mb-0 fw-bold">${fine.memberName}</p>
                                                            <small class="text-muted">
                                                                <span class="member-badge ${fine.memberRole == 'STUDENT' ? 'member-student' : 'member-lecturer'} me-1">${fine.memberRole}</span>
                                                                ID: ${fine.memberCode}
                                                            </small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="mb-0 fw-bold text-truncate" style="max-width: 200px;" title="${fine.bookTitle}">${fine.bookTitle}</p>
                                                    <small class="text-muted">Barcode: ${fine.barcode}</small>
                                                </td>
                                                <td><span class="small fw-semibold text-muted">${fine.type}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${fine.overdueDays > 0}">
                                                            <span class="days-badge ${fine.overdueDays <= 7 ? 'days-low' : (fine.overdueDays <= 30 ? 'days-medium' : 'days-high')}">${fine.overdueDays} days</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold ${fine.status == 'PAID' ? 'text-success' : 'text-danger'}">$${fine.amount}</td>
                                                <td>
                                                    <span class="status-badge ${fine.status == 'UNPAID' ? 'status-unpaid' : (fine.status == 'PAID' ? 'status-paid' : (fine.status == 'WAIVED' ? 'status-waived' : 'status-partial'))}">${fine.status}</span>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <div class="d-inline-flex gap-1 align-items-center">
                                                        <c:if test="${fine.status == 'UNPAID' || fine.status == 'PARTIAL'}">
                                                            <a href="${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=${fine.memberCode}" class="btn btn-sm btn-primary-custom rounded-pill px-3 py-1 fw-bold" title="Collect payment">Collect</a>
                                                            <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 py-1 fw-bold" title="Waive fine" onclick="waiveSingle('${fine.id}')">Waive</button>
                                                        </c:if>
                                                        <c:if test="${fine.status == 'PAID'}">
                                                            <span class="text-muted small">Cleared</span>
                                                        </c:if>
                                                        <c:if test="${fine.status == 'WAIVED'}">
                                                            <span class="text-muted small">Waived</span>
                                                        </c:if>
                                                        <button class="btn btn-sm btn-icon" title="View details" onclick="openDrawer('${fine.id}', '${fine.memberName}', '${fine.memberRole}', '${fine.memberCode}', '${fine.bookTitle}', '${fine.barcode}', '${fine.type}', '${fine.overdueDays} days', '$${fine.amount}', '${fine.status}', 'Borrow Date: ${fine.borrowDate}<br>Due Date: ${fine.dueDate}', '${fine.calculationFormula}', '${fine.paymentLog}')">
                                                            <span class="material-symbols-outlined" style="font-size: 20px;">visibility</span>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="p-3 bg-light border-top border-outline-variant d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3">
                        <span class="text-muted small">Showing 1-3 of 145 results</span>
                        
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <div class="d-flex align-items-center gap-2">
                                <span class="text-muted small" style="white-space: nowrap;">Rows per page:</span>
                                <select class="form-select form-select-sm rounded-3" style="width: 70px;">
                                    <option value="10">10</option>
                                    <option value="20" selected>20</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                </select>
                            </div>

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
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <!-- 6. Fine Detail Side Drawer (Fragment Include) -->
    <jsp:include page="fragments/_fine-drawer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript logic (Fragment Include) -->
    <jsp:include page="fragments/_fine-scripts.jsp" />
</body>
</html>
