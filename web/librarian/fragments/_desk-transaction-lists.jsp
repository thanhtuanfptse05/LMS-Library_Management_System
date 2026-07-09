<%-- Fragment: _desk-transaction-lists.jsp — 4 danh sách giao dịch (Đặt trước chờ lấy, Đang mượn, Phạt chưa trả, Phạt đã trả) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-12">
    <div class="raised-card p-4">
        <h3 class="fw-bold mb-4" style="font-size:18px;color:var(--on-surface);">Dashboard Danh Sách Giao Dịch</h3>

        <div class="row g-4">

            <%-- LIST 1: Ready-pickup Reservations --%>
            <div class="col-12 col-xl-3 col-md-6">
                <div class="list-section-header">
                    <span>1. Đặt trước chờ lấy</span>
                    <span class="badge bg-secondary rounded-pill">${fn:length(requestScope.readyReservations)}</span>
                </div>
                <c:choose>
                    <c:when test="${empty requestScope.readyReservations}">
                        <p class="text-on-surface-variant small text-center py-4">Không có đơn đặt trước chờ nhận.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="res" items="${requestScope.readyReservations}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="fw-bold text-primary-custom small">Mã đơn: #${res.reservationId}</span>
                                        <span class="badge bg-warning text-dark" style="font-size:10px;">Chờ lấy</span>
                                    </div>
                                    <p class="mb-1 small">Mã đầu sách: <strong>${res.bookId}</strong></p>
                                    <p class="mb-1 small">Tên đầu sách: <strong><c:out value="${res.bookTitle}"/></strong></p>
                                    <p class="mb-2 text-on-surface-variant" style="font-size:11px;">
                                        Hạn nhận sách: <strong><fmt:formatDate value="${res.endDate}" pattern="dd/MM/yyyy" /></strong>
                                    </p>
                                    <c:if test="${requestScope.searchedUser.status == 'active'}">
                                        <button class="btn btn-xs btn-outline-primary w-100 py-1 fw-bold text-uppercase"
                                                style="font-size:10px;"
                                                onclick="fillCheckout('${copyBarcodeMap[res.bookCopyId]}', '${res.bookId}')">
                                            Chọn giao sách
                                        </button>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- LIST 2: Active Borrows --%>
            <div class="col-12 col-xl-3 col-md-6">
                <div class="list-section-header">
                    <span>2. Sách đang mượn</span>
                    <span class="badge bg-secondary rounded-pill">${fn:length(requestScope.activeBorrows)}</span>
                </div>
                <c:choose>
                    <c:when test="${empty requestScope.activeBorrows}">
                        <p class="text-on-surface-variant small text-center py-4">Độc giả hiện không mượn sách nào.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="borrow" items="${requestScope.activeBorrows}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="fw-bold small">Mã mượn: #${borrow.borrowRecordId}</span>
                                        <span class="badge bg-info text-white" style="font-size:10px;">Đang mượn</span>
                                    </div>
                                    <p class="mb-1 small">Mã đầu sách: <strong>${borrow.bookId}</strong></p>
                                    <p class="mb-1 small">Tên đầu sách: <strong><c:out value="${borrow.bookTitle}"/></strong></p>
                                    <p class="mb-1 small">Mã vạch bản sao (Barcode): <strong>${copyBarcodeMap[borrow.bookCopyId]}</strong></p>
                                    <p class="mb-2 text-on-surface-variant" style="font-size:11px;">
                                        Hạn trả: <strong><fmt:formatDate value="${borrow.endDate}" pattern="dd/MM/yyyy" /></strong>
                                    </p>
                                    <button class="btn btn-xs btn-outline-success w-100 py-1 fw-bold text-uppercase"
                                            style="font-size:10px;"
                                            onclick="fillCheckin('${copyBarcodeMap[borrow.bookCopyId]}')">
                                        Chọn trả sách
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- LIST 3: Unpaid Fines --%>
            <div class="col-12 col-xl-3 col-md-6">
                <div class="list-section-header">
                    <span>3. Khoản phạt chưa trả</span>
                    <span class="badge bg-secondary rounded-pill">${fn:length(requestScope.unpaidFines)}</span>
                </div>
                <c:choose>
                    <c:when test="${empty requestScope.unpaidFines}">
                        <p class="text-on-surface-variant small text-center py-4">Tuyệt vời! Không có khoản nợ phạt nào.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="fine" items="${requestScope.unpaidFines}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="fw-bold text-danger small">Mã phạt: #${fine.fineId}</span>
                                        <span class="badge bg-danger" style="font-size:10px;">Chưa thanh toán</span>
                                    </div>
                                    <p class="mb-1 small">Số tiền: <strong class="text-danger"><fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" /></strong></p>
                                    <p class="mb-2 small">Lý do: <em><c:out value="${fine.reason}" /></em></p>
                                    <c:choose>
                                        <c:when test="${not empty fine.paymentId}">
                                            <form action="${pageContext.request.contextPath}/librarian/cash-payment" method="POST">
                                                <input type="hidden" name="memberCode" value="${fn:escapeXml(requestScope.memberCode)}">
                                                <input type="hidden" name="paymentId" value="${fine.paymentId}">
                                                <input type="hidden" name="userId" value="${fine.userId}">
                                                <button type="submit" class="btn btn-xs btn-success w-100 py-1 fw-bold text-uppercase"
                                                        style="font-size:10px; border:none; background-color:#059669;">
                                                    Duyệt thu tiền mặt (#${fine.paymentId})
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted" style="font-size:11px;">Chờ tạo hóa đơn (Hệ thống tự tạo)</span>
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
                        <p class="text-on-surface-variant small text-center py-4">Chưa có khoản phạt nào đã trả.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="fine" items="${requestScope.paidFines}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="fw-bold text-success small">Mã phạt: #${fine.fineId}</span>
                                        <span class="badge bg-success" style="font-size:10px;">Đã thanh toán</span>
                                    </div>
                                    <p class="mb-1 small">Số tiền: <strong class="text-success"><fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" /></strong></p>
                                    <p class="mb-2 small">Lý do: <em><c:out value="${fine.reason}" /></em></p>
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
