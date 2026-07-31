<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>500 - Lỗi Máy chủ Nội bộ | Thư viện Đại học LMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <%-- Font icon ligature: bắt buộc display=block. Dùng swap sẽ lòi chữ nguồn ("menu_book") ra màn hình. --%>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=block" rel="stylesheet" />

    <style>
        /* Custom Variables mapped from original tailwind config */
        :root {
            --bs-body-font-family: 'Inter', sans-serif;
            --primary-color: #9d4300;
            --primary-container: #f97316;
            --on-primary-container: #582200;
            --surface: #f7f9fb;
            --surface-container: #eceef0;
            --surface-container-high: #e6e8ea;
            --surface-container-lowest: #ffffff;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --outline-variant: #e0c0b1;
            --error-container: #ffdad6;
            --on-error-container: #93000a;
            --secondary: #565e74;
        }

        body {
            background-color: var(--surface);
            color: var(--on-surface);
            min-height: 100vh;
        }

        .text-primary-custom {
            color: var(--primary-color);
        }

        .bg-primary-container {
            background-color: var(--primary-container);
            color: var(--on-primary-container);
        }

        .text-on-surface-variant {
            color: var(--on-surface-variant);
        }

        .bg-surface-container-lowest {
            background-color: var(--surface-container-lowest);
        }

        .bg-surface-container {
            background-color: var(--surface-container);
        }

        .bg-error-container {
            background-color: var(--error-container);
            color: var(--on-error-container);
        }

        /* Material Icons Customization */
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

        /* Hover Effects */
        .hover-primary:hover {
            color: var(--primary-color) !important;
        }

        .hover-bg-high:hover {
            background-color: var(--surface-container-high) !important;
        }

        .btn-custom-primary {
            background-color: var(--primary-container);
            color: var(--on-primary-container);
            border: none;
            transition: all 0.2s ease-in-out;
        }

        .btn-custom-primary:hover {
            transform: scale(1.02);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            background-color: var(--primary-container);
            color: var(--on-primary-container);
        }

        .btn-custom-primary:active {
            transform: scale(0.95);
        }

        .btn-custom-outline {
            border: 1px solid var(--outline-variant);
            color: var(--primary-color);
            background: transparent;
            transition: all 0.2s ease-in-out;
        }

        .btn-custom-outline:hover {
            background-color: var(--surface-container-high);
            color: var(--primary-color);
            border-color: var(--outline-variant);
        }

        /* Error Glow and Glow Background */
        .error-card-glow {
            box-shadow: 0 15px 45px -10px rgba(157, 67, 0, 0.08);
            border: 1px solid rgba(224, 192, 177, 0.2);
        }

        .glow-bg {
            background-color: rgba(157, 67, 0, 0.05);
            transition: transform 0.1s ease-out;
        }

        /* Typography Customization */
        .display-custom {
            font-size: 48px;
            font-weight: 700;
            letter-spacing: -0.02em;
            line-height: 56px;
        }

        /* Simple entry animation */
        .animate-fade-up {
            animation: fadeUp 0.7s ease-out forwards;
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(16px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body class="d-flex flex-column">

    <c:choose>
        <c:when test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'admin'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
        </c:when>
        <c:when test="${sessionScope.role eq 'LIBRARIAN' or sessionScope.role eq 'librarian'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
        </c:when>
        <c:when test="${sessionScope.role eq 'STUDENT' or sessionScope.role eq 'student'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/student/dashboard" />
        </c:when>
        <c:when test="${sessionScope.role eq 'LECTURER' or sessionScope.role eq 'lecturer'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/lecturer/dashboard" />
        </c:when>
        <c:otherwise>
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/" />
        </c:otherwise>
    </c:choose>

    <header class="fixed-top w-full bg-white border-bottom shadow-sm">
        <div class="container-max mx-auto d-flex justify-content-between align-items-center px-4" style="height: 64px; max-width: 1280px;">
            <a href="${pageContext.request.contextPath}/" class="fs-5 fw-bold text-primary-custom text-decoration-none">Thư viện Đại học LMS</a>
            <div class="d-flex gap-3">
                <a href="${pageContext.request.contextPath}/#contact" class="btn p-0 border-0 material-symbols-outlined text-on-surface-variant hover-primary transition-colors text-decoration-none">help</a>
                <a href="${dashboardUrl}" class="btn p-0 border-0 material-symbols-outlined text-on-surface-variant hover-primary transition-colors text-decoration-none">settings</a>
            </div>
        </div>
    </header>

    <main class="flex-grow-1 d-flex align-items-center justify-content-center px-4" style="padding-top: 80px; padding-bottom: 40px;">
        <div class="w-100 text-center animate-fade-up" style="max-width: 42rem;">

            <div class="position-relative d-flex justify-content-center mb-4">
                <div class="position-absolute top-50 start-50 translate-middle rounded-circle glow-bg" style="width: 280px; height: 280px; filter: blur(40px); transform: scale(1.5);"></div>
                <div class="position-relative bg-surface-container-lowest rounded-circle d-flex align-items-center justify-content-center error-card-glow overflow-hidden" style="width: 220px; height: 220px;">
                    <img alt="Academic Library Interior" class="position-absolute top-0 start-0 w-100 h-100 object-fit-cover opacity-10 grayscale" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCyuQzDs6MmxOj8BTJ9I_Qlv8Es4sgudOwW-3VsRXv_ogB2WEntcb3izGDmfGPRIIUOEx0dgRI9ARt45G3VTj79GzMNTCCkpre7VJ5mHkXuP-N7kuFiH6ZfeusKjtc-0b-93UTh8OhpvlNNaK8ktQYbPSUxt-tlKA8gIpNjXa8ZDuUD6W-1mgGt3Mf1qPn8skrMxEMJnpTTOeM-BB5BRFARZtsE97wRWCNJYBZAhvKokqZidKTHitTjinJe32HcRKx7PtN1kN-TWAuw" />
                    <span class="material-symbols-outlined text-primary-custom opacity-90" style="font-size: 100px; font-variation-settings: 'wght' 300;">clinical_notes</span>
                </div>
            </div>

            <div class="mb-4">
                <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill bg-error-container mb-3" style="font-size: 12px; font-weight: 600; letter-spacing: 0.05em;">
                    <span class="material-symbols-outlined" style="font-size: 14px;">error</span>
                    <span>HỆ THỐNG BỊ GIÁN ĐOẠN (500)</span>
                </div>
                <h1 class="display-custom text-dark mb-3">Lỗi Máy chủ Nội bộ.</h1>
                <p class="fs-5 text-on-surface-variant mx-auto" style="max-width: 32rem;">Chúng tôi đang nỗ lực khắc phục sự cố này. Vui lòng thử lại sau hoặc liên hệ quản trị viên nếu sự cố vẫn tiếp diễn.</p>
            </div>

            <div class="row g-3 justify-content-center pt-2 mb-4">
                <div class="col-12 col-md-auto">
                    <button class="btn btn-custom-primary px-4 py-2 fw-bold rounded-3 w-100 d-inline-flex align-items-center justify-content-center gap-2" style="height: 48px;" onclick="window.location.reload()">
                        <span class="material-symbols-outlined">refresh</span>Tải lại trang
                    </button>
                </div>
                <div class="col-12 col-md-auto">
                    <a class="btn btn-custom-outline px-4 py-2 fw-semibold rounded-3 w-100 d-inline-flex align-items-center justify-content-center gap-2 text-decoration-none" style="height: 48px;" href="${dashboardUrl}">
                        <span class="material-symbols-outlined">home</span>Quay lại Trang chủ
                    </a>
                </div>
            </div>

            <!-- Collapsible technical details for developers/debugging in Servlet container -->
            <c:if test="${not empty requestScope['jakarta.servlet.error.exception'] or not empty requestScope['jakarta.servlet.error.message']}">
                <div class="mt-4 text-start mx-auto border rounded-3 p-3" style="max-width: 32rem; background-color: var(--surface-container-high); border-color: var(--outline-variant) !important;">
                    <button class="btn btn-sm btn-link p-0 text-decoration-none text-dark fw-bold d-flex align-items-center gap-1" type="button" data-bs-toggle="collapse" data-bs-target="#errorDetails" aria-expanded="false" aria-controls="errorDetails">
                        <span class="material-symbols-outlined" style="font-size: 16px;">code</span> Chi tiết Kỹ thuật (Debug)
                    </button>
                    <div class="collapse mt-2" id="errorDetails">
                        <div class="p-2 bg-white rounded border font-monospace text-danger small overflow-auto" style="max-height: 150px; font-size: 12px; white-space: pre-wrap;">
                            <c:if test="${not empty requestScope['jakarta.servlet.error.status_code']}"><strong>Mã Trạng thái:</strong> <c:out value="${requestScope['jakarta.servlet.error.status_code']}" /><br/></c:if>
                            <c:if test="${not empty requestScope['jakarta.servlet.error.message']}"><strong>Tin nhắn:</strong> <c:out value="${requestScope['jakarta.servlet.error.message']}" /><br/></c:if>
                            <c:if test="${not empty requestScope['jakarta.servlet.error.request_uri']}"><strong>URI Yêu cầu:</strong> <c:out value="${requestScope['jakarta.servlet.error.request_uri']}" /><br/></c:if>
                            <c:if test="${not empty requestScope['jakarta.servlet.error.servlet_name']}"><strong>Tên Servlet:</strong> <c:out value="${requestScope['jakarta.servlet.error.servlet_name']}" /><br/></c:if>
                            <c:if test="${not empty requestScope['jakarta.servlet.error.exception']}">
                                <strong>Ngoại lệ:</strong> <span class="text-secondary"><c:out value="${requestScope['jakarta.servlet.error.exception']}" /></span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>

            <p class="text-on-surface-variant opacity-75 mt-4 small fst-italic">Cảm ơn bạn đã kiên nhẫn. Bảo mật và dữ liệu của bạn luôn là ưu tiên hàng đầu của chúng tôi.</p>
        </div>
    </main>

    <footer class="w-100 px-4 mt-auto bg-surface-container py-4 border-top">
        <div class="container-max mx-auto d-flex flex-column flex-md-row justify-content-between align-items-center gap-3" style="max-width: 1280px;">
            <div class="small fw-semibold text-muted">© 2026 Thư viện Đại học LMS System</div>
            <div class="d-flex flex-wrap justify-content-center gap-4">
                <a class="small text-on-surface-variant hover-primary text-decoration-underline opacity-90" href="#">Chính sách bảo mật</a>
                <a class="small text-on-surface-variant hover-primary text-decoration-underline opacity-90" href="#">Điều khoản Dịch vụ</a>
                <a class="small text-on-surface-variant hover-primary text-decoration-underline opacity-90" href="#">Trợ năng</a>
                <a class="small text-on-surface-variant hover-primary text-decoration-underline opacity-90" href="${pageContext.request.contextPath}/#contact">Liên hệ Hỗ trợ</a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Micro-interaction for the reload button
        const reloadBtn = document.querySelector('button[onclick="window.location.reload()"]');
        if (reloadBtn) {
            reloadBtn.addEventListener('click', function (e) {
                const icon = this.querySelector('.material-symbols-outlined');
                icon.classList.add('spin-animation');

                // Injecting basic keyframe dynamically for spin icon
                if (!document.getElementById('spin-styles')) {
                    const style = document.createElement('style');
                    style.id = 'spin-styles';
                    style.innerHTML = `@keyframes spin { to { transform: rotate(360deg); } } .spin-animation { animation: spin 1s linear infinite; }`;
                    document.head.appendChild(style);
                }

                setTimeout(() => {
                    icon.classList.remove('spin-animation');
                }, 1000);
            });
        }

        // Atmospheric effect: subtle mouse tracking on the glow background
        document.addEventListener('mousemove', (e) => {
            const glow = document.querySelector('.glow-bg');
            if (glow) {
                const x = (e.clientX / window.innerWidth - 0.5) * 40;
                const y = (e.clientY / window.innerHeight - 0.5) * 40;
                glow.style.transform = `translate(calc(-50% + ${x}px), calc(-50% + ${y}px)) scale(1.5)`;
            }
        });
    </script>
</body>

</html>
