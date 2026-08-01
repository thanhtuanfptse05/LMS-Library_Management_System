<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Trang: book-damaged-lost.jsp - Quản lý sự cố Hỏng & Mất sách --%>
<%-- Cho phép Thủ thư ghi nhận và xử lý các sự cố liên quan đến bản sao sách --%>
<%-- (bao gồm tạm ngừng lưu thông, cập nhật bồi thường, khôi phục hoặc báo mất) --%>

<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />
                <div class="container-fluid px-4 py-4 bm-page">
                    <%-- Thông báo kết quả thao tác --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <c:out value="${sessionScope.successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <c:out value="${sessionScope.errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <%-- Tiêu đề trang và Nút ghi nhận sự cố mới --%>
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Kho vật lý</p>
                            <h2 class="bm-page__title mb-1">Hỏng &amp; mất</h2>
                            <p class="bm-page__subtitle mb-0">Xác minh và xử lý các bản sao không còn đủ điều kiện lưu thông.</p>
                        </div>
                        <c:if test="${canEdit}">
                            <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#reportModal">
                                <span class="material-symbols-outlined">add</span>Ghi nhận sự cố
                            </button>
                        </c:if>
                    </section>

                    <%-- Bộ lọc tìm kiếm danh sách sự cố --%>
                    <form class="bm-filter-card bm-list-filter mb-3" method="get" action="${pageContext.request.contextPath}/librarian/book-management/incidents">
                        <div class="row g-2">
                            <div class="col-xl-5 col-lg-6 bm-search">
                                <span class="material-symbols-outlined">search</span>
                                <input class="form-control" name="q" value="<c:out value="${q}" />" placeholder="Tìm mã vạch hoặc đầu sách">
                            </div>
                            <div class="col-xl-3 col-md-4">
                                <select class="form-select" name="type">
                                    <option value="">Tất cả loại sự cố</option>
                                    <option value="damaged" ${selectedType == 'damaged' ? 'selected' : ''}>Hỏng</option>
                                    <option value="lost" ${selectedType == 'lost' ? 'selected' : ''}>Mất</option>
                                </select>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <select class="form-select" name="status">
                                    <option value="">Mọi trạng thái</option>
                                    <option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>Chờ xác minh</option>
                                    <option value="investigating" ${selectedStatus == 'investigating' ? 'selected' : ''}>Đang xử lý</option>
                                    <option value="resolved" ${selectedStatus == 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                    <option value="rejected" ${selectedStatus == 'rejected' ? 'selected' : ''}>Báo sai</option>
                                </select>
                            </div>
                            <div class="col-xl-2 col-lg-6">
                                <div class="bm-filter-actions bm-filter-actions--compact">
                                    <button class="btn bm-filter-button ${not empty q or not empty selectedType or not empty selectedStatus ? 'bm-filter-button--active' : ''}" type="submit">
                                        <span class="material-symbols-outlined">filter_alt</span><span>Lọc</span>
                                        <c:if test="${not empty q or not empty selectedType or not empty selectedStatus}">
                                            <span class="bm-filter-badge">Đang áp dụng</span>
                                        </c:if>
                                    </button>
                                    <a class="btn bm-reset-button" href="${pageContext.request.contextPath}/librarian/book-management/incidents" title="Đặt lại bộ lọc">
                                        <span class="material-symbols-outlined">refresh</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>

                    <c:choose>
                        <c:when test="${selectedType == 'damaged'}"><c:set var="selectedTypeLabel" value="Hỏng" /></c:when>
                        <c:when test="${selectedType == 'lost'}"><c:set var="selectedTypeLabel" value="Mất" /></c:when>
                    </c:choose>
                    <c:choose>
                        <c:when test="${selectedStatus == 'pending'}"><c:set var="selectedStatusLabel" value="Chờ xác minh" /></c:when>
                        <c:when test="${selectedStatus == 'investigating'}"><c:set var="selectedStatusLabel" value="Đang xử lý" /></c:when>
                        <c:when test="${selectedStatus == 'resolved'}"><c:set var="selectedStatusLabel" value="Đã xử lý" /></c:when>
                        <c:when test="${selectedStatus == 'rejected'}"><c:set var="selectedStatusLabel" value="Báo sai" /></c:when>
                    </c:choose>
                    <c:if test="${not empty q or not empty selectedType or not empty selectedStatus}">
                        <div class="bm-active-filters mb-3" aria-label="Bộ lọc đang áp dụng">
                            <span class="bm-active-filters__label">Đang lọc:</span>
                            <c:if test="${not empty q}">
                                <span class="bm-active-filter-chip">Từ khóa: <strong><c:out value="${q}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedType}">
                                <span class="bm-active-filter-chip">Loại sự cố: <strong><c:out value="${selectedTypeLabel}" /></strong></span>
                            </c:if>
                            <c:if test="${not empty selectedStatus}">
                                <span class="bm-active-filter-chip">Trạng thái: <strong><c:out value="${selectedStatusLabel}" /></strong></span>
                            </c:if>
                            <a class="bm-active-filters__clear" href="${pageContext.request.contextPath}/librarian/book-management/incidents">Xóa bộ lọc</a>
                        </div>
                    </c:if>

                    <%-- Khối thống kê nhanh sự cố sách --%>
                    <div class="bm-list-stats mb-3">
                        <article class="bm-list-stat bm-list-stat--warning">
                            <span class="material-symbols-outlined">pending_actions</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Chờ xác minh</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.pendingCount}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--info">
                            <span class="material-symbols-outlined">manage_search</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Đang xử lý</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.investigatingCount}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat bm-list-stat--success">
                            <span class="material-symbols-outlined">task_alt</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Đã xử lý tháng này</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${summary.resolvedThisMonthCount}" /></p>
                            </div>
                        </article>
                    </div>

                    <div class="bm-rule-note mb-3"><strong>Quy tắc:</strong> Sự cố ghi nhận khi trả sách (có mã lượt mượn) sẽ chờ Thủ thư <strong>xác minh và kết luận tại đây</strong> — phạt đền bù và khóa tài khoản CHỈ áp dụng sau khi Kết luận. Sự cố báo thủ công không liên kết lượt mượn.</div>

                    <%-- Bảng danh sách các sự cố --%>
                    <section class="bm-table-card bm-table-card--primary bm-data-table bm-incident-table">
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead>
                                    <tr>
                                        <th>Bản sao</th>
                                        <th>Sự cố</th>
                                        <th>Lượt mượn</th>
                                        <th>Ghi nhận</th>
                                        <th>Người báo</th>
                                        <th>Trạng thái</th>
                                        <th>Hướng xử lý</th>
                                        <th class="bm-action-column bm-incident-action-column"><span class="visually-hidden">Thao tác</span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="incident" items="${incidents}">
                                        <tr>
                                            <td>
                                                <strong><c:out value="${incident.barcode}" /></strong>
                                                <div class="bm-book__meta"><c:out value="${incident.bookTitle}" /></div>
                                            </td>
                                            <td>
                                                <span class="bm-badge bm-badge--danger">${incident.incidentType == 'damaged' ? 'Hỏng' : 'Mất'}</span>
                                                <div class="bm-book__meta"><c:out value="${incident.description}" /></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty incident.borrowRecordId}">
                                                        <span class="bm-badge bm-badge--info" title="Sự cố ghi nhận từ luồng trả sách">
                                                            BR-<c:out value="${incident.borrowRecordId}" />
                                                        </span>
                                                        <div class="bm-book__meta" style="font-size:0.78rem">Từ check-in</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted" style="font-size:0.85rem">Thủ công</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${incident.reportedAt}" pattern="dd/MM/yyyy" /></td>
                                            <td><c:out value="${incident.reportedByName}" /></td>
                                            <td>
                                                <%-- Trạng thái xử lý sự cố --%>
                                                <c:choose>
                                                    <c:when test="${incident.status == 'pending'}">
                                                        <span class="bm-badge bm-badge--warning">Chờ xác minh</span>
                                                    </c:when>
                                                    <c:when test="${incident.status == 'investigating'}">
                                                        <span class="bm-badge bm-badge--info">Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${incident.status == 'resolved'}">
                                                        <span class="bm-badge bm-badge--success">
                                                            ${incident.removedFromInventory ? 'Đã loại khỏi kho' : 'Đã xử lý'}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bm-badge bm-badge--neutral">Báo sai</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:choose><c:when test="${empty incident.resolution}">Chưa có kết luận</c:when><c:otherwise><c:out value="${incident.resolution}" /></c:otherwise></c:choose></td>
                                            <td class="bm-incident-action-cell">
                                                <div class="bm-actions bm-incident-actions">
                                                    <%-- Trạng thái chờ: Cho phép Thủ thư bắt đầu xác minh sự cố --%>
                                                    <c:if test="${canEdit and incident.status == 'pending'}">
                                                        <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/incidents">
                                                            <input type="hidden" name="action" value="investigate">
                                                            <input type="hidden" name="incidentId" value="${incident.incidentId}">
                                                            <button class="btn btn-sm btn-primary-custom" type="submit">Bắt đầu xác minh</button>
                                                        </form>
                                                    </c:if>
                                                    <%-- Đối với sách đã xử lý hỏng (nhưng chưa hoàn tất khôi phục): Cho phép khôi phục lưu thông --%>
                                                    <c:if test="${canEdit and incident.status == 'resolved' and incident.incidentType == 'damaged' and not incident.removedFromInventory and not fn:contains(incident.resolution, 'Khôi phục lưu thông:')}">
                                                        <a class="btn btn-sm btn-primary-custom" href="${pageContext.request.contextPath}/librarian/book-management/incidents?incidentId=${incident.incidentId}">Xử lý sau kết luận</a>
                                                    </c:if>
                                                    <%-- Xem chi tiết hoặc Đưa ra kết luận xử lý bồi thường --%>
                                                    <a class="btn btn-sm bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/incidents?incidentId=${incident.incidentId}">
                                                        ${canEdit and (incident.status == 'pending' or incident.status == 'investigating') ? 'Kết luận' : 'Chi tiết'}
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty incidents}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="bm-empty-state">
                                                    <span class="material-symbols-outlined">verified</span>
                                                    <strong>Không có sự cố nào</strong>
                                                    <span>Tất cả bản sao đang ổn định hoặc bộ lọc không khớp kết quả.</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <%-- Phân trang danh sách sự cố --%>
                    <jsp:include page="fragments/_book-pagination.jsp">
                        <jsp:param name="label" value="Phân trang sự cố" />
                        <jsp:param name="inputId" value="bookIncidentPageJump" />
                    </jsp:include>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
                <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
            </main>
        </div>

        <%-- Include các file fragment modal báo cáo sự cố và chi tiết sự cố --%>
        <jsp:include page="fragments/_book-incident-report-modal.jsp" />
        <jsp:include page="fragments/_book-incident-detail-modal.jsp" />
    </body>
</html>
