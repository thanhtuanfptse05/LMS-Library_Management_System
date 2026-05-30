<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Reset Password | LMS University Library</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
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
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }
        .validation-passed { color: #15803d; }
        .validation-failed { color: #8c7164; }
        .transition-soft { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    </style>
</head>
<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col">
<!-- TopAppBar -->
<header class="bg-surface dark:bg-surface-dim shadow-sm docked full-width top-0 z-50">
<div class="flex justify-between items-center px-container-padding-mobile md:px-container-padding-desktop h-16 w-full max-w-[1440px] mx-auto">
<div class="font-headline-md text-headline-md font-bold text-primary dark:text-primary-fixed-dim flex items-center gap-2">
<span class="material-symbols-outlined text-primary" data-icon="library_books">library_books</span>
            LMS University Library
        </div>
<div class="flex items-center gap-4">
<button class="text-on-surface-variant dark:text-outline-variant hover:text-primary transition-colors p-2 rounded-full">
<span class="material-symbols-outlined" data-icon="help_outline">help_outline</span>
</button>
</div>
</div>
</header>
<!-- Main Content Area -->
<main class="flex-grow flex items-center justify-center py-section-gap px-container-padding-mobile">
<div class="w-full max-w-[1100px] grid grid-cols-1 lg:grid-cols-12 gap-gutter items-stretch">
<!-- Left Side: Informative/Atmospheric Column -->
<div class="hidden lg:flex lg:col-span-5 flex-col justify-center pr-8">
<h1 class="font-display-lg text-display-lg text-on-surface mb-6">Secure Your Knowledge</h1>
<p class="font-body-lg text-body-lg text-on-surface-variant mb-8 leading-relaxed">
                Protect your academic profile and saved research. A strong password ensures your access to the university's digital collection remains private and secure.
            </p>
<div class="relative w-full aspect-square rounded-[32px] overflow-hidden shadow-xl rotate-3">
<img alt="Library Interior" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB1bd01KQvQ6UhSPIXqdQZet4MkS6SqDDEHzBuHbSAqubiMc3AhaYppHJfHQ8hoi_8cr5VCBixTF0tDRIiT-0GM6d4qLdqvwiVJktUEberFPapV9Ig8LwVAcmpN7hFqa6cIzZSzRQ9lV55f2u6fT4q90a4ADHfc22_Vg_pRTjMhyaXWLfsk099DzP8wVt2B4oHsia61pBp1pUh92WdU4n68ezwaW78w2Sl-lCrmMdLibt_ouNaIaAJZZbzDIUXIH-SjXX1b8f2---Ku"/>
<div class="absolute inset-0 bg-gradient-to-t from-primary/40 to-transparent"></div>
</div>
</div>
<!-- Right Side: Reset Password Card -->
<div class="lg:col-span-7 flex flex-col justify-center">
<div class="bg-surface-container-lowest dark:bg-surface-container-low rounded-[24px] p-8 md:p-12 shadow-[0_4px_6px_-1px_rgba(0,0,0,0.05),0_2px_4px_-1px_rgba(0,0,0,0.03)] border border-outline-variant/30">
<div class="mb-8">
<h2 class="font-headline-lg text-headline-lg text-on-surface mb-2">Reset Password</h2>
<p class="font-body-md text-body-md text-on-surface-variant">Please provide your temporary password and choose a new unique password.</p>
</div>
<form class="space-y-6" id="resetForm" onsubmit="return false;">
<div class="space-y-4">
<!-- Temporary Password -->
<div class="relative">
<label class="block font-label-md text-label-md text-on-surface mb-2" for="temp_password">Temporary Password</label>
<div class="relative">
<input class="w-full bg-white border border-outline-variant rounded-xl px-4 py-3.5 focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 outline-none transition-soft" id="temp_password" placeholder="Enter password from email" required="" type="password"/>
<button class="absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-primary transition-colors" onclick="togglePassword('temp_password', 'eye_icon_temp')" type="button">
<span class="material-symbols-outlined" data-icon="visibility" id="eye_icon_temp">visibility</span>
</button>
</div>
<p class="mt-1.5 font-label-sm text-label-sm text-on-surface-variant/70 italic">Check your university email for the code sent by the admin.</p>
</div>
<div class="h-px bg-outline-variant/30 my-6"></div>
<!-- New Password -->
<div class="relative">
<label class="block font-label-md text-label-md text-on-surface mb-2" for="new_password">New Password</label>
<div class="relative">
<input class="w-full bg-white border border-outline-variant rounded-xl px-4 py-3.5 focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 outline-none transition-soft" id="new_password" placeholder="Enter new password" required="" type="password"/>
<button class="absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-primary transition-colors" onclick="togglePassword('new_password', 'eye_icon_new')" type="button">
<span class="material-symbols-outlined" data-icon="visibility" id="eye_icon_new">visibility</span>
</button>
</div>
</div>
<!-- Confirm Password -->
<div class="relative">
<label class="block font-label-md text-label-md text-on-surface mb-2" for="confirm_password">Confirm Password</label>
<div class="relative">
<input class="w-full bg-white border border-outline-variant rounded-xl px-4 py-3.5 focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 outline-none transition-soft" id="confirm_password" placeholder="Repeat new password" required="" type="password"/>
<button class="absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-primary transition-colors" onclick="togglePassword('confirm_password', 'eye_icon_confirm')" type="button">
<span class="material-symbols-outlined" data-icon="visibility" id="eye_icon_confirm">visibility</span>
</button>
</div>
</div>
</div>
<!-- Real-time Validation Panel -->
<div class="bg-surface-container-low dark:bg-surface-container p-6 rounded-2xl border border-outline-variant/20">
<h3 class="font-label-md text-label-md text-on-surface mb-4 flex items-center gap-2">
<span class="material-symbols-outlined text-[18px]" data-icon="security">security</span>
                            Security Requirements
                        </h3>
<div class="grid grid-cols-1 md:grid-cols-2 gap-y-3 gap-x-6">
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-length">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-length">cancel</span>
                                At least 8 characters
                            </div>
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-upper">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-upper">cancel</span>
                                Uppercase letter
                            </div>
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-lower">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-lower">cancel</span>
                                Lowercase letter
                            </div>
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-number">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-number">cancel</span>
                                One number
                            </div>
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-special">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-special">cancel</span>
                                Special character
                            </div>
<div class="flex items-center gap-2 font-label-sm text-label-sm validation-failed transition-soft" id="req-match">
<span class="material-symbols-outlined text-[16px]" data-icon="cancel" id="icon-match">cancel</span>
                                Passwords match
                            </div>
</div>
</div>
<button class="w-full bg-primary-container text-white font-label-md text-label-md py-4 rounded-xl shadow-lg hover:bg-primary transition-all duration-200 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:scale-100 mt-4" disabled="" id="submitBtn" type="submit">
                        Update Password
                    </button>
</form>
</div>
</div>
</div>
</main>
<!-- Footer -->
<footer class="bg-surface-container-lowest dark:bg-surface-container-low border-t border-outline-variant dark:border-outline mt-auto">
<div class="flex flex-col md:flex-row justify-between items-center py-8 px-container-padding-mobile md:px-container-padding-desktop w-full max-w-[1440px] mx-auto">
<div class="font-title-lg text-title-lg font-bold text-on-surface mb-4 md:mb-0">LMS University Library</div>
<div class="flex flex-wrap justify-center gap-6 font-label-sm text-label-sm mb-4 md:mb-0">
<a class="text-on-surface-variant dark:text-outline-variant hover:text-primary underline transition-opacity" href="#">Privacy Policy</a>
<a class="text-on-surface-variant dark:text-outline-variant hover:text-primary underline transition-opacity" href="#">Terms of Service</a>
<a class="text-on-surface-variant dark:text-outline-variant hover:text-primary underline transition-opacity" href="#">Contact Support</a>
</div>
<p class="font-label-sm text-label-sm text-on-surface-variant dark:text-outline-variant">
            © 2024 University Library Management System. All rights reserved.
        </p>
</div>
</footer>
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

        // Check if temporary password is provided
        if (!tempVal) {
            allPassed = false;
        }

        // Check specific requirements for new password
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

        // Check match
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
