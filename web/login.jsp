<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Login - LMS University Library</title>
    <!-- Standard CSS files instead of TailwindCSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css" />
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="auth-body auth-body--split">
    <div class="auth-split-wrapper">
        <!-- Left Side: Illustration & Branding -->
        <section class="auth-split-left">
            <div style="position: absolute; inset: 0; background: linear-gradient(to bottom right, rgba(249, 115, 22, 0.8), rgba(157, 67, 0, 0.9)); mix-blend-mode: multiply; z-index: 10;"></div>
            <img alt="University Library" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; filter: grayscale(0.2);" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD_BNiCLhjMig8aQvEZ4cGp-g0OkTkHATR5wLQxSvGqtheUVmBrEHDyoI-tlV3Q3vu8GND6akSV6zLtXNQiDI_ViYnkU2CphuZrNx1z-rqE5rYEm-i6idHvjT_pSUCh3MQNDz0xW7Swa4jvG4pahXVRw5ETKG6kP7bqXV8jPOC28GWRshO5_hXqM2bFqyp5X6saqVmXtUrRPU37rduvI2KdDP98xpjqmJwzD9xJUyxpxUFewad3VU4BftBU1wDh4mgmaqEFNGx1sqqK" id="auth-illustration"/>
            <div style="position: relative; z-index: 20; display: flex; flex-direction: column; justify-content: space-between; padding: var(--space-3xl); width: 100%; height: 100%;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="material-symbols-outlined" style="color: white; font-size: 36px; font-variation-settings: 'FILL' 1;">auto_stories</span>
                    <h1 style="font-family: var(--font-headline); font-size: var(--text-headline-lg); color: white; font-weight: 700; margin: 0;">LMS University Library</h1>
                </div>
                <div style="max-width: 450px;">
                    <h2 style="font-family: var(--font-headline); font-size: var(--text-display); line-height: var(--text-display-lh); color: white; margin-bottom: 16px; font-weight: 700;">Empowering the Minds of Tomorrow.</h2>
                    <p style="font-family: var(--font-body); font-size: var(--text-body-lg); color: rgba(255,255,255,0.9); margin: 0;">Access over 500,000 digital and physical resources with our state-of-the-art management system.</p>
                </div>
                <div style="display: flex; gap: 16px;">
                    <div style="background: rgba(255,255,255,0.1); backdrop-filter: blur(12px); border-radius: var(--radius-xl); padding: 16px; border: 1px solid rgba(255,255,255,0.2);">
                        <span style="display: block; font-family: var(--font-headline); font-size: var(--text-headline-md); color: white; font-weight: 600;">2.5M+</span>
                        <span style="font-size: var(--text-label-md); color: rgba(255,255,255,0.7);">Books Circulated</span>
                    </div>
                    <div style="background: rgba(255,255,255,0.1); backdrop-filter: blur(12px); border-radius: var(--radius-xl); padding: 16px; border: 1px solid rgba(255,255,255,0.2);">
                        <span style="display: block; font-family: var(--font-headline); font-size: var(--text-headline-md); color: white; font-weight: 600;">45k</span>
                        <span style="font-size: var(--text-label-md); color: rgba(255,255,255,0.7);">Active Students</span>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Right Side: Authentication Card -->
        <section class="auth-split-right">
            <div style="width: 100%; max-width: 450px;">
                <!-- Branding for Mobile -->
                <div class="auth-header-mobile">
                    <div style="width: 64px; height: 64px; background-color: var(--color-primary-container); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin-bottom: 16px; box-shadow: 0 10px 15px -3px rgba(249,115,22,0.2);">
                        <span class="material-symbols-outlined" style="color: white; font-size: 36px; font-variation-settings: 'FILL' 1;">auto_stories</span>
                    </div>
                    <h1 style="font-family: var(--font-headline); font-size: var(--text-headline-md); color: var(--color-primary); font-weight: 700; margin: 0;">LMS University Library</h1>
                </div>
                
                <!-- Back to Home Button -->
                <a href="${pageContext.request.contextPath}/index.jsp" class="auth-header-link">
                    <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                    Return to Home
                </a>

                <div style="margin-bottom: var(--space-xl);">
                    <h2 class="auth-title">Welcome Back</h2>
                    <p class="auth-subtitle">Please enter your institutional credentials to access the library dashboard.</p>
                </div>
                
                <!-- Error State Display (JSTL dynamic) -->
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="auth-alert auth-alert--error">
                        <span class="material-symbols-outlined">error</span>
                        <span><c:out value="${requestScope.errorMessage}" /></span>
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.successMessage}">
                    <div class="auth-alert auth-alert--success">
                        <span class="material-symbols-outlined">check_circle</span>
                        <span><c:out value="${requestScope.successMessage}" /></span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <!-- Email Field -->
                    <div class="auth-form-group">
                        <label class="auth-form-label" for="email">Institutional Email</label>
                        <div class="auth-input-wrapper">
                            <span class="auth-input-icon-left material-symbols-outlined">mail</span>
                            <input class="auth-input auth-input--with-icon-left" 
                                   id="email" name="email" placeholder="m.student@university.edu" required type="email" 
                                   value="${not empty param.email ? param.email : ''}"/>
                        </div>
                    </div>
                    
                    <!-- Password Field -->
                    <div class="auth-form-group">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-xs);">
                            <label class="auth-form-label" style="margin-bottom: 0;" for="password">Password</label>
                            <a class="auth-link" style="font-size: var(--text-label-md); font-weight: var(--text-label-md-fw);" href="${pageContext.request.contextPath}/forgot-password.jsp">Forgot Password?</a>
                        </div>
                        <div class="auth-input-wrapper">
                            <span class="auth-input-icon-left material-symbols-outlined">lock</span>
                            <input class="auth-input auth-input--with-icon-left auth-input--with-icon-right" 
                                   id="password" name="password" placeholder="••••••••" required type="password"/>
                            <button class="auth-input-icon-right material-symbols-outlined" onclick="togglePassword()" type="button" id="password-toggle-icon">visibility</button>
                        </div>
                    </div>
                    
                    <!-- Remember Me -->
                    <div class="auth-checkbox-group">
                        <input class="auth-checkbox" id="remember" name="remember" type="checkbox"/>
                        <label class="auth-checkbox-label" for="remember">Remember me on this device</label>
                    </div>
                    
                    <!-- Submit Button -->
                    <button class="auth-submit-btn" type="submit">
                        <span>Login</span>
                        <span class="material-symbols-outlined">login</span>
                    </button>
                </form>
                
                <div class="auth-divider">
                    <div class="auth-divider-line"></div>
                    <span class="auth-divider-text">or login with</span>
                    <div class="auth-divider-line"></div>
                </div>
                
                <div class="auth-sso-grid">
                    <a href="${pageContext.request.contextPath}/login/google" class="auth-sso-btn">
                        <img alt="Google" style="width: 20px; height: 20px;" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBqMW_TR8Vis0hOIi6Ok5gXYDNu5H3Wv-YGTeNbrq1C_fvULC3vW_s5kZkT5qZ0X_HKDqXR0C0t0X7YEltJymEscxrUE-gZeMTl589pYzT998zimpiCO-ImaRVnUXgb1mvsodhG2Fx14ZIKnKL6cm8ksavEO1YHo8cRIWooeLCQGnIHVId-PuigGcBQ1yIF-qABxCOMILWo3d7ca7GnSJIUGfQBvX-gAUESXI9TpF6S_0CgyQyV5D80RQOV4SgRKc-zOvhGzrEzqpTI"/>
                        <span>Google SSO</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/login/microsoft" class="auth-sso-btn">
                        <span class="material-symbols-outlined" style="color: #0078D4; font-variation-settings: 'FILL' 1;">grid_view</span>
                        <span>Microsoft</span>
                    </a>
                </div>
                
                <footer style="text-align: center; margin-top: 40px;">
                    <p style="font-family: var(--font-body); font-size: var(--text-body-md); color: var(--color-on-surface-variant); margin: 0;">
                        Don't have an account? 
                        <a class="auth-link" style="font-weight: 600;" href="${pageContext.request.contextPath}/contact">Contact the Registrar</a>
                    </p>
                </footer>
            </div>
        </section>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('password-toggle-icon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.textContent = 'visibility_off';
            } else {
                passwordInput.type = 'password';
                toggleIcon.textContent = 'visibility';
            }
        }

        // Add subtle hover effect for the illustration container
        const illustration = document.getElementById('auth-illustration');
        document.addEventListener('mousemove', (e) => {
            const { clientX, clientY } = e;
            const x = (clientX / window.innerWidth - 0.5) * 20;
            const y = (clientY / window.innerHeight - 0.5) * 20;
            if (illustration) {
                illustration.style.transform = `scale(1.1) translate(${x}px, ${y}px)`;
            }
        });
        
        if (illustration) {
            illustration.style.transition = 'transform 0.1s ease-out';
            illustration.style.transform = 'scale(1.1)';
        }
    </script>
</body>
</html>
