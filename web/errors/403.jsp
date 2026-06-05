<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Truy cập bị từ chối - Thư viện Đại học LMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #9d4300;
            --primary-container: #f97316;
            --surface: #f7f9fb;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --outline-variant: rgba(224, 192, 177, 0.3);
            --surface-container-lowest: #ffffff;
            --surface-container-low: #f2f4f6;
            --surface-container: #eceef0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--surface);
            color: var(--on-surface);
            min-height: 100vh;
        }

        .bg-pattern {
            background-image: radial-gradient(#e0c0b1 0.5px, transparent 0.5px);
            background-size: 24px 24px;
        }

        /* Custom Styles để giữ nguyên thiết kế tinh tế ban đầu */
        .header-nav-link {
            color: var(--on-surface-variant);
            text-decoration: none;
            font-weight: 400;
            transition: color 0.2s ease;
        }

        .header-nav-link:hover {
            color: var(--primary);
        }

        .icon-btn {
            color: var(--primary);
            background: none;
            border: none;
            transition: transform 0.2s, opacity 0.2s;
            text-decoration: none;
        }

        .icon-btn:active {
            transform: scale(0.95);
            opacity: 0.8;
        }

        .blur-bg-effect {
            position: absolute;
            inset: 0;
            background-color: rgba(157, 67, 0, 0.1);
            border-radius: 50%;
            filter: blur(48px);
            transform: scale(1.5);
        }

        .illustration-circle {
            position: relative;
            width: 160px;
            height: 160px;
            background-color: var(--surface-container-lowest);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--outline-variant);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: transform 0.1s ease-out;
        }

        @media (min-width: 768px) {
            .illustration-circle {
                width: 192px;
                height: 192px;
            }
        }

        .error-card {
            z-index: 10;
            background-color: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(224, 192, 177, 0.2);
        }

        .btn-primary-custom {
            background-color: var(--primary-container);
            color: white;
            font-weight: 700;
            border: none;
            transition: transform 0.2s, opacity 0.2s;
        }

        .btn-primary-custom:hover {
            transform: scale(1.05);
            color: white;
            background-color: #ea580c;
        }

        .btn-primary-custom:active {
            opacity: 0.9;
        }

        .btn-secondary-custom {
            color: #565e74;
            font-weight: 600;
            border: 1px solid rgba(224, 192, 177, 0.5);
            transition: background-color 0.2s;
        }

        .btn-secondary-custom:hover {
            background-color: #e6e8ea;
            color: #565e74;
        }

        .info-box {
            background-color: var(--surface-container-low);
            border: 1px solid rgba(224, 192, 177, 0.1);
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

    <c:choose>
        <c:when test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'admin'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/dashboard" />
        </c:when>
        <c:when test="${sessionScope.role eq 'LIBRARIAN' or sessionScope.role eq 'librarian'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/librarian/dashboard" />
        </c:when>
        <c:when test="${sessionScope.role eq 'MANAGER' or sessionScope.role eq 'manager'}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/manager/dashboard" />
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

    <header class="fixed-top bg-white border-bottom shadow-sm">
        <div class="container-xl d-flex justify-content-between align-items-center" style="height: 64px;">
            <div class="d-flex align-items-center gap-4">
                <a href="${pageContext.request.contextPath}/" class="h5 mb-0 fw-bold text-decoration-none" style="color: var(--primary);">Thư viện Đại học LMS</a>
                <nav class="d-none d-md-flex gap-4">
                    <a class="header-nav-link" href="${dashboardUrl}">Bảng điều khiển</a>
                    <a class="header-nav-link" href="${pageContext.request.contextPath}/book-search.jsp">Mục lục</a>
                    <a class="header-nav-link" href="${pageContext.request.contextPath}/services.jsp">Dịch vụ</a>
                    <a class="header-nav-link" href="${pageContext.request.contextPath}/policies.jsp">Chính sách</a>
                    <a class="header-nav-link" href="${pageContext.request.contextPath}/#contact">Hỗ trợ</a>
                </nav>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/#contact" class="icon-btn fs-4" title="Trợ giúp"><i class="bi bi-question-circle"></i></a>
                <a href="${dashboardUrl}" class="icon-btn fs-4" title="Tài khoản"><i class="bi bi-person-circle"></i></a>
            </div>
        </div>
    </header>

    <main class="flex-grow-1 bg-pattern" style="padding-top: 128px; padding-bottom: 48px;">
        <div class="container" style="max-width: 896px;">
            <div class="d-flex flex-column align-items-center text-center">

                <div class="position-relative mb-4">
                    <div class="blur-bg-effect"></div>
                    <div class="illustration-circle" id="interactive-container">
                        <style>
                            .illustration-circle i {
                                font-size: 64px;
                                color: var(--primary);
                            }

                            @media (min-width: 768px) {
                                .illustration-circle i {
                                    font-size: 96px;
                                }
                            }
                        </style>
                        <i class="bi bi-shield-exclamation"></i>
                    </div>
                </div>

                <div class="error-card p-4 p-md-5 rounded-4 shadow-sm mb-4 w-100">
                    <h2 class="fw-bold text-dark mb-1" style="font-size: 32px;">Truy cập Bị từ chối</h2>
                    <h3 class="h5 mb-4" style="color: var(--primary); font-weight: 600;">Bạn không có quyền truy cập trang này.</h3>
                    <p class="mx-auto text-muted mb-4" style="max-width: 576px; font-size: 18px; color: var(--on-surface-variant) !important;">
                        Trang bạn đang cố truy cập bị giới hạn đối với quản trị viên hoặc các vai trò cụ thể. Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ bộ phận hỗ trợ kỹ thuật của thư viện.
                    </p>

                    <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center align-items-center">
                        <a class="btn btn-primary-custom px-4 py-2.5 rounded-3 d-inline-flex align-items-center gap-2 text-decoration-none" href="${dashboardUrl}">
                            <i class="bi bi-house-door-fill"></i> Quay lại Bảng điều khiển
                        </a>
                        <a class="btn btn-secondary-custom px-4 py-2.5 rounded-3 d-inline-flex align-items-center gap-2 text-decoration-none" href="${pageContext.request.contextPath}/login">
                            <i class="bi bi-person-exclamation"></i> Đăng nhập bằng tài khoản khác
                        </a>
                    </div>
                </div>

                <div class="row g-4 text-start w-100">
                    <div class="col-12 col-md-4">
                        <div class="info-box p-3 rounded-3 h-100">
                            <i class="bi bi-headset d-block mb-2 fs-4" style="color: var(--primary);"></i>
                            <h4 class="text-uppercase fw-bold mb-1" style="font-size: 12px; letter-spacing: 0.05em;">CẦN HỖ TRỢ?</h4>
                            <p class="text-muted mb-0" style="font-size: 14px;">Liên hệ đội ngũ IT qua Chat Trực tuyến hoặc Hotline 1900-xxxx.</p>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="info-box p-3 rounded-3 h-100">
                            <i class="bi bi-journal-check d-block mb-2 fs-4" style="color: var(--primary);"></i>
                            <h4 class="text-uppercase fw-bold mb-1" style="font-size: 12px; letter-spacing: 0.05em;">CHÍNH SÁCH</h4>
                            <p class="text-muted mb-0" style="font-size: 14px;">Xem các quy định về quyền truy cập vào tài nguyên số của thư viện.</p>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="info-box p-3 rounded-3 h-100">
                            <i class="bi bi-shield-lock d-block mb-2 fs-4" style="color: var(--primary);"></i>
                            <h4 class="text-uppercase fw-bold mb-1" style="font-size: 12px; letter-spacing: 0.05em;">BẢO MẬT</h4>
                            <p class="text-muted mb-0" style="font-size: 14px;">Tài khoản của bạn vẫn an toàn. Đây chỉ là thông báo hạn chế truy cập.</p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <footer class="w-100 px-4 mt-auto py-4 border-t" style="background-color: var(--surface-container); border-top: 1px solid rgba(224, 192, 177, 0.5);">
        <div class="container-xl d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div class="text-center text-md-start">
                <span class="text-uppercase text-secondary d-block mb-1 tracking-wider" style="font-size: 12px; font-weight: 600;">Hệ thống Thư viện Đại học LMS</span>
                <p class="text-muted mb-0" style="font-size: 14px;">&copy; 2024 Thư viện Đại học LMS</p>
            </div>
            <div class="d-flex flex-wrap justify-content-center gap-4">
                <a class="text-muted text-decoration-underline" style="font-size: 14px;" href="#">Chính sách bảo mật</a>
                <a class="text-muted text-decoration-underline" style="font-size: 14px;" href="#">Điều khoản Dịch vụ</a>
                <a class="text-muted text-decoration-underline" style="font-size: 14px;" href="#">Trợ năng</a>
                <a class="text-muted text-decoration-underline" style="font-size: 14px;" href="${pageContext.request.contextPath}/#contact">Liên hệ Hỗ trợ</a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Giữ nguyên hiệu ứng micro-interaction di chuyển nhẹ theo chuột cho Icon
        const interactiveContainer = document.getElementById('interactive-container');
        if (interactiveContainer) {
            document.addEventListener('mousemove', (e) => {
                const xAxis = (window.innerWidth / 2 - e.pageX) / 50;
                const yAxis = (window.innerHeight / 2 - e.pageY) / 50;
                interactiveContainer.style.transform = `rotateY(${xAxis}deg) rotateX(${yAxis}deg)`;
            });
        }
    </script>
</body>

</html>
