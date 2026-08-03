<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Trang: book-inventory-reconciliation.jsp - Nghiệp vụ Đối chiếu Tồn kho --%>
<%-- Cho phép Thủ thư quét mã vạch của các bản sao sách tại một khu vực vật lý --%>
<%-- để so sánh với dữ liệu hệ thống, phát hiện và xử lý sách bị mất hoặc xếp sai vị trí --%>

<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />

                <div class="container-fluid px-4 py-4 bm-page">
                    <%-- Hiển thị thông báo thành công từ Session --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <c:out value="${sessionScope.successMessage}"/>
                            <button class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>

                    <%-- Hiển thị thông báo lỗi từ Session --%>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <c:out value="${sessionScope.errorMessage}"/>
                            <button class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>

                    <%-- Tiêu đề trang và Nút tạo phiên kiểm kê --%>
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Kho vật lý</p>
                            <h2 class="bm-page__title mb-1">Đối chiếu tồn kho</h2>
                            <p class="bm-page__subtitle mb-0">Quét mã vạch theo khu vực, xác minh chênh lệch trước khi cập nhật kho.</p>
                        </div>
                        <c:if test="${canEdit}">
                            <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#createInventoryModal">
                                <span class="material-symbols-outlined">add</span>
                                Tạo phiên kiểm kê
                            </button>
                        </c:if>
                    </section>

                    <%-- Thống kê nhanh các phiên kiểm kê (Tổng phiên, Đang kiểm đếm, Chờ xác minh, Lệch chưa xử lý) --%>
                    <div class="bm-list-stats bm-list-stats--four mb-3">
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">fact_check</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Tổng phiên</p>
                                <p class="bm-stat-card__value mb-0">${summary.totalSessions}</p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--info">
                            <span class="material-symbols-outlined">barcode_scanner</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Đang kiểm đếm</p>
                                <p class="bm-stat-card__value mb-0">${summary.activeSessions}</p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--warning">
                            <span class="material-symbols-outlined">manage_search</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Chờ xác minh</p>
                                <p class="bm-stat-card__value mb-0">${summary.reviewingSessions}</p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--danger">
                            <span class="material-symbols-outlined">warning</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Lệch chưa xử lý</p>
                                <p class="bm-stat-card__value mb-0">${summary.unresolvedItems}</p>
                            </div>
                        </article>
                    </div>

                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: Xem chi tiết một phiên kiểm kê --%>
                        <c:when test="${not empty selectedSession}">
                            <%-- Thông tin chi tiết phiên và các nút chuyển đổi trạng thái --%>
                            <section class="bm-side-card mb-3 d-flex flex-wrap justify-content-between gap-3">
                                <div>
                                    <a class="bm-action-link" href="${pageContext.request.contextPath}/librarian/book-management/inventory">← Danh sách phiên</a>
                                    <h3 class="bm-section-title mt-2 mb-1">Phiên #${selectedSession.inventorySessionId} · <c:out value="${selectedSession.location}"/></h3>
                                    <p class="bm-section-note mb-0">
                                        <strong>Tình trạng sách:</strong>
                                        Kệ này quản lý ${locationSummary.managedCopies}
                                        · Đang mượn ${locationSummary.borrowedCopies}
                                        · Hỏng/đang xử lý ${locationSummary.issueCopies}
                                        · Dự kiến có trên kệ
                                        ${selectedSession.status == 'draft' ? locationSummary.expectedOnShelfCopies : selectedSession.expectedCount}
                                    </p>
                                    <c:choose>
                                        <c:when test="${selectedSession.status == 'draft'}">
                                            <p class="bm-section-note mb-0"><strong>Tiến độ kiểm kê:</strong> Danh sách cần quét sẽ được chốt khi bắt đầu kiểm đếm.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="bm-section-note mb-0">
                                                <strong>Tiến độ kiểm kê:</strong> Cần quét ${selectedSession.expectedCount}
                                                · Đã quét dự kiến ${selectedSession.scannedExpectedCount}
                                                · Bất thường ${selectedSession.unexpectedCount}
                                                · Còn lại ${selectedSession.expectedCount - selectedSession.scannedExpectedCount}
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="bm-actions">
                                    <%-- Trạng thái Nháp (Draft): Cho phép bắt đầu kiểm đếm --%>
                                    <c:if test="${canEdit and selectedSession.status == 'draft'}">
                                        <form method="post" class="d-inline">
                                            <input type="hidden" name="action" value="start">
                                            <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                            <button class="btn btn-primary-custom">Bắt đầu kiểm đếm</button>
                                        </form>
                                    </c:if>
                                    <%-- Trạng thái Đang đếm (Counting): Cho phép bấm Kết thúc quét để chuyển sang Chờ xác minh --%>
                                    <c:if test="${canEdit and selectedSession.status == 'counting'}">
                                        <form method="post" class="d-inline"
                                              onsubmit="return confirm('Còn ${selectedSession.expectedCount - selectedSession.scannedExpectedCount} bản sao dự kiến chưa quét. Nếu kết thúc, các bản sao này sẽ được ghi nhận là thiếu. Bạn có chắc chắn muốn tiếp tục?');">
                                            <input type="hidden" name="action" value="finish-counting">
                                            <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                            <button class="btn btn-primary-custom">Kết thúc quét</button>
                                        </form>
                                    </c:if>
                                    <%-- Trạng thái Chờ xác minh (Reviewing) & Lệch đã xử lý hết: Cho phép hoàn tất phiên --%>
                                    <c:if test="${canEdit and selectedSession.status == 'reviewing' and selectedSession.unresolvedCount == 0}">
                                        <form method="post" class="d-inline">
                                            <input type="hidden" name="action" value="complete">
                                            <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                            <button class="btn btn-primary-custom">Hoàn tất phiên</button>
                                        </form>
                                    </c:if>
                                    <%-- Cho phép hủy phiên nếu chưa hoàn thành hoặc chưa bị hủy trước đó --%>
                                    <c:if test="${canEdit and selectedSession.status != 'completed' and selectedSession.status != 'cancelled'}">
                                        <form method="post" class="d-inline">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                            <button class="btn bm-btn-secondary">Hủy phiên</button>
                                        </form>
                                    </c:if>
                                </div>
                            </section>

                            <%-- Ô quét mã vạch đầu vào: Chỉ hiển thị khi đang kiểm đếm --%>
                            <c:if test="${canEdit and selectedSession.status == 'counting'}">
                                <form class="bm-filter-card bm-list-filter mb-3" method="post">
                                    <input type="hidden" name="action" value="scan">
                                    <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                    <div class="row g-2">
                                        <div class="col-lg-10 bm-search">
                                            <span class="material-symbols-outlined">barcode_scanner</span>
                                            <input class="form-control" name="barcode" autofocus required placeholder="Quét hoặc nhập mã vạch">
                                        </div>
                                        <div class="col-lg-2">
                                            <button class="btn btn-primary-custom w-100 h-100">Ghi nhận</button>
                                        </div>
                                    </div>
                                </form>
                            </c:if>

                            <c:if test="${selectedSession.status == 'draft'}">
                                <section class="bm-side-card mb-3">
                                    <strong>Danh sách bản sao chưa được chốt</strong>
                                    <p class="bm-section-note mb-0 mt-1">Hệ thống sẽ tạo snapshot tồn kho tại thời điểm bấm “Bắt đầu kiểm đếm”.</p>
                                </section>
                            </c:if>

                            <%-- Bảng danh sách các bản sao và kết quả đối chiếu --%>
                            <c:if test="${selectedSession.status != 'draft'}">
                            <section class="bm-table-card bm-table-card--primary bm-data-table">
                                <div class="table-responsive">
                                    <table class="table table-lms">
                                        <thead>
                                            <tr>
                                                <th>Mã vạch / đầu sách</th>
                                                <th>Vị trí hệ thống</th>
                                                <th>Vị trí quét</th>
                                                <th>Kết quả</th>
                                                <th>Kết luận</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${items}">
                                                <tr>
                                                    <td>
                                                        <strong><c:out value="${item.barcode}"/></strong>
                                                        <div class="bm-book__meta">
                                                            <c:out value="${item.bookTitle}"/>
                                                        </div>
                                                    </td>
                                                    <td><c:out value="${empty item.expectedLocation ? 'Chưa đăng ký' : item.expectedLocation}"/></td>
                                                    <td><c:out value="${empty item.scannedLocation ? 'Chưa quét' : item.scannedLocation}"/></td>
                                                    <td>
                                                        <%-- Huy hiệu trạng thái kết quả đối chiếu (khớp, thiếu, sai vị trí, chưa quét) --%>
                                                        <c:choose>
                                                            <c:when test="${item.result=='matched'}">
                                                                <span class="bm-badge bm-badge--success">Khớp</span>
                                                            </c:when>
                                                            <c:when test="${item.result=='missing'}">
                                                                <span class="bm-badge bm-badge--danger">Thiếu</span>
                                                            </c:when>
                                                            <c:when test="${item.result=='misplaced'}">
                                                                <span class="bm-badge bm-badge--warning">Sai vị trí</span>
                                                            </c:when>
                                                            <c:when test="${item.result=='unexpected'}">
                                                                <c:choose>
                                                                    <c:when test="${item.anomalyType=='damaged_on_shelf'}">
                                                                        <span class="bm-badge bm-badge--danger">Sách hỏng trên kệ</span>
                                                                    </c:when>
                                                                    <c:when test="${item.anomalyType=='borrowed_on_shelf'}">
                                                                        <span class="bm-badge bm-badge--danger">Sách đang mượn trên kệ</span>
                                                                    </c:when>
                                                                    <c:when test="${item.anomalyType=='found_lost'}">
                                                                        <span class="bm-badge bm-badge--warning">Tìm thấy sách đã báo mất</span>
                                                                    </c:when>
                                                                    <c:when test="${item.anomalyType=='removed_copy_found'}">
                                                                        <span class="bm-badge bm-badge--danger">Tìm thấy sách đã thanh lý</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="bm-badge bm-badge--warning">Sách không khả dụng trên kệ</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:when test="${item.result=='excluded'}">
                                                                <span class="bm-badge bm-badge--neutral">Ngoài phạm vi</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="bm-badge bm-badge--neutral">Chưa quét</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${empty item.resolution ? 'Chưa xử lý' : item.resolution}"/></td>
                                                    <td>
                                                        <%-- Sai vị trí có hai cách xử lý: đưa về vị trí gốc hoặc chuyển vị trí đăng ký. --%>
                                                        <c:if test="${canEdit and selectedSession.status=='reviewing' and empty item.resolvedAt and item.result=='misplaced'}">
                                                            <form method="post" class="d-inline"
                                                                  onsubmit="return confirm('Xác nhận bản sao đã được đưa về vị trí đăng ký?');">
                                                                <input type="hidden" name="action" value="resolve-misplaced">
                                                                <input type="hidden" name="resolutionMode" value="return_to_expected">
                                                                <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                                                <input type="hidden" name="itemId" value="${item.inventoryItemId}">
                                                                <button class="btn btn-sm bm-btn-secondary">Đã đưa về vị trí gốc</button>
                                                            </form>
                                                            <form method="post" class="d-inline"
                                                                  onsubmit="return confirm('Thao tác này sẽ đổi vị trí đăng ký của bản sao sang nơi đang kiểm kê. Bạn có chắc chắn?');">
                                                                <input type="hidden" name="action" value="resolve-misplaced">
                                                                <input type="hidden" name="resolutionMode" value="relocate_to_scanned">
                                                                <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                                                <input type="hidden" name="itemId" value="${item.inventoryItemId}">
                                                                <button class="btn btn-sm bm-btn-secondary">Chuyển sang vị trí hiện tại</button>
                                                            </form>
                                                        </c:if>
                                                        <%-- Nút xử lý thiếu sách: Ghi nhận mất sách để hệ thống cập nhật trạng thái bản sao --%>
                                                        <c:if test="${canEdit and selectedSession.status=='reviewing' and empty item.resolvedAt and item.result=='missing'}">
                                                            <form method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="resolve-missing">
                                                                <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                                                <input type="hidden" name="itemId" value="${item.inventoryItemId}">
                                                                <button class="btn btn-sm bm-incident-button">Ghi nhận mất</button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${canEdit and selectedSession.status=='reviewing' and empty item.resolvedAt and item.result=='unexpected'}">
                                                            <form method="post" class="d-inline"
                                                                  onsubmit="return confirm('Xác nhận đã đưa bản sao khỏi kệ và chuyển sang quy trình nghiệp vụ phù hợp?');">
                                                                <input type="hidden" name="action" value="resolve-unexpected">
                                                                <input type="hidden" name="sessionId" value="${selectedSession.inventorySessionId}">
                                                                <input type="hidden" name="itemId" value="${item.inventoryItemId}">
                                                                <button class="btn btn-sm bm-incident-button">Xác nhận đã chuyển xử lý</button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty items}">
                                                <tr>
                                                    <td colspan="6">
                                                        <div class="bm-empty-state">
                                                            <span class="material-symbols-outlined">inventory</span>
                                                            <strong>Không có bản sao trong phiên</strong>
                                                            <span>Khu vực này chưa có bản sao phù hợp.</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </section>
                            </c:if>
                        </c:when>

                        <%-- TRƯỜNG HỢP 2: Hiển thị danh sách toàn bộ các phiên kiểm kê --%>
                        <c:otherwise>
                            <section class="bm-table-card bm-table-card--primary bm-data-table">
                                <div class="table-responsive">
                                    <table class="table table-lms">
                                        <thead>
                                            <tr>
                                                <th>Phiên / khu vực</th>
                                                <th>Người tạo</th>
                                                <th>Bắt đầu</th>
                                                <th>Dự kiến</th>
                                                <th>Khớp</th>
                                                <th>Chênh lệch</th>
                                                <th>Trạng thái</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${sessions}">
                                                <tr>
                                                    <td>
                                                        <strong>#${item.inventorySessionId} · <c:out value="${item.location}"/></strong>
                                                    </td>
                                                    <td><c:out value="${item.createdByName}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty item.startedAt}">Chưa bắt đầu</c:when>
                                                            <c:otherwise><fmt:formatDate value="${item.startedAt}" pattern="dd/MM/yyyy HH:mm"/></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${item.expectedCount}</td>
                                                    <td>${item.matchedCount}</td>
                                                    <td>${item.discrepancyCount}</td>
                                                    <td>
                                                        <%-- Huy hiệu trạng thái phiên kiểm kê --%>
                                                        <c:choose>
                                                            <c:when test="${item.status=='completed'}">
                                                                <span class="bm-badge bm-badge--success">Đã hoàn tất</span>
                                                            </c:when>
                                                            <c:when test="${item.status=='reviewing'}">
                                                                <span class="bm-badge bm-badge--warning">Chờ xác minh</span>
                                                            </c:when>
                                                            <c:when test="${item.status=='counting'}">
                                                                <span class="bm-badge bm-badge--info">Đang kiểm đếm</span>
                                                            </c:when>
                                                            <c:when test="${item.status=='cancelled'}">
                                                                <span class="bm-badge bm-badge--neutral">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="bm-badge bm-badge--neutral">Bản nháp</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a class="btn btn-sm bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/inventory?sessionId=${item.inventorySessionId}">Chi tiết</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty sessions}">
                                                <tr>
                                                    <td colspan="8">
                                                        <div class="bm-empty-state">
                                                            <span class="material-symbols-outlined">fact_check</span>
                                                            <strong>Chưa có phiên kiểm kê</strong>
                                                            <span>Tạo phiên đầu tiên để bắt đầu đối chiếu.</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>

        <%-- Modal tạo mới một phiên kiểm kê tồn kho --%>
        <c:if test="${canEdit}">
            <div class="modal fade bm-modal" id="createInventoryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/inventory">
                            <input type="hidden" name="action" value="create">
                            <div class="modal-header">
                                <h5 class="modal-title">Tạo phiên kiểm kê</h5>
                                <button class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Khu vực kiểm kê</label>
                                    <select class="form-select" name="location" required>
                                        <option value="">Chọn khu vực</option>
                                        <c:forEach var="location" items="${locations}">
                                            <option value="<c:out value="${location}"/>"><c:out value="${location}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="form-label">Ghi chú</label>
                                    <textarea class="form-control" name="note" maxlength="1000"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn bm-btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button class="btn btn-primary-custom">Tạo phiên</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
        <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260628-inventory-combobox"></script>
    </body>
</html>
