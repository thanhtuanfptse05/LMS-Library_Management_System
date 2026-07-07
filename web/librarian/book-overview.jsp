<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty catalogSummary}">
    <c:redirect url="/book-management/overview" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />
                <div class="container-fluid px-4 py-4 bm-page bm-overview-page">
                    <section class="bm-overview-hero mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Quản lý sách</p>
                            <h2 class="bm-page__title mb-1">Tổng quan</h2>
                            <p class="bm-page__subtitle mb-0">
                                Theo dõi nhanh tình trạng danh mục, kho vật lý và các việc cần xử lý.
                            </p>
                        </div>
                        <c:if test="${actionCount > 0}">
                            <a class="bm-overview-hero__action" href="#overview-actions">
                                <span class="material-symbols-outlined">priority_high</span>
                                <span><fmt:formatNumber value="${actionCount}" /> việc cần chú ý</span>
                            </a>
                        </c:if>
                    </section>

                    <section class="row g-3 mb-4" aria-label="Chỉ số quản lý sách">
                        <div class="col-sm-6 col-xl-3">
                            <article class="raised-card bm-stat-card bm-overview-kpi bm-overview-kpi--catalog p-3">
                                <span class="bm-stat-card__icon material-symbols-outlined">menu_book</span>
                                <p class="bm-stat-card__label mt-3 mb-1">Tổng đầu sách</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${catalogSummary.totalBooks}" /></p>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <article class="raised-card bm-stat-card bm-overview-kpi bm-overview-kpi--copies p-3">
                                <span class="bm-stat-card__icon material-symbols-outlined">inventory_2</span>
                                <p class="bm-stat-card__label mt-3 mb-1">Tổng bản sao</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${copySummary.totalCopies}" /></p>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <article class="raised-card bm-stat-card bm-overview-kpi bm-overview-kpi--healthy p-3">
                                <span class="bm-stat-card__icon material-symbols-outlined">check_circle</span>
                                <p class="bm-stat-card__label mt-3 mb-1">Sẵn sàng</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${copySummary.availableCopies}" /></p>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <article class="raised-card bm-stat-card bm-overview-kpi ${actionCount > 0 ? 'bm-overview-kpi--attention' : 'bm-overview-kpi--healthy'} p-3">
                                <span class="bm-stat-card__icon material-symbols-outlined">warning</span>
                                <p class="bm-stat-card__label mt-3 mb-1">Cần xử lý</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${actionCount}" /></p>
                            </article>
                        </div>
                    </section>

                    <div class="row g-3 mb-4">
                        <section class="col-xl-8">
                            <div class="bm-table-card bm-table-card--primary bm-overview-stock h-100">
                                <div class="bm-table-card__header">
                                    <h3 class="bm-section-title mb-1">Tình trạng kho</h3>
                                    <p class="bm-section-note mb-0">
                                        Cập nhật lúc <fmt:formatDate value="${overviewGeneratedAt}" pattern="HH:mm dd/MM/yyyy" />.
                                    </p>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-lms">
                                        <thead>
                                            <tr>
                                                <th>Vị trí</th>
                                                <th>Tổng bản sao</th>
                                                <th>Sẵn sàng</th>
                                                <th>Cần kiểm tra</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty locationSummaries}">
                                                    <tr>
                                                        <td colspan="5">
                                                            <div class="bm-empty-state bm-empty-state--compact">
                                                                <span class="material-symbols-outlined">task_alt</span>
                                                                <strong>Kho đang ổn định</strong>
                                                                <p class="mb-0">Không có vị trí nào cần kiểm tra tại thời điểm này.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="location" items="${locationSummaries}">
                                                        <tr class="${location.issueCopies > 0 ? 'bm-overview-row--attention' : ''}">
                                                            <td><strong><c:out value="${location.location}" /></strong></td>
                                                            <td><fmt:formatNumber value="${location.totalCopies}" /></td>
                                                            <td><fmt:formatNumber value="${location.availableCopies}" /></td>
                                                            <td><fmt:formatNumber value="${location.issueCopies}" /></td>
                                                            <td><span class="bm-badge bm-badge--warning">Cần kiểm tra</span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </section>

                        <aside class="col-xl-4">
                            <div id="overview-actions" class="bm-side-card bm-overview-actions h-100">
                                <h3 class="bm-section-title mb-1">Việc cần xử lý</h3>
                                <p class="bm-section-note mb-0">Ưu tiên theo mức độ ảnh hưởng đến lưu thông và tồn kho.</p>

                                <c:choose>
                                    <c:when test="${empty tasks}">
                                        <div class="bm-empty-state bm-empty-state--compact mt-3">
                                            <span class="material-symbols-outlined">task_alt</span>
                                            <strong>Không có cảnh báo</strong>
                                            <p class="mb-0">Danh mục và kho sách hiện chưa có việc cần xử lý ngay.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="task" items="${tasks}">
                                            <div class="bm-alert-item bm-alert-item--${task.severity}">
                                                <span class="bm-alert-item__icon material-symbols-outlined"><c:out value="${task.icon}" /></span>
                                                <div>
                                                    <p class="bm-alert-item__title mb-1"><c:out value="${task.title}" /></p>
                                                    <p class="bm-alert-item__text mb-1"><c:out value="${task.description}" /></p>
                                                    <a class="bm-action-link" href="${pageContext.request.contextPath}${task.url}">
                                                        <c:out value="${task.actionLabel}" />
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </aside>
                    </div>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>
    </body>
</html>
