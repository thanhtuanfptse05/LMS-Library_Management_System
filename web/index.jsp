<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/_head.jsp" />
<body>

    <jsp:include page="common/_header.jsp" />

    <!-- Nội dung chính — spacer đã xử lý trong _header.jsp -->
    <main>
        <jsp:include page="common/_section-hero.jsp" />

        <!-- Khối AI Gợi Ý Sách Cá Nhân Hóa (Render by AJAX từ RecommendationServlet) -->
        <section class="container-xl py-5">
            <div class="d-flex align-items-center gap-2 mb-4">
                <i id="recommendation-section-icon" class="bi bi-stars text-warning fs-4"></i>
                <h2 id="recommendation-section-title" class="fw-bold m-0" style="color: var(--bs-body-color);">Gợi ý tài liệu cho bạn</h2>
            </div>
            <div id="ai-recommendation-container" data-context="${pageContext.request.contextPath}"></div>
        </section>

        <jsp:include page="common/_section-quicklinks.jsp" />
        <jsp:include page="common/_section-news.jsp" />
    </main>

    <jsp:include page="common/_footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/recommendation.js"></script>

</body>
</html>
