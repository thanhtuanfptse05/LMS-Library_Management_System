<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bm-book-drawer-templates" hidden>
    <c:forEach var="book" items="${books}">
        <c:set var="drawerCopies" value="${copiesByBookId[book.bookId]}" />
        <c:set var="borrowedCount" value="0" />
        <c:set var="reservedCount" value="0" />
        <c:set var="incidentCount" value="0" />
        <c:forEach var="copy" items="${drawerCopies}">
            <c:if test="${copy.status == 'borrowed'}"><c:set var="borrowedCount" value="${borrowedCount + 1}" /></c:if>
            <c:if test="${copy.status == 'reserved'}"><c:set var="reservedCount" value="${reservedCount + 1}" /></c:if>
            <c:if test="${copy.condition == 'damaged' or copy.condition == 'lost'}"><c:set var="incidentCount" value="${incidentCount + 1}" /></c:if>
        </c:forEach>
        <template id="bookDrawerTemplate-${book.bookId}">
            <div class="bm-drawer-book">
                <div class="bm-drawer-book__cover-wrap">
                    <c:choose>
                        <c:when test="${not empty book.imagePath}">
                            <c:choose>
                                <c:when test="${fn:startsWith(book.imagePath, 'http://') or fn:startsWith(book.imagePath, 'https://')}">
                                    <img class="bm-drawer-book__cover" src="${book.imagePath}" alt="Ảnh bìa đầu sách" loading="lazy">
                                </c:when>
                                <c:otherwise>
                                    <img class="bm-drawer-book__cover" src="${pageContext.request.contextPath}/book-images/${book.imagePath}" alt="Ảnh bìa đầu sách" loading="lazy">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span class="bm-drawer-book__cover bm-drawer-book__cover--empty material-symbols-outlined">menu_book</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="bm-drawer-book__main">
                    <p class="bm-page__eyebrow mb-1">Chi tiết đầu sách</p>
                    <h3 class="bm-drawer-book__title mb-1"><c:out value="${book.title}" /></h3>
                    <p class="bm-drawer-book__author mb-2"><c:out value="${empty book.author ? 'Chưa cập nhật tác giả' : book.author}" /></p>
                    <div class="bm-drawer-meta">
                        <span>ISBN: <strong><c:out value="${book.isbn}" /></strong></span>
                        <span><c:out value="${empty book.publisher ? 'Chưa cập nhật NXB' : book.publisher}" /><c:if test="${not empty book.publicationYear}">, <c:out value="${book.publicationYear}" /></c:if></span>
                    </div>
                    <div class="bm-detail-labels mt-3">
                        <c:forEach var="category" items="${book.categories}">
                            <span class="bm-tag"><c:out value="${category.name}" /></span>
                        </c:forEach>
                        <c:forEach var="tag" items="${book.tags}">
                            <span class="bm-tag bm-tag--secondary"><c:out value="${tag.name}" /></span>
                        </c:forEach>
                        <c:if test="${empty book.categories and empty book.tags}">
                            <span class="bm-empty-note">Chưa phân loại</span>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="bm-drawer-stats">
                <span>Tổng bản sao <strong><fmt:formatNumber value="${book.totalQuantity}" /></strong></span>
                <span>Sẵn sàng <strong><fmt:formatNumber value="${book.availableQuantity}" /></strong></span>
                <span>Đang mượn <strong><fmt:formatNumber value="${borrowedCount}" /></strong></span>
                <span>Đặt trước <strong><fmt:formatNumber value="${reservedCount}" /></strong></span>
                <span>Hỏng/mất <strong><fmt:formatNumber value="${incidentCount}" /></strong></span>
            </div>

            <div class="bm-drawer-actions">
                <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/copies?q=${book.isbn}">
                    <span class="material-symbols-outlined" aria-hidden="true">inventory_2</span>
                    Mở kho vật lý
                </a>
                <c:if test="${canEdit}">
                    <a class="btn btn-primary-custom" href="${pageContext.request.contextPath}/book-management/copies">
                        <span class="material-symbols-outlined" aria-hidden="true">add</span>
                        Thêm bản sao
                    </a>
                </c:if>
            </div>

            <section class="bm-drawer-section">
                <div class="bm-drawer-section__header">
                    <h4>Bản sao vật lý</h4>
                    <span><fmt:formatNumber value="${fn:length(drawerCopies)}" /> bản sao</span>
                </div>
                <div class="bm-drawer-copy-list">
                    <c:forEach var="copy" items="${drawerCopies}">
                        <article class="bm-drawer-copy">
                            <div>
                                <strong><c:out value="${copy.barcode}" /></strong>
                                <small><c:out value="${empty copy.location ? 'Chưa cập nhật vị trí' : copy.location}" /></small>
                            </div>
                            <div class="bm-drawer-copy__badges">
                                <c:choose>
                                    <c:when test="${copy.condition == 'good'}"><span class="bm-badge bm-badge--success">Tốt</span></c:when>
                                    <c:when test="${copy.condition == 'damaged'}"><span class="bm-badge bm-badge--danger">Hỏng</span></c:when>
                                    <c:otherwise><span class="bm-badge bm-badge--danger">Mất</span></c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${copy.status == 'available'}"><span class="bm-badge bm-badge--success">Sẵn sàng</span></c:when>
                                    <c:when test="${copy.status == 'borrowed'}"><span class="bm-badge bm-badge--info">Đang mượn</span></c:when>
                                    <c:when test="${copy.status == 'reserved'}"><span class="bm-badge bm-badge--warning">Đặt trước</span></c:when>
                                    <c:otherwise><span class="bm-badge bm-badge--neutral">Ngừng lưu thông</span></c:otherwise>
                                </c:choose>
                            </div>
                        </article>
                    </c:forEach>
                    <c:if test="${empty drawerCopies}">
                        <div class="bm-empty-state bm-empty-state--compact">
                            <span class="material-symbols-outlined">inventory_2</span>
                            <strong>Chưa có bản sao</strong>
                            <span>Đầu sách này chưa được nhập vào kho vật lý.</span>
                        </div>
                    </c:if>
                </div>
            </section>
        </template>
    </c:forEach>
</div>

<div class="bm-drawer-backdrop" data-book-drawer-close hidden></div>
<aside class="bm-book-drawer" aria-hidden="true" aria-labelledby="bookDrawerTitle">
    <div class="bm-book-drawer__header">
        <div>
            <p class="bm-page__eyebrow mb-1">Xem nhanh</p>
            <h2 id="bookDrawerTitle">Chi tiết đầu sách</h2>
        </div>
        <button class="bm-drawer-close" type="button" data-book-drawer-close aria-label="Đóng">
            <span class="material-symbols-outlined" aria-hidden="true">close</span>
        </button>
    </div>
    <div class="bm-book-drawer__body" data-book-drawer-content></div>
</aside>
