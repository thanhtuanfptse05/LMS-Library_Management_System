<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Services Section -->
<section class="py-5 container-xl" id="services">
    <div class="mb-4">
        <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">OUR SERVICES</span>
        <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Library Services</h2>
    </div>
    
    <div class="policy-container">
        <!-- Sidebar Tabs -->
        <div class="policy-sidebar">
            <button class="policy-btn active" onclick="switchServiceTab(event, 'pane-circulation')">
                <span class="material-symbols-outlined">sync_alt</span>
                Circulation Services
            </button>
            <button class="policy-btn" onclick="switchServiceTab(event, 'pane-renewal')">
                <span class="material-symbols-outlined">autorenew</span>
                Renewal Services
            </button>
            <button class="policy-btn" onclick="switchServiceTab(event, 'pane-fees')">
                <span class="material-symbols-outlined">payments</span>
                Library Fees
            </button>
        </div>

        <!-- Content Area -->
        <div class="policy-content">
            
            <!-- TAB 1: CIRCULATION SERVICES -->
            <div class="policy-pane active" id="pane-circulation">
                <div class="policy-header">
                    <h3 class="policy-title">CIRCULATION SERVICES</h3>
                    <p class="policy-subtitle">Borrowing & Returning Materials</p>
                </div>
                
                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">info</span>
                        1. Purpose
                    </h4>
                    <p class="mb-0">
                        The borrowing and returning service is designed to support students, lecturers, and staff in accessing, exploiting, and effectively utilizing library learning resources for learning, teaching, and research.
                    </p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">group</span>
                        2. Target Patrons
                    </h4>
                    <p class="mb-2">This service is available to:</p>
                    <ul class="policy-list">
                        <li>Students and trainees currently enrolled at the university.</li>
                        <li>Lecturers, officers, and staff members of the university.</li>
                        <li>Other eligible users according to library regulations.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">gavel</span>
                        3. Borrowing Regulations
                    </h4>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">3.1. Borrowing Conditions</h5>
                    <p class="mb-2">Users must satisfy the following requirements:</p>
                    <ul class="policy-list mb-3">
                        <li>Possess a valid student card, staff card, or official identification documents as required.</li>
                        <li>Do not use another individual's card to borrow library materials.</li>
                        <li>Must not be in violation of any library rules.</li>
                    </ul>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">3.2. Borrowing Procedures</h5>
                    <ul class="policy-list mb-3">
                        <li>Search and select suitable materials at the library or via the catalog search system.</li>
                        <li>Bring the materials to the circulation counter or complete checkout procedures as instructed by library staff.</li>
                        <li>Inspect the physical condition of the materials before completing checkout.</li>
                    </ul>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">3.3. Loan Periods</h5>
                    <ul class="policy-list mb-3">
                        <li>Loan periods vary depending on the type of library materials and user categories.</li>
                        <li>Users can renew borrowed items in accordance with library regulations if they are not reserved by other patrons.</li>
                    </ul>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">3.4. Patron Responsibilities</h5>
                    <ul class="policy-list">
                        <li>Take proper care of borrowed items during the loan period.</li>
                        <li>Do not write, draw, erase, tear, wet, or cause any damage to the materials.</li>
                        <li>Inspect items immediately upon receipt and notify the librarian of any pre-existing damage.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">keyboard_return</span>
                        4. Returning Regulations
                    </h4>
                    <ul class="policy-list">
                        <li>Users must return borrowed materials on or before the designated due date.</li>
                        <li>Returns must be processed at the library counter or via designated return drop boxes.</li>
                        <li>Users may authorize others to return materials on their behalf, but they remain responsible for the return condition and promptness.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">warning</span>
                        5. Violations & Penalties
                    </h4>
                    <p class="mb-2">Users may be subject to disciplinary actions in the following cases:</p>
                    <ul class="policy-list mb-2">
                        <li>Late return of library materials.</li>
                        <li>Loss of library materials.</li>
                        <li>Damage to library materials.</li>
                        <li>Violating other library regulations.</li>
                    </ul>
                    <p class="mb-0 text-muted small">
                        * Specific penalties and fine amounts will be applied according to the current active regulations of the library.
                    </p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">contact_support</span>
                        6. Support Information
                    </h4>
                    <p class="mb-0">
                        Users can contact the library for assistance with borrowing, returning, renewing, or searching for materials through the official communication channels provided by the library.
                    </p>
                </div>
            </div>

            <!-- TAB 2: RENEWAL SERVICES -->
            <div class="policy-pane" id="pane-renewal">
                <div class="policy-header">
                    <h3 class="policy-title">DOCUMENT RENEWAL SERVICES</h3>
                    <p class="policy-subtitle">Extending Loan Duration</p>
                </div>
                
                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">info</span>
                        1. Purpose
                    </h4>
                    <p class="mb-0">
                        The renewal service assists users in extending the loan duration of borrowed materials when they require additional time for academic studies, teaching, or research.
                    </p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">fact_check</span>
                        2. Conditions for Renewal
                    </h4>
                    <p class="mb-2">Renewals are granted under the following conditions:</p>
                    <ul class="policy-list">
                        <li>The materials are currently within a valid loan period (not overdue).</li>
                        <li>The materials are not restricted from renewal under library regulations.</li>
                        <li>The user has no outstanding violations regarding borrowing or returning materials.</li>
                        <li>The materials have not been reserved or requested by another user.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">rule</span>
                        3. Renewal Regulations
                    </h4>
                    <ul class="policy-list">
                        <li>The number of renewals allowed and renewal durations are set according to library regulations.</li>
                        <li>The renewal period may vary based on the item type and user category.</li>
                        <li>The library reserves the right to deny renewal requests under special circumstances.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">handshake</span>
                        4. Renewal Methods
                    </h4>
                    <p class="mb-3">Users can renew library materials through one of the following methods:</p>
                    
                    <h6 class="fw-bold text-dark mb-1">Method 1: Online Renewal (Recommended)</h6>
                    <p class="text-secondary-custom mb-3">Log in to the Library Management System, access the active loans section, and click on the "Renew" button next to your borrowed item.</p>
                    
                    <h6 class="fw-bold text-dark mb-1">Method 2: Email Request</h6>
                    <p class="text-secondary-custom mb-1">Send an email to the library support address containing the following details:</p>
                    <ul class="policy-list mb-3">
                        <li>Full name of the borrower.</li>
                        <li>Student / Staff ID.</li>
                        <li>Information about the materials to be renewed (title, barcode, or call number).</li>
                        <li>Reason for the renewal.</li>
                        <li>Desired extension period (if applicable).</li>
                    </ul>
                    
                    <h6 class="fw-bold text-dark mb-1">Method 3: Direct Contact</h6>
                    <p class="text-secondary-custom mb-3">Visit the circulation desk in person for assistance, or call the official library phone number during operating hours.</p>
                    
                    <h6 class="fw-bold text-dark mb-1">Method 4: Support Channels</h6>
                    <p class="text-secondary-custom mb-0">Submit renewal requests via the library's official fanpage, support ticket portal, or other official communication platforms.</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">priority_high</span>
                        5. Important Notes
                    </h4>
                    <ul class="policy-list">
                        <li>Users should submit renewal requests prior to the current due date.</li>
                        <li>Submitting a renewal request does not guarantee approval. The final outcome is subject to library rules and real-time item status.</li>
                        <li>Patrons are responsible for verifying the updated due date on the system or through library confirmation.</li>
                        <li>If the renewal is declined, the materials must be returned on time to avoid overdue fines.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">help_center</span>
                        6. Support
                    </h4>
                    <p class="mb-0">
                        For any inquiries regarding renewals, please contact the library support staff through the official help channels for guidance and assistance.
                    </p>
                </div>
            </div>

            <!-- TAB 3: LIBRARY FEES -->
            <div class="policy-pane" id="pane-fees">
                <div class="policy-header">
                    <h3 class="policy-title">LIBRARY FEES</h3>
                    <p class="policy-subtitle">Fee Structure & Fine Regulations</p>
                </div>
                
                <div class="policy-card text-center py-5">
                    <span class="material-symbols-outlined text-muted" style="font-size: 64px;">payments</span>
                    <h4 class="fw-bold mt-3 mb-2">Fee Information Coming Soon</h4>
                    <p class="text-muted mx-auto" style="max-width: 450px;">
                        The library fee and fine schedule is currently being updated. Please check back later or contact the circulation desk directly for any immediate inquiries.
                    </p>
                </div>
            </div>
            
        </div>
    </div>
</section>
