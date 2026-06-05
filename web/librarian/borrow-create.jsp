<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <%-- ════════════════ BODY WRAPPER ════════════════ --%>
    <div class="d-flex main-wrapper overflow-hidden">

        <%-- ════════════════ MAIN CONTENT ════════════════ --%>
        <main class="flex-grow-1 overflow-y-auto"
              style="background-color: var(--background); margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <%-- ─── Alert Messages ─── --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <%-- ─── Main Layout: Form + Sidebar Summary ─── --%>
                <div class="row">

                    <%-- Main Content Area --%>
                    <div class="col-12 col-lg-8">

                        <%-- Breadcrumb Navigation --%>
                        <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                             aria-label="breadcrumb"
                             style="font-size: 12px; letter-spacing: 0.05em;">
                            <a class="text-decoration-none text-muted link-dark"
                               href="${pageContext.request.contextPath}/librarian/dashboard">Bảng điều khiển</a>
                            <span class="material-symbols-outlined fs-6">chevron_right</span>
                            <a class="text-decoration-none text-muted link-dark"
                               href="${pageContext.request.contextPath}/librarian/borrow-list">Mượn trả</a>
                            <span class="material-symbols-outlined fs-6">chevron_right</span>
                            <span class="text-dark">Bản ghi mới</span>
                        </nav>

                        <h1 class="h3 fw-bold mb-4 text-dark">Tạo bản ghi mượn sách mới</h1>

                        <form action="${pageContext.request.contextPath}/librarian/borrow-create"
                              method="post"
                              id="borrow_form">

                            <div class="d-flex flex-column gap-4">
                                <%-- Multi-step form fragment --%>
                                <jsp:include page="fragments/_borrow-create-form.jsp" />
                            </div>

                        </form>
                    </div><%-- /col-lg-8 --%>

                    <%-- Right Sidebar: Summary & Alerts --%>
                    <aside class="col-12 col-lg-4 mt-4 mt-lg-0">
                        <div class="sticky-top" style="top: 1.5rem; z-index: 1020;">
                            <div class="custom-card shadow-sm border-0">
                                <div class="p-4 summary-accent">
                                    <h5 class="mb-0 fw-bold">Tóm tắt giao dịch</h5>
                                </div>
                                <div class="p-4">
                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span class="text-muted">Ngày mượn</span>
                                            <span class="fw-semibold text-dark" id="current_date"></span>
                                        </div>
                                        <div class="p-3 rounded-3 border border-warning-subtle text-center"
                                             style="background-color: #fff8f5;">
                                            <div class="small text-muted text-uppercase fw-bold mb-1" style="font-size: 10px;">Hạn trả</div>
                                            <div class="h3 fw-bold text-primary-custom mb-0" id="due_date"></div>
                                            <div class="small text-dark mt-1 opacity-75">Áp dụng chính sách Sinh viên 14 ngày</div>
                                        </div>
                                    </div>

                                    <div class="d-flex flex-column gap-3 mb-4">
                                        <div class="d-flex align-items-center gap-3 p-2 bg-light rounded-3">
                                            <span class="material-symbols-outlined text-muted">person</span>
                                            <span class="small text-muted flex-grow-1" id="summary_member">Chưa xác minh thành viên</span>
                                        </div>
                                        <div class="d-flex align-items-center gap-3 p-2 bg-light rounded-3">
                                            <span class="material-symbols-outlined text-muted">book</span>
                                            <span class="small text-muted flex-grow-1" id="summary_book">Chưa chọn sách</span>
                                        </div>
                                    </div>

                                    <%-- Alerts/Fines Section --%>
                                    <div class="mb-4" id="active_alerts">
                                        <div class="alert alert-lumina p-3 mb-0 d-flex align-items-start gap-2">
                                            <span class="material-symbols-outlined">warning</span>
                                            <div>
                                                <div class="fw-bold small mb-1">Cảnh báo hoạt động</div>
                                                <p class="small mb-0 opacity-75">
                                                    Không phát hiện khoản phạt chưa thanh toán hoặc mục quá hạn nào cho tài khoản này.
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <button class="btn btn-primary-lumina w-100 py-3 fs-5 d-flex align-items-center justify-content-center gap-2"
                                            style="border-radius: 0.75rem;" disabled id="finalize_btn"
                                            form="borrow_form" type="submit">
                                        <span class="material-symbols-outlined">check_circle</span>
                                        Hoàn tất việc mượn
                                    </button>
                                    <p class="text-center text-muted small mt-3">
                                        Hành động được ghi lại cho Thủ thư: <strong><c:out value="${sessionScope.loginUser.userId}" default="LIB-0824" /></strong>
                                    </p>
                                </div>
                            </div>

                            <%-- Station Stats --%>
                            <div class="mt-4 p-3 bg-white rounded-3 border border-light-subtle">
                                <h6 class="text-uppercase text-muted fw-bold mb-3"
                                    style="font-size: 10px; letter-spacing: 0.1em;">Hoạt động trạm</h6>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="small">Lượt mượn hôm nay</span>
                                    <span class="fw-bold text-primary-custom">
                                        <c:out value="${todayLoans != null ? todayLoans : '—'}" />
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="small">Thời gian hoạt động</span>
                                    <span class="font-monospace small text-muted" id="uptime_display">00:00:00</span>
                                </div>
                            </div>
                        </div>
                    </aside>

                </div><%-- /row --%>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Page-specific styles --%>
<style>
    .step-indicator {
        width: 32px; height: 32px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; margin-right: 12px;
    }
    .active-step { border-left: 4px solid var(--primary) !important; }
    .custom-card {
        border: 1px solid rgba(140, 113, 100, 0.1);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        border-radius: 0.75rem; background: #ffffff; overflow: hidden;
    }
    .btn-primary-lumina {
        background-color: var(--primary); color: white; border: none;
        font-weight: 600; transition: all 0.2s;
    }
    .btn-primary-lumina:hover { background-color: #783200; color: white; }
    .btn-primary-lumina:disabled {
        background-color: var(--outline-variant); color: white; cursor: not-allowed;
    }
    .alert-lumina {
        background-color: var(--error-container); color: var(--on-error-container);
        border: 1px solid var(--error); border-radius: 0.5rem;
    }
    .summary-accent { background-color: var(--primary-container); color: white; }
    .max-w-lg-custom { max-width: 512px; }
    .object-cover-custom { object-fit: cover; }
    .bg-primary-custom { background-color: var(--primary); }
    .text-primary-custom { color: var(--primary); }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(8px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-in { animation: fadeIn 0.3s ease-out forwards; }
</style>

<%-- Page-specific JS: date calculation, member verify, book scan --%>
<script>
    // Initialize dates based on role policy
    function setDates(isLecturer) {
        const now = new Date();
        const due = new Date();
        const days = isLecturer ? 30 : 14;
        due.setDate(now.getDate() + days);
        const options = { year: 'numeric', month: 'short', day: '2-digit' };
        document.getElementById('current_date').innerText = now.toLocaleDateString('en-US', options);
        document.getElementById('due_date').innerText = due.toLocaleDateString('en-US', options);
    }
    setDates(false); // Default: student policy

    // Uptime counter
    let startTime = Date.now();
    setInterval(() => {
        const elapsed = Math.floor((Date.now() - startTime) / 1000);
        const h = String(Math.floor(elapsed / 3600)).padStart(2, '0');
        const m = String(Math.floor((elapsed % 3600) / 60)).padStart(2, '0');
        const s = String(elapsed % 60).padStart(2, '0');
        const el = document.getElementById('uptime_display');
        if (el) el.innerText = `${h}:${m}:${s}`;
    }, 1000);

    let memberVerified = false;
    let bookScanned = false;

    function verifyMember() {
        const input = document.getElementById('member_id').value.trim();
        if (input !== "") {
            document.getElementById('member_profile').classList.remove('d-none');
            document.getElementById('summary_member').innerText = "Alex Johnston (UG-2023-014)";
            document.getElementById('summary_member').classList.remove('text-muted');
            document.getElementById('summary_member').classList.add('text-dark', 'fw-medium');
            setDates(false);
            memberVerified = true;
            checkReady();
        }
    }

    function scanBook() {
        const input = document.getElementById('book_barcode').value.trim();
        if (input !== "") {
            document.getElementById('book_details').classList.remove('d-none');
            document.getElementById('summary_book').innerText = "Advanced Computational Fluid Dynamics";
            document.getElementById('summary_book').classList.remove('text-muted');
            document.getElementById('summary_book').classList.add('text-dark', 'fw-medium');
            bookScanned = true;
            checkReady();
        }
    }

    function checkReady() {
        if (memberVerified && bookScanned) {
            const btn = document.getElementById('finalize_btn');
            btn.disabled = false;
            btn.classList.add('shadow');
        }
    }

    document.getElementById('finalize_btn').addEventListener('click', function(e) {
        if (!this.disabled) {
            this.disabled = true;
            this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> Đang xử lý...';
        }
    });
</script>

</html>
