<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Login - LMS University Library</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFF7ED; /* Level 0 Background as per Style Guidance */
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
<body class="bg-background min-h-screen flex items-center justify-center">
    <main class="w-full h-screen flex flex-col md:flex-row overflow-hidden">
        <!-- Left Side: Illustration & Branding -->
        <section class="relative hidden md:flex md:w-1/2 lg:w-3/5 h-full overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-br from-primary-container/80 to-primary/90 mix-blend-multiply z-10"></div>
            <img alt="University Library" class="absolute inset-0 w-full h-full object-cover grayscale-[0.2]" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD_BNiCLhjMig8aQvEZ4cGp-g0OkTkHATR5wLQxSvGqtheUVmBrEHDyoI-tlV3Q3vu8GND6akSV6zLtXNQiDI_ViYnkU2CphuZrNx1z-rqE5rYEm-i6idHvjT_pSUCh3MQNDz0xW7Swa4jvG4pahXVRw5ETKG6kP7bqXV8jPOC28GWRshO5_hXqM2bFqyp5X6saqVmXtUrRPU37rduvI2KdDP98xpjqmJwzD9xJUyxpxUFewad3VU4BftBU1wDh4mgmaqEFNGx1sqqK"/>
            <div class="relative z-20 flex flex-col justify-between p-container-padding-desktop w-full h-full">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-white text-4xl" style="font-variation-settings: 'FILL' 1;">auto_stories</span>
                    <h1 class="font-headline-lg text-headline-lg text-white font-bold tracking-tight">LMS University Library</h1>
                </div>
                <div class="max-w-md">
                    <h2 class="font-display-lg text-display-lg text-white mb-4">Empowering the Minds of Tomorrow.</h2>
                    <p class="font-body-lg text-body-lg text-white/90">Access over 500,000 digital and physical resources with our state-of-the-art management system.</p>
                </div>
                <div class="flex gap-4">
                    <div class="bg-white/10 backdrop-blur-md rounded-xl p-4 border border-white/20">
                        <span class="block font-headline-md text-headline-md text-white">2.5M+</span>
                        <span class="font-label-md text-label-md text-white/70">Books Circulated</span>
                    </div>
                    <div class="bg-white/10 backdrop-blur-md rounded-xl p-4 border border-white/20">
                        <span class="block font-headline-md text-headline-md text-white">45k</span>
                        <span class="font-label-md text-label-md text-white/70">Active Students</span>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Right Side: Authentication Card -->
        <section class="w-full md:w-1/2 lg:w-2/5 flex items-center justify-center p-6 md:p-12 bg-surface">
            <div class="w-full max-w-md space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
                <!-- Branding for Mobile -->
                <div class="md:hidden flex flex-col items-center mb-10">
                    <div class="w-16 h-16 bg-primary-container rounded-2xl flex items-center justify-center mb-4 shadow-lg shadow-primary-container/20">
                        <span class="material-symbols-outlined text-white text-4xl" style="font-variation-settings: 'FILL' 1;">auto_stories</span>
                    </div>
                    <h1 class="font-headline-md text-headline-md text-primary font-bold">LMS University Library</h1>
                </div>
                
                <div class="text-left md:text-left">
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-2">Welcome Back</h2>
                    <p class="font-body-md text-body-md text-on-surface-variant">Please enter your institutional credentials to access the library dashboard.</p>
                </div>
                
                <!-- Error State Display (JSTL dynamic) -->
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="flex items-center p-4 rounded-lg bg-error-container border-l-4 border-error text-on-error-container shadow-sm animate-in fade-in zoom-in duration-300" id="error-alert">
                        <span class="material-symbols-outlined mr-3 text-error">error</span>
                        <span class="font-label-md text-label-md"><c:out value="${requestScope.errorMessage}" /></span>
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.successMessage}">
                    <div class="flex items-center p-4 rounded-lg bg-[#d4edda] border-l-4 border-[#28a745] text-[#155724] shadow-sm animate-in fade-in zoom-in duration-300" id="success-alert">
                        <span class="material-symbols-outlined mr-3 text-[#28a745]">check_circle</span>
                        <span class="font-label-md text-label-md"><c:out value="${requestScope.successMessage}" /></span>
                    </div>
                </c:if>

                <form class="space-y-6" action="${pageContext.request.contextPath}/login" method="POST">
                    <!-- Email Field -->
                    <div class="space-y-2">
                        <label class="font-label-md text-label-md text-on-surface-variant block" for="email">Institutional Email</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-outline group-focus-within:text-primary transition-colors">
                                <span class="material-symbols-outlined">mail</span>
                            </span>
                            <input class="w-full pl-10 pr-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary-container/20 focus:border-primary outline-none transition-all font-body-md text-body-md" 
                                   id="email" name="email" placeholder="m.student@university.edu" required type="email" 
                                   value="${not empty param.email ? param.email : ''}"/>
                        </div>
                    </div>
                    
                    <!-- Password Field -->
                    <div class="space-y-2">
                        <div class="flex justify-between items-center">
                            <label class="font-label-md text-label-md text-on-surface-variant block" for="password">Password</label>
                            <a class="font-label-md text-label-md text-primary hover:underline transition-all" href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
                        </div>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-outline group-focus-within:text-primary transition-colors">
                                <span class="material-symbols-outlined">lock</span>
                            </span>
                            <input class="w-full pl-10 pr-12 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary-container/20 focus:border-primary outline-none transition-all font-body-md text-body-md" 
                                   id="password" name="password" placeholder="••••••••" required type="password"/>
                            <button class="absolute inset-y-0 right-0 pr-3 flex items-center text-outline hover:text-on-surface transition-colors" onclick="togglePassword()" type="button">
                                <span class="material-symbols-outlined" id="password-toggle-icon">visibility</span>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Remember Me -->
                    <div class="flex items-center">
                        <input class="h-5 w-5 rounded border-outline-variant text-primary focus:ring-primary-container transition-all cursor-pointer" id="remember" name="remember" type="checkbox"/>
                        <label class="ml-2 font-body-md text-body-md text-on-surface-variant select-none cursor-pointer" for="remember">Remember me on this device</label>
                    </div>
                    
                    <!-- Submit Button -->
                    <button class="w-full bg-primary-container text-white py-4 rounded-xl font-title-lg text-title-lg font-semibold hover:bg-primary transition-all duration-200 active:scale-[0.98] shadow-lg shadow-primary-container/20 flex items-center justify-center gap-2" type="submit">
                        <span>Login</span>
                        <span class="material-symbols-outlined">login</span>
                    </button>
                </form>
                
                <div class="pt-8 flex flex-col items-center gap-4">
                    <div class="flex items-center w-full gap-4">
                        <div class="h-[1px] bg-outline-variant flex-1"></div>
                        <span class="font-label-sm text-label-sm text-outline uppercase tracking-widest">or login with</span>
                        <div class="h-[1px] bg-outline-variant flex-1"></div>
                    </div>
                    <div class="grid grid-cols-2 gap-4 w-full">
                        <a href="${pageContext.request.contextPath}/login/google" class="flex items-center justify-center gap-2 px-4 py-3 bg-white border border-outline-variant rounded-lg hover:bg-surface-container-low transition-colors font-label-md text-label-md text-on-surface">
                            <img alt="Google" class="w-5 h-5" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBqMW_TR8Vis0hOIi6Ok5gXYDNu5H3Wv-YGTeNbrq1C_fvULC3vW_s5kZkT5qZ0X_HKDqXR0C0t0X7YEltJymEscxrUE-gZeMTl589pYzT998zimpiCO-ImaRVnUXgb1mvsodhG2Fx14ZIKnKL6cm8ksavEO1YHo8cRIWooeLCQGnIHVId-PuigGcBQ1yIF-qABxCOMILWo3d7ca7GnSJIUGfQBvX-gAUESXI9TpF6S_0CgyQyV5D80RQOV4SgRKc-zOvhGzrEzqpTI"/>
                            <span>Google SSO</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/login/microsoft" class="flex items-center justify-center gap-2 px-4 py-3 bg-white border border-outline-variant rounded-lg hover:bg-surface-container-low transition-colors font-label-md text-label-md text-on-surface">
                            <span class="material-symbols-outlined text-[#0078D4]" style="font-variation-settings: 'FILL' 1;">grid_view</span>
                            <span>Microsoft</span>
                        </a>
                    </div>
                </div>
                
                <footer class="pt-10 text-center">
                    <p class="font-body-md text-body-md text-on-surface-variant">
                        Don't have an account? 
                        <a class="text-primary font-semibold hover:underline" href="${pageContext.request.contextPath}/contact">Contact the Registrar</a>
                    </p>
                </footer>
            </div>
        </section>
    </main>

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
        const illustration = document.querySelector('section img');
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
