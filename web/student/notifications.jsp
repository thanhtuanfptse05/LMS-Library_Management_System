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
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #faf9f8;">
            <div class="container-xl px-4 py-5" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── BREADCRUMBS & PAGE HEADER ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb"
                     style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted link-dark"
                       href="${pageContext.request.contextPath}/student/dashboard">Trang chủ</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span class="text-dark">Bảng tin hệ thống</span>
                </nav>

                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                    <div>
                        <h1 class="h3 fw-bold text-dark mb-1">Bảng tin hệ thống</h1>
                        <p class="text-secondary mb-0">Cập nhật tin tức và thông báo chung từ Thư viện.</p>
                    </div>
                </div>

                <!-- ─── MAIN BENTO GRID LAYOUT ─── -->
                <div class="row g-4">
                    
                    <!-- Left Area: Search & Notification List (Wide, 8 Columns) -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card shadow-sm p-4 mb-4">
                            
                            <!-- Search Tools -->
                            <div class="row g-3 mb-4">
                                <div class="col-12">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 rounded-start-3 text-secondary">
                                            <span class="material-symbols-outlined">search</span>
                                        </span>
                                        <input type="text" class="form-control bg-light border-start-0 rounded-end-3" 
                                               id="searchNotifInput" placeholder="Tìm kiếm tiêu đề hoặc nội dung thông báo..."
                                               onkeyup="filterNotifications()">
                                    </div>
                                </div>
                            </div>

                            <!-- Notification Rows Container -->
                            <div class="d-flex flex-column gap-3" id="notificationsList">
                                
                                <c:choose>
                                    <c:when test="${not empty requestScope.notifications}">
                                        <c:forEach var="notif" items="${requestScope.notifications}">
                                            <!-- Item: Info (Broadcast) -->
                                            <div class="notif-item p-3 rounded-3 border-start border-4 border-info d-flex gap-3 position-relative" 
                                                 style="background-color: #ffffff;">
                                                <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-info-subtle text-info"
                                                     style="width: 44px; height: 44px; flex-shrink: 0;">
                                                    <span class="material-symbols-outlined fs-4">campaign</span>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between align-items-start gap-2">
                                                        <h5 class="notif-title fs-6 fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                                            <c:out value="${notif.title}" />
                                                        </h5>
                                                        <span class="text-secondary small font-monospace">
                                                            <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                        <c:out value="${notif.content}" />
                                                    </p>
                                                    <div class="d-none notif-full-content">
                                                        ${notif.content} <!-- Dùng trực tiếp cho HTML nếu thông báo hỗ trợ rich text -->
                                                    </div>
                                                    <div class="d-flex gap-2 mt-2">
                                                        <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                                onclick="viewDetails(this)">
                                                            Xem chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Empty State -->
                                        <div class="text-center py-5">
                                            <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-light text-secondary mb-3"
                                                 style="width: 80px; height: 80px;">
                                                <span class="material-symbols-outlined" style="font-size: 40px;">mail_outline</span>
                                            </div>
                                            <h4 class="fw-bold text-dark mb-1">Không có thông báo nào</h4>
                                            <p class="text-secondary small mb-3">Bảng tin hệ thống hiện đang trống.</p>
                                            <a href="${pageContext.request.contextPath}/student/dashboard" 
                                               class="btn btn-primary-custom rounded-pill px-4 py-2 fw-semibold">
                                                Về trang chủ
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div><!-- /.raised-card -->
                    </div><!-- /.col-lg-8 -->

                    <!-- Right Area: Stats & Quick Controls (Narrow, 4 Columns) -->
                    <div class="col-12 col-lg-4">
                        
                        <!-- Mini statistics block widget -->
                        <div class="raised-card shadow-sm p-4 mb-4">
                            <h5 class="fw-bold text-dark mb-3">Thông tin Bảng tin</h5>
                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3 bg-light">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined text-primary-custom">drafts</span>
                                        <span class="small fw-semibold text-secondary">Tổng số bản tin</span>
                                    </div>
                                    <span class="fw-bold text-dark">${requestScope.notifications.size()}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Notification Settings Card -->
                        <div class="raised-card shadow-sm p-4 mb-4">
                            <h5 class="fw-bold text-dark mb-3">Nhận thông báo qua Email</h5>
                            <div class="d-flex flex-column gap-3">
                                <div class="form-check form-switch d-flex justify-content-between align-items-center ps-0">
                                    <label class="form-check-label small fw-semibold text-secondary" for="emailSettings">
                                        Gửi email nhắc nhở trả sách
                                    </label>
                                    <input class="form-check-input ms-2" type="checkbox" role="switch" id="emailSettings" checked disabled>
                                </div>
                                <div class="form-check form-switch d-flex justify-content-between align-items-center ps-0">
                                    <label class="form-check-label small fw-semibold text-secondary" for="fineSettings">
                                        Nhận email hóa đơn phạt
                                    </label>
                                    <input class="form-check-input ms-2" type="checkbox" role="switch" id="fineSettings" checked disabled>
                                </div>
                                <p class="small text-muted mt-2 mb-0" style="font-size: 11px;">
                                    * Thư viện sẽ tự động gửi email quan trọng về các giao dịch của bạn. Không thể tắt tính năng này.
                                </p>
                            </div>
                        </div>

                        <!-- Library policy note card -->
                        <div class="raised-card shadow-sm p-4" style="background-color: rgba(217, 119, 6, 0.05); border: 1px solid rgba(217, 119, 6, 0.1);">
                            <div class="d-flex align-items-start gap-3">
                                <span class="material-symbols-outlined text-primary-custom fs-4">info</span>
                                <div>
                                    <h6 class="fw-bold text-dark mb-1">Bảng tin hệ thống</h6>
                                    <p class="small text-secondary mb-0" style="line-height: 1.5;">
                                        Nơi cung cấp các thông tin nghỉ lễ, sự kiện và thay đổi chính sách từ thư viện. Các cảnh báo về tài khoản cá nhân sẽ được gửi trực tiếp qua Email.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </div><!-- /.col-lg-4 -->

                </div><!-- /.row -->

            </div><!-- /.container-xl -->

            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.main-wrapper -->


    <!-- ════════════════ DETAILS MODAL ════════════════ -->
    <div class="modal fade" id="notifDetailsModal" tabindex="-1" aria-labelledby="notifDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius: 1rem; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-bottom px-4 py-3" style="background-color: #f7f9fb;">
                    <div class="d-flex align-items-center gap-2">
                        <div class="modal-icon-box rounded-circle d-flex align-items-center justify-content-center bg-info-subtle text-info" 
                             style="width: 36px; height: 36px;">
                            <span class="material-symbols-outlined">campaign</span>
                        </div>
                        <h5 class="modal-title fw-bold text-dark" id="notifDetailsModalLabel">Chi tiết bản tin</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <span class="badge rounded-pill bg-info-subtle text-info fw-bold" style="padding: 6px 12px; font-size: 11px;">HỆ THỐNG</span>
                        <span class="text-secondary small font-monospace" id="modalTime"></span>
                    </div>
                    <h4 class="fw-bold text-dark mb-3" id="modalTitle">Tiêu đề thông báo</h4>
                    <div class="text-secondary small" id="modalContent" style="line-height: 1.6; font-size: 14.5px;">
                        Nội dung thông báo đầy đủ.
                    </div>
                </div>
                <div class="modal-footer border-top px-4 py-3 bg-light">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>


    <!-- ════════════════ MICRO-INTERACTION SCRIPTS ════════════════ -->
    <script>
        // View full notification in modal dialog
        function viewDetails(btn) {
            const item = btn.closest('.notif-item');
            if (!item) return;

            // Get data from row
            const title = item.querySelector('.notif-title').innerText.trim();
            const time = item.querySelector('.font-monospace').innerText.trim();
            const fullContent = item.querySelector('.notif-full-content').innerHTML;

            // Fill text
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalTime').innerText = time;
            document.getElementById('modalContent').innerHTML = fullContent;

            // Show modal
            const myModal = new bootstrap.Modal(document.getElementById('notifDetailsModal'));
            myModal.show();
        }

        // Filter search input
        function filterNotifications() {
            const searchVal = document.getElementById('searchNotifInput').value.toLowerCase().trim();

            document.querySelectorAll('.notif-item').forEach(item => {
                const title = item.querySelector('.notif-title').innerText.toLowerCase();
                const summary = item.querySelector('.notif-summary').innerText.toLowerCase();

                const matchSearch = title.includes(searchVal) || summary.includes(searchVal);

                if (matchSearch) {
                    item.classList.remove('d-none');
                } else {
                    item.classList.add('d-none');
                }
            });
        }
    </script>

    <style>
        .notif-item {
            transition: transform 0.22s ease-out, box-shadow 0.22s ease-out, opacity 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            border: 1px solid #e5e5e5;
        }
        .notif-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.04);
        }
    </style>

</body>
</html>
