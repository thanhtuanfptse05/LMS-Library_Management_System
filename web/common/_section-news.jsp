<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Latest News Bento Grid -->
<section class="bg-container-low py-5" id="news">
    <div class="container-xl py-3">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">Updates</span>
                <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Latest News & Highlights</h2>
            </div>
            <a class="btn btn-custom-outline d-flex align-items-center gap-1 text-decoration-none px-3 py-2 rounded-pill fw-semibold"
                href="${pageContext.request.contextPath}/news.jsp">
                See More News <span class="material-symbols-outlined fs-5">arrow_forward</span>
            </a>
        </div>

        <div class="row g-4">
            <!-- News Card 1 -->
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card h-100 bg-white border border-outline-variant rounded-3 overflow-hidden shadow-soft card-hover" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="img-hover-zoom" style="height: 200px;">
                        <img alt="Journal Access" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuD3vHmjLEG7w7MqA7Wodbtf-9s-QG8HcK_Onbi3b4CHjAfqqM_a3O_NsGTSX2s-ib09A8vMguplY1JRVqeT_72ah5rBqIh_m4knJyEkUkVGNdKwMSngfLRgXyEn_2jnrAMR4WrJFIhh_zSl6bN7HA1uOQfMWy2rUViATQwdD2I5bUdjZvCs-4liS2vUCBHKb2GLZTdFVHqd4ENNnnXSLJok0K1sb9RcchbD7bsRn29vIIlJ4b5PWCveTCo1JJJZmQoKhKidNSZMvqvk" />
                    </div>
                    <div class="p-4 d-flex flex-column flex-grow-1">
                        <span class="text-primary-custom fw-semibold small mb-1">Research • Oct 24</span>
                        <h4 class="fw-bold text-dark fs-5 mb-2">New Digital Journal Subscription for 2024</h4>
                        <p class="text-muted small mb-0 flex-grow-1">We are proud to announce full access to over 500 new premium academic journals across medical and engineering fields for all users.</p>
                    </div>
                </div>
            </div>

            <!-- News Card 2 -->
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card h-100 bg-white border border-outline-variant rounded-3 overflow-hidden shadow-soft card-hover" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="img-hover-zoom" style="height: 200px;">
                        <img alt="Event" class="w-100 h-100 object-fit-cover"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzhOwY3MmEoh8oMW1xFzwcRHLqWFpW5JdtzBpodWnRVn6dD25RMjwNnR4TtUV4r9YrHbHByG6VR2h-UYnX2jkfHBmzUKkStKMmPiP3V7Of_1uoyA9Xa0S7CjixKWcM7GzAf6ILZE2QuT7f1SkaALKIycnLZ7S3MzzxH8RXQlERxrv4R2muupz1v75TtWiX1OA-pcpvw_iJFiGeyiDdm1M0K_jt3O487MUxjWnxbkCmv2BSI5gGIviHpY7ATAdwKKZePVDchaYL0S0Q" />
                    </div>
                    <div class="p-4 d-flex flex-column flex-grow-1">
                        <span class="text-primary-custom fw-semibold small mb-1">Events • Oct 20</span>
                        <h4 class="fw-bold text-dark fs-5 mb-2">Annual Book Fair &amp; Author Talk</h4>
                        <p class="text-muted small mb-0 flex-grow-1">Join us for the annual University Book Fair, featuring book sales, discount vouchers, and live discussions with popular authors.</p>
                    </div>
                </div>
            </div>

            <!-- News Card 3 -->
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card h-100 bg-white border border-outline-variant rounded-3 overflow-hidden shadow-soft card-hover" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/news.jsp'">
                    <div class="p-4 d-flex flex-column h-100 justify-content-between">
                        <div>
                            <span class="material-symbols-outlined text-primary-custom mb-3" style="font-size: 40px;">architecture</span>
                            <h4 class="fw-bold text-dark fs-5 mb-2">New Quiet Study Pods</h4>
                            <p class="text-muted small mb-0">Phase 1 of our library renovation is complete! Try out our 20 new individual soundproof study pods on the 3rd floor.</p>
                        </div>
                        <div class="mt-4 pt-3 border-top border-outline-variant">
                            <span class="text-primary-custom fw-semibold small">Facilities • Oct 15</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
