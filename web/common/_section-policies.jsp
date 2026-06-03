<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Quick Instructions & Policies -->
<section class="py-5 container-xl" id="policies">
    <div class="mb-4">
        <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">Regulations</span>
        <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Library Policies & Guidelines</h2>
    </div>
    
    <div class="policy-container">
        <!-- Sidebar Tabs -->
        <div class="policy-sidebar">
            <button class="policy-btn active" onclick="switchPolicyTab(event, 'pane-general')">
                <span class="material-symbols-outlined">gavel</span>
                General Policy
            </button>
            <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-intro')">
                <span class="material-symbols-outlined">info</span>
                About the Library
            </button>
            <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-rules')">
                <span class="material-symbols-outlined">menu_book</span>
                Rules & Regulations
            </button>
            <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-hours')">
                <span class="material-symbols-outlined">schedule</span>
                Opening Hours
            </button>
        </div>

        <!-- Content Area -->
        <div class="policy-content">
            
            <!-- TAB 1: GENERAL POLICY -->
            <div class="policy-pane active" id="pane-general">
                <div class="policy-header">
                    <h3 class="policy-title">LIBRARY GENERAL POLICY</h3>
                    <p class="policy-subtitle">Guidelines & Scope of Application</p>
                </div>
                
                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">group</span>
                        1. Scope of Application
                    </h4>
                    <p class="mb-0">This policy applies to all authorized library users, including:</p>
                    <ul class="policy-list mt-2">
                        <li>Students</li>
                        <li>Faculty members</li>
                        <li>Staff members</li>
                        <li>Alumni (where permitted)</li>
                        <li>Visitors or other individuals authorized by the institution</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">menu_book</span>
                        2. Library Usage Rights
                    </h4>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">2.1. Study and Collaborative Spaces</h5>
                    <p>The library provides study, research, and collaborative learning spaces to support academic and educational activities. Users may access reading areas, use group study rooms (if available), and utilize library facilities/equipment in accordance with regulations.</p>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">2.2. Internet and Electronic Resource Access</h5>
                    <p>The library provides access to the Internet and electronic resources for educational, research, and academic purposes. Available resources may include: academic databases, scholarly journals, electronic books (e-books), theses and dissertations, institutional repositories, and licensed online resources. Access privileges may vary according to institutional policies.</p>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">2.3. On-Site Resource Usage</h5>
                    <p>Users are permitted to read library materials within the library premises, search and access catalog information, and use reference materials in accordance with regulations. Certain special collections, archival materials, or reference resources may be restricted to on-site use only.</p>
                    
                    <h5 class="fw-bold fs-6 mt-3 text-secondary">2.4. Borrowing and Returning Materials</h5>
                    <p>Authorized users may borrow library materials according to their assigned borrowing privileges. Regulations regarding borrowing limits, loan periods, renewals, and reservation requests shall be determined by the respective institution or library administration.</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">database</span>
                        3. Access to Academic Resources
                    </h4>
                    <p class="mb-0">Users may be granted access to research articles, academic publications, theses, dissertations, learning materials, and digital repositories. The use of these resources must comply with applicable copyright laws, intellectual property regulations, and licensing agreements.</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">local_activity</span>
                        4. Library Events and Activities
                    </h4>
                    <p class="mb-0">The library may organize activities that promote reading culture, research, and academic engagement, including: book fairs, reading campaigns, academic competitions, seminars, workshops, exhibitions, and research development programs. Eligible users may participate in these activities according to guidelines.</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">assignment_ind</span>
                        5. User Responsibilities
                    </h4>
                    <ul class="policy-list">
                        <li>Respecting and protecting library property and resources.</li>
                        <li>Following all library rules, policies, and staff instructions.</li>
                        <li>Maintaining a quiet and respectful environment.</li>
                        <li>Refraining from unauthorized copying, distribution, or misuse of copyrighted materials.</li>
                        <li>Compensating for lost, damaged, or improperly handled library materials and equipment as required by regulations.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">shield</span>
                        6. Additional Provisions
                    </h4>
                    <p class="mb-0">The library or institution reserves the right to modify policies and regulations, update borrowing, access, and service policies, and temporarily suspend or limit services for maintenance, upgrades, security, or operational requirements. This policy becomes effective upon publication.</p>
                </div>
            </div>

            <!-- TAB 2: ABOUT THE LIBRARY -->
            <div class="policy-pane" id="pane-intro">
                <div class="policy-header">
                    <h3 class="policy-title">UNIVERSITY LIBRARY INTRODUCTION</h3>
                    <p class="policy-subtitle">About UniLib Library & Mission</p>
                </div>
                
                <div class="policy-card">
                    <p class="lead text-secondary-custom fw-medium mb-0" style="font-size: 16px; line-height: 1.6;">
                        The University Library is an academic resource and information center directly under the university, established to effectively support teaching, learning, scientific research, and knowledge development activities for faculty, staff, and students.
                    </p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">settings_suggest</span>
                        Library Functions
                    </h4>
                    <p class="mb-0">
                        The library functions to collect, organize, store, preserve, and provide textbooks, reference materials, and scientific information to serve training, research, and learning needs within the university.
                    </p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">task</span>
                        Library Missions
                    </h4>
                    <ul class="policy-list">
                        <li>Collect, supplement, and develop resource collections aligned with the university's academic majors and research directions.</li>
                        <li>Process, store, and preserve information resources in various physical and digital formats.</li>
                        <li>Provide catalog search, circulation (borrowing/returning) services, and information exploitation support for learners, faculty, and researchers.</li>
                        <li>Build and develop academic databases, digital libraries, and electronic resource portals.</li>
                        <li>Collect and archive university publications, scientific research projects, theses, dissertations, and graduation projects.</li>
                        <li>Guide users to effectively exploit and utilize information resources and learning materials.</li>
                        <li>Advise university leadership on strategies for developing resource collections and the library information system.</li>
                        <li>Establish and expand cooperative relations with external libraries, information centers, educational and research organizations to share information resources.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">library_books</span>
                        Library Resources
                    </h4>
                    <p class="mb-2">The university library possesses a diverse range of resources, including:</p>
                    <ul class="policy-list">
                        <li>Textbooks, reference books, and monographs.</li>
                        <li>National and international newspapers and scientific journals.</li>
                        <li>Theses, dissertations, and graduation projects.</li>
                        <li>Online databases and digital libraries.</li>
                        <li>Multimedia materials (CDs, DVDs, educational videos, and e-learning resources).</li>
                        <li>Academic information resources from international publishers and global databases.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">stars</span>
                        Library Role
                    </h4>
                    <p class="mb-0">
                        The library acts as the university's knowledge hub, contributing to improving the quality of training, scientific research, and developing self-learning and independent research skills for learners in a modern higher education environment.
                    </p>
                </div>
            </div>

            <!-- TAB 3: RULES & REGULATIONS -->
            <div class="policy-pane" id="pane-rules">
                <div class="policy-header">
                    <h3 class="policy-title">LIBRARY RULES & REGULATIONS</h3>
                    <p class="policy-subtitle">Mandatory Rules for All Patrons</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 1</span>
                        How to get library card?
                    </h4>
                    <p class="mb-0">Your student ID card is your Library card. Use your Student or Staff ID card to access Library services and resources. Library cards are non-transferrable.</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 2</span>
                        Opening Hours
                    </h4>
                    <ul class="policy-list">
                        <li><strong>Monday - Friday:</strong> 8:15 – 21:00</li>
                        <li><strong>Weekend:</strong> 8:00 – 12:00, 13:00 – 17:00</li>
                        <li><em>Note:</em> On evenings and weekends, the library only serves self-study.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 3</span>
                        Library Services
                    </h4>
                    <p class="mb-2">The library provides the following core services to students and staff:</p>
                    <div class="row g-2">
                        <div class="col-md-6">
                            <ul class="policy-list">
                                <li>3.1 Circulation (Borrow/Return)</li>
                                <li>3.2 Seeking Information</li>
                                <li>3.3 Information Consulting</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="policy-list">
                                <li>3.4 Log-on-to E-resource</li>
                                <li>3.5 Request Materials</li>
                                <li>3.6 Interlibrary Loan</li>
                                <li>3.7 Group Work Rooms</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 4</span>
                        General Regulations
                    </h4>
                    <ul class="policy-list">
                        <li><strong>4.1 Card Verification:</strong> Patrons must present a valid card to enter the library. Cards are strictly non-transferrable.</li>
                        <li><strong>4.2 Silence:</strong> Loud conversation is forbidden throughout the Library.</li>
                        <li><strong>4.3 Cleanliness:</strong> Please consciously keep the library clean. No smoking, no graffiti, no littering inside the premises.</li>
                        <li><strong>4.4 Food & Drink:</strong> Food, drink, toxic and explosive substances in the Library are strictly forbidden.</li>
                        <li><strong>4.5 Mobile Devices:</strong> Please keep quiet in the library and set mobile phones or computers to silent mode. Do not talk via phone inside study areas.</li>
                        <li><strong>4.6 Book Care:</strong> Do not use pencils, pens, or highlighters in the books.</li>
                        <li><strong>4.7 Page Protection:</strong> Do not bend or tear the pages of the books.</li>
                        <li><strong>4.8 Damage Prevention:</strong> Do not let books get wet, mouldy, or damaged in any way.</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 5</span>
                        Circulation Policies
                    </h4>
                    <ul class="policy-list">
                        <li><strong>5.1 Returning Books:</strong> Place books in the designated area after finishing. Do not arrange books on the shelf freely.</li>
                        <li><strong>5.2 Book Removal:</strong> Materials may not be taken out of the library without permission of the Librarian.</li>
                        <li><strong>5.3 Textbooks (Semester/Block):</strong> Textbooks are delivered according to the academic calendar. Textbooks can only be renewed for up to 1 week with suitable reasons.</li>
                        <li><strong>5.4 Reference Textbooks:</strong> 1 week after a new block starts, patrons can borrow textbooks as reference books.</li>
                        <li><strong>5.5 Reference Books:</strong> Patrons can borrow up to 10 titles. The loan period is 1 week for mother-tongue books and 2 weeks for foreign language books. Renewals are allowed up to 4 times.</li>
                        <li><strong>5.6 Borrowing Check:</strong> Patrons should:
                            <ul class="policy-list mt-1">
                                <li>5.6.1 Check the list of books borrowed and confirm with the librarian.</li>
                                <li>5.6.2 Make sure book condition notes at the end of borrowed books are updated. You are responsible for the condition of everything while it is on loan. Please take good care of books or compensate for damages.</li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="badge bg-primary-container text-white px-2 py-1 me-2 rounded-2" style="font-size: 11px;">Article 6</span>
                        Fines & Penalties
                    </h4>
                    <ul class="policy-list">
                        <li><strong>6.1 Violations:</strong> Patrons who violate regulations in Article 4 and 5 may be reminded, punished, or requested to leave the library. Librarians can write violation reports and suspend services. In severe situations, students may face expulsion.</li>
                        <li><strong>6.2 Damaged Items:</strong> Damaged items that can still be used will incur a fee based on the severity of the damage. If a book is lost or damaged beyond repair, you must purchase a replacement.</li>
                        <li><strong>6.3 Overdue Fines:</strong> Overdue books will be fined <strong>5,000 VNĐ / item / day</strong> (including weekends and holidays).</li>
                        <li><strong>6.4 Compensation:</strong> In any situation, patrons must compensate for damages as prescribed.</li>
                    </ul>
                </div>
            </div>

            <!-- TAB 4: OPENING HOURS -->
            <div class="policy-pane" id="pane-hours">
                <div class="policy-header">
                    <h3 class="policy-title">LIBRARY OPENING HOURS</h3>
                    <p class="policy-subtitle">Standard Hours of Operation</p>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">schedule</span>
                        1. Operating Schedule
                    </h4>
                    <div class="table-responsive">
                        <table class="table-policy">
                            <thead>
                                <tr>
                                    <th>Day</th>
                                    <th>Opening Hours</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>Monday – Friday</strong></td>
                                    <td>08:00 – 20:00</td>
                                </tr>
                                <tr>
                                    <td><strong>Saturday</strong></td>
                                    <td>08:00 – 17:00</td>
                                </tr>
                                <tr>
                                    <td><strong>Sunday</strong></td>
                                    <td><span class="badge bg-danger text-white px-2 py-1 rounded-2" style="font-size: 11px;">Closed</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">autorenew</span>
                        2. Borrowing & Returning Services
                    </h4>
                    <ul class="policy-list">
                        <li><strong>Morning:</strong> 08:00 – 12:00</li>
                        <li><strong>Afternoon:</strong> 13:00 – 17:00</li>
                    </ul>
                </div>

                <div class="policy-card">
                    <h4 class="policy-card-title">
                        <span class="material-symbols-outlined">info</span>
                        3. Important Notes
                    </h4>
                    <p class="mb-0 text-secondary-custom">
                        Outside the official borrowing and returning service hours, the library may only provide study space and reading services.
                    </p>
                </div>
            </div>
            
        </div>
    </div>
</section>
