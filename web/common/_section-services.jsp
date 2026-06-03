<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Services Page -->

<!-- ── Page Hero Banner ──────────────────────────────────────────────── -->
<div style="background: linear-gradient(135deg, var(--primary-color) 0%, #b85c00 100%); padding: 56px 0 40px;">
    <div class="container-xl px-4">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0" style="font-size: 13px;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: rgba(255,255,255,0.7);">Home</a>
                </li>
                <li class="breadcrumb-item active" style="color: rgba(255,255,255,0.9);">Services</li>
            </ol>
        </nav>
        <h1 class="fw-bold text-white mb-1" style="font-size: 36px;">Library Services</h1>
        <p class="mb-0" style="color: rgba(255,255,255,0.75); font-size: 16px;">
            Everything you need to access, borrow, and manage library resources.
        </p>
    </div>
</div>

<!-- ── Main Content ──────────────────────────────────────────────────── -->
<section class="py-5" id="services" style="background-color: var(--bs-body-bg);">
    <div class="container-xl px-4">
        <div class="policy-container shadow-sm">

            <!-- ── Sidebar Tabs ──────────────────────────────────── -->
            <div class="policy-sidebar">
                <p class="fw-bold text-uppercase mb-2 px-1"
                    style="font-size: 10px; letter-spacing: 0.1em; color: var(--text-muted-custom);">Categories</p>

                <button class="policy-btn active" onclick="switchServiceTab(event, 'pane-circulation')">
                    <i class="bi bi-arrow-left-right"></i>
                    Circulation Services
                </button>
                <button class="policy-btn" onclick="switchServiceTab(event, 'pane-renewal')">
                    <i class="bi bi-arrow-clockwise"></i>
                    Renewal Services
                </button>
                <button class="policy-btn" onclick="switchServiceTab(event, 'pane-fees')">
                    <i class="bi bi-cash-coin"></i>
                    Library Fees
                </button>
            </div>

            <!-- ── Content Area ──────────────────────────────────── -->
            <div class="policy-content">

                <!-- TAB 1: CIRCULATION SERVICES -->
                <div class="policy-pane active" id="pane-circulation">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-arrow-left-right fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Circulation Services</h3>
                                <p class="policy-subtitle mb-0">Borrowing &amp; Returning Materials</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            1. Purpose
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            The borrowing and returning service is designed to support students, lecturers, and staff in accessing, exploiting, and effectively utilizing library learning resources for learning, teaching, and research.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-people-fill" style="color: var(--primary-color);"></i>
                            2. Target Patrons
                        </h4>
                        <p class="mb-2 text-secondary">This service is available to:</p>
                        <ul class="policy-list">
                            <li>Students and trainees currently enrolled at the university.</li>
                            <li>Lecturers, officers, and staff members of the university.</li>
                            <li>Other eligible users according to library regulations.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-journal-check" style="color: var(--primary-color);"></i>
                            3. Borrowing Regulations
                        </h4>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.1. Borrowing Conditions</h6>
                        <ul class="policy-list mb-3">
                            <li>Possess a valid student card, staff card, or official identification documents.</li>
                            <li>Do not use another individual's card to borrow library materials.</li>
                            <li>Must not be in violation of any library rules.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.2. Borrowing Procedures</h6>
                        <ul class="policy-list mb-3">
                            <li>Search and select suitable materials via the catalog search system.</li>
                            <li>Bring materials to the circulation counter or complete checkout as instructed.</li>
                            <li>Inspect physical condition of materials before completing checkout.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.3. Loan Periods</h6>
                        <ul class="policy-list mb-3">
                            <li>Loan periods vary depending on the type of materials and user category.</li>
                            <li>Users can renew items if they are not reserved by other patrons.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.4. Patron Responsibilities</h6>
                        <ul class="policy-list">
                            <li>Take proper care of borrowed items during the loan period.</li>
                            <li>Do not write, draw, erase, tear, wet, or cause damage to materials.</li>
                            <li>Notify the librarian of any pre-existing damage upon receipt.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-box-arrow-in-left" style="color: var(--primary-color);"></i>
                            4. Returning Regulations
                        </h4>
                        <ul class="policy-list">
                            <li>Users must return borrowed materials on or before the designated due date.</li>
                            <li>Returns must be processed at the library counter or via designated drop boxes.</li>
                            <li>Users may authorize others to return materials, but remain responsible.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #dc3545;">
                        <h4 class="policy-card-title">
                            <i class="bi bi-exclamation-triangle-fill" style="color: #dc3545;"></i>
                            5. Violations &amp; Penalties
                        </h4>
                        <p class="mb-2 text-secondary">Users may be subject to disciplinary actions for:</p>
                        <ul class="policy-list mb-2">
                            <li>Late return of library materials.</li>
                            <li>Loss of library materials.</li>
                            <li>Damage to library materials.</li>
                            <li>Violating other library regulations.</li>
                        </ul>
                        <p class="mb-0 text-muted small fst-italic">
                            * Specific penalties and fine amounts are applied according to the current active regulations of the library.
                        </p>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-headset" style="color: var(--primary-color);"></i>
                            6. Support Information
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Contact the library for assistance with borrowing, returning, renewing, or searching for materials through the official communication channels.
                        </p>
                    </div>
                </div>

                <!-- TAB 2: RENEWAL SERVICES -->
                <div class="policy-pane" id="pane-renewal">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-arrow-clockwise fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Document Renewal Services</h3>
                                <p class="policy-subtitle mb-0">Extending Loan Duration</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            1. Purpose
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            The renewal service assists users in extending the loan duration of borrowed materials when they require additional time for academic studies, teaching, or research.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-check2-circle" style="color: var(--primary-color);"></i>
                            2. Conditions for Renewal
                        </h4>
                        <p class="mb-2 text-secondary">Renewals are granted under the following conditions:</p>
                        <ul class="policy-list">
                            <li>The materials are currently within a valid loan period (not overdue).</li>
                            <li>The materials are not restricted from renewal under library regulations.</li>
                            <li>The user has no outstanding violations regarding borrowing or returning.</li>
                            <li>The materials have not been reserved or requested by another user.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-journal-text" style="color: var(--primary-color);"></i>
                            3. Renewal Regulations
                        </h4>
                        <ul class="policy-list">
                            <li>The number of renewals allowed and renewal durations are set according to library regulations.</li>
                            <li>The renewal period may vary based on item type and user category.</li>
                            <li>The library reserves the right to deny renewal requests under special circumstances.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-grid-1x2" style="color: var(--primary-color);"></i>
                            4. Renewal Methods
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <span class="badge fw-semibold rounded-pill" style="background-color: var(--primary-color); font-size: 11px;">★ Recommended</span>
                                    </div>
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-laptop me-1" style="color: var(--primary-color);"></i> Online Renewal
                                    </h6>
                                    <p class="text-secondary small mb-0">Log in to the Library Management System, go to active loans, and click "Renew".</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-envelope me-1" style="color: var(--primary-color);"></i> Email Request
                                    </h6>
                                    <p class="text-secondary small mb-0">Send full name, Student/Staff ID, and book details to the library support address.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-building me-1" style="color: var(--primary-color);"></i> In Person
                                    </h6>
                                    <p class="text-secondary small mb-0">Visit the circulation desk directly during operating hours.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-chat-dots me-1" style="color: var(--primary-color);"></i> Support Channels
                                    </h6>
                                    <p class="text-secondary small mb-0">Submit via official fanpage, support ticket portal, or other platforms.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #f97316;">
                        <h4 class="policy-card-title">
                            <i class="bi bi-exclamation-circle-fill" style="color: #f97316;"></i>
                            5. Important Notes
                        </h4>
                        <ul class="policy-list">
                            <li>Submit renewal requests <strong>prior to</strong> the current due date.</li>
                            <li>Submitting a renewal request does <strong>not guarantee</strong> approval.</li>
                            <li>Verify the updated due date on the system or through library confirmation.</li>
                            <li>If the renewal is declined, materials must be returned on time to avoid overdue fines.</li>
                        </ul>
                    </div>
                </div>

                <!-- TAB 3: LIBRARY FEES -->
                <div class="policy-pane" id="pane-fees">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-cash-coin fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Library Fees</h3>
                                <p class="policy-subtitle mb-0">Fee Structure &amp; Fine Regulations</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-clock-history" style="color: var(--primary-color);"></i>
                            Overdue Fines
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Violation</th>
                                        <th>Fine Rate</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Overdue return</td>
                                        <td><strong style="color: #dc3545;">5,000 VNĐ / item / day</strong></td>
                                        <td>Including weekends &amp; holidays</td>
                                    </tr>
                                    <tr>
                                        <td>Lost item</td>
                                        <td>Replacement cost</td>
                                        <td>Purchase equivalent replacement</td>
                                    </tr>
                                    <tr>
                                        <td>Damaged item (repairable)</td>
                                        <td>Based on damage severity</td>
                                        <td>Assessed by librarian</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card text-center py-4" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <i class="bi bi-bell" style="font-size: 48px; color: var(--primary-color);"></i>
                        <h5 class="fw-bold mt-3 mb-2">Full Fee Schedule Coming Soon</h5>
                        <p class="text-muted mb-3" style="max-width: 400px; margin: 0 auto;">
                            The complete library fee and fine schedule is being finalized. Contact the circulation desk for current fee information.
                        </p>
                        <a href="#contact" class="btn btn-primary-custom px-4 py-2 rounded-3 fw-semibold" style="font-size: 14px;">
                            <i class="bi bi-headset me-1"></i> Contact Library
                        </a>
                    </div>
                </div>

            </div><!-- /.policy-content -->
        </div><!-- /.policy-container -->
    </div>
</section>
