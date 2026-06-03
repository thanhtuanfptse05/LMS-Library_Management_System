<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Latest News Bento Grid -->
<section class="bg-container-low py-5" id="news">
    <div class="container-xl py-3">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="text-primary-custom fw-bold text-uppercase small">Updates</span>
                <h2 class="fw-bold text-dark mt-1 mb-0">Latest Library News</h2>
            </div>
            <a class="text-primary-custom fw-semibold d-flex align-items-center gap-1 text-decoration-none"
                href="#">
                View all updates <span class="material-symbols-outlined fs-5">arrow_forward</span>
            </a>
        </div>

        <div class="bento-grid">
            <!-- Featured News -->
            <div class="bento-featured bg-white rounded-3 overflow-hidden shadow-sm d-flex flex-column card-hover"
                style="cursor: pointer;">
                <div class="img-hover-zoom" style="height: 256px;">
                    <img alt="Journal Access" class="w-100 h-100 object-fit-cover"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuD3vHmjLEG7w7MqA7Wodbtf-9s-QG8HcK_Onbi3b4CHjAfqqM_a3O_NsGTSX2s-ib09A8vMguplY1JRVqeT_72ah5rBqIh_m4knJyEkUkVGNdKwMSngfLRgXyEn_2jnrAMR4WrJFIhh_zSl6bN7HA1uOQfMWy2rUViATQwdD2I5bUdjZvCs-4liS2vUCBHKb2GLZTdFVHqd4ENNnnXSLJok0K1sb9RcchbD7bsRn29vIIlJ4b5PWCveTCo1JJJZmQoKhKidNSZMvqvk" />
                </div>
                <div class="p-4 d-flex flex-column flex-grow-1">
                    <span class="text-primary-custom fw-semibold small mb-1">Research • Oct 24</span>
                    <h3 class="fw-bold fs-4 mb-2 text-dark">New Digital Journal Subscription for 2024</h3>
                    <p class="text-muted mb-0 flex-grow-1">We are proud to announce full access to over 500 new
                        premium academic journals across medical and engineering fields for all users.</p>
                </div>
            </div>

            <!-- Grid Item 2 -->
            <div class="bento-wide bg-white rounded-3 overflow-hidden shadow-sm d-flex p-4 gap-4 align-items-center card-hover"
                style="cursor: pointer;">
                <div class="img-hover-zoom rounded-3 flex-shrink-0" style="width: 128px; height: 128px;">
                    <img alt="Event" class="w-100 h-100 object-fit-cover"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzhOwY3MmEoh8oMW1xFzwcRHLqWFpW5JdtzBpodWnRVn6dD25RMjwNnR4TtUV4r9YrHbHByG6VR2h-UYnX2jkfHBmzUKkStKMmPiP3V7Of_1uoyA9Xa0S7CjixKWcM7GzAf6ILZE2QuT7f1SkaALKIycnLZ7S3MzzxH8RXQlERxrv4R2muupz1v75TtWiX1OA-pcpvw_iJFiGeyiDdm1M0K_jt3O487MUxjWnxbkCmv2BSI5gGIviHpY7ATAdwKKZePVDchaYL0S0Q" />
                </div>
                <div>
                    <span class="text-primary-custom fw-semibold small">Events • Oct 20</span>
                    <h3 class="fw-bold fs-5 text-dark mb-0 mt-1">Annual Book Fair &amp; Author Talk</h3>
                </div>
            </div>

            <!-- Grid Item 3 -->
            <div class="bg-white rounded-3 shadow-sm p-4 d-flex flex-column" style="cursor: pointer;">
                <span class="material-symbols-outlined text-primary-custom mb-3 display-6">architecture</span>
                <h3 class="fw-bold fs-5 text-dark mb-2">New Quiet Study Pods</h3>
                <p class="small text-muted mb-0">Phase 1 of our renovation is complete with 20 new individual
                    pods.</p>
            </div>

            <!-- Grid Item 4 -->
            <div class="bg-primary-container text-white rounded-3 shadow-sm p-4 d-flex flex-column justify-content-between"
                style="cursor: pointer;">
                <div>
                    <h3 class="fw-bold fs-5 mb-2">Join Our Newsletter</h3>
                    <p class="text-white-50 small mb-0">Stay updated with library news and upcoming workshop
                        dates.</p>
                </div>
                <form action="#" class="d-flex gap-2 mt-4">
                    <input class="form-control form-control-sm border-0 bg-white text-dark" placeholder="Email"
                        type="email" required />
                    <button type="submit" class="btn btn-dark d-flex align-items-center justify-content-center px-2">
                        <span class="material-symbols-outlined fs-6">send</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</section>
