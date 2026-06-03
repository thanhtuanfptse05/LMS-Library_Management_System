<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'vi'}">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Lumina Library - Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet">

    <style>
        :root {
            --primary-color: #9d4300;
            --primary-container: #f97316;
            --surface-color: #f7f9fb;
            --text-on-surface: #191c1e;
            --text-secondary: #565e74;
            --outline-variant: #e0c0b1;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--surface-color);
            min-height: 100vh;
            overflow-x: hidden;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }

        /* Split Screen Styles */
        .hero-side {
            position: relative;
            background-color: #eceef0;
            overflow: hidden;
            min-height: 100vh;
        }

        .hero-bg-img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: grayscale(20%) brightness(0.8);
            z-index: 0;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            transform: scale(1.05);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: gradient(linear, left top, right bottom, from(rgba(157, 67, 0, 0.3)), to(transparent));
            background: linear-gradient(to top right, rgba(157, 67, 0, 0.3), transparent);
            mix-blend-mode: multiply;
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 10;
            color: #ffffff;
            height: 100%;
            padding: 48px;
        }

        /* Form Custom Utilities */
        .form-container-wrapper {
            max-width: 480px;
            width: 100%;
        }

        .input-group-custom {
            position: relative;
        }

        .input-group-custom .icon-left {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: var(--text-secondary);
            transition: color 0.3s;
        }

        .input-group-custom .form-control {
            padding-left: 52px;
            padding-top: 14px;
            padding-bottom: 14px;
            background-color: var(--surface-color);
            border: 1px solid var(--outline-variant);
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .input-group-custom .form-control:focus {
            background-color: #fff;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(157, 67, 0, 0.2);
            color: var(--text-on-surface);
        }

        .input-group-custom:focus-within .icon-left {
            color: var(--primary-color);
        }

        .btn-toggle-pw {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            z-index: 10;
        }

        .btn-toggle-pw:hover {
            color: var(--text-on-surface);
        }

        .btn-primary-custom {
            background-color: var(--primary-container);
            color: white;
            border: none;
            padding-top: 14px;
            padding-bottom: 14px;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-primary-custom:hover {
            filter: brightness(1.1);
            color: white;
        }

        .btn-primary-custom:active {
            transform: scale(0.98);
        }

        .btn-outline-custom {
            border: 1px solid var(--outline-variant);
            border-radius: 12px;
            padding: 8px 16px;
            background-color: transparent;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 14px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-outline-custom:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            background-color: rgba(157, 67, 0, 0.05);
            transform: scale(1.02);
        }

        .btn-outline-custom:active {
            transform: scale(0.98);
        }

        .btn-google {
            border: 1px solid var(--outline-variant);
            border-radius: 12px;
            padding-top: 14px;
            padding-bottom: 14px;
            background-color: white;
            font-weight: 600;
            color: var(--text-on-surface);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-google:hover {
            background-color: #f2f4f6;
        }

        .btn-google:active {
            transform: scale(0.98);
        }

        /* Avatar overlapping stack */
        .avatar-group img {
            width: 48px;
            height: 48px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid white;
            margin-right: -16px;
        }

        .avatar-group .avatar-plus {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            border: 2px solid white;
            background-color: var(--primary-container);
            color: white;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        /* Divider line */
        .divider-container {
            position: relative;
            text-align: center;
            margin: 24px 0;
        }

        .divider-line {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            border-top: 1px solid var(--outline-variant);
            z-index: 1;
        }

        .divider-text {
            position: relative;
            z-index: 2;
            background-color: white;
            padding: 0 16px;
            color: var(--text-secondary);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
        }

        .footer-link {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
        }

        .footer-link:hover {
            color: var(--primary-color);
        }
    </style>
</head>

<body>

    <div class="container-fluid p-0">
        <div class="row g-0 min-vh-screen">

            <div class="col-lg-6 d-none d-lg-block hero-side">
                <img alt="Modern Library Interior" class="hero-bg-img"
                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuDX9ONooS2aY7BnMXi5281r4GTE1LwpL0LmOP1MbqyhvygpuJhiHP0JYGCi2Dik_1j1KPJ8M_hPOeJmnD1cIMrlBxMRhAGSoQIUlyR4rcFAQu0nHOJ3W4yhGJ--s-asxQlCTxIxCEiegeKguHn-LpvY_2d7Z-71BTQPD4O-5DsTBo7QHNCNRmNRbb2JrQTH59G8vEzYWe_SGuV4ul_3Me18Dw_CPhpmEwif60iTStwpW7fIz9zcgkBnDyoqXOQSpAk3bDrX_TIMWjXu">
                <div class="hero-overlay"></div>

                <div class="hero-content d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined text-white"
                            style="font-size: 40px; font-variation-settings: 'FILL' 1;">auto_stories</span>
                        <span class="fs-2 fw-bold tracking-tight text-white">LMS University Library</span>
                    </div>

                    <div style="max-width: 450px;">
                        <h2 class="display-5 fw-bold text-white mb-4">Access the world's knowledge.</h2>
                        <p class="fs-5 text-white-50">Manage loans, browse collections, and connect with global research
                            resources through the Lumina Library ecosystem.</p>
                    </div>

                    <div class="d-flex align-items-center gap-3">
                        <div class="avatar-group d-flex align-items-center">
                            <img alt="Librarian"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuDStQM9ALcH-TjR1yJpJ59zo9jjQtcZU18Tq72P_-_Fmlfxt69RXBhGbyNbUPLktPiB-ibH8lYwX5KYSw6esfga0VIFsLXIJcj79J6eZEzOvY2wtEiZv2N8DRfQ75HyI3JjpKY0o0iJr0w0C-DuEtbKuAiyY4xknFJFk7nKBORPfXuUVMpKCUv2fStyc9SQTppUgHn5jx_lWCEsqwGlsZN8KCksZH4NCVsOSGLZhyUte1wUpsduV0LiQII21Cy6tZ2Oy5sWZ2VIK7k7">
                            <img alt="Student"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuAO1SHGmVpGKvqAmQyGJgo5D0tj_3R9aRPfRj-9w3jRbORizYXfVFvcVGwq_shbatYAjzt8_SMXE7_TmtwOqvCf_QpwrtPXheyrP1o54py-GeUUL3umiXxDznsc-Hu4e4XDUJMzQZCjqR2ASn7yg8OusGyCeEUBm0HVdRuF_vtbaxXHuLW9zVaM88aHoofSqGRDlEpjlEXdDvyjO98czDp2oCeQcPPdkOhAry8EOtTevL1tt7wQhrmQRKXPzIKDo9EkeEnfP3hbzXlR">
                            <div class="avatar-plus">+20K</div>
                        </div>
                        <p class="small text-white mb-0 ms-3">Join thousands of active researchers today.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-6 d-flex align-items-center justify-content-center p-4 bg-white">
                <div class="form-container-wrapper py-5">

                    <div class="d-lg-none text-center mb-5">
                        <div class="d-inline-block p-2 rounded-3 text-white mb-2"
                            style="background-color: var(--primary-container);">
                            <span class="material-symbols-outlined"
                                style="font-size: 32px; font-variation-settings: 'FILL' 1;">auto_stories</span>
                        </div>
                        <h1 class="h3 text-primary fw-bold">Lumina Library</h1>
                    </div>

                    <div class="mb-4 d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/" class="btn-outline-custom gap-2 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 20px;">home</span>
                            <span><fmt:message key="login.back_home" /></span>
                        </a>
                        <!-- Language Switcher -->
                        <div class="d-flex align-items-center gap-1 border rounded-pill px-2 py-1 bg-light" style="height: 34px;">
                            <a href="${pageContext.request.contextPath}/change-language?lang=vi" 
                               class="text-decoration-none small fw-semibold px-2 rounded-pill ${sessionScope.lang eq 'vi' ? 'bg-primary-custom text-white' : 'text-muted'}">VI</a>
                            <span class="text-secondary opacity-50" style="font-size: 10px;">|</span>
                            <a href="${pageContext.request.contextPath}/change-language?lang=en" 
                               class="text-decoration-none small fw-semibold px-2 rounded-pill ${sessionScope.lang eq 'en' ? 'bg-primary-custom text-white' : 'text-muted'}">EN</a>
                        </div>
                    </div>

                    <div class="text-start mb-4">
                        <h2 class="fw-bold text-dark mb-1" style="font-size: 32px;"><fmt:message key="login.welcome" /></h2>
                        <p class="text-muted"><fmt:message key="login.sub" /></p>
                    </div>

                    <!-- Hộp thông báo lỗi động bằng JSTL -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger d-flex align-items-center gap-2 mb-4" role="alert" 
                             style="border-radius: 12px; font-size: 14.5px; background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca;">
                             <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                             <div><c:out value="${errorMessage}"/></div>
                        </div>
                    </c:if>

                    <!-- Hộp thông báo thành công khi reset mật khẩu -->
                    <c:if test="${param.resetSuccess == 'true'}">
                        <div class="alert alert-success d-flex align-items-center gap-2 mb-4" role="alert" 
                             style="border-radius: 12px; font-size: 14.5px; background-color: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0;">
                            <span class="material-symbols-outlined" style="font-size: 20px;">check_circle</span>
                            <div>If the email is valid, a new password has been sent. Please check your inbox.</div>
                        </div>
                    </c:if>

                    <!-- Form kết nối POST với LoginServlet -->
                    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST" class="mb-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted ms-1" for="email"><fmt:message key="login.username_or_email" /></label>
                            <div class="input-group-custom">
                                <span class="material-symbols-outlined icon-left">person</span>
                                <input class="form-control" id="email" name="email" placeholder="librarian@lumina.edu"
                                    required type="text">
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-1">
                                <label class="form-label small fw-bold text-muted mb-0" for="password"><fmt:message key="login.password" /></label>
                                <a class="small fw-bold text-decoration-none" href="${pageContext.request.contextPath}/forgot-password"
                                    style="color: var(--primary-color);"><fmt:message key="login.forgot_password" /></a>
                            </div>
                            <div class="input-group-custom">
                                <span class="material-symbols-outlined icon-left">lock</span>
                                <input class="form-control" id="password" name="password" placeholder="••••••••"
                                    required type="password">
                                <button class="btn-toggle-pw" onclick="togglePassword()" type="button">
                                    <span class="material-symbols-outlined" id="pw-toggle">visibility</span>
                                </button>
                            </div>
                        </div>

                        <button
                            class="w-full btn-primary-custom w-100 d-flex align-items-center justify-content-center gap-2"
                            type="submit">
                            <fmt:message key="login.signin" />
                            <span class="material-symbols-outlined">arrow_forward</span>
                        </button>
                    </form>

                    <div class="divider-container">
                        <div class="divider-line"></div>
                        <span class="divider-text"><fmt:message key="login.or_access" /></span>
                    </div>

                    <!-- Liên kết thẻ A tích hợp Google SSO thay cho button để chuyển hướng chính xác -->
                    <a href="${pageContext.request.contextPath}/login-google" class="btn-google w-100 d-flex align-items-center justify-content-center gap-3 mb-5 text-decoration-none">
                        <svg class="bi" width="20" height="20" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                                fill="#4285F4"></path>
                            <path
                                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                                fill="#34A853"></path>
                            <path
                                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                                fill="#FBBC05"></path>
                            <path
                                d="M12 5.38c1.62 0 3.06.56 4.21 1.66l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                                fill="#EA4335"></path>
                        </svg>
                        <span><fmt:message key="login.sign_with_google" /></span>
                    </a>

                    <footer
                        class="d-flex flex-column flex-sm-row align-items-center justify-content-between pt-4 border-top border-secondary-subtle gap-3">
                        <div class="d-flex gap-4">
                            <a class="footer-link d-flex align-items-center gap-1" href="#">
                                <span class="material-symbols-outlined" style="font-size: 18px;">help</span>
                                <fmt:message key="login.need_help" />
                            </a>
                            <a class="footer-link d-flex align-items-center gap-1" href="#">
                                <span class="material-symbols-outlined" style="font-size: 18px;">support_agent</span>
                                <fmt:message key="login.contact_librarian" />
                            </a>
                        </div>
                        <p class="small text-muted mb-0 opacity-75">© 2024 LMS University Library System</p>
                    </footer>

                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon = document.getElementById('pw-toggle');
            if (input.type === 'password') {
                input.type = 'text';
                icon.textContent = 'visibility_off';
            } else {
                input.type = 'password';
                icon.textContent = 'visibility';
            }
        }

        // Tích hợp hiệu ứng chuyển động Authentic mượt mà trước khi submit thực tế
        document.getElementById('loginForm').addEventListener('submit', function (e) {
            e.preventDefault();
            const form = e.target;
            const btn = form.querySelector('button[type="submit"]');
            const originalContent = btn.innerHTML;

            // Phản hồi trực quan loading
            btn.innerHTML = '<span class="material-symbols-outlined spinner-border spinner-border-sm me-2" role="status" style="animation: spin 1.5s linear infinite; vertical-align: middle;">progress_activity</span> Authenticating...';
            btn.disabled = true;
            btn.style.opacity = '0.8';

            setTimeout(() => {
                // Submit form thực tế lên servlet xử lý sau 800ms
                form.submit();
            }, 800);
        });

        // Parallax effect on hero image
        document.addEventListener('mousemove', (e) => {
            const hero = document.querySelector('.hero-bg-img');
            if (hero) {
                const moveX = (e.clientX - window.innerWidth / 2) * 0.005;
                const moveY = (e.clientY - window.innerHeight / 2) * 0.005;
                hero.style.transform = `scale(1.05) translate(${moveX}px, ${moveY}px)`;
            }
        });
    </script>

</body>

</html>
