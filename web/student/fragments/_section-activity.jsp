<%-- Fragment: _section-activity.jsp — Recent Activity table (borrow history) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- ── Recent Activity Table ── -->
<section class="mb-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fs-4 fw-bold mb-0 text-dark">Hoạt động gần đây</h2>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/student/borrow-history"
               class="btn btn-light bg-surface-container border-0 p-2 d-flex align-items-center justify-content-center text-decoration-none"
               style="border-radius: 0.5rem;"
               title="Xem tất cả sách mượn">
                <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 20px;">open_in_new</span>
            </a>
        </div>
    </div>

    <div class="raised-card overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 text-start" id="recentActivityTable">
                <thead class="bg-surface-container-low" style="border-bottom: 1px solid var(--outline-variant);">
                    <tr>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Sách Tiêu đề</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Tác giả</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Ngày mượn</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Hạn trả</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold text-center"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty recentLoans}">
                            <c:forEach var="loan" items="${recentLoans}" end="4">
                                <tr>
                                    <td class="px-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="overflow-hidden rounded flex-shrink-0"
                                                 style="width: 32px; height: 40px; background: var(--surface-container-high);">
                                                <c:choose>
                                                    <c:when test="${not empty loan.book.imagePath}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(loan.book.imagePath, 'http://') or fn:startsWith(loan.book.imagePath, 'https://')}">
                                                                <img alt="" class="w-100 h-100" style="object-fit: cover;" src="<c:out value='${loan.book.imagePath}'/>" onerror="this.onerror=null; this.style.display='none';" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img alt="" class="w-100 h-100" style="object-fit: cover;" src="${pageContext.request.contextPath}/book-images/<c:out value='${loan.book.imagePath}'/>" onerror="this.onerror=null; this.style.display='none';" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <span class="fw-normal text-dark small">
                                                <c:out value="${loan.book.title}"/>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-on-surface-variant small">
                                        <c:out value="${loan.book.author}"/>
                                    </td>
                                    <td class="px-4 py-3 text-on-surface-variant small">
                                        <fmt:formatDate value="${loan.startDate}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td class="px-4 py-3 text-on-surface-variant small">
                                        <fmt:formatDate value="${loan.endDate}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <c:choose>
                                            <c:when test="${loan.status eq 'returned'}">
                                                <span class="badge badge-returned text-uppercase px-3 py-1" style="font-size: 10px;">Đã trả</span>
                                            </c:when>
                                            <c:when test="${loan.status eq 'overdue'}">
                                                <span class="badge badge-overdue text-uppercase px-3 py-1" style="font-size: 10px;">Quá hạn</span>
                                            </c:when>
                                            <c:when test="${loan.status eq 'borrowed'}">
                                                <span class="badge badge-borrowed text-uppercase px-3 py-1" style="font-size: 10px;">Đang mượn</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pending text-uppercase px-3 py-1" style="font-size: 10px;">
                                                    <c:out value="${loan.status}"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Trạng thái rỗng: chưa có lịch sử mượn sách --%>
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <span class="material-symbols-outlined d-block mb-2"
                                          style="font-size: 40px; color: var(--outline);">menu_book</span>
                                    <p class="mb-0 text-on-surface-variant small">Bạn chưa có lịch sử mượn sách nào.</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <div class="p-3 bg-surface-container-low text-center"
             style="border-top: 1px solid var(--outline-variant);">
            <a href="${pageContext.request.contextPath}/student/borrow-history"
               class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                Xem toàn bộ lịch sử mượn sách
            </a>
        </div>
    </div>
</section>
