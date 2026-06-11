<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
<jsp:include page="fragments/_sidebar.jsp" />
<div class="d-flex main-wrapper overflow-hidden">
    <main class="flex-grow-1 overflow-y-auto main-content-layout">
        <jsp:include page="fragments/_header.jsp" />
        <div class="container-fluid px-4 py-4 bm-page">
            <section class="mb-4">
                <p class="bm-page__eyebrow mb-1">Quản lý sách</p>
                <h2 class="bm-page__title mb-1">Tổng quan</h2>
                <p class="bm-page__subtitle mb-0">Theo dõi nhanh tình trạng danh mục, kho vật lý và các vấn đề cần xử lý.</p>
            </section>

            <section class="row g-3 mb-4" aria-label="Chỉ số quản lý sách">
                <div class="col-sm-6 col-xl-3">
                    <article class="raised-card bm-stat-card p-3">
                        <span class="bm-stat-card__icon material-symbols-outlined">menu_book</span>
                        <p class="bm-stat-card__label mt-3 mb-1">Tổng đầu sách</p>
                        <p class="bm-stat-card__value mb-0">12.480</p>
                    </article>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <article class="raised-card bm-stat-card p-3">
                        <span class="bm-stat-card__icon material-symbols-outlined">inventory_2</span>
                        <p class="bm-stat-card__label mt-3 mb-1">Tổng bản sao</p>
                        <p class="bm-stat-card__value mb-0">35.921</p>
                    </article>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <article class="raised-card bm-stat-card p-3">
                        <span class="bm-stat-card__icon material-symbols-outlined">check_circle</span>
                        <p class="bm-stat-card__label mt-3 mb-1">Đang sẵn sàng</p>
                        <p class="bm-stat-card__value mb-0">26.361</p>
                    </article>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <article class="raised-card bm-stat-card p-3">
                        <span class="bm-stat-card__icon material-symbols-outlined">warning</span>
                        <p class="bm-stat-card__label mt-3 mb-1">Cần xử lý</p>
                        <p class="bm-stat-card__value mb-0">14</p>
                    </article>
                </div>
            </section>

            <div class="row g-3 mb-4">
                <section class="col-xl-8">
                    <div class="bm-table-card h-100">
                        <div class="bm-table-card__header">
                            <h3 class="bm-section-title mb-1">Tình trạng kho</h3>
                            <p class="bm-section-note mb-0">Số liệu cập nhật gần nhất lúc 09:30 hôm nay</p>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead><tr><th>Khu vực</th><th>Bản sao ghi nhận</th><th>Đang sẵn sàng</th><th>Cần kiểm tra</th><th>Trạng thái</th></tr></thead>
                                <tbody>
                                    <tr><td><strong>Kho A - Giáo trình</strong></td><td>14.320</td><td>10.882</td><td>3</td><td><span class="bm-badge bm-badge--warning">Cần đối chiếu</span></td></tr>
                                    <tr><td><strong>Kho B - Tham khảo</strong></td><td>12.601</td><td>9.474</td><td>0</td><td><span class="bm-badge bm-badge--success">Ổn định</span></td></tr>
                                    <tr><td><strong>Kho C - Luận văn</strong></td><td>9.000</td><td>6.005</td><td>2</td><td><span class="bm-badge bm-badge--warning">Cần đối chiếu</span></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <aside class="col-xl-4">
                    <div class="bm-side-card h-100">
                        <h3 class="bm-section-title mb-1">Việc cần xử lý</h3>
                        <p class="bm-section-note mb-0">Ưu tiên theo mức độ ảnh hưởng đến kho.</p>
                        <div class="bm-alert-item">
                            <span class="bm-alert-item__icon material-symbols-outlined">report</span>
                            <div>
                                <p class="bm-alert-item__title mb-1">8 bản sao báo hỏng</p>
                                <a class="bm-action-link" href="${pageContext.request.contextPath}/book-management/incidents">Mở danh sách hỏng &amp; mất</a>
                            </div>
                        </div>
                        <div class="bm-alert-item">
                            <span class="bm-alert-item__icon material-symbols-outlined">difference</span>
                            <div>
                                <p class="bm-alert-item__title mb-1">5 lệch kho chưa xác minh</p>
                                <a class="bm-action-link" href="book-inventory-reconciliation.jsp">Xem lệch kho</a>
                            </div>
                        </div>
                        <div class="bm-alert-item">
                            <span class="bm-alert-item__icon material-symbols-outlined">upload_file</span>
                            <div>
                                <p class="bm-alert-item__title mb-1">1 phiên import có lỗi</p>
                                <a class="bm-action-link" href="${pageContext.request.contextPath}/book-management/import-history">Xem lịch sử xử lý</a>
                            </div>
                        </div>
                    </div>
                </aside>
            </div>

            <section class="bm-table-card">
                <div class="bm-table-card__header">
                    <h3 class="bm-section-title mb-1">Hoạt động gần đây</h3>
                    <p class="bm-section-note mb-0">Các thay đổi mới nhất liên quan đến danh mục và kho sách.</p>
                </div>
                <div class="table-responsive">
                    <table class="table table-lms">
                        <thead><tr><th>Thời gian</th><th>Hoạt động</th><th>Đối tượng</th><th>Người thực hiện</th><th>Kết quả</th></tr></thead>
                        <tbody>
                            <tr><td>09/06/2026 09:12</td><td><strong>Import dữ liệu sách</strong></td><td>Phiên IMP-20260609-003</td><td>Nguyễn Thị Lan</td><td><span class="bm-badge bm-badge--success">Thành công</span></td></tr>
                            <tr><td>09/06/2026 08:46</td><td><strong>Cập nhật tình trạng bản sao</strong></td><td>BC-00026312</td><td>Trần Hoàng Minh</td><td><span class="bm-badge bm-badge--warning">Chờ xác minh</span></td></tr>
                            <tr><td>08/06/2026 15:30</td><td><strong>Import dữ liệu sách</strong></td><td>Phiên IMP-20260608-011</td><td>Trần Hoàng Minh</td><td><span class="bm-badge bm-badge--danger">Thất bại</span></td></tr>
                            <tr><td>08/06/2026 14:05</td><td><strong>Tạo đầu sách mới</strong></td><td>Kiến trúc phần mềm hiện đại</td><td>Nguyễn Thị Lan</td><td><span class="bm-badge bm-badge--success">Hoàn tất</span></td></tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div>
</body>
</html>
