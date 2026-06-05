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
              style="background-color: var(--surface); margin-left: 256px;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1280px; margin: 0 auto;">

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
                <div class="mb-4">
                    <h2 class="font-headline-lg text-dark mb-2">Xử lý trả sách</h2>
                    <p class="font-body-md text-secondary-custom">
                        Quét mã vạch sách để bắt đầu quá trình trả và xác minh thông tin người mượn.
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/librarian/return-create"
                      method="post" id="return_form">

                    <div class="row g-4">
                        <%-- Left Column: Scanner & Details --%>
                        <div class="col-12 col-lg-8">
                            <div class="d-flex flex-column gap-4">

                                <%-- Inventory Scanner Section --%>
                                <section class="bg-lowest p-4 rounded-3 border tonal-elevation-1"
                                         style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                    <div class="row g-3 align-items-end">
                                        <div class="col flex-grow-1">
                                            <label class="d-block font-label-md text-primary-custom mb-2"
                                                   for="inventory_barcode">Mã vạch kho / ID sách</label>
                                            <div class="position-relative">
                                                <span class="position-absolute start-0 top-50 translate-middle-y ms-3 material-symbols-outlined text-secondary-custom">barcode_scanner</span>
                                                <input class="form-control bg-low border-0 rounded-3 py-3 font-title-lg"
                                                       style="padding-left: 3rem;"
                                                       placeholder="Nhập hoặc quét ID..."
                                                       type="text"
                                                       id="inventory_barcode"
                                                       name="bookCopyBarcode"
                                                       value="<c:out value='${param.bookCopyBarcode}' />" />
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <button class="btn px-4 py-3 fw-bold rounded-3 text-white d-flex align-items-center gap-2 btn-scale-active border-0"
                                                    style="background-color: var(--primary-container); height: 56px;"
                                                    type="button"
                                                    onclick="document.getElementById('return_form').submit()">
                                                <span class="material-symbols-outlined">center_focus_strong</span> Quét
                                            </button>
                                        </div>
                                    </div>
                                </section>

                                <%-- Return Details Grid --%>
                                <c:if test="${not empty borrowRecord}">
                                <section class="row g-4">
                                    <%-- Book Information --%>
                                    <div class="col-12 col-md-6">
                                        <div class="bg-lowest p-4 rounded-3 border h-100 tonal-elevation-1 d-flex gap-3"
                                             style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                            <div class="rounded-2 bg-light overflow-hidden flex-shrink-0 shadow-sm border border-light-subtle"
                                                 style="width: 96px; height: 144px;">
                                                <img alt="Book Cover" class="w-100 h-100" style="object-fit: cover;"
                                                     src="${not empty borrowRecord.bookCoverUrl ? borrowRecord.bookCoverUrl : 'https://lh3.googleusercontent.com/aida-public/AB6AXuAfr9Wq-8JQcE2HOz4w5ELcy7VqzxHCIdzMDfvzpEkmCqo1DqYHn8f9TXyuj7SxOZ3gJeq6eLmWm4QWqJxq14KLzBIIH4tW4vX1nuw7GJCGJIIM3L-S_d8C3eICH-BtMFeto-J8AIB6oQ4vSMTMSzlZeLpncWKmB3K_d7hL1EkFxhlZLsGi7HPJOKWjCxrZi6aIdMXJPYt8YLN1iv5pVEU6ex-TT1Lgb601MK0DY52ivGXQF4wXuoE3x7fwgGQlWsen5gfMV7bBdRc'}" />
                                            </div>
                                            <div class="d-flex flex-column justify-content-center">
                                                <span class="badge font-label-md text-dark mb-2 align-self-start py-2 px-2 border-0"
                                                      style="background-color: var(--tertiary-fixed); font-size: 10px;">
                                                    <c:out value="${borrowRecord.bookCategory}" default="GENERAL" />
                                                </span>
                                                <h3 class="font-title-lg text-dark mb-1" style="line-height: 1.2;">
                                                    <c:out value="${borrowRecord.bookTitle}" default="Advanced Organic Chemistry" />
                                                </h3>
                                                <p class="font-body-sm text-secondary-custom mb-2">
                                                    <c:out value="${borrowRecord.bookAuthor}" default="Francis A. Carey" />
                                                </p>
                                                <div class="d-flex flex-column gap-1">
                                                    <div class="d-flex align-items-center gap-2 font-label-md"
                                                         style="color: var(--on-surface-variant);">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">fingerprint</span>
                                                        ISBN: <c:out value="${borrowRecord.isbn}" default="978-0387683461" />
                                                    </div>
                                                    <div class="d-flex align-items-center gap-2 font-label-md"
                                                         style="color: var(--on-surface-variant);">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">barcode</span>
                                                        ID: <c:out value="${borrowRecord.bookCopyBarcode}" default="LUM-88293-XP" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Borrower Information --%>
                                    <div class="col-12 col-md-6">
                                        <div class="bg-lowest p-4 rounded-3 border h-100 tonal-elevation-1"
                                             style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                            <div class="d-flex align-items-center gap-3 mb-4">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center text-dark"
                                                     style="width: 48px; height: 48px; background-color: var(--secondary-container);">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div>
                                                    <h3 class="font-title-lg text-dark mb-0" style="line-height: 1;">
                                                        <c:out value="${borrowRecord.borrowerName}" default="Julian Thorne" />
                                                    </h3>
                                                    <p class="font-body-sm text-secondary-custom mb-0 mt-1">
                                                        Sinh viên ID: <c:out value="${borrowRecord.borrowerId}" default="2023-ST-0442" />
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="row g-3">
                                                <div class="col-6">
                                                    <div class="bg-low p-2 rounded-3 text-center">
                                                        <p class="font-label-md mb-1" style="color: var(--on-surface-variant);">Loại thành viên</p>
                                                        <p class="font-body-md fw-bold text-primary-custom mb-0">
                                                            <c:out value="${borrowRecord.memberType}" default="Undergraduate" />
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="bg-low p-2 rounded-3 text-center">
                                                        <p class="font-label-md mb-1" style="color: var(--on-surface-variant);">Khoản mượn hiện tại</p>
                                                        <p class="font-body-md fw-bold text-primary-custom mb-0">
                                                            <c:out value="${borrowRecord.activeLoans}" default="3" /> / 5
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mt-4 d-flex justify-content-between align-items-center font-body-sm">
                                                <span class="text-secondary-custom">Hạn trả:</span>
                                                <c:choose>
                                                    <c:when test="${borrowRecord.overdueDays > 0}">
                                                        <span class="text-danger fw-bold d-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined" style="font-size: 16px;">warning</span>
                                                            <c:out value="${borrowRecord.overdueDays}" /> Ngày quá hạn
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-success fw-bold">
                                                            Đúng hạn (<fmt:formatDate value="${borrowRecord.dueDate}" pattern="dd/MM/yyyy" />)
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                </c:if>

                                <%-- Placeholder when no book scanned yet --%>
                                <c:if test="${empty borrowRecord}">
                                <section class="row g-4">
                                    <div class="col-12 col-md-6">
                                        <div class="bg-lowest p-4 rounded-3 border h-100 tonal-elevation-1 d-flex gap-3"
                                             style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                            <div class="rounded-2 bg-light overflow-hidden flex-shrink-0 shadow-sm border border-light-subtle"
                                                 style="width: 96px; height: 144px;">
                                                <img alt="Book Cover" class="w-100 h-100" style="object-fit: cover;"
                                                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuAfr9Wq-8JQcE2HOz4w5ELcy7VqzxHCIdzMDfvzpEkmCqo1DqYHn8f9TXyuj7SxOZ3gJeq6eLmWm4QWqJxq14KLzBIIH4tW4vX1nuw7GJCGJIIM3L-S_d8C3eICH-BtMFeto-J8AIB6oQ4vSMTMSzlZeLpncWKmB3K_d7hL1EkFxhlZLsGi7HPJOKWjCxrZi6aIdMXJPYt8YLN1iv5pVEU6ex-TT1Lgb601MK0DY52ivGXQF4wXuoE3x7fwgGQlWsen5gfMV7bBdRc" />
                                            </div>
                                            <div class="d-flex flex-column justify-content-center">
                                                <span class="badge font-label-md text-dark mb-2 align-self-start py-2 px-2 border-0"
                                                      style="background-color: var(--tertiary-fixed); font-size: 10px;">SCIENCE &amp; TECH</span>
                                                <h3 class="font-title-lg text-dark mb-1" style="line-height: 1.2;">Advanced Organic Chemistry</h3>
                                                <p class="font-body-sm text-secondary-custom mb-2">Francis A. Carey</p>
                                                <div class="d-flex flex-column gap-1">
                                                    <div class="d-flex align-items-center gap-2 font-label-md" style="color: var(--on-surface-variant);">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">fingerprint</span> ISBN: 978-0387683461
                                                    </div>
                                                    <div class="d-flex align-items-center gap-2 font-label-md" style="color: var(--on-surface-variant);">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">barcode</span> ID: LUM-88293-XP
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="bg-lowest p-4 rounded-3 border h-100 tonal-elevation-1"
                                             style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                            <div class="d-flex align-items-center gap-3 mb-4">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center text-dark"
                                                     style="width: 48px; height: 48px; background-color: var(--secondary-container);">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div>
                                                    <h3 class="font-title-lg text-dark mb-0" style="line-height: 1;">Julian Thorne</h3>
                                                    <p class="font-body-sm text-secondary-custom mb-0 mt-1">Sinh viên ID: 2023-ST-0442</p>
                                                </div>
                                            </div>
                                            <div class="row g-3">
                                                <div class="col-6">
                                                    <div class="bg-low p-2 rounded-3 text-center">
                                                        <p class="font-label-md mb-1" style="color: var(--on-surface-variant);">Loại thành viên</p>
                                                        <p class="font-body-md fw-bold text-primary-custom mb-0">Undergraduate</p>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="bg-low p-2 rounded-3 text-center">
                                                        <p class="font-label-md mb-1" style="color: var(--on-surface-variant);">Khoản mượn hiện tại</p>
                                                        <p class="font-body-md fw-bold text-primary-custom mb-0">3 / 5</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mt-4 d-flex justify-content-between align-items-center font-body-sm">
                                                <span class="text-secondary-custom">Hạn trả:</span>
                                                <span class="text-danger fw-bold d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined" style="font-size: 16px;">warning</span> 2 Ngày quá hạn
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                </c:if>

                                <%-- Condition Assessment --%>
                                <section class="bg-lowest p-4 rounded-3 border tonal-elevation-1"
                                         style="border-color: rgba(224, 192, 177, 0.2) !important;">
                                    <div class="d-flex align-items-center gap-2 mb-4">
                                        <span class="material-symbols-outlined text-primary-custom">analytics</span>
                                        <h3 class="font-title-lg text-dark mb-0">Đánh giá tình trạng</h3>
                                        <span class="text-muted fst-italic ms-2" style="font-size: 10px;">Cập nhật trạng thái bản sao sách</span>
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-4">
                                            <label class="condition-label d-block" style="cursor: pointer;">
                                                <input checked name="condition" type="radio" value="GOOD" />
                                                <div class="condition-box">
                                                    <span class="material-symbols-outlined text-primary-custom fs-2">verified</span>
                                                    <span class="font-label-md fw-bold text-dark">Tốt</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-4">
                                            <label class="condition-label d-block" style="cursor: pointer;">
                                                <input name="condition" type="radio" value="DAMAGED" />
                                                <div class="condition-box">
                                                    <span class="material-symbols-outlined fs-2" style="color: var(--on-surface-variant);">heart_broken</span>
                                                    <span class="font-label-md fw-bold text-dark">Bị hỏng</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-4">
                                            <label class="condition-label d-block" style="cursor: pointer;">
                                                <input name="condition" type="radio" value="LOST" />
                                                <div class="condition-box">
                                                    <span class="material-symbols-outlined text-danger fs-2">dangerous</span>
                                                    <span class="font-label-md fw-bold text-dark">Bị mất</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <textarea class="form-control bg-low border-0 rounded-3 p-3 font-body-sm"
                                                  rows="3"
                                                  name="conditionNote"
                                                  placeholder="Tùy chọn: Ghi chú hư hỏng cụ thể (VD: ướt nước, rách gáy sách)..."></textarea>
                                    </div>
                                </section>

                            </div>
                        </div><%-- /col-lg-8 --%>

                        <%-- Right Sidebar Column: Fine & Action --%>
                        <div class="col-12 col-lg-4">
                            <div class="d-flex flex-column gap-4 position-sticky" style="top: 24px;">

                                <%-- Fine Calculation Summary --%>
                                <section class="bg-lowest p-4 rounded-3 border tonal-elevation-2">
                                    <h3 class="font-title-lg text-dark mb-4">Tính tiền phạt</h3>
                                    <div class="d-flex flex-column gap-3 mb-4">
                                        <div class="d-flex justify-content-between align-items-center font-body-md">
                                            <span class="text-secondary-custom">
                                                Phí quá hạn (<c:out value="${borrowRecord.overdueDays != null ? borrowRecord.overdueDays : '2'}" /> ngày)
                                            </span>
                                            <span class="text-dark fw-semibold" id="side-overdue-fee">
                                                <c:out value="${borrowRecord.overdueFine != null ? borrowRecord.overdueFine : '10,000đ'}" />
                                            </span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center font-body-md">
                                            <span class="text-secondary-custom">Phí hỏng/mất sách</span>
                                            <span class="text-dark fw-semibold" id="side-damage-fee">0đ</span>
                                        </div>
                                        <div class="border-top pt-3 mt-1 d-flex justify-content-between align-items-center">
                                            <span class="fw-bold font-title-lg text-dark">Tổng số tiền</span>
                                            <span class="fw-bold font-headline-md text-primary-custom" id="side-total-fee">
                                                <c:out value="${borrowRecord.overdueFine != null ? borrowRecord.overdueFine : '10,000đ'}" />
                                            </span>
                                        </div>
                                    </div>

                                    <div class="p-3 rounded-3 mb-4 d-flex align-items-start gap-3"
                                         style="background-color: rgba(255,219,202,0.2);">
                                        <span class="material-symbols-outlined text-primary-custom" style="font-size: 16px; margin-top: 2px;">info</span>
                                        <p class="font-body-sm mb-0" style="color: var(--on-primary-fixed-variant);">
                                            Tiền phạt sẽ tự động được thêm vào số dư tài khoản của người mượn.
                                        </p>
                                    </div>

                                    <div class="d-flex flex-column gap-3">
                                        <div class="form-check d-flex align-items-center gap-2 m-0" style="cursor: pointer;">
                                            <input checked class="form-check-input m-0 border-secondary-subtle"
                                                   style="width: 20px; height: 20px;"
                                                   type="checkbox"
                                                   id="notifyEmail"
                                                   name="notifyEmail"
                                                   value="true" />
                                            <label class="form-check-label font-body-sm text-dark ms-1" for="notifyEmail">
                                                Thông báo cho người mượn qua email
                                            </label>
                                        </div>
                                        <button class="btn btn-scale-active w-100 py-3 fw-bold rounded-3 text-white shadow d-flex align-items-center justify-content-center gap-2 border-0"
                                                style="background-color: var(--primary-container);"
                                                type="submit"
                                                form="return_form">
                                            <span class="material-symbols-outlined">task_alt</span> Xử lý trả &amp; Chốt tiền phạt
                                        </button>
                                        <a href="${pageContext.request.contextPath}/librarian/borrow-list"
                                           class="btn w-100 py-2 font-body-md text-secondary-custom fw-bold rounded-3 border-0 text-decoration-none text-center"
                                           style="background-color: var(--surface-container-highest);">
                                            Hủy thao tác
                                        </a>
                                    </div>
                                </section>

                                <%-- Policy Tip --%>
                                <section class="p-4 rounded-3 bg-low border-start border-4"
                                         style="border-color: rgba(157,67,0,0.5) !important;">
                                    <h4 class="font-label-md text-primary-custom text-uppercase mb-2">Mẹo chính sách thư viện</h4>
                                    <p class="font-body-sm text-secondary-custom fst-italic mb-0">
                                        "Tiền phạt quá hạn tối đa là 100.000đ mỗi mục. Trạng thái bị hỏng phải được Thủ thư trưởng phê duyệt đối với các mục trị giá trên 500.000đ."
                                    </p>
                                </section>

                            </div>
                        </div><%-- /col-lg-4 --%>
                    </div><%-- /row --%>

                </form>

                <%-- Bottom Log Table Section --%>
                <section class="mt-4 bg-lowest p-4 rounded-3 border tonal-elevation-1"
                         style="border-color: rgba(224, 192, 177, 0.2) !important;">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div class="d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined text-primary-custom">history</span>
                            <h3 class="font-title-lg text-dark mb-0">Nhật ký trả gần đây</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/librarian/borrow-list"
                           class="btn btn-link p-0 font-label-md text-primary-custom text-decoration-none shadow-none">Xem toàn bộ lịch sử</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0 text-start">
                            <thead>
                                <tr class="border-bottom font-label-md text-secondary-custom text-uppercase"
                                    style="font-size: 12px;">
                                    <th class="py-3 border-0">Thời gian</th>
                                    <th class="py-3 border-0">ID sách</th>
                                    <th class="py-3 border-0">Người mượn</th>
                                    <th class="py-3 border-0">Tình trạng</th>
                                    <th class="py-3 text-end border-0">Tiền phạt</th>
                                    <th class="py-3 text-center border-0">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody class="font-body-sm text-dark">
                                <c:choose>
                                    <c:when test="${not empty recentReturns}">
                                        <c:forEach var="log" items="${recentReturns}">
                                            <tr class="border-bottom">
                                                <td class="py-3 text-muted">
                                                    <fmt:formatDate value="${log.returnTime}" pattern="HH:mm" />
                                                </td>
                                                <td class="py-3 fw-semibold"><c:out value="${log.bookCopyBarcode}" /></td>
                                                <td class="py-3"><c:out value="${log.borrowerName}" /></td>
                                                <td class="py-3 ${log.condition == 'DAMAGED' ? 'text-danger fw-semibold' : ''}">
                                                    <c:out value="${log.condition}" />
                                                </td>
                                                <td class="py-3 text-end"><c:out value="${log.fine}" /></td>
                                                <td class="py-3 text-center">
                                                    <span class="badge rounded-pill px-2 py-1"
                                                          style="background-color: rgba(255,219,202,0.2); color: var(--on-primary-fixed-variant); font-size: 12px;">Đã xử lý</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="border-bottom">
                                            <td class="py-3 text-muted">14:22</td>
                                            <td class="py-3 fw-semibold">LUM-10294-AB</td>
                                            <td class="py-3">Elena Rodriguez</td>
                                            <td class="py-3">Tốt</td>
                                            <td class="py-3 text-end">0đ</td>
                                            <td class="py-3 text-center">
                                                <span class="badge rounded-pill px-2 py-1"
                                                      style="background-color: rgba(255,219,202,0.2); color: var(--on-primary-fixed-variant); font-size: 12px;">Đã xử lý</span>
                                            </td>
                                        </tr>
                                        <tr class="border-bottom">
                                            <td class="py-3 text-muted">14:15</td>
                                            <td class="py-3 fw-semibold">LUM-55231-ZZ</td>
                                            <td class="py-3">Marcus Chen</td>
                                            <td class="py-3 text-danger fw-semibold">Bị hỏng</td>
                                            <td class="py-3 text-end">75,000đ</td>
                                            <td class="py-3 text-center">
                                                <span class="badge rounded-pill px-2 py-1"
                                                      style="background-color: rgba(255,219,202,0.2); color: var(--on-primary-fixed-variant); font-size: 12px;">Đã xử lý</span>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

            </div><%-- /container --%>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><%-- /.main-wrapper --%>

</body>

<%-- Page-specific styles --%>
<style>
    .tonal-elevation-1 { box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04); }
    .tonal-elevation-2 { box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08); }
    .font-headline-lg { font-size: 32px; line-height: 40px; letter-spacing: -0.01em; font-weight: 600; }
    .font-title-lg { font-size: 20px; line-height: 28px; font-weight: 600; }
    .font-body-md { font-size: 16px; line-height: 24px; font-weight: 400; }
    .font-body-sm { font-size: 14px; line-height: 20px; font-weight: 400; }
    .font-label-md { font-size: 12px; line-height: 16px; letter-spacing: 0.05em; font-weight: 600; }
    .bg-lowest { background-color: var(--surface-container-lowest); }
    .bg-low { background-color: var(--surface-container-low); }
    .text-secondary-custom { color: var(--secondary); }
    .text-primary-custom { color: var(--primary); }
    .condition-label input[type="radio"] { display: none; }
    .condition-box {
        padding: 16px; border: 2px solid rgba(224, 192, 177, 0.3);
        border-radius: 12px; display: flex; flex-direction: column;
        align-items: center; gap: 8px; transition: all 0.2s ease;
    }
    .condition-label:hover .condition-box { background-color: var(--surface-container-low); }
    .condition-label input[type="radio"]:checked + .condition-box {
        border-color: var(--primary-container);
        background-color: rgba(255, 219, 202, 0.3);
    }
    .btn-scale-active:active { transform: scale(0.97); }
</style>

<%-- Page-specific JS: condition change → fee recalculation --%>
<script>
    const radioButtons = document.querySelectorAll('input[name="condition"]');
    const damageFeeDisplay = document.getElementById('side-damage-fee');
    const totalDisplay = document.getElementById('side-total-fee');
    const baseFine = 10000;

    radioButtons.forEach(radio => {
        radio.addEventListener('change', (e) => {
            let damageFee = 0;
            const label = e.target.nextElementSibling.querySelector('span:last-child').textContent.trim();
            if (label === 'Bị hỏng') damageFee = 75000;
            else if (label === 'Bị mất') damageFee = 200000;

            damageFeeDisplay.textContent = damageFee.toLocaleString('vi-VN') + 'đ';
            const total = baseFine + damageFee;
            totalDisplay.textContent = total.toLocaleString('vi-VN') + 'đ';

            totalDisplay.style.transform = 'scale(1.08)';
            totalDisplay.style.transition = 'transform 0.1s ease';
            setTimeout(() => { totalDisplay.style.transform = 'scale(1)'; }, 200);
        });
    });
</script>

</html>
