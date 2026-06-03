<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Footer -->
<footer class="bg-container-highest mt-5" id="contact">
    <div class="container-xl py-5">
        <div class="row g-4 align-items-center justify-content-between">
            <div class="col-12 col-md-6 text-center text-md-start">
                <div class="d-flex align-items-center justify-content-center justify-content-md-start gap-2 mb-2">
                    <span class="text-primary-custom material-symbols-outlined fs-3">library_books</span>
                    <span class="fs-4 fw-bold text-primary-custom">UniLib LMS</span>
                </div>
                <p class="text-secondary-custom small mb-3 style-desc-footer" style="max-width: 400px;">
                    Providing world-class information access to the global academic community since 1954.
                </p>
                <p class="small text-muted mb-0">© 2024 University Library Management System. All rights reserved.</p>
            </div>

            <div class="col-12 col-md-6 text-center text-md-end d-flex flex-column align-items-center align-items-md-end gap-3">
                <nav class="d-flex flex-wrap justify-content-center justify-content-md-end gap-3">
                    <a class="text-secondary-custom small text-decoration-underline" href="#">Instructions</a>
                    <a class="text-secondary-custom small text-decoration-underline" href="#">Privacy Policy</a>
                    <a class="text-secondary-custom small text-decoration-underline" href="#">Terms of Service</a>
                    <a class="text-secondary-custom small text-decoration-underline" href="#">FAQ</a>
                    <a class="text-primary-custom small fw-bold text-decoration-none" href="${pageContext.request.contextPath}/login">Staff Login</a>
                </nav>
                <div class="d-flex gap-3">
                    <a class="text-secondary-custom text-decoration-none" href="#"><span
                            class="material-symbols-outlined">public</span></a>
                    <a class="text-secondary-custom text-decoration-none" href="#"><span
                            class="material-symbols-outlined">mail</span></a>
                    <a class="text-secondary-custom text-decoration-none" href="#"><span
                            class="material-symbols-outlined">share</span></a>
                </div>
                <div class="small text-secondary-custom d-flex align-items-center gap-1">
                    <span class="material-symbols-outlined fs-6">location_on</span>
                    123 Academic Row, Knowledge City, EDU 4567
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Sticky Header Shadow effect
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

    // Smooth Scrolling for anchor links with header offset
    const navLinks = document.querySelectorAll('.nav-link-custom');
    navLinks.forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href.startsWith('#')) {
                e.preventDefault();
                
                navLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');

                if (href === '#') {
                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth'
                    });
                } else {
                    const target = document.querySelector(href);
                    if (target) {
                        const headerOffset = 80; // Sticky header height plus margin
                        const elementPosition = target.getBoundingClientRect().top;
                        const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                        window.scrollTo({
                            top: offsetPosition,
                            behavior: 'smooth'
                        });
                    }
                }
            }
        });
    });

    // ScrollSpy: Dynamic navigation active state highlighting
    const sections = document.querySelectorAll('section[id], footer[id]');
    window.addEventListener('scroll', () => {
        let current = '';
        const scrollY = window.pageYOffset;
        const headerHeight = 90; // Trigger offset

        sections.forEach(section => {
            const sectionTop = section.offsetTop - headerHeight;
            const sectionHeight = section.offsetHeight;
            if (scrollY >= sectionTop && scrollY < sectionTop + sectionHeight) {
                current = section.getAttribute('id');
            }
        });

        // Default to Home if near top
        if (scrollY < 100) {
            current = '';
        }

        navLinks.forEach(link => {
            link.classList.remove('active');
            const href = link.getAttribute('href');
            if ((current === '' && href === '#') || href === '#' + current) {
                link.classList.add('active');
            }
        });
    });

    // Scoped tab switching logic for Policies
    function switchPolicyTab(event, paneId) {
        const container = event.currentTarget.closest('.policy-container');
        if (!container) return;

        container.querySelectorAll('.policy-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        container.querySelectorAll('.policy-pane').forEach(pane => {
            pane.classList.remove('active');
        });
        
        event.currentTarget.classList.add('active');
        const targetPane = container.querySelector('#' + paneId);
        if (targetPane) {
            targetPane.classList.add('active');
            const contentArea = container.querySelector('.policy-content');
            if (contentArea) {
                contentArea.scrollTop = 0;
            }
        }
    }

    // Scoped tab switching logic for Services
    function switchServiceTab(event, paneId) {
        const container = event.currentTarget.closest('.policy-container');
        if (!container) return;

        container.querySelectorAll('.policy-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        container.querySelectorAll('.policy-pane').forEach(pane => {
            pane.classList.remove('active');
        });
        
        event.currentTarget.classList.add('active');
        const targetPane = container.querySelector('#' + paneId);
        if (targetPane) {
            targetPane.classList.add('active');
            const contentArea = container.querySelector('.policy-content');
            if (contentArea) {
                contentArea.scrollTop = 0;
            }
        }
    }

    // Scoped tab switching logic for News Categories
    function switchNewsCategory(event, paneId) {
        const container = event.currentTarget.closest('#news');
        if (!container) return;

        container.querySelectorAll('.news-category-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        container.querySelectorAll('.news-pane').forEach(pane => {
            pane.classList.remove('active');
        });
        
        event.currentTarget.classList.add('active');
        const targetPane = container.querySelector('#' + paneId);
        if (targetPane) {
            targetPane.classList.add('active');
        }
    }
</script>
