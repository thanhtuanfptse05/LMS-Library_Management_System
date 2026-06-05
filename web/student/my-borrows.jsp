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

                                <div class="px-4 pb-5 pt-4" style="max-width: 1280px; margin: 0 auto;">

                                    <%-- ─── Alert Messages ─── --%>
                                        <c:if test="${not empty sessionScope.successMessage}">
                                            <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4"
                                                role="alert">
                                                <span class="material-symbols-outlined me-2">check_circle</span>
                                                <c:out value="${sessionScope.successMessage}" />
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Đóng"></button>
                                            </div>
                                            <c:remove var="successMessage" scope="session" />
                                        </c:if>

                                        <%-- ─── Page Header ─── --%>
                                            <section
                                                class="d-flex flex-column flex-md-row justify-content-between gap-3 mb-4">
                                                <div>
                                                    <h2 class="font-headline-lg text-dark mb-1">Lịch sử mượn sách</h2>
                                                    <p class="font-body-md text-secondary-custom mb-0">Quản lý sách đang mượn và xem hành trình đọc của bạn.</p>
                                                </div>
                                                <div class="d-flex align-items-end">
                                                    <button
                                                        class="btn btn-sm d-flex align-items-center gap-1 px-3 py-2 border text-secondary-custom font-label-md"
                                                        style="border-color: var(--outline) !important; border-radius: 8px;">
                                                        <span class="material-symbols-outlined"
                                                            style="font-size: 20px;">download</span> Xuất PDF
                                                    </button>
                                                </div>
                                            </section>

                                            <%-- ─── Summary Bento Grid ─── --%>
                                                <section class="row g-4 mb-4">
                                                    <div class="col-12 col-sm-6 col-lg-3">
                                                        <div class="bg-lowest p-4 rounded-3 border premium-card d-flex flex-column gap-1 shadow-sm"
                                                            style="border-color: var(--outline-variant) !important;">
                                                            <span class="font-label-md text-secondary-custom">Sách đang mượn</span>
                                                            <div
                                                                class="d-flex align-items-baseline justify-content-between mt-2">
                                                                <span class="font-display text-primary-custom">
                                                                    <c:out
                                                                        value="${activeCount != null ? activeCount : '03'}" />
                                                                </span>
                                                                <div class="p-2 rounded-3"
                                                                    style="background-color: var(--primary-fixed); color: var(--on-primary-fixed);">
                                                                    <span
                                                                        class="material-symbols-outlined">menu_book</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-12 col-sm-6 col-lg-3">
                                                        <div class="bg-lowest p-4 rounded-3 border premium-card d-flex flex-column gap-1 shadow-sm"
                                                            style="border-color: var(--outline-variant) !important;">
                                                            <span class="font-label-md text-secondary-custom">Sách quá hạn</span>
                                                            <div
                                                                class="d-flex align-items-baseline justify-content-between mt-2">
                                                                <span class="font-display text-danger">
                                                                    <c:out
                                                                        value="${overdueCount != null ? overdueCount : '01'}" />
                                                                </span>
                                                                <div class="p-2 rounded-3"
                                                                    style="background-color: var(--error-container); color: var(--on-error-container);">
                                                                    <span
                                                                        class="material-symbols-outlined">warning</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-12 col-sm-6 col-lg-3">
                                                        <div class="bg-lowest p-4 rounded-3 border premium-card d-flex flex-column gap-1 shadow-sm"
                                                            style="border-color: var(--outline-variant) !important;">
                                                            <span class="font-label-md text-secondary-custom">Tổng số sách đã mượn</span>
                                                            <div
                                                                class="d-flex align-items-baseline justify-content-between mt-2">
                                                                <span class="font-display text-dark">
                                                                    <c:out
                                                                        value="${lifetimeLoans != null ? lifetimeLoans : '42'}" />
                                                                </span>
                                                                <div class="p-2 rounded-3"
                                                                    style="background-color: var(--surface-container); color: var(--secondary);">
                                                                    <span
                                                                        class="material-symbols-outlined">history_edu</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-12 col-sm-6 col-lg-3">
                                                        <div class="p-4 rounded-3 premium-card d-flex flex-column gap-1 text-white shadow-lg position-relative overflow-hidden"
                                                            style="background-color: var(--primary-container); box-shadow: 0 8px 24px rgba(249, 115, 22, 0.2) !important;">
                                                            <div class="position-absolute rounded-circle"
                                                                style="right: -16px; top: -16px; width: 96px; height: 96px; background-color: rgba(255,255,255,0.1); filter: blur(24px);">
                                                            </div>
                                                            <span
                                                                class="font-label-md opacity-90 position-relative z-1">Hạn trả tiếp theo</span>
                                                            <div
                                                                class="d-flex align-items-baseline justify-content-between mt-2 position-relative z-1">
                                                                <span class="font-headline-lg">
                                                                    <c:choose>
                                                                        <c:when test="${not empty nextDueDate}">
                                                                            <fmt:formatDate value="${nextDueDate}"
                                                                                pattern="MMM dd" />
                                                                        </c:when>
                                                                        <c:otherwise>Oct 24</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                                <span class="material-symbols-outlined">event</span>
                                                            </div>
                                                            <p class="small fw-medium mt-auto mb-0 position-relative z-1 text-truncate"
                                                                style="max-width: 100%;">
                                                                <c:out
                                                                    value="${not empty nextDueBook ? nextDueBook : 'Calculus: A New Horizon'}" />
                                                            </p>
                                                        </div>
                                                    </div>
                                                </section>

                                                <%-- ─── Currently Borrowed Grid ─── --%>
                                                    <section class="mb-5">
                                                        <div
                                                            class="d-flex align-items-center justify-content-between mb-3">
                                                            <h3 class="font-title-lg text-dark mb-0">Sách đang mượn
                                                            </h3>
                                                            <a class="text-primary-custom font-label-md text-decoration-none d-flex align-items-center gap-1"
                                                                href="${pageContext.request.contextPath}/student/borrow-policy">
                                                                Xem chính sách <span class="material-symbols-outlined"
                                                                    style="font-size: 14px;">open_in_new</span>
                                                            </a>
                                                        </div>

                                                        <div class="row g-4">
                                                            <c:choose>
                                                                <c:when test="${not empty currentBorrows}">
                                                                    <c:forEach var="borrow" items="${currentBorrows}">
                                                                        <div class="col-12 col-lg-6">
                                                                            <div class="bg-lowest p-3 rounded-3 border shadow-sm d-flex gap-3 premium-card"
                                                                                style="border-color: var(--outline-variant) !important;">
                                                                                <div
                                                                                    class="book-cover-wrapper bg-light rounded-2 overflow-hidden flex-shrink-0 shadow-sm border border-light-subtle position-relative">
                                                                                    <img alt="<c:out value='${borrow.bookTitle}' />"
                                                                                        class="w-100 h-100 object-fit-cover"
                                                                                        src="<c:out value='${borrow.bookCoverUrl}' />" />
                                                                                    <c:if test="${borrow.overdue}">
                                                                                        <div class="position-absolute top-0 start-0 m-2 bg-danger text-white px-2 rounded"
                                                                                            style="font-size: 8px; font-weight: 700; letter-spacing: 0.05em;">
                                                                                            Quá hạn</div>
                                                                                    </c:if>
                                                                                </div>
                                                                                <div
                                                                                    class="d-flex flex-column flex-grow-1 py-1">
                                                                                    <div
                                                                                        class="d-flex justify-content-between align-items-start">
                                                                                        <div>
                                                                                            <h4 class="font-title-lg text-dark mb-0"
                                                                                                style="font-size: 18px;">
                                                                                                <c:out
                                                                                                    value="${borrow.bookTitle}" />
                                                                                            </h4>
                                                                                            <p
                                                                                                class="text-secondary-custom font-body-sm mb-0 mt-1">
                                                                                                <c:out
                                                                                                    value="${borrow.bookAuthor}" />
                                                                                            </p>
                                                                                        </div>
                                                                                        <span
                                                                                            class="badge font-label-md rounded-pill tracking-wider px-2 py-1 border"
                                                                                            style="${borrow.overdue ?
                                                                  'background-color: var(--error-container); color: var(--on-error-container); border-color: rgba(186,26,26,0.2) !important;' :
                                                                  'background-color: var(--secondary-container); color: var(--on-secondary-container); border-color: rgba(86,94,116,0.2) !important;'}
                                                                  font-size: 10px;">
                                                                                            ${borrow.overdue ?
                                                                                            'NGHIÊM TRỌNG' : 'ĐANG MƯỢN'}
                                                                                        </span>
                                                                                    </div>
                                                                                    <div
                                                                                        class="row g-2 mt-auto mb-3 pt-3">
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                NGÀY MƯỢN</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold text-dark mb-0 mt-1">
                                                                                                <fmt:formatDate
                                                                                                    value="${borrow.borrowDate}"
                                                                                                    pattern="MMM dd, yyyy" />
                                                                                            </p>
                                                                                        </div>
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                HẠN TRẢ</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold mb-0 mt-1 ${borrow.overdue ? 'text-danger' : 'text-primary-custom'}">
                                                                                                <fmt:formatDate
                                                                                                    value="${borrow.dueDate}"
                                                                                                    pattern="MMM dd, yyyy" />
                                                                                            </p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${borrow.overdue}">
                                                                                            <a href="${pageContext.request.contextPath}/student/pay-fine?borrowId=${borrow.borrowId}"
                                                                                                class="btn btn-sm interactive-btn w-100 py-2 fw-bold text-decoration-none text-center border"
                                                                                                style="background-color: var(--error-container); color: var(--on-error-container); border-color: rgba(186,26,26,0.1) !important; border-radius: 8px; font-size: 14px;">
                                                                                                Nộp phạt &amp; Gia hạn
                                                                                            </a>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/student/borrow-renew"
                                                                                                method="post">
                                                                                                <input type="hidden"
                                                                                                    name="borrowId"
                                                                                                    value="${borrow.borrowId}" />
                                                                                                <button
                                                                                                    class="btn btn-sm interactive-btn w-100 py-2 fw-bold text-white shadow-sm border-0"
                                                                                                    style="background-color: var(--primary); border-radius: 8px; font-size: 14px;">Gia hạn</button>
                                                                                            </form>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <%-- Sample items --%>
                                                                        <div class="col-12 col-lg-6">
                                                                            <div class="bg-lowest p-3 rounded-3 border shadow-sm d-flex gap-3 premium-card"
                                                                                style="border-color: var(--outline-variant) !important;">
                                                                                <div
                                                                                    class="book-cover-wrapper bg-light rounded-2 overflow-hidden flex-shrink-0 shadow-sm border border-light-subtle position-relative">
                                                                                    <img alt="Book cover"
                                                                                        class="w-100 h-100 object-fit-cover"
                                                                                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuA3WPM3I-G32TrTtJf06pbW4jo7hEM5mrMDeh7jcpky2Iewtu-7nGoNA75DbXbjnHOyChbfnoEqXhEGm0Xi6ADsrNRtC6Ak1e00PCkBrH6AGBRUk2zU07-5et67L-MXcetG1ksw893iKofp2ecqZGWpo9Dywoa6RSa2EQfZ1V0XQQh128KdzHLw5TdtEwsnRaMuJPXEuud0FGGtYlD9oBObDyqjaGJ0Xma9oKqXgHlWXE71_j4rQjbLQJRkl-WpgSv0rvVbDJsessU" />
                                                                                    <div class="position-absolute top-0 start-0 m-2 bg-danger text-white px-2 rounded"
                                                                                        style="font-size: 8px; font-weight: 700;">
                                                                                        Quá hạn</div>
                                                                                </div>
                                                                                <div
                                                                                    class="d-flex flex-column flex-grow-1 py-1">
                                                                                    <div
                                                                                        class="d-flex justify-content-between align-items-start">
                                                                                        <div>
                                                                                            <h4 class="font-title-lg text-dark mb-0"
                                                                                                style="font-size: 18px;">
                                                                                                Calculus: A New Horizon
                                                                                            </h4>
                                                                                            <p
                                                                                                class="text-secondary-custom font-body-sm mb-0 mt-1">
                                                                                                Howard Anton</p>
                                                                                        </div>
                                                                                        <span
                                                                                            class="badge font-label-md rounded-pill px-2 py-1 border"
                                                                                            style="background-color: var(--error-container); color: var(--on-error-container); border-color: rgba(186,26,26,0.2) !important; font-size: 10px;">NGHIÊM TRỌNG</span>
                                                                                    </div>
                                                                                    <div
                                                                                        class="row g-2 mt-auto mb-3 pt-3">
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                NGÀY MƯỢN</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold text-dark mb-0 mt-1">
                                                                                                Oct 01, 2023</p>
                                                                                        </div>
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                HẠN TRẢ</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold text-danger mb-0 mt-1">
                                                                                                Oct 15, 2023</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <button
                                                                                        class="btn btn-sm interactive-btn w-100 py-2 fw-bold border"
                                                                                        style="background-color: var(--error-container); color: var(--on-error-container); border-color: rgba(186,26,26,0.1) !important; border-radius: 8px; font-size: 14px;">
                                                                                        Nộp phạt &amp; Gia hạn
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-12 col-lg-6">
                                                                            <div class="bg-lowest p-3 rounded-3 border shadow-sm d-flex gap-3 premium-card"
                                                                                style="border-color: var(--outline-variant) !important;">
                                                                                <div
                                                                                    class="book-cover-wrapper bg-light rounded-2 overflow-hidden flex-shrink-0 shadow-sm border border-light-subtle">
                                                                                    <img alt="Book cover"
                                                                                        class="w-100 h-100 object-fit-cover"
                                                                                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuAyJ86uGq11oLiuF3vP2O04ctA5nEQWppWkVYRCMYMSUhizMqYmnQgI4e1M0awwpGj08cA3N3-ZiCw-v1NWRS7kt66exPLh4woMNKTbOl8VZTeRHeIW0h2z5pWn3sAYHzNsDRyFaDJhNjfdEVyCnNJvVzjcJCJor4v2_hoXTnMQKI5l9sI2xXrYWxuYl8Sa7oa8yyCTPADVpA2FTtpuLc2ZBAjnDHkb0PWFjgjXGJmlhZj0P7jx8apFYlAOjCBWSZ_9orE-WmYRgOY" />
                                                                                </div>
                                                                                <div
                                                                                    class="d-flex flex-column flex-grow-1 py-1">
                                                                                    <div
                                                                                        class="d-flex justify-content-between align-items-start">
                                                                                        <div>
                                                                                            <h4 class="font-title-lg text-dark mb-0"
                                                                                                style="font-size: 18px;">
                                                                                                The Art of Computing
                                                                                            </h4>
                                                                                            <p
                                                                                                class="text-secondary-custom font-body-sm mb-0 mt-1">
                                                                                                Donald Knuth</p>
                                                                                        </div>
                                                                                        <span
                                                                                            class="badge font-label-md rounded-pill px-2 py-1 border"
                                                                                            style="background-color: var(--secondary-container); color: var(--on-secondary-container); border-color: rgba(86,94,116,0.2) !important; font-size: 10px;">IN
                                                                                            ĐANG MƯỢN</span>
                                                                                    </div>
                                                                                    <div
                                                                                        class="row g-2 mt-auto mb-3 pt-3">
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                NGÀY MƯỢN</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold text-dark mb-0 mt-1">
                                                                                                Oct 10, 2023</p>
                                                                                        </div>
                                                                                        <div class="col-6">
                                                                                            <p class="mb-0 text-secondary-custom"
                                                                                                style="font-size: 10px; font-weight: 700; text-transform: uppercase;">
                                                                                                HẠN TRẢ</p>
                                                                                            <p
                                                                                                class="font-body-sm fw-semibold text-primary-custom mb-0 mt-1">
                                                                                                Oct 31, 2023</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <button
                                                                                        class="btn btn-sm interactive-btn w-100 py-2 fw-bold text-white shadow-sm border-0"
                                                                                        style="background-color: var(--primary); border-radius: 8px; font-size: 14px;">Gia hạn</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </section>

                                                    <%-- ─── Borrowing History Table ─── --%>
                                                        <section
                                                            class="bg-lowest rounded-3 border overflow-hidden shadow-sm"
                                                            style="border-color: var(--outline-variant) !important;">
                                                            <div class="px-4 py-3 border-bottom d-flex align-items-center justify-content-between bg-lowest"
                                                                style="border-color: var(--surface-container) !important;">
                                                                <h3 class="font-title-lg text-dark mb-0">Lịch sử mượn sách</h3>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn btn-link p-2 text-secondary-custom rounded-3 shadow-none border-0">
                                                                        <span
                                                                            class="material-symbols-outlined">filter_list</span>
                                                                    </button>
                                                                    <button
                                                                        class="btn btn-link p-2 text-secondary-custom rounded-3 shadow-none border-0">
                                                                        <span
                                                                            class="material-symbols-outlined">search</span>
                                                                    </button>
                                                                </div>
                                                            </div>

                                                            <div class="table-responsive">
                                                                <table
                                                                    class="table table-hover align-middle mb-0 text-start">
                                                                    <thead>
                                                                        <tr class="bg-low text-secondary-custom border-bottom"
                                                                            style="border-color: var(--outline-variant) !important; font-size: 12px;">
                                                                            <th
                                                                                class="px-4 py-3 font-label-md text-uppercase border-0">
                                                                                Tiêu đề</th>
                                                                            <th
                                                                                class="px-4 py-3 font-label-md text-uppercase border-0">
                                                                                Ngày trả</th>
                                                                            <th
                                                                                class="px-4 py-3 font-label-md text-uppercase border-0">
                                                                                Thời hạn</th>
                                                                            <th
                                                                                class="px-4 py-3 font-label-md text-uppercase border-0">
                                                                                Đánh giá</th>
                                                                            <th
                                                                                class="px-4 py-3 font-label-md text-uppercase text-end border-0">
                                                                                Hành động</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody class="table-group-divider border-0">
                                                                        <c:choose>
                                                                            <c:when test="${not empty borrowHistory}">
                                                                                <c:forEach var="hist"
                                                                                    items="${borrowHistory}">
                                                                                    <tr class="border-bottom"
                                                                                        style="border-color: var(--surface-container) !important;">
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex align-items-center gap-3">
                                                                                                <div class="book-thumb-wrapper bg-light rounded overflow-hidden shadow-sm border flex-shrink-0"
                                                                                                    style="border-color: var(--outline-variant) !important;">
                                                                                                    <img alt="<c:out value='${hist.bookTitle}' />"
                                                                                                        class="w-100 h-100"
                                                                                                        style="object-fit: cover;"
                                                                                                        src="<c:out value='${hist.bookCoverUrl}' />" />
                                                                                                </div>
                                                                                                <div>
                                                                                                    <p
                                                                                                        class="fw-bold font-body-sm text-dark mb-0">
                                                                                                        <c:out
                                                                                                            value="${hist.bookTitle}" />
                                                                                                    </p>
                                                                                                    <p class="mb-0 text-secondary-custom"
                                                                                                        style="font-size: 12px;">
                                                                                                        <c:out
                                                                                                            value="${hist.bookAuthor}" />
                                                                                                    </p>
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            <fmt:formatDate
                                                                                                value="${hist.returnDate}"
                                                                                                pattern="MMM dd, yyyy" />
                                                                                        </td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            <c:out
                                                                                                value="${hist.durationDays}" />
                                                                                            ngày
                                                                                        </td>
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex text-primary-custom">
                                                                                                <c:forEach begin="1"
                                                                                                    end="5" var="star">
                                                                                                    <span class="material-symbols-outlined"
                                                                                                        style="font-size: 18px; <c:if test='${star <= hist.rating}'>font-variation-settings: 'FILL' 1;</c:if>">star</span>
                                                                                                </c:forEach>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="px-4 py-3 text-end">
                                                                                            <button
                                                                                                class="btn btn-sm interactive-btn fw-bold font-body-sm px-3 py-2 border-0"
                                                                                                style="color: var(--primary); background-color: transparent; border-radius: 8px;"
                                                                                                onmouseover="this.style.backgroundColor='var(--primary-fixed)'"
                                                                                                onmouseout="this.style.backgroundColor='transparent'"
                                                                                                onclick="location.href='${pageContext.request.contextPath}/student/reserve?bookId=${hist.bookId}'">
                                                                                                Mượn lại
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <%-- Sample history rows --%>
                                                                                    <tr class="border-bottom"
                                                                                        style="border-color: var(--surface-container) !important;">
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex align-items-center gap-3">
                                                                                                <div class="book-thumb-wrapper bg-light rounded overflow-hidden shadow-sm border flex-shrink-0"
                                                                                                    style="border-color: var(--outline-variant) !important;">
                                                                                                    <img alt="Principles of Physics"
                                                                                                        class="w-100 h-100"
                                                                                                        style="object-fit: cover;"
                                                                                                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuDWsL2Qu914bfgZ8x07fPQhP1ue63dC6G58aWWYOEpIiitOdDcEy3dc4-CFAYHM8eZh_hOo2FJXWruA-SxV-egjG2UrcUiSjOVXrtByieliCcUscO1FXgtUDVOocrSPGibCaSHD8dgzPPZdgMSeVlJ_RcDcgTg7Na5zjJB7KixeZv3RnSMGjP9TEyGX4UHMa_dUNvb6RKxDKpy5bGAnox6PQB9Oo9lTH4NVfcnRSKersXk4pn_wMfA1k7rUTV2qyxwS8XM-wGqUtLk" />
                                                                                                </div>
                                                                                                <div>
                                                                                                    <p
                                                                                                        class="fw-bold font-body-sm text-dark mb-0">
                                                                                                        Principles of
                                                                                                        Physics</p>
                                                                                                    <p class="mb-0 text-secondary-custom"
                                                                                                        style="font-size: 12px;">
                                                                                                        Halliday &amp;
                                                                                                        Resnick</p>
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            Sep 14, 2023</td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            14 ngày</td>
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex text-primary-custom">
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px;">star</span>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="px-4 py-3 text-end">
                                                                                            <button
                                                                                                class="btn btn-sm interactive-btn fw-bold font-body-sm px-3 py-2 border-0"
                                                                                                style="color: var(--primary); background-color: transparent; border-radius: 8px;"
                                                                                                onmouseover="this.style.backgroundColor='var(--primary-fixed)'"
                                                                                                onmouseout="this.style.backgroundColor='transparent'">
                                                                                                Mượn lại
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr class="border-bottom"
                                                                                        style="border-color: var(--surface-container) !important;">
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex align-items-center gap-3">
                                                                                                <div class="book-thumb-wrapper bg-light rounded overflow-hidden shadow-sm border flex-shrink-0"
                                                                                                    style="border-color: var(--outline-variant) !important;">
                                                                                                    <img alt="Modern Architecture"
                                                                                                        class="w-100 h-100"
                                                                                                        style="object-fit: cover;"
                                                                                                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuDWFGUQFif7bnJutLt279fZ4z8m2-N4y7iKMGuLH7a7-W3Ut16qShsRiNlaKr6GG3op4e8ldbRh9eCAtMUfFDSGdNQlI8QlNdzpbBXTuMao3Oy7Lx57m-EaQIO0XW2iTsI-e7wCSpw_eOOMTIsGnuOC5aNDl9a2o-Ic81zZHylcEwc7Sq08htxNnIUcAeJKzIx7WoAZREBlPVjQPpf89lhl0nMHPsdZ3H9zGCrNbbgTkY0kc-MqlPJxXplNbQeLfV6KOlJPGfdo44I" />
                                                                                                </div>
                                                                                                <div>
                                                                                                    <p
                                                                                                        class="fw-bold font-body-sm text-dark mb-0">
                                                                                                        Modern
                                                                                                        Architecture</p>
                                                                                                    <p class="mb-0 text-secondary-custom"
                                                                                                        style="font-size: 12px;">
                                                                                                        Kenneth Frampton
                                                                                                    </p>
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            Aug 28, 2023</td>
                                                                                        <td
                                                                                            class="px-4 py-3 font-body-sm text-dark">
                                                                                            21 ngày</td>
                                                                                        <td class="px-4 py-3">
                                                                                            <div
                                                                                                class="d-flex text-primary-custom">
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 18px; font-variation-settings: 'FILL' 1;">star</span>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="px-4 py-3 text-end">
                                                                                            <button
                                                                                                class="btn btn-sm interactive-btn fw-bold font-body-sm px-3 py-2 border-0"
                                                                                                style="color: var(--primary); background-color: transparent; border-radius: 8px;"
                                                                                                onmouseover="this.style.backgroundColor='var(--primary-fixed)'"
                                                                                                onmouseout="this.style.backgroundColor='transparent'">
                                                                                                Mượn lại
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </tbody>
                                                                </table>
                                                            </div>

                                                            <%-- Pagination --%>
                                                                <div class="px-4 py-3 bg-low d-flex align-items-center justify-content-between border-top"
                                                                    style="border-color: var(--outline-variant) !important;">
                                                                    <span class="font-body-sm text-secondary-custom">
                                                                        Hiển thị 1-
                                                                        <c:out
                                                                            value="${pageSize != null ? pageSize : '10'}" />
                                                                        trên
                                                                        <c:out
                                                                            value="${lifetimeLoans != null ? lifetimeLoans : '42'}" />
                                                                        mục
                                                                    </span>
                                                                    <div class="d-flex gap-1 align-items-center">
                                                                        <button
                                                                            class="btn p-1 text-secondary-custom rounded shadow-none border-0"
                                                                            disabled style="opacity: 0.3;">
                                                                            <span
                                                                                class="material-symbols-outlined">chevron_left</span>
                                                                        </button>
                                                                        <button
                                                                            class="btn btn-sm px-3 py-1 rounded font-body-sm fw-bold border-0 text-white shadow-sm"
                                                                            style="background-color: var(--primary);">1</button>
                                                                        <button
                                                                            class="btn btn-sm px-3 py-1 rounded font-body-sm text-dark border-0"
                                                                            onmouseover="this.style.backgroundColor='var(--surface-container)'"
                                                                            onmouseout="this.style.backgroundColor='transparent'"
                                                                            style="transition: all 0.2s;">2</button>
                                                                        <button
                                                                            class="btn btn-sm px-3 py-1 rounded font-body-sm text-dark border-0"
                                                                            onmouseover="this.style.backgroundColor='var(--surface-container)'"
                                                                            onmouseout="this.style.backgroundColor='transparent'"
                                                                            style="transition: all 0.2s;">3</button>
                                                                        <button
                                                                            class="btn p-1 text-secondary-custom rounded shadow-none border-0">
                                                                            <span
                                                                                class="material-symbols-outlined">chevron_right</span>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                        </section>

                                </div><%-- /container --%>

                                    <jsp:include page="fragments/_footer.jsp" />

                            </main>
                    </div><%-- /.main-wrapper --%>

            </body>

            <%-- Page-specific styles --%>
                <style>
                    .font-headline-lg {
                        font-size: 32px;
                        line-height: 40px;
                        letter-spacing: -0.01em;
                        font-weight: 600;
                    }

                    .font-title-lg {
                        font-size: 20px;
                        line-height: 28px;
                        font-weight: 600;
                    }

                    .font-body-md {
                        font-size: 16px;
                        line-height: 24px;
                        font-weight: 400;
                    }

                    .font-body-sm {
                        font-size: 14px;
                        line-height: 20px;
                        font-weight: 400;
                    }

                    .font-label-md {
                        font-size: 12px;
                        line-height: 16px;
                        letter-spacing: 0.05em;
                        font-weight: 600;
                    }

                    .font-display {
                        font-size: 48px;
                        line-height: 56px;
                        letter-spacing: -0.02em;
                        font-weight: 700;
                    }

                    .bg-lowest {
                        background-color: var(--surface-container-lowest);
                    }

                    .bg-low {
                        background-color: var(--surface-container-low);
                    }

                    .text-secondary-custom {
                        color: var(--secondary);
                    }

                    .text-primary-custom {
                        color: var(--primary);
                    }

                    .premium-card {
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    }

                    .premium-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.08) !important;
                    }

                    .interactive-btn:active {
                        transform: scale(0.96);
                    }

                    .book-cover-wrapper {
                        width: 112px;
                        height: 168px;
                        position: relative;
                    }

                    .book-thumb-wrapper {
                        width: 40px;
                        height: 56px;
                    }
                </style>

            </html>