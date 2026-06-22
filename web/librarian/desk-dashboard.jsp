<%-- desk-dashboard.jsp — Bảng điều khiển nghiệp vụ tại quầy của thủ thư (F6) --%>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                    <!DOCTYPE html>
                    <html lang="vi">
                    <jsp:include page="fragments/_head.jsp" />
                    <style>
                        .status-badge {
                            font-weight: 600;
                            padding: 0.25rem 0.75rem;
                            border-radius: 50rem;
                            font-size: 0.75rem;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.25rem;
                        }

                        .status-active {
                            background-color: #d1fae5;
                            color: #065f46;
                        }

                        .status-locked {
                            background-color: #fee2e2;
                            color: #991b1b;
                        }

                        .list-section-header {
                            border-bottom: 2px solid var(--outline-variant);
                            padding-bottom: 0.5rem;
                            margin-bottom: 1rem;
                            font-size: 0.95rem;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                            font-weight: 700;
                            color: var(--on-surface-variant);
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .profile-card {
                            background: linear-gradient(135deg, var(--surface-container-low) 0%, var(--surface-container-high) 100%);
                            border: 1px solid var(--outline-variant);
                        }

                        /* ════ STYLE HỖ TRỢ MÁY QUÉT BARCODE ════ */
                        .btn-scan-active {
                            background-color: #d97706 !important;
                            /* Cam đậm */
                            border-color: #d97706 !important;
                            color: white !important;
                            animation: scan-pulse-animation 1.5s infinite ease-in-out;
                        }

                        @keyframes scan-pulse-animation {
                            0% {
                                opacity: 1;
                            }

                            50% {
                                opacity: 0.6;
                            }

                            100% {
                                opacity: 1;
                            }
                        }

                        @keyframes rotation {
                            from {
                                transform: rotate(0deg);
                            }

                            to {
                                transform: rotate(359deg);
                            }
                        }

                        .rotating-icon {
                            display: inline-block;
                            animation: rotation 2s infinite linear;
                        }
                    </style>

                    <body>

                        <%-- ════ SIDEBAR ════ --%>
                            <jsp:include page="fragments/_sidebar.jsp" />

                            <%-- ════ BODY WRAPPER ════ --%>
                            <div class="d-flex main-wrapper overflow-hidden">

                                    <%-- ════ MAIN CONTENT ════ --%>
                                    <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

                                        <%-- ════ HEADER ════ --%>
                                        <jsp:include page="fragments/_header.jsp" />

                                        <%-- ════ CONTENT ════ --%>
                                        <div class="container-fluid px-4 py-4">

                                                <%-- Breadcrumb --%>
                                                    <nav aria-label="breadcrumb" class="mb-3">
                                                        <ol class="breadcrumb small">
                                                            <li class="breadcrumb-item">
                                                                <a href="${pageContext.request.contextPath}/librarian/dashboard"
                                                                    class="text-primary-custom text-decoration-none">Bảng
                                                                    điều khiển</a>
                                                            </li>
                                                            <li class="breadcrumb-item active text-on-surface-variant"
                                                                aria-current="page">Quầy lưu thông</li>
                                                        </ol>
                                                    </nav>

                                                    <%-- Page Title --%>
                                                        <div
                                                            class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
                                                            <div class="d-flex align-items-center gap-3">
                                                                <div class="rounded-3 d-flex align-items-center justify-content-center"
                                                                    style="width:48px;height:48px;background-color:rgba(157,67,0,0.1);">
                                                                    <span
                                                                        class="material-symbols-outlined text-primary-custom"
                                                                        style="font-size:24px;">room_service</span>
                                                                </div>
                                                                <div>
                                                                    <h2 class="fw-bold mb-0"
                                                                        style="font-size:20px;color:var(--on-surface);">
                                                                        Quầy Lưu Thông Trung Tâm</h2>
                                                                    <p class="mb-0 small text-on-surface-variant">Tra
                                                                        cứu độc giả, mượn sách, nhận sách trả và duyệt
                                                                        thanh toán tiền mặt</p>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <%-- ════ FLASH MESSAGES ════ --%>
                                                            <c:if test="${not empty requestScope.successMessage}">
                                                                <div class="alert alert-success d-flex align-items-center gap-2 mb-4 rounded-3"
                                                                    role="alert">
                                                                    <span class="material-symbols-outlined"
                                                                        style="font-size:20px;">check_circle</span>
                                                                    <div>
                                                                        <c:out value="${requestScope.successMessage}" />
                                                                    </div>
                                                                </div>
                                                            </c:if>

                                                            <c:if test="${not empty requestScope.errorMessage}">
                                                                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4 rounded-3"
                                                                    role="alert">
                                                                    <span class="material-symbols-outlined"
                                                                        style="font-size:20px;">error</span>
                                                                    <div>
                                                                        <c:out value="${requestScope.errorMessage}" />
                                                                    </div>
                                                                </div>
                                                            </c:if>

                                                            <%-- ════ SEARCH AREA ════ --%>
                                                                <div class="raised-card p-4 mb-4">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/librarian/desk-dashboard"
                                                                        method="GET" class="row g-3 align-items-end">
                                                                        <div class="col-12 col-md-8 col-lg-6">
                                                                            <label for="memberCodeSearch"
                                                                                class="form-label fw-bold small text-on-surface-variant">
                                                                                Mã Số Độc Giả (Student/Lecturer Code)
                                                                            </label>
                                                                            <div class="input-group">
                                                                                <span class="input-group-text"
                                                                                    style="background:var(--surface-container-low);border-color:var(--outline-variant);">
                                                                                    <span
                                                                                        class="material-symbols-outlined"
                                                                                        style="font-size:18px;">search</span>
                                                                                </span>
                                                                                <input type="text" id="memberCodeSearch"
                                                                                    name="memberCode"
                                                                                    class="form-control"
                                                                                    placeholder="Ví dụ: SE170123, GD12345..."
                                                                                    value="${fn:escapeXml(requestScope.memberCode)}"
                                                                                required
                                                                                autofocus
                                                                                style="border-color:var(--outline-variant);">
                                                                                <button type="button"
                                                                                    class="btn btn-outline-secondary d-flex align-items-center gap-1 btn-scan"
                                                                                    onclick="toggleScanner('memberCodeSearch', this)"
                                                                                    style="border-color:var(--outline-variant);">
                                                                                    <span
                                                                                        class="material-symbols-outlined"
                                                                                        style="font-size:18px;">barcode_scanner</span>
                                                                                    <span>Quét</span>
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-12 col-md-4 col-lg-3">
                                                                            <button type="submit"
                                                                                class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">
                                                                                Tra Cứu Độc Giả
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>

                                                                <%-- ════ MAIN DASHBOARD CONTENT (ONLY WHEN SEARCHED)
                                                                    ════ --%>
                                                                    <c:if test="${not empty requestScope.searchedUser}">
                                                                        <div class="row g-4">

                                                                            <%-- PROFILE CARD --%>
                                                                                <div class="col-12 col-lg-4">
                                                                                    <div
                                                                                        class="profile-card rounded-4 p-4 h-100">
                                                                                        <div
                                                                                            class="d-flex align-items-center gap-3 mb-4">
                                                                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                                                                style="width:54px;height:54px;background-color:var(--primary);color:white;font-size:20px;">
                                                                                                ${not empty
                                                                                                requestScope.searchedProfile.fullName
                                                                                                ?
                                                                                                requestScope.searchedProfile.fullName.substring(0,
                                                                                                1).toUpperCase() : 'Đ'}
                                                                                            </div>
                                                                                            <div>
                                                                                                <h4 class="fw-bold mb-0"
                                                                                                    style="font-size:16px;">
                                                                                                    <c:out
                                                                                                        value="${requestScope.searchedProfile.fullName}" />
                                                                                                </h4>
                                                                                                <p
                                                                                                    class="text-on-surface-variant mb-0 small">
                                                                                                    Mã số: <strong>
                                                                                                        <c:out
                                                                                                            value="${requestScope.memberCode}" />
                                                                                                    </strong>
                                                                                                </p>
                                                                                            </div>
                                                                                        </div>

                                                                                        <hr
                                                                                            style="border-color:var(--outline-variant);">

                                                                                        <div
                                                                                            class="d-flex flex-column gap-3 small">
                                                                                            <div
                                                                                                class="d-flex justify-content-between">
                                                                                                <span
                                                                                                    class="text-on-surface-variant">Vai
                                                                                                    trò:</span>
                                                                                                <span
                                                                                                    class="fw-bold text-capitalize">
                                                                                                    <c:out
                                                                                                        value="${requestScope.searchedUser.role}" />
                                                                                                </span>
                                                                                            </div>
                                                                                            <div
                                                                                                class="d-flex justify-content-between">
                                                                                                <span
                                                                                                    class="text-on-surface-variant">Email:</span>
                                                                                                <span class="fw-bold">
                                                                                                    <c:out
                                                                                                        value="${requestScope.searchedUser.email}" />
                                                                                                </span>
                                                                                            </div>
                                                                                            <div
                                                                                                class="d-flex justify-content-between">
                                                                                                <span
                                                                                                    class="text-on-surface-variant">Số
                                                                                                    điện thoại:</span>
                                                                                                <span class="fw-bold">
                                                                                                    <c:out
                                                                                                        value="${requestScope.searchedProfile.phoneNumber}" />
                                                                                                </span>
                                                                                            </div>
                                                                                            <div
                                                                                                class="d-flex justify-content-between align-items-center">
                                                                                                <span
                                                                                                    class="text-on-surface-variant">Trạng
                                                                                                    thái tài
                                                                                                    khoản:</span>
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${requestScope.searchedUser.status == 'active'}">
                                                                                                        <span
                                                                                                            class="status-badge status-active">
                                                                                                            <span
                                                                                                                class="material-symbols-outlined"
                                                                                                                style="font-size:12px;">check_circle</span>
                                                                                                            Hoạt động
                                                                                                        </span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span
                                                                                                            class="status-badge status-locked">
                                                                                                            <span
                                                                                                                class="material-symbols-outlined"
                                                                                                                style="font-size:12px;">lock</span>
                                                                                                            Bị khóa
                                                                                                        </span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </div>
                                                                                            <c:if
                                                                                                test="${requestScope.searchedUser.status != 'active'}">
                                                                                                <div
                                                                                                    class="alert alert-danger p-2 mb-0 mt-2 rounded-3 small">
                                                                                                    <strong>Lý do
                                                                                                        khóa:</strong>
                                                                                                    <c:out
                                                                                                        value="${not empty requestScope.searchedUserLockReasons ? requestScope.searchedUserLockReasons : 'Nợ phạt quá hạn / Chưa thanh toán'}" />
                                                                                                </div>
                                                                                            </c:if>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>

                                                                                <%-- TRANSACTION OPERATIONS (QUICK
                                                                                    FORMS) --%>
                                                                                    <div class="col-12 col-lg-8">
                                                                                        <div
                                                                                            class="raised-card p-4 h-100">
                                                                                            <h4 class="fw-bold mb-4"
                                                                                                style="font-size:16px;color:var(--on-surface);">
                                                                                                Thao tác nhanh tại quầy
                                                                                            </h4>

                                                                                            <div class="row g-4">
                                                                                                <%-- Check-out Form --%>
                                                                                                    <div
                                                                                                        class="col-12 col-md-6">
                                                                                                        <div class="p-3 rounded-3"
                                                                                                            style="background-color:rgba(157,67,0,0.04);border:1px solid rgba(157,67,0,0.1);">
                                                                                                            <h5
                                                                                                                class="fw-bold small mb-2 d-flex align-items-center gap-2 text-primary-custom">
                                                                                                                <span
                                                                                                                    class="material-symbols-outlined"
                                                                                                                    style="font-size:18px;">published_with_changes</span>
                                                                                                                Giao
                                                                                                                sách
                                                                                                                (Check-out)
                                                                                                            </h5>
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${requestScope.searchedUser.status == 'active'}">
                                                                                                                    <form
                                                                                                                        action="${pageContext.request.contextPath}/librarian/checkout"
                                                                                                                        method="POST"
                                                                                                                        class="needs-validation"
                                                                                                                        novalidate>
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="memberCode"
                                                                                                                            value="${fn:escapeXml(requestScope.memberCode)}">
                                                                                                                        <div
                                                                                                                            class="mb-3">
                                                                                                                            <label
                                                                                                                                for="checkoutBarcode"
                                                                                                                                class="form-label small mb-1">Mã
                                                                                                                                vạch
                                                                                                                                bản
                                                                                                                                sao
                                                                                                                                (Barcode)</label>
                                                                                                                            <div
                                                                                                                                class="input-group input-group-sm">
                                                                                                                                <input
                                                                                                                                    type="text"
                                                                                                                                    id="checkoutBarcode"
                                                                                                                                    name="barcode"
                                                                                                                                    class="form-control form-control-sm"
                                                                                                                                    placeholder="Quét hoặc nhập barcode..."
                                                                                                                                    required>
                                                                                                                                <button
                                                                                                                                    type="button"
                                                                                                                                    class="btn btn-outline-primary d-flex align-items-center gap-1 btn-scan"
                                                                                                                                    onclick="toggleScanner('checkoutBarcode', this)">
                                                                                                                                    <span
                                                                                                                                        class="material-symbols-outlined"
                                                                                                                                        style="font-size:16px;">barcode_scanner</span>
                                                                                                                                    <span>Quét</span>
                                                                                                                                </button>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                        <button
                                                                                                                            type="submit"
                                                                                                                            class="btn btn-sm btn-primary-custom w-100 rounded-3 fw-bold">Xác
                                                                                                                            nhận
                                                                                                                            giao
                                                                                                                            sách</button>
                                                                                                                    </form>
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <div
                                                                                                                        class="text-danger small py-3 text-center">
                                                                                                                        <span
                                                                                                                            class="material-symbols-outlined"
                                                                                                                            style="font-size:24px;vertical-align:middle;">block</span>
                                                                                                                        Tài
                                                                                                                        khoản
                                                                                                                        bị
                                                                                                                        khóa,
                                                                                                                        không
                                                                                                                        thể
                                                                                                                        giao
                                                                                                                        sách.
                                                                                                                    </div>
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </div>
                                                                                                    </div>

                                                                                                    <%-- Check-in Form
                                                                                                        --%>
                                                                                                        <div
                                                                                                            class="col-12 col-md-6">
                                                                                                            <div class="p-3 rounded-3"
                                                                                                                style="background-color:rgba(5,150,105,0.04);border:1px solid rgba(5,150,105,0.1);">
                                                                                                                <h5
                                                                                                                    class="fw-bold small mb-2 d-flex align-items-center gap-2 text-success">
                                                                                                                    <span
                                                                                                                        class="material-symbols-outlined"
                                                                                                                        style="font-size:18px;">assignment_return</span>
                                                                                                                    Nhận
                                                                                                                    trả
                                                                                                                    sách
                                                                                                                    (Check-in)
                                                                                                                </h5>
                                                                                                                <form
                                                                                                                    action="${pageContext.request.contextPath}/librarian/checkin"
                                                                                                                    method="POST"
                                                                                                                    class="needs-validation"
                                                                                                                    novalidate>
                                                                                                                    <input
                                                                                                                        type="hidden"
                                                                                                                        name="memberCode"
                                                                                                                        value="${fn:escapeXml(requestScope.memberCode)}">
                                                                                                                    <div
                                                                                                                        class="mb-2">
                                                                                                                        <label
                                                                                                                            for="checkinBarcode"
                                                                                                                            class="form-label small mb-1">Mã
                                                                                                                            vạch
                                                                                                                            bản
                                                                                                                            sao
                                                                                                                            (Barcode)</label>
                                                                                                                        <div
                                                                                                                            class="input-group input-group-sm">
                                                                                                                            <input
                                                                                                                                type="text"
                                                                                                                                id="checkinBarcode"
                                                                                                                                name="barcode"
                                                                                                                                class="form-control form-control-sm"
                                                                                                                                placeholder="Quét hoặc nhập barcode..."
                                                                                                                                required>
                                                                                                                            <button
                                                                                                                                type="button"
                                                                                                                                class="btn btn-outline-success d-flex align-items-center gap-1 btn-scan"
                                                                                                                                onclick="toggleScanner('checkinBarcode', this)">
                                                                                                                                <span
                                                                                                                                    class="material-symbols-outlined"
                                                                                                                                    style="font-size:16px;">barcode_scanner</span>
                                                                                                                                <span>Quét</span>
                                                                                                                            </button>
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                    <div
                                                                                                                        class="mb-3">
                                                                                                                        <label
                                                                                                                            for="checkinCondition"
                                                                                                                            class="form-label small mb-1">Tình
                                                                                                                            trạng
                                                                                                                            sách
                                                                                                                            trả</label>
                                                                                                                        <select
                                                                                                                            id="checkinCondition"
                                                                                                                            name="condition"
                                                                                                                            class="form-select form-select-sm"
                                                                                                                            required>
                                                                                                                            <option
                                                                                                                                value="good">
                                                                                                                                Tốt
                                                                                                                                (Có
                                                                                                                                hàng
                                                                                                                                chờ
                                                                                                                                tự
                                                                                                                                động
                                                                                                                                đẩy)
                                                                                                                            </option>
                                                                                                                            <option
                                                                                                                                value="damaged">
                                                                                                                                Hỏng
                                                                                                                                (Tự
                                                                                                                                động
                                                                                                                                phạt
                                                                                                                                &
                                                                                                                                khóa)
                                                                                                                            </option>
                                                                                                                            <option
                                                                                                                                value="lost">
                                                                                                                                Mất
                                                                                                                                (Tự
                                                                                                                                động
                                                                                                                                phạt
                                                                                                                                &
                                                                                                                                khóa)
                                                                                                                            </option>
                                                                                                                        </select>
                                                                                                                    </div>
                                                                                                                    <button
                                                                                                                        type="submit"
                                                                                                                        class="btn btn-sm btn-success w-100 rounded-3 fw-bold text-white"
                                                                                                                        style="border:none;">Xác
                                                                                                                        nhận
                                                                                                                        nhận
                                                                                                                        sách</button>
                                                                                                                </form>
                                                                                                            </div>
                                                                                                        </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <%-- 3 LISTS SECTION --%>
                                                                                        <div class="col-12">
                                                                                            <div
                                                                                                class="raised-card p-4">
                                                                                                <h3 class="fw-bold mb-4"
                                                                                                    style="font-size:18px;color:var(--on-surface);">
                                                                                                    Dashboard Danh Sách Giao Dịch
                                                                                                </h3>

                                                                                                <div class="row g-4">

                                                                                                    <%-- LIST 1:
                                                                                                        Ready-pickup
                                                                                                        Reservations
                                                                                                        --%>
                                                                                                        <div
                                                                                                            class="col-12 col-xl-3 col-md-6">
                                                                                                            <div
                                                                                                                class="list-section-header">
                                                                                                                <span>1.
                                                                                                                    Đặt
                                                                                                                    trước
                                                                                                                    chờ
                                                                                                                    lấy</span>
                                                                                                                <span
                                                                                                                    class="badge bg-secondary rounded-pill">${fn:length(requestScope.readyReservations)}</span>
                                                                                                            </div>
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${empty requestScope.readyReservations}">
                                                                                                                    <p
                                                                                                                        class="text-on-surface-variant small text-center py-4">
                                                                                                                        Không
                                                                                                                        có
                                                                                                                        đơn
                                                                                                                        đặt
                                                                                                                        trước
                                                                                                                        chờ
                                                                                                                        nhận.
                                                                                                                    </p>
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <div
                                                                                                                        class="d-flex flex-column gap-2">
                                                                                                                        <c:forEach
                                                                                                                            var="res"
                                                                                                                            items="${requestScope.readyReservations}">
                                                                                                                            <div
                                                                                                                                class="p-3 border rounded-3 bg-light">
                                                                                                                                <div
                                                                                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                                                                                    <span
                                                                                                                                        class="fw-bold text-primary-custom small">Mã
                                                                                                                                        đơn:
                                                                                                                                        #${res.reservationId}</span>
                                                                                                                                    <span
                                                                                                                                        class="badge bg-warning text-dark"
                                                                                                                                        style="font-size:10px;">Chờ
                                                                                                                                        lấy</span>
                                                                                                                                </div>
                                                                                                                                <p
                                                                                                                                    class="mb-1 small">
                                                                                                                                    Mã
                                                                                                                                    đầu
                                                                                                                                    sách:
                                                                                                                                    <strong>${res.bookId}</strong>
                                                                                                                                </p>
                                                                                                                                <p class="mb-2 text-on-surface-variant"
                                                                                                                                    style="font-size:11px;">
                                                                                                                                    Hạn
                                                                                                                                    nhận
                                                                                                                                    sách:
                                                                                                                                    <strong>
                                                                                                                                        <fmt:formatDate
                                                                                                                                            value="${res.endDate}"
                                                                                                                                            pattern="dd/MM/yyyy" />
                                                                                                                                    </strong>
                                                                                                                                </p>
                                                                                                                                <c:if
                                                                                                                                    test="${requestScope.searchedUser.status == 'active'}">
                                                                                                                                    <button
                                                                                                                                        class="btn btn-xs btn-outline-primary w-100 py-1 fw-bold text-uppercase"
                                                                                                                                        style="font-size:10px;"
                                                                                                                                        onclick="fillCheckout('${copyBarcodeMap[res.bookCopyId]}')">
                                                                                                                                        Chọn
                                                                                                                                        giao
                                                                                                                                        sách
                                                                                                                                    </button>
                                                                                                                                </c:if>
                                                                                                                            </div>
                                                                                                                        </c:forEach>
                                                                                                                    </div>
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </div>

                                                                                                        <%-- LIST 2:
                                                                                                            Active
                                                                                                            Borrows --%>
                                                                                                            <div
                                                                                                                class="col-12 col-xl-3 col-md-6">
                                                                                                                <div
                                                                                                                    class="list-section-header">
                                                                                                                    <span>2.
                                                                                                                        Sách
                                                                                                                        đang
                                                                                                                        mượn</span>
                                                                                                                    <span
                                                                                                                        class="badge bg-secondary rounded-pill">${fn:length(requestScope.activeBorrows)}</span>
                                                                                                                </div>
                                                                                                                <c:choose>
                                                                                                                    <c:when
                                                                                                                        test="${empty requestScope.activeBorrows}">
                                                                                                                        <p
                                                                                                                            class="text-on-surface-variant small text-center py-4">
                                                                                                                            Độc
                                                                                                                            giả
                                                                                                                            hiện
                                                                                                                            không
                                                                                                                            mượn
                                                                                                                            sách
                                                                                                                            nào.
                                                                                                                        </p>
                                                                                                                    </c:when>
                                                                                                                    <c:otherwise>
                                                                                                                        <div
                                                                                                                            class="d-flex flex-column gap-2">
                                                                                                                            <c:forEach
                                                                                                                                var="borrow"
                                                                                                                                items="${requestScope.activeBorrows}">
                                                                                                                                <div
                                                                                                                                    class="p-3 border rounded-3 bg-light">
                                                                                                                                    <div
                                                                                                                                        class="d-flex justify-content-between align-items-start mb-2">
                                                                                                                                        <span
                                                                                                                                            class="fw-bold small">Mã
                                                                                                                                            mượn:
                                                                                                                                            #${borrow.borrowRecordId}</span>
                                                                                                                                        <span
                                                                                                                                            class="badge bg-info text-white"
                                                                                                                                            style="font-size:10px;">Đang
                                                                                                                                            mượn</span>
                                                                                                                                    </div>
                                                                                                                                    <p
                                                                                                                                        class="mb-1 small">
                                                                                                                                        Mã vạch bản sao (Barcode):
                                                                                                                                        <strong>${copyBarcodeMap[borrow.bookCopyId]}</strong>
                                                                                                                                    </p>
                                                                                                                                    <p class="mb-2 text-on-surface-variant"
                                                                                                                                        style="font-size:11px;">
                                                                                                                                        Hạn
                                                                                                                                        trả:
                                                                                                                                        <strong>
                                                                                                                                            <fmt:formatDate
                                                                                                                                                value="${borrow.endDate}"
                                                                                                                                                pattern="dd/MM/yyyy" />
                                                                                                                                        </strong>
                                                                                                                                    </p>
                                                                                                                                    <button
                                                                                                                                        class="btn btn-xs btn-outline-success w-100 py-1 fw-bold text-uppercase"
                                                                                                                                        style="font-size:10px;"
                                                                                                                                        onclick="fillCheckin('${copyBarcodeMap[borrow.bookCopyId]}')">
                                                                                                                                        Chọn
                                                                                                                                        trả
                                                                                                                                        sách
                                                                                                                                    </button>
                                                                                                                                </div>
                                                                                                                            </c:forEach>
                                                                                                                        </div>
                                                                                                                    </c:otherwise>
                                                                                                                </c:choose>
                                                                                                            </div>

                                                                                                            <%-- LIST 3:
                                                                                                                Unpaid
                                                                                                                Fines
                                                                                                                --%>
                                                                                                                <div
                                                                                                                    class="col-12 col-xl-3 col-md-6">
                                                                                                                    <div
                                                                                                                        class="list-section-header">
                                                                                                                        <span>3.
                                                                                                                            Khoản
                                                                                                                            phạt
                                                                                                                            chưa
                                                                                                                            trả</span>
                                                                                                                        <span
                                                                                                                            class="badge bg-secondary rounded-pill">${fn:length(requestScope.unpaidFines)}</span>
                                                                                                                    </div>
                                                                                                                    <c:choose>
                                                                                                                        <c:when
                                                                                                                            test="${empty requestScope.unpaidFines}">
                                                                                                                            <p
                                                                                                                                class="text-on-surface-variant small text-center py-4">
                                                                                                                                Tuyệt
                                                                                                                                vời!
                                                                                                                                Không
                                                                                                                                có
                                                                                                                                khoản
                                                                                                                                nợ
                                                                                                                                phạt
                                                                                                                                nào.
                                                                                                                            </p>
                                                                                                                        </c:when>
                                                                                                                        <c:otherwise>
                                                                                                                            <div
                                                                                                                                class="d-flex flex-column gap-2">
                                                                                                                                <c:forEach
                                                                                                                                    var="fine"
                                                                                                                                    items="${requestScope.unpaidFines}">
                                                                                                                                    <div
                                                                                                                                        class="p-3 border rounded-3 bg-light">
                                                                                                                                        <div
                                                                                                                                            class="d-flex justify-content-between align-items-start mb-2">
                                                                                                                                            <span
                                                                                                                                                class="fw-bold text-danger small">Mã
                                                                                                                                                phạt:
                                                                                                                                                #${fine.fineId}</span>
                                                                                                                                            <span
                                                                                                                                                class="badge bg-danger"
                                                                                                                                                style="font-size:10px;">Chưa
                                                                                                                                                thanh
                                                                                                                                                toán</span>
                                                                                                                                        </div>
                                                                                                                                        <p
                                                                                                                                            class="mb-1 small">
                                                                                                                                            Số
                                                                                                                                            tiền:
                                                                                                                                            <strong
                                                                                                                                                class="text-danger">
                                                                                                                                                <fmt:formatNumber
                                                                                                                                                    value="${fine.amount}"
                                                                                                                                                    type="currency"
                                                                                                                                                    currencySymbol="đ" />
                                                                                                                                            </strong>
                                                                                                                                        </p>
                                                                                                                                        <p
                                                                                                                                            class="mb-2 small">
                                                                                                                                            Lý
                                                                                                                                            do:
                                                                                                                                            <em>
                                                                                                                                                <c:out
                                                                                                                                                    value="${fine.reason}" />
                                                                                                                                            </em>
                                                                                                                                        </p>
                                                                                                                                        <c:choose>
                                                                                                                                            <c:when
                                                                                                                                                test="${not empty fine.paymentId}">
                                                                                                                                                <form
                                                                                                                                                    action="${pageContext.request.contextPath}/librarian/cash-payment"
                                                                                                                                                    method="POST">
                                                                                                                                                    <input
                                                                                                                                                        type="hidden"
                                                                                                                                                        name="memberCode"
                                                                                                                                                        value="${fn:escapeXml(requestScope.memberCode)}">
                                                                                                                                                    <input
                                                                                                                                                        type="hidden"
                                                                                                                                                        name="paymentId"
                                                                                                                                                        value="${fine.paymentId}">
                                                                                                                                                    <input
                                                                                                                                                        type="hidden"
                                                                                                                                                        name="userId"
                                                                                                                                                        value="${fine.userId}">
                                                                                                                                                    <button
                                                                                                                                                        type="submit"
                                                                                                                                                        class="btn btn-xs btn-success w-100 py-1 fw-bold text-uppercase"
                                                                                                                                                        style="font-size:10px; border:none; background-color:#059669;">
                                                                                                                                                        Duyệt
                                                                                                                                                        thu
                                                                                                                                                        tiền
                                                                                                                                                        mặt
                                                                                                                                                        (#${fine.paymentId})
                                                                                                                                                    </button>
                                                                                                                                                </form>
                                                                                                                                            </c:when>
                                                                                                                                            <c:otherwise>
                                                                                                                                                <span
                                                                                                                                                    class="text-muted"
                                                                                                                                                    style="font-size:11px;">Chờ
                                                                                                                                                    tạo
                                                                                                                                                    hóa
                                                                                                                                                    đơn
                                                                                                                                                    (Hệ
                                                                                                                                                    thống
                                                                                                                                                    tự
                                                                                                                                                    tạo)</span>
                                                                                                                                            </c:otherwise>
                                                                                                                                        </c:choose>
                                                                                                                                    </div>
                                                                                                                                </c:forEach>
                                                                                                                            </div>
                                                                                                                        </c:otherwise>
                                                                                                                    </c:choose>
                                                                                                                </div>

                                                                                                                <%-- LIST 4: Paid Fines --%>
                                                                                                                <div class="col-12 col-xl-3 col-md-6">
                                                                                                                    <div class="list-section-header">
                                                                                                                        <span>4. Khoản phạt đã trả</span>
                                                                                                                        <span class="badge bg-secondary rounded-pill">${fn:length(requestScope.paidFines)}</span>
                                                                                                                    </div>
                                                                                                                    <c:choose>
                                                                                                                        <c:when test="${empty requestScope.paidFines}">
                                                                                                                            <p class="text-on-surface-variant small text-center py-4">
                                                                                                                                Chưa có khoản phạt nào đã trả.
                                                                                                                            </p>
                                                                                                                        </c:when>
                                                                                                                        <c:otherwise>
                                                                                                                            <div class="d-flex flex-column gap-2">
                                                                                                                                <c:forEach var="fine" items="${requestScope.paidFines}">
                                                                                                                                    <div class="p-3 border rounded-3 bg-light">
                                                                                                                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                                                                                                                            <span class="fw-bold text-success small">Mã phạt: #${fine.fineId}</span>
                                                                                                                                            <span class="badge bg-success" style="font-size:10px;">Đã thanh toán</span>
                                                                                                                                        </div>
                                                                                                                                        <p class="mb-1 small">
                                                                                                                                            Số tiền:
                                                                                                                                            <strong class="text-success">
                                                                                                                                                <fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" />
                                                                                                                                            </strong>
                                                                                                                                        </p>
                                                                                                                                        <p class="mb-2 small">
                                                                                                                                            Lý do: <em><c:out value="${fine.reason}" /></em>
                                                                                                                                        </p>
                                                                                                                                        <c:if test="${not empty fine.paymentId}">
                                                                                                                                            <p class="mb-0 text-muted" style="font-size:11px;">Mã TT: #${fine.paymentId}</p>
                                                                                                                                        </c:if>
                                                                                                                                    </div>
                                                                                                                                </c:forEach>
                                                                                                                            </div>
                                                                                                                        </c:otherwise>
                                                                                                                    </c:choose>
                                                                                                                </div>

                                                                                                </div>
                                                                                            </div>
                                                                                        </div>

                                                                        </div>
                                                                    </c:if>

                                        </div>
                                    </main>
                            </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // ════ QUẢN LÝ MÁY QUÉT BARCODE BẰNG ĐIỆN THOẠI ════
                                    let activeScanInputId = null;
                                    let activeScanButtonEl = null;
                                    let originalBtnHtml = '';

                                    function toggleScanner(inputId, buttonEl) {
                                        if (activeScanInputId === inputId) {
                                            resetScanner();
                                        } else {
                                            if (activeScanInputId) {
                                                resetScanner();
                                            }
                                            activeScanInputId = inputId;
                                            activeScanButtonEl = buttonEl;
                                            originalBtnHtml = buttonEl.innerHTML;

                                            buttonEl.classList.add('btn-scan-active');
                                            buttonEl.innerHTML = `
                        <span class="material-symbols-outlined rotating-icon" style="font-size:16px; vertical-align:middle;">sync</span>
                        <span>Đang quét...</span>
                    `;

                                            const inputEl = document.getElementById(inputId);
                                            if (inputEl) {
                                                inputEl.value = '';
                                                inputEl.focus();
                                            }
                                        }
                                    }

                                    function resetScanner() {
                                        if (activeScanButtonEl) {
                                            activeScanButtonEl.classList.remove('btn-scan-active');
                                            activeScanButtonEl.innerHTML = originalBtnHtml;
                                        }
                                        activeScanInputId = null;
                                        activeScanButtonEl = null;
                                        originalBtnHtml = '';
                                    }

                                    // Đăng ký sự kiện keydown toàn cục để bắt Enter và chặn submit
                                    document.addEventListener('keydown', function (e) {
                                        if (activeScanInputId) {
                                            const target = e.target;
                                            if (target && target.id === activeScanInputId) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    resetScanner();
                                                } else if (e.key === 'Escape') {
                                                    e.preventDefault();
                                                    resetScanner();
                                                }
                                            }
                                        }
                                    }, true); // Sử dụng capture để chặn sự kiện sớm nhất

                                    // JS helpers để tự điền nhanh barcode khi click hành động ở danh sách
                                    function fillCheckout(barcode) {
                                        const coInput = document.getElementById('checkoutBarcode');
                                        if (coInput) {
                                            coInput.value = barcode;
                                            coInput.focus();
                                        }
                                    }

                                    function fillCheckin(barcode) {
                                        const ciInput = document.getElementById('checkinBarcode');
                                        if (ciInput) {
                                            ciInput.value = barcode;
                                            ciInput.focus();
                                        }
                                    }
                                </script>
                    </body>

                    </html>
