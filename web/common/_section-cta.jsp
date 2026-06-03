<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- CTA Section -->
<section class="py-5 bg-dark text-white text-center">
    <div class="container-xl py-4">
        <h2 class="fw-bold display-5 mb-3">Ready to start your research?</h2>
        <p class="text-white-50 fs-5 max-width-custom mx-auto mb-4" style="max-width: 700px;">Our staff is ready
            to assist you in navigating our extensive databases and physical archives.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <a href="${dashboardUrl}"
                        class="btn bg-primary-container text-white px-5 py-3 rounded-pill fw-bold shadow-lg border-0 text-decoration-none d-inline-flex align-items-center">
                        Go to Dashboard
                    </a>
                    <a href="#contact" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold text-decoration-none d-inline-flex align-items-center">
                        Contact Support
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"
                        class="btn bg-primary-container text-white px-5 py-3 rounded-pill fw-bold shadow-lg border-0 text-decoration-none d-inline-flex align-items-center">
                        Plan Your Visit
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold text-decoration-none d-inline-flex align-items-center">
                        Chat with a Librarian
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>
