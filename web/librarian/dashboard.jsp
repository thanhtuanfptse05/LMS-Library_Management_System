<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto" style="background-color: var(--background); margin-left: 256px;">

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

                <!-- ─── Stats Overview ─── -->
                <section class="mb-4">
                    <div class="d-flex justify-content-between align-items-end mb-3">
                        <div>
                            <h2 class="fw-semibold mb-0" style="font-size: 20px; color: var(--on-surface);">Lưu thông hôm nay</h2>
                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Tổng quan hoạt động quầy theo thời gian thực</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/librarian/catalog.jsp"
                           class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                            <span class="material-symbols-outlined" style="font-size: 18px;">add</span> Mượn sách
                        </a>
                    </div>
                    <div class="row g-3">
                        <!-- Issued Today -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--primary); background-color: var(--primary-fixed);">library_books</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">+12 hôm nay</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Sách đã mượn</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${issuedToday != null ? issuedToday : '38'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 70%; background-color: var(--primary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Returned Today -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--tertiary); background-color: var(--tertiary-fixed);">assignment_return</span>
                                    <span class="badge-pill" style="color: #059669; background-color: #d1fae5;">+8 hôm nay</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Sách đã trả</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${returnedToday != null ? returnedToday : '22'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 50%; background-color: var(--tertiary);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Overdue -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: var(--error); background-color: var(--error-container);">event_busy</span>
                                    <span class="badge-pill" style="color: var(--error); background-color: var(--error-container);">Cần hành động</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Khoản mượn quá hạn</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${overdueCount != null ? overdueCount : '7'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 30%; background-color: var(--error);"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Active Reservations -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <div class="raised-card p-3 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="material-symbols-outlined p-2 rounded-2"
                                          style="color: #d97706; background-color: #fef3c7;">bookmark</span>
                                    <span class="badge-pill" style="color: #d97706; background-color: #fef3c7;">Chờ duyệt</span>
                                </div>
                                <p class="mb-1 fw-semibold text-uppercase text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Đặt trước chờ duyệt</p>
                                <h3 class="fw-semibold mb-2" style="font-size: 24px; color: var(--on-surface);">
                                    <c:out value="${pendingReservations != null ? pendingReservations : '15'}" />
                                </h3>
                                <div class="mini-progress">
                                    <div class="mini-progress-bar" style="width: 60%; background-color: #d97706;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ─── Main Split Layout ─── -->
                <div class="row g-4">

                    <!-- Left 2/3: Recent Loans -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Active Loans Table -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center bg-white"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Khoản mượn hoạt động</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Sách đang được mượn</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm rounded-3 fw-bold px-3" style="background-color: var(--surface-container-low); color: var(--on-surface-variant); border: 1px solid var(--outline-variant);">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">filter_list</span> Bộ lọc
                                    </button>
                                    <button class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3">
                                        <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Mượn mới
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thành viên</th>
                                            <th>Tiêu đề sách</th>
                                            <th>Ngày mượn</th>
                                            <th>Hạn trả</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty activeLoans}">
                                                <c:forEach var="loan" items="${activeLoans}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">ST</div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${loan.memberName}" /></span>
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 13px;"><c:out value="${loan.bookTitle}" /></td>
                                                        <td class="text-on-surface-variant" style="font-size: 13px;"><fmt:formatDate value="${loan.issueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td style="font-size: 13px; color: var(--error);"><fmt:formatDate value="${loan.dueDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                        <td class="text-end">
                                                            <button class="btn-icon" title="Xử lý trả sách"><span class="material-symbols-outlined" style="font-size: 18px;">assignment_return</span></button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Sample rows -->
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">TN</div><span style="font-size: 13px; font-weight: 600;">Tran Nguyen</span></div></td>
                                                    <td style="font-size: 13px;">Clean Code (R. Martin)</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">20/05/2025</td>
                                                    <td style="font-size: 13px;">10/06/2025</td>
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined" style="font-size: 18px;">assignment_return</span></button></td>
                                                </tr>
                                                <tr style="background-color: rgba(255,218,214,0.08);">
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--error-container); color: var(--error);">LM</div><span style="font-size: 13px; font-weight: 600;">Le Minh</span></div></td>
                                                    <td style="font-size: 13px;">Design Patterns (GoF)</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">01/05/2025</td>
                                                    <td style="font-size: 13px; color: var(--error); font-weight: 600;">22/05/2025 ⚠</td>
                                                    <td><span class="badge-pill" style="color: var(--error); background-color: var(--error-container);">Quá hạn</span></td>
                                                    <td class="text-end"><button class="btn-icon" style="color: var(--error);" title="Trả sách"><span class="material-symbols-outlined" style="font-size: 18px;">assignment_return</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--secondary-fixed); color: var(--on-secondary-fixed);">HP</div><span style="font-size: 13px; font-weight: 600;">Hoang Phuong</span></div></td>
                                                    <td style="font-size: 13px;">Introduction to Algorithms</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">28/05/2025</td>
                                                    <td style="font-size: 13px;">18/06/2025</td>
                                                    <td><span class="badge-pill" style="color: var(--tertiary); background-color: var(--tertiary-fixed);">Hoạt động</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined" style="font-size: 18px;">assignment_return</span></button></td>
                                                </tr>
                                                <tr>
                                                    <td><div class="d-flex align-items-center gap-2"><div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">VT</div><span style="font-size: 13px; font-weight: 600;">Vo Thanh</span></div></td>
                                                    <td style="font-size: 13px;">The Pragmatic Programmer</td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">29/05/2025</td>
                                                    <td style="font-size: 13px;">19/06/2025</td>
                                                    <td><span class="badge-pill" style="color: #059669; background-color: #d1fae5;">Sắp đến hạn</span></td>
                                                    <td class="text-end"><button class="btn-icon" title="Trả sách"><span class="material-symbols-outlined" style="font-size: 18px;">assignment_return</span></button></td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-3 text-center bg-surface-container-low">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">Xem tất cả khoản mượn hoạt động &rarr;</a>
                            </div>
                        </div>

                        <!-- Quick Issue Form -->
                        <div class="raised-card p-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="material-symbols-outlined p-2 rounded-2 text-primary-custom" style="background-color: var(--primary-fixed);">published_with_changes</span>
                                <div>
                                    <h3 class="fw-semibold mb-0" style="font-size: 18px; color: var(--on-surface);">Mượn / Trả nhanh</h3>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Hành động quầy lưu thông nhanh</p>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-12 col-md-5">
                                    <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Mã thành viên / Email</label>
                                    <input class="form-control rounded-3" type="text" placeholder="Quét hoặc nhập mã thành viên..." aria-label="Member ID or email" />
                                </div>
                                <div class="col-12 col-md-5">
                                    <label class="d-block mb-1 fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">ISBN / ID Sách</label>
                                    <input class="form-control rounded-3" type="text" placeholder="Quét hoặc nhập ISBN..." aria-label="Book ISBN or ID" />
                                </div>
                                <div class="col-12 col-md-2 d-flex align-items-end">
                                    <button class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">Mượn</button>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-8 -->

                    <!-- Right 1/3: Pending Reservations + Member Status -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">

                        <!-- Pending Reservations -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 bg-white d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">Chờ duyệt Đặt trước</h3>
                                <span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--primary);">
                                    <c:out value="${pendingReservations != null ? pendingReservations : '15'}" /> Đang chờ
                                </span>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <span class="fw-bold" style="font-size: 13px;">Nguyen Duc Hieu</span>
                                        <span class="badge-pill" style="background-color: var(--error-container); color: var(--error);">2 days</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-2" style="font-size: 12px;">Refactoring (Martin Fowler)</p>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Xác nhận</button>
                                        <button class="btn btn-sm rounded-2 fw-bold flex-fill" style="background-color: var(--surface-container-high); color: var(--on-surface-variant); font-size: 12px; border: 1px solid var(--outline-variant);">Từ chối</button>
                                    </div>
                                </div>
                                <div class="p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <span class="fw-bold" style="font-size: 13px;">Pham Thi Lan</span>
                                        <span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">1 day</span>
                                    </div>
                                    <p class="text-on-surface-variant mb-2" style="font-size: 12px;">Java: The Complete Reference</p>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-primary-custom rounded-2 fw-bold flex-fill" style="font-size: 12px;">Xác nhận</button>
                                        <button class="btn btn-sm rounded-2 fw-bold flex-fill" style="background-color: var(--surface-container-high); color: var(--on-surface-variant); font-size: 12px; border: 1px solid var(--outline-variant);">Từ chối</button>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3 text-center bg-surface-container-low" style="border-top: 1px solid var(--outline-variant);">
                                <a href="#" class="text-primary-custom fw-bold text-decoration-none" style="font-size: 13px;">Xem tất cả đặt trước &rarr;</a>
                            </div>
                        </div>

                        <!-- Today's Fine Alerts -->
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 bg-white" style="border-bottom: 1px solid var(--outline-variant);">
                                <h3 class="fw-semibold mb-0" style="font-size: 16px; color: var(--on-surface);">Thu tiền phạt hôm nay</h3>
                                <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Số dư phạt chưa thanh toán</p>
                            </div>
                            <div class="p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-center p-2 rounded-2"
                                     style="background-color: rgba(186,26,26,0.05);">
                                    <div>
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Le Minh</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Overdue: 11 days</p>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-0" style="font-size: 15px; font-weight: 700; color: var(--error);">55,000đ</p>
                                        <button class="btn btn-sm rounded-2 fw-bold mt-1" style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none;">Thu</button>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center p-2 rounded-2"
                                     style="background-color: rgba(186,26,26,0.05);">
                                    <div>
                                        <p class="fw-bold mb-0" style="font-size: 13px;">Nguyen Van An</p>
                                        <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Overdue: 4 days</p>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-0" style="font-size: 15px; font-weight: 700; color: var(--error);">20,000đ</p>
                                        <button class="btn btn-sm rounded-2 fw-bold mt-1" style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none;">Thu</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
