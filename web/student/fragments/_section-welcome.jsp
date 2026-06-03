<%-- Fragment: _section-welcome.jsp — Welcome banner with CTA buttons --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<!-- ── Welcome Banner ── -->
<section class="position-relative overflow-hidden rounded-4 bg-primary-custom text-white p-5 mb-5"
         style="box-shadow: 0 8px 30px rgba(157, 67, 0, 0.25);">
    <div class="position-relative" style="max-width: 640px; z-index: 2;">
        <h1 class="fw-bold mb-2 fs-2">
            <fmt:message key="student.welcome" />,
            <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Student'}" />!
        </h1>
        <p class="opacity-90 mb-4" style="font-size: 18px;">
            <c:choose>
                <c:when test="${not empty activeLoansCount and activeLoansCount gt 0}">
                    <strong>
                        <fmt:message key="student.active_loans">
                            <fmt:param value="${activeLoansCount}" />
                        </fmt:message>
                    </strong>
                    <c:if test="${not empty dueSoonCount and dueSoonCount gt 0}">
                        <strong>
                            <fmt:message key="student.due_soon">
                                <fmt:param value="${dueSoonCount}" />
                            </fmt:message>
                        </strong>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <fmt:message key="student.learning_today" />
                </c:otherwise>
            </c:choose>
        </p>
        <div class="d-flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/book-search.jsp"
               class="btn btn-light rounded-pill px-4 fw-semibold btn-sm text-decoration-none"
               style="color: var(--primary);">
                <fmt:message key="nav.catalog" />
            </a>
            <a href="${pageContext.request.contextPath}/student/loans"
               class="btn btn-outline-light rounded-pill px-4 fw-semibold btn-sm text-decoration-none"
               style="border-color: rgba(255,255,255,0.4);">
                <fmt:message key="student.study_room" />
            </a>
        </div>
    </div>
    <!-- Decorative icon -->
    <div class="position-absolute end-0 top-0 h-100 d-flex align-items-center opacity-25 pointer-events-none"
         style="width: 33%; user-select: none;" aria-hidden="true">
        <span class="material-symbols-outlined"
              style="font-size: 200px; transform: translate(40px, -20px);">auto_stories</span>
    </div>
</section>
