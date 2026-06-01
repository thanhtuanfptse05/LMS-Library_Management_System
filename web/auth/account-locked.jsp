<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Account Locked - LMS University Library</title>
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
            display: inline-block;
            line-height: 1;
            text-transform: none;
            letter-spacing: normal;
            word-wrap: normal;
            white-space: nowrap;
            direction: ltr;
        }
        body {
            background-color: #FFF7ED;
        }
    </style>
</head>
<body class="auth-body" style="align-items: flex-start;">
    <!-- TopAppBar -->
    <header class="main-header">
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="material-symbols-outlined nav-brand__icon" style="font-variation-settings: 'FILL' 1;">local_library</span>
                <span class="nav-brand__text">LMS University Library</span>
            </a>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-primary">Login</a>
            </div>
        </nav>
    </header>

    <!-- Main Content: Account Locked State -->
    <main class="auth-full-page" style="margin-top: 64px; position: relative; overflow: hidden;">
        <!-- Atmospheric Background Elements -->
        <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; overflow: hidden; z-index: -1;">
            <div style="position: absolute; top: -100px; left: -100px; width: 400px; height: 400px; background-color: rgba(157, 67, 0, 0.05); border-radius: 50%; filter: blur(40px);"></div>
            <div style="position: absolute; bottom: 0; right: 0; width: 500px; height: 500px; background-color: rgba(253, 214, 169, 0.1); border-radius: 50%; filter: blur(100px);"></div>
        </div>

        <div class="auth-locked-grid">
            <!-- Visual Side (Hidden on Mobile) -->
            <div class="auth-locked-visual">
                <img alt="Academic Library Architecture" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCQg4ubgcUSXgWxkOKUKa9kaKUbAytQWPCslLBZU-S0Qc2VA1L_EXt7OWOcVTvl2GgYC_h36efQcssU-HKRWBJ_Zz4GLz1fELaOGOnuHRNQuZdsZGNJmiWvmYMWi0VjdToi34jPCiOBwKEgtyQ2Kc8Z9S33JbyuQ1WoBjMirdopMmrtCyRjON2TQqA9qKvLfprJbjbCPH4B69pY1sJR1X0xQFozNSd3-AHGdNRM4xcF6AqXazbXsFH6XF9hXS2gDfvfHlztCNheFgDg"/>
                <div class="auth-locked-overlay"></div>
                <div class="auth-locked-text">
                    <p style="font-family: var(--font-headline); font-size: var(--text-headline-md); line-height: var(--text-headline-md-lh); margin-bottom: 8px;">Preserving Academic Integrity</p>
                    <p style="font-family: var(--font-body); font-size: var(--text-body-md); opacity: 0.9;">Security protocols are in place to protect your research and digital identity.</p>
                </div>
            </div>
            
            <!-- Warning Card Container -->
            <div class="auth-card auth-card--warning" id="locked-card">
                <!-- Decorative Lock Icon -->
                <div class="auth-locked-icon-box">
                    <span class="material-symbols-outlined" style="font-size: 40px; font-variation-settings: 'FILL' 1;">lock_person</span>
                </div>
                
                <div>
                    <h1 style="font-family: var(--font-headline); font-size: var(--text-display); line-height: var(--text-display-lh); color: var(--color-on-surface); margin-bottom: 8px; text-align: center;">Account Locked</h1>
                    <p style="font-family: var(--font-body); font-size: var(--text-body-lg); color: var(--color-on-surface-variant); text-align: center;">For your security, your library access has been temporarily suspended due to multiple unsuccessful login attempts.</p>
                    
                    <div class="auth-locked-info">
                        <h2 style="font-family: var(--font-headline); font-size: var(--text-headline-md); color: var(--color-primary); display: flex; align-items: center; gap: 8px; margin-bottom: 16px;">
                            <span class="material-symbols-outlined">info</span>
                            How to Unlock
                        </h2>
                        <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 12px; font-family: var(--font-body); font-size: var(--text-body-md); color: var(--color-on-surface-variant);">
                            <li style="display: flex; align-items: flex-start; gap: 12px;">
                                <span class="material-symbols-outlined" style="color: var(--color-primary); font-size: 20px;">mail</span>
                                <span>Check your university email for a <strong>Verification Link</strong> sent automatically.</span>
                            </li>
                            <li style="display: flex; align-items: flex-start; gap: 12px;">
                                <span class="material-symbols-outlined" style="color: var(--color-primary); font-size: 20px;">timer</span>
                                <span>Alternatively, wait <strong>30 minutes</strong> for the account to reset automatically.</span>
                            </li>
                            <li style="display: flex; align-items: flex-start; gap: 12px;">
                                <span class="material-symbols-outlined" style="color: var(--color-primary); font-size: 20px;">badge</span>
                                <span>Visit the <strong>Library Help Desk</strong> with your physical Student ID.</span>
                            </li>
                        </ul>
                    </div>
                    
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <button onclick="window.location.href='login.jsp';" class="auth-submit-btn" style="border-radius: var(--radius-full);">
                            <span class="material-symbols-outlined">arrow_back</span>
                            Return to Login
                        </button>
                        <button class="auth-submit-btn" style="background-color: var(--color-secondary-container); color: var(--color-on-secondary-container); border-radius: var(--radius-full); box-shadow: var(--shadow-sm);">
                            <span class="material-symbols-outlined">support_agent</span>
                            Contact Support
                        </button>
                    </div>
                    
                    <div class="auth-support-channels">
                        <p style="font-family: var(--font-body); font-size: var(--text-label-sm); color: var(--color-on-surface-variant); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 16px;">Support Channels</p>
                        <div class="auth-support-grid">
                            <div class="auth-support-item">
                                <div class="auth-support-icon">
                                    <span class="material-symbols-outlined">phone</span>
                                </div>
                                <div class="auth-support-text">
                                    <span style="font-size: var(--text-label-sm); opacity: 0.6;">Hotline</span>
                                    <span style="font-size: var(--text-label-md); font-weight: 600;">+1 (555) LIBRARY</span>
                                </div>
                            </div>
                            <div class="auth-support-item">
                                <div class="auth-support-icon">
                                    <span class="material-symbols-outlined">chat</span>
                                </div>
                                <div class="auth-support-text">
                                    <span style="font-size: var(--text-label-sm); opacity: 0.6;">Live Chat</span>
                                    <span style="font-size: var(--text-label-md); font-weight: 600;">Available 24/7</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer style="background-color: var(--color-surface-container-lowest); border-top: 1px solid var(--color-outline-variant); margin-top: auto;">
        <div style="display: flex; flex-direction: column; justify-content: space-between; align-items: center; padding: var(--space-2xl) var(--space-margin-mobile); max-width: 1440px; margin: 0 auto; width: 100%;">
            <div style="text-align: center; margin-bottom: var(--space-xl);">
                <div style="font-family: var(--font-headline); font-size: var(--text-title-lg); font-weight: 700; color: var(--color-on-surface); margin-bottom: 8px;">LMS Library</div>
                <p style="font-family: var(--font-body); font-size: var(--text-label-sm); color: var(--color-on-surface-variant); margin: 0;">© 2024 University Library Management System. All rights reserved.</p>
            </div>
            <nav style="display: flex; flex-wrap: wrap; justify-content: center; gap: 24px;">
                <a href="#" class="auth-link" style="color: var(--color-on-surface-variant); font-size: var(--text-label-sm);">Privacy Policy</a>
                <a href="#" class="auth-link" style="color: var(--color-on-surface-variant); font-size: var(--text-label-sm);">Terms of Service</a>
                <a href="#" class="auth-link" style="color: var(--color-on-surface-variant); font-size: var(--text-label-sm);">Contact Support</a>
            </nav>
        </div>
    </footer>
    
    <script>
        // Micro-interaction for the error card "shake" on load
        window.addEventListener('DOMContentLoaded', () => {
            const card = document.getElementById('locked-card');
            card.style.transition = 'transform 0.5s cubic-bezier(0.36, 0.07, 0.19, 0.97), opacity 0.5s ease';
            
            // Initial subtle entrance
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>
