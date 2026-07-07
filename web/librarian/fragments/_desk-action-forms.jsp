<%-- Fragment: _desk-action-forms.jsp — 4 form thao tác nghiệp vụ tại quầy (Checkout, Checkin, Reserve, Payment) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-12 mt-4">
    <div class="raised-card p-4">
        <h4 class="fw-bold mb-4" style="font-size:16px;color:var(--on-surface);">Thao tác nghiệp vụ tại quầy</h4>

        <%-- 4 Action Buttons --%>
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <button onclick="showActionForm('checkout')"
                        class="btn btn-primary-custom w-100 py-3 d-flex align-items-center justify-content-center gap-2 fw-bold">
                    <span class="material-symbols-outlined">published_with_changes</span>
                    Giao sách (Check-out)
                </button>
            </div>
            <div class="col-md-3">
                <button onclick="showActionForm('checkin')"
                        class="btn btn-success w-100 py-3 d-flex align-items-center justify-content-center gap-2 fw-bold text-white"
                        style="border:none; background-color:#059669;">
                    <span class="material-symbols-outlined">assignment_return</span>
                    Nhận trả sách (Check-in)
                </button>
            </div>
            <div class="col-md-3">
                <button onclick="showActionForm('reserve')"
                        class="btn btn-info w-100 py-3 d-flex align-items-center justify-content-center gap-2 fw-bold text-white"
                        style="border:none; background-color:#0284c7;">
                    <span class="material-symbols-outlined">pending_actions</span>
                    Đặt trước sách (Reserve)
                </button>
            </div>
            <div class="col-md-3">
                <button onclick="showActionForm('payment')"
                        class="btn btn-warning w-100 py-3 d-flex align-items-center justify-content-center gap-2 fw-bold text-dark">
                    <span class="material-symbols-outlined">payments</span>
                    Thu tiền phạt (Cash Payment)
                </button>
            </div>
        </div>

        <%-- Form 4: Reserve --%>
        <div id="actionFormReserve" class="p-4 rounded-4 mb-4"
             style="display:none; background-color:rgba(2,132,199,0.04); border:1px solid rgba(2,132,199,0.15);">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0 d-flex align-items-center gap-2 text-info" style="font-size:16px; color:#0284c7 !important;">
                    <span class="material-symbols-outlined">pending_actions</span>
                    Đặt trước sách (Reserve)
                </h5>
                <button type="button" class="btn-close" onclick="hideActionForm('reserve')"></button>
            </div>
            <c:choose>
                <c:when test="${requestScope.searchedUser.status == 'active'}">
                    <form action="${pageContext.request.contextPath}/librarian/reserve" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="memberCode" value="${fn:escapeXml(requestScope.memberCode)}">
                        <div class="mb-3 col-md-6">
                            <label for="reserveBookIdOrIsbn" class="form-label small fw-bold">Mã đầu sách (Book ID), ISBN hoặc Mã vạch (Barcode)</label>
                            <div class="input-group">
                                <input type="text" id="reserveBookIdOrIsbn" name="bookIdOrIsbn" class="form-control"
                                       placeholder="Nhập ID sách, ISBN hoặc quét barcode..." required>
                                <button type="button" class="btn btn-outline-primary d-flex align-items-center gap-1 btn-scan"
                                        onclick="toggleScanner('reserveBookIdOrIsbn', this)">
                                    <span class="material-symbols-outlined" style="font-size:18px;">barcode_scanner</span>
                                    <span>Quét</span>
                                </button>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-info px-4 fw-bold text-white" style="border:none; background-color:#0284c7;">Xác nhận đặt trước</button>
                            <button type="button" class="btn btn-outline-secondary px-4" onclick="hideActionForm('reserve')">Hủy</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger mb-0">
                        <span class="material-symbols-outlined align-middle me-2">block</span>
                        Tài khoản độc giả đang bị khóa. Không thể thực hiện đặt trước.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- Form 1: Checkout --%>
        <div id="actionFormCheckout" class="p-4 rounded-4 mb-4"
             style="display:none; background-color:rgba(157,67,0,0.04); border:1px solid rgba(157,67,0,0.15);">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0 d-flex align-items-center gap-2 text-primary-custom" style="font-size:16px;">
                    <span class="material-symbols-outlined">published_with_changes</span>
                    Giao sách (Check-out)
                </h5>
                <button type="button" class="btn-close" onclick="hideActionForm('checkout')"></button>
            </div>
            <c:choose>
                <c:when test="${requestScope.searchedUser.status == 'active'}">
                    <form action="${pageContext.request.contextPath}/librarian/checkout" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="memberCode" value="${fn:escapeXml(requestScope.memberCode)}">
                        <input type="hidden" id="checkoutTargetBookId" name="targetBookId" value="">
                        <div class="mb-3 col-md-6">
                            <label for="checkoutBarcode" class="form-label small fw-bold">Mã vạch bản sao (Barcode)</label>
                            <div class="input-group">
                                <input type="text" id="checkoutBarcode" name="barcode" class="form-control"
                                       placeholder="Quét hoặc nhập barcode..." required>
                                <button type="button" class="btn btn-outline-primary d-flex align-items-center gap-1 btn-scan"
                                        onclick="toggleScanner('checkoutBarcode', this)">
                                    <span class="material-symbols-outlined" style="font-size:18px;">barcode_scanner</span>
                                    <span>Quét</span>
                                </button>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary-custom px-4 fw-bold">Xác nhận giao sách</button>
                            <button type="button" class="btn btn-outline-secondary px-4" onclick="hideActionForm('checkout')">Hủy</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger mb-0">
                        <span class="material-symbols-outlined align-middle me-2">block</span>
                        Tài khoản độc giả đang bị khóa. Không thể thực hiện giao sách.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- Form 2: Checkin --%>
        <div id="actionFormCheckin" class="p-4 rounded-4 mb-4"
             style="display:none; background-color:rgba(5,150,105,0.04); border:1px solid rgba(5,150,105,0.15);">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0 d-flex align-items-center gap-2 text-success" style="font-size:16px;">
                    <span class="material-symbols-outlined">assignment_return</span>
                    Nhận trả sách (Check-in)
                </h5>
                <button type="button" class="btn-close" onclick="hideActionForm('checkin')"></button>
            </div>
            <form action="${pageContext.request.contextPath}/librarian/checkin" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="memberCode" value="${fn:escapeXml(requestScope.memberCode)}">
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label for="checkinBarcode" class="form-label small fw-bold">Mã vạch bản sao (Barcode)</label>
                        <div class="input-group">
                            <input type="text" id="checkinBarcode" name="barcode" class="form-control"
                                   placeholder="Quét hoặc nhập barcode..." required>
                            <button type="button" class="btn btn-outline-success d-flex align-items-center gap-1 btn-scan"
                                    onclick="toggleScanner('checkinBarcode', this)">
                                <span class="material-symbols-outlined" style="font-size:18px;">barcode_scanner</span>
                                <span>Quét</span>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="checkinCondition" class="form-label small fw-bold">Tình trạng sách trả</label>
                        <select id="checkinCondition" name="condition" class="form-select" required>
                            <option value="good">Tốt (Có hàng chờ tự động đẩy)</option>
                            <option value="damaged">Hỏng (Tự động phạt &amp; khóa)</option>
                            <option value="lost">Mất (Tự động phạt &amp; khóa)</option>
                        </select>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success px-4 fw-bold text-white"
                            style="border:none; background-color:#059669;">Xác nhận nhận trả sách</button>
                    <button type="button" class="btn btn-outline-secondary px-4" onclick="hideActionForm('checkin')">Hủy</button>
                </div>
            </form>
        </div>

        <%-- Form 3: Payment --%>
        <div id="actionFormPayment" class="p-4 rounded-4 mb-0"
             style="display:none; background-color:rgba(245,158,11,0.04); border:1px solid rgba(245,158,11,0.15);">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0 d-flex align-items-center gap-2 text-warning" style="font-size:16px; color:#d97706 !important;">
                    <span class="material-symbols-outlined">payments</span>
                    Thu tiền phạt (Cash Payment)
                </h5>
                <button type="button" class="btn-close" onclick="hideActionForm('payment')"></button>
            </div>
            <form action="${pageContext.request.contextPath}/librarian/cash-payment" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="memberCode" value="${fn:escapeXml(requestScope.memberCode)}">
                <input type="hidden" name="userId" value="${requestScope.searchedUser.userId}">
                <div class="mb-3 col-md-6">
                    <label for="paymentId" class="form-label small fw-bold">Chọn khoản phạt cần thu tiền mặt</label>
                    <select id="paymentId" name="paymentId" class="form-select" required>
                        <option value="">-- Chọn khoản phạt cần thu --</option>
                        <c:forEach var="fine" items="${requestScope.unpaidFines}">
                            <c:if test="${not empty fine.paymentId}">
                                <option value="${fine.paymentId}">
                                    Mã phạt: #${fine.fineId} - Số tiền: <fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" /> (${fine.reason})
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <div class="form-text text-muted">Chỉ hiển thị các khoản phạt đã có hóa đơn chờ thanh toán (có Mã hóa đơn).</div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning px-4 fw-bold text-dark">Duyệt thu tiền mặt</button>
                    <button type="button" class="btn btn-outline-secondary px-4" onclick="hideActionForm('payment')">Hủy</button>
                </div>
            </form>
        </div>

    </div>
</div>
