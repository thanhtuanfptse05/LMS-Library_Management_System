<%-- Fragment: _section-welcome.jsp — Welcome banner with CTA buttons --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ── Welcome Banner ── -->
<section class="welcome-banner mb-5">
    <div class="row align-items-center g-0">
        <div class="col-12 col-md-8" style="position: relative; z-index: 2;">
            <p class="text-on-surface-variant fw-semibold mb-1" style="font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase;">
                Thư viện Đại học LMS
            </p>
            <h1 class="fw-bold mb-2" style="font-size: 26px; color: var(--on-primary-container);">
                Chào mừng trở lại,
                <c:out value="${not empty sessionScope.email ? sessionScope.email : 'Sinh viên'}" />!
            </h1>
            <p class="mb-4" style="font-size: 16px; color: var(--on-secondary-fixed-variant);">
                <c:choose>
                    <c:when test="${not empty activeLoansCount and activeLoansCount gt 0}">
                        Bạn có <strong><c:out value="${activeLoansCount}" /></strong> sách đang mượn.
                        <c:if test="${not empty dueSoonCount and dueSoonCount gt 0}">
                            <strong><c:out value="${dueSoonCount}" /></strong> sách sắp đến hạn!
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        Hôm nay chúng ta học gì? Khám phá danh mục để tìm sách mới.
                    </c:otherwise>
                </c:choose>
            </p>
            <div class="d-flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/book-search"
                   class="btn btn-primary-custom rounded-pill px-5 fw-semibold btn-sm text-decoration-none"
                   style="padding-top: 10px; padding-bottom: 10px; font-size: 14px;">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px; vertical-align: middle;">search</span>
                    Tra cứu Mục lục
                </a>

            </div>
        </div>
        <div class="col-4 d-none d-md-flex justify-content-end align-items-center"
             style="position: relative; z-index: 2;">
            <span class="material-symbols-outlined" aria-hidden="true"
                  style="font-size: 120px; color: var(--on-primary-container); opacity: 0.2;
                         font-variation-settings: 'FILL' 1, 'wght' 600, 'GRAD' 0, 'opsz' 24;">
                auto_stories
            </span>
        </div>
    </div>
</section>
