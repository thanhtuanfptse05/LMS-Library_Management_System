<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">
        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto d-flex flex-column" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5 flex-grow-1 d-flex align-items-center justify-content-center" style="min-height: calc(100vh - 160px);">
                
                <!-- Success Response Card -->
                <div class="raised-card p-5 border border-outline-variant bg-white text-center" style="max-width: 540px; width: 100%;">
                    
                    <!-- Icon -->
                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-success-subtle text-success mx-auto mb-4" style="width: 80px; height: 80px;">
                        <span class="material-symbols-outlined" style="font-size: 48px;">check_circle</span>
                    </div>

                    <h2 class="mb-2 fw-bold text-success">Thanh toán thành công!</h2>
                    <p class="text-muted mb-4">Cảm ơn bạn. Giao dịch của bạn đã được xử lý và các khoản phạt thư viện đã được thanh toán.</p>

                    <!-- Receipt Summary -->
                    <div class="border rounded-3 p-4 bg-light text-start mb-4" style="border-color: var(--outline-variant) !important;">
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Số biên lai</span>
                            <span class="fw-bold text-dark small">REC-2026-4403</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Mã giao dịch (VNPAY)</span>
                            <span class="fw-bold text-dark small">VNP-9081229048</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Ngày / Giờ</span>
                            <span class="fw-bold text-dark small">Jun 04, 2026 • 18:40</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted small">Số tiền đã trả</span>
                            <span class="fw-bold text-success small">$24.00</span>
                        </div>
                        <div class="d-flex justify-content-between py-2">
                            <span class="text-muted small">Trạng thái</span>
                            <span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3">ĐÃ THANH TOÁN</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex flex-column gap-2">
                        <a href="${pageContext.request.contextPath}/student/my-fines.jsp" class="btn btn-primary-custom py-2.5 rounded-pill fw-bold d-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined">payments</span>
                            Đến Tiền phạt của tôi
                        </a>
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary py-2 rounded-pill fw-bold">
                            Quay lại Bảng điều khiển
                        </a>
                    </div>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
