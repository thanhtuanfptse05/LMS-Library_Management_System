<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Forgot Password - LMS University Library</title>
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
<body class="auth-body">
    <!-- TopAppBar -->
    <header class="main-header">
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="material-symbols-outlined nav-brand__icon" style="font-variation-settings: 'FILL' 1;">auto_stories</span>
                <span class="nav-brand__text">LMS University Library</span>
            </a>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login</a>
            </div>
        </nav>
    </header>
    
    <!-- Main Content Area -->
    <main class="auth-full-page">
        <div class="auth-card" style="margin-top: 64px;">
            <div style="text-align: center; margin-bottom: var(--space-xl);">
                <div style="width: 64px; height: 64px; background-color: var(--color-surface-container); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-md) auto;">
                    <span class="material-symbols-outlined" style="color: var(--color-primary); font-size: 32px;">lock_reset</span>
                </div>
                <h1 class="auth-title">Password Recovery</h1>
                <p class="auth-subtitle" style="margin-bottom: 0;">Enter your institutional email and we will send you a temporary password to regain access.</p>
            </div>
            
            <div id="statusAlert" style="display: none;"></div>

            <form id="forgotPasswordForm" onsubmit="handleForgotPassword(event)">
                <div class="auth-form-group">
                    <label class="auth-form-label" for="email">Institutional Email</label>
                    <div class="auth-input-wrapper">
                        <span class="auth-input-icon-left material-symbols-outlined">mail</span>
                        <input class="auth-input auth-input--with-icon-left" 
                               id="email" name="email" placeholder="m.student@university.edu" required type="email" />
                    </div>
                </div>
                
                <button class="auth-submit-btn" id="submitBtn" type="submit">
                    <span class="material-symbols-outlined" id="submitIcon">send</span>
                    <span id="submitText">Send Recovery Email</span>
                </button>
            </form>

            <div style="text-align: center; margin-top: var(--space-xl);">
                <a href="${pageContext.request.contextPath}/login" class="auth-header-link" style="justify-content: center;">
                    <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
                    Back to Login
                </a>
            </div>
            
            <!-- Success State (Hidden by default) -->
            <div id="successState" style="display: none; text-align: center;">
                <div style="width: 80px; height: 80px; background-color: #d4edda; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-xl) auto; box-shadow: 0 4px 6px rgba(40,167,69,0.2);">
                    <span class="material-symbols-outlined" style="color: #28a745; font-size: 40px; font-variation-settings: 'FILL' 1;">mark_email_read</span>
                </div>
                <h2 class="auth-title">Check your inbox</h2>
                <p class="auth-subtitle">We have sent a temporary password to <strong style="color: var(--color-on-surface);" id="displayEmail"></strong>.</p>
                <div style="background-color: var(--color-surface-container-low); padding: var(--space-md); border-radius: var(--radius-lg); margin-bottom: var(--space-xl); display: flex; align-items: flex-start; gap: 8px;">
                    <span class="material-symbols-outlined" style="color: var(--color-on-surface-variant); font-size: 20px; margin-top: 2px;">info</span>
                    <p style="font-size: var(--text-label-sm); color: var(--color-on-surface-variant); text-align: left; margin: 0;">Please check your spam folder if you do not see the email within 5 minutes.</p>
                </div>
                <a class="auth-submit-btn" href="${pageContext.request.contextPath}/login" style="text-decoration: none;">
                    <span class="material-symbols-outlined">login</span>
                    <span>Return to Login</span>
                </a>
            </div>
        </div>
    </main>
    
    <script>
        function handleForgotPassword(event) {
            event.preventDefault();
            const form = document.getElementById('forgotPasswordForm');
            const email = document.getElementById('email').value;
            const btn = document.getElementById('submitBtn');
            const btnText = document.getElementById('submitText');
            const btnIcon = document.getElementById('submitIcon');
            const alertBox = document.getElementById('statusAlert');
            const successState = document.getElementById('successState');
            
            // Basic UI validation
            if (!email || !email.includes('@')) {
                alertBox.className = 'auth-alert auth-alert--error';
                alertBox.innerHTML = '<span class="material-symbols-outlined">error</span><span>Please enter a valid institutional email address.</span>';
                alertBox.style.display = 'flex';
                return;
            }
            
            // Loading state
            alertBox.style.display = 'none';
            btn.disabled = true;
            btnText.innerText = 'Sending...';
            btnIcon.innerText = 'hourglass_empty';
            
            // Make real fetch request
            fetch('${pageContext.request.contextPath}/forgot-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('System error');
                }
            })
            .then(data => {
                if (data.success) {
                    // Success logic
                    form.style.display = 'none';
                    document.querySelector('.auth-header-link').style.display = 'none'; // Hide the back to login link
                    document.querySelector('.auth-title').style.display = 'none'; // Hide old title
                    document.querySelector('.auth-subtitle').style.display = 'none'; // Hide old subtitle
                    document.querySelector('.material-symbols-outlined.lock_reset')?.parentElement.remove(); // Hide old icon
                    
                    document.getElementById('displayEmail').innerText = email;
                    successState.style.display = 'block';
                    successState.style.animation = 'fadeIn 0.5s ease-out';
                } else {
                    alertBox.className = 'auth-alert auth-alert--error';
                    alertBox.innerHTML = '<span class="material-symbols-outlined">error</span><span>' + data.message + '</span>';
                    alertBox.style.display = 'flex';
                    btn.disabled = false;
                    btnText.innerText = 'Send Recovery Email';
                    btnIcon.innerText = 'send';
                }
            })
            .catch(error => {
                alertBox.className = 'auth-alert auth-alert--error';
                alertBox.innerHTML = '<span class="material-symbols-outlined">error</span><span>Đã xảy ra lỗi kết nối. Vui lòng thử lại sau.</span>';
                alertBox.style.display = 'flex';
                btn.disabled = false;
                btnText.innerText = 'Send Recovery Email';
                btnIcon.innerText = 'send';
            });
        }
    </script>
</body>
</html>
