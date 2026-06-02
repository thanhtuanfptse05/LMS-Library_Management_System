<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>LMS University Library - Reset Password</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />

    <style>
        :root {
            --primary: #9d4300;
            --primary-container: #f97316;
            --on-primary-container: #582200;
            --secondary: #565e74;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --surface-container-low: #f2f4f6;
            --surface-container-lowest: #ffffff;
            --outline-variant: #e0c0b1;
            --error: #ba1a1a;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
            color: var(--on-surface);
            min-height: 100vh;
        }

        .glass-overlay {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(8px);
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }

        /* Custom Styling to match original theme */
        .left-section {
            background-color: #f7f9fb;
            position: relative;
            overflow: hidden;
            min-height: 100vh;
        }

        .bg-parallax {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transform: scale(1.1) translate(-3.16px, 4.96px);
            transition: transform 0.1s ease-out;
            filter: brightness(0.8);
        }

        .custom-input {
            background-color: var(--surface-container-low);
            border: 1px solid var(--outline-variant);
            border-radius: 0.75rem;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            color: var(--on-surface);
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .custom-input:focus {
            background-color: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(157, 67, 0, 0.2);
            color: var(--on-surface);
            outline: none;
        }

        .custom-input.ring-error {
            border-color: var(--error) !important;
            box-shadow: 0 0 0 2px rgba(186, 26, 26, 0.2) !important;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary);
            font-size: 20px;
            z-index: 5;
        }

        .btn-update {
            background-color: var(--primary-container);
            color: white;
            font-weight: 600;
            font-size: 18px;
            padding: 0.85rem;
            border: none;
            border-radius: 0.75rem;
            transition: all 0.2s ease-in-out;
        }

        .btn-update:hover {
            filter: brightness(1.08);
            color: white;
        }

        .btn-update:active {
            transform: scale(0.98);
        }

        .link-back {
            color: var(--primary);
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
        }

        .link-back:hover {
            text-decoration: underline;
        }

        .link-back span {
            transition: transform 0.2s;
        }

        .link-back:hover span {
            transform: translateX(-4px);
        }

        .footer-link {
            color: var(--on-surface-variant);
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-link:hover {
            color: var(--primary);
        }

        .text-error {
            color: var(--error);
            font-size: 12.5px;
            font-weight: 600;
            margin-top: 0.35rem;
            margin-left: 0.25rem;
        }
    </style>
</head>

<body class="d-flex flex-column">

    <main class="flex-grow-1 d-flex flex-column flex-md-row">

        <section class="left-section d-none d-md-flex w-50 align-items-center justify-content-center">
            <img class="bg-parallax" data-alt="A grand, modern university library interior..."
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuARaoOV6zhORKk5Hs8pVWbtuOJ9Al_XGBIW9cC3vfZUKKIM1xGpqbEF1OKiLjmSeh9T4oIahq-yFH4rn667p-Vi7OYAgeMynlg55803kXITBAuEN6PMHtlJLcAg2Ia8dSc7jITULlX_w8eW5OW9wSu9IvVREBdjLfKQYkTfoTdfn1VR5YQZEI-KDww01ItfLXU4db_qblxXPluOSIda34Xx6N9Wlw4o7NYcDj3qnXqFHJZ3xU_HWNasDV_Az8qpicjbInT9Uv7hIZFI" />
            <div class="position-relative z-3 glass-overlay p-5 rounded-4 max-w-lg text-white mx-4"
                style="max-width: 512px;">
                <h1 class="fw-bold mb-2" style="font-size: 24px;">LMS University Library</h1>
                <p class="opacity-90 lh-base" style="font-size: 16px;">
                    Efficiency, clarity, and knowledge at your fingertips.
                </p>
                <div class="mt-4"
                    style="width: 64px; height: 4px; background-color: var(--primary-container); border-radius: 9999px;">
                </div>
            </div>
        </section>

        <section class="w-100 w-md-50 d-flex flex-column" style="background-color: var(--surface-container-lowest);">
            <div class="d-md-none p-4 d-flex justify-content-between align-items-center" style="background-color: var(--surface-container-low);">
                <span class="fw-bold" style="font-size: 20px; color: var(--primary);">LMS Library</span>
            </div>

            <div class="flex-grow-1 d-flex align-items-center justify-content-center px-4 py-5">
                <div class="w-100" style="max-width: 448px;">
                    <div class="mb-4">
                        <h2 class="fw-semibold mb-2" style="font-size: 32px; color: var(--on-surface);">Reset Password</h2>
                        <p class="mb-0" style="font-size: 15px; color: var(--secondary);">Please enter the verification code from Admin and set up your new password.</p>
                    </div>

                    <!-- Hộp cảnh báo lỗi động từ Backend -->
                    <div class="alert alert-danger d-none align-items-center gap-2 mb-3" id="backend-alert" role="alert" 
                         style="border-radius: 12px; font-size: 14.5px; background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                        <div id="backend-error-text"></div>
                    </div>

                    <!-- Form gửi tới servlet xử lý đặt lại mật khẩu -->
                    <form class="d-flex flex-column gap-3" id="resetForm" method="POST" action="${pageContext.request.contextPath}/forgot-password?action=reset">
                        <!-- Trường Email ẩn lấy từ URL -->
                        <input type="hidden" id="email" name="email" value="<c:out value="${param.email}"/>" />

                        <div>
                            <label class="form-label fw-semibold mb-1"
                                style="font-size: 12.5px; color: var(--on-surface-variant);"
                                for="verification-code">Verification Code from Admin</label>
                            <div class="position-relative">
                                <span class="material-symbols-outlined input-icon">verified_user</span>
                                <input class="form-control custom-input" id="verification-code" name="verification-code"
                                    placeholder="Enter temporary code" required type="text" />
                            </div>
                            <p class="d-none text-error" id="code-error">Vui lòng nhập mã xác nhận từ Admin</p>
                        </div>

                        <div>
                            <label class="form-label fw-semibold mb-1"
                                style="font-size: 12.5px; color: var(--on-surface-variant);" for="new-password">New Password</label>
                            <div class="position-relative">
                                <span class="material-symbols-outlined input-icon">lock</span>
                                <input class="form-control custom-input" id="new-password" name="new-password"
                                    placeholder="••••••••" required type="password" />
                            </div>
                            <p class="d-none text-error" id="new-password-error">Mật khẩu phải từ 8 ký tự trở lên, bao gồm chữ và số</p>
                        </div>

                        <div>
                            <label class="form-label fw-semibold mb-1"
                                style="font-size: 12.5px; color: var(--on-surface-variant);"
                                for="confirm-password">Confirm New Password</label>
                            <div class="position-relative">
                                <span class="material-symbols-outlined input-icon">key</span>
                                <input class="form-control custom-input" id="confirm-password" name="confirm-password"
                                    placeholder="••••••••" required type="password" />
                            </div>
                            <p class="d-none text-error" id="confirm-password-error">Xác nhận mật khẩu không khớp</p>
                        </div>

                        <button class="w-100 btn-update mt-2" onclick="submitPasswordForm()" type="button">
                            Update Password
                        </button>
                    </form>

                    <div class="mt-4 text-center">
                        <a class="link-back d-inline-flex align-items-center gap-2" href="${pageContext.request.contextPath}/login">
                            <span class="material-symbols-outlined" style="font-size: 18px;">arrow_back</span>
                            Back to Sign In
                        </a>
                    </div>
                </div>
            </div>

            <footer class="w-100 p-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3"
                style="background-color: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
                <div class="d-flex flex-wrap justify-content-center gap-4">
                    <a class="footer-link" href="#">Need help?</a>
                    <a class="footer-link" href="#">Contact Librarian</a>
                </div>
                <p class="mb-0 text-center text-md-end" style="font-size: 14px; color: var(--on-surface-variant);">
                    © 2024 LMS University Library. All rights reserved.
                </p>
            </footer>
        </section>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Atmosphere: Subtle parallax effect on background image for desktop
        window.addEventListener('mousemove', (e) => {
            const img = document.querySelector('section img');
            if (window.innerWidth >= 768) {
                const moveX = (e.clientX - window.innerWidth / 2) * 0.01;
                const moveY = (e.clientY - window.innerHeight / 2) * 0.01;
                img.style.transform = `scale(1.1) translate(${moveX}px, ${moveY}px)`;
                img.style.transition = 'transform 0.1s ease-out';
            }
        });

        // Đăng ký hiệu ứng xoay spinner
        if (!document.getElementById('spin-effect')) {
            const style = document.createElement('style');
            style.id = 'spin-effect';
            style.innerHTML = '@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }';
            document.head.appendChild(style);
        }

        function submitPasswordForm() {
            const codeInput = document.getElementById('verification-code');
            const newPassInput = document.getElementById('new-password');
            const confirmPassInput = document.getElementById('confirm-password');
            const emailInput = document.getElementById('email');

            const code = codeInput.value.trim();
            const newPass = newPassInput.value;
            const confirmPass = confirmPassInput.value;
            const email = emailInput.value;

            const codeError = document.getElementById('code-error');
            const policyError = document.getElementById('new-password-error');
            const matchError = document.getElementById('confirm-password-error');
            const backendAlert = document.getElementById('backend-alert');

            // Xóa cảnh báo cũ
            backendAlert.classList.add('d-none');

            // Validation Rules
            const isValidCode = code.length > 0;
            const hasLetter = /[a-zA-Z]/.test(newPass);
            const hasNumber = /[0-9]/.test(newPass);
            const isValidPolicy = newPass.length >= 8 && hasLetter && hasNumber;
            const isMatching = newPass === confirmPass && confirmPass !== '';

            // Update UI
            codeError.classList.toggle('d-none', isValidCode);
            policyError.classList.toggle('d-none', isValidPolicy);
            matchError.classList.toggle('d-none', isMatching);

            // Visual feedback on inputs
            codeInput.classList.toggle('ring-error', !isValidCode);
            newPassInput.classList.toggle('ring-error', !isValidPolicy);
            confirmPassInput.classList.toggle('ring-error', !isMatching);

            if (isValidCode && isValidPolicy && isMatching) {
                const btn = document.querySelector('.btn-update');
                const originalText = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = `<div class="d-flex align-items-center justify-content-center gap-2"><span class="material-symbols-outlined spinner-border spinner-border-sm border-0" style="animation: spin 1s linear infinite;">progress_activity</span>Processing...</div>`;

                // Tạo đối tượng dữ liệu gửi lên Servlet
                const params = new URLSearchParams();
                params.append('email', email);
                params.append('tempPassword', code);
                params.append('newPassword', newPass);
                params.append('confirmPassword', confirmPass);

                fetch('${pageContext.request.contextPath}/forgot-password?action=reset', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                    },
                    body: params.toString()
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        btn.innerHTML = `<div class="d-flex align-items-center justify-content-center gap-2"><span class="material-symbols-outlined text-success">check_circle</span>Success</div>`;
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/login?resetSuccess=true';
                        }, 1200);
                    } else {
                        btn.disabled = false;
                        btn.innerHTML = originalText;
                        document.getElementById('backend-error-text').textContent = data.message;
                        backendAlert.classList.remove('d-none');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                    document.getElementById('backend-error-text').textContent = 'Đã xảy ra lỗi kết nối mạng. Vui lòng thử lại.';
                    backendAlert.classList.remove('d-none');
                    console.error('Error:', error);
                });
            }
        }
    </script>
</body>

</html>
