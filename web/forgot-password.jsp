<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Forgot Password - LMS University Library</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFF7ED; /* Level 0 Background from Style Guidance */
        }
    </style>
    <script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "on-primary-container": "#582200",
                      "on-secondary-fixed": "#2a1800",
                      "on-primary-fixed": "#341100",
                      "on-error": "#ffffff",
                      "primary-fixed": "#ffdbca",
                      "surface-container-lowest": "#ffffff",
                      "on-secondary": "#ffffff",
                      "primary": "#9d4300",
                      "secondary-fixed-dim": "#e6c095",
                      "surface-dim": "#edd5cb",
                      "on-error-container": "#93000a",
                      "tertiary-fixed-dim": "#93ccff",
                      "surface-container": "#ffeae0",
                      "outline": "#8c7164",
                      "background": "#fff8f6",
                      "on-primary-fixed-variant": "#783200",
                      "secondary-fixed": "#ffddb7",
                      "surface-tint": "#9d4300",
                      "on-tertiary-fixed": "#001d32",
                      "surface-variant": "#f6ded3",
                      "inverse-surface": "#3c2d26",
                      "tertiary-container": "#00a2f4",
                      "outline-variant": "#e0c0b1",
                      "surface": "#fff8f6",
                      "surface-container-high": "#fce3d9",
                      "on-tertiary-container": "#003554",
                      "on-secondary-fixed-variant": "#5b4220",
                      "on-surface-variant": "#584237",
                      "on-surface": "#251913",
                      "secondary-container": "#fdd6a9",
                      "on-tertiary-fixed-variant": "#004b74",
                      "surface-container-low": "#fff1eb",
                      "on-background": "#251913",
                      "primary-container": "#f97316",
                      "inverse-primary": "#ffb690",
                      "on-primary": "#ffffff",
                      "surface-bright": "#fff8f6",
                      "inverse-on-surface": "#ffede6",
                      "on-tertiary": "#ffffff",
                      "secondary": "#755935",
                      "primary-fixed-dim": "#ffb690",
                      "on-secondary-container": "#785c38",
                      "surface-container-highest": "#f6ded3",
                      "error-container": "#ffdad6",
                      "tertiary": "#006398",
                      "error": "#ba1a1a",
                      "tertiary-fixed": "#cde5ff"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "unit": "8px",
                      "section-gap": "48px",
                      "container-padding-mobile": "16px",
                      "component-gap": "16px",
                      "gutter": "24px",
                      "container-padding-desktop": "40px"
              },
              "fontFamily": {
                      "headline-lg-mobile": ["Inter"],
                      "body-lg": ["Inter"],
                      "label-sm": ["Inter"],
                      "headline-md": ["Inter"],
                      "body-md": ["Inter"],
                      "label-md": ["Inter"],
                      "headline-lg": ["Inter"],
                      "title-lg": ["Inter"],
                      "display-lg": ["Inter"]
              },
              "fontSize": {
                      "headline-lg-mobile": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                      "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                      "label-sm": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                      "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                      "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                      "label-md": ["14px", {"lineHeight": "20px", "fontWeight": "500"}],
                      "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "600"}],
                      "title-lg": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                      "display-lg": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
              }
            }
          }
        }
    </script>
</head>
<body class="bg-background text-on-surface min-h-screen flex flex-col">
    <header class="w-full bg-surface shadow-sm h-16 flex items-center px-container-padding-mobile md:px-container-padding-desktop justify-center">
        <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-primary text-3xl">auto_stories</span>
            <span class="font-headline-md text-headline-md font-bold text-primary">LMS University Library</span>
        </div>
    </header>
    
    <main class="flex-grow flex items-center justify-center p-container-padding-mobile md:p-container-padding-desktop relative overflow-hidden">
        <!-- Atmospheric Background Elements -->
        <div class="absolute top-[-10%] right-[-10%] w-[400px] h-[400px] bg-primary-fixed opacity-20 rounded-full blur-3xl"></div>
        <div class="absolute bottom-[-10%] left-[-10%] w-[300px] h-[300px] bg-secondary-fixed opacity-30 rounded-full blur-3xl"></div>
        
        <!-- Main Card Container -->
        <div class="relative z-10 w-full max-w-[440px] bg-surface-container-lowest rounded-[24px] shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] p-8 md:p-10 transition-all duration-500" id="auth-card">
            
            <!-- Forgot Password State -->
            <div class="space-y-6" id="forgot-password-form">
                <div class="text-center space-y-2">
                    <h1 class="font-headline-lg text-headline-lg text-on-surface">Forgot Password</h1>
                    <p class="font-body-md text-body-md text-on-surface-variant">No worries, it happens. Please enter the email address associated with your account.</p>
                </div>

                <form class="space-y-6" id="reset-request-form" onsubmit="handleReset(event)">
                    <div class="space-y-2">
                        <label class="font-label-md text-label-md text-on-surface-variant block ml-1" for="email">University Email Address</label>
                        <div class="relative group">
                            <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline-variant group-focus-within:text-primary transition-colors">mail</span>
                            <input class="w-full pl-12 pr-4 py-3 bg-white border border-outline-variant rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-container focus:border-primary-container transition-all text-on-surface font-body-md" id="email" name="email" placeholder="e.g. name@university.edu" required type="email" />
                        </div>
                    </div>
                    <button class="w-full bg-primary-container text-white py-4 rounded-xl font-label-md text-label-md hover:bg-primary transition-all active:scale-95 shadow-md flex items-center justify-center gap-2" type="submit" id="submit-btn">
                        Send Reset Link
                        <span class="material-symbols-outlined text-[20px]">send</span>
                    </button>
                </form>
                
                <div class="pt-4 text-center">
                    <a class="inline-flex items-center gap-2 font-label-md text-label-md text-primary hover:text-on-primary-fixed-variant transition-colors group" href="login.jsp">
                        <span class="material-symbols-outlined text-[18px] group-hover:-translate-x-1 transition-transform">arrow_back</span>
                        Back to Login
                    </a>
                </div>
            </div>

            <!-- Success State (Hidden by default) -->
            <div class="hidden space-y-6 text-center animate-in fade-in zoom-in duration-500" id="success-message">
                <div class="mx-auto w-20 h-20 bg-green-50 rounded-full flex items-center justify-center border-2 border-green-100 mb-6">
                    <span class="material-symbols-outlined text-green-600 text-[48px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                </div>
                <div class="space-y-3">
                    <h2 class="font-headline-md text-headline-md text-on-surface">Check your email</h2>
                    <div class="p-4 bg-green-50 border-l-4 border-green-500 rounded-lg text-left">
                        <p class="font-body-md text-body-md text-green-800">
                            Password reset instructions have been sent to your email. Please follow the link in the message to reset your password.
                        </p>
                    </div>
                </div>
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Didn't receive the email? Check your spam folder or 
                    <button class="text-primary font-semibold hover:underline decoration-2 underline-offset-4" onclick="location.reload()">try again</button>.
                </p>
                <div class="pt-6 border-t border-outline-variant">
                    <a class="w-full inline-flex items-center justify-center gap-2 font-label-md text-label-md text-primary py-3 rounded-lg border border-primary hover:bg-primary-fixed transition-all" href="login.jsp">
                        <span class="material-symbols-outlined text-[18px]">login</span>
                        Return to Login
                    </a>
                </div>
            </div>
            
        </div>
    </main>

    <footer class="bg-surface-container-lowest border-t border-outline-variant py-8 px-container-padding-mobile md:px-container-padding-desktop w-full">
        <div class="max-w-[1440px] mx-auto flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex flex-col items-center md:items-start gap-1">
                <span class="font-title-lg text-title-lg font-bold text-on-surface">LMS University Library</span>
                <p class="font-label-sm text-label-sm text-on-surface-variant">© 2024 University Library Management System. All rights reserved.</p>
            </div>
            <div class="flex flex-wrap justify-center gap-6">
                <a class="font-label-sm text-label-sm text-on-surface-variant hover:text-primary transition-opacity hover:opacity-80 underline" href="#">Privacy Policy</a>
                <a class="font-label-sm text-label-sm text-on-surface-variant hover:text-primary transition-opacity hover:opacity-80 underline" href="#">Terms of Service</a>
                <a class="font-label-sm text-label-sm text-on-surface-variant hover:text-primary transition-opacity hover:opacity-80 underline" href="#">Contact Support</a>
            </div>
        </div>
    </footer>

    <script>
        function handleReset(event) {
            event.preventDefault();
            const formContainer = document.getElementById('forgot-password-form');
            const successContainer = document.getElementById('success-message');
            const btn = document.getElementById('submit-btn');

            // Simulate loading
            const originalContent = btn.innerHTML;
            btn.innerHTML = `<span class="material-symbols-outlined animate-spin">progress_activity</span> Sending...`;
            btn.disabled = true;

            setTimeout(() => {
                // Smooth transition to success state
                formContainer.classList.add('opacity-0', 'scale-95');
                
                setTimeout(() => {
                    formContainer.classList.add('hidden');
                    successContainer.classList.remove('hidden');
                    successContainer.classList.add('flex', 'flex-col');
                }, 300);
            }, 1200);
        }

        window.addEventListener('load', () => {
            const card = document.getElementById('auth-card');
            card.classList.add('animate-in', 'fade-in', 'slide-in-from-bottom-8', 'duration-700');
        });
    </script>
</body>
</html>
