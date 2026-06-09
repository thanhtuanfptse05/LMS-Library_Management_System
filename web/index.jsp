<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/_head.jsp" />
<body>

    <jsp:include page="common/_header.jsp" />

    <!-- Offset for the fixed-top header (approx 115px = top-row ~48px + bottom-row ~67px) -->
    <main style="padding-top: 115px;">
        <jsp:include page="common/_section-hero.jsp" />
        
        <!-- Khối AI Gợi Ý Sách Cá Nhân Hóa (Render by AJAX) -->
        <section class="container-xl py-5">
            <div class="d-flex align-items-center gap-2 mb-4">
                <i class="bi bi-stars text-warning fs-4"></i>
                <h2 class="fw-bold m-0" style="color: var(--bs-body-color);">Gợi ý tài liệu cho bạn</h2>
            </div>
            <div id="ai-recommendation-container"></div>
        </section>

        <jsp:include page="common/_section-quicklinks.jsp" />
        <jsp:include page="common/_section-news.jsp" />
    </main>

    <jsp:include page="common/_footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/recommendation.js"></script>

</body>
</html>
