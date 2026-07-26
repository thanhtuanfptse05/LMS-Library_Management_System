<%-- Fragment: _footer.jsp — Footer content + Bootstrap JS for Manager --%>
<style>
    .lms-footer-link {
        color: var(--on-surface-variant);
        text-decoration: none;
        font-size: 13px;
        transition: color 0.2s ease, opacity 0.2s ease;
        opacity: 0.8;
    }
    .lms-footer-link:hover {
        color: var(--primary) !important;
        opacity: 1;
    }
    .lms-footer-sep {
        color: var(--outline-variant);
        font-size: 12px;
        opacity: 0.6;
    }
</style>

<!-- ── Footer ── -->
<footer class="w-100 px-4 py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3"
        style="background-color: var(--surface-container-low); border-top: 1px solid var(--outline-variant); min-height: 56px;">
    <div class="d-flex flex-column flex-md-row align-items-center gap-2">
        <span class="text-on-surface-variant small" style="opacity: 0.7; font-size: 13px;">&copy; 2026 Thư viện Đại học LMS System</span>
    </div>
    <div class="d-flex align-items-center gap-3">
        <a class="lms-footer-link" href="#">Chính sách bảo mật</a>
        <span class="lms-footer-sep">|</span>
        <a class="lms-footer-link" href="#">Điều khoản Dịch vụ</a>
        <span class="lms-footer-sep">|</span>
        <a class="lms-footer-link" href="#">Lưu trữ Báo cáo</a>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
