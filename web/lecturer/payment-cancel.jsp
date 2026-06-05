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
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5 d-flex align-items-center justify-content-center" style="min-height: calc(100vh - 160px);">
                
                <!-- Cancel Response Card -->
                <div class="raised-card p-5 border border-outline-variant bg-white text-center" style="max-width: 500px; width: 100%;">
                    
                    <!-- Icon -->
                    <div class="d-flex align-items-center justify-content-center rounded-circle bg-danger-subtle text-danger mx-auto mb-4" style="width: 80px; height: 80px;">
                        <span class="material-symbols-outlined" style="font-size: 48px;">warning</span>
                    </div>

                    <h2 class="mb-2 fw-bold text-danger">Thanh toán đã bị hủy</h2>
                    <p class="text-muted mb-4">Giao dịch trực tuyến đã bị hủy hoặc hết thời gian. Không có khoản phí nào được tính vào tài khoản của bạn.</p>

                    <!-- Error Details -->
                    <div class="border rounded-3 p-4 bg-light text-start mb-4" style="border-color: var(--outline-variant) !important;">
                        <div class="d-flex justify-content-between py-1">
                            <span class="text-muted small">Tin nhắn phản hồi</span>
                            <span class="fw-bold text-dark small">Giao dịch đã bị hủy (Mã 24)</span>
                        </div>
                        <div class="d-flex justify-content-between py-1">
                            <span class="text-muted small">Tổng phụ</span>
                            <span class="fw-bold text-dark small">$45.00</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex flex-column gap-2">
                        <a href="${pageContext.request.contextPath}/lecturer/payment-checkout.jsp" class="btn btn-primary-custom py-2.5 rounded-pill fw-bold d-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined">refresh</span>
                            Thử thanh toán lại
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/my-fines.jsp" class="btn btn-outline-secondary py-2 rounded-pill fw-bold">
                            Quay lại Tiền phạt
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
