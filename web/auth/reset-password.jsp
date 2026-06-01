<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Reset Password - LMS University Library</title>
    <!-- Standard CSS files -->
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
        
        body.auth-body {
            background-color: #FFFAf5;
            background-image: radial-gradient(#E5D5C5 1px, transparent 1px);
            background-size: 20px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 24px;
        }
        
        .page-wrapper {
            background-color: #ffffff;
            border-radius: 24px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 10px 40px rgba(0,0,0,0.03);
            width: 100%;
            max-width: 1100px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        /* Header */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 24px 40px;
            border-bottom: 1px solid #f0f0f0;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #C07C46;
            text-decoration: none;
            font-weight: 700;
            font-size: 18px;
        }
        .header-help {
            color: #888;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border: 1px solid #e5e5e5;
            border-radius: 50%;
            transition: all 0.2s;
        }
        .header-help:hover {
            background-color: #f5f5f5;
            color: #333;
        }
        .header-help .material-symbols-outlined {
            font-size: 18px;
        }
        
        /* Main Layout */
        .main-content {
            display: flex;
            flex-direction: column;
        }
        @media (min-width: 768px) {
            .main-content {
                flex-direction: row;
            }
        }
        
        .left-panel {
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
        }
        @media (min-width: 768px) {
            .left-panel {
                width: 50%;
                padding: 60px 40px 60px 80px;
            }
        }
        
        .right-panel {
            padding: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        @media (min-width: 768px) {
            .right-panel {
                width: 50%;
                padding: 40px 80px 40px 40px;
            }
        }
        
        /* Left Panel Content */
        .title-main {
            font-family: var(--font-headline);
            font-size: 42px;
            font-weight: 700;
            color: #1a1a1a;
            line-height: 1.15;
            margin-bottom: 20px;
        }
        .desc-main {
            font-size: 15px;
            color: #4a4a4a;
            line-height: 1.6;
            max-width: 400px;
            margin-bottom: 40px;
        }
        
        .hero-image-wrapper {
            background-color: #E68A45;
            border-radius: 24px;
            width: 100%;
            max-width: 320px;
            aspect-ratio: 1;
            transform: rotate(-3deg);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 16px 32px rgba(230, 138, 69, 0.25);
        }
        .hero-image-wrapper img {
            width: 85%;
            height: 55%;
            object-fit: cover;
            border-radius: 6px;
            transform: rotate(3deg);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        
        /* Right Panel Card */
        .auth-card-custom {
            background-color: #ffffff;
            border-radius: 16px;
            padding: 32px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.06);
        }
        .card-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        .card-subtitle {
            font-size: 13px;
            color: #666;
            margin-bottom: 28px;
            line-height: 1.5;
        }
        
        /* Forms */
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #333;
            margin-bottom: 6px;
        }
        .input-group {
            position: relative;
            margin-bottom: 20px;
        }
        .input-group.compact {
            margin-bottom: 16px;
        }
        .form-input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .form-input:focus {
            outline: none;
            border-color: #E68A45;
            box-shadow: 0 0 0 3px rgba(230, 138, 69, 0.1);
        }
        .input-icon-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            padding: 4px;
        }
        .input-icon-btn:hover {
            color: #333;
        }
        .input-hint {
            font-size: 11px;
            color: #888;
            font-style: italic;
            margin-top: 6px;
        }
        
        .divider {
            height: 1px;
            background-color: #f5f5f5;
            margin: 24px 0;
        }
        
        /* Validation Box */
        .validation-box {
            background-color: #FFF3EB;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 20px;
        }
        .validation-title {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        .validation-title .material-symbols-outlined {
            font-size: 14px;
        }
        .validation-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .validation-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: #666;
        }
        .validation-item .material-symbols-outlined {
            font-size: 12px;
        }
        .req-passed { color: #15803d; }
        .req-failed { color: #888; }
        
        /* Submit Button */
        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: #FFB380;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-submit:hover:not(:disabled) {
            background-color: #ffa166;
        }
        .btn-submit:disabled {
            background-color: #fbd6c4;
            cursor: not-allowed;
            color: #fffaf7;
        }
        
        /* Footer */
        .page-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 40px;
            border-top: 1px solid #f0f0f0;
            background-color: #fff;
            flex-wrap: wrap;
            gap: 16px;
        }
        .footer-brand {
            font-weight: 700;
            font-size: 13px;
            color: #1a1a1a;
        }
        .footer-links {
            display: flex;
            gap: 24px;
        }
        .footer-links a {
            color: #666;
            text-decoration: none;
            font-size: 11px;
            font-weight: 500;
        }
        .footer-links a:hover {
            text-decoration: underline;
        }
        .footer-copy {
            font-size: 11px;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .page-footer {
                flex-direction: column;
                text-align: center;
            }
            .title-main {
                font-size: 32px;
            }
            .left-panel, .right-panel, .page-header, .page-footer {
                padding: 24px;
            }
        }
    </style>
</head>
<body class="auth-body">

<div class="page-wrapper">
    <!-- Header -->
    <header class="page-header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="header-brand">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">auto_stories</span>
            <span>LMS University Library</span>
        </a>
        <a href="#" class="header-help">
            <span class="material-symbols-outlined">help</span>
        </a>
    </header>

    <!-- Main -->
    <main class="main-content">
        <!-- Left Side -->
        <div class="left-panel">
            <h1 class="title-main">Secure Your<br/>Knowledge</h1>
            <p class="desc-main">
                Protect your academic profile and saved research. A strong password ensures your access to the university's digital collection remains private and secure.
            </p>
            <div class="hero-image-wrapper">
                <img alt="Library Interior" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB1bd01KQvQ6UhSPIXqdQZet4MkS6SqDDEHzBuHbSAqubiMc3AhaYppHJfHQ8hoi_8cr5VCBixTF0tDRIiT-0GM6d4qLdqvwiVJktUEberFPapV9Ig8LwVAcmpN7hFqa6cIzZSzRQ9lV55f2u6fT4q90a4ADHfc22_Vg_pRTjMhyaXWLfsk099DzP8wVt2B4oHsia61pBp1pUh92WdU4n68ezwaW78w2Sl-lCrmMdLibt_ouNaIaAJZZbzDIUXIH-SjXX1b8f2---Ku"/>
            </div>
        </div>

        <!-- Right Side -->
        <div class="right-panel">
            <div class="auth-card-custom">
                <h2 class="card-title">Reset Password</h2>
                <p class="card-subtitle">Please provide your temporary password and choose a new unique password.</p>
                
                <form id="resetForm" onsubmit="return false;">
                    <!-- Temporary Password -->
                    <div class="input-group">
                        <label class="form-label" for="temp_password">Temporary Password</label>
                        <input class="form-input" id="temp_password" placeholder="Enter password from email" required type="password"/>
                        <button class="input-icon-btn material-symbols-outlined" onclick="togglePassword('temp_password', 'eye_icon_temp')" type="button" id="eye_icon_temp">visibility</button>
                        <p class="input-hint">Check your university email for the code sent by the admin.</p>
                    </div>
                    
                    <div class="divider"></div>
                    
                    <!-- New Password -->
                    <div class="input-group compact">
                        <label class="form-label" for="new_password">New Password</label>
                        <input class="form-input" id="new_password" placeholder="Enter new password" required type="password"/>
                        <button class="input-icon-btn material-symbols-outlined" onclick="togglePassword('new_password', 'eye_icon_new')" type="button" id="eye_icon_new">visibility</button>
                    </div>
                    
                    <!-- Confirm Password -->
                    <div class="input-group">
                        <label class="form-label" for="confirm_password">Confirm Password</label>
                        <input class="form-input" id="confirm_password" placeholder="Repeat new password" required type="password"/>
                        <button class="input-icon-btn material-symbols-outlined" onclick="togglePassword('confirm_password', 'eye_icon_confirm')" type="button" id="eye_icon_confirm">visibility</button>
                    </div>

                    <!-- Security Requirements -->
                    <div class="validation-box">
                        <div class="validation-title">
                            <span class="material-symbols-outlined">security</span>
                            Security Requirements
                        </div>
                        <div class="validation-grid">
                            <div class="validation-item req-failed" id="req-length">
                                <span class="material-symbols-outlined" id="icon-length">cancel</span>
                                At least 8 characters
                            </div>
                            <div class="validation-item req-failed" id="req-upper">
                                <span class="material-symbols-outlined" id="icon-upper">cancel</span>
                                Uppercase letter
                            </div>
                            <div class="validation-item req-failed" id="req-lower">
                                <span class="material-symbols-outlined" id="icon-lower">cancel</span>
                                Lowercase letter
                            </div>
                            <div class="validation-item req-failed" id="req-number">
                                <span class="material-symbols-outlined" id="icon-number">cancel</span>
                                One number
                            </div>
                            <div class="validation-item req-failed" id="req-special">
                                <span class="material-symbols-outlined" id="icon-special">cancel</span>
                                Special character
                            </div>
                            <div class="validation-item req-failed" id="req-match">
                                <span class="material-symbols-outlined" id="icon-match">cancel</span>
                                Passwords match
                            </div>
                        </div>
                    </div>
                    
                    <button class="btn-submit" disabled id="submitBtn" type="submit">
                        Update Password
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-brand">LMS University</div>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Contact Support</a>
        </div>
        <div class="footer-copy">© 2024 University Library Management System. All rights reserved.</div>
    </footer>
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
                    element.classList.remove('req-failed');
                    element.classList.add('req-passed');
                    icon.innerText = 'check_circle';
                    icon.style.fontVariationSettings = "'FILL' 1";
                } else {
                    element.classList.add('req-failed');
                    element.classList.remove('req-passed');
                    icon.innerText = 'cancel';
                    icon.style.fontVariationSettings = "'FILL' 0";
                    allPassed = false;
                }
            }

            const matchElement = document.getElementById('req-match');
            const matchIcon = document.getElementById('icon-match');
            if (val && confirmVal && val === confirmVal) {
                matchElement.classList.remove('req-failed');
                matchElement.classList.add('req-passed');
                matchIcon.innerText = 'check_circle';
                matchIcon.style.fontVariationSettings = "'FILL' 1";
            } else {
                matchElement.classList.add('req-failed');
                matchElement.classList.remove('req-passed');
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
