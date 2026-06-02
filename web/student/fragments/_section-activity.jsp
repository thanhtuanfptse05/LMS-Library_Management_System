<%-- Fragment: _section-activity.jsp — Recent Activity table (borrow history) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- ── Recent Activity Table ── -->
<section class="mb-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fs-4 fw-bold mb-0 text-dark">Recent Activity</h2>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/student/loans"
               class="btn btn-light bg-surface-container border-0 p-2 d-flex align-items-center justify-content-center text-decoration-none"
               style="border-radius: 0.5rem;"
               title="View all loans">
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
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Book Title</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Author</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Date Borrowed</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Due Date</th>
                        <th class="px-4 py-3 text-on-surface-variant text-uppercase fw-semibold text-center"
                            style="font-size: 11px; letter-spacing: 0.06em; border-bottom: none;">Status</th>
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
                                                <img alt=""
                                                     class="w-100 h-100"
                                                     style="object-fit: cover;"
                                                     src="${not empty loan.book.coverImageUrl ? loan.book.coverImageUrl : ''}"
                                                     onerror="this.style.display='none'" />
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
                                                <span class="badge badge-returned text-uppercase px-3 py-1" style="font-size: 10px;">Returned</span>
                                            </c:when>
                                            <c:when test="${loan.status eq 'overdue'}">
                                                <span class="badge badge-overdue text-uppercase px-3 py-1" style="font-size: 10px;">Overdue</span>
                                            </c:when>
                                            <c:when test="${loan.status eq 'borrowed'}">
                                                <span class="badge badge-borrowed text-uppercase px-3 py-1" style="font-size: 10px;">Borrowed</span>
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
                            <!-- Static demo rows when no backend data -->
                            <tr>
                                <td class="px-4 py-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="overflow-hidden rounded flex-shrink-0" style="width: 32px; height: 40px; background: var(--surface-container-high);"></div>
                                        <span class="fw-normal text-dark small">Digital Minimalism</span>
                                    </div>
                                </td>
                                <td class="px-4 py-3 text-on-surface-variant small">Cal Newport</td>
                                <td class="px-4 py-3 text-on-surface-variant small">Sep 15, 2024</td>
                                <td class="px-4 py-3 text-on-surface-variant small">Sep 29, 2024</td>
                                <td class="px-4 py-3 text-center">
                                    <span class="badge badge-returned text-uppercase px-3 py-1" style="font-size: 10px;">Returned</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="px-4 py-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="overflow-hidden rounded flex-shrink-0" style="width: 32px; height: 40px; background: var(--surface-container-high);"></div>
                                        <span class="fw-normal text-dark small">The Lean Startup</span>
                                    </div>
                                </td>
                                <td class="px-4 py-3 text-on-surface-variant small">Eric Ries</td>
                                <td class="px-4 py-3 text-on-surface-variant small">Aug 28, 2024</td>
                                <td class="px-4 py-3 text-on-surface-variant small">Sep 11, 2024</td>
                                <td class="px-4 py-3 text-center">
                                    <span class="badge badge-returned text-uppercase px-3 py-1" style="font-size: 10px;">Returned</span>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <div class="p-3 bg-surface-container-low text-center"
             style="border-top: 1px solid var(--outline-variant);">
            <a href="${pageContext.request.contextPath}/student/loans"
               class="btn btn-link text-primary-custom text-decoration-none fw-semibold p-0 small">
                View Full Borrowing History
            </a>
        </div>
    </div>
</section>
