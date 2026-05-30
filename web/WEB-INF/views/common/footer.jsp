<%-- 
    footer.jsp — Common Footer + Scripts
    Included by all pages via <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
    
    Contains: Footer content, copyright bar, JavaScript imports
    Closes: </body></html>
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- ==================== FOOTER ==================== --%>
<footer class="main-footer">
    <div class="footer-grid">

        <%-- Column 1: Brand Info --%>
        <div class="footer-brand">
            <div class="footer-brand__logo">
                <span class="material-symbols-outlined footer-brand__icon">local_library</span>
                <span class="footer-brand__name">Smart LMS</span>
            </div>
            <p class="footer-brand__desc">
                A digital sanctuary for deep focus and seamless resource discovery. Empowering the modern university community.
            </p>
        </div>

        <%-- Column 2: Quick Links --%>
        <div>
            <h5 class="footer-heading">Quick Links</h5>
            <ul class="footer-links">
                <li><a class="footer-link" href="#">Digital Archive</a></li>
                <li><a class="footer-link" href="#">Study Room Booking</a></li>
                <li><a class="footer-link" href="#">Course Reserves</a></li>
                <li><a class="footer-link" href="#">Research Help</a></li>
            </ul>
        </div>

        <%-- Column 3: Follow Us --%>
        <div>
            <h5 class="footer-heading">Follow Us</h5>
            <div class="footer-social">
                <a class="social-link" href="#" aria-label="Website">
                    <span class="material-symbols-outlined">public</span>
                </a>
                <a class="social-link" href="#" aria-label="Email">
                    <span class="material-symbols-outlined">alternate_email</span>
                </a>
                <a class="social-link" href="#" aria-label="Share">
                    <span class="material-symbols-outlined">share</span>
                </a>
            </div>
        </div>

        <%-- Column 4: Newsletter --%>
        <div>
            <h5 class="footer-heading">Newsletter</h5>
            <p class="footer-newsletter__desc">Get the latest library updates in your inbox.</p>
            <div class="footer-newsletter__input">
                <input class="footer-newsletter__field" type="email" placeholder="Your email" aria-label="Email for newsletter"/>
                <button class="footer-newsletter__btn" type="button">Join</button>
            </div>
        </div>

    </div>

    <%-- Copyright Bar --%>
    <div class="footer-bottom">
        <div class="footer-bottom__inner">
            <p class="footer-bottom__copyright">&copy; 2024 Smart Library Management System. Intellectual Sanctuary.</p>
            <div class="footer-bottom__links">
                <a class="footer-bottom__link" href="#">Privacy Policy</a>
                <a class="footer-bottom__link" href="#">Terms of Service</a>
                <a class="footer-bottom__link" href="#">Accessibility</a>
            </div>
        </div>
    </div>
</footer>

<%-- ==================== SCRIPTS ==================== --%>
<script src="<c:url value='/assets/js/main.js'/>"></script>

</body>
</html>
