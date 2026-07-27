<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />
                <div class="container-fluid px-4 py-4 bm-page bm-circulation-page">
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4 bm-circulation-hero">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Kho vật lý</p>
                            <h2 class="bm-page__title mb-1">Lịch sử lưu thông</h2>
                            <div class="bm-copy-heading">
                                <p class="bm-copy-heading__title mb-2">
                                    <span class="material-symbols-outlined" aria-hidden="true">menu_book</span>
                                    <span><c:out value="${copy.bookTitle}" /></span>
                                </p>
                                <p class="bm-copy-heading__meta mb-0">
                                    <span>Mã vạch <strong><c:out value="${copy.barcode}" /></strong></span>
                                    <span>ISBN <strong><c:out value="${copy.isbn}" /></strong></span>
                                </p>
                            </div>
                        </div>
                        <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/copies">
                            <span class="material-symbols-outlined">arrow_back</span>Quay lại bản sao
                        </a>
                    </section>

                    <div class="bm-list-stats bm-list-stats--four bm-circulation-stats mb-3">
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">qr_code_2</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Mã vạch</p>
                                <p class="bm-stat-card__value mb-0"><c:out value="${copy.barcode}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">location_on</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Vị trí</p>
                                <p class="bm-stat-card__value mb-0"><c:out value="${empty copy.location ? 'Chưa gán' : copy.location}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">history</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Lượt lưu thông</p>
                                <p class="bm-stat-card__value mb-0"><fmt:formatNumber value="${totalItems}" /></p>
                            </div>
                        </article>
                        <article class="bm-list-stat">
                            <span class="material-symbols-outlined">inventory_2</span>
                            <div>
                                <p class="bm-stat-card__label mb-1">Trạng thái bản sao</p>
                                <p class="bm-stat-card__value mb-0">
                                    <c:choose>
                                        <c:when test="${copy.status == 'available'}">Sẵn sàng</c:when>
                                        <c:when test="${copy.status == 'borrowed'}">Đang mượn</c:when>
                                        <c:otherwise>Ngừng lưu thông</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </article>
                    </div>

                    <section class="bm-table-card bm-table-card--primary bm-data-table">
                        <div class="bm-table-card__header">
                            <h3 class="bm-section-title mb-1">Các lần mượn/trả</h3>
                            <p class="bm-section-note mb-0">Danh sách chỉ dùng để tra cứu, không thay đổi dữ liệu lưu thông.</p>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms">
                                <thead>
                                    <tr>
                                        <th>Độc giả</th>
                                        <th>Ngày mượn</th>
                                        <th>Hạn trả</th>
                                        <th>Ngày trả</th>
                                        <th>Gia hạn</th>
                                        <th>Người xử lý</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${histories}">
                                        <tr>
                                            <td>
                                                <strong><c:out value="${item.memberName}" /></strong>
                                                <div class="bm-section-note"><c:out value="${item.memberCode}" /></div>
                                            </td>
                                            <td><fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td><fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty item.returnedAt}">Chưa trả</c:when>
                                                    <c:otherwise><fmt:formatDate value="${item.returnedAt}" pattern="dd/MM/yyyy HH:mm" /></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${item.extensionCount}</td>
                                            <td><c:out value="${item.createdByName}" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status == 'borrowed'}">
                                                        <span class="bm-badge bm-badge--info">Đang mượn</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'overdue'}">
                                                        <span class="bm-badge bm-badge--warning">Quá hạn</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'returned'}">
                                                        <span class="bm-badge bm-badge--success">Đã trả</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'damaged'}">
                                                        <span class="bm-badge bm-badge--danger">Hỏng</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'lost'}">
                                                        <span class="bm-badge bm-badge--danger">Mất</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bm-badge bm-badge--neutral"><c:out value="${item.status}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty histories}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="bm-empty-state">
                                                    <span class="material-symbols-outlined">history</span>
                                                    <strong>Chưa có lịch sử lưu thông</strong>
                                                    <span>Bản sao này chưa từng được ghi nhận mượn/trả trong hệ thống.</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <jsp:include page="fragments/_book-pagination.jsp">
                        <jsp:param name="label" value="Phân trang lịch sử lưu thông" />
                        <jsp:param name="inputId" value="bookCirculationHistoryPageJump" />
                    </jsp:include>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
                <script src="${pageContext.request.contextPath}/assets/js/book-management.js?v=20260620-1"></script>
            </main>
        </div>
    </body>
</html>
