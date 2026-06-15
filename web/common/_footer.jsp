<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!-- Footer — 3-column layout + copyright bar -->
<footer id="contact" style="background-color: var(--surface-lowest); border-top: 1px solid rgba(219, 194, 176, 0.5);">

    <!-- ── Main 3-column body ──────────────────────────────────────────── -->
    <div class="container-xl px-4 py-5">
        <div class="row g-5 align-items-start">

            <!-- Column 1 — Logo + Library Name -->
            <div class="col-12 col-md-4">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-book-half" style="font-size: 32px; color: var(--primary-color);"></i>
                    <div class="lh-sm">
                        <span class="fw-bold d-block"
                            style="font-size: 16px; color: var(--primary-color); letter-spacing: -0.01em; line-height: 1.2;">
                            Hệ thống quản lý thư viện<br>Đại học
                        </span>
                        <span class="fw-semibold text-uppercase d-block"
                            style="font-size: 10px; letter-spacing: 0.08em; color: var(--text-muted-custom);">
                            UniLib LMS
                        </span>
                    </div>
                </div>
                <p class="mb-3" style="color: var(--text-muted-custom); font-size: 14px; line-height: 1.7; max-width: 280px;">
                    Cung cấp quyền truy cập thông tin đẳng cấp thế giới cho cộng đồng học thuật. Cổng kết nối tri thức của bạn từ năm 1954.
                </p>
                <!-- Quick policy links -->
                <div class="d-flex flex-wrap gap-3" style="font-size: 13px;">
                    <a class="text-decoration-none" style="color: var(--text-muted-custom);" href="#">Chính sách bảo mật</a>
                    <a class="text-decoration-none" style="color: var(--text-muted-custom);" href="#">Điều khoản sử dụng</a>
                    <a class="text-decoration-none" style="color: var(--text-muted-custom);" href="#">Câu hỏi thường gặp</a>
                </div>
            </div>

            <!-- Column 2 — Contact Information -->
            <div class="col-12 col-md-4">
                <h5 class="fw-bold mb-3" style="font-size: 15px; color: var(--bs-body-color);">Liên hệ với chúng tôi</h5>
                <ul class="list-unstyled mb-0 d-flex flex-column gap-3" style="font-size: 14px; color: var(--text-muted-custom);">
                    <li class="d-flex align-items-start gap-2">
                        <i class="bi bi-geo-alt-fill mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                        <span>123 Academic Row, Knowledge City, EDU 4567</span>
                    </li>
                    <li class="d-flex align-items-center gap-2">
                        <i class="bi bi-telephone-fill flex-shrink-0" style="color: var(--primary-color);"></i>
                        <a href="tel:+84123456789" class="text-decoration-none" style="color: var(--text-muted-custom);">
                            +84 (0) 123 456 789
                        </a>
                    </li>
                    <li class="d-flex align-items-center gap-2">
                        <i class="bi bi-envelope-fill flex-shrink-0" style="color: var(--primary-color);"></i>
                        <a href="mailto:library@unilib.edu.vn" class="text-decoration-none" style="color: var(--text-muted-custom);">
                            library@unilib.edu.vn
                        </a>
                    </li>
                    <li class="d-flex align-items-center gap-2">
                        <i class="bi bi-clock-fill flex-shrink-0" style="color: var(--primary-color);"></i>
                        <span>Thứ Hai – Thứ Bảy: 08:00 AM – 08:00 PM</span>
                    </li>
                    <li class="d-flex align-items-center gap-2">
                        <i class="bi bi-person-badge-fill flex-shrink-0" style="color: var(--primary-color);"></i>
                        <a href="${pageContext.request.contextPath}/login"
                            class="fw-semibold text-decoration-none"
                            style="color: var(--primary-color);">Đăng nhập Nhân viên</a>
                    </li>
                </ul>
            </div>

            <!-- Column 3 — Connect & Links -->
            <div class="col-12 col-md-4">
                <h5 class="fw-bold mb-3" style="font-size: 15px; color: var(--bs-body-color);">Kết nối</h5>
                <!-- Social icons -->
                <div class="d-flex gap-3 mb-4">
                    <a href="#" class="footer-social-icon" title="Facebook">
                        <i class="bi bi-facebook"></i>
                    </a>
                    <a href="#" class="footer-social-icon" title="YouTube">
                        <i class="bi bi-youtube"></i>
                    </a>
                    <a href="#" class="footer-social-icon" title="Email">
                        <i class="bi bi-envelope"></i>
                    </a>
                    <a href="#" class="footer-social-icon" title="Website">
                        <i class="bi bi-globe2"></i>
                    </a>
                </div>
                <!-- Quick navigation -->
                <h6 class="fw-bold mb-2" style="font-size: 13px; color: var(--bs-body-color); text-transform: uppercase; letter-spacing: 0.06em;">Liên kết nhanh</h6>
                <ul class="list-unstyled mb-0 d-flex flex-column gap-2" style="font-size: 14px;">
                    <li>
                        <a href="${pageContext.request.contextPath}/"
                            class="text-decoration-none d-flex align-items-center gap-1 footer-nav-link">
                            <i class="bi bi-chevron-right" style="font-size: 11px;"></i> Trang chủ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/book-search"
                            class="text-decoration-none d-flex align-items-center gap-1 footer-nav-link">
                            <i class="bi bi-chevron-right" style="font-size: 11px;"></i> Tra cứu mục lục
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/services.jsp"
                            class="text-decoration-none d-flex align-items-center gap-1 footer-nav-link">
                            <i class="bi bi-chevron-right" style="font-size: 11px;"></i> Dịch vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/policies.jsp"
                            class="text-decoration-none d-flex align-items-center gap-1 footer-nav-link">
                            <i class="bi bi-chevron-right" style="font-size: 11px;"></i> Chính sách
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/news.jsp"
                            class="text-decoration-none d-flex align-items-center gap-1 footer-nav-link">
                            <i class="bi bi-chevron-right" style="font-size: 11px;"></i> Tin tức &amp; Sự kiện
                        </a>
                    </li>
                </ul>
            </div>

        </div>
    </div>

    <!-- ── Copyright Bar ────────────────────────────────────────────────── -->
    <div style="background-color: var(--primary-color); padding: 14px 0;">
        <div class="container-xl px-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <p class="mb-0 fw-medium" style="font-size: 13px; color: rgba(255,255,255,0.85);">
                &copy; 2026 Hệ thống Quản lý Thư viện Đại học. Bảo lưu mọi quyền.
            </p>
            <div class="d-flex align-items-center gap-1" style="font-size: 13px; color: rgba(255,255,255,0.7);">
                <i class="bi bi-heart-fill" style="font-size: 11px; color: rgba(255,220,195,0.9);"></i>
                Xây dựng vì sự xuất sắc trong học thuật
            </div>
        </div>
    </div>
</footer>

<style>
    .footer-social-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 38px;
        height: 38px;
        border-radius: 50%;
        background-color: var(--surface-container-low);
        color: var(--primary-color);
        font-size: 16px;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    .footer-social-icon:hover {
        background-color: var(--primary-color);
        color: #fff;
        transform: translateY(-2px);
    }

    .footer-nav-link {
        color: var(--text-muted-custom);
        transition: color 0.2s;
    }

    .footer-nav-link:hover {
        color: var(--primary-color);
    }
</style>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ── Sticky Header shadow ──────────────────────────────────────────────────
    window.addEventListener('scroll', () => {
        const header = document.getElementById('main-header');
        if (header) {
            if (window.scrollY > 20) {
                header.classList.add('shadow');
                header.classList.remove('shadow-sm');
            } else {
                header.classList.add('shadow-sm');
                header.classList.remove('shadow');
            }
        }
    });

    // ── Scroll-fade entrance animation ────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', () => {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.shortcut-card, .card.card-hover, h2').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(32px)';
            el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
            observer.observe(el);
        });
    });

    // ── Policy / Service tab switching ────────────────────────────────────────
    function switchPolicyTab(event, paneId) {
        const container = event.currentTarget.closest('.policy-container');
        if (!container) return;
        container.querySelectorAll('.policy-btn').forEach(btn => btn.classList.remove('active'));
        container.querySelectorAll('.policy-pane').forEach(pane => pane.classList.remove('active'));
        event.currentTarget.classList.add('active');
        const targetPane = container.querySelector('#' + paneId);
        if (targetPane) {
            targetPane.classList.add('active');
            const contentArea = container.querySelector('.policy-content');
            if (contentArea) contentArea.scrollTop = 0;
        }
    }

    function switchServiceTab(event, paneId) {
        switchPolicyTab(event, paneId);
    }

    function switchNewsCategory(event, paneId) {
        const container = event.currentTarget.closest('#news');
        if (!container) return;
        container.querySelectorAll('.news-category-btn').forEach(btn => btn.classList.remove('active'));
        container.querySelectorAll('.news-pane').forEach(pane => pane.classList.remove('active'));
        event.currentTarget.classList.add('active');
        const targetPane = container.querySelector('#' + paneId);
        if (targetPane) targetPane.classList.add('active');
    }
</script>
