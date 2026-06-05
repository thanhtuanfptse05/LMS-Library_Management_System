<%-- Fragment: _footer.jsp — Footer content + Bootstrap JS for Librarian --%>
<!-- ── Footer ── -->
<footer class="w-100 px-4 py-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3"
        style="background-color: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
    <div class="d-flex flex-column flex-md-row align-items-center gap-4">
        <span class="text-on-surface-variant small">&copy; 2024 Thư viện Đại học LMS System</span>
        <div class="d-flex gap-3">
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Chính sách bảo mật</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Điều khoản dịch vụ</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Khả năng truy cập</a>
        </div>
    </div>
    <div class="d-flex align-items-center gap-3">
        <p class="text-on-surface-variant small mb-0">Trợ giúp Quầy lưu thông:</p>
        <a href="${pageContext.request.contextPath}/#contact"
           class="btn btn-sm px-3 rounded-3 text-decoration-none"
           style="background-color: var(--on-surface-variant); color: #fff;">Liên hệ Quản trị viên</a>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
