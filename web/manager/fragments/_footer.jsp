<%-- Fragment: _footer.jsp — Footer content + Bootstrap JS for Manager --%>
<!-- ── Footer ── -->
<footer class="w-100 px-4 py-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3"
        style="background-color: var(--surface-container-low); border-top: 1px solid var(--outline-variant);">
    <div class="d-flex flex-column flex-md-row align-items-center gap-4">
        <span class="text-on-surface-variant small">&copy; 2026 Thư viện Đại học LMS System</span>
        <div class="d-flex gap-3">
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Chính sách bảo mật</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Điều khoản Dịch vụ</a>
            <a class="text-on-surface-variant small text-decoration-underline" href="#">Lưu trữ Báo cáo</a>
        </div>
    </div>
    <div class="d-flex align-items-center gap-3">
        <p class="text-on-surface-variant small mb-0">Xuất dữ liệu:</p>
        <a href="${pageContext.request.contextPath}/manager/reports/dashboard" class="btn btn-sm px-3 rounded-3 text-decoration-none"
           style="background-color: var(--primary); color: #fff;">
            <span class="material-symbols-outlined" style="font-size: 15px;">download</span> Báo cáo Hàng tháng
        </a>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
