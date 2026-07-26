<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${totalItems > 0}">
    <%-- Kích thước trang lấy từ hằng PAGE_SIZE của servlet (requestScope) để dòng tóm tắt
         luôn khớp với số dòng thật trong bảng. Tham số param chỉ còn để tương thích ngược. --%>
    <c:set var="pageSize" value="${not empty requestScope.pageSize ? requestScope.pageSize
                                   : (empty param.pageSize ? 10 : param.pageSize)}" />
    <c:set var="startItem" value="${(currentPage - 1) * pageSize + 1}" />
    <c:set var="endItem" value="${currentPage * pageSize}" />
    <c:if test="${endItem > totalItems}">
        <c:set var="endItem" value="${totalItems}" />
    </c:if>
    <c:set var="pageStart" value="${currentPage - 2}" />
    <c:set var="pageEnd" value="${currentPage + 2}" />
    <c:if test="${pageStart < 1}">
        <c:set var="pageEnd" value="${pageEnd + (1 - pageStart)}" />
        <c:set var="pageStart" value="1" />
    </c:if>
    <c:if test="${pageEnd > totalPages}">
        <c:set var="pageStart" value="${pageStart - (pageEnd - totalPages)}" />
        <c:set var="pageEnd" value="${totalPages}" />
    </c:if>
    <c:if test="${pageStart < 1}">
        <c:set var="pageStart" value="1" />
    </c:if>

    <nav class="bm-pagination" aria-label="${empty param.label ? 'Phân trang danh sách' : param.label}">
        <p class="bm-pagination__summary mb-0">
            Hiển thị <fmt:formatNumber value="${startItem}" />–<fmt:formatNumber value="${endItem}" />
            trên <fmt:formatNumber value="${totalItems}" /> kết quả
        </p>
        <div class="bm-pagination__controls">
            <a class="bm-page-link ${currentPage == 1 ? 'disabled' : ''}" href="#" data-page="${currentPage - 1}" aria-label="Trang trước">‹ Trước</a>
            <c:forEach var="pageNumber" begin="${pageStart}" end="${pageEnd}">
                <a class="bm-page-link ${pageNumber == currentPage ? 'active' : ''}" href="#" data-page="${pageNumber}" aria-label="Trang ${pageNumber}">${pageNumber}</a>
            </c:forEach>
            <a class="bm-page-link ${currentPage == totalPages ? 'disabled' : ''}" href="#" data-page="${currentPage + 1}" aria-label="Trang sau">Sau ›</a>
        </div>
        <form class="bm-page-jump" method="get" data-bm-page-jump>
            <label for="${param.inputId}" class="visually-hidden">Tới trang</label>
            <span>Tới trang</span>
            <input id="${param.inputId}" class="form-control" type="number" name="page" min="1" max="${totalPages}" value="${currentPage}" aria-label="Nhập số trang">
            <button class="btn bm-btn-secondary" type="submit">Đi</button>
        </form>
    </nav>
</c:if>
