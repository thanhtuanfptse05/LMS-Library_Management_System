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
                <a href="${pageContext.request.contextPath}/login" class="btn bg-primary-container text-white rounded-pill px-4 fw-semibold shadow-sm text-decoration-none d-inline-flex align-items-center justify-content-center">
                    Sign In
                </a>
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
            <div class="row g-5">
                <!-- Instructions -->
                <div class="col-12 col-md-6">
                    <h2 class="fw-bold text-dark mb-4">Quick Instructions for Guests</h2>
                    <div class="d-flex flex-column gap-4">
                        <div class="d-flex gap-4 guest-step">
                            <div class="guest-step-num">1</div>
                            <div>
                                <h4 class="fw-bold fs-5 text-dark mb-1">Register for a Guest Pass</h4>
                                <p class="text-muted mb-0">Visit the main reception desk with a valid ID to obtain a
                                    temporary day pass for physical access.</p>
                            </div>
                        </div>
                        <div class="d-flex gap-4 guest-step">
                            <div class="guest-step-num">2</div>
                            <div>
                                <h4 class="fw-bold fs-5 text-dark mb-1">Connect to Guest Wi-Fi</h4>
                                <p class="text-muted mb-0">Use the network 'UniLib-Guest' and follow the portal
                                    instructions to gain high-speed access.</p>
                            </div>
                        </div>
                        <div class="d-flex gap-4 guest-step">
                            <div class="guest-step-num">3</div>
                            <div>
                                <h4 class="fw-bold fs-5 text-dark mb-1">Reference Only Access</h4>
                                <p class="text-muted mb-0">Guests can use all books within the premises but are not
                                    permitted to check out items for off-site use.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Policies Summary -->
                <div class="col-12 col-md-6">
                    <div class="bg-container-low p-4 rounded-4 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <h2 class="fw-bold text-dark mb-4">Library Policies</h2>
                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex align-items-center gap-3 bg-white p-3 rounded-3 shadow-sm">
                                    <span class="material-symbols-outlined text-success">check_circle</span>
                                    <span class="fw-medium text-dark small">Quiet zones must be respected at all
                                        times.</span>
                                </div>
                                <div class="d-flex align-items-center gap-3 bg-white p-3 rounded-3 shadow-sm">
                                    <span class="material-symbols-outlined text-success">check_circle</span>
                                    <span class="fw-medium text-dark small">Laptops and devices must be on silent
                                        mode.</span>
                                </div>
                                <div class="d-flex align-items-center gap-3 bg-white p-3 rounded-3 shadow-sm">
                                    <span class="material-symbols-outlined text-success">check_circle</span>
                                    <span class="fw-medium text-dark small">Bottled water only; no food in the stack
                                        areas.</span>
                                </div>
                                <div class="d-flex align-items-center gap-3 bg-white p-3 rounded-3 shadow-sm">
                                    <span class="material-symbols-outlined text-primary-custom">info</span>
                                    <span class="fw-medium text-dark small">Maximum guest occupancy is 50 persons
                                        daily.</span>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-custom-outline w-100 py-3 rounded-3 mt-4">
                            Download Full Policy (PDF)
                        </button>
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
                    <a href="${pageContext.request.contextPath}/login"
                        class="btn bg-primary-container text-white px-5 py-3 rounded-pill fw-bold shadow-lg border-0 text-decoration-none d-inline-flex align-items-center">
                        Plan Your Visit
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold text-decoration-none d-inline-flex align-items-center">
                        Chat with a Librarian
                    </a>
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

        // Smooth Scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });
    </script>
</body>

</html>
