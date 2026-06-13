<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
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

                <!-- ─── KPI Grid ─── -->
                <section class="mb-4">
                    <div class="d-flex justify-content-between align-items-end mb-3">
                        <div>
                            <h2 class="fw-semibold mb-0" style="font-size: 20px; color: var(--on-surface);">Hiệu suất Thư viện</h2>
                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Tóm tắt KPI hàng tháng — <span id="current-month"></span></p>
                        </div>
                        <a href="#" class="btn btn-sm rounded-3 fw-bold px-3 d-flex align-items-center gap-1"
                           style="background-color: var(--surface-container-high); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                            <span class="material-symbols-outlined" style="font-size: 16px;">download</span> Xuất
                        </a>
                    </div>
                    <div class="row g-3">
                        <!-- Total Borrowings -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed);">library_books</span>
                                    <span class="fw-bold kpi-trend-up" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span> +8.2%
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Tổng số Mượn</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${totalBorrowings != null ? totalBorrowings : '1,254'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 78%; background-color: var(--primary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Active Members -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed);">people</span>
                                    <span class="fw-bold kpi-trend-up" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span> +3.5%
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Thành viên hoạt động</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${activeMembers != null ? activeMembers : '3,401'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 65%; background-color: var(--tertiary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Fine Revenue -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7;">payments</span>
                                    <span class="fw-bold kpi-trend-up" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span> +12.1%
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Doanh thu Tiền phạt (VND)</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${fineRevenue != null ? fineRevenue : '2.4M'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 55%; background-color: #d97706;"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Overdue Rate -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--error); background-color: var(--error-container);">event_busy</span>
                                    <span class="fw-bold kpi-trend-down" style="font-size: 12px;">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">trending_down</span> -1.4%
                                    </span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Tỷ lệ Trễ hạn</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">5.6%</h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 22%; background-color: var(--error);"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Borrowing Chart + Staff Table -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Monthly Borrowing Chart (visual bars) -->
                        <div class="raised-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Xu hướng Mượn hàng tháng</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Số phiếu mượn mỗi tháng (8 tháng gần nhất)</p>
                                </div>
                                <span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--primary);">2025</span>
                            </div>
                            <div class="d-flex align-items-end gap-2 pt-2" style="height: 130px; border-bottom: 1px solid var(--outline-variant);">
                                <div class="bar-chart-col flex-fill" title="Tháng 10: 820">
                                    <div class="bar-track" style="height: 65%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th10</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 11: 940">
                                    <div class="bar-track" style="height: 75%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th11</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 12: 1100">
                                    <div class="bar-track" style="height: 87%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th12</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 1: 1000">
                                    <div class="bar-track" style="height: 79%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th1</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 2: 870">
                                    <div class="bar-track" style="height: 69%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th2</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 3: 1050">
                                    <div class="bar-track" style="height: 83%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th3</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 4: 1150">
                                    <div class="bar-track" style="height: 91%; background-color: var(--surface-container-high);"></div>
                                    <span style="font-size: 10px; color: var(--on-surface-variant);">Th4</span>
                                </div>
                                <div class="bar-chart-col flex-fill" title="Tháng 5: 1254">
                                    <div class="bar-track" style="height: 100%; background-color: var(--primary);"></div>
                                    <span style="font-size: 10px; font-weight: 600; color: var(--primary);">Th5</span>
                                </div>
                            </div>
                        </div>

                        <!-- Staff Performance Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center bg-white"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Hiệu suất Nhân viên</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Hoạt động hàng tháng theo thủ thư</p>
                                </div>
                                <a href="#" class="btn btn-sm rounded-3 fw-bold px-3 text-decoration-none"
                                   style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                    Báo cáo Chi tiết
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thủ thư</th>
                                            <th>Số phiếu cấp</th>
                                            <th>Số trả</th>
                                            <th>Tiền phạt thu</th>
                                            <th>Đánh giá</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty staffStats}">
                                                <c:forEach var="staff" items="${staffStats}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">LB</div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${staff.name}" /></span>
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 13px; font-weight: 600;"><c:out value="${staff.issues}" /></td>
                                                        <td style="font-size: 13px; font-weight: 600;"><c:out value="${staff.returns}" /></td>
                                                        <td style="font-size: 13px; color: #059669; font-weight: 600;"><c:out value="${staff.fineCollected}" /></td>
                                                        <td>
                                                            <span class="badge-pill" style="background-color: #d1fae5; color: #059669;">★ <c:out value="${staff.rating}" /></span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">JS</div><span style="font-size: 13px; font-weight: 600;">John Stevens</span></div></td>
                                                    <td style="font-size: 13px; font-weight: 600;">345</td>
                                                    <td style="font-size: 13px; font-weight: 600;">312</td>
                                                    <td style="font-size: 13px; color: #059669; font-weight: 600;">680,000đ</td>
                                                    <td><span class="badge-pill" style="background-color: #d1fae5; color: #059669;">★ 4.9</span></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed-variant);">MH</div><span style="font-size: 13px; font-weight: 600;">Mai Huong</span></div></td>
                                                    <td style="font-size: 13px; font-weight: 600;">298</td>
                                                    <td style="font-size: 13px; font-weight: 600;">281</td>
                                                    <td style="font-size: 13px; color: #059669; font-weight: 600;">540,000đ</td>
                                                    <td><span class="badge-pill" style="background-color: #d1fae5; color: #059669;">★ 4.7</span></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed);">NQ</div><span style="font-size: 13px; font-weight: 600;">Nguyen Quang</span></div></td>
                                                    <td style="font-size: 13px; font-weight: 600;">210</td>
                                                    <td style="font-size: 13px; font-weight: 600;">195</td>
                                                    <td style="font-size: 13px; color: #d97706; font-weight: 600;">380,000đ</td>
                                                    <td><span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">★ 4.2</span></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Policies + Announcements -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Library Policies -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">Chính sách Hoạt động</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Thêm mới
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="policy-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Chính sách Thời hạn Mượn</p>
                                        <span class="badge-pill" style="background-color: #d1fae5; color: #059669;">Hoạt động</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Tối đa 21 ngày mỗi lần mượn. Gia hạn được 1 lần.</p>
                                </div>
                                <div class="policy-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Chính sách Tiền phạt</p>
                                        <span class="badge-pill" style="background-color: #d1fae5; color: #059669;">Hoạt động</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Phí 5.000 VND/ngày quá hạn.</p>
                                </div>
                                <div class="policy-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Hết hạn Đặt trước</p>
                                        <span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">Xem xét</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Đặt trước tự động hủy sau 48 giờ.</p>
                                </div>
                            </div>
                            <div class="p-3 bg-surface-container-low" style="border-top: 1px solid var(--outline-variant);">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">Quản lý Chính sách &rarr;</a>
                            </div>
                        </div>

                        <!-- Announcements -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">Thông báo hệ thống</h3>
                                <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold px-2" style="font-size: 12px;">
                                    <span class="material-symbols-outlined" style="font-size: 15px;">campaign</span> Đăng
                                </button>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <c:choose>
                                    <c:when test="${not empty announcements}">
                                        <c:forEach var="ann" items="${announcements}">
                                            <div class="announcement-card">
                                                <p class="fw-bold mb-1" style="font-size: 13px;"><c:out value="${ann.title}" /></p>
                                                <p class="text-on-surface-variant mb-1" style="font-size: 12px;"><c:out value="${ann.body}" /></p>
                                                <span class="text-on-surface-variant" style="font-size: 11px;"><fmt:formatDate value="${ann.postedAt}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="announcement-card">
                                            <p class="fw-bold mb-1" style="font-size: 13px;">Cập nhật Giờ mùa hè</p>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">Thư viện mở cửa đến 22:00 từ ngày 10/6 đến 31/8.</p>
                                            <span class="text-on-surface-variant" style="font-size: 11px;">Ngày đăng: 01/06/2025</span>
                                        </div>
                                        <div class="announcement-card" style="border-left-color: var(--tertiary); background-color: rgba(205,229,255,0.15);">
                                            <p class="fw-bold mb-1" style="font-size: 13px;">Thông báo bổ sung Sách mới</p>
                                            <p class="text-on-surface-variant mb-1" style="font-size: 12px;">220 tựa sách Khoa học Máy tính mới được thêm vào danh mục Kèo Đông.</p>
                                            <span class="text-on-surface-variant" style="font-size: 11px;">Ngày đăng: 28/05/2025</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <script>
        document.getElementById('current-month').textContent = new Date().toLocaleString('vi-VN', { month: 'long', year: 'numeric' });
    </script>

</body>
</html>
