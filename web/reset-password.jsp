<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Reset Password - LMS University Library</title>
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
    <!-- TopAppBar -->
    <header class="main-header">
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="material-symbols-outlined nav-brand__icon" style="font-variation-settings: 'FILL' 1;">auto_stories</span>
                <span class="nav-brand__text">LMS University Library</span>
            </a>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Login</a>
            </div>
        </nav>
    </header>

    <div class="auth-split-wrapper" style="margin-top: 64px;">
        <!-- Left Side: Informative/Atmospheric Column -->
        <section class="auth-split-left" style="padding: var(--space-3xl); flex-direction: column; justify-content: center;">
            <div style="max-width: 480px; margin: 0 auto;">
                <h1 style="font-family: var(--font-headline); font-size: var(--text-display); line-height: var(--text-display-lh); color: var(--color-on-surface); margin-bottom: 24px; font-weight: 700;">Secure Your Knowledge</h1>
                <p style="font-family: var(--font-body); font-size: var(--text-body-lg); color: var(--color-on-surface-variant); margin-bottom: 32px; line-height: 1.6;">
                    Protect your academic profile and saved research. A strong password ensures your access to the university's digital collection remains private and secure.
                </p>
                <div class="auth-image-box">
                    <img alt="Library Interior" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB1bd01KQvQ6UhSPIXqdQZet4MkS6SqDDEHzBuHbSAqubiMc3AhaYppHJfHQ8hoi_8cr5VCBixTF0tDRIiT-0GM6d4qLdqvwiVJktUEberFPapV9Ig8LwVAcmpN7hFqa6cIzZSzRQ9lV55f2u6fT4q90a4ADHfc22_Vg_pRTjMhyaXWLfsk099DzP8wVt2B4oHsia61pBp1pUh92WdU4n68ezwaW78w2Sl-lCrmMdLibt_ouNaIaAJZZbzDIUXIH-SjXX1b8f2---Ku"/>
                    <div class="overlay"></div>
                </div>
            </div>
        </section>

        <!-- Right Side: Reset Password Card -->
        <section class="auth-split-right">
            <div class="auth-card" style="max-width: 500px;">
                <div style="margin-bottom: var(--space-xl);">
                    <h2 class="auth-title">Reset Password</h2>
                    <p class="auth-subtitle">Please provide your temporary password and choose a new unique password.</p>
                </div>
                
                <form id="resetForm" onsubmit="return false;">
                    <!-- Temporary Password -->
                    <div class="auth-form-group">
                        <label class="auth-form-label" for="temp_password">Temporary Password</label>
                        <div class="auth-input-wrapper">
                            <input class="auth-input auth-input--with-icon-right" id="temp_password" placeholder="Enter password from email" required type="password"/>
                            <button class="auth-input-icon-right material-symbols-outlined" onclick="togglePassword('temp_password', 'eye_icon_temp')" type="button" id="eye_icon_temp">visibility</button>
                        </div>
                        <p style="margin-top: 6px; font-size: var(--text-label-sm); color: var(--color-outline); font-style: italic;">Check your university email for the code sent by the admin.</p>
                    </div>
                    
                    <div class="auth-divider" style="margin: 24px 0;">
                        <div class="auth-divider-line"></div>
                    </div>
                    
                    <!-- New Password -->
                    <div class="auth-form-group">
                        <label class="auth-form-label" for="new_password">New Password</label>
                        <div class="auth-input-wrapper">
                            <input class="auth-input auth-input--with-icon-right" id="new_password" placeholder="Enter new password" required type="password"/>
                            <button class="auth-input-icon-right material-symbols-outlined" onclick="togglePassword('new_password', 'eye_icon_new')" type="button" id="eye_icon_new">visibility</button>
                        </div>
                    </div>
                    
                    <!-- Confirm Password -->
                    <div class="auth-form-group">
                        <label class="auth-form-label" for="confirm_password">Confirm Password</label>
                        <div class="auth-input-wrapper">
                            <input class="auth-input auth-input--with-icon-right" id="confirm_password" placeholder="Repeat new password" required type="password"/>
                            <button class="auth-input-icon-right material-symbols-outlined" onclick="togglePassword('confirm_password', 'eye_icon_confirm')" type="button" id="eye_icon_confirm">visibility</button>
                        </div>
                    </div>

                    <!-- Real-time Validation Panel -->
                    <div class="auth-validation-box">
                        <h3 class="auth-validation-title">
                            <span class="material-symbols-outlined text-[18px]">security</span>
                            Security Requirements
                        </h3>
                        <div class="auth-validation-grid">
                            <div class="auth-validation-item validation-failed" id="req-length">
                                <span class="material-symbols-outlined" id="icon-length">cancel</span>
                                At least 8 characters
                            </div>
                            <div class="auth-validation-item validation-failed" id="req-upper">
                                <span class="material-symbols-outlined" id="icon-upper">cancel</span>
                                Uppercase letter
                            </div>
                            <div class="auth-validation-item validation-failed" id="req-lower">
                                <span class="material-symbols-outlined" id="icon-lower">cancel</span>
                                Lowercase letter
                            </div>
                            <div class="auth-validation-item validation-failed" id="req-number">
                                <span class="material-symbols-outlined" id="icon-number">cancel</span>
                                One number
                            </div>
                            <div class="auth-validation-item validation-failed" id="req-special">
                                <span class="material-symbols-outlined" id="icon-special">cancel</span>
                                Special character
                            </div>
                            <div class="auth-validation-item validation-failed" id="req-match">
                                <span class="material-symbols-outlined" id="icon-match">cancel</span>
                                Passwords match
                            </div>
                        </div>
                    </div>
                    
                    <button class="auth-submit-btn" disabled id="submitBtn" type="submit" style="margin-top: 16px;">
                        Update Password
                    </button>
                </form>
            </div>
        </section>
    </div>

    <script>
        const tempInput = document.getElementById('temp_password');
        const passInput = document.getElementById('new_password');
        const confirmInput = document.getElementById('confirm_password');
        const submitBtn = document.getElementById('submitBtn');

        const requirements = {
            length: { id: 'req-length', icon: 'icon-length', regex: /.{8,}/ },
            upper: { id: 'req-upper', icon: 'icon-upper', regex: /[A-Z]/ },
            lower: { id: 'req-lower', icon: 'icon-lower', regex: /[a-z]/ },
            number: { id: 'req-number', icon: 'icon-number', regex: /[0-9]/ },
            special: { id: 'req-special', icon: 'icon-special', regex: /[^A-Za-z0-9]/ }
        };

        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === "password") {
                input.type = "text";
                icon.innerText = "visibility_off";
            } else {
                input.type = "password";
                icon.innerText = "visibility";
            }
        }

        function validate() {
            const tempVal = tempInput.value;
            const val = passInput.value;
            const confirmVal = confirmInput.value;
            let allPassed = true;

            if (!tempVal) {
                allPassed = false;
            }

            for (const key in requirements) {
                const req = requirements[key];
                const element = document.getElementById(req.id);
                const icon = document.getElementById(req.icon);
                
                if (req.regex.test(val)) {
                    element.classList.remove('validation-failed');
                    element.classList.add('validation-passed');
                    icon.innerText = 'check_circle';
                    icon.style.fontVariationSettings = "'FILL' 1";
                } else {
                    element.classList.add('validation-failed');
                    element.classList.remove('validation-passed');
                    icon.innerText = 'cancel';
                    icon.style.fontVariationSettings = "'FILL' 0";
                    allPassed = false;
                }
            }

            const matchElement = document.getElementById('req-match');
            const matchIcon = document.getElementById('icon-match');
            if (val && confirmVal && val === confirmVal) {
                matchElement.classList.remove('validation-failed');
                matchElement.classList.add('validation-passed');
                matchIcon.innerText = 'check_circle';
                matchIcon.style.fontVariationSettings = "'FILL' 1";
            } else {
                matchElement.classList.add('validation-failed');
                matchElement.classList.remove('validation-passed');
                matchIcon.innerText = 'cancel';
                matchIcon.style.fontVariationSettings = "'FILL' 0";
                allPassed = false;
            }

            submitBtn.disabled = !allPassed;
        }

        tempInput.addEventListener('input', validate);
        passInput.addEventListener('input', validate);
        confirmInput.addEventListener('input', validate);
    </script>
</body>
</html>
