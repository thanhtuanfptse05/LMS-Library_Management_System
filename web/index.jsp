<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/_head.jsp" />
<body>

    <jsp:include page="common/_header.jsp" />

    <!-- Offset for the fixed-top header (approx 115px = top-row ~48px + bottom-row ~67px) -->
    <main style="padding-top: 115px;">
        <jsp:include page="common/_section-hero.jsp" />
        <jsp:include page="common/_section-quicklinks.jsp" />
        <jsp:include page="common/_section-news.jsp" />
    </main>

    <jsp:include page="common/_footer.jsp" />

</body>
</html>
