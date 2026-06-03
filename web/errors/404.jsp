<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>404 - Page Not Found | LMS University Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #9d4300;
            --primary-container: #f97316;
            --on-background: #191c1e;
            --on-surface-variant: #584237;
            --surface: #f7f9fb;
            --surface-container: #eceef0;
            --outline-variant: #e0c0b1;
            --secondary: #565e74;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--surface);
            color: var(--on-background);
        }

        /* Custom typography styles matching original spec */
        .font-display {
            font-size: 48px;
            line-height: 56px;
            letter-spacing: -0.02em;
            font-weight: 700;
        }

        @media (max-width: 576px) {
            .font-display {
                font-size: 32px;
                line-height: 40px;
            }
        }

        .text-primary-custom {
            color: var(--primary);
        }

        .text-on-surface-variant {
            color: var(--on-surface-variant);
        }

        .bg-primary-container {
            background-color: var(--primary-container);
        }

        .border-outline-variant {
            border-color: var(--outline-variant) !important;
        }

        /* Navigation link hover */
        .nav-link-custom {
            color: var(--on-surface-variant);
            text-decoration: none;
            font-weight: 400;
            transition: color 0.2s ease;
        }

        .nav-link-custom:hover {
            color: var(--primary);
        }

        /* Image interaction container */
        .illustration-box {
            position: relative;
            width: 100%;
            max-width: 400px;
            aspect-ratio: 1 / 1;
        }

        .blur-bg {
            position: absolute;
            inset: 0;
            background-color: rgba(249, 115, 22, 0.1);
            border-radius: 50%;
            filter: blur(40px);
            opacity: 0.5;
            transition: opacity 0.3s;
        }

        .illustration-box:hover .blur-bg {
            opacity: 0.7;
        }

        .interactive-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            position: relative;
            z-index: 10;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.1s ease-out;
        }

        /* Quick Links Card */
        .quick-link-card {
            background-color: #ffffff;
            border-radius: 12px;
            border: 1px solid var(--outline-variant);
            padding: 16px;
            transition: box-shadow 0.2s ease, transform 0.2s ease;
            cursor: pointer;
            text-align: left;
        }

        .quick-link-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        /* Micro-interactions for buttons */
        .btn-animate:active {
            transform: scale(0.95);
        }
    </style>
</head>

<body class="d-flex flex-column h-100">

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
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/" />
        </c:otherwise>
    </c:choose>

    <nav class="navbar navbar-expand-md fixed-top bg-white shadow-sm py-3">
        <div class="container-xl d-flex justify-content-between align-items-center">
            <a class="navbar-brand fw-bold text-primary-custom m-0 fs-5" href="${pageContext.request.contextPath}/">LMS University Library</a>

            <div class="collapse navbar-collapse justify-content-center d-none d-md-flex">
                <div class="d-flex gap-4">
                    <a class="nav-link-custom" href="${dashboardUrl}">Dashboard</a>
                    <a class="nav-link-custom" href="${pageContext.request.contextPath}/book-search.jsp">Catalog</a>
                    <a class="nav-link-custom" href="${pageContext.request.contextPath}/services.jsp">Services</a>
                    <a class="nav-link-custom" href="${pageContext.request.contextPath}/policies.jsp">Policies</a>
                    <a class="nav-link-custom" href="${pageContext.request.contextPath}/#contact">Support</a>
                </div>
            </div>

            <div class="d-flex gap-3 align-items-center">
                <a href="${pageContext.request.contextPath}/#contact" class="btn p-0 material-symbols-outlined text-primary-custom btn-animate text-decoration-none">help</a>
                <a href="${dashboardUrl}" class="btn p-0 material-symbols-outlined text-primary-custom btn-animate text-decoration-none">account_circle</a>
            </div>
        </div>
    </nav>

    <main class="flex-shrink-0 container-xl d-flex flex-column align-items-center justify-content-center text-center px-4" style="margin-top: 100px; margin-bottom: 80px;">
        <div class="w-100 d-flex flex-column align-items-center">

            <div class="illustration-box mb-4">
                <div class="blur-bg"></div>
                <img alt="Lost in Library" class="interactive-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCJ1U0RBd1wVinNR3RGVmj8xFFjWD98ohXcybzKhPa0AWaLzJAhB3PYe2AiTsFEgrd7auWMdvgvdsdtOrun_hhQjzdCxLpskDxWAeO9KRi9XMgGiwktlxzBC_fwHjfvmT3L57QoRPTmiC7rzgpc17D3acmPyIV4fQWF1jsZ1QlMN-pV5Ip2TG15ys1Wjxh_4zSXSpDNkaXNX2P5yp_ehZ692GA4MbNhCfxVr8lBU9AivMbRMdlQzmAozjJ58TlCURAv_WfNe_Mi8ykm" />

                <div class="position-absolute bg-white p-3 rounded-3 shadow-sm d-flex align-items-center gap-2 border border-outline-variant" style="top: -16px; right: -16px; z-index: 20;">
                    <span class="material-symbols-outlined text-primary-custom">search_off</span>
                    <span class="small fw-semibold text-on-surface-variant">Not found</span>
                </div>
                <div class="position-absolute bg-white p-3 rounded-3 shadow-sm d-flex align-items-center gap-2 border border-outline-variant" style="bottom: -24px; left: -24px; z-index: 20;">
                    <span class="material-symbols-outlined text-primary-custom">book_5</span>
                    <span class="small fw-semibold text-on-surface-variant">LMS Lib 404</span>
                </div>
            </div>

            <div class="mt-4 max-w-2xl mx-auto">
                <h1 class="font-display text-primary-custom tracking-tight mb-2">404 - Page Not Found</h1>
                <h2 class="h4 fw-semibold text-dark mb-3">The requested page could not be found.</h2>
                <p class="text-on-surface-variant fs-5 mb-4 mx-auto" style="max-width: 600px; line-height: 1.6;">
                    It looks like you've wandered between our digital bookshelves. This page doesn't exist or has been moved to a new address. Please check the URL or use the search bar to continue.
                </p>
            </div>

            <div class="d-flex flex-column flex-sm-row gap-3 mt-3">
                <a class="btn bg-primary-container text-white fw-semibold px-4 py-3 border-0 rounded-3 d-inline-flex align-items-center justify-content-center gap-2 shadow-sm btn-animate text-decoration-none" href="${dashboardUrl}">
                    <span class="material-symbols-outlined">home</span> Back to Home
                </a>
                <a class="btn btn-outline-secondary px-4 py-3 rounded-3 d-inline-flex align-items-center justify-content-center gap-2 border-2 text-on-surface-variant border-outline-variant btn-animate text-decoration-none" href="${pageContext.request.contextPath}/#contact">
                    <span class="material-symbols-outlined">contact_support</span> Contact Support
                </a>
            </div>

            <div class="mt-5 w-100" style="max-width: 768px;">
                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <a href="${pageContext.request.contextPath}/book-search.jsp" class="text-decoration-none text-reset">
                            <div class="quick-link-card h-100">
                                <span class="material-symbols-outlined text-primary-custom mb-2 d-block">menu_book</span>
                                <h3 class="h6 text-dark fw-bold mb-1">Catalog</h3>
                                <p class="small text-on-surface-variant mb-0">Search for study materials.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-12 col-md-4">
                        <a href="${pageContext.request.contextPath}/#policies" class="text-decoration-none text-reset">
                            <div class="quick-link-card h-100">
                                <span class="material-symbols-outlined text-primary-custom mb-2 d-block">gavel</span>
                                <h3 class="h6 text-dark fw-bold mb-1">Policies</h3>
                                <p class="small text-on-surface-variant mb-0">Read library policies.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-12 col-md-4">
                        <a href="${dashboardUrl}" class="text-decoration-none text-reset">
                            <div class="quick-link-card h-100">
                                <span class="material-symbols-outlined text-primary-custom mb-2 d-block">person</span>
                                <h3 class="h6 text-dark fw-bold mb-1">Account</h3>
                                <p class="small text-on-surface-variant mb-0">View your borrowing history.</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <footer class="footer mt-auto py-4 bg-light border-top border-outline-variant" style="background-color: var(--surface-container) !important;">
        <div class="container-xl d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div class="text-center text-md-start">
                <span class="d-block small fw-semibold text-muted" style="color: var(--secondary) !important;">LMS University Library</span>
                <span class="small text-on-surface-variant">© 2024 LMS University Library System</span>
            </div>
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <a class="small text-on-surface-variant text-decoration-underline" href="#">Privacy Policy</a>
                <a class="small text-on-surface-variant text-decoration-underline" href="#">Terms of Service</a>
                <a class="small text-on-surface-variant text-decoration-underline" href="#">Accessibility</a>
                <a class="small text-on-surface-variant text-decoration-underline" href="${pageContext.request.contextPath}/#contact">Contact Support</a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Micro-interaction for the illustration
        document.addEventListener('mousemove', (e) => {
            const img = document.querySelector('.interactive-img');
            if (!img) return;
            const rect = img.getBoundingClientRect();
            const x = (e.clientX - rect.left) / rect.width - 0.5;
            const y = (e.clientY - rect.top) / rect.height - 0.5;

            img.style.transform = `perspective(1000px) rotateY(${x * 5}deg) rotateX(${-y * 5}deg)`;
        });
    </script>
</body>

</html>
