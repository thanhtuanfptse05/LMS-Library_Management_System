<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Latest News Section -->
<section class="py-5" style="background-color: var(--surface-container-low);" id="news">
    <div class="container-xl px-4">

        <!-- Section Header -->
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="fw-bold text-uppercase"
                    style="font-size: 12px; letter-spacing: 0.1em; color: var(--primary-color);">Updates</span>
                <h2 class="fw-bold mt-1 mb-0" style="font-size: 32px; color: var(--bs-body-color);">Latest News</h2>
                <p class="mb-0" style="color: var(--text-muted-custom);">Stay updated with research and library events.</p>
            </div>
            <a class="fw-semibold text-decoration-none d-flex align-items-center gap-1"
                style="color: var(--primary-color); white-space: nowrap;"
                href="${pageContext.request.contextPath}/news.jsp">
                View All News <i class="bi bi-arrow-right small"></i>
            </a>
        </div>

        <div class="row g-4 row-cols-1 row-cols-md-3">

            <!-- News Card 1 -->
            <div class="col">
                <div class="card h-100 border-0 shadow-sm overflow-hidden card-hover"
                    style="background-color: var(--surface-lowest); border-radius: 0.75rem; cursor: pointer;"
                    onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="img-hover-zoom" style="height: 192px;">
                        <img alt="Library event" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuAGo9Uw-QmKvCKVC7g3dFXHjfsao_1QHKzwCHOVNre5bMHy0lIw8G1f1LkF3zdxA_FsmCX3iG73zzY0jlvFeSUGS-h3O-7BUP-5_PSQWNrld0oGA19v7AmrKy2sdehcSy6bkgzVv84ywAkY6S5AlVG5mR-Eknlb7WMD3UCDUICyhqBw7xH3sMw7890d3CeBGhrG78zGVdU0Lcm1M7uy7jwnFCeUA56TfJJRKMBifavQ7V7IvcF7riyG4LP_XrLwbgSaGgH3Sl-KDQXH" />
                    </div>
                    <div class="card-body p-4 d-flex flex-column">
                        <span class="fw-medium mb-1" style="font-size: 12px; color: var(--primary-color);">Events • Oct 24, 2023</span>
                        <h4 class="fw-semibold mb-3" style="font-size: 16px;">Annual Research Symposium: Digital Frontiers in Academia</h4>
                        <p class="card-text mb-4 small line-clamp-2" style="color: var(--text-muted-custom);">
                            Join us for a three-day event exploring the future of digital humanities and library science.
                        </p>
                        <a href="${pageContext.request.contextPath}/news.jsp"
                            class="mt-auto align-self-start text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 read-more-link"
                            style="color: var(--primary-color); font-size: 14px;">
                            Read More <i class="bi bi-arrow-right small read-more-icon" style="transition: transform 0.2s;"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- News Card 2 -->
            <div class="col">
                <div class="card h-100 border-0 shadow-sm overflow-hidden card-hover"
                    style="background-color: var(--surface-lowest); border-radius: 0.75rem; cursor: pointer;"
                    onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="img-hover-zoom" style="height: 192px;">
                        <img alt="Archives" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuD5FcFikzAy5-vRo4Z1Q0MgbTFdDtJNmd40Vn-xHEPK50oNshQKYO_BGJfwvVMOKboAtrAGz0xbkNWPgd42b-UHo4cGBJ95f32_oQpMUjW8gXwVIlf9QceIBdgdfqOd0YghKurkap_SahlgZSIjdPWFhqilgow6pn6ZZ7j_hfnkN84R4gUPfdMr3D5FhSUmg3jAgz92wzQyEhGlUhoNk44OYlaA5cc15X31XoyYNZg-bumN1g55Ij4XnUI2Um4r7E7Qp-lLAtsFOdcH" />
                    </div>
                    <div class="card-body p-4 d-flex flex-column">
                        <span class="fw-medium mb-1" style="font-size: 12px; color: var(--primary-color);">Archives • Oct 20, 2023</span>
                        <h4 class="fw-semibold mb-3" style="font-size: 16px;">New Collection: Rare Manuscripts from the 17th Century</h4>
                        <p class="card-text mb-4 small line-clamp-2" style="color: var(--text-muted-custom);">
                            The library has acquired a significant collection of rare scientific manuscripts now available for study.
                        </p>
                        <a href="${pageContext.request.contextPath}/news.jsp"
                            class="mt-auto align-self-start text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 read-more-link"
                            style="color: var(--primary-color); font-size: 14px;">
                            Read More <i class="bi bi-arrow-right small read-more-icon" style="transition: transform 0.2s;"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- News Card 3 -->
            <div class="col">
                <div class="card h-100 border-0 shadow-sm overflow-hidden card-hover"
                    style="background-color: var(--surface-lowest); border-radius: 0.75rem; cursor: pointer;"
                    onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="img-hover-zoom" style="height: 192px;">
                        <img alt="Library study area" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuD3KYeTS9e0HyH7UMD0eSxz9vGBRdmKSa5hfMeExavLNEqqZVF473zeU1-req8wcp-0ipmLUEe90Bk7GbW5gRLjK8AiSJJPm1OALmcV6c8pi_G2smwG4jtsDdTkFshiB2JR1Z8IT_U1tgs-Ggk1shRDiHaJzPZrcTReZQcpr5OUkryw2Ajx4KUhV7ZX4mhYDqI8dbCVvYBkaf9Wf4bBcqn5rcrleMk9KVMZquNtw-_huQh_Ipdo1nZ5LJz0LTLwd6IJgWRnHfPhBW5k" />
                    </div>
                    <div class="card-body p-4 d-flex flex-column">
                        <span class="fw-medium mb-1" style="font-size: 12px; color: var(--primary-color);">Facility • Oct 15, 2023</span>
                        <h4 class="fw-semibold mb-3" style="font-size: 16px;">North Wing Study Pods: New Reservation System</h4>
                        <p class="card-text mb-4 small line-clamp-2" style="color: var(--text-muted-custom);">
                            Students can now reserve the newly refurbished quiet study pods through our mobile dashboard.
                        </p>
                        <a href="${pageContext.request.contextPath}/news.jsp"
                            class="mt-auto align-self-start text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 read-more-link"
                            style="color: var(--primary-color); font-size: 14px;">
                            Read More <i class="bi bi-arrow-right small read-more-icon" style="transition: transform 0.2s;"></i>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<style>
    .read-more-link:hover .read-more-icon { transform: translateX(4px); }
</style>
