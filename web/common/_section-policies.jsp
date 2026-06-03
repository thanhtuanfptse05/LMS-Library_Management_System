<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Policies Page -->

<!-- ── Page Hero Banner ──────────────────────────────────────────────── -->
<div style="background: linear-gradient(135deg, var(--primary-color) 0%, #b85c00 100%); padding: 56px 0 40px;">
    <div class="container-xl px-4">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0" style="font-size: 13px;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: rgba(255,255,255,0.7);">Home</a>
                </li>
                <li class="breadcrumb-item active" style="color: rgba(255,255,255,0.9);">Policies</li>
            </ol>
        </nav>
        <h1 class="fw-bold text-white mb-1" style="font-size: 36px;">Library Policies &amp; Guidelines</h1>
        <p class="mb-0" style="color: rgba(255,255,255,0.75); font-size: 16px;">
            Rules, regulations, and operating standards for all library patrons.
        </p>
    </div>
</div>

<!-- ── Main Content ──────────────────────────────────────────────────── -->
<section class="py-5" id="policies" style="background-color: var(--bs-body-bg);">
    <div class="container-xl px-4">
        <div class="policy-container shadow-sm">

            <!-- ── Sidebar Tabs ──────────────────────────────────── -->
            <div class="policy-sidebar">
                <p class="fw-bold text-uppercase mb-2 px-1"
                    style="font-size: 10px; letter-spacing: 0.1em; color: var(--text-muted-custom);">Sections</p>

                <button class="policy-btn active" onclick="switchPolicyTab(event, 'pane-general')">
                    <i class="bi bi-shield-check"></i>
                    General Policy
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-intro')">
                    <i class="bi bi-building-check"></i>
                    About the Library
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-rules')">
                    <i class="bi bi-journal-text"></i>
                    Rules &amp; Regulations
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-hours')">
                    <i class="bi bi-clock"></i>
                    Opening Hours
                </button>
            </div>

            <!-- ── Content Area ──────────────────────────────────── -->
            <div class="policy-content">

                <!-- TAB 1: GENERAL POLICY -->
                <div class="policy-pane active" id="pane-general">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-shield-check fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Library General Policy</h3>
                                <p class="policy-subtitle mb-0">Guidelines &amp; Scope of Application</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-people-fill" style="color: var(--primary-color);"></i>
                            1. Scope of Application
                        </h4>
                        <p class="mb-2 text-secondary">This policy applies to all authorized library users, including:</p>
                        <ul class="policy-list">
                            <li>Students</li>
                            <li>Faculty members</li>
                            <li>Staff members</li>
                            <li>Alumni (where permitted)</li>
                            <li>Visitors or other individuals authorized by the institution</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-book-half" style="color: var(--primary-color);"></i>
                            2. Library Usage Rights
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-building me-1" style="color: var(--primary-color);"></i> Study Spaces
                                    </h6>
                                    <p class="text-secondary small mb-0">Access reading areas, group study rooms, and library facilities per regulations.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-wifi me-1" style="color: var(--primary-color);"></i> Internet &amp; E-Resources
                                    </h6>
                                    <p class="text-secondary small mb-0">Access to academic databases, journals, e-books, and licensed online resources.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-eye me-1" style="color: var(--primary-color);"></i> On-Site Usage
                                    </h6>
                                    <p class="text-secondary small mb-0">Read materials on premises and access catalog information per regulations.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-arrow-left-right me-1" style="color: var(--primary-color);"></i> Borrowing &amp; Returning
                                    </h6>
                                    <p class="text-secondary small mb-0">Authorized users may borrow library materials per assigned borrowing privileges.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-database-fill" style="color: var(--primary-color);"></i>
                            3. Access to Academic Resources
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Users may access research articles, academic publications, theses, dissertations, and digital repositories. Use must comply with applicable copyright laws, intellectual property regulations, and licensing agreements.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-calendar-event-fill" style="color: var(--primary-color);"></i>
                            4. Library Events and Activities
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            The library organizes activities to promote reading culture and academic engagement, including book fairs, seminars, workshops, exhibitions, and research development programs.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-person-check-fill" style="color: var(--primary-color);"></i>
                            5. User Responsibilities
                        </h4>
                        <ul class="policy-list">
                            <li>Respecting and protecting library property and resources.</li>
                            <li>Following all library rules, policies, and staff instructions.</li>
                            <li>Maintaining a quiet and respectful environment.</li>
                            <li>Refraining from unauthorized copying, distribution, or misuse of copyrighted materials.</li>
                            <li>Compensating for lost, damaged, or improperly handled library materials.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-shield-fill-check" style="color: var(--primary-color);"></i>
                            6. Additional Provisions
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            The library reserves the right to modify policies, update borrowing and access regulations, and temporarily suspend or limit services for maintenance, upgrades, or operational requirements. This policy becomes effective upon publication.
                        </p>
                    </div>
                </div>

                <!-- TAB 2: ABOUT THE LIBRARY -->
                <div class="policy-pane" id="pane-intro">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-building-check fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">University Library Introduction</h3>
                                <p class="policy-subtitle mb-0">About UniLib &amp; Mission</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <p class="mb-0 fw-medium" style="font-size: 16px; line-height: 1.7; color: var(--primary-hover);">
                            The University Library is an academic resource and information center established to effectively support teaching, learning, scientific research, and knowledge development for faculty, staff, and students.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-gear-fill" style="color: var(--primary-color);"></i>
                            Library Functions
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            The library functions to collect, organize, store, preserve, and provide textbooks, reference materials, and scientific information to serve training, research, and learning needs within the university.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-check2-all" style="color: var(--primary-color);"></i>
                            Library Missions
                        </h4>
                        <ul class="policy-list">
                            <li>Collect, supplement, and develop resource collections aligned with academic majors and research directions.</li>
                            <li>Process, store, and preserve information resources in physical and digital formats.</li>
                            <li>Provide catalog search, circulation services, and information exploitation support.</li>
                            <li>Build and develop academic databases, digital libraries, and electronic resource portals.</li>
                            <li>Collect and archive university publications, theses, dissertations, and graduation projects.</li>
                            <li>Guide users to effectively exploit and utilize information resources.</li>
                            <li>Advise university leadership on strategies for developing resource collections.</li>
                            <li>Establish cooperative relations with external libraries and research organizations.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-collection-fill" style="color: var(--primary-color);"></i>
                            Library Resources
                        </h4>
                        <div class="row g-2 mt-1">
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-book mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Textbooks, reference books, and monographs</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-newspaper mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">National and international scientific journals</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-mortarboard mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Theses, dissertations, and graduation projects</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-database mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Online databases and digital libraries</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-film mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Multimedia materials and e-learning resources</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-globe mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Resources from international publishers and global databases</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 3: RULES & REGULATIONS -->
                <div class="policy-pane" id="pane-rules">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-journal-text fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Library Rules &amp; Regulations</h3>
                                <p class="policy-subtitle mb-0">Mandatory Rules for All Patrons</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Article 1</span>
                            Library Card
                        </h4>
                        <p class="mb-0 text-secondary">Your student ID card is your Library card. Use your Student or Staff ID card to access Library services and resources. Library cards are non-transferrable.</p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Article 2</span>
                            Opening Hours
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Day</th>
                                        <th>Hours</th>
                                        <th>Service Mode</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Monday – Friday</strong></td>
                                        <td>08:15 – 21:00</td>
                                        <td>Full services</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Saturday – Sunday</strong></td>
                                        <td>08:00 – 17:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #f97316; font-size: 11px;">Self-study only</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Article 3</span>
                            Library Services
                        </h4>
                        <div class="row g-2 mt-1">
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-arrow-left-right" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Borrow / Return</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-search" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Catalog Search</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-headset" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Info Consulting</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-wifi" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">E-Resources</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-clipboard-check" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Request Materials</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-people" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Group Work Rooms</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Article 4</span>
                            General Regulations
                        </h4>
                        <ul class="policy-list">
                            <li><strong>4.1 Card Verification:</strong> Present a valid card to enter. Cards are non-transferrable.</li>
                            <li><strong>4.2 Silence:</strong> Loud conversation is forbidden throughout the Library.</li>
                            <li><strong>4.3 Cleanliness:</strong> Keep the library clean. No smoking, no graffiti, no littering.</li>
                            <li><strong>4.4 Food &amp; Drink:</strong> Food, drink, and hazardous substances are strictly forbidden.</li>
                            <li><strong>4.5 Mobile Devices:</strong> Set mobile phones to silent mode. No calls inside study areas.</li>
                            <li><strong>4.6 Book Care:</strong> Do not use pencils, pens, or highlighters in the books.</li>
                            <li><strong>4.7 Page Protection:</strong> Do not bend or tear the pages of books.</li>
                            <li><strong>4.8 Damage Prevention:</strong> Do not let books get wet, mouldy, or damaged.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Article 5</span>
                            Circulation Policies
                        </h4>
                        <ul class="policy-list">
                            <li><strong>5.1 Returning:</strong> Place books in the designated area. Do not arrange books on shelves freely.</li>
                            <li><strong>5.2 Book Removal:</strong> Materials may not be taken out without permission of the Librarian.</li>
                            <li><strong>5.3 Textbooks:</strong> Delivered per academic calendar. Renewable for up to 1 week with valid reason.</li>
                            <li><strong>5.4 Reference Books:</strong> Borrow up to 10 titles. Loan: 1 week (Vietnamese) / 2 weeks (foreign language). Up to 4 renewals.</li>
                            <li><strong>5.5 Borrowing Check:</strong> Verify the list of borrowed books and note any pre-existing damage with the librarian.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #dc3545;">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: #dc3545; font-size: 11px;">Article 6</span>
                            Fines &amp; Penalties
                        </h4>
                        <ul class="policy-list">
                            <li><strong>6.1 Violations:</strong> Patrons who violate Articles 4 and 5 may be reminded, penalized, or requested to leave.</li>
                            <li><strong>6.2 Damaged Items:</strong> Items that can still be used will incur a fee based on severity of damage.</li>
                            <li><strong>6.3 Overdue Fines:</strong> <strong style="color: #dc3545;">5,000 VNĐ / item / day</strong> (including weekends and holidays).</li>
                            <li><strong>6.4 Compensation:</strong> Patrons must compensate for any damages as prescribed by regulations.</li>
                        </ul>
                    </div>
                </div>

                <!-- TAB 4: OPENING HOURS -->
                <div class="policy-pane" id="pane-hours">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-clock fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Library Opening Hours</h3>
                                <p class="policy-subtitle mb-0">Standard Hours of Operation</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-calendar3" style="color: var(--primary-color);"></i>
                            1. Weekly Schedule
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Day</th>
                                        <th>Opening Hours</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Monday – Friday</strong></td>
                                        <td>08:00 – 20:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #198754; font-size: 11px;">Open</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Saturday</strong></td>
                                        <td>08:00 – 17:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #198754; font-size: 11px;">Open</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Sunday</strong></td>
                                        <td>—</td>
                                        <td><span class="badge rounded-pill bg-danger" style="font-size: 11px;">Closed</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-arrow-left-right" style="color: var(--primary-color);"></i>
                            2. Borrowing &amp; Returning Services
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 text-center" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <i class="bi bi-sun" style="font-size: 28px; color: var(--primary-color);"></i>
                                    <h6 class="fw-bold mt-2 mb-1">Morning Session</h6>
                                    <p class="mb-0 fw-semibold" style="color: var(--primary-color);">08:00 – 12:00</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 text-center" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <i class="bi bi-brightness-alt-high" style="font-size: 28px; color: var(--primary-color);"></i>
                                    <h6 class="fw-bold mt-2 mb-1">Afternoon Session</h6>
                                    <p class="mb-0 fw-semibold" style="color: var(--primary-color);">13:00 – 17:00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            3. Important Notes
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Outside the official borrowing and returning service hours, the library may only provide study space and reading services. Please plan your visits accordingly.
                        </p>
                    </div>
                </div>

            </div><!-- /.policy-content -->
        </div><!-- /.policy-container -->
    </div>
</section>
