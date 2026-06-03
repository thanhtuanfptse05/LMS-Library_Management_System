<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>UniLib LMS - University Library Guest Portal</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&amp;display=swap"
        rel="stylesheet" />

    <!-- Material Symbols -->
    <link
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
        rel="stylesheet" />

    <style>
        :root {
            --primary-color: #9d4300;
            --primary-container: #f97316;
            --on-surface: #191c1e;
            --secondary: #565e74;
            --bg-background: #f7f9fb;
            --surface-container-low: #f2f4f6;
            --surface-container-highest: #e0e3e5;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-background);
            color: var(--on-surface);
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }

        /* Custom Theme Colors */
        .text-primary-custom {
            color: var(--primary-color) !important;
        }

        .bg-primary-container {
            background-color: var(--primary-container) !important;
        }

        .text-secondary-custom {
            color: var(--secondary) !important;
        }

        .bg-container-low {
            background-color: var(--surface-container-low) !important;
        }

        .bg-container-highest {
            background-color: var(--surface-container-highest) !important;
        }

        /* Navigation link active styling */
        .nav-link-custom {
            color: var(--secondary);
            font-weight: 500;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .nav-link-custom:hover {
            color: var(--primary-color);
        }

        .nav-link-custom.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 2px;
        }

        /* Hero Image Overlay */
        .hero-section {
            position: relative;
            height: 600px;
            overflow: hidden;
        }

        .hero-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to right, rgba(25, 28, 30, 0.6), transparent);
            z-index: 2;
        }

        .hero-content {
            position: relative;
            z-index: 3;
        }

        /* Bento Grid Layout using CSS Grid */
        .bento-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-template-rows: repeat(2, minmax(180px, auto));
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .bento-grid {
                grid-template-columns: 1fr;
                grid-template-rows: auto;
            }
        }

        .bento-featured {
            grid-column: span 2;
            grid-row: span 2;
        }

        .bento-wide {
            grid-column: span 2;
        }

        /* Hover animations */
        .img-hover-zoom {
            overflow: hidden;
        }

        .img-hover-zoom img {
            transition: transform 0.5s ease;
        }

        .card-hover:hover .img-hover-zoom img {
            transform: scale(1.05);
        }

        .btn-custom-outline {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            font-weight: 700;
            transition: all 0.2s ease;
        }

        .btn-custom-outline:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .guest-step-num {
            width: 48px;
            height: 48px;
            background-color: var(--surface-container-highest);
            color: var(--primary-color);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .guest-step:hover .guest-step-num {
            background-color: var(--primary-color);
            color: white;
        }

        /* Policies & Regulations Styles */
        .policy-container {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--surface-container-highest);
            overflow: hidden;
            display: flex;
            min-height: 550px;
        }

        @media (max-width: 991px) {
            .policy-container {
                flex-direction: column;
            }
        }

        .policy-sidebar {
            width: 280px;
            background-color: var(--surface-container-low);
            border-right: 1px solid var(--surface-container-highest);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex-shrink: 0;
        }

        @media (max-width: 991px) {
            .policy-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--surface-container-highest);
                flex-direction: row;
                overflow-x: auto;
                padding: 1rem;
                white-space: nowrap;
                scrollbar-width: none;
            }
            .policy-sidebar::-webkit-scrollbar {
                display: none;
            }
        }

        .policy-btn {
            background: transparent;
            border: none;
            border-radius: 10px;
            padding: 1rem 1.25rem;
            text-align: left;
            font-weight: 600;
            color: var(--secondary);
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.25s ease;
            cursor: pointer;
            width: 100%;
            outline: none;
        }

        @media (max-width: 991px) {
            .policy-btn {
                width: auto;
                padding: 0.75rem 1.25rem;
            }
        }

        .policy-btn:hover {
            background-color: rgba(157, 67, 0, 0.05);
            color: var(--primary-color);
        }

        .policy-btn.active {
            background-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(157, 67, 0, 0.25);
        }

        .policy-content {
            flex-grow: 1;
            padding: 2.5rem;
            overflow-y: auto;
            max-height: 700px;
        }

        @media (max-width: 768px) {
            .policy-content {
                padding: 1.5rem;
            }
        }

        .policy-pane {
            display: none;
            animation: policyFadeIn 0.4s ease-out forwards;
        }

        .policy-pane.active {
            display: block;
        }

        @keyframes policyFadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .policy-header {
            border-bottom: 2px solid var(--surface-container-low);
            padding-bottom: 1rem;
            margin-bottom: 1.75rem;
        }

        .policy-title {
            color: var(--primary-color);
            font-weight: 800;
            font-size: 24px;
            margin: 0;
        }

        .policy-subtitle {
            color: var(--secondary);
            font-size: 11px;
            margin-top: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 700;
        }

        .policy-card {
            background-color: var(--bg-background);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--surface-container-highest);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .policy-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.03);
            border-color: var(--primary-container);
        }

        .policy-card-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .policy-list {
            padding-left: 1.25rem;
            margin-bottom: 0;
            color: var(--on-surface);
        }

        .policy-list li {
            margin-bottom: 0.5rem;
            line-height: 1.6;
        }

        .policy-list li:last-child {
            margin-bottom: 0;
        }

        .table-policy {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            margin-bottom: 1.5rem;
        }

        .table-policy th {
            background-color: var(--surface-container-low);
            color: var(--primary-color);
            font-weight: 700;
            text-align: left;
            padding: 1rem;
            border-bottom: 2px solid var(--surface-container-highest);
        }

        .table-policy td {
            padding: 1rem;
            border-bottom: 1px solid var(--surface-container-highest);
            color: var(--on-surface);
        }

        .table-policy tr:hover td {
            background-color: var(--surface-container-low);
        }
    </style>
</head>

<body>

    <!-- TopNavBar -->
    <header class="bg-white shadow-sm sticky-top transition-all" id="main-header">
        <div class="container-xl d-flex justify-content-between align-items-center py-3">
            <div class="d-flex align-items-center gap-2">
                <span class="text-primary-custom material-symbols-outlined fs-2">library_books</span>
                <span class="fs-5 fw-bold text-primary-custom">UniLib LMS</span>
            </div>

            <nav class="d-none d-md-flex align-items-center gap-4">
                <a class="nav-link-custom active" href="#">Home</a>
                <a class="nav-link-custom" href="#about">About</a>
                <a class="nav-link-custom" href="#policies">Policies</a>
                <a class="nav-link-custom" href="#news">News</a>
                <a class="nav-link-custom" href="#contact">Contact</a>
            </nav>

            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/book-search.jsp" class="btn d-none d-lg-flex align-items-center text-muted rounded-pill px-3 py-1 text-decoration-none">
                    <span class="material-symbols-outlined me-1">search</span>
                    <span class="small">Search Catalog</span>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'ADMIN'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LIBRARIAN'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'MANAGER'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'STUDENT'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:when>
                            <c:when test="${sessionScope.role eq 'LECTURER'}">
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/lecturer/dashboard" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
                            </c:otherwise>
                        </c:choose>
                        <a href="${dashboardUrl}" class="btn bg-primary-container text-white rounded-pill px-4 fw-semibold shadow-sm text-decoration-none d-inline-flex align-items-center justify-content-center">
                            Go to Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary rounded-pill px-3 fw-semibold text-decoration-none d-inline-flex align-items-center justify-content-center">
                            Sign Out
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn bg-primary-container text-white rounded-pill px-4 fw-semibold shadow-sm text-decoration-none d-inline-flex align-items-center justify-content-center">
                            Sign In
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <main>
        <!-- Hero Section -->
        <section class="hero-section d-flex align-items-center">
            <img alt="Modern University Library" class="hero-img"
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuAXhwL3B82lHt70iVpVkR7bfy8MimqE7q3dKe0kFsVo7tjsnlheJNcmx_U9y-O4PHnsyTUkDrJLU3pD4Wk5K1nlm9fOvSB4cEgkpN0ZRjTWevp9BzeOcbYuj-51iud0mu-7OMrTm9doBITkCvxIiltV57-pe6G-2ODmimeIWygFXQdaIu9i6EZHOgD4ytVn5fjJuJGwf59A_NLHoXgj--56kW-NMGo5HhChnAc5WZuSE_qrUgosgYpqBjOVYLSTX430SBBQj7ZaNg8l" />
            <div class="hero-overlay"></div>
            <div class="container-xl hero-content w-100">
                <div class="max-width-custom" style="max-width: 650px;">
                    <h1 class="text-white fw-bold display-4 mb-3">Welcome to the Heart of Knowledge</h1>
                    <p class="text-white-50 fs-5 mb-4">Access millions of academic resources, journals, and digital
                        archives at the UniLib University Library. Explore our collections as our guest today.</p>

                    <!-- Form Tìm kiếm công cộng kết nối tới book-search.jsp -->
                    <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="position-relative style-search-box">
                        <span class="position-absolute top-50 start-0 translate-middle-y ms-3 material-symbols-outlined text-muted">search</span>
                        <input class="form-control form-control-lg border-0 shadow-lg ps-5 pe-5 py-3 rounded-3"
                            name="query" placeholder="Search Info, Catalog, or Archives..." type="text" />
                        <button type="submit"
                            class="btn bg-primary-container text-white position-absolute top-50 end-0 translate-middle-y me-2 px-4 py-2 rounded-3 fw-semibold">
                            Search
                        </button>
                    </form>
                </div>
            </div>
        </section>

        <!-- About Us Snippet -->
        <section class="py-5 my-3 container-xl" id="about">
            <div class="row align-items-center g-5">
                <div class="col-12 col-md-6">
                    <span class="text-primary-custom fw-bold text-uppercase tracking-wider small">Our Mission</span>
                    <h2 class="fw-bold display-6 mt-2 mb-3">Empowering Discovery &amp; Academic Excellence</h2>
                    <p class="text-secondary-custom lh-lg mb-4">
                        The University Library Management System (UniLib) stands as a beacon of information for
                        students, faculty, and guests. We provide a bridge between traditional literacy and digital
                        innovation, ensuring that every researcher has the tools they need to succeed in an
                        ever-evolving academic landscape.
                    </p>
                    <div class="row g-4 mt-2">
                        <div class="col-6 d-flex align-items-start gap-3">
                            <span
                                class="material-symbols-outlined text-primary-custom p-2 bg-container-highest rounded-3">history_edu</span>
                            <div>
                                <h4 class="fw-bold fs-6 mb-0 text-dark">500k+ Books</h4>
                                <p class="small text-muted mb-0">Physical collection</p>
                            </div>
                        </div>
                        <div class="col-6 d-flex align-items-start gap-3">
                            <span
                                class="material-symbols-outlined text-primary-custom p-2 bg-container-highest rounded-3">language</span>
                            <div>
                                <h4 class="fw-bold fs-6 mb-0 text-dark">Digital Access</h4>
                                <p class="small text-muted mb-0">24/7 Virtual Library</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-6">
                    <div class="rounded-4 overflow-hidden shadow-lg" style="height: 400px;">
                        <img alt="Library Interior" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuAwcTGVluSCOZGz7VYifrPcqBSbZPKU1Dy2qsP5nvYyJIl10Ru5khq6rTd_4v7vjTXd1hIUeVml6WgCxm2-pUhFmBbyRY3T-gVERSAqgOFGmCu1m2GuxNLE6MIQ84AJUoepideQqT8yKIjb82nsRbeuJjTxrAt3iRRwbsr42_zaGrTbjGCtGKAF84uNNgzcbtmMyc-iFWjA3XKx_FWXBO8U58us_fhFRZ8bUtFQCQZRRR-PfmRInC--fNAIjPRJdXMNpm_fYiNrdAUb" />
                    </div>
                </div>
            </div>
        </section>

        <!-- Latest News Bento Grid -->
        <section class="bg-container-low py-5" id="news">
            <div class="container-xl py-3">
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <span class="text-primary-custom fw-bold text-uppercase small">Updates</span>
                        <h2 class="fw-bold text-dark mt-1 mb-0">Latest Library News</h2>
                    </div>
                    <a class="text-primary-custom fw-semibold d-flex align-items-center gap-1 text-decoration-none"
                        href="#">
                        View all updates <span class="material-symbols-outlined fs-5">arrow_forward</span>
                    </a>
                </div>

                <div class="bento-grid">
                    <!-- Featured News -->
                    <div class="bento-featured bg-white rounded-3 overflow-hidden shadow-sm d-flex flex-column card-hover"
                        style="cursor: pointer;">
                        <div class="img-hover-zoom" style="height: 256px;">
                            <img alt="Journal Access" class="w-100 h-100 object-fit-cover"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuD3vHmjLEG7w7MqA7Wodbtf-9s-QG8HcK_Onbi3b4CHjAfqqM_a3O_NsGTSX2s-ib09A8vMguplY1JRVqeT_72ah5rBqIh_m4knJyEkUkVGNdKwMSngfLRgXyEn_2jnrAMR4WrJFIhh_zSl6bN7HA1uOQfMWy2rUViATQwdD2I5bUdjZvCs-4liS2vUCBHKb2GLZTdFVHqd4ENNnnXSLJok0K1sb9RcchbD7bsRn29vIIlJ4b5PWCveTCo1JJJZmQoKhKidNSZMvqvk" />
                        </div>
                        <div class="p-4 d-flex flex-column flex-grow-1">
                            <span class="text-primary-custom fw-semibold small mb-1">Research • Oct 24</span>
                            <h3 class="fw-bold fs-4 mb-2 text-dark">New Digital Journal Subscription for 2024</h3>
                            <p class="text-muted mb-0 flex-grow-1">We are proud to announce full access to over 500 new
                                premium academic journals across medical and engineering fields for all users.</p>
                        </div>
                    </div>

                    <!-- Grid Item 2 -->
                    <div class="bento-wide bg-white rounded-3 overflow-hidden shadow-sm d-flex p-4 gap-4 align-items-center card-hover"
                        style="cursor: pointer;">
                        <div class="img-hover-zoom rounded-3 flex-shrink-0" style="width: 128px; height: 128px;">
                            <img alt="Event" class="w-100 h-100 object-fit-cover"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzhOwY3MmEoh8oMW1xFzwcRHLqWFpW5JdtzBpodWnRVn6dD25RMjwNnR4TtUV4r9YrHbHByG6VR2h-UYnX2jkfHBmzUKkStKMmPiP3V7Of_1uoyA9Xa0S7CjixKWcM7GzAf6ILZE2QuT7f1SkaALKIycnLZ7S3MzzxH8RXQlERxrv4R2muupz1v75TtWiX1OA-pcpvw_iJFiGeyiDdm1M0K_jt3O487MUxjWnxbkCmv2BSI5gGIviHpY7ATAdwKKZePVDchaYL0S0Q" />
                        </div>
                        <div>
                            <span class="text-primary-custom fw-semibold small">Events • Oct 20</span>
                            <h3 class="fw-bold fs-5 text-dark mb-0 mt-1">Annual Book Fair &amp; Author Talk</h3>
                        </div>
                    </div>

                    <!-- Grid Item 3 -->
                    <div class="bg-white rounded-3 shadow-sm p-4 d-flex flex-column" style="cursor: pointer;">
                        <span class="material-symbols-outlined text-primary-custom mb-3 display-6">architecture</span>
                        <h3 class="fw-bold fs-5 text-dark mb-2">New Quiet Study Pods</h3>
                        <p class="small text-muted mb-0">Phase 1 of our renovation is complete with 20 new individual
                            pods.</p>
                    </div>

                    <!-- Grid Item 4 -->
                    <div class="bg-primary-container text-white rounded-3 shadow-sm p-4 d-flex flex-column justify-content-between"
                        style="cursor: pointer;">
                        <div>
                            <h3 class="fw-bold fs-5 mb-2">Join Our Newsletter</h3>
                            <p class="text-white-50 small mb-0">Stay updated with library news and upcoming workshop
                                dates.</p>
                        </div>
                        <form action="#" class="d-flex gap-2 mt-4">
                            <input class="form-control form-control-sm border-0 bg-white text-dark" placeholder="Email"
                                type="email" required />
                            <button type="submit" class="btn btn-dark d-flex align-items-center justify-content-center px-2">
                                <span class="material-symbols-outlined fs-6">send</span>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

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

        <!-- CTA Section -->
        <section class="py-5 bg-dark text-white text-center">
            <div class="container-xl py-4">
                <h2 class="fw-bold display-5 mb-3">Ready to start your research?</h2>
                <p class="text-white-50 fs-5 max-width-custom mx-auto mb-4" style="max-width: 700px;">Our staff is ready
                    to assist you in navigating our extensive databases and physical archives.</p>
                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userId}">
                            <a href="${dashboardUrl}"
                                class="btn bg-primary-container text-white px-5 py-3 rounded-pill fw-bold shadow-lg border-0 text-decoration-none d-inline-flex align-items-center">
                                Go to Dashboard
                            </a>
                            <a href="#contact" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold text-decoration-none d-inline-flex align-items-center">
                                Contact Support
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"
                                class="btn bg-primary-container text-white px-5 py-3 rounded-pill fw-bold shadow-lg border-0 text-decoration-none d-inline-flex align-items-center">
                                Plan Your Visit
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold text-decoration-none d-inline-flex align-items-center">
                                Chat with a Librarian
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-container-highest mt-5" id="contact">
        <div class="container-xl py-5">
            <div class="row g-4 align-items-center justify-content-between">
                <div class="col-12 col-md-6 text-center text-md-start">
                    <div class="d-flex align-items-center justify-content-center justify-content-md-start gap-2 mb-2">
                        <span class="text-primary-custom material-symbols-outlined fs-3">library_books</span>
                        <span class="fs-4 fw-bold text-primary-custom">UniLib LMS</span>
                    </div>
                    <p class="text-secondary-custom small mb-3 style-desc-footer" style="max-width: 400px;">
                        Providing world-class information access to the global academic community since 1954.
                    </p>
                    <p class="small text-muted mb-0">© 2024 University Library Management System. All rights reserved.</p>
                </div>

                <div class="col-12 col-md-6 text-center text-md-end d-flex flex-column align-items-center align-items-md-end gap-3">
                    <nav class="d-flex flex-wrap justify-content-center justify-content-md-end gap-3">
                        <a class="text-secondary-custom small text-decoration-underline" href="#">Instructions</a>
                        <a class="text-secondary-custom small text-decoration-underline" href="#">Privacy Policy</a>
                        <a class="text-secondary-custom small text-decoration-underline" href="#">Terms of Service</a>
                        <a class="text-secondary-custom small text-decoration-underline" href="#">FAQ</a>
                        <a class="text-primary-custom small fw-bold text-decoration-none" href="${pageContext.request.contextPath}/login">Staff Login</a>
                    </nav>
                    <div class="d-flex gap-3">
                        <a class="text-secondary-custom text-decoration-none" href="#"><span
                                class="material-symbols-outlined">public</span></a>
                        <a class="text-secondary-custom text-decoration-none" href="#"><span
                                class="material-symbols-outlined">mail</span></a>
                        <a class="text-secondary-custom text-decoration-none" href="#"><span
                                class="material-symbols-outlined">share</span></a>
                    </div>
                    <div class="small text-secondary-custom d-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">location_on</span>
                        123 Academic Row, Knowledge City, EDU 4567
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JavaScript Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Sticky Header Shadow effect
        window.addEventListener('scroll', () => {
            const header = document.getElementById('main-header');
            if (header) {
                if (window.scrollY > 20) {
                    header.classList.add('shadow');
                    header.classList.remove('shadow-sm');
                } else {
                    header.classList.add('shadow-sm');
                    header.classList.remove('shadow');
                }
            }
        });

        // Smooth Scrolling for anchor links with header offset
        const navLinks = document.querySelectorAll('.nav-link-custom');
        navLinks.forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href.startsWith('#')) {
                    e.preventDefault();
                    
                    navLinks.forEach(l => l.classList.remove('active'));
                    this.classList.add('active');

                    if (href === '#') {
                        window.scrollTo({
                            top: 0,
                            behavior: 'smooth'
                        });
                    } else {
                        const target = document.querySelector(href);
                        if (target) {
                            const headerOffset = 80; // Sticky header height plus margin
                            const elementPosition = target.getBoundingClientRect().top;
                            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                            window.scrollTo({
                                top: offsetPosition,
                                behavior: 'smooth'
                            });
                        }
                    }
                }
            });
        });

        // ScrollSpy: Dynamic navigation active state highlighting
        const sections = document.querySelectorAll('section[id], footer[id]');
        window.addEventListener('scroll', () => {
            let current = '';
            const scrollY = window.pageYOffset;
            const headerHeight = 90; // Trigger offset

            sections.forEach(section => {
                const sectionTop = section.offsetTop - headerHeight;
                const sectionHeight = section.offsetHeight;
                if (scrollY >= sectionTop && scrollY < sectionTop + sectionHeight) {
                    current = section.getAttribute('id');
                }
            });

            // Default to Home if near top
            if (scrollY < 100) {
                current = '';
            }

            navLinks.forEach(link => {
                link.classList.remove('active');
                const href = link.getAttribute('href');
                if ((current === '' && href === '#') || href === '#' + current) {
                    link.classList.add('active');
                }
            });
        });

        // Tab switching logic for Policies
        function switchPolicyTab(event, paneId) {
            document.querySelectorAll('.policy-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelectorAll('.policy-pane').forEach(pane => {
                pane.classList.remove('active');
            });
            
            event.currentTarget.classList.add('active');
            const targetPane = document.getElementById(paneId);
            if (targetPane) {
                targetPane.classList.add('active');
                const contentArea = document.querySelector('.policy-content');
                if (contentArea) {
                    contentArea.scrollTop = 0;
                }
            }
        }
    </script>
</body>

</html>
