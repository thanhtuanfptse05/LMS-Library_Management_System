<%-- Fragment: _footer.jsp — Footer content + Bootstrap JS + page scripts --%>
<!-- ── Footer ── -->
<footer class="w-100 px-4 py-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3 bg-surface-container"
        style="border-top: 1px solid var(--outline-variant);">
    <div class="d-flex flex-column flex-md-row align-items-center gap-4">
        <span class="text-secondary small">&copy; 2024 LMS University Library System</span>
        <div class="d-flex gap-3">
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Privacy Policy</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Terms of Service</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Accessibility</a>
        </div>
    </div>
    <div class="d-flex align-items-center gap-3">
        <p class="text-on-surface-variant small mb-0">Questions?</p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn btn-sm px-3 rounded-3 text-decoration-none"
           style="background-color: var(--on-surface-variant); color: #fff;">
            Contact Support
        </a>
    </div>
</footer>
