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
              style="background-color: var(--background); margin-left: 256px; margin-top: 64px; padding-bottom: 80px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid p-4" style="max-width: 1280px; margin: 0 auto;">

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

                <%-- ─── Page Header ─── --%>
                <header class="mb-4">
                    <h3 class="font-headline-lg text-dark mb-1">Quản lý đặt trước</h3>
                    <p class="font-body-lg text-secondary-custom mb-0">
                        Theo dõi và xử lý các yêu cầu mượn sách đang chờ duyệt từ khắp mạng lưới trường học.
                    </p>
                </header>

                <%-- ─── Stats Overview Cards ─── --%>
                <section class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-lowest p-4 rounded-3 border d-flex flex-column justify-content-between h-100"
                             style="border-color: var(--surface-container-highest) !important; box-shadow: 4px 4px 15px rgba(0,0,0,0.04);">
                            <div class="mb-3">
                                <span class="material-symbols-outlined text-secondary-custom mb-2">pending_actions</span>
                                <p class="font-label-md text-secondary-custom text-uppercase mb-0">Tổng chờ duyệt</p>
                            </div>
                            <p class="mb-0 fw-bold text-dark" style="font-size: 40px; line-height: 1;">
                                <c:out value="${totalPending != null ? totalPending : '42'}" />
                            </p>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="p-4 rounded-3 d-flex flex-column justify-content-between h-100 text-white"
                             style="background-color: var(--primary-container); box-shadow: 4px 4px 15px rgba(0,0,0,0.1);">
                            <div class="mb-3">
                                <span class="material-symbols-outlined mb-2" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                <p class="font-label-md text-white opacity-90 text-uppercase mb-0">Sẵn sàng để lấy</p>
                            </div>
                            <p class="mb-0 fw-bold" style="font-size: 40px; line-height: 1;">
                                <c:out value="${readyForPickup != null ? readyForPickup : '12'}" />
                            </p>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-lowest p-4 rounded-3 border d-flex flex-column justify-content-between h-100"
                             style="border-color: var(--surface-container-highest) !important; box-shadow: 4px 4px 15px rgba(0,0,0,0.04);">
                            <div class="mb-3">
                                <span class="material-symbols-outlined text-secondary-custom mb-2">assignment_return</span>
                                <p class="font-label-md text-secondary-custom text-uppercase mb-0">Đang chờ trả</p>
                            </div>
                            <p class="mb-0 fw-bold text-dark" style="font-size: 40px; line-height: 1;">
                                <c:out value="${awaitingReturn != null ? awaitingReturn : '28'}" />
                            </p>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="p-4 rounded-3 border d-flex flex-column justify-content-between h-100"
                             style="background-color: var(--error-container); border-color: rgba(186, 26, 26, 0.1) !important; box-shadow: 4px 4px 15px rgba(0,0,0,0.04);">
                            <div class="mb-3">
                                <span class="material-symbols-outlined text-danger mb-2">history_toggle_off</span>
                                <p class="font-label-md text-danger text-uppercase mb-0">Yêu cầu đã hết hạn</p>
                            </div>
                            <p class="mb-0 fw-bold" style="color: var(--on-error-container); font-size: 40px; line-height: 1;">
                                <c:out value="${expiredCount != null ? expiredCount : '5'}" />
                            </p>
                        </div>
                    </div>
                </section>

                <%-- ─── Filter Toolbar ─── --%>
                <div class="bg-lowest rounded-top-4 p-3 border-start border-end border-top d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3"
                     style="border-color: var(--surface-container-highest) !important;">
                    <div class="d-flex align-items-center gap-3 flex-wrap">
                        <div class="d-flex bg-low rounded-3 p-1">
                            <button class="btn btn-sm bg-white shadow-sm font-label-md text-primary-custom px-3 py-2 border-0"
                                    style="border-radius: 6px;" id="filter-all">Tất cả yêu cầu</button>
                            <button class="btn btn-sm font-label-md text-secondary-custom px-3 py-2 border-0"
                                    id="filter-processing" style="transition: color 0.2s;">Đang xử lý</button>
                            <button class="btn btn-sm font-label-md text-secondary-custom px-3 py-2 border-0"
                                    id="filter-ready" style="transition: color 0.2s;">Sẵn sàng</button>
                        </div>
                        <button class="btn btn-sm d-flex align-items-center gap-1 px-3 py-2 border text-secondary-custom font-label-md rounded-3"
                                style="border-color: var(--outline-variant) !important;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">filter_list</span> Bộ lọc
                        </button>
                    </div>
                    <div class="text-secondary-custom font-label-md">
                        Hiển thị <span class="text-dark fw-bold">
                            <c:out value="${reservationList != null ? reservationList.size() : '12'}" />
                        </span> của <c:out value="${totalPending != null ? totalPending : '42'}" /> bản ghi
                    </div>
                </div>

                <%-- ─── Reservation Table ─── --%>
                <div class="bg-lowest border rounded-bottom-4 overflow-hidden shadow-sm"
                     style="border-color: var(--surface-container-highest) !important;">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-start">
                            <thead>
                                <tr class="bg-low text-secondary-custom font-label-md border-bottom"
                                    style="font-size: 12px; border-color: var(--surface-container-highest) !important;">
                                    <th class="py-3 px-4 fw-semibold text-uppercase border-0">Chi tiết sách</th>
                                    <th class="py-3 px-4 fw-semibold text-uppercase border-0">Thành viên</th>
                                    <th class="py-3 px-4 fw-semibold text-uppercase border-0">Ngày yêu cầu</th>
                                    <th class="py-3 px-4 fw-semibold text-uppercase border-0">Trạng thái</th>
                                    <th class="py-3 px-4 fw-semibold text-uppercase text-end border-0">Hành động</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider border-0">
                                <c:choose>
                                    <c:when test="${not empty reservationList}">
                                        <c:forEach var="res" items="${reservationList}">
                                            <tr class="border-bottom" style="border-color: var(--surface-container-highest) !important; cursor: pointer;"
                                                onclick="if(event.target.tagName!='BUTTON'&&event.target.tagName!='SPAN') location.href='${pageContext.request.contextPath}/librarian/reservation-detail?id=${res.reservationId}'">
                                                <td class="py-3 px-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-2 shadow-sm bg-light overflow-hidden"
                                                             style="width: 48px; height: 64px; flex-shrink: 0;">
                                                            <img alt="Book Cover" class="w-100 h-100" style="object-fit: cover;"
                                                                 src="<c:out value='${res.bookCoverUrl}' />" />
                                                        </div>
                                                        <div>
                                                            <p class="font-body-md fw-bold text-dark mb-0"><c:out value="${res.bookTitle}" /></p>
                                                            <p class="font-body-sm text-secondary-custom mb-0"><c:out value="${res.bookAuthor}" /></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="py-3 px-4">
                                                    <div class="d-flex flex-column">
                                                        <span class="font-body-md fw-semibold text-dark"><c:out value="${res.memberName}" /></span>
                                                        <span class="font-body-sm text-secondary-custom">
                                                            ID: <c:out value="${res.memberId}" /> &bull; <c:out value="${res.memberType}" />
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="py-3 px-4 font-body-sm text-secondary-custom">
                                                    <fmt:formatDate value="${res.requestDate}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td class="py-3 px-4">
                                                    <c:choose>
                                                        <c:when test="${res.status == 'READY'}">
                                                            <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2"
                                                                  style="background-color: var(--primary-fixed); color: var(--on-primary-fixed-variant); font-size: 12px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--primary);"></span>
                                                                Sẵn sàng để lấy
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${res.status == 'WAITING'}">
                                                            <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2"
                                                                  style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant); font-size: 12px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--tertiary);"></span>
                                                                Đang chờ trả
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${res.status == 'EXPIRED'}">
                                                            <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2"
                                                                  style="background-color: var(--error-container); color: var(--on-error-container); font-size: 12px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--error);"></span>
                                                                Đã hết hạn
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2 text-muted"
                                                                  style="background-color: var(--surface-container-high); font-size: 12px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--secondary);"></span>
                                                                Đang xử lý
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="py-3 px-4 text-end">
                                                    <div class="d-flex justify-content-end align-items-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/librarian/reservation-detail?id=${res.reservationId}"
                                                           class="btn p-2 text-secondary-custom rounded-3 border-0 shadow-none" title="Xem chi tiết">
                                                            <span class="material-symbols-outlined">visibility</span>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${res.status == 'WAITING'}">
                                                                <button class="btn btn-sm text-white font-label-md px-3 py-2 border-0 rounded-3"
                                                                        style="background-color: var(--primary);">Thông báo</button>
                                                            </c:when>
                                                            <c:when test="${res.status == 'READY'}">
                                                                <button class="btn btn-sm text-white font-label-md px-3 py-2 border-0 rounded-3"
                                                                        style="background-color: var(--on-tertiary-container);">Bàn giao</button>
                                                            </c:when>
                                                            <c:when test="${res.status == 'EXPIRED'}">
                                                                <button class="btn btn-sm border text-dark font-label-md px-3 py-2 rounded-3"
                                                                        style="border-color: var(--outline) !important;">Lưu trữ</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn btn-sm text-white font-label-md px-3 py-2 border-0 rounded-3"
                                                                        style="background-color: var(--secondary);">Chuẩn bị</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Sample/placeholder rows --%>
                                        <tr class="border-bottom" style="border-color: var(--surface-container-highest) !important;">
                                            <td class="py-3 px-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img alt="Book Cover" class="rounded-2 shadow-sm"
                                                         style="width: 48px; height: 64px; object-fit: cover;"
                                                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuCjQO90jTrkxb53NX6jktB3F8Yj3QoEpb6P61h16sCugqRk04-Bbpmij_nCyGh7GXTbf1jgmzs4VSS2NfZNTRakKsA8KRU1whooosT0Y-hdVXafHY0cUZ9gytb_4jZLoc6LMcUYA0wb5xZZ8ZKzbNRxBrVOmBMDGocxZLHSu0YK5J2wvXTgxrzY13VHjlTc33RymqBAr-almVByvlGbN9aN6Bz-watlFup5mrnhgEoemLzlp9Jop6xRVGiUaW6gxjnxhxrmWklIH2g" />
                                                    <div>
                                                        <p class="font-body-md fw-bold text-dark mb-0">Modern Architecture</p>
                                                        <p class="font-body-sm text-secondary-custom mb-0">Kenneth Frampton</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4">
                                                <div class="d-flex flex-column">
                                                    <span class="font-body-md fw-semibold text-dark">Alex Rivera</span>
                                                    <span class="font-body-sm text-secondary-custom">ID: #STU-9928 &bull; Giảng viên</span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4 font-body-sm text-secondary-custom">Oct 24, 2023</td>
                                            <td class="py-3 px-4">
                                                <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2"
                                                      style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant); font-size: 12px;">
                                                    <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--tertiary);"></span>
                                                    Đang chờ trả
                                                </span>
                                            </td>
                                            <td class="py-3 px-4 text-end">
                                                <div class="d-flex justify-content-end align-items-center gap-2">
                                                    <button class="btn p-2 text-secondary-custom rounded-3 border-0 shadow-none" title="Xem chi tiết">
                                                        <span class="material-symbols-outlined">visibility</span>
                                                    </button>
                                                    <button class="btn btn-sm text-white font-label-md px-3 py-2 border-0 rounded-3"
                                                            style="background-color: var(--primary);">Thông báo</button>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="border-bottom" style="border-color: var(--surface-container-highest) !important;">
                                            <td class="py-3 px-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img alt="Book Cover" class="rounded-2 shadow-sm"
                                                         style="width: 48px; height: 64px; object-fit: cover;"
                                                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBL2Rap63FTihdL_uDtfcK2I8FXJ5zlC0c-v541T04U7r7NdYEAE0zQX8-7jgebYDRiFWPzhRdE436LqhoErXtr051NCgkWKCI8uKUF1ok9Zsa6y9udKi8GyDQr17sLKky9mFhR7Qjrkyfs_43regNCKtmdaS9vGYYpMIqu8kCjKuLMAtmufZRSb7-NlnS0sZao-7ewyKUDTjqZ2c4v5c4Qj8Wr7gYdd1IQWQZDxHEDblSZd8ObAptfemPyZLBw37q9K8K242NvCS0" />
                                                    <div>
                                                        <p class="font-body-md fw-bold text-dark mb-0">Sociological Theory</p>
                                                        <p class="font-body-sm text-secondary-custom mb-0">George Ritzer</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4">
                                                <div class="d-flex flex-column">
                                                    <span class="font-body-md fw-semibold text-dark">Sarah Jenkins</span>
                                                    <span class="font-body-sm text-secondary-custom">ID: #STU-4412 &bull; Sinh viên</span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-4 font-body-sm text-secondary-custom">Oct 25, 2023</td>
                                            <td class="py-3 px-4">
                                                <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border-0 px-3 py-2"
                                                      style="background-color: var(--primary-fixed); color: var(--on-primary-fixed-variant); font-size: 12px;">
                                                    <span class="rounded-circle d-inline-block" style="width: 6px; height: 6px; background-color: var(--primary);"></span>
                                                    Sẵn sàng để lấy
                                                </span>
                                            </td>
                                            <td class="py-3 px-4 text-end">
                                                <div class="d-flex justify-content-end align-items-center gap-2">
                                                    <button class="btn p-2 text-secondary-custom rounded-3 border-0 shadow-none" title="Xem chi tiết">
                                                        <span class="material-symbols-outlined">visibility</span>
                                                    </button>
                                                    <button class="btn btn-sm text-white font-label-md px-3 py-2 border-0 rounded-3"
                                                            style="background-color: var(--on-tertiary-container);">Bàn giao</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- Pagination --%>
                    <div class="p-3 bg-low d-flex justify-content-between align-items-center border-top"
                         style="border-color: var(--surface-container-highest) !important;">
                        <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
                        <button class="btn btn-link p-0 text-decoration-none font-label-md text-secondary-custom d-flex align-items-center gap-1 border-0 shadow-none"
                                ${currentPage <= 1 ? 'disabled style="opacity:0.5;"' : ''}>
                            <span class="material-symbols-outlined">chevron_left</span> Trước
                        </button>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm p-0 rounded-circle text-white fw-bold d-flex align-items-center justify-content-center"
                                    style="width: 32px; height: 32px; background-color: var(--primary); font-size: 12px;">1</button>
                            <button class="btn btn-sm p-0 rounded-circle text-secondary-custom fw-bold d-flex align-items-center justify-content-center border-0"
                                    style="width: 32px; height: 32px; font-size: 12px; transition: background-color 0.2s;">2</button>
                            <button class="btn btn-sm p-0 rounded-circle text-secondary-custom fw-bold d-flex align-items-center justify-content-center border-0"
                                    style="width: 32px; height: 32px; font-size: 12px; transition: background-color 0.2s;">3</button>
                        </div>
                        <button class="btn btn-link p-0 text-decoration-none font-label-md text-secondary-custom d-flex align-items-center gap-1 border-0 shadow-none">
                            Tiếp <span class="material-symbols-outlined">chevron_right</span>
                        </button>
                    </div>
                </div>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Page-specific styles --%>
<style>
    .font-headline-lg { font-size: 32px; line-height: 40px; letter-spacing: -0.01em; font-weight: 600; }
    .font-title-lg { font-size: 20px; line-height: 28px; font-weight: 600; }
    .font-body-lg { font-size: 18px; line-height: 28px; font-weight: 400; }
    .font-body-md { font-size: 16px; line-height: 24px; font-weight: 400; }
    .font-body-sm { font-size: 14px; line-height: 20px; font-weight: 400; }
    .font-label-md { font-size: 12px; line-height: 16px; letter-spacing: 0.05em; font-weight: 600; }
    .bg-lowest { background-color: var(--surface-container-lowest); }
    .bg-low { background-color: var(--surface-container-low); }
    .text-secondary-custom { color: var(--secondary); }
    .text-primary-custom { color: var(--primary); }
    .btn-scale-active:active { transform: scale(0.95); }
</style>

<script>
    document.querySelectorAll('tbody tr').forEach(row => {
        row.style.cursor = 'pointer';
    });
</script>

</html>
