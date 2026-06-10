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
                <p class="bm-page__eyebrow mb-1">Danh mục sách</p>
                <h2 class="bm-page__title mb-1">Thể loại &amp; thẻ</h2>
                <p class="bm-page__subtitle mb-0">Quản lý cách phân nhóm và mô tả đầu sách trong thư viện.</p>
            </section>

            <nav class="bm-segmented-tabs mb-4" role="tablist" aria-label="Quản lý thể loại và tag sách">
                <button class="bm-segmented-tabs__item active" id="category-tab" data-bs-toggle="tab"
                        data-bs-target="#category-panel" type="button" role="tab"
                        aria-controls="category-panel" aria-selected="true">
                    <span class="material-symbols-outlined">category</span>
                    Thể loại
                </button>
                <button class="bm-segmented-tabs__item" id="tag-tab" data-bs-toggle="tab"
                        data-bs-target="#tag-panel" type="button" role="tab"
                        aria-controls="tag-panel" aria-selected="false">
                    <span class="material-symbols-outlined">sell</span>
                    Tag sách
                </button>
            </nav>

            <div class="tab-content">
                <section class="tab-pane fade show active" id="category-panel" role="tabpanel" aria-labelledby="category-tab">
                    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                        <div>
                            <h3 class="bm-section-title mb-1">Danh sách thể loại</h3>
                            <p class="bm-section-note mb-0">Thể loại đã ẩn vẫn được giữ để bảo toàn dữ liệu lịch sử.</p>
                        </div>
                        <button class="btn btn-primary-custom">
                            <span class="material-symbols-outlined">add</span>
                            Tạo thể loại
                        </button>
                    </div>

                    <section class="bm-filter-card mb-3">
                        <div class="row g-2">
                            <div class="col-lg-8 bm-search">
                                <span class="material-symbols-outlined">search</span>
                                <input class="form-control" placeholder="Tìm kiếm thể loại..." aria-label="Tìm kiếm thể loại">
                            </div>
                            <div class="col-lg-4">
                                <select class="form-select" aria-label="Lọc trạng thái thể loại">
                                    <option>Mọi trạng thái</option>
                                    <option>Đang dùng</option>
                                    <option>Đã ẩn</option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <section class="bm-table-card">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead><tr><th>Tên thể loại</th><th>Mô tả</th><th>Số đầu sách</th><th>Trạng thái</th><th>Cập nhật gần nhất</th><th></th></tr></thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Công nghệ thông tin</strong></td>
                                        <td>Lập trình, hệ thống, dữ liệu và mạng máy tính.</td>
                                        <td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?categoryId=1">Xem 3.412 đầu sách</a></td>
                                        <td><span class="bm-badge bm-badge--success">Đang dùng</span></td>
                                        <td>08/06/2026</td>
                                        <td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Kinh tế &amp; quản trị</strong></td>
                                        <td>Kinh tế học, tài chính, marketing và quản trị.</td>
                                        <td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?categoryId=2">Xem 2.108 đầu sách</a></td>
                                        <td><span class="bm-badge bm-badge--success">Đang dùng</span></td>
                                        <td>06/06/2026</td>
                                        <td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Khoa học tự nhiên</strong></td>
                                        <td>Toán học, vật lý, hóa học và sinh học.</td>
                                        <td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?categoryId=3">Xem 1.927 đầu sách</a></td>
                                        <td><span class="bm-badge bm-badge--success">Đang dùng</span></td>
                                        <td>03/06/2026</td>
                                        <td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Tài liệu nội bộ cũ</strong></td>
                                        <td>Nhóm tài liệu cũ, không tiếp tục gán cho đầu sách mới.</td>
                                        <td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?categoryId=4">Xem 86 đầu sách</a></td>
                                        <td><span class="bm-badge bm-badge--neutral">Đã ẩn</span></td>
                                        <td>20/05/2026</td>
                                        <td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </section>

                <section class="tab-pane fade" id="tag-panel" role="tabpanel" aria-labelledby="tag-tab">
                    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                        <div>
                            <h3 class="bm-section-title mb-1">Danh sách tag sách</h3>
                            <p class="bm-section-note mb-0">Tag đã ẩn không còn được gợi ý khi gán cho đầu sách mới.</p>
                        </div>
                        <div class="bm-actions">
                            <button class="btn bm-btn-secondary">Gộp tag</button>
                            <button class="btn btn-primary-custom">
                                <span class="material-symbols-outlined">add</span>
                                Tạo tag sách
                            </button>
                        </div>
                    </div>

                    <section class="bm-filter-card mb-3">
                        <div class="row g-2">
                            <div class="col-lg-8 bm-search">
                                <span class="material-symbols-outlined">search</span>
                                <input class="form-control" placeholder="Tìm kiếm tag sách..." aria-label="Tìm kiếm tag sách">
                            </div>
                            <div class="col-lg-4">
                                <select class="form-select" aria-label="Lọc trạng thái tag sách">
                                    <option>Mọi trạng thái</option>
                                    <option>Đang dùng</option>
                                    <option>Đã ẩn</option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <section class="bm-table-card">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead><tr><th>Tên tag</th><th>Số đầu sách</th><th>Trạng thái</th><th>Cập nhật gần nhất</th><th>Người cập nhật</th><th></th></tr></thead>
                                <tbody>
                                    <tr><td><span class="bm-tag">Java</span></td><td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?tagId=1">Xem 428 đầu sách</a></td><td><span class="bm-badge bm-badge--success">Đang dùng</span></td><td>08/06/2026</td><td>Nguyễn Thị Lan</td><td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td></tr>
                                    <tr><td><span class="bm-tag">Cơ sở dữ liệu</span></td><td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?tagId=2">Xem 317 đầu sách</a></td><td><span class="bm-badge bm-badge--success">Đang dùng</span></td><td>05/06/2026</td><td>Trần Hoàng Minh</td><td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td></tr>
                                    <tr><td><span class="bm-tag">Giáo trình</span></td><td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?tagId=3">Xem 2.841 đầu sách</a></td><td><span class="bm-badge bm-badge--success">Đang dùng</span></td><td>02/06/2026</td><td>Nguyễn Thị Lan</td><td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td></tr>
                                    <tr><td><span class="bm-tag">Tài liệu 2015</span></td><td><a class="bm-count-link" href="${pageContext.request.contextPath}/book-management/titles?tagId=4">Xem 64 đầu sách</a></td><td><span class="bm-badge bm-badge--neutral">Đã ẩn</span></td><td>18/05/2026</td><td>Trần Hoàng Minh</td><td><button class="btn btn-sm bm-btn-secondary">Chỉnh sửa</button></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </section>
            </div>
        </div>
        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div>
</body>
</html>
